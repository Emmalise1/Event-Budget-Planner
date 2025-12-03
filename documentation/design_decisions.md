# PHASE III: Design Decisions & Assumptions
## Event Budget Planner System

## 1. DESIGN DECISIONS

### Decision 1: 3-Table Structure Only
- **Chosen:** EVENTS, EXPENSE_CATEGORIES, EXPENSES tables only
- **Reason:** Matches Phase I proposal exactly (3 tables promised)
- **Alternative considered:** Add USERS and VENDORS tables
- **Why rejected:** Not in original proposal, would change scope

### Decision 2: Simple Budget Tracking
- **Chosen:** Basic budget limits without warning thresholds
- **Reason:** Simpler implementation for academic project
- **Limitation:** No automatic alerts when nearing budget limits
- **Future enhancement:** Add warning_threshold column in EXPENSE_CATEGORIES

### Decision 3: No Status Tracking for Events
- **Chosen:** No 'status' column in EVENTS table
- **Reason:** Basic event tracking without lifecycle states
- **Limitation:** Cannot track if event is PLANNING, ONGOING, or COMPLETED
- **Future enhancement:** Add status column with CHECK constraint

### Decision 4: Cascade Delete Implementation
- **Chosen:** ON DELETE CASCADE for foreign keys
- **Reason:** Automatic cleanup of related data
- **Example:** Delete event → automatically delete all its categories → delete all expenses
- **Benefit:** Prevents orphaned data in database
### Decision 5: Separation of Business and System Tables
- **Chosen:** Implement 5 total tables with clear separation
- **Reason:** Balance Phase I proposal with Phase VII requirements
- **Business Tables (3):** EVENTS, EXPENSE_CATEGORIES, EXPENSES (ER diagram)
- **System Tables (2):** HOLIDAYS, AUDIT_LOG (not in ER diagram)
- **Justification:** ER diagrams model business entities; system tables handle technical requirements separately

### Decision 6: Phase VII Compliance Strategy
- **Chosen:** Add required tables while keeping ER diagram focused on business entities
- **Reason:** HOLIDAYS and AUDIT_LOG tables are MANDATORY for Phase VII business rule
- **Implementation:** 
  - ER diagram shows 3 business tables (as promised in Phase I)
  - Database includes 5 total tables (3 business + 2 system)
  - Phase VII implementation uses all 5 tables
- **Benefit:** Meets all project requirements without confusing business model  

## 2. BUSINESS ASSUMPTIONS

### Assumption 1: Single Currency
- System uses Rwandan Francs (RWF) only
- No currency conversion needed
- All amounts stored and displayed in RWF

### Assumption 2: Fixed Budget at Creation
- Total budget set when event is created
- Cannot change budget amount later
- Budget amounts must be positive (> 0)

### Assumption 3: Manual Expense Entry
- Users manually enter all expenses
- No automatic import from bank statements
- No receipt scanning or OCR technology

### Assumption 4: Single Event Planner
- One main person plans each event
- No multi-user collaboration features
- User tracked via simple text field (created_by)

### Assumption 5: Future Events Only
- System used for planning future events
- Not for tracking past historical events
- All event dates are in the future
### Assumption 6: System Tables for Compliance
- HOLIDAYS table contains only public holidays for the upcoming month
- AUDIT_LOG table automatically captures all database operations
- System tables are maintained automatically, not by end users
- Business rule restrictions apply only to DML operations, not queries
  

## 3. TECHNICAL ASSUMPTIONS

### Assumption 1: Oracle Database Environment
- Oracle Database 19c or higher available
- SQL Developer as primary development tool
- Sufficient tablespace for data storage

### Assumption 2: User Competency
- Users can use database forms or simple interface
- Users understand basic budgeting concepts
- Users can enter data accurately

### Assumption 3: Data Volume Limits
- Maximum 500 events in database
- Maximum 10 categories per event
- Maximum 50 expenses per category
- 1-2 concurrent users maximum

### Assumption 4: Basic Security
- No login authentication system
- No sensitive financial data (credit cards, etc.)
- Basic user tracking via text fields only

## 4. SYSTEM CAPABILITIES

### What the System CAN Do:
1. Create events with name, date, and budget
2. Define expense categories for each event
3. Record individual expense transactions
4. Track spending against category budget limits
5. Generate basic spending reports
6. Track payment status (PENDING/PAID/CANCELLED)
7. Maintain vendor information for expenses

### What the System CANNOT Do:
1. Provide warning alerts when nearing budget limits (no warning_threshold)
2. Track event status (PLANNING/ONGOING/COMPLETED)
3. Track current spending per category automatically (no current_spending column)
4. Change total budget after event creation
5. Transfer unused budget between categories
6. Handle multiple currencies
7. Attach receipt images or documents
8. Provide user login with passwords

## 5. NORMALIZATION JUSTIFICATION (3NF)

### Database Design:
**3 Tables in 3rd Normal Form:**

1. **EVENTS** - Contains event details (6 columns)
2. **EXPENSE_CATEGORIES** - Contains category details (4 columns)
3. **EXPENSES** - Contains expense details (7 columns)

### 1NF Achieved:
- ✓ Each table has primary key
- ✓ All columns contain atomic values (single values)
- ✓ No repeating groups of columns

### 2NF Achieved:
- ✓ All non-key columns depend on ENTIRE primary key
- ✓ Example: In EXPENSES, 'amount' depends on entire 'expense_id'

