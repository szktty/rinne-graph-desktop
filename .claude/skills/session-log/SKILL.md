---
name: session-log
description: >-
  Restore or record session context using the private progress log. Use at
  session start to load PLAN.md and the latest daily minutes, or at session end
  to update feature status and write the day's minutes (commit hashes,
  decisions, remaining tasks). Operates on ../rinne-graph-desktop-private/.
disable-model-invocation: true
---

# session-log

Manage the RinneGraph progress log, which lives in the private repository at
`../rinne-graph-desktop-private/` (relative to this repo root). This implements
the "Progress Logging" section of CLAUDE.md.

The private repo layout:

```
../rinne-graph-desktop-private/
├── PLAN.md                 # Overall plan & feature status
└── sessions/
    └── YYYY-MM-DD.md       # Per-day minutes
```

## Mode: start

Run at the beginning of a session to restore context.

1. **Verify the private repo exists.**

   ```bash
   ls ../rinne-graph-desktop-private/
   ```

   If it does not exist, stop and tell the user — do not proceed.

2. **Read the plan and the latest minutes.**

   ```bash
   ls -t ../rinne-graph-desktop-private/sessions/
   ```

   Read `../rinne-graph-desktop-private/PLAN.md` and the most recent
   `sessions/YYYY-MM-DD.md` to restore context from prior work.

3. **Summarize and confirm the day's target.** Briefly report where the last
   session left off (remaining tasks, blockers) and confirm today's target with
   the user before starting implementation.

## Mode: end

Run at the end of a session to record progress.

1. **Update feature status** in `../rinne-graph-desktop-private/PLAN.md` to
   reflect what changed this session.

2. **Write the day's minutes** to
   `../rinne-graph-desktop-private/sessions/YYYY-MM-DD.md` (use today's date).
   Cover:
   - What was done — with commit hashes for each change.
   - Decisions made and why.
   - Remaining tasks and blockers for the next session.

   If a file for today already exists, append to it rather than overwriting.

3. **Remind the user to commit the private repo.** The minutes and PLAN.md
   updates live in `../rinne-graph-desktop-private/`, a separate git repo — tell
   the user to `git commit` there. Do not commit it yourself unless asked.

## Notes

- This skill only touches the private repo, never the app source tree.
- Convert any relative dates to absolute dates when writing minutes.
- Gather commit hashes with `git log --oneline` in the main repo for the
  session's commits before writing the minutes.
