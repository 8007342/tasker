## Why

Farmers need to hand out the day's work and workers need to see it without reading much,
often with no signal. The first slice proves that core loop on a real phone, and gets it
online so every later slice ships by pushing `main`.

## What Changes

- Farmer view: create tasks, assign them to a worker, see how each is going.
- Worker view: lands directly on today's tasks; big start and done buttons.
- Task rules: must be at a place to start (GPS), can't start before, must start by,
  time limit once started, expiry (TTL).
- Farm map drawn with Flame, showing where today's work is.
- Installable PWA that opens and works with no connection.
- Deployment to tasker.tlatoani.net on every push to `main`.

- Sync through a Cloudflare D1 (SQLite) database, so phones work offline and catch up later.
- Admin and Worker buttons on the landing screen, and seeded demo tasks every day.

Not in this slice, each its own later change: Google sign-in (the two buttons stand in, and
the API is open until then), NFC tags, photos, recordings, sequences, recurring schedules,
editing the farm's map and people.

## Capabilities

### New Capabilities

- `task-assignment`: farmer creates, assigns and tracks tasks.
- `worker-day-list`: what a worker sees on landing and how they start and finish work.
- `task-rules`: when a task may start, and how it lapses.
- `farm-map`: the illustrated map of places and where work is.
- `offline-app`: the app installs, opens and keeps its data without a connection.
- `web-deployment`: pushing `main` publishes the site.
- `data-sync`: the shared database and how phones catch up with it.
- `demo-access`: the proof of concept's landing buttons and seeded tasks.

### Modified Capabilities

None.

## Impact

New Flutter web app, `wrangler.jsonc`, `package.json` and build scripts. One manual step
outside the repo: connecting the GitHub repository to Cloudflare Workers Builds.
