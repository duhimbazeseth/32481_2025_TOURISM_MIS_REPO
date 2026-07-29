# Tourism Booking Management Information System — Oracle Database Capstone Project

<p align="center">
  <img src="https://img.shields.io/badge/Oracle-Database_19c-F80000?style=for-the-badge&logo=oracle&logoColor=white" alt="Oracle Database" />
  <img src="https://img.shields.io/badge/PL%2FSQL-Advanced_Programming-0073B7?style=for-the-badge&logo=oracle&logoColor=white" alt="PL/SQL" />
  <img src="https://img.shields.io/badge/Power_BI-Analytics_%26_Dashboards-F2C94C?style=for-the-badge&logo=powerbi&logoColor=black" alt="Power BI" />
  <img src="https://img.shields.io/badge/License-Academic_Capstone-green?style=for-the-badge" alt="License" />
</p>

---

## Executive Summary

The Tourism Booking Management Information System (MIS) is a relational database system built on Oracle Database, submitted as the Final Examination (Capstone Project) for **DPR400210 — Database Programming** at the University of Lay Adventists of Kigali (UNILAK). It automates tourist registration, tour package booking, transaction processing, and audit logging for a tourism management use case.

The system enforces operational integrity through calendar-based security triggers that restrict data-modification operations outside authorized business hours, and includes a Power BI analytical dashboard as its innovation component for reporting and decision support.

---

## Student and Course Information

| Parameter | Details |
| :--- | :--- |
| Student Name | Seth |
| Student ID | 32481_2025 |
| Course Code and Title | DPR400210 — Database Programming (Final Examination / Capstone Project) |
| Institution | University of Lay Adventists of Kigali (UNILAK) |
| Faculty | Faculty of Computing and Information Sciences |
| Instructor | Eric Maniraguha (ericmaniraguha2024@gmail.com) |
| Group | Session Day |
| Repository Name | 32481_2025_Seth_Tourism_DB |
| Academic Year | 2025–2026 |
| Maximum Marks | 40 |

### Important Dates

| Milestone | Date |
| :--- | :--- |
| Project Sharing Deadline | 22 July 2026 |
| Final Submission and Presentation | 30 July 2026 (no later than 08:00 AM) |

---

## Technology Stack and Environment

| Layer / Category | Technologies Used |
| :--- | :--- |
| Database Engine | Oracle Database 19c / Oracle Enterprise Manager (OEM) |
| Language and Scripts | SQL, PL/SQL (Stored Procedures, Functions, Packages, Triggers) |
| Security and Auditing | Compound Triggers, Audit Logs, Calendar-Based Access Rules |
| Business Intelligence | Microsoft Power BI Desktop (.pbix) |
| Version Control | Git and GitHub |
| Documentation and Modeling | UML / BPMN Swimlanes, ERD (3NF Standard), Markdown |

---

## Database and Repository Naming Convention

Per course requirements, all project artifacts follow the format:

```
StudentID_FirstName_Project_DB
```

Applied consistently to the Oracle database/user, GitHub repository, SQL and PL/SQL scripts, and all reports and documentation:

```
32481_2025_Seth_Tourism_DB
```

---

## Competencies Demonstrated

**Relational Database Architecture (3NF)**
End-to-end entity relationship modeling, database normalization to Third Normal Form (3NF), primary and foreign key mapping, and declarative constraint configuration (CHECK, UNIQUE, NOT NULL).

**Advanced PL/SQL Engineering**
Modular database programming using stored packages, parameterized procedures, functions, explicit cursors, dynamic SQL, and transaction control (COMMIT / ROLLBACK) with structured exception handling.

**Auditing and Security Controls**
Audit logging that tracks user-initiated INSERT, UPDATE, and DELETE operations, and compound triggers that enforce calendar-based restrictions on data modification.

**Business Intelligence and Data Analytics**
Integration of relational datasets into Power BI to produce KPI metrics, revenue tracking by tour package, and booking-fulfillment visual analytics.

---

## System Architecture and Project Phases

### Phase I: Problem Statement and Objectives

**Problem Definition:** Manual and legacy tourism booking workflows are prone to scheduling overlaps, unrecorded transaction changes, and unauthorized data access outside business hours.

**Context of Use:** A tourism management office handling tourist registration, package sales, and payment processing.

**Target Users:** Tourism booking agents, finance officers, and system administrators.

**Objectives:**
1. Centralize tourist profiles, tour package catalogs, and booking transactions into a normalized (3NF) Oracle schema.
2. Automate payment processing and capacity validation using PL/SQL packages.
3. Enforce calendar-based security rules that block modifications outside authorized operating windows.
4. Visualize revenue and customer trends using Power BI analytics.

**Expected Benefits:** Reduced booking errors, reliable audit history, and real-time visibility into revenue and fulfillment performance.

*Submission format: maximum 3 PowerPoint slides, Helvetica font (see `01_Documentation/Phase_I_Problem_Statement.pptx`).*

---

### Phase II: Business Process Modeling (MIS Workflow)

System scope, actors, and process flow, modeled using BPMN swimlanes from tourist registration through payment and audit logging:

```text
[ Tourist ] ───► Register Profile ───► Select Tour Package ───► Submit Booking
                                                                       │
[ Database System ] ◄── Validate Capacity & Business Rules ◄──────────┘
        │
        ├───► Calculate Package Pricing & Generate Invoice
        │
[ Finance Officer ] ───► Process & Verify Payment Status
        │
[ Audit Module ] ───► Write Entry to AUDIT_LOGS Table
```

