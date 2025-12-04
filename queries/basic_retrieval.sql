-- =============================================
-- BASIC RETRIEVAL QUERIES (SELECT *)
-- Phase V Requirement: Basic retrieval from all tables
-- =============================================

-- Simple count of all tables
SELECT 'EVENTS count: ' || COUNT(*) FROM events;
SELECT 'EXPENSE_CATEGORIES count: ' || COUNT(*) FROM expense_categories;
SELECT 'EXPENSES count: ' || COUNT(*) FROM expenses;
SELECT 'HOLIDAYS count: ' || COUNT(*) FROM holidays;
SELECT 'AUDIT_LOG count: ' || COUNT(*) FROM audit_log;

-- Detailed SELECT * from each table (first 3 rows)
SELECT '=== EVENTS TABLE (first 3 rows) ===' FROM dual;
SELECT * FROM events WHERE ROWNUM <= 3 ORDER BY event_id;

SELECT '=== EXPENSE_CATEGORIES TABLE (first 3 rows) ===' FROM dual;
SELECT * FROM expense_categories WHERE ROWNUM <= 3 ORDER BY category_id;

SELECT '=== EXPENSES TABLE (first 3 rows) ===' FROM dual;
SELECT * FROM expenses WHERE ROWNUM <= 3 ORDER BY expense_id;

SELECT '=== HOLIDAYS TABLE (first 3 rows) ===' FROM dual;
SELECT * FROM holidays WHERE ROWNUM <= 3 ORDER BY holiday_id;

SELECT '=== AUDIT_LOG TABLE (first 3 rows) ===' FROM dual;
SELECT * FROM audit_log WHERE ROWNUM <= 3 ORDER BY audit_id;

-- Verification that all tables have data
SELECT 'VERIFICATION: All tables contain data' AS status FROM dual
WHERE (SELECT COUNT(*) FROM events) > 0
AND (SELECT COUNT(*) FROM expense_categories) > 0
AND (SELECT COUNT(*) FROM expenses) > 0
AND (SELECT COUNT(*) FROM holidays) > 0
AND (SELECT COUNT(*) FROM audit_log) > 0;
