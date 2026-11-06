## Context

New project. Flutter web + Flame, hosted on Cloudflare Workers, with D1 (SQLite) as the shared database.

## Goals / Non-Goals

**Goals:** the farmer-to-worker loop on one device, offline from the first release, simple
controllers, sync through D1, and a domain model that sign-in, NFC and photos can extend.

**Non-Goals:** real accounts, access control, editing people or the map.

## Decisions

**One ChangeNotifier store, pure rules.** `TaskStore` holds people, places and tasks and saves
them as JSON. Whether a task may start is a pure function of the task, the time and the fix
(`task_rules.dart`), so the rules are testable without widgets, and sync can reuse them.
Alternative (Bloc, Riverpod) rejected: the brief asks for controllers as simple as possible.

**A task's state is derived, never stored.** Only `startedAt` and `doneAt` are recorded. A
phone that sat offline shows the right state the moment it looks at the clock.

**Timing rule meanings.** Four separate rules, checked in this order:
1. Expiry (TTL): at `expiresAt` the task is `expired`, even if it had been started.
2. Time limit: counted from `startedAt`; running past it makes the task `overdue`, and the
   worker can still finish it (the work was done, it was just late).
3. Must start by (timeout): passing it unstarted makes the task `missed`.
4. Can't start before: until then the task is `waiting`.
TTL counts from the later of creation and the start of the assigned day, so a task planned for
next week doesn't expire before its day.

**Unfinished work carries over.** An earlier day's task stays on the list while it can still
be done. The farmer ends it by setting an expiry.

**Places are the shared anchor.** A `Place` has a position on the illustrated map, optional
GPS and a radius. The map tells a worker where to go without reading; GPS enforces it. NFC tags
will attach to places. The illustration is not geographically accurate, so GPS is saved by the
farmer standing at the place rather than by tapping the map.

**GPS is forgiving.** A worker may start when distance minus reported accuracy is within the
radius: a weak fix must not lock someone out of work while standing in the right field.

**Sync is one call.** `POST /api/sync` takes the phone's unsent changes and returns every record.
The server has one `records` table (kind, id, updated_at, deleted, data as JSON), created on first
use so a deploy needs no migration step. Every change is written on the phone first and queued in
an outbox saved beside the data; the store syncs every 5 s while the app is open. The newest `updatedAt` wins, using
the phones' clocks, which suits this app because workers only touch progress and the admin only
creates and deletes. Deletions are kept as tombstones. Returning everything won't scale forever
and is fine for one farm's proof of concept.

**Demo seed is idempotent.** Each phone seeds today's tasks with ids fixed per day and timestamp 0,
so phones agree on them and any real progress or deletion on the server wins.

**Own service worker.** The build disables Flutter's PWA strategy; `tool/gen_sw.mjs` writes
`sw.js` precaching the exact build output, with a version derived from file hashes. It caches
`./` rather than `index.html` because Cloudflare redirects the latter, and a redirected response
cannot answer a navigation. Offline also needs CanvasKit self-hosted (`--no-web-resources-cdn`)
and a bundled font, because by default both are fetched from Google at runtime.

**Deploy through Workers Builds.** Build `npm run build`, deploy `npx wrangler deploy`,
matching the account's other projects. The build fetches the Flutter version pinned in
`.flutter-version` and runs the tests, so a failing test stops the deploy. The custom domain is
declared in `wrangler.jsonc`. Alternative (GitHub Actions + API token) rejected: it adds a
long-lived secret for no gain.

## Risks / Trade-offs

- The API has no access control until Google sign-in → anyone with the URL can read and change
  tasks; keep demo data non-private, and don't add sign-in-dependent data before that change.
- Unsent changes live only on the phone → clearing browser data loses them; the app asks the
  browser for persistent storage.
- A wrong phone clock can win or lose a write → acceptable for a proof of concept.
- A cold Flutter fetch makes each deploy take minutes → acceptable; free allowance is 3,000
  build minutes a month.
- Illustrated farm is fixed demo data → map editing is a later change.

## Open Questions

- Sign-in for workers without Google accounts or who can't type a password.
- Web NFC reads only in Chrome on Android; iPhones can only open a URL from a tag.
