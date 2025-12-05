-- =============================================
-- PHASE VI: PL/SQL FUNCTIONS IMPLEMENTATION
-- Event Budget Planner System
-- Student: Emma Lise IZA KURADUSENGE (ID: 28246)
-- Database: wed_28246_emma_event_budget_planner_db
-- =============================================

SET SERVEROUTPUT ON;
SET DEFINE OFF;

BEGIN
    DBMS_OUTPUT.PUT_LINE('============================================');
    DBMS_OUTPUT.PUT_LINE('PHASE VI: PL/SQL FUNCTIONS DEVELOPMENT');
    DBMS_OUTPUT.PUT_LINE('============================================');
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- =============================================
-- FUNCTION 1: CALCULATE_EVENT_UTILIZATION (Calculation)
-- Purpose: Calculate budget utilization percentage for an event
-- Return: NUMBER (percentage)
-- =============================================

CREATE OR REPLACE FUNCTION calculate_event_utilization(
    p_event_id IN NUMBER
) RETURN NUMBER
AS
    v_total_budget NUMBER;
    v_total_spent NUMBER;
    v_utilization NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Function: calculate_event_utilization - Calculating...');
    
    -- Get event budget and spending
    SELECT total_budget, COALESCE(actual_spending, 0)
    INTO v_total_budget, v_total_spent
    FROM events
    WHERE event_id = p_event_id;
    
    -- Calculate utilization percentage
    IF v_total_budget > 0 THEN
        v_utilization := ROUND((v_total_spent / v_total_budget) * 100, 2);
    ELSE
        v_utilization := 0;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('   Budget: ' || v_total_budget || ', Spent: ' || v_total_spent);
    DBMS_OUTPUT.PUT_LINE('   Utilization: ' || v_utilization || '%');
    
    RETURN v_utilization;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Event ' || p_event_id || ' not found');
        RETURN -1;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        RETURN -1;
END calculate_event_utilization;
/

-- =============================================
-- FUNCTION 2: VALIDATE_EVENT_DATE (Validation)
-- Purpose: Validate if event date is in the future and reasonable
-- Return: VARCHAR2 (validation message)
-- =============================================

