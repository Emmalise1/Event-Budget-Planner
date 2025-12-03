# PHASE I: Problem Statement

## PL/SQL Practicum Project Proposal
### Project Title: Event Budget Planner System
### Student Name: IZA KURADUSENGE Emma Lise
### Student ID: 28246
### Course: Database Development with PL/SQL
### Area: Business

---

## 1. Project Idea

The Event Budget Planner System offers a new and intelligent solution via a PL/SQL-based system to change the way people plan, manage, and control expenditures at events. Instead of using spreadsheets or rough estimates, the system allows users to impose a budget, categorize expenditures, and record every transaction in real time.

What differentiates the system is its inherent financial awareness; if, at any time a recent expenditure puts you in danger of exceeding your limit, smart PL/SQL triggers will inform you, and prevent you from spending as far down the road as possible. The system is somewhat like a personal financial assistant, embedded directly into your event planning process.

Whether it is a wedding, a concert, or a small celebration, the tool allows for a clean, data-driven view of your finances. It combines automated data collection with prescriptive decision support. The system not only tracks expenses but also directs you toward a healthier financial position, encourages better planning, and lets you focus on a stress-free event experience.

---
## Target Users
- Event planners  
- Individuals organizing weddings, parties, or conferences  
- Small event management businesses  
- Finance teams managing event budgets  
---

## Business Intelligence (BI) Potential
The system will support decision-making through:
- Spending trend analysis per event and category  
- Budget utilization dashboards  
- Risk prediction of budget overruns  
- Identification of high-cost categories  

---

## 2. Database Schema Overview

### Main Tables:

#### **EVENTS Table**
- `event_id` (PK) - Unique identifier for each event
- `event_name` - Name of the event
- `event_date` - Scheduled date of the event
- `total_budget` - Total budget allocated for the event

#### **EXPENSE_CATEGORIES Table** 
- `category_id` (PK) - Unique identifier for each category
- `event_id` (FK) - References EVENTS(event_id)
- `category_name` - Name of the expense category (e.g., Venue, Food, Decorations)
- `budget_limit` - Maximum amount allowed for this category

#### **EXPENSES Table**
- `expense_id` (PK) - Unique identifier for each expense
- `category_id` (FK) - References EXPENSE_CATEGORIES(category_id)
- `description` - Description of what was purchased
- `amount` - Cost of the expense
- `date_added` - Date when the expense was recorded

---

## 3. PL/SQL Components

### Procedures:
1. **`calculate_total_expenses`** - Computes total expenses for each event
2. **`add_expense_with_validation`** - Adds new expenses with automatic budget checking
3. **`generate_budget_report`** - Creates summary reports of spending

### Functions:
1. **`get_remaining_balance`** - Returns remaining balance for each category
2. **`calculate_budget_utilization`** - Calculates percentage of budget used
3. **`predict_overrun_risk`** - Estimates risk of exceeding budget

### Triggers:
1. **`check_budget_limit`** - Alerts users if a new expense exceeds category or total budget
2. **`update_category_spending`** - Automatically updates category totals when expenses are added
3. **`restrict_weekday_and_holiday_dml`** - Restricts database changes to weekends only (business rule)

### Packages:
1. **`budget_management_pkg`** - Groups all budget-related procedures and functions
2. **`reporting_pkg`** - Contains all reporting and analytics functions
3. **`audit_pkg`** - Manages audit logging and security features

---

## 4. Innovation or Improvement

The Event Budget Planner System builds on traditional expenses tracking by introducing a smart, automated budgeting experience, powered entirely in PL/SQL. No longer is it just about recording numbers, it is about building a system that thinks with the user.

### Key Innovations:

#### **Real-time Overspending Alerts**
Smart triggers alert users instantly when nearing spending limits much like having a personal finance coach.

#### **Dynamic Budget Insights**
Functions and procedures continually calculate totals, balances, and spending against each budget to give information on real-time financial status.

#### **Multi-event Support**
Manage several budgeting events separately from each other, including categories and each event's budgets.

#### **Data-Informed Decision Making**
Creates reports to visualize spending habits, which fosters accountability and smarter spending plans.

The Event Budget Planner System creates an automated, intelligent, and interactive experience, empowering users to plan memorable events without giving up full control over finances.
