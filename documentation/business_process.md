# PHASE II: Business Process Modeling
## Event Budget Planner System

## 1. PROCESS SCOPE & OBJECTIVES

### Scope:
The business process models the complete workflow for event budget planning, from initial event creation through expense tracking to final reporting. The scope includes automated budget validation, real-time expense tracking, and financial reporting.

### MIS Relevance:
This is a **Management Information System (MIS)** that transforms raw financial data into meaningful information for decision-making. It replaces manual spreadsheet tracking with automated database-driven processes.

### Objectives:
1. **Automate** budget tracking and expense validation
2. **Provide real-time** financial insights for event planners
3. **Enforce** business rules through database constraints
4. **Generate** actionable reports for financial decision-making
5. **Reduce** manual errors in budget management

### Expected Outcomes:
- 80% reduction in manual calculation errors
- Real-time budget visibility for planners
- Automated alerts for budget violations
- Historical data for future planning reference

## 2. KEY ENTITIES & ROLES

### Primary Actors:
1. **Event Planner** (Primary User)
   - Creates events and sets budgets
   - Defines expense categories
   - Records expense transactions
   - Reviews budget reports
   - Makes financial decisions

2. **System** (Database & PL/SQL Automation)
   - Validates data integrity
   - Enforces business rules
   - Performs calculations
   - Generates reports
   - Maintains audit trails

### Data Sources:
1. **User Input:** Event details, budget amounts, expense transactions
2. **System Calculations:** Budget utilization, remaining amounts, percentages
3. **Database Storage:** Historical data, audit logs, configuration settings

### Responsibilities:
- **Event Planner:** Data entry, decision-making, planning
- **System:** Validation, calculation, enforcement, reporting

## 3. PROCESS FLOW USING BPMN

### Diagram Overview:
The BPMN diagram uses **2 horizontal swimlanes** to separate:
- **Top Lane:** Event Planner (human activities)
- **Bottom Lane:** System (automated processes)

### Key BPMN Elements Used:

#### Start Events:
- ⚪ **Start Event Planning** - Process initiation by planner
- ⚪ **Budget Details Received** - System process start via message

#### Tasks:
- 👤 **User Tasks** (7 total) - Planner activities
- ⚙️ **Service Tasks** (9 total) - System/database operations
- 📊 **Business Rule Task** - Budget calculations

#### Gateways:
- ◇ **Exclusive Gateway** - Budget limit decision point
- ◇+ **Parallel Gateway** - Merging of process paths

#### Events:
- ⚪ **Intermediate Catch Events** (7 total) - Message reception
- ⚫ **End Events** (4 total) - Process completion points

#### Message Flows:
- ═══→ **Vertical connections** (8 total) - Communication between lanes

## 4. CORE BUSINESS PROCESSES

### Process 1: Event Creation & Budget Setup
```
1. START: Planner initiates event planning
2. Planner creates event with basic details
3. Planner defines total budget amount
4. SYSTEM validates budget (must be > 0)
5. SYSTEM saves event to database
6. Planner receives confirmation
7. Planner defines expense categories
8. SYSTEM saves categories
```

### Process 2: Expense Management & Validation
```
1. Planner enters expense details
2. Planner submits expense for validation
3. SYSTEM checks budget availability
4. DECISION: Within budget limit?
   - YES: Save expense, update spending totals
   - NO: Reject expense, log violation
5. Planner receives success/failure notification
```

### Process 3: Reporting & Analytics
```
1. Planner requests budget report
2. SYSTEM calculates budget vs actual totals
3. SYSTEM generates comprehensive report
4. Planner reviews report and insights
5. Process completes with planning decisions
```

## 5. DECISION POINTS & BUSINESS RULES

### Critical Decision Point:
**"Within Budget Limit?"** (Exclusive Gateway)
- **Condition:** (Current spending + New expense) ≤ Budget limit
- **Yes Path:** Expense approved, record saved
- **No Path:** Expense rejected, violation logged

### Business Rules Enforced:
1. **Budget Positivity:** All budget amounts > 0
2. **Real-time Validation:** Expense validation before saving
3. **Data Completeness:** Required fields cannot be NULL
4. **Referential Integrity:** Expenses must belong to valid categories

### Validation Points:
1. Budget amount validation (> 0 check)
2. Foreign key integrity (category/event existence)
3. Data type validation (numbers, dates, text formats)
4. Business rule enforcement (budget limits)

## 6. DATA FLOWS & HANDOFFS

### Input Data Flows:
1. **Event Data:** Name, date, total budget
2. **Category Data:** Category names, budget limits
3. **Expense Data:** Descriptions, amounts, vendors
4. **Report Requests:** Date ranges, detail levels

