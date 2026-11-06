---
id: usability/touch-targets-thumb-gloves-parhi-2006
claim: >
  For one-handed thumb use on small touchscreens, targets of about 9.2 mm for
  single taps and 9.6 mm for serial taps were large enough not to degrade
  performance or preference, and larger targets were generally faster.
applies_to: [touch-targets, button-sizing, gloves, outdoor-use, one-handed-use]
tags: [thumb, target-size, gloves, wcag, touchscreen, accuracy]
sources:
  - url: https://doi.org/10.1145/1152215.1152260
    doi: 10.1145/1152215.1152260
    kind: peer-reviewed
    title: Target Size Study for One-Handed Thumb Use on Small Touchscreen Devices
    authors: Parhi, P.; Karlson, A.; Bederson, B.
    year: 2006
    venue: MobileHCI 2006, 203-210
    archived: "pending: unavailable - web.archive.org could not be reached from this environment (network allowlist)"
    retrieved: 2026-11-06
  - url: https://www.w3.org/WAI/WCAG22/Understanding/target-size-enhanced.html
    kind: standard
    title: "Understanding SC 2.5.5: Target Size (Enhanced)"
    authors: W3C WAI
    venue: WCAG 2.2 Understanding documents
    archived: "pending: unavailable - web.archive.org could not be reached from this environment (network allowlist)"
    retrieved: 2026-11-06
  - url: https://researchr.org/publication/RayMPF16
    kind: peer-reviewed
    title: Touch Zone Sizing for Mobile Devices in Military Applications
    authors: Ray, J.; Michelson, S.; Price, C.; Fausset, C.B.
    year: 2016
    venue: DUXU 2016, LNCS 9748, 65-76
    archived: "pending: unavailable - web.archive.org could not be reached from this environment (network allowlist)"
    retrieved: 2026-11-06
authority: primary
strength: single-study
since: 2026-11-06
last_verified: 2026-11-06
status: current
origin: project
---
# Thumb target floor is about 9-10 mm; gloves call for more

@trace spec:research-records

## Claim

About 9.2 to 9.6 mm is the bare-thumb floor; for hurried or gloved use it should
be treated as a minimum, not a goal. The gloved part is weakly evidenced.

## Evidence

- Parhi et al. (abstract summary from the Microsoft Research page): error rates
  showed no significant difference at or above 9.6 mm for discrete tasks and
  7.7 mm for serial tasks; the authors recommend 9.2 mm and 9.6 mm using speed,
  preference and hit variability too. No farm conditions or gloves.
- WCAG 2.2 (W3C pages read): 2.5.5, Level AAA, at least 44 by 44 CSS pixels;
  2.5.8, Level AA, at least 24 by 24. The guidance recommends larger targets for
  frequent use and for actions that are hard to undo.
- Ray et al. (search summary only): gloved and ungloved touch, n = 6, significant
  main effects of gloves and sizing guideline. A figure of 20 mm square for gloved
  operation appears as background about military cockpits, not as a tested
  farm-glove result. Effect sizes were not visible.

No study of farm gloves was found. Ordinary non-conductive gloves may not register
on capacitive screens at all, in which case no target size helps; that is a
general caution, to be checked with the gloves workers actually use.

No usable human-performance study of phone legibility in sunlight was found. W3C
1.4.6 asks for 7:1 contrast at AAA, but its page does not address sunlight. Any
outdoor colour or size choice in Tasker is a design choice, to be field-checked.

## How it applies

- As per research:usability/touch-targets-thumb-gloves-parhi-2006, no worker
  control is under 44 CSS pixels, and start and done are far larger.
- Make start/done full-width and tall, with wide gaps. Roughly 20 mm height is a
  design choice borrowed from the gloved figure, not a tested value for farms.
- Test on a real phone, outdoors, with the workers' real gloves, before fixing
  sizes and colours.

## Provenance

- <https://doi.org/10.1145/1152215.1152260>
  archived: unavailable (could not reach an archive from this environment)
  retrieved: 2026-11-06 (abstract summary from microsoft.com/en-us/research/?p=155150)
- <https://www.w3.org/WAI/WCAG22/Understanding/target-size-enhanced.html>
  archived: unavailable
  retrieved: 2026-11-06 (page read)
- <https://researchr.org/publication/RayMPF16>
  archived: unavailable
  retrieved: 2026-11-06 (search summary only)

## See also

- `research:interaction/fitts-law-1954`