### 3NF Achieved:
- ✓ No transitive dependencies
- ✓ Example: 'vendor_name' does not determine 'amount'
- ✓ Example: 'payment_status' does not determine 'date_added'

### Benefits of 3NF:
1. **Minimal Data Duplication** - Each fact stored once
2. **Easy Data Updates** - Change in one place only
3. **Data Integrity** - Foreign keys ensure valid relationships
4. **Efficient Queries** - Proper indexing possible
5. **Scalable Design** - Easy to add future enhancements
   
### Note on System Tables:
The HOLIDAYS and AUDIT_LOG tables follow different normalization considerations:
- **HOLIDAYS:** Simple reference data (1NF sufficient)
- **AUDIT_LOG:** Append-only logging table (denormalized for performance)
- **Separation:** These system tables don't affect the 3NF design of business tables   

## 6. BI & ANALYTICS CONSIDERATIONS

### Data Classification:
- **Fact Table:** EXPENSES (contains measurable 'amount' column)
- **Dimension Tables:** EVENTS, EXPENSE_CATEGORIES (descriptive attributes)

### Reports Possible with Current Design:
1. **Budget vs Actual Report** - Compare budget_limit vs SUM(amount)
2. **Category Spending Report** - Group expenses by category
3. **Vendor Payment Report** - Expenses by vendor_name
4. **Time-based Report** - Expenses by date_added
5. **Payment Status Report** - Expenses by payment_status

### Reports NOT Possible (Missing Columns):
1. ❌ **Budget Warning Report** - No warning_threshold column
2. ❌ **Event Status Report** - No status column in EVENTS
3. ❌ **Category Progress Report** - No current_spending column

### Future BI Enhancements:
1. Add warning_threshold for budget alerts
2. Add status column for event lifecycle tracking
3. Add current_spending for real-time category tracking
4. Create dashboard with visual charts
5. Add predictive spending analytics

## 7. AUDIT TRAIL & COMPLIANCE DESIGN (Phase VII)

### System Tables Implementation:
1. **HOLIDAYS Table** (Required for business rule):
   - holiday_id (PK)
   - holiday_date (NOT NULL, UNIQUE)
   - holiday_name (NOT NULL)
   - is_public_holiday (DEFAULT 'Y')

2. **AUDIT_LOG Table** (Required for comprehensive auditing):
   - audit_id (PK)
   - table_name (ALL tables)
   - operation_type (INSERT/UPDATE/DELETE)
   - operation_date (TIMESTAMP)
   - user_name (DEFAULT USER)
   - status (SUCCESS/FAILED/BLOCKED)

### Business Rule Implementation:
- **Restriction:** No DML operations on weekdays (Mon-Fri) or public holidays
- **Enforcement:** Triggers check HOLIDAYS table before allowing operations
- **Auditing:** All attempts (successful and blocked) logged to AUDIT_LOG
- **Testing:** Separate test cases for weekday, weekend, and holiday scenarios

### Audit Scope:
1. All DML operations on ALL tables
2. Business rule violation attempts
3. Successful operations with before/after values
4. User identity and timestamp for accountability

## 8. LIMITATIONS & FUTURE ENHANCEMENTS

### Current Limitations:
1. No budget warning system (missing warning_threshold)
2. No event status tracking (missing status column)
3. No automatic category spending tracking (missing current_spending)
4. No user authentication system
5. No vendor management beyond name

### Immediate Phase VII Enhancements:
1. **HOLIDAYS table** - For weekday/holiday restriction enforcement
2. **AUDIT_LOG table** - For comprehensive system auditing
3. **Business rule triggers** - No DML on weekdays/public holidays

### Phase 2.0 Enhancements (Future):
1. Add warning_threshold column to EXPENSE_CATEGORIES
2. Add status column to EVENTS table
3. Add current_spending column to EXPENSE_CATEGORIES
4. Create USERS table for authentication
5. Create VENDORS table for vendor management
6. Add budget transfer functionality

## 9. SUCCESS CRITERIA FOR PHASE III

### Phase III Complete When:
- ER diagram created with 3 business tables and relationships  
- Data dictionary documents 30 columns across 5 tables (3 business + 2 system)  
- Design decisions documented (including separation of business/system tables)  
- Assumptions clearly stated (business and technical, including Phase VII compliance)  
- Normalization to 3NF explained and justified (for business tables)  
- BI considerations identified (fact vs dimension tables)  
- Phase VII audit/compliance plan outlined  
- All files committed to GitHub documentation folder  

### Key Deliverables:
1. ER diagram (3 business tables)
2. Complete data dictionary (5 tables total)
3. Design decisions with Phase VII strategy
4. Documentation of business/system table separation 

---

---

**DESIGN APPROACH:** Hybrid model with business entities (ER diagram) + system tables (compliance)  
**BUSINESS TABLES IN ER DIAGRAM:** 3  
**SYSTEM TABLES FOR PHASE VII:** 2  
**TOTAL TABLES IN DATABASE:** 5  
**PHASE VII READINESS:** HOLIDAYS and AUDIT_LOG tables designed for business rule implementation  
**STUDENT:** IZA KURADUSENGE Emma Lise (28246)  
**COURSE:** Database Development with PL/SQL  
**UNIVERSITY:** AUCA  
**PHASE:** III - Logical Model Design Complete  
**DATE:** December 2025  
**NOTE:** Design supports all Phase I-VIII requirements while maintaining clean separation between business modeling and system compliance.

