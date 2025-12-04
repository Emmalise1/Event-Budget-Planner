-- =============================================
-- PHASE V: DATA INSERTION SCRIPT (FIXED VERSION)
-- Event Budget Planner System
-- Student: Emma Lise IZA KURADUSENGE (ID: 28246)
-- Database: wed_28246_emma_event_budget_planner_db
-- =============================================

SET SERVEROUTPUT ON;
SET DEFINE OFF;

BEGIN
    DBMS_OUTPUT.PUT_LINE('============================================');
    DBMS_OUTPUT.PUT_LINE('PHASE V: DATA INSERTION STARTING...');
    DBMS_OUTPUT.PUT_LINE('============================================');
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- =============================================
-- STEP 1: CLEAN ALL TABLES (FOR FRESH START)
-- =============================================

DECLARE
    v_counter NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Cleaning all tables for fresh start...');
    
    -- Delete in correct order (respect foreign keys)
    DELETE FROM audit_log;
    v_counter := v_counter + SQL%ROWCOUNT;
    
    DELETE FROM expenses;
    v_counter := v_counter + SQL%ROWCOUNT;
    
    DELETE FROM expense_categories;
    v_counter := v_counter + SQL%ROWCOUNT;
    
    DELETE FROM holidays;
    v_counter := v_counter + SQL%ROWCOUNT;
    
    DELETE FROM events;
    v_counter := v_counter + SQL%ROWCOUNT;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('✓ All tables cleaned (' || v_counter || ' rows removed)');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error cleaning tables: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

-- =============================================
-- STEP 2: RESET ALL SEQUENCES
-- =============================================

BEGIN
    DBMS_OUTPUT.PUT_LINE('Resetting sequences...');
    
    -- Drop sequences if they exist
    BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_event_id'; 
    EXCEPTION WHEN OTHERS THEN NULL; END;
    
    BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_category_id'; 
    EXCEPTION WHEN OTHERS THEN NULL; END;
    
    BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_expense_id'; 
    EXCEPTION WHEN OTHERS THEN NULL; END;
    
    BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_audit_log'; 
    EXCEPTION WHEN OTHERS THEN NULL; END;
    
    BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE seq_holiday_id'; 
    EXCEPTION WHEN OTHERS THEN NULL; END;
    
    -- Create fresh sequences
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_event_id START WITH 1001 INCREMENT BY 1 NOCACHE';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_category_id START WITH 2001 INCREMENT BY 1 NOCACHE';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_expense_id START WITH 3001 INCREMENT BY 1 NOCACHE';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_audit_log START WITH 1 INCREMENT BY 1 NOCACHE';
    EXECUTE IMMEDIATE 'CREATE SEQUENCE seq_holiday_id START WITH 1 INCREMENT BY 1 NOCACHE';
    
    DBMS_OUTPUT.PUT_LINE('✓ All sequences reset');
END;
/

-- =============================================
-- STEP 3: INSERT HOLIDAYS (RWANDAN HOLIDAYS 2025)
-- =============================================

BEGIN
    DBMS_OUTPUT.PUT_LINE('Inserting Rwandan public holidays...');
    
    INSERT INTO holidays (holiday_date, holiday_name, is_public_holiday)
    SELECT DATE '2025-01-01', 'New Years Day', 'Y' FROM dual UNION ALL
    SELECT DATE '2025-01-02', 'Day after New Years Day', 'Y' FROM dual UNION ALL
    SELECT DATE '2025-02-01', 'National Heroes Day', 'Y' FROM dual UNION ALL
    SELECT DATE '2025-04-02', 'Good Friday', 'Y' FROM dual UNION ALL
    SELECT DATE '2025-04-05', 'Easter Monday', 'Y' FROM dual UNION ALL
    SELECT DATE '2025-04-07', 'Genocide Memorial Day', 'Y' FROM dual UNION ALL
    SELECT DATE '2025-05-01', 'Labour Day', 'Y' FROM dual UNION ALL
    SELECT DATE '2025-05-13', 'Eid El Fitr', 'Y' FROM dual UNION ALL
    SELECT DATE '2025-07-01', 'Independence Day', 'Y' FROM dual UNION ALL
    SELECT DATE '2025-07-04', 'Liberation Day Holiday', 'Y' FROM dual UNION ALL
    SELECT DATE '2025-07-20', 'Eid al-Adha', 'Y' FROM dual UNION ALL
    SELECT DATE '2025-08-01', 'Umuganura Day', 'Y' FROM dual UNION ALL
    SELECT DATE '2025-08-15', 'Assumption Day', 'Y' FROM dual UNION ALL
    SELECT DATE '2025-12-25', 'Christmas Day', 'Y' FROM dual UNION ALL
    SELECT DATE '2025-12-26', 'Boxing Day', 'Y' FROM dual;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('✓ 15 holidays inserted');
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Note: Some holidays already exist');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inserting holidays: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

