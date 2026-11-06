---
id: usability/graphical-voice-vs-text-low-literacy-medhi-2011
claim: >
  First-time low-literacy phone users could not complete a task on a text
  interface (0 of 20), while 72% (13 of 18) did on spoken dialog and 100%
  (20 of 20) did on a voice-annotated graphical interface, though only with
  heavy prompting.
applies_to: [low-literacy-ui, first-time-users, worker-task-list, navigation-depth, voice-annotation]
tags: [ict4d, low-literacy, text-free, voice-ui, mobile, novice-users]
sources:
  - url: https://doi.org/10.1145/1959022.1959024
    doi: 10.1145/1959022.1959024
    kind: peer-reviewed
    title: Designing Mobile Interfaces for Novice and Low-Literacy Users
    authors: Medhi, I.; Patnaik, S.; Brunskill, E.; Gautama, S.N.N.; Thies, W.; Toyama, K.
    year: 2011
    venue: ACM Transactions on Computer-Human Interaction 18(1), Article 2
    archived: "pending: unavailable - web.archive.org could not be reached from this environment (network allowlist)"
    retrieved: 2026-11-06
  - url: https://www.microsoft.com/en-us/research/?p=164235
    kind: peer-reviewed
    title: Some Evidence for Impact of Limited Education on Hierarchical User Interface Navigation
    authors: Medhi Thies, I.; Lakshmanan, M.; Toyama, K.; Cutrell, E.
    year: 2013
    venue: ACM CHI 2013
    archived: "pending: unavailable - web.archive.org could not be reached from this environment (network allowlist)"
    retrieved: 2026-11-06
authority: primary
strength: single-study
since: 2026-11-06
last_verified: 2026-11-06
status: current
origin: project
---
# Text fails first-time low-literacy users; pictures with voice work, with help

@trace spec:research-records

## Claim

Text interfaces were unusable for first-time low-literacy users. Pictures with
voice annotation got everyone through a task, but slowly and with coaching.

## Evidence

Full text of the 2011 article read from the Microsoft Research PDF. Three parts:
ethnography with 90 low-literacy subjects (India, Kenya, Philippines, South
Africa); mobile-banking comparison with 58 first-time low-literacy subjects in
southern India; health-data entry with 13 novice but literate users.

- Banking: text 0/20; voice 13/18 (5.2 min, 4 prompts, among completers);
  graphical 20/20 (13 min, 14 prompts). The authors say the graphical UI is "not
  suitable for independent use by first-time users".
- Subjects were nervous about pressing keys for fear of "breaking" or "spoiling"
  the phone, which the authors use to explain the prompting.
- Barriers found: scrolling, hierarchical navigation, soft-key mapping,
  nonnumeric input, technical language. Recommendations include graphical cues,
  voice annotation wherever possible, local language in text and audio, minimal
  hierarchy, no scrolling menus, human mediators.
- Health: about 5% error rate on text interfaces, ten times the live operator's,
  but only 13 users and 26 errors; the authors warn against generalising.

Limits: keypad phones, not touchscreens; a banking task, harder than start/done;
subjects used their own language (Kannada), not a language they were learning.
A scrolling list of tasks was not tested, so it needs its own check.

The article itself notes that speech versus keypress input is unsettled across
three studies (Patel 2009, Grover 2009, Sherwani 2009), so it supports voice as
output more safely than as input.

The 2013 CHI paper (abstract summary from the Microsoft Research page) tested 60
low-income participants in India: literacy and Raven's scores predicted success
navigating UI hierarchies, even text-free ones.

## How it applies

- As per research:usability/graphical-voice-vs-text-low-literacy-medhi-2011, the
  worker screen does not rely on text: every task has a picture, and a play-audio
  control once recordings exist.
- One flat list, no menus or nested screens between landing and start/done.
- No typing anywhere in the worker flow.
- A person shows the worker the app the first time; do not assume self-service.
- Make tapping visibly safe, because fear of breaking something slows these users.

## Provenance

- <https://doi.org/10.1145/1959022.1959024>
  archived: unavailable (could not reach an archive from this environment)
  retrieved: 2026-11-06 (full text, PDF at microsoft.com/en-us/research/wp-content/uploads/2016/02/ToCHI2711_Medhi.pdf)
- <https://www.microsoft.com/en-us/research/?p=164235>
  archived: unavailable
  retrieved: 2026-11-06 (abstract summary from the publication page; DOI not listed there)

## See also

- `research:usability/full-context-video-onboarding-medhi-2007`
- `research:usability/pictogram-plus-voice-migrant-workers-kheir-2014`
