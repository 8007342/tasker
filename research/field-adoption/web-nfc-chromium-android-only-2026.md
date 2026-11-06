---
id: field-adoption/web-nfc-chromium-android-only-2026
claim: >
  Web NFC is experimental and not Baseline, with documented support centred on Chrome for Android and
  Safari and Firefox on record against it, so a tag can only work across phones as a plain URL the
  operating system opens.
applies_to: [nfc-tags, place-check-in, ios-support, feature-scoping, qr-codes]
tags: [web-nfc, browser-support, chrome-android, safari, ndef, core-nfc]
sources:
  - url: https://developer.mozilla.org/en-US/docs/Web/API/Web_NFC_API
    kind: standard
    title: "Web NFC API"
    authors: MDN contributors
    venue: MDN Web Docs
    archived: "pending: unavailable, no archive made; read through a search summary, compatibility table not visible"
    retrieved: 2026-11-06
  - url: https://developer.chrome.com/docs/capabilities/nfc
    kind: standard
    title: "Interact with NFC devices on Chrome for Android"
    authors: Google Chrome team
    venue: Chrome for Developers
    archived: "pending: unavailable, no archive made; read through a search summary only"
    retrieved: 2026-11-06
  - url: https://caniuse.com/webnfc
    kind: tertiary
    title: "Web NFC"
    authors: caniuse.com
    venue: caniuse.com
    archived: "pending: unavailable, no archive made; only partial rows were visible"
    retrieved: 2026-11-06
  - url: https://developer.apple.com/documentation/corenfc/adding-support-for-background-tag-reading
    kind: standard
    title: "Adding support for background tag reading"
    authors: Apple
    venue: Apple Developer Documentation
    archived: "pending: unavailable, no archive made; read through a search summary only"
    retrieved: 2026-11-06
authority: primary
strength: expert-opinion
since: 2026-11-06
last_verified: 2026-11-06
status: current
origin: project
---
# Web NFC is a Chrome-for-Android feature

@trace spec:research-records

## Claim

An app that needs Web NFC excludes iPhones. A URL written on a tag is the only form that reaches both.

## Evidence

Platform documentation, graded expert-opinion because no grade fits vendor docs, and because I saw
summaries and partial tables rather than the live compatibility data.

- MDN: experimental, not Baseline, secure contexts only. Compatibility table not visible.
- caniuse: lists Safari's position as opposed and Firefox's as harmful. Android rows were not visible.
- web-features data lists Chrome Android from 89 for parts of the API and 100 for the feature as a whole.
- Chrome docs: NDEF only. `NDEFReader` detection does not prove the phone has NFC hardware. Writes need a
  user gesture, permission, NFC hardware and NFC switched on. `makeReadOnly()` is from Chrome 100.
- Apple: iPhone XS and later read tags in the background while in use. A URL tag produces a notification;
  universal links open an associated native app; otherwise it opens in Safari. Custom schemes are not
  supported. A PWA has no such app association, so I expect Safari, not the home-screen app. That is an
  inference; I found no test of it.
- Not verified: Samsung Internet and other Android browsers, foreground-only behaviour, how many cheap
  Android phones have NFC, and whether a tag URL opens an installed Android PWA. Test on real devices.

## How it applies

- As per research:field-adoption/web-nfc-chromium-android-only-2026, keep NFC out of the first releases.
- If tags come, write a plain URL carrying the place id. On iPhone assume it opens Safari, without the
  home-screen app's saved data (see research:field-adoption/pwa-install-and-storage-2026).
- A tag may only ever make starting quicker. It is never required: GPS, a QR code and a supervisor
  override remain, or iPhone users and phones without NFC are locked out.
- Consider printed QR codes first; they need no NFC hardware.

## Provenance

- <https://developer.mozilla.org/en-US/docs/Web/API/Web_NFC_API>
  archived: unavailable
  retrieved: 2026-11-06 (search summary)
- <https://developer.chrome.com/docs/capabilities/nfc>
  archived: unavailable
  retrieved: 2026-11-06 (search summary)
- <https://caniuse.com/webnfc>
  archived: unavailable
  retrieved: 2026-11-06 (partial rows)
- <https://web-platform-dx.github.io/web-features-explorer/features/web-nfc> (search summary)
- <https://developer.apple.com/documentation/corenfc/adding-support-for-background-tag-reading>
  archived: unavailable
  retrieved: 2026-11-06 (search summary)

## See also

- `research:field-adoption/pwa-install-and-storage-2026`
