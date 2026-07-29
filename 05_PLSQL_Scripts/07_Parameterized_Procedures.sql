-- ============================================================================
-- Script 07: Parameterized Stored Procedures
-- System: Tourism Booking MIS
-- PDB: PDB_32481_2025_TOURISM_BOOKING_DB
-- User: U_32481_2025_TOURISM_BOOKING_DB
-- ============================================================================

ALTER SESSION SET CONTAINER = PDB_32481_2025_TOURISM_BOOKING_DB;
ALTER SESSION SET CURRENT_SCHEMA = U_32481_2025_TOURISM_BOOKING_DB;

-- ============================================================================
-- PROCEDURE 1: Create New Booking with Automated Validation & Cost Calculation
-- Handles: Capacity check, total cost calculation, and transaction commit/rollback
-- ============================================================================
CREATE OR REPLACE PROCEDURE PR_CREATE_BOOKING (
    p_tourist_id    IN  BOOKING.TOURIST_ID%TYPE,
    p_package_id    IN  BOOKING.PACKAGE_ID%TYPE,
    p_travel_date   IN  BOOKING.TRAVEL_DATE%TYPE,
    p_num_guests    IN  BOOKING.NUMBER_OF_GUESTS%TYPE,
    p_booking_id    OUT BOOKING.BOOKING_ID%TYPE,
    p_status_msg    OUT VARCHAR2
) IS
    v_unit_price     TOUR_PACKAGE.PRICE_PER_PERSON%TYPE;
    v_max_cap        TOUR_PACKAGE.MAX_CAPACITY%TYPE;
    v_current_guests NUMBER := 0;
    v_total_amount   NUMBER(10,2);
    
    EX_OVERBOOKING   EXCEPTION;
    EX_INVALID_DATA  EXCEPTION;
BEGIN
    -- Input validation
    IF p_num_guests <= 0 OR p_travel_date < TRUNC(SYSDATE) THEN
        RAISE EX_INVALID_DATA;
    END IF;

    -- 1. Fetch package details
    SELECT price_per_person, max_capacity
    INTO v_unit_price, v_max_cap
    FROM TOUR_PACKAGE
    WHERE package_id = p_package_id;

    -- 2. Check remaining capacity for the package
    SELECT NVL(SUM(number_of_guests), 0)
    INTO v_current_guests
    FROM BOOKING
    WHERE package_id = p_package_id
      AND booking_status IN ('CONFIRMED', 'PENDING');

    IF (v_current_guests + p_num_guests) > v_max_cap THEN
        RAISE EX_OVERBOOKING;
    END IF;

    -- 3. Calculate total cost using package price
    v_total_amount := v_unit_price * p_num_guests;

    -- 4. Generate new Booking ID and insert record
    p_booking_id := SEQ_BOOKING_ID.NEXTVAL;

    INSERT INTO BOOKING (
        booking_id, tourist_id, package_id, booking_date, travel_date, 
        number_of_guests, total_amount, booking_status
    ) VALUES (
        p_booking_id, p_tourist_id, p_package_id, SYSDATE, p_travel_date, 
        p_num_guests, v_total_amount, 'PENDING'
    );

    COMMIT;
    p_status_msg := 'SUCCESS: Booking #' || p_booking_id || ' created (Total: $' || v_total_amount || ').';

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_status_msg := 'ERROR: Invalid Tourist ID (' || p_tourist_id || ') or Package ID (' || p_package_id || ').';
        ROLLBACK;
    WHEN EX_INVALID_DATA THEN
        p_status_msg := 'ERROR: Invalid number of guests or past travel date.';
        ROLLBACK;
    WHEN EX_OVERBOOKING THEN
        p_status_msg := 'ERROR: Capacity exceeded! Only ' || (v_max_cap - v_current_guests) || ' spots available.';
        ROLLBACK;
    WHEN OTHERS THEN
        p_status_msg := 'ERROR: Transaction failed due to ' || SQLERRM;
        ROLLBACK;
END PR_CREATE_BOOKING;
/


-- ============================================================================
-- PROCEDURE 2: Process Booking Payment & Auto-Confirm Reservation
-- Handles: Payment insertion and automatic status update of the associated booking
-- ============================================================================
CREATE OR REPLACE PROCEDURE PR_PROCESS_PAYMENT (
    p_booking_id      IN  PAYMENT.BOOKING_ID%TYPE,
    p_amount_paid     IN  PAYMENT.AMOUNT_PAID%TYPE,
    p_payment_method  IN  PAYMENT.PAYMENT_METHOD%TYPE,
    p_payment_id      OUT PAYMENT.PAYMENT_ID%TYPE,
    p_status_msg      OUT VARCHAR2
) IS
    v_due_amount     BOOKING.TOTAL_AMOUNT%TYPE;
    v_current_status BOOKING.BOOKING_STATUS%TYPE;
    
    EX_ALREADY_PAID  EXCEPTION;
    EX_WRONG_AMOUNT  EXCEPTION;
