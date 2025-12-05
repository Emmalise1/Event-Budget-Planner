-- =============================================
-- PHASE VI: PACKAGES IMPLEMENTATION
-- Event Budget Planner System
-- Student: Emma Lise IZA KURADUSENGE (ID: 28246)
-- =============================================

SET SERVEROUTPUT ON;

-- =============================================
-- PACKAGE 1: BUDGET_MANAGEMENT_PKG (SPECIFICATION)
-- Public interface for budget-related operations
-- =============================================

CREATE OR REPLACE PACKAGE budget_management_pkg AS
    -- TYPE declarations (public)
    TYPE expense_summary_rec IS RECORD (
        category_id   NUMBER,
        category_name VARCHAR2(100),
        budget_limit  NUMBER,
        spent_amount  NUMBER,
        remaining     NUMBER,
        utilization   NUMBER
    );
    
    TYPE expense_summary_tab IS TABLE OF expense_summary_rec;
    
    -- CONSTANT declarations (public)
    g_max_budget CONSTANT NUMBER := 100000000; -- 100 million RWF
    
    -- EXCEPTION declarations (public)
    budget_exceeded EXCEPTION;
    invalid_category EXCEPTION;
    PRAGMA EXCEPTION_INIT(budget_exceeded, -20001);
    PRAGMA EXCEPTION_INIT(invalid_category, -20002);
    
    -- PROCEDURE declarations (public interface)
    PROCEDURE add_expense(
        p_category_id   IN NUMBER,
        p_description   IN VARCHAR2,
        p_amount        IN NUMBER,
        p_vendor_name   IN VARCHAR2 DEFAULT NULL
    );
    
    PROCEDURE update_expense(
        p_expense_id    IN NUMBER,
        p_new_amount    IN NUMBER DEFAULT NULL,
        p_new_status    IN VARCHAR2 DEFAULT NULL
    );
    
    PROCEDURE delete_expense(
        p_expense_id    IN NUMBER
    );
    
    -- FUNCTION declarations (public interface)
    FUNCTION calculate_remaining_budget(
        p_category_id IN NUMBER
    ) RETURN NUMBER;
    
    FUNCTION get_category_summary(
        p_event_id IN NUMBER
    ) RETURN expense_summary_tab PIPELINED;
    
    FUNCTION check_budget_health(
        p_event_id IN NUMBER
    ) RETURN VARCHAR2;
    
    -- Overloaded function (polymorphism)
    FUNCTION calculate_utilization(
        p_category_id IN NUMBER
    ) RETURN NUMBER;
    
    FUNCTION calculate_utilization(
        p_event_id IN NUMBER
    ) RETURN NUMBER;
    
    -- CURSOR declaration (public)
    CURSOR get_top_expenses(
        p_event_id IN NUMBER,
        p_limit    IN NUMBER DEFAULT 10
    ) RETURN expense_summary_rec;
    
END budget_management_pkg;
/

-- =============================================
-- PACKAGE 2: REPORTING_PKG (SPECIFICATION)
-- Public interface for reporting operations
-- =============================================

CREATE OR REPLACE PACKAGE reporting_pkg AS
    -- TYPE for returning report data
    TYPE report_line_rec IS RECORD (
        line_number NUMBER,
        line_text   VARCHAR2(500)
    );
    
    TYPE report_table IS TABLE OF report_line_rec;
    
    -- PROCEDURES for different report types
    PROCEDURE generate_budget_report(
        p_event_id     IN NUMBER,
        p_report_level IN VARCHAR2 DEFAULT 'SUMMARY'
    );
    
    PROCEDURE generate_financial_summary(
        p_start_date IN DATE DEFAULT NULL,
        p_end_date   IN DATE DEFAULT NULL
    );
    
    PROCEDURE generate_vendor_analysis(
        p_min_transactions IN NUMBER DEFAULT 1
    );
    
    -- FUNCTIONS returning data
    FUNCTION get_event_performance(
        p_event_id IN NUMBER
    ) RETURN report_table PIPELINED;
    
    FUNCTION get_monthly_summary(
        p_year IN NUMBER DEFAULT EXTRACT(YEAR FROM SYSDATE)
    ) RETURN report_table PIPELINED;
    
    -- Function to check package status
    FUNCTION get_package_info RETURN VARCHAR2;
    
END reporting_pkg;
/

-- =============================================
-- PACKAGE 3: AUDIT_SECURITY_PKG (SPECIFICATION)
-- Public interface for audit and security
-- =============================================

CREATE OR REPLACE PACKAGE audit_security_pkg AS
    -- Constants for security levels
    SECURITY_LEVEL_LOW    CONSTANT NUMBER := 1;
    SECURITY_LEVEL_MEDIUM CONSTANT NUMBER := 2;
    SECURITY_LEVEL_HIGH   CONSTANT NUMBER := 3;
    
    -- Audit procedures
    PROCEDURE log_operation(
        p_table_name    IN VARCHAR2,
        p_operation     IN VARCHAR2,
        p_record_id     IN VARCHAR2 DEFAULT NULL,
        p_description   IN VARCHAR2 DEFAULT NULL
    );
    
    PROCEDURE log_error(
        p_procedure_name IN VARCHAR2,
        p_error_message  IN VARCHAR2,
        p_error_code     IN NUMBER DEFAULT NULL
    );
    
    -- Security procedures
    PROCEDURE check_access_permission(
        p_user_name    IN VARCHAR2,
        p_operation    IN VARCHAR2
    ) RETURN BOOLEAN;
    
    PROCEDURE encrypt_sensitive_data(
        p_plain_text  IN VARCHAR2,
        p_encrypted   OUT VARCHAR2
    );
    
    -- Maintenance procedures
    PROCEDURE cleanup_old_logs(
        p_days_to_keep IN NUMBER DEFAULT 90
    );
    
    PROCEDURE backup_audit_trail;
    
    -- Utility functions
    FUNCTION get_audit_count(
        p_days_back IN NUMBER DEFAULT 7
    ) RETURN NUMBER;
    
    FUNCTION is_operation_allowed(
        p_user_name IN VARCHAR2,
        p_table     IN VARCHAR2,
        p_operation IN VARCHAR2
    ) RETURN BOOLEAN;
    
END audit_security_pkg;
/

-- =============================================
-- VERIFICATION: PACKAGE SPECIFICATIONS CREATED
-- =============================================

SELECT 'PACKAGE SPECIFICATIONS CREATED SUCCESSFULLY' as status FROM dual
UNION ALL
SELECT '==========================================' FROM dual
UNION ALL
SELECT ' ' FROM dual
UNION ALL
SELECT '1. BUDGET_MANAGEMENT_PKG - Budget operations' FROM dual
UNION ALL
SELECT '2. REPORTING_PKG - Reporting and analytics' FROM dual
UNION ALL
SELECT '3. AUDIT_SECURITY_PKG - Audit and security' FROM dual
UNION ALL
SELECT ' ' FROM dual
UNION ALL
SELECT 'All package specifications compiled ✓' FROM dual;
