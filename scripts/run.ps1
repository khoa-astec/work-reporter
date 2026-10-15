# Headless run for Task Scheduler: morning = /morning (goals), evening = /daily (results).
# dontAsk denies anything not pre-approved; only the Kintone write and state.json are added here.
param([Parameter(Mandatory)][ValidateSet('morning', 'evening')][string]$Mode)

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root
New-Item -ItemType Directory -Force -Path logs | Out-Null

$prompt = @{ morning = '/morning'; evening = '/daily' }[$Mode]
$log = Join-Path logs ("{0}-{1}.log" -f (Get-Date -Format 'yyyy-MM-dd'), $Mode)

claude -p $prompt --permission-mode dontAsk --allowedTools 'mcp__claude_ai_Kintone_MCP__updateRecord' 'Edit(./state.json)' *>> $log
