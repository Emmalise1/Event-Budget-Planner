# PHASE III: ER Diagram & System Architecture
## Event Budget Planner System

## 1. ENTITIES (3 TABLES)

### Table 1: EVENTS
Attributes:
- event_id (PK) - Primary Key
- event_name
- event_date
- total_budget
- created_by
- created_date

### Table 2: EXPENSE_CATEGORIES
Attributes:
- category_id (PK) - Primary Key
- event_id (FK) - Foreign Key to EVENTS
- category_name
- budget_limit

### Table 3: EXPENSES
Attributes:
- expense_id (PK) - Primary Key
- category_id (FK) - Foreign Key to EXPENSE_CATEGORIES
- description
- amount
- vendor_name
- payment_status

## 2. ER DIAGRAM RELATIONSHIPS

EVENTS (1) --- HAS --- (M) EXPENSE_CATEGORIES (1) --- CONTAINS --- (M) EXPENSES

Visual Representation:
EVENTS --1:M--> EXPENSE_CATEGORIES --1:M--> EXPENSES

Meaning:
- One EVENT can have many EXPENSE_CATEGORIES
- One EXPENSE_CATEGORY can have many EXPENSES
- Each EXPENSE belongs to exactly one CATEGORY
- Each CATEGORY belongs to exactly one EVENT

## 3. CARDINALITIES

| From Table | To Table | Cardinality | Description |
|------------|----------|-------------|-------------|
| EVENTS | EXPENSE_CATEGORIES | 1:M | One event has many categories |
| EXPENSE_CATEGORIES | EXPENSES | 1:M | One category contains many expenses |

## 4. PRIMARY KEYS (PK)

1. EVENTS.event_id - Unique identifier for each event
2. EXPENSE_CATEGORIES.category_id - Unique identifier for each category
3. EXPENSES.expense_id - Unique identifier for each expense

## 5. FOREIGN KEYS (FK)

1. EXPENSE_CATEGORIES.event_id references EVENTS.event_id
   - Links each category to its parent event
   - ON DELETE CASCADE: If event is deleted, all its categories are deleted

2. EXPENSES.category_id references EXPENSE_CATEGORIES.category_id
   - Links each expense to its parent category
   - ON DELETE CASCADE: If category is deleted, all its expenses are deleted

## 6. CONSTRAINTS

### NOT NULL Constraints (Required fields):
- EVENTS: event_name, event_date, total_budget
- EXPENSE_CATEGORIES: category_name, budget_limit
- EXPENSES: description, amount

### CHECK Constraints (Business rules):
- total_budget > 0 (Budget must be positive)
- budget_limit > 0 (Category limit must be positive)
- amount > 0 (Expense amount must be positive)
- warning_threshold BETWEEN 50 AND 95 (Alert between 50% to 95% spending)

### DEFAULT Values (Auto-filled):
- created_date = SYSDATE (current date/time)
- date_added = SYSDATE (current date/time)
- status = 'PLANNING' (default event status)
- payment_status = 'PENDING' (default payment status)

## 7. NORMALIZATION (3NF ACHIEVED)

### First Normal Form (1NF):
- Each table has a primary key
- All columns contain atomic values (no lists or arrays)
- No repeating groups of columns

### Second Normal Form (2NF):
- All non-key columns depend on the ENTIRE primary key
- Example: In EXPENSES table, 'amount' depends on the whole 'expense_id' (not just part of it)

### Third Normal Form (3NF):
- No transitive dependencies (no column depends on another non-key column)
- Example: 'vendor_name' does not determine 'amount', and 'amount' does not determine 'payment_status'

### Benefits of 3NF:
1. **No Data Duplication** - Each fact stored in one place only
2. **Easy Updates** - Change data in one location only
3. **Data Integrity** - Prevents inconsistent data
4. **Efficient Storage** - Reduces database size

## 8. BI (BUSINESS INTELLIGENCE) CONSIDERATIONS

### Fact Table:
- **EXPENSES** - Contains measurable numerical data (amounts)

### Dimension Tables:
- **EVENTS** - Descriptive attributes about events
- **EXPENSE_CATEGORIES** - Descriptive attributes about categories

### Potential Reports:
1. Budget vs Actual Spending Report
2. Category-wise Expense Analysis
3. Vendor Payment Tracking Report
4. Event Status Dashboard

### Audit Trail Design:
- Will be implemented in Phase VII using triggers
- Will track: user actions, date/time, old values, new values
- Will log attempted violations of business rules

---

**DESIGNED BY:** IZA KURADUSENGE Emma Lise
**STUDENT ID:** 28246
**PHASE:** III - Logical Model Design
**DATE:** December 2025
