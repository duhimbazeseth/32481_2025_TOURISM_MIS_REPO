-- ============================================================================
-- Script 03: Comprehensive Sample Data Insertion
-- System: Tourism Booking MIS
-- PDB: PDB_32481_2025_TOURISM_BOOKING_DB
-- User: U_32481_2025_TOURISM_BOOKING_DB
-- ============================================================================

ALTER SESSION SET CONTAINER = PDB_32481_2025_TOURISM_BOOKING_DB;

-- 1. Populate Public Holidays Reference Table
INSERT INTO PUBLIC_HOLIDAYS VALUES (TO_DATE('2026-01-01', 'YYYY-MM-DD'), 'New Year Day');
INSERT INTO PUBLIC_HOLIDAYS VALUES (TO_DATE('2026-02-01', 'YYYY-MM-DD'), 'Heroes Day');
INSERT INTO PUBLIC_HOLIDAYS VALUES (TO_DATE('2026-04-07', 'YYYY-MM-DD'), 'Genocide Memorial Day');
INSERT INTO PUBLIC_HOLIDAYS VALUES (TO_DATE('2026-07-01', 'YYYY-MM-DD'), 'Independence Day');
INSERT INTO PUBLIC_HOLIDAYS VALUES (TO_DATE('2026-07-04', 'YYYY-MM-DD'), 'Liberation Day');
INSERT INTO PUBLIC_HOLIDAYS VALUES (TO_DATE('2026-12-25', 'YYYY-MM-DD'), 'Christmas Day');

-- 2. Populate Tour Packages
INSERT INTO TOUR_PACKAGE VALUES (SEQ_PACKAGE_ID.NEXTVAL, 'Gorilla Trekking Safari', 'Volcanoes National Park', 3, 1500.00, 20);
INSERT INTO TOUR_PACKAGE VALUES (SEQ_PACKAGE_ID.NEXTVAL, 'Akagera Big Five Wildlife', 'Akagera National Park', 2, 500.00, 35);
INSERT INTO TOUR_PACKAGE VALUES (SEQ_PACKAGE_ID.NEXTVAL, 'Nyungwe Canopy & Chimp Trek', 'Nyungwe Forest', 4, 850.00, 15);
INSERT INTO TOUR_PACKAGE VALUES (SEQ_PACKAGE_ID.NEXTVAL, 'Lake Kivu Relaxation Retreat', 'Rubavu', 3, 400.00, 50);

-- 3. Populate Tourists
INSERT INTO TOURIST VALUES (SEQ_TOURIST_ID.NEXTVAL, 'Seth', 'Mugisha', 'seth.m@gmail.com', '+250788111222', 'Rwanda', SYSDATE - 60);
INSERT INTO TOURIST VALUES (SEQ_TOURIST_ID.NEXTVAL, 'Sarah', 'Smith', 'sarah.smith@yahoo.com', '+14155552671', 'USA', SYSDATE - 45);
INSERT INTO TOURIST VALUES (SEQ_TOURIST_ID.NEXTVAL, 'David', 'Kramer', 'dkramer@de-tours.de', '+4930123456', 'Germany', SYSDATE - 30);
INSERT INTO TOURIST VALUES (SEQ_TOURIST_ID.NEXTVAL, 'Amina', 'Uwase', 'uwase.a@outlook.com', '+250789000111', 'Rwanda', SYSDATE - 10);
INSERT INTO TOURIST VALUES (SEQ_TOURIST_ID.NEXTVAL, 'Claire', 'Dubois', 'claire.d@france-travel.fr', '+33142685500', 'France', SYSDATE - 5);

-- 4. Populate Bookings
-- Booking 8001: Seth -> Gorilla Trekking (2 guests @ $1500 = $3000)
INSERT INTO BOOKING VALUES (SEQ_BOOKING_ID.NEXTVAL, 1001, 5001, SYSDATE - 20, SYSDATE + 15, 2, 3000.00, 'CONFIRMED');

-- Booking 8002: Sarah -> Akagera Wildlife (4 guests @ $500 = $2000)
INSERT INTO BOOKING VALUES (SEQ_BOOKING_ID.NEXTVAL, 1002, 5002, SYSDATE - 15, SYSDATE + 10, 4, 2000.00, 'CONFIRMED');

-- Booking 8003: David -> Nyungwe Canopy (1 guest @ $850 = $850)
INSERT INTO BOOKING VALUES (SEQ_BOOKING_ID.NEXTVAL, 1003, 5003, SYSDATE - 10, SYSDATE + 25, 1, 850.00, 'PENDING');

-- Booking 8004: Amina -> Lake Kivu Retreat (3 guests @ $400 = $1200)
INSERT INTO BOOKING VALUES (SEQ_BOOKING_ID.NEXTVAL, 1004, 5004, SYSDATE - 5, SYSDATE + 5, 3, 1200.00, 'CONFIRMED');

-- Booking 8005: Claire -> Gorilla Trekking (1 guest @ $1500 = $1500)
INSERT INTO BOOKING VALUES (SEQ_BOOKING_ID.NEXTVAL, 1005, 5001, SYSDATE - 2, SYSDATE + 40, 1, 1500.00, 'CANCELLED');

-- 5. Populate Payments for Confirmed Bookings
INSERT INTO PAYMENT VALUES (SEQ_PAYMENT_ID.NEXTVAL, 8001, SYSDATE - 19, 3000.00, 'CREDIT_CARD', 'COMPLETED');
INSERT INTO PAYMENT VALUES (SEQ_PAYMENT_ID.NEXTVAL, 8002, SYSDATE - 14, 2000.00, 'BANK_TRANSFER', 'COMPLETED');
INSERT INTO PAYMENT VALUES (SEQ_PAYMENT_ID.NEXTVAL, 8004, SYSDATE - 4, 1200.00, 'MOBILE_MONEY', 'COMPLETED');

-- Commit Transaction
COMMIT;

PROMPT Sample data population completed successfully!