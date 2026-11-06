---
id: field-adoption/farmworker-phones-identity-lee-2024
claim: >
  North Carolina farmworker surveys show phones are common but many workers rely on cellular data and
  few keep the same number, so a phone number or email is a weak anchor for a worker's identity.
applies_to: [sign-in, onboarding, shared-phones, google-sign-in, otp, first-load]
tags: [farmworkers, smartphones, phone-numbers, connectivity, identity, migrant-workers]
sources:
  - url: https://journals.sagepub.com/doi/10.1177/00333549241295632
    doi: 10.1177/00333549241295632
    kind: peer-reviewed
    title: "Internet Devices and Internet Access Among Migrant and Seasonal Farmworkers, North Carolina, 2023"
    authors: Lee, J. G. L.; Roby, M.; Cofie, L. E.; LePrevost, C. E.; Harwell, E. L.; Reed, E. C.; Nieuwsma, J.; Bloss, J. E.; Anderson, G. C.; Santillán-Deras, J. R.; Moore, M. A.; Ketterman, E.; Russell, R. G.
    year: 2024
    venue: SAGE journal (journal name not shown in the search summary)
    archived: "pending: unavailable, no archive made; read through search summaries only"
    retrieved: 2026-11-06
  - url: https://www.springermedizin.de/mobile-and-traditional-modes-of-communication-among-male-latino-/8923664
    kind: peer-reviewed
    title: "Mobile and Traditional Modes of Communication Among Male Latino Farmworkers: Implications for Health Communication and Dissemination"
    authors: Sandberg, J. C.; Spears Johnson, C. R.; Nguyen, H. T.; Talton, J. W.; Quandt, S. A.; Chen, H.; Summers, P.; Arcury, T. A.
    year: 2016
    venue: Journal of Immigrant and Minority Health 18(3), 522-531
    archived: "pending: unavailable, no archive made; read through a search summary of the abstract only"
    retrieved: 2026-11-06
  - url: https://www.tandfonline.com/doi/full/10.1080/1059924X.2026.2656163
    doi: 10.1080/1059924X.2026.2656163
    kind: peer-reviewed
    title: "Access to Phones and Use of International Numbers Among Farmworkers in North Carolina, 2023-2024"
    authors: Zahra, A. G.; Cofie, L. E.; LePrevost, C. E.; et al.
    year: 2026
    venue: Journal of Agromedicine
    archived: "pending: unavailable, no archive made; read through search summaries only"
    retrieved: 2026-11-06
  - url: https://support.google.com/accounts/answer/27441
    kind: primary-report
    title: "Create a Google Account"
    authors: Google
    venue: Google Account Help (seen through a mirrored copy in search results)
    archived: "pending: unavailable, no archive made; read through a search summary only"
    retrieved: 2026-11-06
authority: primary
strength: single-study
since: 2026-11-06
last_verified: 2026-11-06
status: current
origin: project
---
# Phones yes, stable numbers and accounts no

@trace spec:research-records

## Claim

Assume workers have a smartphone, not that they have a lasting number, an email or a good connection.

## Evidence

- Lee et al.: survey of 1,034 migrant and seasonal farmworkers at 8 North Carolina sites, 2023. Across
  summaries: smartphone ownership 93.9%, almost 1 in 4 without consistent internet in their housing,
  migrant workers 8.17 times more likely than state households to rely on cellular data alone, slightly
  over half without speeds for steady video calls. One summary carried these numbers and a follow-up
  search did not re-confirm the 93.9% and 8.17, so check the paper before quoting them.
- Sandberg et al.: questionnaires from 165 and 102 male Latino farmworkers, North Carolina, 2012-13.
  "Relatively few farmworkers maintain consistent phone numbers." Dated, one state, men only.
- Zahra et al. (2026): some workers keep two phones, one from home and one bought in the US, and
  international numbers complicate contact. Interviews (n = 19) raised weak digital skills.
- One state's mainly Spanish-speaking workforce will not represent every farm.
- Sign-in: I found no study measuring email or Google-account barriers for these workers. Google's help
  says an account needs an existing email or a new Gmail, plus a birthday; only blogs discuss when phone
  verification is required, so I treat that as unverified. Developer forum reports describe Google
  sign-in redirects out of iOS home-screen apps and lost sessions, while one vendor says it works now.
- Vendor claims that about 80% of frontline workers lack company email cite unnamed research; excluded.
- H-2A participants in the Wallace study were told to leave with as little as a week's notice, so crews
  change quickly and enrolment must be cheap.

## How it applies

- As per research:field-adoption/farmworker-phones-identity-lee-2024, the worker's identity belongs to
  the farm's list, not to a phone number or account. The farmer adds the name and a photo or icon.
- Enrol by the farmer showing a QR code or short link that signs that phone in as that worker. It needs
  signal once, ideally the farmhouse Wi-Fi; the sign-in then persists offline.
- Keep Google sign-in for farmers at most. Never require a worker to have an email, password or SMS code.
- A lost or changed phone is fixed by the farmer issuing a new code, not by a recovery flow.
- This bears on the spec's open question about workers without Google accounts, and argues against the
  later Google sign-in change covering workers.

## Provenance

- <https://journals.sagepub.com/doi/10.1177/00333549241295632>
  archived: unavailable
  retrieved: 2026-11-06 (search summaries)
- <https://www.springermedizin.de/mobile-and-traditional-modes-of-communication-among-male-latino-/8923664>
  archived: unavailable
  retrieved: 2026-11-06 (search summary of abstract)
- <https://www.tandfonline.com/doi/full/10.1080/1059924X.2026.2656163>
  archived: unavailable
  retrieved: 2026-11-06 (search summaries)
- <https://support.google.com/accounts/answer/27441>
  archived: unavailable
  retrieved: 2026-11-06 (mirrored copy in search results)
- <https://intercom.help/progressier/en/articles/9519381-google-oauth2-is-not-working-in-my-pwa-on-ios-why> (vendor; search summary)
- <https://github.com/nolanlawson/pinafore/issues/45> (developer report; search summary)

## See also

- `research:field-adoption/supervisor-operated-capture-orchard-apps`
- `research:field-adoption/pwa-install-and-storage-2026`
