## ADDED Requirements

### Requirement: Location to start
A task MAY require the worker to be at its place to start. Such a task SHALL start only when the worker's distance from the place, less the fix's reported accuracy, is within the place's radius. If there is no fix or the worker is too far, the task SHALL stay unstarted and the worker SHALL be shown where to go.

#### Scenario: too far away
- **WHEN** a worker 300 m from a place with a 50 m radius taps start
- **THEN** the task does not start and the place is shown

#### Scenario: at the place
- **WHEN** a worker 20 m from the place taps start
- **THEN** the task starts

### Requirement: Start window
A task MAY have a time before which it cannot start, and a time by which it must start. Before the first it SHALL be waiting; past the second, unstarted, it SHALL be missed.

#### Scenario: must start by noon
- **WHEN** it is past noon and the task with a noon start deadline was not started
- **THEN** it shows as missed and cannot be started

### Requirement: Time limit
A task MAY have a time limit counted from its start. Past the limit it SHALL be overdue, and the worker SHALL still be able to finish it.

#### Scenario: running over
- **WHEN** a 30 minute task has been running for 40 minutes
- **THEN** it shows as overdue and the done button still works

### Requirement: Expiry
A task MAY have an expiry (TTL), counted from the later of its creation and the start of its assigned day. Once expired it SHALL no longer be startable or finishable, including if already started.

#### Scenario: expired while running
- **WHEN** a started task passes its expiry
- **THEN** it shows as expired and offers no actions