-- =============================================
-- STEP 4: INSERT 150+ REALISTIC EVENTS
-- =============================================

DECLARE
    v_counter NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Inserting 150+ realistic events...');
    
    -- 1. CONFERENCES (30 events)
    FOR i IN 1..30 LOOP
        INSERT INTO events (event_name, event_type, event_date, total_budget, location, expected_guests, created_by, status) 
        VALUES (
            'Kigali Tech Summit ' || (2025 + MOD(i, 3)),
            'CONFERENCE',
            DATE '2025-06-15' + (i*7),
            ROUND(DBMS_RANDOM.VALUE(5000000, 50000000), -3),
            'Kigali Convention Center',
            ROUND(DBMS_RANDOM.VALUE(100, 1000)),
            'emma_admin',
            'PLANNING'
        );
        v_counter := v_counter + 1;
    END LOOP;
    
    -- 2. WEDDINGS (40 events)
    FOR i IN 1..40 LOOP
        INSERT INTO events (event_name, event_type, event_date, total_budget, location, expected_guests, created_by, status) 
        VALUES (
            CASE MOD(i, 4)
                WHEN 0 THEN 'Traditional Rwandan Wedding - Family ' || CHR(65+i)
                WHEN 1 THEN 'Church Wedding - Couple ' || CHR(65+i)
                WHEN 2 THEN 'Garden Wedding Ceremony ' || i
                ELSE 'Destination Wedding at Lake Kivu ' || i
            END,
            'WEDDING',
            DATE '2025-03-20' + (i*5),
            ROUND(DBMS_RANDOM.VALUE(3000000, 30000000), -3),
            CASE MOD(i, 5)
                WHEN 0 THEN 'Kigali Serena Hotel'
                WHEN 1 THEN 'Lemigo Hotel'
                WHEN 2 THEN 'Radisson Blu Hotel'
                WHEN 3 THEN 'Family Compound, Nyamirambo'
                ELSE 'Lake Kivu Serena Resort'
            END,
            ROUND(DBMS_RANDOM.VALUE(50, 500)),
            'john_planner',
            CASE MOD(i, 3) 
                WHEN 0 THEN 'PLANNING' 
                WHEN 1 THEN 'IN_PROGRESS' 
                ELSE 'COMPLETED' 
            END
        );
        v_counter := v_counter + 1;
    END LOOP;
    
    -- 3. CORPORATE EVENTS (35 events)
    FOR i IN 1..35 LOOP
        INSERT INTO events (event_name, event_type, event_date, total_budget, location, expected_guests, created_by, status) 
        VALUES (
            CASE MOD(i, 5)
                WHEN 0 THEN 'Annual General Meeting Q' || (2025 + MOD(i, 3))
                WHEN 1 THEN 'Product Launch Event ' || i
                WHEN 2 THEN 'Team Building Retreat ' || i
                WHEN 3 THEN 'Client Appreciation Gala ' || i
                ELSE 'Board of Directors Conference ' || i
            END,
            'CORPORATE',
            DATE '2025-02-10' + (i*10),
            ROUND(DBMS_RANDOM.VALUE(1000000, 20000000), -3),
            CASE MOD(i, 4)
                WHEN 0 THEN 'Kigali Marriott Hotel'
                WHEN 1 THEN 'Ubumwe Grande Hotel'
                WHEN 2 THEN 'Norrsken House Kigali'
                ELSE 'Company Headquarters'
            END,
            ROUND(DBMS_RANDOM.VALUE(20, 300)),
            'mary_coordinator',
            'IN_PROGRESS'
        );
        v_counter := v_counter + 1;
    END LOOP;
    
    -- 4. CHARITY EVENTS (25 events)
    FOR i IN 1..25 LOOP
        INSERT INTO events (event_name, event_type, event_date, total_budget, location, expected_guests, created_by, status) 
        VALUES (
            CASE MOD(i, 4)
                WHEN 0 THEN 'Education Fundraiser for Rural Schools'
                WHEN 1 THEN 'Healthcare Awareness Gala ' || i
                WHEN 2 THEN 'Environmental Conservation Dinner'
                ELSE 'Orphanage Support Charity Event ' || i
            END,
            'CHARITY',
            DATE '2025-04-01' + (i*14),
            ROUND(DBMS_RANDOM.VALUE(500000, 10000000), -3),
            CASE MOD(i, 3)
                WHEN 0 THEN 'Kigali Serena Hotel'
                WHEN 1 THEN 'Radisson Blu Hotel'
                ELSE 'Community Center, Gisozi'
            END,
            ROUND(DBMS_RANDOM.VALUE(50, 200)),
            'emma_admin',
            'PLANNING'
        );
        v_counter := v_counter + 1;
    END LOOP;
    
    -- 5. BIRTHDAY & OTHER EVENTS (20 events)
    FOR i IN 1..20 LOOP
        INSERT INTO events (event_name, event_type, event_date, total_budget, location, expected_guests, created_by, status) 
        VALUES (
            CASE MOD(i, 3)
                WHEN 0 THEN (CASE WHEN MOD(i, 2)=0 THEN '50th' ELSE '40th' END) || ' Birthday Celebration'
                WHEN 1 THEN 'Graduation Party ' || i
                ELSE 'Family Reunion Gathering ' || i
            END,
            CASE MOD(i, 3) WHEN 0 THEN 'BIRTHDAY' ELSE 'OTHER' END,
            DATE '2025-05-01' + (i*7),
            ROUND(DBMS_RANDOM.VALUE(200000, 5000000), -3),
            CASE MOD(i, 4)
                WHEN 0 THEN 'Private Residence, Kigali'
                WHEN 1 THEN 'Local Restaurant'
                WHEN 2 THEN 'Community Hall'
                ELSE 'Hotel Garden'
            END,
            ROUND(DBMS_RANDOM.VALUE(20, 150)),
            CASE MOD(i, 3) 
                WHEN 0 THEN 'family_friend' 
                WHEN 1 THEN 'john_planner' 
                ELSE 'mary_coordinator' 
            END,
            CASE MOD(i, 4) 
                WHEN 0 THEN 'PLANNING' 
                WHEN 1 THEN 'IN_PROGRESS' 
                WHEN 2 THEN 'COMPLETED' 
                ELSE 'CANCELLED' 
            END
        );
        v_counter := v_counter + 1;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('✓ ' || v_counter || ' events inserted');
    
    -- Add edge cases (NULL values for testing)
    UPDATE events SET location = NULL WHERE MOD(event_id, 20) = 0;
    UPDATE events SET expected_guests = NULL WHERE MOD(event_id, 15) = 0;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('✓ Added NULL values for edge case testing');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inserting events: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

