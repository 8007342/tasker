## ADDED Requirements

### Requirement: Workers land on today's tasks
Tapping Worker on the landing screen SHALL open directly on that person's list of today's tasks, with no menu or extra step, showing only tasks assigned to them. Once sign-in exists, a signed-in worker SHALL land there straight away. Unfinished tasks from earlier days SHALL stay on the list while they can still be done.

#### Scenario: opening the app in the morning
- **WHEN** Ana opens the app and taps Worker
- **THEN** she immediately sees her tasks for today, things to do first

#### Scenario: yesterday's unfinished task
- **WHEN** a task from yesterday was not finished and has not lapsed
- **THEN** it is on today's list

### Requirement: Tasks are readable without reading
Every task SHALL show its kind and state by icon and colour as well as by word, and the actions SHALL be large buttons with an icon, as per research:interaction/fitts-law-1954, because bigger targets are hit faster and more reliably by gloved or hurried hands.

#### Scenario: a worker who doesn't read
- **WHEN** a worker looks at a seed task that is ready
- **THEN** a seed icon and a large green play button make the next action clear

### Requirement: Starting and finishing respond at once
Starting or finishing a task SHALL update the screen immediately with no network wait, as per research:interaction/response-time-limits-nielsen-1993, because about 0.1 s is what feels instantaneous.

#### Scenario: finishing with no signal
- **WHEN** a worker with no connection taps done
- **THEN** the task shows as done straight away, and stays done after reopening the app
