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

## 5. Memory Parameters Configuration  

### Current Memory Settings
- **SGA Target:** 256M  
- **PGA Aggregate Target:** 128M  
- **Memory Target:** Auto-managed by Oracle 21c  

### Configuration Commands
```sql
ALTER SYSTEM SET sga_target = 256M SCOPE = BOTH;
ALTER SYSTEM SET pga_aggregate_target = 128M SCOPE = BOTH;
```

## 6. Archive Logging Configuration  

- **Archive Logging Status:** ENABLED  

### Configuration Process
- Database switched to mount mode  
- Archive logging enabled  
- Database reopened in archive mode  

### Verification
```sql
-- Before: NOARCHIVELOG
-- After: ARCHIVELOG
SELECT log_mode FROM v$database;
```

## 7. Autoextend Parameters  

### Autoextend Configuration

| Tablespace   | Initial Size | Autoextend Increment | Maximum Size |
|--------------|--------------|----------------------|--------------|
| EVENT_DATA   | 100M         | 50M                  | 500M         |
| EVENT_IDX    | 50M          | 25M                  | 200M         |
| EVENT_TEMP   | 50M          | 25M                  | 200M         |

## 8. Verification Queries  

### PDB Verification
```sql
SELECT name, open_mode 
FROM v$pdbs 
WHERE name = 'WED_28246_EMMA_EVENT_BUDGET_PLANNER_DB';
```
### Tablespace Verification
```sql
SELECT tablespace_name, status, contents  
FROM dba_tablespaces  
WHERE tablespace_name LIKE 'EVENT%';
```
### User Verification
```sql
SELECT username, account_status, default_tablespace, temporary_tablespace  
FROM dba_users  
WHERE username = 'EVENT_ADMIN';
```
### Memory Verification
```sql
SELECT name, value  
FROM v$parameter  
WHERE name IN ('sga_target', 'pga_aggregate_target');
```
## 9. Completion Checklist  

- [x] PDB created with correct naming convention  
- [x] Admin user created with identifiable username  
- [x] Password set to student's first name (emma)  
- [x] Super admin privileges granted (DBA role)  
- [x] Tablespaces created for data and indexes  
- [x] Temporary tablespace configured  
- [x] Memory parameters (SGA, PGA) configured  
- [x] Archive logging enabled  
- [x] Autoextend parameters set on all tablespaces  
- [x] All configurations tested and verified
      
## 10. Screenshots  

### Phase IV Implementation Screenshots

**Screenshot 1: PDB Creation Success**  
![PDB Creation](https://github.com/Emmalise1/Event-Budget-Planner/blob/main/screenshots/phase_iv/01_pdb_creation.png?raw=true)  
*Figure 1: PDB `WED_28246_EMMA_EVENT_BUDGET_PLANNER_DB` successfully created and opened*

**Screenshot 2: Tablespace Configuration**  
![Tablespace Configuration](https://github.com/Emmalise1/Event-Budget-Planner/blob/main/screenshots/phase_iv/02_tablespaces.png?raw=true)  
*Figure 2: `EVENT_DATA`, `EVENT_IDX`, and `EVENT_TEMP` tablespaces created with proper specifications*

**Screenshot 3: Memory Parameters**  
![Memory Parameters](https://github.com/Emmalise1/Event-Budget-Planner/blob/main/screenshots/phase_iv/03_memory_config.png?raw=true
)  
*Figure 3: `SGA_TARGET` (256M) and `PGA_AGGREGATE_TARGET` (128M) successfully configured*

**Screenshot 4: Archive Logging Enabled**  
![Archive Logging](https://github.com/Emmalise1/Event-Budget-Planner/blob/main/screenshots/phase_iv/04_archive_logging.png?raw=true)  
*Figure 4: Archive logging enabled (`ARCHIVELOG` mode) for database recovery*

## 11. Conclusion  

### Phase IV Success Summary
The Event Budget Planner System database has been successfully created and configured according to all specified requirements. The implementation includes:

- **Proper Naming Convention:** PDB name follows the required format `wed_28246_emma_event_budget_planner_db`  
- **Complete Security Setup:** Admin user `event_admin` with password `emma` and DBA privileges  
- **Optimized Storage:** Three dedicated tablespaces with appropriate sizing and autoextend parameters  
- **Performance Configuration:** Memory parameters tuned for optimal performance  
- **Data Protection:** Archive logging enabled for data recovery and audit purposes  

### Technical Achievements
- Successfully created Oracle 21c pluggable database  
- Configured all required memory and storage parameters  
- Implemented enterprise-grade security with DBA privileges  
- Enabled critical database features including archive logging  
- Verified all configurations through comprehensive testing  

### Phase V Readiness
The database is now fully prepared for Phase V implementation. All infrastructure is in place for:

- Creating the 5 core business and system tables  
- Inserting sample data (100–500 rows)  
- Implementing constraints and indexes  
- Beginning PL/SQL development in Phase VI  

### Files Created for Phase IV
- `database/scripts/01_database_creation.sql` – Complete database setup script  
- `documentation/phase4_database_creation.md` – This completion report  
- `documentation/project_overview.md` – Updated project documentation  
- `screenshots/phase_iv/` – Complete visual documentation  

### Database Metadata
- **Database Created By:** IZA KURADUSENGE Emma Lise  
- **Student ID:** 28246  
- **Phase:** IV – Database Creation Complete  
- **Date:** December 2025  
- **Database Name:** `wed_28246_emma_event_budget_planner_db`  
- **Status:**  Ready for Phase V Implementation


