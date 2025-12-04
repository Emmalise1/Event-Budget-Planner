# Event Budget Planner System
## PL/SQL Capstone Project - INSY 8311

---
## Project Title and Overview
**Event Budget Planner System** is an Oracle PL/SQL database solution that automates event budget management with real-time validation, automated auditing, and business intelligence features. It replaces error-prone spreadsheet tracking with intelligent database automation.

---
## Student Name and ID

- STUDENT: "IZA KURADUSENGE Emma Lise"

- STUDENT_ID: 28246

- COURSE: "Database Development with PL/SQL (INSY 8311)"

- LECTURER: "Eric Maniraguha"

- UNIVERSITY: "Adventist University of Central Africa"

- SEMESTER: "I, 2025-2026"

- DEADLINE: "December 7, 2025"

---
## Problem Statement
Manual spreadsheet budgeting for events is error-prone, lacks real-time validation, and provides no automated alerts for overspending. This leads to budget overruns, financial crises during events, and inefficient resource allocation.

---
## Key Objectives
```sql
1. Automate budget tracking with real-time validation
2. Implement business rules via database constraints  
3. Create comprehensive audit trails
4. Provide BI analytics for decision-making
5. Restrict DML to weekends (Phase VII requirement)
```
---

## Quick Start Instructions

```
# 1. Clone Repository
git clone https://github.com/Emmalise1/Event-Budget-Planner.git
cd Event-Budget-Planner

# 2. Database Setup
sqlplus / as sysdba
@database/scripts/01_database_creation.sql

# 3. Table Implementation  
CONNECT event_admin/emma@tue_28246_emma_eventbudget_db
@database/scripts/02_table_creation.sql
@database/scripts/03_sample_data.sql

# 4. PL/SQL Development
@database/scripts/04_procedures_functions.sql
@database/scripts/05_triggers_audit.sql
```
``
---
## Links to Documentation
- [Phase I - Problem Statement](documentation/phase1_problem_statement.md)
- [Phase II - Business Process](documentation/phase2_business_process.md)  
- [Phase III - Logical Design](documentation/architecture.md)
- [Phase IV - Database Creation](documentation/phase4_database_creation.md)
- [Phase V - Table Implementation & Data Insertion](documentation/phase_v_report.md)
- [Data Dictionary](documentation/data_dictionary.md)
- [Design Decisions](documentation/design_decisions.md)
- [Database Scripts](database/scripts/)
- [Screenshots](screenshots/)
```
