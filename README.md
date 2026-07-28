# Tourism Booking MIS - Oracle Capstone Database Project

## Student Details
* **Student ID:** 32481_2025
* **Name:** Seth
* **Course Code:** DPR400210 - Database Programming
* **Institution:** UNILAK (University of Lay Adventists of Kigali)
* **Folder & Naming Format:** `32481_2025_Seth_Tourism_DB`

---

## Project Overview
This database system manages end-to-end tourist bookings, tour packages, payment records, audit management, and schedule-based integrity controls for Rwanda Tourism Management.

---

## Setup & Execution Order

1. **Database Schema Creation:**
   Run `04_Database_Setup/01_schema_setup.sql` as `SYSDBA` to create user `seth_tourism_db` and assign privileges.
2. **Table & Constraint Creation:**
   Run `04_Database_Setup/02_tables_and_constraints.sql` connected as `seth_tourism_db`.
3. **Data Population:**
   Execute `05_PLSQL_Scripts/03_sample_data.sql`.
4. **Business Logic & Packages:**
   Compile `05_PLSQL_Scripts/04_packages_and_procedures.sql`.
5. **Auditing & Restrictive Triggers:**
   Execute `05_PLSQL_Scripts/05_triggers_and_auditing.sql`.

---

## Innovation Component
This project integrates an interactive **Power BI Dashboard** (`06_Innovation_PowerBI/Tourism_Dashboard.pbix`) tracking key tourism metrics such as revenue per package, customer booking trends, and payment fulfillment statuses.