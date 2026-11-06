# Tasker

A simple daily task list for farm crews. Farmers assign the work; each worker opens the app
in the morning and sees today's tasks. First customer: one farm with several locations.

## Where it is going

- Google single sign-on, so each person sees the tasks under their own name.
- Sync between phones, working offline and catching up when signal returns.
- NFC tags placed around the farm: tag in, tag out, hear what to do.
- Recorded instructions for tasks and tools, for people who don't read.
- Photos attached as proof of finished work.
- Sequences (B after A) and recurring schedules.

## Stack

Flutter web installed as a PWA, with the Flame engine for the farm map. Hosted on Cloudflare
Workers at tasker.tlatoani.net.