*Full swimlane diagram and one-page explanation: `02_Diagrams/BPMN_Swimlane_Workflow.png`.*

---

### Phase III: Logical Database Design

- **Core Entities:** TOURISTS, PACKAGES, BOOKINGS, PAYMENTS, PUBLIC_HOLIDAYS, AUDIT_LOGS
- Entity attributes, primary and foreign key relationships, and cardinalities are defined in the ER diagram.
- Schema is normalized to Third Normal Form (3NF) to eliminate redundancy and update anomalies.

*ERD: `02_Diagrams/ERD_3NF_Diagram.png`.*

---

### Phase IV: Database Creation

- Dedicated Oracle database/user `32481_2025_Seth_Tourism_DB` created following the required naming convention.
- Privileges assigned on a least-privilege basis, provisioned separately from the SYSDBA account.
- Access configuration documented with Oracle Enterprise Manager (OEM) screenshots.

*Script: `04_Database_Setup/01_schema_setup.sql`.*

---

### Phase V: Table Implementation

- Tables created directly from the approved ERD.
- Constraints defined: PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE, CHECK.
- Meaningful sample data inserted to demonstrate referential integrity.

*Scripts: `04_Database_Setup/02_tables_and_constraints.sql`, `05_PLSQL_Scripts/03_sample_data.sql`.*

---

### Phase VI: PL/SQL Programming

- Parameterized procedures and functions for booking and payment logic.
- Packages grouping related procedures/functions.
- Explicit cursors for row-level processing.
- Structured exception handling throughout.
- DML/DDL operations with transaction control (COMMIT / ROLLBACK).

*Script: `05_PLSQL_Scripts/04_packages_and_procedures.sql`.*

---

### Phase VII: Advanced Database Programming (Business Rules and Audit Architecture)

- Simple and compound triggers enforcing business rules.
- **Business Rule:** INSERT, UPDATE, and DELETE operations are blocked when the transaction occurs on:
  1. Weekdays (Monday–Friday), restricted to authorized operating windows only.
  2. Official public holidays, verified against the `PUBLIC_HOLIDAYS` reference table.
- **Audit Trail:** User activity — user IDs, timestamps, modified table names, and operation types — is automatically recorded in the `AUDIT_LOGS` table.

*Script: `05_PLSQL_Scripts/05_triggers_and_auditing.sql`.*

> **Note:** Confirm the trigger logic in this script matches the restriction above exactly (weekdays plus public holidays) before final submission.

---

### Phase VIII: Documentation, Presentation, and Innovation

**GitHub Repository includes:** problem statement, SQL scripts, PL/SQL scripts, screenshots, and query explanations.

**Presentation:** maximum 10 slides, covering Introduction, Problem, Methodology, Database Design, Implementation, Results, and Conclusion. Submitted via email and Google Drive.

**Innovation Component (Power BI Analytics):** located at `06_Innovation_PowerBI/Tourism_Dashboard.pbix`, presenting:

- **Revenue per Package:** Financial breakdown across tour categories.
- **Booking Trends:** Tourist registration volume over time.
- **Payment Fulfillment:** Ratio of settled versus pending bookings.

---

## Marking Scheme Reference (40 Marks)

| Component | Marks |
| :--- | :---: |
| Problem definition and analysis | 3 |
| Business process modeling | 3 |
| ERD and normalization (3NF) | 4 |
| Table creation and constraints | 6 |
| SQL operations (DML and DDL) | 4 |
| PL/SQL (procedures, functions, packages) | 4 |
| Triggers and exception handling | 3 |
| Auditing and security implementation | 2 |
| Documentation and GitHub | 2 |
| Innovation (Power BI, APEX, dashboards, analytics) | 8 |
| **Direct total** | **39** |

*The "Problem definition and analysis" figure appears as 33 in the official exam document, which does not reconcile with the stated 40-mark total; 3 is used above as the likely intended value. Verify the exact weighting with the instructor before submission.*

---

## Submission Requirements

- [ ] GitHub repository link
- [ ] PowerPoint presentation (max. 10 slides)
- [ ] SQL scripts
- [ ] PL/SQL scripts
- [ ] Final report
- [ ] Live demonstration

## Final Demonstration Checklist

- [ ] Database structure
- [ ] Query execution
- [ ] PL/SQL programs
- [ ] Triggers and packages
- [ ] Audit system
- [ ] Innovation component (Power BI dashboard)

---

## Repository Directory Structure

```text
32481_2025_Seth_Tourism_DB/
├── 01_Documentation/
│   ├── Phase_I_Problem_Statement.pptx
│   └── Phase_VIII_Final_Presentation.pptx
├── 02_Diagrams/
│   ├── ERD_3NF_Diagram.png
│   └── BPMN_Swimlane_Workflow.png
├── 04_Database_Setup/
│   ├── 01_schema_setup.sql
│   └── 02_tables_and_constraints.sql
├── 05_PLSQL_Scripts/
│   ├── 03_sample_data.sql
│   ├── 04_packages_and_procedures.sql
│   └── 05_triggers_and_auditing.sql
├── 06_Innovation_PowerBI/
│   └── Tourism_Dashboard.pbix
└── README.md
```

---

## Academic Integrity Declaration

**Project Author:** Seth (32481_2025)
**Institution:** University of Lay Adventists of Kigali (UNILAK)

This is an individual examination project; no group work has been used. I declare that this capstone project represents my original database architectural design, programming work, and documentation, prepared for course evaluation. Any use of AI tools was limited to learning and support and does not replace my own understanding of the submitted work. All external sources and references have been acknowledged.