# Driver that runs every exercise and saves output for submission.
# Usage:  pwsh -File submission/run_all.ps1
#
# Prereqs: .env filled in (OPENROUTER_API_KEY, GITHUB_TOKEN, GITHUB_USER), `uv sync` done.

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root
$out = Join-Path $root "submission\logs"
New-Item -ItemType Directory -Force -Path $out | Out-Null

$PR1 = "https://github.com/VinUni-AI20k/PR-Demo/pull/1"
$PR2 = "https://github.com/VinUni-AI20k/PR-Demo/pull/2"

Write-Host "=== Ex1 routing — PR#1 ===" -ForegroundColor Cyan
uv run python exercises/exercise_1_confidence.py --pr $PR1 *> "$out\ex1_pr1.log"
Write-Host "=== Ex1 routing — PR#2 ===" -ForegroundColor Cyan
uv run python exercises/exercise_1_confidence.py --pr $PR2 *> "$out\ex1_pr2.log"

Write-Host "`nExercises 2, 3, 4 are interactive (the agent will pause and ask)."
Write-Host "Run them by hand and copy-paste the terminal into submission/logs/."
Write-Host "Suggested commands:`n"
Write-Host "  uv run python exercises/exercise_2_hitl.py --pr $PR1"
Write-Host "  uv run python exercises/exercise_3_escalation.py --pr $PR2"
Write-Host "  uv run python exercises/exercise_4_audit.py --pr $PR1"
Write-Host "  uv run python exercises/exercise_4_audit.py --pr $PR2"

Write-Host "`nAfter Ex4, capture replay:`n"
Write-Host "  uv run python -m audit.replay --list  *> submission\logs\replay_list.log"
Write-Host "  uv run python -m audit.replay --thread <ID>  *> submission\logs\replay_thread.log"

Write-Host "`nSQL sanity check:`n"
Write-Host "  sqlite3 hitl_audit.db `".read submission\verify.sql`" *> submission\logs\sql_check.log"
