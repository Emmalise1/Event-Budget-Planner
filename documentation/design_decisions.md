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

## 7. AUDIT TRAIL DESIGN (Phase VII)

### What Will Be Audited:
1. All INSERT operations on EXPENSES table
2. Attempts to exceed budget limits (will be calculated)
3. Payment status changes
4. Foreign key violation attempts

### Audit Implementation Plan:
1. **AUDIT_LOG Table** (to be created in Phase VII):
   - audit_id (PK)
   - table_name (EVENTS, CATEGORIES, EXPENSES)
   - operation_type (INSERT, UPDATE, DELETE)
   - user_name (from created_by)
   - timestamp (SYSDATE)
   - old_values (for UPDATE/DELETE)
   - new_values (for INSERT/UPDATE)
   - success_status (SUCCESS/FAILED)

2. **Database Triggers** (Phase VII):
   - Will automatically log all expense additions
   - Will log failed operations (budget exceeded)
   - Will track who made changes and when

## 8. LIMITATIONS & FUTURE ENHANCEMENTS

### Current Limitations:
1. No budget warning system (missing warning_threshold)
2. No event status tracking (missing status column)
3. No automatic category spending tracking (missing current_spending)
4. No user authentication system
5. No vendor management beyond name

### Phase 2.0 Enhancements (Future):
1. Add warning_threshold column to EXPENSE_CATEGORIES
2. Add status column to EVENTS table
3. Add current_spending column to EXPENSE_CATEGORIES
4. Create USERS table for authentication
5. Create VENDORS table for vendor management
6. Add budget transfer functionality

## 9. SUCCESS CRITERIA FOR PHASE III

### Phase III Complete When:
- ER diagram created with 3 tables and relationships  
- Data dictionary documents 17 columns across 3 tables  
- Design decisions documented (why 3 tables, no extra columns)  
- Assumptions clearly stated (business and technical)  
- Normalization to 3NF explained and justified  
- BI considerations identified (fact vs dimension tables)  
- All files committed to GitHub documentation folder  

---

**PROJECT:** Event Budget Planner System  
**STUDENT:** IZA KURADUSENGE Emma Lise  
**ID:** 28246  
**COURSE:** Database Development with PL/SQL  
**UNIVERSITY:** AUCA  
**PHASE:** III - Logical Model Design Complete  
**DATE:** December 2025  

