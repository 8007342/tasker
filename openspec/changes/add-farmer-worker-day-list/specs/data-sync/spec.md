## ADDED Requirements

### Requirement: Shared database
Tasks and place locations SHALL be stored in a Cloudflare D1 (SQLite) database, so that a task assigned on one phone reaches the worker's phone.

#### Scenario: assigning across phones
- **WHEN** the admin assigns a task on their phone and both phones have signal
- **THEN** the task appears on the worker's phone within about 5 seconds

### Requirement: Offline changes catch up
Changes made with no connection SHALL be saved on the phone, kept across restarts, and sent automatically when the server can be reached, with no action from the user.

#### Scenario: back in range
- **WHEN** a worker finishes a task in a dead zone and later regains signal
- **THEN** the admin sees it as done, with the time it was actually finished

#### Scenario: the admin is watching
- **WHEN** the worker taps done and both phones have signal
- **THEN** the admin's screen shows the task as done within about 5 seconds, with no refresh

### Requirement: Sync state is visible and calm
The screen SHALL show whether everything has reached the server or how many changes are waiting, and being offline SHALL NOT be presented as an error.

#### Scenario: waiting for signal
- **WHEN** a change hasn't reached the server
- **THEN** a cloud icon with a count shows it is waiting, and the worker can carry on
