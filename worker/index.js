// Tasker's API: one sync call on top of the D1 (SQLite) database, plus the static app.
// The API is open until Google sign-in arrives. Do not put private data in it yet.

const SCHEMA =
  "CREATE TABLE IF NOT EXISTS records (kind TEXT NOT NULL, id TEXT NOT NULL, " +
  "updated_at INTEGER NOT NULL, deleted INTEGER NOT NULL DEFAULT 0, data TEXT NOT NULL, " +
  "PRIMARY KEY (kind, id))";

const UPSERT = `INSERT INTO records (kind, id, updated_at, deleted, data) VALUES (?, ?, ?, ?, ?)
  ON CONFLICT (kind, id) DO UPDATE SET
    updated_at = excluded.updated_at, deleted = excluded.deleted, data = excluded.data
  WHERE excluded.updated_at >= records.updated_at`;

const KINDS = new Set(["task", "place"]);
const MAX_BODY = 512 * 1024;
const MAX_CHANGES = 500;
const MAX_DATA = 8 * 1024;

// A flag, not a shared promise: a Worker may not await I/O started by another request.
// Two first requests may both create the table, which is harmless.
let schemaReady = false;

async function ensureSchema(db) {
  if (schemaReady) return;
  await db.exec(SCHEMA);
  schemaReady = true;
}

/** A change's row values, or null if it isn't valid. */
function rowFor(change) {
  if (!change || !KINDS.has(change.kind)) return null;
  if (typeof change.id !== "string" || !change.id || change.id.length > 64) return null;
  if (!Number.isSafeInteger(change.updatedAt) || change.updatedAt < 0) return null;
  if (typeof change.data !== "object" || change.data === null) return null;
  const data = JSON.stringify(change.data);
  if (data.length > MAX_DATA) return null;
  return [change.kind, change.id, change.updatedAt, change.deleted ? 1 : 0, data];
}

function json(body, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "content-type": "application/json", "cache-control": "no-store" },
  });
}

async function sync(request, env) {
  const text = await request.text();
  if (text.length > MAX_BODY) return json({ error: "too large" }, 413);
  let body;
  try {
    body = JSON.parse(text);
  } catch {
    return json({ error: "not json" }, 400);
  }
  const changes = Array.isArray(body?.changes) ? body.changes.slice(0, MAX_CHANGES) : [];
  await ensureSchema(env.DB);

  const rows = changes.map(rowFor).filter(Boolean);
  const upsert = env.DB.prepare(UPSERT);
  const select = env.DB.prepare("SELECT kind, id, updated_at, deleted, data FROM records");
  const results = await env.DB.batch([...rows.map((row) => upsert.bind(...row)), select]);

  return json({
    rejected: changes.length - rows.length,
    records: results.at(-1).results.map((row) => ({
      kind: row.kind,
      id: row.id,
      updatedAt: row.updated_at,
      deleted: row.deleted === 1,
      data: JSON.parse(row.data),
    })),
  });
}

export default {
  async fetch(request, env) {
    const { pathname } = new URL(request.url);
    if (pathname === "/api/sync") {
      if (request.method !== "POST") return json({ error: "use POST" }, 405);
      try {
        return await sync(request, env);
      } catch (error) {
        console.error("sync failed", error);
        return json({ error: "database unavailable" }, 503);
      }
    }
    if (pathname.startsWith("/api/")) return json({ error: "not found" }, 404);
    return env.ASSETS.fetch(request);
  },
};