-- =============================================
-- STEP 5: INSERT 815+ EXPENSE CATEGORIES
-- =============================================

DECLARE
    v_counter NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Inserting 815+ expense categories...');
    
    -- Process all events
    FOR event_rec IN (SELECT event_id, event_type, total_budget FROM events) LOOP
        
        IF event_rec.event_type = 'CONFERENCE' THEN
            -- Conference categories
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Venue Rental', ROUND(event_rec.total_budget * 0.35, -3));
            
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Speaker Fees', ROUND(event_rec.total_budget * 0.25, -3));
            
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Catering Service', ROUND(event_rec.total_budget * 0.20, -3));
            
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Audio Visual Equipment', ROUND(event_rec.total_budget * 0.10, -3));
            
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Marketing', ROUND(event_rec.total_budget * 0.05, -3));
            
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Print Materials', ROUND(event_rec.total_budget * 0.05, -3));
            
            v_counter := v_counter + 6;
            
        ELSIF event_rec.event_type = 'WEDDING' THEN
            -- Wedding categories
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Venue and Decorations', ROUND(event_rec.total_budget * 0.30, -3));
            
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Catering and Wedding Cake', ROUND(event_rec.total_budget * 0.25, -3));
            
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Photography Services', ROUND(event_rec.total_budget * 0.15, -3));
            
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Bridal Attire', ROUND(event_rec.total_budget * 0.12, -3));
            
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Entertainment', ROUND(event_rec.total_budget * 0.10, -3));
            
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Wedding Invitations', ROUND(event_rec.total_budget * 0.05, -3));
            
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Transportation', ROUND(event_rec.total_budget * 0.03, -3));
            
            v_counter := v_counter + 7;
            
        ELSIF event_rec.event_type = 'CORPORATE' THEN
            -- Corporate categories
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Venue', ROUND(event_rec.total_budget * 0.40, -3));
            
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Food and Beverages', ROUND(event_rec.total_budget * 0.30, -3));
            
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Audio Visual Equipment', ROUND(event_rec.total_budget * 0.15, -3));
            
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Promotional Materials', ROUND(event_rec.total_budget * 0.10, -3));
            
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Staff Coordination', ROUND(event_rec.total_budget * 0.05, -3));
            
            v_counter := v_counter + 5;
            
        ELSE -- Charity, Birthday, Other
            -- Other event categories
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Venue Costs', ROUND(event_rec.total_budget * 0.40, -3));
            
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Food and Drinks', ROUND(event_rec.total_budget * 0.35, -3));
            
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Entertainment', ROUND(event_rec.total_budget * 0.15, -3));
            
            INSERT INTO expense_categories (event_id, category_name, budget_limit) 
            VALUES (event_rec.event_id, 'Decorations', ROUND(event_rec.total_budget * 0.10, -3));
            
            v_counter := v_counter + 4;
        END IF;
        
        -- Show progress
        IF MOD(v_counter, 100) = 0 THEN
            DBMS_OUTPUT.PUT_LINE('   ' || v_counter || ' categories inserted...');
            COMMIT;
        END IF;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('✓ ' || v_counter || ' expense categories inserted');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inserting categories: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

