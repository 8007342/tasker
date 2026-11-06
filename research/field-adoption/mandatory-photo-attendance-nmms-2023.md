---
id: field-adoption/mandatory-photo-attendance-nmms-2023
claim: >
  When India's rural jobs programme made pay depend on geo-tagged photos uploaded from weak-signal
  worksites, workers and supervisors reported lost wages, phone debt and no way to correct errors,
  and protested for years.
applies_to: [photo-proof, gps-checks, offline-sync, pay-linked-records, error-correction, rural-field-apps]
tags: [mgnrega, nmms, photo-attendance, connectivity, redress, worker-protest]
sources:
  - url: https://slate.com/technology/2023/04/digital-india-mgnrega-protest.html
    kind: expert-secondary
    title: "Indian workers protest against a glitchy app-based attendance system"
    authors: Not shown in the search summary
    year: 2023
    venue: Slate
    archived: "pending: unavailable, no archive made; read through a search summary only"
    retrieved: 2026-11-06
  - url: https://thewire.in/tech/nrega-workers-nmms-app-protest
    kind: expert-secondary
    title: "Why NREGA Workers Are Protesting Against an App"
    authors: Not shown in the search summary
    venue: The Wire
    archived: "pending: unavailable, no archive made; read through a search summary only"
    retrieved: 2026-11-06
  - url: https://www.isignal.in/governance/flawed-mgnregs-attendance-app-impacts-workers-pay-in-worlds-largest-rural-jobs-programme-861930
    kind: expert-secondary
    title: "Flawed MGNREGS Attendance App Impacts Workers' Pay In World's Largest Rural Jobs Programme"
    authors: Not shown in the search summary
    venue: iSignal
    archived: "pending: unavailable, no archive made; read through a search summary only"
    retrieved: 2026-11-06
  - url: https://www.counterview.net/2025/08/nrega-sangharsh-morcha-demands-rollback.html
    kind: expert-secondary
    title: "NREGA Sangharsh Morcha demands rollback of NMMS App, restoration of workers' rights"
    authors: Not shown in the search summary
    year: 2025
    venue: Counterview
    archived: "pending: unavailable, no archive made; read through a search summary only"
    retrieved: 2026-11-06
authority: secondary
strength: expert-opinion
since: 2026-11-06
last_verified: 2026-11-06
status: current
origin: project
---
# Pay-linked photo proof on bad signal

@trace spec:research-records

## Claim

The closest large-scale precedent for photo and location proof of manual labour went badly for workers
where signal was weak, because a technical failure counted as not having worked.

## Evidence

This is journalism and campaign reporting, not a measured evaluation. I found no study with counts.

- From 1 January 2023 the NMMS app was mandatory: two geo-tagged photos a day, and no upload means no
  pay for that day. Worksite supervisors ("mates") capture attendance.
- Reported harms: payments stuck because there was no network to upload; marked absent on days worked;
  errors "almost impossible" to correct. The campaign group claims losses up to 50% of wages in some
  cases and women supervisors borrowing to buy smartphones. One worker reportedly borrowed about
  Rs 7,000 for a phone that could not run the app. These are claims, not audited figures.
- Activists also say it did not stop fake attendance, because photos of gathered people were not checked.
- The ministry's stated position was that issues are reviewed and resolved, and it reported no notice of
  an indefinite protest. So the account is disputed. The demand for rollback was still live in August
  2025; I could not confirm the app's current status.
- Important differences: a public wage scheme at national scale, with attendance tied to pay. Tasker is
  a single farm and tracks tasks. The transferable part is the failure pattern, not the politics.

## How it applies

- As per research:field-adoption/mandatory-photo-attendance-nmms-2023, no failed check, missing photo
  or unsent record may ever imply work was not done. Done tapped offline stays done.
- The supervisor must be able to correct any record on the spot, and the worker must be able to see the
  correction. Build this before any proof feature.
- Do not make photos mandatory. If photos come later, keep them worker-initiated, such as showing a
  problem to the farmer.
- The campaign demanded physical attendance slips. Let a worker show their own done list on their own phone.
- Don't let Tasker records become pay records without a separate decision; that raises the stakes of
  every sync failure.

## Provenance

- <https://slate.com/technology/2023/04/digital-india-mgnrega-protest.html>
  archived: unavailable
  retrieved: 2026-11-06 (search summary)
- <https://thewire.in/tech/nrega-workers-nmms-app-protest>
  archived: unavailable
  retrieved: 2026-11-06 (search summary)
- <https://www.isignal.in/governance/flawed-mgnregs-attendance-app-impacts-workers-pay-in-worlds-largest-rural-jobs-programme-861930>
  archived: unavailable
  retrieved: 2026-11-06 (search summary)
- <https://www.counterview.net/2025/08/nrega-sangharsh-morcha-demands-rollback.html>
  archived: unavailable
  retrieved: 2026-11-06 (search summary)

## See also

- `research:field-adoption/monitoring-needs-enforcement-duflo-dhaliwal`
- `research:field-adoption/offline-status-not-error-open-health-stack`
