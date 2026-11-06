# Tasker

A simple daily task list for farm crews. The boss assigns the work, each worker opens the app and
sees today's tasks, and it keeps working with no signal, catching up when back in range. Built at
the San Diego AgTech Hackathon 2026.

Live at https://tasker.tlatoani.net (once the Cloudflare connection below is made).

## How it works

- **App**: Flutter web as an installable PWA, with a Flame-drawn farm map (`lib/`).
- **Server**: a Cloudflare Worker with one sync call (`worker/index.js`) on a D1 (SQLite) database.
- **Offline**: changes save on the phone first and are sent when there's signal.

This is a proof of concept: Admin and Worker buttons stand in for Google sign-in, and until
sign-in exists anyone with the address can read and change tasks.

## Working on it

```bash
flutter test            # the tests
bash tool/build_web.sh  # build into build/web
bash tool/preview.sh    # copy into preview-site/ for a local preview, then: npx wrangler dev
```

## Deploying

Pushing `main` deploys, once the repository is connected to Cloudflare. That connection is made
once: Cloudflare dashboard, Workers & Pages, Create, Import a repository, `8007342/tasker`, with:

| Setting | Value |
|---|---|
| Project name | `tasker` |
| Build command | `npm run build` |
| Deploy command | `npx wrangler deploy` |
| Branch | `main` |

The address and database are declared in `wrangler.jsonc`; the first deploy creates them.
A failing test stops the deploy and leaves the live site as it was.

## How this project is organised

- `openspec/`: what the app should do. Change the specs first, then the code.
- `plan/`: work that takes more than one session.
- `research/`: what is known about how people use apps like this, with sources.
