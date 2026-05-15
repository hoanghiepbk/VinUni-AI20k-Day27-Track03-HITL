# Submission folder

Everything the grader needs is here.

- `SUBMISSION.md` — the main report (fill in PR URLs + tick boxes).
- `run_all.ps1` — driver that runs Ex1 non-interactively and prints commands for Ex2–4.
- `verify.sql` — sanity SQL queries over `audit_events`.
- `logs/` — terminal output captured by `run_all.ps1` and by you for the interactive exercises.
- `screenshots/` — PNG captures of the Streamlit UI.

## How to populate this folder

```powershell
# 1. Fill in .env first (OPENROUTER_API_KEY, GITHUB_TOKEN, GITHUB_USER)
uv sync

# 2. Non-interactive runs
pwsh -File submission\run_all.ps1

# 3. Interactive exercises — copy terminal into the matching log file
uv run python exercises/exercise_2_hitl.py --pr https://github.com/VinUni-AI20k/PR-Demo/pull/1 | Tee-Object submission\logs\ex2_pr1.log
uv run python exercises/exercise_3_escalation.py --pr https://github.com/VinUni-AI20k/PR-Demo/pull/2 | Tee-Object submission\logs\ex3_pr2.log
uv run python exercises/exercise_4_audit.py --pr https://github.com/VinUni-AI20k/PR-Demo/pull/1 | Tee-Object submission\logs\ex4_pr1.log
uv run python exercises/exercise_4_audit.py --pr https://github.com/VinUni-AI20k/PR-Demo/pull/2 | Tee-Object submission\logs\ex4_pr2.log

# 4. Replay + SQL
uv run python -m audit.replay --list *> submission\logs\replay_list.log
uv run python -m audit.replay --thread <ID> *> submission\logs\replay_thread_escalate.log
sqlite3 hitl_audit.db ".read submission/verify.sql" *> submission\logs\sql_check.log

# 5. Streamlit + screenshots
uv run streamlit run app.py
#    capture: approval card, escalation form, sidebar, success state
```
