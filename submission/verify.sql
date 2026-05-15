-- Sanity-check queries on the audit trail.
-- Run with: sqlite3 hitl_audit.db ".read submission/verify.sql"

.headers on
.mode column

SELECT '--- All recent events ---' AS section;
SELECT id, action, ROUND(confidence, 2) AS conf, risk_level,
       decision, reviewer_id, execution_time_ms AS ms
  FROM audit_events
 ORDER BY id DESC
 LIMIT 30;

SELECT '--- Threads summary ---' AS section;
SELECT thread_id,
       pr_url,
       COUNT(*)         AS events,
       MAX(risk_level)  AS worst_risk,
       MIN(timestamp)   AS started,
       MAX(timestamp)   AS last_event
  FROM audit_events
 GROUP BY thread_id, pr_url
 ORDER BY MAX(timestamp) DESC;

SELECT '--- Invariant: high-risk PR must NOT auto-approve (should be EMPTY) ---' AS section;
SELECT * FROM audit_events
 WHERE risk_level = 'high' AND decision = 'auto';

SELECT '--- Avg confidence by decision ---' AS section;
SELECT decision,
       COUNT(*)                       AS n,
       ROUND(AVG(confidence), 3)      AS avg_conf
  FROM audit_events
 GROUP BY decision
 ORDER BY avg_conf DESC;

SELECT '--- Routing histogram ---' AS section;
SELECT decision, COUNT(*) AS n
  FROM audit_events
 WHERE action = 'route'
 GROUP BY decision;

SELECT '--- HITL events (reviewer involved) ---' AS section;
SELECT action, decision, reviewer_id, ROUND(confidence,2) AS conf, reason
  FROM audit_events
 WHERE reviewer_id IS NOT NULL
 ORDER BY id;
