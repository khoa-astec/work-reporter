# work-reporter

A Claude Code workspace that reads your Backlog tickets, GitHub PRs and local git commits, writes the day's work into a Kintone weekly record, and drafts Backlog updates and Kintone point entries for you to approve.

## Setup
1. **Keys.** Set these once, then open a new terminal:
   ```
   setx BACKLOG_DOMAIN "<your-space>.backlog.jp"
   setx BACKLOG_API_KEY "<Backlog: 個人設定 → API>"
   setx GITHUB_PAT "<GitHub classic token, scopes: repo, read:org>"
   ```
2. **Kintone.** On claude.ai, open Settings → Connectors and connect your Kintone MCP. Claude Code picks it up when you sign in with the same account.
3. **Config.** Copy `config.example.md` to `config.local.md` and fill in your project key, repos and app IDs. This file is gitignored.
4. **Start.**
   - `cd work-reporter`, run `claude`, and accept the folder trust prompt.
   - Run `/mcp`. `backlog`, `github` and Kintone should all show as connected.
   - If `github` fails to authenticate, replace it in `.mcp.json` with the local server:
     ```json
     "github": {"command": "docker", "args": ["run", "-i", "--rm", "-e", "GITHUB_PERSONAL_ACCESS_TOKEN", "ghcr.io/github/github-mcp-server"], "env": {"GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_PAT}"}}
     ```

## Use
- `/morning`: writes today's goals (本日の目標) into the Kintone weekly record.
- `/daily`: reports what changed and writes today's results (業務). Everything else comes back as drafts.
- `/digest`: what changed since the last run. Read-only.
- `/points 2026-10`: drafts point entries, checked against what you've already claimed.

In an interactive session, reads run without prompts and writes ask for permission each time.

## Schedule (Windows)
Run `/digest` once interactively first. That trusts the folder and checks the connections. Then:
```
powershell -ExecutionPolicy Bypass -File scripts\register-schedule.ps1
```
This registers two tasks:

| Task | Time | Runs |
|---|---|---|
| `work-reporter-morning` | 08:55 every day | `/morning` |
| `work-reporter-evening` | 17:00 every day | `/daily` |

How the scheduled runs behave:
- They run only while you're logged on. A run missed while the PC was off starts when it's back.
- They are headless (`claude -p`, `--permission-mode dontAsk`). The only write they can make is the Kintone record update, plus `state.json`.
- Logs go to `logs/`.

To remove the tasks:
```
Unregister-ScheduledTask -TaskName work-reporter-morning, work-reporter-evening -Confirm:$false
```
