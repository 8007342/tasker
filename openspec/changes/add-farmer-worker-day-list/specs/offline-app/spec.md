## ADDED Requirements

### Requirement: Opens with no connection
After one visit online, the app SHALL open and be fully usable with no connection, with no assets fetched from any other site, and SHALL be installable to the phone's home screen.

#### Scenario: opening in the field
- **WHEN** a worker with no signal opens the app
- **THEN** it loads, with text, icons and map drawn correctly

### Requirement: Data survives restarts
Tasks and unsent changes SHALL be kept on the device across restarts.

#### Scenario: reopening
- **WHEN** the app is closed and reopened
- **THEN** the same tasks are there, including changes not yet sent

### Requirement: Updates arrive by themselves
When online, a newly deployed version SHALL be fetched in the background and used from the next time the app opens.

#### Scenario: after a deploy
- **WHEN** a new version is published and the app is opened online
- **THEN** the next open runs the new version