### Output Data Flows:
1. **Confirmation Messages:** Event saved, expense status
2. **Validation Results:** Approved/rejected notifications
3. **Reports:** Budget utilization, spending patterns
4. **Audit Trails:** Violation logs, change history

### Critical Handoff Points:
1. **Budget Submission:** Planner → System validation
2. **Expense Validation:** Planner → System check → Planner
3. **Report Generation:** Planner request → System calculation → Planner review

## 7. ORGANIZATIONAL IMPACT

### Efficiency Improvements:
- **Time Savings:** 70% reduction in manual calculations
- **Error Reduction:** Automated validation prevents overspending
- **Decision Speed:** Real-time data enables faster planning decisions

### Quality Enhancements:
- **Data Accuracy:** Database constraints ensure valid data
- **Consistency:** Standardized processes across all events
- **Transparency:** Clear audit trails for all transactions

### Strategic Benefits:
- **Better Planning:** Historical data informs future budgets
- **Cost Control:** Automated limits prevent budget overruns
- **Resource Optimization:** Focus human effort on planning, not calculations

## 8. ANALYTICS OPPORTUNITIES

### Immediate Analytics (Current System):
1. **Budget Utilization Rates:** Actual vs planned spending
2. **Category Analysis:** Spending patterns by category
3. **Vendor Analysis:** Frequently used vendors and costs
4. **Time-based Trends:** Spending patterns over event lifecycle

### Future BI Enhancements:
1. **Predictive Analytics:** Forecast final costs based on current spending
2. **Comparative Analysis:** Benchmark similar events
3. **Risk Scoring:** Identify high-risk spending categories
4. **ROI Analysis:** Event outcomes vs budget investment

### Data Mining Potential:
- Identify optimal budget allocations
- Detect spending pattern anomalies
- Predict budget overruns early
- Optimize vendor selection based on cost/quality

## 9. TECHNOLOGY INTEGRATION

### Current Integration:
- **Database:** Oracle PL/SQL for business logic
- **Validation:** Database constraints and triggers
- **Calculation:** SQL queries and PL/SQL functions

### Future Integration Opportunities:
1. **Mobile Interface:** Expense entry via mobile devices
2. **Payment Systems:** Direct integration with banking/payment gateways
3. **Document Management:** Receipt image storage and OCR
4. **Calendar Integration:** Event date synchronization

## 10. PROCESS METRICS & KPIs

### Performance Metrics:
1. **Process Time:** Event creation to completion
2. **Validation Speed:** Expense approval/rejection time
3. **Report Generation:** Time to produce reports
4. **User Satisfaction:** Reduction in planning stress

### Quality Metrics:
1. **Error Rate:** Failed validations per 100 transactions
2. **Budget Accuracy:** Planned vs actual variance
3. **Data Completeness:** Percentage of complete records
4. **System Uptime:** Availability for planning activities

### Business Impact Metrics:
1. **Cost Savings:** Reduction in budget overruns
2. **Time Savings:** Hours saved in manual calculations
3. **Decision Quality:** Improved planning outcomes
4. **Compliance Rate:** Adherence to budget policies

## 11. RISK MANAGEMENT

### Identified Risks:
1. **Data Integrity:** Invalid or incomplete data entry
2. **System Performance:** Slow response during peak planning
3. **User Errors:** Incorrect budget or expense entries
4. **Technical Failures:** Database or application outages

### Mitigation Strategies:
1. **Validation Layers:** Multiple validation points
2. **Performance Optimization:** Proper indexing and query design
3. **User Training:** Clear instructions and error messages
4. **Backup Systems:** Regular backups and recovery plans

## 12. CONCLUSION

The Event Budget Planner System represents a significant improvement over manual spreadsheet-based budgeting. By implementing this BPMN-modeled process, organizations can achieve:

- **Automated** budget validation and enforcement  
- **Real-time** financial visibility and insights  
- **Reduced** manual errors and calculation time  
- **Improved** decision-making through data-driven reports  
- **Scalable** process adaptable to events of any size  

This MIS solution transforms financial data management from a reactive, error-prone activity into a proactive, efficient, and reliable business process.

---

**DIAGRAM FILE:** ![business_process_diagram.png](https://github.com/Emmalise1/Event-Budget-Planner/blob/main/screenshots/BPMN%20Diagram.PNG?raw=true)  
**CREATED WITH:** Lucidchart  
**BPMN VERSION:** 2.0  
**STUDENT:** IZA KURADUSENGE Emma Lise  
**ID:** 28246  
**PHASE:** II - Business Process Modeling  
**DATE:** December 2025  
