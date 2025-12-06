# PHASE V: TABLE IMPLEMENTATION & DATA INSERTION
## Event Budget Planner System

### Project Information
- **Student:** Emma Lise IZA KURADUSENGE
- **Student ID:** 28246
- **Course:** Database Development with PL/SQL (INSY 8311)
- **Group:** Wednesday
- **Lecturer:** Eric Maniraguha

### Executive Summary
Phase V involved the implementation of physical database tables and insertion of comprehensive test data. This phase successfully created 5 normalized tables, inserted 1,580+ rows of realistic data, and verified all data integrity requirements. The database is now ready for PL/SQL development in Phase VI.

### Objectives Accomplished
1. Created 5 normalized database tables with proper constraints
2. Inserted 1,580+ rows of realistic test data
3. Verified data integrity through comprehensive validation queries
4. Demonstrated all required query types (SELECT *, Joins, GROUP BY, Subqueries)
5. Implemented business rules and constraint enforcement
6. Prepared database for Phase VI PL/SQL development

### Database Schema Implementation

#### Tables Created
1. **EVENTS** - Main event information (150+ rows)
2. **EXPENSE_CATEGORIES** - Budget categories per event (815+ rows)
3. **EXPENSES** - Individual expense transactions (550+ rows)
4. **HOLIDAYS** - Public holidays for Phase VII restrictions (15 rows)
5. **AUDIT_LOG** - Audit trail for Phase VII requirements (50+ rows)

#### Key Constraints Implemented
- Primary Keys on all tables
- Foreign Keys with CASCADE DELETE
- CHECK constraints for business rules
- NOT NULL constraints for required fields
- UNIQUE constraints where appropriate
- DEFAULT values for common fields

### Data Insertion Details

#### Volume Requirements Met
| Table | Rows Inserted | Requirement | Status |
|-------|--------------|-------------|--------|
| EVENTS | 150+ | 100+ | PASS |
| EXPENSE_CATEGORIES | 815+ | 200+ | PASS |
| EXPENSES | 550+ | 500+ | PASS |
| HOLIDAYS | 15 | 8+ | PASS |
| AUDIT_LOG | 50+ | Sample | PASS |
| **TOTAL** | **1,580+** | **1,000+** | **PASS** |

#### Data Characteristics
- **Realistic Scenarios:** Based on actual event planning scenarios
- **Demographic Mix:** Various event types (Weddings, Conferences, Corporate, Charity, etc.)
- **Edge Cases:** Includes NULL values for testing
- **Business Rules:** All constraints validated
- **Referential Integrity:** Foreign key relationships maintained

### Query Type Demonstrations

---

###  Screenshot 1: Basic Retrieval (SELECT *)

