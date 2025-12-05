-- =============================================
-- PHASE VII: COMPLETE TRIGGER CODE
-- =============================================

-- 1. RESTRICTION CHECK FUNCTION
CREATE OR REPLACE FUNCTION check_dml_allowed(
    p_table_name IN VARCHAR2 DEFAULT NULL
) RETURN VARCHAR2 IS
    v_day_of_week      VARCHAR2(20);
    v_is_public_holiday CHAR(1) := 'N';
    v_current_month    NUMBER;
    v_current_year     NUMBER;
    v_message          VARCHAR2(500);
    v_holiday_name     VARCHAR2(100);
BEGIN
    v_day_of_week := TRIM(TO_CHAR(SYSDATE, 'DAY'));
    v_current_month := EXTRACT(MONTH FROM SYSDATE);
    v_current_year := EXTRACT(YEAR FROM SYSDATE);
    
    IF v_day_of_week IN ('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY') THEN
        BEGIN
            SELECT 'Y', holiday_name 
            INTO v_is_public_holiday, v_holiday_name
            FROM holidays
            WHERE holiday_date = TRUNC(SYSDATE)
              AND is_public_holiday = 'Y';
              
            v_message := 'Today is ' || v_day_of_week || ' and a PUBLIC HOLIDAY (' || v_holiday_name || ')';
            RETURN 'DENIED:HOLIDAY:' || v_message;
                        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_message := 'Today is ' || v_day_of_week || ' (weekday)';
                RETURN 'DENIED:WEEKDAY:' || v_message;
        END;
        
    ELSE
        v_message := 'Today is ' || v_day_of_week || ' (weekend)';
        
        BEGIN
            SELECT 'Y', holiday_name 
            INTO v_is_public_holiday, v_holiday_name
            FROM holidays
            WHERE holiday_date = TRUNC(SYSDATE)
              AND is_public_holiday = 'Y';
            
            RETURN 'DENIED:HOLIDAY:' || v_message || ' but PUBLIC HOLIDAY (' || v_holiday_name || ')';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN 'ALLOWED:WEEKEND:' || v_message;
        END;
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'ERROR:' || SQLERRM;
END check_dml_allowed;
/

-- 2. AUDIT LOGGING PROCEDURE
CREATE OR REPLACE PROCEDURE proc_audit_event(
    p_table_name      IN VARCHAR2,
    p_operation_type  IN VARCHAR2,
    p_status          IN VARCHAR2,
    p_error_message   IN VARCHAR2 DEFAULT NULL,
    p_old_values      IN CLOB DEFAULT NULL,
    p_new_values      IN CLOB DEFAULT NULL
) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    v_audit_id NUMBER;
BEGIN
    SELECT seq_audit_log.NEXTVAL INTO v_audit_id FROM dual;
    
    INSERT INTO audit_log (
        audit_id,
        table_name,
        operation_type,
        operation_date,
        user_name,
        status,
        error_message,
        old_values,
        new_values,
        ip_address,
        session_id,
        program_name,
        module_name
    ) VALUES (
        v_audit_id,
        p_table_name,
        p_operation_type,
        SYSTIMESTAMP,
        USER,
        p_status,
        p_error_message,
        p_old_values,
        p_new_values,
        SYS_CONTEXT('USERENV', 'IP_ADDRESS'),
        SYS_CONTEXT('USERENV', 'SESSIONID'),
        SYS_CONTEXT('USERENV', 'MODULE'),
        SYS_CONTEXT('USERENV', 'ACTION')
    );
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Audit logging failed: ' || SQLERRM);
END proc_audit_event;
/

-- 3. SIMPLE TRIGGER FOR EVENTS
CREATE OR REPLACE TRIGGER trg_events_dml_restriction
BEFORE INSERT OR UPDATE OR DELETE ON events
FOR EACH ROW
DECLARE
    v_check_result VARCHAR2(500);
    v_operation    VARCHAR2(10);
BEGIN
    v_operation := CASE
        WHEN INSERTING THEN 'INSERT'
        WHEN UPDATING THEN 'UPDATE'
        WHEN DELETING THEN 'DELETE'
    END;
    
    v_check_result := check_dml_allowed('EVENTS');
    
    IF v_check_result LIKE 'DENIED:%' THEN
        proc_audit_event(
            p_table_name => 'EVENTS',
            p_operation_type => v_operation,
            p_status => 'DENIED',
            p_error_message => SUBSTR(v_check_result, INSTR(v_check_result, ':') + 1),
            p_old_values => CASE 
                WHEN :OLD.event_id IS NOT NULL THEN 
                    'Event ID: ' || :OLD.event_id
                ELSE NULL 
            END,
            p_new_values => CASE 
                WHEN :NEW.event_id IS NOT NULL THEN 
                    'Event ID: ' || :NEW.event_id
                ELSE NULL 
            END
        );
        
        RAISE_APPLICATION_ERROR(-20001, 
            'DML Operation ' || v_operation || ' on EVENTS table is NOT ALLOWED. ' ||
            'Reason: ' || SUBSTR(v_check_result, INSTR(v_check_result, ':') + 1));
    END IF;