BEGIN
    -- 1. Fetch booking status and required total
    SELECT total_amount, booking_status
    INTO v_due_amount, v_current_status
    FROM BOOKING
    WHERE booking_id = p_booking_id;

    IF v_current_status = 'CONFIRMED' THEN
        RAISE EX_ALREADY_PAID;
    ELSIF p_amount_paid < v_due_amount THEN
        RAISE EX_WRONG_AMOUNT;
    END IF;

    -- 2. Insert Payment Record
    p_payment_id := SEQ_PAYMENT_ID.NEXTVAL;

    INSERT INTO PAYMENT (
        payment_id, booking_id, payment_date, amount_paid, payment_method, payment_status
    ) VALUES (
        p_payment_id, p_booking_id, SYSDATE, p_amount_paid, p_payment_method, 'COMPLETED'
    );

    -- 3. Update Booking Status to CONFIRMED
    UPDATE BOOKING
    SET booking_status = 'CONFIRMED'
    WHERE booking_id = p_booking_id;

    COMMIT;
    p_status_msg := 'SUCCESS: Payment #' || p_payment_id || ' recorded. Booking #' || p_booking_id || ' is now CONFIRMED.';

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_status_msg := 'ERROR: Booking ID #' || p_booking_id || ' does not exist.';
        ROLLBACK;
    WHEN EX_ALREADY_PAID THEN
        p_status_msg := 'ERROR: Booking #' || p_booking_id || ' is already confirmed/paid.';
        ROLLBACK;
    WHEN EX_WRONG_AMOUNT THEN
        p_status_msg := 'ERROR: Insufficient payment amount. Required: $' || v_due_amount || ', Received: $' || p_amount_paid;
        ROLLBACK;
    WHEN OTHERS THEN
        p_status_msg := 'ERROR: Payment processing failed: ' || SQLERRM;
        ROLLBACK;
END PR_PROCESS_PAYMENT;
/


-- ============================================================================
-- PROCEDURE 3: Batch Update Tour Package Prices by Percentage
-- Handles: Trigger safety toggle during batch maintenance operations
-- ============================================================================
CREATE OR REPLACE PROCEDURE PR_APPLY_PACKAGE_DISCOUNT (
    p_destination_keyword IN  VARCHAR2,
    p_discount_percentage IN  NUMBER,
    p_rows_updated        OUT NUMBER,
    p_status_msg          OUT VARCHAR2
) IS
BEGIN
    IF p_discount_percentage <= 0 OR p_discount_percentage > 50 THEN
        p_status_msg := 'ERROR: Discount percentage must be between 1 and 50.';
        RETURN;
    END IF;

    -- Temporarily disable schedule trigger for administrative price updates
    EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_RESTRICT_DML_SCHEDULE DISABLE';

    UPDATE TOUR_PACKAGE
    SET price_per_person = ROUND(price_per_person * (1 - (p_discount_percentage / 100)), 2)
    WHERE UPPER(destination) LIKE '%' || UPPER(p_destination_keyword) || '%';

    p_rows_updated := SQL%ROWCOUNT;

    -- Re-enable the schedule trigger
    EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_RESTRICT_DML_SCHEDULE ENABLE';

    COMMIT;
    p_status_msg := 'SUCCESS: Discount of ' || p_discount_percentage || '% applied to ' || p_rows_updated || ' package(s).';

EXCEPTION
    WHEN OTHERS THEN
        -- Ensure trigger gets re-enabled if an error occurs
        EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_RESTRICT_DML_SCHEDULE ENABLE';
        p_status_msg := 'ERROR: Batch discount failed: ' || SQLERRM;
        ROLLBACK;
END PR_APPLY_PACKAGE_DISCOUNT;
/


-- ============================================================================
-- TEST EXECUTION BLOCK (Demonstrating Procedure Calls)
-- ============================================================================

SET SERVEROUTPUT ON;

DECLARE
    v_new_booking_id NUMBER;
    v_new_payment_id NUMBER;
    v_rows_affected  NUMBER;
    v_message        VARCHAR2(250);
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- TEST 1: Creating a Valid Booking ---');
    -- Tourist 1001 books Package 5002 for 3 guests
    PR_CREATE_BOOKING(
        p_tourist_id  => 1001,
        p_package_id  => 5002,
        p_travel_date => SYSDATE + 12,
        p_num_guests  => 3,
        p_booking_id  => v_new_booking_id,
        p_status_msg  => v_message
    );
    DBMS_OUTPUT.PUT_LINE(v_message);

    DBMS_OUTPUT.PUT_LINE('--- TEST 2: Processing Payment for New Booking ---');
    IF v_new_booking_id IS NOT NULL THEN
        -- Pay $1500 for the newly created booking
        PR_PROCESS_PAYMENT(
            p_booking_id     => v_new_booking_id,
            p_amount_paid    => 1500.00,
            p_payment_method => 'CREDIT_CARD',
            p_payment_id     => v_new_payment_id,
            p_status_msg     => v_message
        );
        DBMS_OUTPUT.PUT_LINE(v_message);
    END IF;

    DBMS_OUTPUT.PUT_LINE('--- TEST 3: Applying 15% Seasonal Discount ---');
    PR_APPLY_PACKAGE_DISCOUNT(
        p_destination_keyword => 'Akagera',
        p_discount_percentage => 15,
        p_rows_updated        => v_rows_affected,
        p_status_msg          => v_message
    );
    DBMS_OUTPUT.PUT_LINE(v_message);
END;
/