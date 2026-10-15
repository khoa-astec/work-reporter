---
description: 初期設定。足りないキー・接続・設定を1つずつ案内します
---
足りないものを1つずつ、1項目3行以内で、やさしい日本語で案内します。キーをチャットに貼らせてはいけません。

## 1. ファイルを作る
次のファイルがなければ作成します。作った後に「設定ファイルを作りました」と1行だけ伝えます。

`.mcp.json`
```json
{
  "mcpServers": {
    "backlog": {
      "command": "npx",
      "args": ["-y", "backlog-mcp-server"],
      "env": { "BACKLOG_DOMAIN": "${BACKLOG_DOMAIN}", "BACKLOG_API_KEY": "${BACKLOG_API_KEY}" }
    },
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": { "Authorization": "Bearer ${GITHUB_PAT}" }
    }
  }
}
```

`.claude/settings.json`
```json
{
  "enabledMcpjsonServers": ["backlog", "github"],
  "permissions": {
    "allow": [
      "mcp__backlog__get_*", "mcp__backlog__count_*",
      "mcp__github__get_*", "mcp__github__list_*", "mcp__github__search_*", "mcp__github__pull_request_read",
      "mcp__claude_ai_Kintone_MCP__get*", "mcp__claude_ai_Kintone_MCP__searchApps", "mcp__claude_ai_Kintone_MCP__jisou_*",
      "Bash(git -C * log *)", "Bash(git -C * status *)", "Bash(git -C * worktree list*)", "Bash(git -C * branch *)",
      "Bash(git config user.name)"
    ],
    "deny": ["Bash(git -C * push*)", "Bash(git -C * commit*)", "Bash(git -C * reset*)", "Bash(git -C * checkout*)"]
  }
}
```

Kintone ツール名の接頭辞が `mcp__claude_ai_Kintone_MCP__` と違う場合は、実際の名前に合わせます。

`.git/info/exclude` に次の行がなければ追加します。これらは個人用のファイルなので、git に入れません。
```
.mcp.json
.claude/settings.json
.claude/settings.local.json
config.local.md
state.json
logs/
scripts/
```

## 2. キーを確認する
値は表示せず、設定されているかどうかだけ確認します。
- Windows（PowerShell）：`'GITHUB_PAT','BACKLOG_API_KEY','BACKLOG_DOMAIN' | % { $_ + ': ' + [bool][Environment]::GetEnvironmentVariable($_,'User') }`
- Mac/Linux：`[ -n "$名前" ]` で1つずつ確認

足りないキーごとの案内：
- `GITHUB_PAT`：github.com → Settings → Developer settings → Tokens (classic) → `repo` と `read:org` にチェック → トークンをコピー
- `BACKLOG_API_KEY`：Backlog → 個人設定 → API → 登録 → キーをコピー
- `BACKLOG_DOMAIN`：Backlog の URL のホスト名（例：`xxx.backlog.jp`）
- 設定方法：「このチャットではなく、普通のターミナルで `setx 名前 "値"` を実行してください」。Mac/Linux なら `~/.zshrc` に `export 名前="値"` を追加します。

## 3. Kintone をつなぐ
Kintone のツールがなければ、「claude.ai → 設定 → コネクタ → Kintone を接続してください」と案内します。

## 4. 再起動する
キーやコネクタ、`.mcp.json` を変えたら、「このウィンドウを閉じ、新しいターミナルでこのフォルダに移動して `claude` を起動してください」と案内します。

## 5. 接続を確認する
`get_me`（GitHub）、`get_myself`（Backlog）、Kintone の読み取りを1回ずつ試し、どれがつながったかを伝えます。

## 6. 個人設定を作る
`config.local.md` がなければ、次を聞いて `config.example.md` の形で作ります。
- Backlog のプロジェクトキー
- GitHub の org
- ローカルのリポジトリのパス
- Kintone の週報アプリID
- ポイントアプリのID（任意）

## 7. 自動実行（Windows のみ・任意）
「毎日 8:55 に目標、17:00 に実績を自動で書きますか？」と聞きます。「はい」なら次の2ファイルを作り、登録スクリプトを実行します。

`scripts/run.ps1`
```powershell
param([Parameter(Mandatory)][ValidateSet('morning', 'evening')][string]$Mode)
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root
New-Item -ItemType Directory -Force -Path logs | Out-Null
$prompt = @{ morning = '/morning'; evening = '/daily' }[$Mode]
$log = Join-Path logs ("{0}-{1}.log" -f (Get-Date -Format 'yyyy-MM-dd'), $Mode)
claude -p $prompt --permission-mode dontAsk --allowedTools 'mcp__claude_ai_Kintone_MCP__updateRecord' 'Edit(./state.json)' *>> $log
```

`scripts/register-schedule.ps1`
```powershell
$run = Join-Path $PSScriptRoot 'run.ps1'
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable
foreach ($t in @(
        @{ Name = 'work-reporter-morning'; At = '08:55'; Mode = 'morning' },
        @{ Name = 'work-reporter-evening'; At = '17:00'; Mode = 'evening' })) {
    $action = New-ScheduledTaskAction -Execute 'powershell.exe' `
        -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$run`" -Mode $($t.Mode)"
    $trigger = New-ScheduledTaskTrigger -Daily -At $t.At
    Register-ScheduledTask -TaskName $t.Name -Action $action -Trigger $trigger -Settings $settings -Force | Out-Null
    Write-Output "registered $($t.Name) at $($t.At)"
}
```

自動実行のしくみ：
- `dontAsk` モードで動くため、許可されていない操作はすべて止まります。書き込めるのは Kintone の週報と `state.json` だけです。
- 止めるとき：`Unregister-ScheduledTask -TaskName work-reporter-morning, work-reporter-evening -Confirm:$false`

## 8. 完了
「準備できました。`/digest` を試してください。」と伝えます。