END;
/

-- 4. SIMPLE TRIGGER FOR EXPENSE_CATEGORIES
CREATE OR REPLACE TRIGGER trg_categories_dml_restriction
BEFORE INSERT OR UPDATE OR DELETE ON expense_categories
FOR EACH ROW
DECLARE
    v_check_result VARCHAR2(500);
BEGIN
    v_check_result := check_dml_allowed('EXPENSE_CATEGORIES');
    
    IF v_check_result LIKE 'DENIED:%' THEN
        proc_audit_event(
            p_table_name => 'EXPENSE_CATEGORIES',
            p_operation_type => CASE
                WHEN INSERTING THEN 'INSERT'
                WHEN UPDATING THEN 'UPDATE'
                WHEN DELETING THEN 'DELETE'
            END,
            p_status => 'DENIED',
            p_error_message => SUBSTR(v_check_result, INSTR(v_check_result, ':') + 1),
            p_old_values => CASE 
                WHEN :OLD.category_id IS NOT NULL THEN 
                    'Category ID: ' || :OLD.category_id
                ELSE NULL 
            END
        );
        
        RAISE_APPLICATION_ERROR(-20002, 
            'Category operation DENIED. Reason: ' || 
            SUBSTR(v_check_result, INSTR(v_check_result, ':') + 1));
    END IF;
END;
/

-- 5. SIMPLE TRIGGER FOR EXPENSES
CREATE OR REPLACE TRIGGER trg_expenses_dml_restriction
BEFORE INSERT OR UPDATE OR DELETE ON expenses
FOR EACH ROW
DECLARE
    v_check_result VARCHAR2(500);
BEGIN
    v_check_result := check_dml_allowed('EXPENSES');
    
    IF v_check_result LIKE 'DENIED:%' THEN
        proc_audit_event(
            p_table_name => 'EXPENSES',
            p_operation_type => CASE
                WHEN INSERTING THEN 'INSERT'
                WHEN UPDATING THEN 'UPDATE'
                WHEN DELETING THEN 'DELETE'
            END,
            p_status => 'DENIED',
            p_error_message => SUBSTR(v_check_result, INSTR(v_check_result, ':') + 1),
            p_old_values => CASE 
                WHEN :OLD.expense_id IS NOT NULL THEN 
                    'Expense ID: ' || :OLD.expense_id
                ELSE NULL 
            END
        );
        
        RAISE_APPLICATION_ERROR(-20003, 
            'Expense operation DENIED. Reason: ' || 
            SUBSTR(v_check_result, INSTR(v_check_result, ':') + 1));
    END IF;
END;
/

-- 6. COMPOUND TRIGGER FOR EXPENSES AUDITING
CREATE OR REPLACE TRIGGER trg_compound_expenses_audit
FOR INSERT OR UPDATE OR DELETE ON expenses
COMPOUND TRIGGER

    TYPE audit_rec IS RECORD (
        operation VARCHAR2(10),
        expense_id NUMBER,
        old_amount NUMBER,
        new_amount NUMBER,
        category_id NUMBER
    );
    
    TYPE audit_table IS TABLE OF audit_rec;
    g_audit_data audit_table := audit_table();
    
    BEFORE STATEMENT IS
    BEGIN
        g_audit_data := audit_table();
    END BEFORE STATEMENT;
    
    AFTER EACH ROW IS
    BEGIN
        g_audit_data.EXTEND;
        g_audit_data(g_audit_data.LAST).operation := 
            CASE 
                WHEN INSERTING THEN 'INSERT'
                WHEN UPDATING THEN 'UPDATE' 
                WHEN DELETING THEN 'DELETE'
            END;
        g_audit_data(g_audit_data.LAST).expense_id := 
            COALESCE(:NEW.expense_id, :OLD.expense_id);
        g_audit_data(g_audit_data.LAST).old_amount := :OLD.amount;
        g_audit_data(g_audit_data.LAST).new_amount := :NEW.amount;
        g_audit_data(g_audit_data.LAST).category_id := 
            COALESCE(:NEW.category_id, :OLD.category_id);
    END AFTER EACH ROW;
    
    AFTER STATEMENT IS
    BEGIN
        FOR i IN 1..g_audit_data.COUNT LOOP
            proc_audit_event(
                p_table_name => 'EXPENSES',
                p_operation_type => g_audit_data(i).operation,
                p_status => 'SUCCESS',
                p_old_values => 
                    CASE WHEN g_audit_data(i).old_amount IS NOT NULL THEN
                        'Expense ID: ' || g_audit_data(i).expense_id ||
                        ', Old Amount: ' || g_audit_data(i).old_amount
                    END,
                p_new_values => 
                    CASE WHEN g_audit_data(i).new_amount IS NOT NULL THEN
                        'Expense ID: ' || g_audit_data(i).expense_id ||
                        ', New Amount: ' || g_audit_data(i).new_amount
                    END
            );
        END LOOP;
    END AFTER STATEMENT;
    
END trg_compound_expenses_audit;
/

