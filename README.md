# work-reporter

Claude Code reads your Backlog, GitHub and git work, then fills your Kintone weekly report.

## Start
```
git clone https://github.com/khoa-astec/work-reporter
cd work-reporter
claude
```
Type `/setup`. It tells you which keys to get and where to put them.

## Commands
- `/morning`: writes today's goals into Kintone.
- `/daily`: writes today's results into Kintone.
- `/digest`: shows what changed. Writes nothing.
- `/points 2026-10`: drafts point entries for you to approve.

Writes always ask first. The only exception is the daily schedule (Windows, 08:55 + 17:00): `/setup` offers it, and it can only update the Kintone report.