![Basic Retrieval](https://github.com/Emmalise1/Event-Budget-Planner/blob/main/screenshots/test_results/Basic%20retrieval1..PNG?raw=true)  

![Basic Retrieval](https://github.com/Emmalise1/Event-Budget-Planner/blob/main/screenshots/test_results/Basic%20retrieval2..PNG?raw=true)
*Figure 1: All 5 tables successfully returned data using SELECT * queries. Sample data from each table was verified for correctness and completeness.*

---

###  Screenshot 2: Joins (Multi-table Queries)

![Join Results](https://github.com/Emmalise1/Event-Budget-Planner/blob/main/screenshots/test_results/Joins1.PNG?raw=true)

![Join Results](https://github.com/Emmalise1/Event-Budget-Planner/blob/main/screenshots/test_results/Joins2.PNG?raw=true)

![Join Results](https://github.com/Emmalise1/Event-Budget-Planner/blob/main/screenshots/test_results/Joins3.PNG?raw=true)

*Figure 2: Multiple join types demonstrated, including INNER JOIN for event-category-expense chains, LEFT JOIN for budget vs actual analysis, and multi-table joins with filtering.*

---

###  Screenshot 3: Aggregations (GROUP BY)

![Aggregations](https://github.com/Emmalise1/Event-Budget-Planner/blob/main/screenshots/test_results/Group%20by%201.PNG?raw=true)  
*Figure 3: Statistical analysis using GROUP BY including event type distribution with COUNT, AVG, SUM, MIN, MAX, payment status analysis, monthly expense trends, and vendor performance metrics.*

---

###  Screenshot 4: Subqueries

![Subqueries](https://github.com/Emmalise1/Event-Budget-Planner/blob/main/screenshots/test_results/Subquery%201.PNG?raw=true)

![Subqueries](https://github.com/Emmalise1/Event-Budget-Planner/blob/main/screenshots/test_results/Subquery%202.PNG?raw=true)

*Figure 4: Demonstration of  subquery types including simple WHERE subqueries, EXISTS, NOT EXISTS, IN subqueries, correlated subqueries, and nested subqueries for complex analysis.*

---

##  Phase V Data Integrity Verification

---

###  Screenshot 5: Data Integrity Validation

![Data Integrity](https://github.com/Emmalise1/Event-Budget-Planner/blob/main/screenshots/test_results/Data%20Integrity%20Summary.PNG?raw=true)  
*Figure 5: Validation results confirming referential integrity, constraint enforcement, and absence of orphaned records.*

---

###  Validation Results Summary
- All SELECT queries return data: **PASS**  
- All constraints properly enforced: **PASS**  
- Foreign key relationships validated: **PASS**  
- Data completeness verified: **PASS**  
- CASCADE DELETE working correctly: **PASS**  
- No orphaned records found: **PASS**  

---

###  Business Rule Enforcement Confirmed
- No negative budgets or amounts  
- Valid payment statuses only (**PENDING, PAID, CANCELLED, PARTIAL**)  
- Unique holiday dates enforced  
- Required fields populated  
- Default values applied correctly  


##  Screenshot Organization

All verification screenshots have been organized in the following structure:

### 1. `screenshots/test_results/`
- `basic_retrieval.jpg` – SELECT * results from all 5 tables  
- `joins_results.jpg` – Multi-table join query outputs  
- `aggregations.jpg` – GROUP BY aggregation results  
- `subqueries.jpg` – Various subquery demonstrations  
- `data_integrity.jpg` – Data integrity verification summary  

### 2. `screenshots/database_objects/`
- Table creation confirmation  
- Constraint definitions  
- Index creation verification  

### 3. `screenshots/oem_monitoring/`
- Database performance metrics 
- Tablespace usage statistics  

---

##  Testing Methodology

###  Test Cases Executed
1. **Basic Retrieval Test:** Verified all tables return data  
2. **Join Test:** Validated foreign key relationships  
3. **Aggregation Test:** Confirmed statistical functions work  
4. **Subquery Test:** Verified all subquery types execute  
5. **Constraint Test:** Validated business rule enforcement  
6. **Data Integrity Test:** Confirmed referential integrity  
7. **Edge Case Test:** Verified NULL value handling  

###  Test Results Summary
- **Total Tests Executed:** 6  
- **Tests Passed:** 6  
- **Tests Failed:** 0  
- **Success Rate:** 100%  

---

##  Key Statistics

###  Event Distribution
- **WEDDING:** 40 events (Average budget: RWF 17,097,775)  
- **CORPORATE:** 35 events (Average budget: RWF 10,414,114)  
- **CONFERENCE:** 30 events (Average budget: RWF 27,974,833)  
- **CHARITY:** 25 events (Average budget: RWF 5,781,520)  
- **OTHER:** 14 events (Average budget: RWF 2,166,643)  
- **BIRTHDAY:** 6 events (Average budget: RWF 2,735,333)  

###  Payment Status Distribution
- **PAID:** 300 expenses (54.55% of total)  
- **PENDING:** 200 expenses (36.36% of total)  
- **CANCELLED:** 50 expenses (9.09% of total)  

###  Vendor Analysis
Top 5 vendors by total spending have been identified, with the highest being **Ubumwe Grande Hotel** (63 transactions, RWF 26.9M total).

---

##  Challenges and Solutions

###  Challenge 1: GROUP BY Syntax Errors
**Issue:** Oracle's strict GROUP BY requirements caused errors in some join queries.  
**Solution:** Used `FETCH FIRST N ROWS ONLY` instead of `ROWNUM` in GROUP BY queries and ensured all non-aggregated columns were included in the GROUP BY clause.

###  Challenge 2: Data Volume Requirements
**Issue:** Meeting the 500+ rows requirement for the expenses table.  
**Solution:** Implemented PL/SQL loops to generate realistic expense data for each category.

###  Challenge 3: Constraint Validation
**Issue:** Verifying all constraints were properly enforced.  
**Solution:** Created comprehensive validation queries that test each constraint type.

---

##  Conclusion

**Phase V has been successfully completed** with all requirements satisfied. The database is now:

1. **Fully Populated:** 1,580+ rows of realistic data  
2. **Properly Normalized:** 5 tables in 3NF  
3. **Integrity Verified:** All constraints and relationships validated  
4. **Tested:** All query types demonstrated successfully  
5. **Documented:** Comprehensive documentation and screenshots provided  
6. **Ready for Development:** Prepared for Phase VI PL/SQL implementation  

The Event Budget Planner System database now serves as a solid foundation for the advanced PL/SQL development scheduled for Phase VI.

---

##  Next Steps

Proceed to **Phase VI: PL/SQL Development**, which will include:

1. Procedures (3–5 required)  
2. Functions (3–5 required)  
3. Cursors and bulk operations  
4. Window functions  
5. Packages  
6. Exception handling  

---

###  Document Information
- **Document Generated:** December 4, 2025  
- **Student:** Emma Lise IZA KURADUSENGE (ID: 28246)  
- **Course:** Database Development with PL/SQL  
- **Lecturer:** Eric Maniraguha  
