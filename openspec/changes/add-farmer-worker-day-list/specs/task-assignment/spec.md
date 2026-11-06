## ADDED Requirements

### Requirement: Farmer creates and assigns a task
The farmer SHALL be able to create a task with a kind, a worker and a day, and optionally a place, a note and timing rules. The title SHALL default to the kind's name so a task can be made in a few taps.

#### Scenario: assigning seed spreading
- **WHEN** the farmer picks "Seed", worker Ana, North Field and today, and saves
- **THEN** the task appears in the farmer's list under Ana, and on Ana's list for today

### Requirement: Farmer sees progress
The farmer SHALL see each task for the chosen day grouped by worker, with its current state, and SHALL be able to delete a task.

#### Scenario: a worker starts a task
- **WHEN** Ana starts her task
- **THEN** the farmer's view shows that task as in progress

### Requirement: Farmer records a place's GPS
The farmer SHALL be able to save their current GPS position to a place, by standing there.

#### Scenario: saving the barn's position
- **WHEN** the farmer, standing at the barn, saves the location for Barn
- **THEN** tasks at the barn may require the worker to be there to start