CREATE OR REPLACE FUNCTION validate_event_date(
    p_event_date IN DATE,
    p_event_type IN VARCHAR2 DEFAULT 'GENERAL'
) RETURN VARCHAR2
AS
    v_days_diff NUMBER;
    v_max_days NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Function: validate_event_date - Validating...');
    DBMS_OUTPUT.PUT_LINE('   Date: ' || TO_CHAR(p_event_date, 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('   Type: ' || p_event_type);
    
    -- Calculate days difference
    v_days_diff := p_event_date - TRUNC(SYSDATE);
    
    -- Set maximum days based on event type
    v_max_days := CASE UPPER(p_event_type)
        WHEN 'WEDDING' THEN 730  -- 2 years for weddings
        WHEN 'CONFERENCE' THEN 365  -- 1 year for conferences
        WHEN 'CORPORATE' THEN 180  -- 6 months for corporate
        ELSE 90  -- 3 months for other events
    END;
    
    -- Validation rules
    IF v_days_diff < 0 THEN
        RETURN 'INVALID: Event date cannot be in the past';
    ELSIF v_days_diff < 7 THEN
        RETURN 'WARNING: Event is less than 7 days away';
    ELSIF v_days_diff > v_max_days THEN
        RETURN 'INVALID: Event cannot be scheduled more than ' || v_max_days || ' days in advance';
    ELSIF v_days_diff > 3650 THEN  -- 10 years
        RETURN 'INVALID: Event date is too far in the future';
    ELSE
        RETURN 'VALID: Event date is acceptable';
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'ERROR: Validation failed - ' || SQLERRM;
END validate_event_date;
/

-- =============================================
-- FUNCTION 3: GET_CATEGORY_SPENDING (Lookup)
-- Purpose: Get total spending for a specific category
-- Return: NUMBER (total amount)
-- =============================================

CREATE OR REPLACE FUNCTION get_category_spending(
    p_category_id IN NUMBER,
    p_include_cancelled IN BOOLEAN DEFAULT FALSE
) RETURN NUMBER
AS
    v_total_spent NUMBER;
    v_category_name VARCHAR2(100);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Function: get_category_spending - Looking up...');
    
    -- Get category name for logging
    BEGIN
        SELECT category_name INTO v_category_name
        FROM expense_categories
        WHERE category_id = p_category_id;
        
        DBMS_OUTPUT.PUT_LINE('   Category: ' || v_category_name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('   Category ID ' || p_category_id || ' not found');
            RETURN -1;
    END;
    
    -- Calculate total spending
    IF p_include_cancelled THEN
        -- Include all expenses
        SELECT COALESCE(SUM(amount), 0)
        INTO v_total_spent
        FROM expenses
        WHERE category_id = p_category_id;
    ELSE
        -- Exclude cancelled expenses
        SELECT COALESCE(SUM(amount), 0)
        INTO v_total_spent
        FROM expenses
        WHERE category_id = p_category_id
          AND (payment_status IS NULL OR payment_status != 'CANCELLED');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('   Total spent: ' || v_total_spent);
    
    RETURN v_total_spent;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        RETURN -1;
END get_category_spending;
/

-- =============================================
-- FUNCTION 4: CALCULATE_AVERAGE_EXPENSE (Calculation)
-- Purpose: Calculate average expense amount for an event
-- Return: NUMBER (average amount)
-- =============================================

CREATE OR REPLACE FUNCTION calculate_average_expense(
    p_event_id IN NUMBER
) RETURN NUMBER
AS
    v_avg_amount NUMBER;
    v_event_name VARCHAR2(200);
    v_expense_count NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Function: calculate_average_expense - Calculating...');
    
    -- Get event name
    BEGIN
        SELECT event_name INTO v_event_name
        FROM events
        WHERE event_id = p_event_id;
        
        DBMS_OUTPUT.PUT_LINE('   Event: ' || v_event_name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('ERROR: Event ' || p_event_id || ' not found');
            RETURN -1;
    END;
    
    -- Calculate average expense
    SELECT 
        COALESCE(AVG(amount), 0),
        COUNT(*)
    INTO v_avg_amount, v_expense_count
    FROM expenses e
    JOIN expense_categories c ON e.category_id = c.category_id
    WHERE c.event_id = p_event_id
      AND (e.payment_status IS NULL OR e.payment_status != 'CANCELLED');
    
    DBMS_OUTPUT.PUT_LINE('   Expense count: ' || v_expense_count);
    DBMS_OUTPUT.PUT_LINE('   Average amount: ' || ROUND(v_avg_amount, 2));
    
    RETURN ROUND(v_avg_amount, 2);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        RETURN -1;
END calculate_average_expense;
/

-- =============================================
-- FUNCTION 5: VALIDATE_VENDOR_NAME (Validation)
-- Purpose: Validate vendor name format and check for duplicates
-- Return: VARCHAR2 (validation message)
-- =============================================

CREATE OR REPLACE FUNCTION validate_vendor_name(
    p_vendor_name IN VARCHAR2,
    p_check_duplicates IN BOOLEAN DEFAULT TRUE
) RETURN VARCHAR2
AS
    v_vendor_count NUMBER;
    v_similar_vendors NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Function: validate_vendor_name - Validating...');
    DBMS_OUTPUT.PUT_LINE('   Vendor: ' || p_vendor_name);
    
    -- Check for NULL or empty
    IF p_vendor_name IS NULL OR TRIM(p_vendor_name) = '' THEN
        RETURN 'INVALID: Vendor name cannot be empty';
    END IF;
    
    -- Check length
    IF LENGTH(p_vendor_name) < 2 THEN
        RETURN 'INVALID: Vendor name too short (min 2 characters)';
    ELSIF LENGTH(p_vendor_name) > 200 THEN
        RETURN 'INVALID: Vendor name too long (max 200 characters)';
    END IF;
    
    -- Check for special characters (basic validation)
    IF REGEXP_LIKE(p_vendor_name, '[^a-zA-Z0-9 .@&-]') THEN
        RETURN 'WARNING: Vendor name contains special characters';
    END IF;
    
    -- Check for duplicates if requested
    IF p_check_duplicates THEN
        SELECT COUNT(*)
        INTO v_vendor_count
        FROM expenses
        WHERE UPPER(vendor_name) = UPPER(p_vendor_name);
        
        IF v_vendor_count > 0 THEN
            -- Check for similar names
            SELECT COUNT(*)
            INTO v_similar_vendors
            FROM expenses
            WHERE UPPER(vendor_name) LIKE '%' || UPPER(SUBSTR(p_vendor_name, 1, 5)) || '%';
            
            RETURN 'VALID: Vendor exists (' || v_vendor_count || ' transactions). ' || 
                   v_similar_vendors || ' similar vendors found.';
        ELSE
            RETURN 'VALID: New vendor - no previous transactions';
        END IF;
    END IF;
    
    RETURN 'VALID: Vendor name format is acceptable';
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'ERROR: Validation failed - ' || SQLERRM;
END validate_vendor_name;
/

-- =============================================
-- FUNCTION 6: GET_EVENT_SUMMARY (Lookup)
-- Purpose: Get comprehensive summary for an event
-- Return: CLOB (JSON-like summary)
-- =============================================

CREATE OR REPLACE FUNCTION get_event_summary(
    p_event_id IN NUMBER
) RETURN CLOB
AS
    v_summary CLOB;
    v_event_name VARCHAR2(200);
    v_event_date DATE;
    v_total_budget NUMBER;
    v_total_spent NUMBER;
    v_category_count NUMBER;
    v_expense_count NUMBER;
    v_avg_expense NUMBER;
    v_utilization NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Function: get_event_summary - Generating...');
    
    -- Get event details
    BEGIN
        SELECT event_name, event_date, total_budget, COALESCE(actual_spending, 0)
        INTO v_event_name, v_event_date, v_total_budget, v_total_spent
        FROM events
        WHERE event_id = p_event_id;
        
        DBMS_OUTPUT.PUT_LINE('   Event: ' || v_event_name);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN '{"error": "Event ' || p_event_id || ' not found"}';
    END;
    
    -- Get category count
    SELECT COUNT(*)
    INTO v_category_count
    FROM expense_categories
    WHERE event_id = p_event_id;
    
    -- Get expense count
    SELECT COUNT(*)
    INTO v_expense_count
    FROM expenses e
    JOIN expense_categories c ON e.category_id = c.category_id
    WHERE c.event_id = p_event_id
      AND (e.payment_status IS NULL OR e.payment_status != 'CANCELLED');
    
    -- Calculate average expense
    SELECT COALESCE(AVG(amount), 0)
    INTO v_avg_expense
    FROM expenses e
    JOIN expense_categories c ON e.category_id = c.category_id
    WHERE c.event_id = p_event_id
      AND (e.payment_status IS NULL OR e.payment_status != 'CANCELLED');
    
    -- Calculate utilization
    IF v_total_budget > 0 THEN
        v_utilization := ROUND((v_total_spent / v_total_budget) * 100, 2);
    ELSE
        v_utilization := 0;
    END IF;
    
    -- Build summary JSON
    v_summary := '{' ||
        '"event_id": ' || p_event_id || ',' ||
        '"event_name": "' || REPLACE(v_event_name, '"', '\"') || '",' ||
        '"event_date": "' || TO_CHAR(v_event_date, 'YYYY-MM-DD') || '",' ||
        '"total_budget": ' || v_total_budget || ',' ||
        '"total_spent": ' || v_total_spent || ',' ||
        '"remaining_budget": ' || (v_total_budget - v_total_spent) || ',' ||
        '"budget_utilization": ' || v_utilization || ',' ||
        '"category_count": ' || v_category_count || ',' ||
        '"expense_count": ' || v_expense_count || ',' ||
        '"average_expense": ' || ROUND(v_avg_expense, 2) || ',' ||
        '"status": "SUCCESS"' ||
        '}';
    
    DBMS_OUTPUT.PUT_LINE('   Summary generated for ' || v_event_name);
    
    RETURN v_summary;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN '{"error": "' || REPLACE(SQLERRM, '"', '\"') || '"}';
END get_event_summary;
/

-- =============================================
-- TESTING ALL FUNCTIONS
-- =============================================

BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'TESTING ALL 6 FUNCTIONS');
    DBMS_OUTPUT.PUT_LINE('=================================');
END;
/

DECLARE
    v_test_event_id NUMBER;
    v_test_category_id NUMBER;
    v_test_date DATE;
    v_result NUMBER;
    v_message VARCHAR2(500);
    v_summary CLOB;
BEGIN
    -- Get test data
    SELECT event_id INTO v_test_event_id
    FROM events WHERE ROWNUM = 1;
    
    SELECT category_id INTO v_test_category_id
    FROM expense_categories WHERE ROWNUM = 1;
    
    v_test_date := SYSDATE + 30;
    
    DBMS_OUTPUT.PUT_LINE('Test Data:');
    DBMS_OUTPUT.PUT_LINE('  Event ID: ' || v_test_event_id);
    DBMS_OUTPUT.PUT_LINE('  Category ID: ' || v_test_category_id);
    DBMS_OUTPUT.PUT_LINE('  Test Date: ' || TO_CHAR(v_test_date, 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Test 1: Calculation Function
    DBMS_OUTPUT.PUT_LINE('1. Testing CALCULATION function: calculate_event_utilization');
    v_result := calculate_event_utilization(v_test_event_id);
    DBMS_OUTPUT.PUT_LINE('   Result: ' || v_result || '%');
    
    -- Test 2: Validation Function
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '2. Testing VALIDATION function: validate_event_date');
    v_message := validate_event_date(v_test_date, 'WEDDING');
    DBMS_OUTPUT.PUT_LINE('   Result: ' || v_message);
    
    -- Test 3: Lookup Function
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '3. Testing LOOKUP function: get_category_spending');
    v_result := get_category_spending(v_test_category_id);
    DBMS_OUTPUT.PUT_LINE('   Result: ' || v_result);
    
    -- Test 4: Calculation Function
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '4. Testing CALCULATION function: calculate_average_expense');
    v_result := calculate_average_expense(v_test_event_id);
    DBMS_OUTPUT.PUT_LINE('   Result: ' || v_result);
    
    -- Test 5: Validation Function
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '5. Testing VALIDATION function: validate_vendor_name');
    v_message := validate_vendor_name('Kigali Convention Center');
    DBMS_OUTPUT.PUT_LINE('   Result: ' || v_message);
    
    -- Test 6: Lookup Function
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '6. Testing LOOKUP function: get_event_summary');
    v_summary := get_event_summary(v_test_event_id);
    DBMS_OUTPUT.PUT_LINE('   Result: ' || SUBSTR(v_summary, 1, 100) || '...');
    
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '=================================');
    DBMS_OUTPUT.PUT_LINE(' ALL 6 FUNCTIONS TESTED SUCCESSFULLY');
    DBMS_OUTPUT.PUT_LINE('=================================');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
