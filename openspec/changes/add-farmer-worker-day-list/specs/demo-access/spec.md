## ADDED Requirements

### Requirement: Landing buttons
Until Google sign-in exists, the landing screen SHALL show Admin and Worker buttons at the bottom, each opening that view.

#### Scenario: choosing a view
- **WHEN** someone taps Worker on the landing screen
- **THEN** the worker's task list opens

### Requirement: Seeded demo tasks
Each day the demo worker SHALL have seeded tasks (irrigate crops, measure moisture, and last, take the trash out), without duplicates across phones and without undoing progress or deletions.

#### Scenario: a second phone opens the app
- **WHEN** a task was already finished on one phone and another phone opens the app
- **THEN** the second phone shows the same tasks, with that one finished
