# PHASE IV: Database Creation
## Event Budget Planner System

## 1. DATABASE CREATION OVERVIEW
Successfully created Oracle 21c pluggable database with all required configurations for the Event Budget Planner System. The database is configured with proper naming convention, tablespaces, memory parameters, and security settings.

## 2. PLUGGABLE DATABASE (PDB) CREATION

### PDB Details:
- **PDB Name:** `wed_28246_emma_event_budget_planner_db`
- **Naming Convention:** GrpName_StudentId_FirstName_ProjectName_DB
- **Group:** Wednesday (WED)
- **Student ID:** 28246
- **First Name:** Emma
- **Project:** Event Budget Planner

### Creation Command:
```sql
CREATE PLUGGABLE DATABASE wed_28246_emma_event_budget_planner_db
ADMIN USER event_admin IDENTIFIED BY emma
FILE_NAME_CONVERT = ('C:\ORACLE21C\ORADATA\ORCL\PDBSEED\', 
                     'C:\ORACLE21C\ORADATA\ORCL\WED_28246_EMMA_EVENT_BUDGET_PLANNER_DB\');
```

## 3. Admin User Configuration  

### User Details
- **Username:** `event_admin`  
- **Password:** `emma`  
- **Privileges:** Super Admin (DBA Role)  
- **Default Tablespace:** `EVENT_DATA`  
- **Temporary Tablespace:** `EVENT_TEMP`  

### Privileges Granted
```sql
GRANT DBA TO event_admin;
GRANT UNLIMITED TABLESPACE TO event_admin;
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW TO event_admin;
GRANT CREATE SEQUENCE, CREATE SYNONYM TO event_admin;
```
## 4. Tablespace Configuration  

### Tablespace 1: EVENT_DATA (Data Storage)
```sql
CREATE TABLESPACE event_data  
DATAFILE 'C:\ORACLE21C\ORADATA\ORCL\WED_28246_EMMA_EVENT_BUDGET_PLANNER_DB\EVENT_DATA01.DBF'  
SIZE 100M  
AUTOEXTEND ON NEXT 50M MAXSIZE 500M;
```
Purpose: Stores all business tables (EVENTS, EXPENSE_CATEGORIES, EXPENSES)

### Tablespace 2: EVENT_IDX (Index Storage)
```sql
CREATE TABLESPACE event_idx  
DATAFILE 'C:\ORACLE21C\ORADATA\ORCL\WED_28246_EMMA_EVENT_BUDGET_PLANNER_DB\EVENT_IDX01.DBF'  
SIZE 50M  
AUTOEXTEND ON NEXT 25M MAXSIZE 200M;
```
Purpose: Stores all indexes for performance optimization

### Tablespace 3: EVENT_TEMP (Temporary Storage)
```sql
CREATE TEMPORARY TABLESPACE event_temp  
TEMPFILE 'C:\ORACLE21C\ORADATA\ORCL\WED_28246_EMMA_EVENT_BUDGET_PLANNER_DB\EVENT_TEMP01.DBF'  
SIZE 50M  
AUTOEXTEND ON NEXT 25M MAXSIZE 200M;
```
Purpose: Temporary storage for sorting operations and large queries
