## ADDED Requirements

### Requirement: Pushing main deploys
Every push to `main` SHALL build the app and publish it at https://tasker.tlatoani.net, unless the build or tests fail, in which case the live site SHALL stay as it was.

#### Scenario: a good push
- **WHEN** a commit whose tests pass is pushed to `main`
- **THEN** the new version is live at tasker.tlatoani.net

#### Scenario: a broken push
- **WHEN** a commit with a failing test is pushed to `main`
- **THEN** nothing is deployed

### Requirement: QR code page
The site SHALL serve a page at `/qr` showing a QR code that opens https://tasker.tlatoani.net, usable with no connection once cached, and printable with no other assets.

#### Scenario: scanning the code
- **WHEN** someone opens tasker.tlatoani.net/qr and another phone scans the code
- **THEN** that phone opens https://tasker.tlatoani.net
