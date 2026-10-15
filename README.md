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
- `/digest`: what changed since the last run. Read-only.
- `/daily`: the digest, plus today's 業務 written into the Kintone weekly record. Everything else comes back as drafts.
- `/points 2026-10`: drafts point entries, checked against what you've already claimed.
- `/loop 24h /daily`: runs the daily sync automatically while the session stays open.

Reads run without prompts. Writes (Kintone records, Backlog comments) ask for permission each time.