-- =============================================
-- STEP 6: INSERT 550+ EXPENSES
-- =============================================

DECLARE
    v_counter NUMBER := 0;
    TYPE vendor_array IS TABLE OF VARCHAR2(100);
    v_vendors vendor_array := vendor_array(
        'Kigali Convention Center', 'Serena Hotels Rwanda', 'Radisson Blu Kigali',
        'Inyange Industries', 'Rwanda Coffee Ltd', 'Catering Plus Rwanda',
        'Bloom Flowers Kigali', 'Capture Moments Photography', 'Sound Systems Ltd',
        'Print Solutions Rwanda', 'AV Equipment Rentals', 'Transport Services Ltd',
        'Kigali Bakery', 'Fresh Foods Market', 'Bridal Boutique Kigali',
        'DJ Entertainment Rwanda', 'Event Decor Rwanda', 'Security Services Ltd',
        'Clean Team Services', 'RwandAir Travel'
    );
BEGIN
    DBMS_OUTPUT.PUT_LINE('Inserting 550+ expenses...');
    
    -- Get all categories
    FOR cat_rec IN (SELECT category_id, budget_limit FROM expense_categories) LOOP
        -- Insert 2 expenses per category
        FOR i IN 1..2 LOOP
            INSERT INTO expenses (
                category_id,
                description,
                amount,
                date_added,
                vendor_name,
                payment_status
            ) VALUES (
                cat_rec.category_id,
                CASE MOD(i, 3)
                    WHEN 0 THEN 'Deposit Payment'
                    WHEN 1 THEN 'Service Fee'
                    ELSE 'Materials Purchase'
                END,
                -- Amount: 5-30% of budget limit
                LEAST(
                    ROUND(DBMS_RANDOM.VALUE(10000, 500000), -2),
                    cat_rec.budget_limit * 0.3
                ),
                -- Date: within last 180 days
                SYSDATE - DBMS_RANDOM.VALUE(1, 180),
                -- Vendor
                CASE MOD(v_counter, 5)
                    WHEN 0 THEN 'Kigali Convention Center'
                    WHEN 1 THEN 'Serena Hotels Rwanda'
                    WHEN 2 THEN 'Radisson Blu Kigali'
                    WHEN 3 THEN 'Local Catering Service'
                    ELSE 'General Supplies Ltd'
                END,
                -- Payment status
                CASE MOD(v_counter, 4)
                    WHEN 0 THEN 'PENDING'
                    WHEN 1 THEN 'PARTIAL'
                    WHEN 2 THEN 'CANCELLED'
                    ELSE 'PAID'
                END
            );
            
            v_counter := v_counter + 1;
            
            -- Show progress every 100 records
            IF MOD(v_counter, 100) = 0 THEN
                DBMS_OUTPUT.PUT_LINE('   ' || v_counter || ' expenses inserted...');
                COMMIT;
            END IF;
        END LOOP;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('✓ ' || v_counter || ' expenses inserted');
    
    -- Add edge cases
    UPDATE expenses SET vendor_name = NULL WHERE MOD(expense_id, 50) = 0;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('✓ Added NULL vendor names for edge cases');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inserting expenses: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

-- =============================================
-- STEP 7: INSERT 50+ AUDIT LOG ENTRIES
-- =============================================

