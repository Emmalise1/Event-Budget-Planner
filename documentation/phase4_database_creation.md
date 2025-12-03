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
