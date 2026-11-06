## ADDED Requirements

### Requirement: Map shows where the work is
The farmer and worker views SHALL show an illustrated farm map with a pin on each place that has open tasks in view, showing how many.

#### Scenario: two tasks at the orchard
- **WHEN** a worker has two open tasks at the Orchard
- **THEN** the Orchard has a pin showing 2

### Requirement: Tapping a pin filters the list
Tapping a pin SHALL show only that place's tasks, and tapping it again SHALL show all.

#### Scenario: filtering
- **WHEN** a worker taps the Orchard pin
- **THEN** the list shows only Orchard tasks