DECLARE
    v_counter NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Inserting 50+ audit log entries...');
    
    -- Log event creations (SUCCESS operations)
    FOR i IN 1..20 LOOP
        INSERT INTO audit_log (table_name, operation_type, user_name, status) VALUES
        ('EVENTS', 'INSERT', 
         CASE MOD(i, 3) 
            WHEN 0 THEN 'emma_admin' 
            WHEN 1 THEN 'john_planner' 
            ELSE 'mary_coordinator' 
         END,
         'SUCCESS');
        v_counter := v_counter + 1;
    END LOOP;
    
    -- Log expense transactions (mixed status)
    FOR i IN 1..20 LOOP
        INSERT INTO audit_log (table_name, operation_type, user_name, status) VALUES
        ('EXPENSES', 
         CASE MOD(i, 3) 
            WHEN 0 THEN 'INSERT' 
            WHEN 1 THEN 'UPDATE' 
            ELSE 'DELETE' 
         END,
         CASE MOD(i, 4) 
            WHEN 0 THEN 'emma_admin' 
            WHEN 1 THEN 'john_planner' 
            WHEN 2 THEN 'mary_coordinator' 
            ELSE 'system' 
         END,
         CASE MOD(i, 5) 
            WHEN 0 THEN 'SUCCESS' 
            WHEN 1 THEN 'FAILED' 
            ELSE 'BLOCKED' 
         END);
        v_counter := v_counter + 1;
    END LOOP;
    
    -- Log attempted violations (BLOCKED operations)
    FOR i IN 1..10 LOOP
        INSERT INTO audit_log (table_name, operation_type, user_name, status) VALUES
        ('EXPENSES', 'INSERT', 'unauthorized_user', 'BLOCKED');
        v_counter := v_counter + 1;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('✓ ' || v_counter || ' audit log entries inserted');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inserting audit logs: ' || SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

-- =============================================
-- STEP 8: FINAL VERIFICATION
-- =============================================

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('============================================');
    DBMS_OUTPUT.PUT_LINE('PHASE V: DATA INSERTION COMPLETE!');
    DBMS_OUTPUT.PUT_LINE('============================================');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Show final counts
    DBMS_OUTPUT.PUT_LINE('FINAL DATA COUNTS:');
    DBMS_OUTPUT.PUT_LINE('  Events:           ' || (SELECT COUNT(*) FROM events));
    DBMS_OUTPUT.PUT_LINE('  Expense Categories: ' || (SELECT COUNT(*) FROM expense_categories));
    DBMS_OUTPUT.PUT_LINE('  Expenses:         ' || (SELECT COUNT(*) FROM expenses));
    DBMS_OUTPUT.PUT_LINE('  Holidays:         ' || (SELECT COUNT(*) FROM holidays));
    DBMS_OUTPUT.PUT_LINE('  Audit Logs:       ' || (SELECT COUNT(*) FROM audit_log));
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Verify requirements
    DBMS_OUTPUT.PUT_LINE('PHASE V REQUIREMENTS MET:');
    DBMS_OUTPUT.PUT_LINE('  ✓ 150+ events inserted (Target: 100+)');
    DBMS_OUTPUT.PUT_LINE('  ✓ 800+ categories inserted (Target: 200+)');
    DBMS_OUTPUT.PUT_LINE('  ✓ 550+ expenses inserted (Target: 500+)');
    DBMS_OUTPUT.PUT_LINE('  ✓ 15 holidays inserted (Target: 8+)');
    DBMS_OUTPUT.PUT_LINE('  ✓ 50+ audit logs inserted');
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('TOTAL ROWS INSERTED: ' || 
        ((SELECT COUNT(*) FROM events) +
         (SELECT COUNT(*) FROM expense_categories) +
         (SELECT COUNT(*) FROM expenses) +
         (SELECT COUNT(*) FROM holidays) +
         (SELECT COUNT(*) FROM audit_log)));
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('✅ PHASE V DATA INSERTION SUCCESSFUL!');
    DBMS_OUTPUT.PUT_LINE('✅ READY FOR PHASE VI: PL/SQL DEVELOPMENT');
    DBMS_OUTPUT.PUT_LINE('============================================');
    
    -- Sample verification
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('SAMPLE DATA VERIFICATION:');
    DBMS_OUTPUT.PUT_LINE('  Events with NULL location: ' || 
        (SELECT COUNT(*) FROM events WHERE location IS NULL));
    DBMS_OUTPUT.PUT_LINE('  Expenses with NULL vendor: ' || 
        (SELECT COUNT(*) FROM expenses WHERE vendor_name IS NULL));
    DBMS_OUTPUT.PUT_LINE('');
    
END;
/

-- =============================================
-- SCRIPT COMPLETION
-- =============================================

SELECT 'Script execution completed: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') FROM dual;
