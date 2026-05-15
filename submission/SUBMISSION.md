# Day27 Track 3 — HITL PR Review Agent — Submission

**Student:** Phạm Hữu Hoàng Hiệp — 2A202600415  &nbsp;·&nbsp; **GitHub:** `hoanghiepbk`
**Date:** 2026-05-15

**Threads in audit DB:**
- PR#1 (human_approval → approve → commit): `3acd67ac-f743-495b-bb6e-13ab55d69852` — 7 events
- PR#2 (escalate → synthesize → commit):     `df70a20e-08b7-4443-a0c1-64139b2e3fe0` — 8 events

---

## 1. Exercises completed

| # | File | Status | Notes |
|---|------|--------|-------|
| 1 | `exercises/exercise_1_confidence.py` | DONE | LLM + with_structured_output(PRAnalysis); 3-way routing |
| 2 | `exercises/exercise_2_hitl.py`       | DONE | `interrupt(approval_request)` + `MemorySaver` + resume loop |
| 3 | `exercises/exercise_3_escalation.py` | DONE | escalation Q&A + `node_synthesize` re-prompt |
| 4 | `exercises/exercise_4_audit.py`      | DONE | `AsyncSqliteSaver` + 10 `AuditEntry` rows per session |
| 5 | `app.py` (Streamlit UI)              | DONE | Approval card / Escalation form / Recent sessions sidebar |

## 2. Evidence — terminal logs (under `submission/logs/`)

| Artefact | File |
|----------|------|
| Ex1 PR#1 — routes to `human_approval` | `logs/ex1_pr1.log` |
| Ex1 PR#2 — routes to `escalate`       | `logs/ex1_pr2.log` |
| Ex2 PR#1 interactive session          | `logs/ex2_pr1.log` |
| Ex3 PR#2 escalation Q&A               | `logs/ex3_pr2.log` |
| Ex4 PR#1 + PR#2 with audit            | `logs/ex4_pr1.log`, `logs/ex4_pr2.log` |
| `audit.replay --list`                 | `logs/replay_list.log` |
| `audit.replay --thread <escalate>`    | `logs/replay_thread_escalate.log` |
| `audit.replay --thread <approval>`    | `logs/replay_thread_approval.log` |
| SQL sanity check (`verify.sql`)       | `logs/sql_check.log` |

## 3. Evidence — GitHub PR comments posted by the agent

| PR | Branch fired | Comment URL |
|----|--------------|-------------|
| #1 | human_approval (approve) | https://github.com/VinUni-AI20k/PR-Demo/pull/1#issuecomment-4457691800 |
| #2 | escalate → synthesize    | https://github.com/VinUni-AI20k/PR-Demo/pull/2#issuecomment-4457697070 |

## 4. Evidence — Streamlit UI (under `submission/screenshots/`)

- [x] `streamlit_pr1_approval_card.png` — PR#1 50–72% bucket; Approve/Reject/Edit buttons
- [x] `streamlit_pr2_escalation_form.png` — PR#2 <50% bucket; risk factors + question form
- [ ] `streamlit_sidebar_sessions.png` — _optional_ recent sessions sidebar
- [ ] `streamlit_pr1_committed.png` — _optional_ success state after Approve

## 5. Self-verification checklist

- [x] `python -m py_compile exercises/*.py app.py` — no syntax errors
- [x] Ex1 prints **different** branches for PR#1 (human_approval @ 50%) vs PR#2 (escalate @ 30%)
- [x] Ex2/Ex4 pauses on `interrupt()` and resumes after `Command(resume=...)` (PR#1 thread shows it)
- [x] Ex3/Ex4 LLM populated 4 escalation_questions on PR#2 (see logs/ex4_pr2.log)
- [x] Ex4 emits 7 events for PR#1 and 8 for PR#2 (`fetch_pr → analyze → route → … → commit`)
- [x] SQL invariant `WHERE risk_level='high' AND decision='auto'` returns **0 rows** (see logs/sql_check.log)
- [x] Streamlit UI renders Approval card (PR#1) and Escalation form (PR#2) — see screenshots
- [x] `.env` is NOT committed (`git status` confirms — `.env` is gitignored)

## 6. Implementation notes

- **Thresholds** (`common/schemas.py`): `AUTO_APPROVE_THRESHOLD = 0.73`, `ESCALATE_THRESHOLD = 0.58` (kept default).
- **Audit pattern**: every node measures `t0 = time.monotonic()` and emits exactly one
  `AuditEntry`; HITL nodes (`human_approval`, `escalate`) emit **two** rows — one
  before `interrupt()` (decision=`pending`/`escalate`, no reviewer) and one after
  resume (decision=reviewer choice, `reviewer_id=$GITHUB_USER`).
- **Reviewer identity**: read from `os.environ["GITHUB_USER"]`.
- **System prompt for escalation**: explicitly instructs the LLM to populate
  `escalation_questions` with 2–4 file-anchored questions when confidence < 0.60.
- **Streamlit graph reuse**: imports `build_graph` from
  `exercises/exercise_4_audit.py` so all 4 exercise behaviours (routing + HITL +
  escalation + audit) drive the UI.

## 7. Bonus (optional)

- [ ] Time-travel via `app.aget_state_history(cfg)`
- [ ] Confidence calibration query / chart
- [ ] Multi-reviewer fan-out with `Send`
- [ ] Auto-edit branch when reviewer chooses `edit`

_(Tick boxes for whichever you implemented; otherwise leave blank.)_
