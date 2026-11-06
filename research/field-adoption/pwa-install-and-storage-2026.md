---
id: field-adoption/pwa-install-and-storage-2026
claim: >
  PWA install is not dependable by itself: Chrome offers it only after engagement, a real Android app
  install depends on Play services or a vendor server, and browsers may evict data unless persistence is
  granted, which installed apps are more likely to get.
applies_to: [pwa-install, offline-storage, onboarding, ios-support, low-end-android, first-load]
tags: [pwa, webapk, add-to-home-screen, storage-eviction, persistent-storage, safari]
sources:
  - url: https://web.dev/articles/install-criteria
    kind: standard
    title: "What does it take to be installable?"
    authors: Google web.dev
    venue: web.dev
    archived: "pending: unavailable, no archive made; read through a search summary only"
    retrieved: 2026-11-06
  - url: https://web.dev/learn/pwa/installation
    kind: standard
    title: "Installation (Learn PWA)"
    authors: Google web.dev
    venue: web.dev
    archived: "pending: unavailable, no archive made; read through a search summary only"
    retrieved: 2026-11-06
  - url: https://web.dev/articles/persistent-storage
    kind: standard
    title: "Persistent storage"
    authors: Google web.dev
    venue: web.dev
    archived: "pending: unavailable, no archive made; read through a search summary only"
    retrieved: 2026-11-06
  - url: https://webkit.org/?p=14403
    kind: primary-report
    title: "Updates to Storage Policy"
    authors: WebKit team
    venue: WebKit blog
    archived: "pending: unavailable, no archive made; read through a search summary only"
    retrieved: 2026-11-06
  - url: https://www.creativebloq.com/features/9-amazing-pwa-secrets
    kind: expert-secondary
    title: "9 amazing PWA secrets"
    authors: Not shown in the search summary
    venue: Creative Bloq
    archived: "pending: unavailable, no archive made; read through a search summary only"
    retrieved: 2026-11-06
  - url: https://www.idownloadblog.com/?p=1042117
    kind: tertiary
    title: "iOS 26: Safari opens every bookmark added to the Home Screen as a web app"
    authors: Not shown in the search summary
    venue: iDownloadBlog
    archived: "pending: unavailable, no archive made; read through a search summary only"
    retrieved: 2026-11-06
authority: primary
strength: expert-opinion
since: 2026-11-06
last_verified: 2026-11-06
status: current
origin: project
---
# Install and storage are weaker than "works offline" sounds

@trace spec:research-records

## Claim

Installation needs a helper, and data on the phone is not guaranteed to stay. Plan onboarding and sync
around both.

## Evidence

Platform docs and a few secondary sources, seen as summaries. I found no field data on cheap phones.

- Chrome fires `beforeinstallprompt` only if the app is not installed, the user tapped the page and spent
  at least 30 seconds on it, over HTTPS, with a suitable manifest. Other browsers differ.
- Android: a Google server builds a WebAPK. If Play services is missing or has a connection problem, or
  the browser is Firefox or Samsung Internet, a secondary source says the fallback is a home-screen
  shortcut (browser-branded from Android 8). web.dev says Samsung has its own minting server, so that
  source is partly out of date. Either way install may need a connection beyond the page load.
- iOS: from iOS 26 every site added to the Home Screen opens as a web app by default, with an option to
  turn it off that leaves a Safari bookmark (tech press and developer blogs, not Apple). Finding "Add to
  Home Screen" remains manual; I did not find a doc stating there is no install prompt.
- iOS storage: from Safari 17, origins are best-effort and evicted least-recently-used; `persist()` is
  granted by heuristics, including being opened as a Home Screen web app. WebKit's 2020 seven-day rule
  was described as counting days of use separately for home-screen apps. Older sources; test it.
- Developer reports say Safari and the home-screen app do not share a session. I did not find Apple
  documentation for this.
- Chromium grants `persist()` silently by heuristics, including install; web.dev says Chrome rarely
  clears data automatically, and advises asking when critical data is saved, not at page load.
- Not found: Android Go behaviour, quota on small phones, Flutter CanvasKit load on cheap phones. The
  spec's first online visit is the risky moment; measure its download size on a real low-end phone.

## How it applies

- As per research:field-adoption/pwa-install-and-storage-2026, onboarding happens in person on Wi-Fi:
  the supervisor opens the link and adds the app with the worker, and sees it open offline before leaving.
- The app must work fully in a browser tab; installing helps, never gates. Do not build around an install
  prompt or a custom install banner in the first slice.
- On iPhone, enrol inside the home-screen app rather than in Safari, as sessions may not carry across.
- Call `navigator.storage.persist()` on first task save, and treat a false result as more reason to sync.
- Until sync ships, the design's "clearing browser data loses tasks" risk also covers silent eviction.

## Provenance

- <https://web.dev/articles/install-criteria>
  archived: unavailable
  retrieved: 2026-11-06 (search summary)
- <https://web.dev/learn/pwa/installation>
  archived: unavailable
  retrieved: 2026-11-06 (search summary)
- <https://web.dev/articles/persistent-storage>
  archived: unavailable
  retrieved: 2026-11-06 (search summary)
- <https://webkit.org/?p=14403>
  archived: unavailable
  retrieved: 2026-11-06 (search summary)
- <https://www.creativebloq.com/features/9-amazing-pwa-secrets>
  archived: unavailable
  retrieved: 2026-11-06 (search summary)
- <https://www.idownloadblog.com/?p=1042117>
  archived: unavailable
  retrieved: 2026-11-06 (search summary)
- <https://www.itnews.com.au/news/apple-cops-flak-for-deleting-local-browser-storage-after-7-days-539833> (2020; search summary)
- <https://developer.apple.com/forums/thread/710157> (developer forum; search summary)

## See also

- `research:field-adoption/web-nfc-chromium-android-only-2026`
- `research:field-adoption/farmworker-phones-identity-lee-2024`
