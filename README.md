# work-reporter

Backlog・GitHub・git の作業を Claude Code が集めて、Kintone の週報に書き込みます。

## はじめ方
```
git clone https://github.com/khoa-astec/work-reporter
cd work-reporter
claude
```
`/setup` と入力してください。必要なキーの取り方と設定方法を、1つずつ案内します。

## 使い方
| コマンド | すること |
|---|---|
| `/morning` | 今日の目標を週報に書く |
| `/daily` | 今日の実績を週報に書く |
| `/digest` | 前回以降の変更を見るだけ（何も書かない） |
| `/points 2026-10` | その月のポイント申請を下書きする |
| `/setup` | 設定の確認・やり直し |

## 例
- 朝：`/morning` → 目標が週報に入る
- 夕方：`/daily` → 実績が週報に入り、Backlog の更新案も出る
- 月末：`/points 2026-10` → 申請案を確認し、「1〜3 申請して」と返す

## ルール
- 週報の「今日の目標」「今日の業務」以外への書き込みは、毎回確認してから行います。
- 自動実行（Windows、毎日 8:55・17:00）は `/setup` で設定できます。自動実行で書けるのは週報だけです。
- キーはチャットに貼らず、ターミナルで `setx` を使って設定します。
