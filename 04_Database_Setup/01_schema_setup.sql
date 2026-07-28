-- ============================================================================
-- Script 01: PDB Creation, Container Session Switch, User Setup & Privileges
-- System: Tourism Booking MIS
-- Student ID & User: Seth (32481_2025)
-- ============================================================================

-- Execute as SYSDBA

-- 1. Create the PDB using the correct source path
CREATE PLUGGABLE DATABASE PDB_32481_2025_TOURISM_BOOKING_DB
  ADMIN USER U_32481_2025_TOURISM_BOOKING_DB IDENTIFIED BY "Tourism123#"
  ROLES = (DBA)
  FILE_NAME_CONVERT = (
    'C:\APP\RISA\PRODUCT\21C\ORADATA\XE\PDBSEED\', 
    'C:\APP\RISA\PRODUCT\21C\ORADATA\XE\PDB_32481_2025_TOURISM_BOOKING_DB\'
  );

-- 2. Open the new PDB
ALTER PLUGGABLE DATABASE PDB_32481_2025_TOURISM_BOOKING_DB OPEN READ WRITE;

-- 3. Save state so it opens automatically when Oracle restarts
ALTER PLUGGABLE DATABASE PDB_32481_2025_TOURISM_BOOKING_DB SAVE STATE;

-- 4. Switch context to the new PDB
ALTER SESSION SET CONTAINER = PDB_32481_2025_TOURISM_BOOKING_DB;

-- 5. Grant privileges to the admin user (inside the PDB context)
GRANT ALL PRIVILEGES TO U_32481_2025_TOURISM_BOOKING_DB;
GRANT DBA TO U_32481_2025_TOURISM_BOOKING_DB;

PROMPT PDB and Admin User setup complete. Connected to PDB_32481_2025_TOURISM_BOOKING_DB.

