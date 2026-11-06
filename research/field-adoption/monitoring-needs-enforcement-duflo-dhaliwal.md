---
id: field-adoption/monitoring-needs-enforcement-duflo-dhaliwal
claim: >
  Digital proof of presence changes behaviour mainly when someone acts on it: pay-linked camera proof
  cut teacher absence by 21 percentage points, while biometric attendance with unenforced penalties
  left doctors' attendance unimproved and its scale-up was cancelled.
applies_to: [photo-proof, supervisor-dashboards, attendance-tracking, minimum-tracking, feature-scoping]
tags: [randomized-trial, monitoring, enforcement, incentives, proof-of-work]
sources:
  - url: https://www.povertyactionlab.org/evaluation/encouraging-teacher-attendance-through-monitoring-cameras-rural-udaipur-india
    kind: primary-report
    title: "Encouraging Teacher Attendance through Monitoring with Cameras in Rural Udaipur, India (summary of Duflo, Hanna and Ryan, 'Incentives Work: Getting Teachers to Come to School', American Economic Review 102(4), 1241-78, 2012)"
    authors: J-PAL; Duflo, E.; Hanna, R.; Ryan, S. P.
    year: 2012
    venue: J-PAL evaluation summary
    archived: "pending: unavailable, no archive made; read through a search summary only"
    retrieved: 2026-11-06
  - url: https://www.povertyactionlab.org/node/1407
    kind: primary-report
    title: "Limits of technological solutions to provider monitoring (summary of Dhaliwal and Hanna, 'The Devil is in the Details', Journal of Development Economics, 2017)"
    authors: J-PAL; Dhaliwal, I.; Hanna, R.
    year: 2017
    venue: J-PAL evaluation summary
    archived: "pending: unavailable, no archive made; read through a search summary only"
    retrieved: 2026-11-06
authority: primary
strength: single-study
since: 2026-11-06
last_verified: 2026-11-06
status: current
origin: project
---
# Proof only matters if someone acts on it

@trace spec:research-records

## Claim

Recording that someone was present is not what moves behaviour. What follows from the record does.

## Evidence

Two randomised trials, seen through J-PAL's summaries rather than the papers.

- Duflo, Hanna and Ryan: 113 informal schools in rural Udaipur, 2003-2006. Teachers took tamper-proof
  dated photos with students at the start and end of each day, with pay tied to valid days (INR 50 a
  day). Absence fell 21 percentage points against control and test scores rose 0.17 SD. So photo proof
  can work: this is the counter-evidence to "monitoring never works", and it came with a pay rule.
- Dhaliwal and Hanna: 322 Karnataka primary health centres, about 140 given biometric attendance.
  Attendance rose slightly for nurses, lab technicians and pharmacists, not doctors, who were present
  31% of the time at random checks. Few got notices, fewer got pay cuts; officials feared losing
  doctors. Birth weight still improved, so the system was not useless. The scale-up was cancelled.
- Neither is farm work; both measure attendance, not tasks. Two trials in different sectors are
  suggestive, not a replication. Extending this to "supervisors need little data" is my inference.
  I found no study of what farm supervisors minimally need.

## How it applies

- As per research:field-adoption/monitoring-needs-enforcement-duflo-dhaliwal, record only what the
  farmer will act on today: who, which task, not started / started / done, and a problem flag.
- Leave out photo proof in the core product: its proven effect came through pay, and pay-linked proof on
  weak signal carries the risks in research:field-adoption/mandatory-photo-attendance-nmms-2023.
- Before adding any recorded field, name the decision it changes. No decision, no field.

## Provenance

- <https://www.povertyactionlab.org/evaluation/encouraging-teacher-attendance-through-monitoring-cameras-rural-udaipur-india>
  archived: unavailable
  retrieved: 2026-11-06 (search summary)
- <https://www.povertyactionlab.org/node/1407>
  archived: unavailable
  retrieved: 2026-11-06 (search summary)

## See also

- `research:field-adoption/monitoring-no-performance-gain-ravid-2023`
- `research:field-adoption/supervisor-operated-capture-orchard-apps`
