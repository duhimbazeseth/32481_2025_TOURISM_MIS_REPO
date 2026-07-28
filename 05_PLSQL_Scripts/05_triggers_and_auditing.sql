-- ============================================================================
-- Script 05: Triggers and Auditing Implementation
-- System: Tourism Booking MIS
-- User: U_32481_2025_TOURISM_BOOKING_DB
-- ============================================================================

ALTER SESSION SET CONTAINER = PDB_32481_2025_TOURISM_BOOKING_DB;

-- 1. Day Restriction Trigger: Blocks DML on TOUR_PACKAGE on Weekdays or Public Holidays
CREATE OR REPLACE TRIGGER TRG_RESTRICT_DML_SCHEDULE
BEFORE INSERT OR UPDATE OR DELETE ON TOUR_PACKAGE
DECLARE
    V_DAY VARCHAR2(20);
    V_HOLIDAY_CNT NUMBER := 0;
BEGIN
    SELECT TRIM(TO_CHAR(SYSDATE, 'DAY')) INTO V_DAY FROM DUAL;
    
    SELECT COUNT(*) INTO V_HOLIDAY_CNT 
    FROM PUBLIC_HOLIDAYS 
    WHERE TRUNC(HOLIDAY_DATE) = TRUNC(SYSDATE);

    IF V_DAY IN ('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY') OR V_HOLIDAY_CNT > 0 THEN
        RAISE_APPLICATION_ERROR(-20099, 'Schema Restriction: Direct modifications to tour packages are blocked on weekdays and public holidays.');
    END IF;
END;
/

-- 2. Audit Trail Trigger: Tracks DML operations executed on BOOKING
CREATE OR REPLACE TRIGGER TRG_AUDIT_BOOKING_CHANGES
AFTER INSERT OR UPDATE OR DELETE ON BOOKING
FOR EACH ROW
DECLARE
    V_ACTION VARCHAR2(10);
    V_INFO   VARCHAR2(500);
BEGIN
    IF INSERTING THEN
        V_ACTION := 'INSERT';
        V_INFO   := 'Created booking ID: ' || :NEW.BOOKING_ID || ' for Tourist ID: ' || :NEW.TOURIST_ID;
    ELSIF UPDATING THEN
        V_ACTION := 'UPDATE';
        V_INFO   := 'Updated booking ID: ' || :NEW.BOOKING_ID || '. Status changed from ' || :OLD.BOOKING_STATUS || ' to ' || :NEW.BOOKING_STATUS;
    ELSIF DELETING THEN
        V_ACTION := 'DELETE';
        V_INFO   := 'Deleted booking ID: ' || :OLD.BOOKING_ID;
    END IF;

    INSERT INTO AUDIT_LOGS (
        TABLE_NAME, OPERATION_TYPE, PERFORMED_BY, PERFORMED_AT, DETAILS
    ) VALUES (
        'BOOKING', V_ACTION, USER, SYSTIMESTAMP, V_INFO
    );
END;
/