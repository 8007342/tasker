---
id: field-adoption/offline-status-not-error-open-health-stack
claim: >
  Google's offline guidance for community health worker apps says offline should not look like an
  error, a failure caused by no connection should read as offline, and sync state and last-updated
  time should appear next to the data they describe.
applies_to: [offline-sync, save-feedback, sync-status, supervisor-dashboards, conflict-avoidance, error-messages]
tags: [offline-first, sync, status-indicator, field-workers, design-guideline, local-first]
sources:
  - url: https://developers.google.com/open-health-stack/design/offline-sync-guideline
    kind: expert-secondary
    title: "Design Guidelines for Offline & Sync"
    authors: Google Open Health Stack
    venue: Google for Developers
    archived: "pending: unavailable, no archive made; read through search summaries only"
    retrieved: 2026-11-06
  - url: https://www.repository.cam.ac.uk/handle/1810/297581
    kind: peer-reviewed
    title: "Local-first software: you own your data, in spite of the cloud"
    authors: Kleppmann, M.; Wiggins, A.; van Hardenberg, P.; McGranaghan, M.
    year: 2019
    venue: Onward! 2019, 154-178
    archived: "pending: unavailable, no archive made; read through search summaries only"
    retrieved: 2026-11-06
  - url: https://caniuse.com/background-sync
    kind: tertiary
    title: "Background Sync API"
    authors: caniuse.com
    venue: caniuse.com
    archived: "pending: unavailable, no archive made; only a partial snippet was visible"
    retrieved: 2026-11-06
authority: secondary
strength: expert-opinion
since: 2026-11-06
last_verified: 2026-11-06
status: current
origin: project
---
# Show offline calmly, and show staleness next to the data

@trace spec:research-records

## Claim

For field workers, being offline is normal and should read as normal. Save and sync state belong beside
the work they describe, not in a settings screen or an alarm.

## Evidence

This is design guidance, not a measured study. I searched for field studies of sync confusion (including
ODK and CommCare) and found none, so the "did it save?" advice below is reasoned, not tested.

- Open Health Stack guideline, written for community health worker apps: show offline status where
  relevant; avoid making it look like an error; if a sync fails because of no connection, say offline;
  error messages only when action is urgent; show whether the latest info has synced on task lists; tell
  users how often they need to go online; offer manual sync for people who get signal only at home;
  keep reminders occasional; sync today's tasks before history.
- Kleppmann et al. (essay in a peer-reviewed venue) argue for the local copy as primary, with no waiting
  on a server. CRDTs merge without conflicts, but that is heavier machinery than this app needs.
- Conflict avoidance is my own inference: the spec records only `startedAt` and `doneAt` and derives
  state, and each task has one assignee. Treating those as first-write-wins facts leaves almost nothing
  to conflict over. Farmer edits to a started task are the remaining case.
- Background Sync: a Workbox issue and a 2026 guide say Chromium only, not Safari; one blog claims all
  browsers and contradicts them; the caniuse snippet was unclear. Treat it as not available everywhere.

## How it applies

- As per research:field-adoption/offline-status-not-error-open-health-stack, a done tap gives one
  immediate tick on the phone, with a second mark when the farmer's side has it. Never show a red error
  for no signal, and never ask the worker to resolve a conflict.
- Farmer's view shows "last heard from this phone at 07:40" per worker, so not-yet-synced is not read as
  not-done. Without this the supervisor will wrongly chase people.
- Sync whenever the app opens, on tap and when connection returns; do not rely on Background Sync.
- Offer one plain send-now button for when the worker reaches signal.
- No conflict screens, no sync settings, no percentages for a few small records.

## Provenance

- <https://developers.google.com/open-health-stack/design/offline-sync-guideline>
  archived: unavailable
  retrieved: 2026-11-06 (search summaries)
- <https://www.repository.cam.ac.uk/handle/1810/297581>
  archived: unavailable
  retrieved: 2026-11-06 (search summaries)
- <https://caniuse.com/background-sync>
  archived: unavailable
  retrieved: 2026-11-06 (partial snippet)
- <https://github.com/GoogleChrome/workbox/issues/2386> (search summary)

## See also

- `research:interaction/response-time-limits-nielsen-1993`
- `research:field-adoption/mandatory-photo-attendance-nmms-2023`