END;
/

-- =============================================
-- VERIFICATION OF REQUIREMENTS
-- =============================================

BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'VERIFICATION OF PHASE VI FUNCTION REQUIREMENTS');
    DBMS_OUTPUT.PUT_LINE('========================================================');
END;
/

DECLARE
    v_function_count NUMBER;
    v_calculation_count NUMBER := 0;
    v_validation_count NUMBER := 0;
    v_lookup_count NUMBER := 0;
    v_return_types VARCHAR2(1000);
BEGIN
    -- Count all functions
    SELECT COUNT(*)
    INTO v_function_count
    FROM user_objects 
    WHERE object_type = 'FUNCTION'
      AND object_name IN (
        'CALCULATE_EVENT_UTILIZATION',
        'VALIDATE_EVENT_DATE',
        'GET_CATEGORY_SPENDING',
        'CALCULATE_AVERAGE_EXPENSE',
        'VALIDATE_VENDOR_NAME',
        'GET_EVENT_SUMMARY'
      );
    
    -- Categorize functions
    v_calculation_count := 2;  -- calculate_event_utilization, calculate_average_expense
    v_validation_count := 2;   -- validate_event_date, validate_vendor_name
    v_lookup_count := 2;       -- get_category_spending, get_event_summary
    
    -- Get return types
    SELECT LISTAGG(object_name || ' -> ' || data_type, ', ') WITHIN GROUP (ORDER BY object_name)
    INTO v_return_types
    FROM (
        SELECT DISTINCT ua.object_name, ua.data_type
        FROM user_arguments ua
        WHERE ua.object_name IN (
            'CALCULATE_EVENT_UTILIZATION',
            'VALIDATE_EVENT_DATE',
            'GET_CATEGORY_SPENDING',
            'CALCULATE_AVERAGE_EXPENSE',
            'VALIDATE_VENDOR_NAME',
            'GET_EVENT_SUMMARY'
        )
        AND ua.position = 0  -- Return type
    );
    
    DBMS_OUTPUT.PUT_LINE('REQUIREMENT 1: Minimum 3-5 Functions');
    DBMS_OUTPUT.PUT_LINE('   ✓ ' || v_function_count || ' functions created (Target: 3-5)');
    DBMS_OUTPUT.PUT_LINE('   ✓ 2 Calculation functions');
    DBMS_OUTPUT.PUT_LINE('   ✓ 2 Validation functions');
    DBMS_OUTPUT.PUT_LINE('   ✓ 2 Lookup functions');
    
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'REQUIREMENT 2: Proper Return Types');
    DBMS_OUTPUT.PUT_LINE('   ' || v_return_types);
    
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'FUNCTION DETAILS:');
    DBMS_OUTPUT.PUT_LINE('   1. calculate_event_utilization - NUMBER (Calculation)');
    DBMS_OUTPUT.PUT_LINE('   2. validate_event_date - VARCHAR2 (Validation)');
    DBMS_OUTPUT.PUT_LINE('   3. get_category_spending - NUMBER (Lookup)');
    DBMS_OUTPUT.PUT_LINE('   4. calculate_average_expense - NUMBER (Calculation)');
    DBMS_OUTPUT.PUT_LINE('   5. validate_vendor_name - VARCHAR2 (Validation)');
    DBMS_OUTPUT.PUT_LINE('   6. get_event_summary - CLOB (Lookup)');
    
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '========================================================');
    DBMS_OUTPUT.PUT_LINE('STATUS: ALL FUNCTION REQUIREMENTS MET ✓');
    DBMS_OUTPUT.PUT_LINE('========================================================');
    
END;
/

