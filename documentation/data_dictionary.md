# PHASE III: Data Dictionary
## Event Budget Planner System

| Table | Column | Type | Constraints | Purpose |
|-------|--------|------|-------------|---------|
| EVENTS | event_id | NUMBER(10) | PK, NOT NULL | Unique event identifier |
| EVENTS | event_name | VARCHAR2(100) | NOT NULL | Name of the event |
| EVENTS | event_date | DATE | NOT NULL | Scheduled date of event |
| EVENTS | total_budget | NUMBER(12,2) | NOT NULL, CHECK > 0 | Total allocated budget |
| EVENTS | created_by | VARCHAR2(100) | - | User who created event |
| EVENTS | created_date | DATE | DEFAULT SYSDATE | Date event was created |
| EXPENSE_CATEGORIES | category_id | NUMBER(10) | PK, NOT NULL | Unique category identifier |
| EXPENSE_CATEGORIES | event_id | NUMBER(10) | FK → EVENTS, NOT NULL | Associated event |
| EXPENSE_CATEGORIES | category_name | VARCHAR2(100) | NOT NULL | Name of expense category |
| EXPENSE_CATEGORIES | budget_limit | NUMBER(12,2) | NOT NULL, CHECK > 0 | Maximum amount for category |
| EXPENSES | expense_id | NUMBER(10) | PK, NOT NULL | Unique expense identifier |
| EXPENSES | category_id | NUMBER(10) | FK → CATEGORIES, NOT NULL | Associated category |
| EXPENSES | description | VARCHAR2(200) | NOT NULL | Description of expense |
| EXPENSES | amount | NUMBER(10,2) | NOT NULL, CHECK > 0 | Cost of expense |
| EXPENSES | vendor_name | VARCHAR2(200) | - | Vendor/supplier name |
| EXPENSES | payment_status | VARCHAR2(20) | DEFAULT 'PENDING' | Payment status |
| EXPENSES | date_added | DATE | DEFAULT SYSDATE | Date expense recorded |

## RELATIONSHIPS

### Relationship 1: EVENTS to EXPENSE_CATEGORIES
- **Type:** One-to-Many (1:M)
- **Foreign Key:** EXPENSE_CATEGORIES.event_id → EVENTS.event_id
- **Rule:** One event can have many categories
- **Delete Rule:** CASCADE (Delete event → Delete all its categories)

### Relationship 2: EXPENSE_CATEGORIES to EXPENSES
- **Type:** One-to-Many (1:M)
- **Foreign Key:** EXPENSES.category_id → EXPENSE_CATEGORIES.category_id
- **Rule:** One category can have many expenses
- **Delete Rule:** CASCADE (Delete category → Delete all its expenses)

## SAMPLE DATA

### EVENTS Sample Row:
| Column | Value |
|--------|-------|
| event_id | 1 |
| event_name | "Annual Conference" |
| event_date | 2025-12-15 |
| total_budget | 1000000 |
| created_by | "Emma" |
| created_date | 2025-12-03 |

### EXPENSE_CATEGORIES Sample Row:
| Column | Value |
|--------|-------|
| category_id | 101 |
| event_id | 1 |
| category_name | "Venue" |
| budget_limit | 300000 |

### EXPENSES Sample Row:
| Column | Value |
|--------|-------|
| expense_id | 1001 |
| category_id | 101 |
| description | "Conference hall booking" |
| amount | 150000 |
| vendor_name | "Kigali Convention Centre" |
| payment_status | "PAID" |
| date_added | 2025-12-03 |

## CONSTRAINT SUMMARY

### Primary Keys:
1. EVENTS.event_id
2. EXPENSE_CATEGORIES.category_id
3. EXPENSES.expense_id

### Foreign Keys:
1. EXPENSE_CATEGORIES.event_id → EVENTS.event_id
2. EXPENSES.category_id → EXPENSE_CATEGORIES.category_id

### Check Constraints:
1. total_budget > 0
2. budget_limit > 0
3. amount > 0
4. payment_status IN ('PENDING','PAID','CANCELLED')

### Default Values:
1. created_date = SYSDATE
2. date_added = SYSDATE
3. payment_status = 'PENDING'

---

**TOTAL TABLES:** 3  
**TOTAL COLUMNS:** 17  
**NORMALIZATION:** 3NF Achieved  
**STUDENT:** IZA KURADUSENGE Emma Lise (28246)
