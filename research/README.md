# Research

What is known about how people use things like this app, kept next to the
code so decisions carry their reasons.

- One file per finding: `research/<domain>/<slug>.md`, copied from the
  shared library (`$TILLANDSIAS_RESEARCH`, `/opt/research`) or written with
  the `find-research` skill from its `TEMPLATE.md`. Every file names its
  source, an archived copy of it, and how strong the evidence is.
- Cite a finding as `research:<domain>/<slug>` in specs, code comments and
  commit trailers (`Research: <domain>/<slug>`); see the `cite-research`
  skill.
- Downloaded papers and pages do not live here; they go in the cache layer.
