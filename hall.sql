-- DROP SCHEMA before creation, if it Exists
DROP SCHEMA IF EXISTS private CASCADE;

-- CREATE private schema
CREATE SCHEMA private;

-- DROP Tables before creation
DROP TABLE IF EXISTS seat_row CASCADE;
DROP TABLE IF EXISTS seat_num CASCADE;
DROP TABLE IF EXISTS seat CASCADE;
DROP TABLE IF EXISTS ticket CASCADE;
DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS private.customer CASCADE;


CREATE TABLE seat_row
(
    row CHAR(2) UNIQUE PRIMARY KEY
);

CREATE TABLE seat_num
(
    num INT UNIQUE PRIMARY KEY
);

CREATE TABLE seat
(
    SeatRow     CHAR(2) NOT NULL,
    SeatNumber  INT NOT NULL,
    Section     text,
    Side        text,
    PricingTier text,
    Wheelchair  BOOLEAN,

--  Composite PRIMARY KEY
    PRIMARY KEY (SeatRow, SeatNumber),

--  Foreign Keys
    FOREIGN KEY (SeatRow) REFERENCES seat_row (row),
    FOREIGN KEY (SeatNumber) REFERENCES seat_num (num)

);
CREATE TABLE customer
(
    CustomerID INT PRIMARY KEY,
    FirstName  text,
    LastName   text
);

CREATE TABLE private.customer
(
    CustomerID INT PRIMARY KEY,
    CreditCard BIGINT,

--  Foreign Keys
    FOREIGN KEY (CustomerID) REFERENCES customer (CustomerID)
);

CREATE TABLE ticket
(
    TicketNumber SERIAL PRIMARY KEY,
    CustomerID   INT,
    SeatRow      CHAR(2),
    SeatNumber   INT,
    ShowTime     TIMESTAMP,

--  Composite Seat
    CONSTRAINT SEAT_UT1 UNIQUE (SeatRow, SeatNumber, ShowTime),

--  Foreign Keys
    FOREIGN KEY (CustomerID) REFERENCES customer (CustomerID),
    FOREIGN KEY (SeatRow, SeatNumber) REFERENCES seat (SeatRow, SeatNumber)
);

-- Technique: Pipeline
--
-- Combination letters / numbers
-- A1-zz99
--
-- Certain combinations ahare characteristics
-- EE-HH 102-22 evens only (120 GG, 118 HH) <-- Filter Criteria & Output Data
-- PriceTier = 'upper balcony', Right , Balcony

INSERT INTO seat_row (row)
SELECT chr(generate_series(0, 17) + ascii('A'));
DELETE
from seat_row
where row = 'I';
INSERT INTO seat_row (row)
SELECT row || row
from seat_row
where ascii(row) <= ascii('H');

INSERT INTO seat_num (num)
SELECT generate_series(1, 15);
INSERT INTO seat_num (num)
SELECT generate_series(101, 126);

--Combine letter and numbers using join
-- SELECT * FROM seat_row, seat_num;

-- Filter and add constant value
INSERT INTO seat (seatrow, seatnumber, section, side, pricingtier, wheelchair)
SELECT seat_row.row, seat_num.num, 'Upper Balcony', 'Right', 'Balcony', false
FROM seat_row,
     seat_num
WHERE seat_row.row in ('EE', 'FF', 'GG', 'HH')
  AND seat_num.num >= 102
  AND seat_num.num <= 122
  AND seat_num.num % 2 = 0;

DELETE FROM seat WHERE SeatRow = 'GG' AND side = 'Right' AND SeatNumber > 120;
DELETE FROM seat WHERE SeatRow = 'HH' AND side = 'Right' AND  SeatNumber > 118;

-- Test Query: Upper Balcony, Right, Balcony --> 41 Seats
-- SELECT * FROM seat WHERE (section, side, pricingtier, wheelchair) = ('Upper Balcony', 'Right', 'Balcony', false);

INSERT INTO seat (seatrow, seatnumber, section, side, pricingtier, wheelchair)
SELECT seat_row.row, seat_num.num, 'Upper Balcony', 'Left', 'Balcony', false
FROM seat_row,
     seat_num
WHERE seat_row.row in ('EE', 'FF', 'GG', 'HH')
  AND seat_num.num >= 101
  AND seat_num.num <= 121
  AND seat_num.num % 2 = 1;

DELETE FROM seat WHERE SeatRow = 'GG' AND side = 'Left' AND  SeatNumber > 119;
DELETE FROM seat WHERE SeatRow = 'HH' AND side = 'Left' AND  SeatNumber > 117;

-- Test Query: Upper Balcony, Left, Balcony --> 41 Seats
-- SELECT * FROM seat WHERE (section, side, pricingtier, wheelchair) = ('Upper Balcony', 'Left', 'Balcony', false);

INSERT INTO seat (seatrow, seatnumber, section, side, pricingtier, wheelchair)
SELECT seat_row.row, seat_num.num, 'Upper Balcony', 'Middle', 'Balcony', false
FROM seat_row,
     seat_num
WHERE seat_row.row in ('EE', 'FF', 'GG', 'HH')
  AND seat_num.num >= 2
  AND seat_num.num <= 10
  AND seat_num.num % 2 = 0;

INSERT INTO seat (seatrow, seatnumber, section, side, pricingtier, wheelchair)
SELECT seat_row.row, seat_num.num, 'Upper Balcony', 'Middle', 'Balcony', false
FROM seat_row,
     seat_num
WHERE seat_row.row in ('EE', 'FF', 'GG', 'HH')
  AND seat_num.num >= 1
  AND seat_num.num <= 11
  AND seat_num.num % 2 = 1;

DELETE FROM seat WHERE SeatRow = 'GG' AND side = 'Middle' AND  SeatNumber > 10;
DELETE FROM seat WHERE SeatRow = 'HH' AND side = 'Middle' AND  SeatNumber > 10;

-- Test Query: Upper Balcony, Middle, Balcony --> 42 Seats
-- SELECT * FROM seat WHERE (section, side, pricingtier, wheelchair) = ('Upper Balcony', 'Middle', 'Balcony', false);

INSERT INTO seat (seatrow, seatnumber, section, side, pricingtier, wheelchair)
SELECT seat_row.row, seat_num.num, 'Side', 'Right', 'Balcony', false
FROM seat_row,
     seat_num
WHERE seat_row.row in ('AA', 'BB', 'CC', 'DD')
  AND seat_num.num >= 102
  AND seat_num.num <= 126
  AND seat_num.num % 2 = 0;

DELETE FROM seat WHERE SeatRow = 'AA' AND side = 'Right' AND SeatNumber > 124;
DELETE FROM seat WHERE SeatRow = 'BB' AND side = 'Right' AND SeatNumber > 124;
DELETE FROM seat WHERE SeatRow = 'CC' AND side = 'Right' AND SeatNumber > 124;

-- Test Query: Side, Right, Balcony --> 49 Seats
-- SELECT * FROM seat WHERE (section, side, pricingtier, wheelchair) = ('Side', 'Right', 'Balcony', false);

INSERT INTO seat (seatrow, seatnumber, section, side, pricingtier, wheelchair)
SELECT seat_row.row, seat_num.num, 'Side', 'Left', 'Balcony', false
FROM seat_row,
     seat_num
WHERE seat_row.row in ('AA', 'BB', 'CC', 'DD')
  AND seat_num.num >= 101
  AND seat_num.num <= 125
  AND seat_num.num % 2 = 1;

DELETE FROM seat WHERE SeatRow = 'AA' AND side = 'Left' AND SeatNumber > 123;
DELETE FROM seat WHERE SeatRow = 'BB' AND side = 'Left' AND SeatNumber > 123;
DELETE FROM seat WHERE SeatRow = 'CC' AND side = 'Left' AND SeatNumber > 123;

-- Test Query: Side, Left, Balcony --> 49 Seats
-- SELECT * FROM seat WHERE (section, side, pricingtier, wheelchair) = ('Side', 'Left', 'Balcony', false);

INSERT INTO seat (seatrow, seatnumber, section, side, pricingtier, wheelchair)
SELECT seat_row.row, seat_num.num, 'Orchestra', 'Middle', 'Balcony', false
FROM seat_row,
     seat_num
WHERE seat_row.row in ('AA', 'BB', 'CC', 'DD')
  AND seat_num.num >= 2
  AND seat_num.num <= 14
  AND seat_num.num % 2 = 0;

INSERT INTO seat (seatrow, seatnumber, section, side, pricingtier, wheelchair)
SELECT seat_row.row, seat_num.num, 'Orchestra', 'Middle', 'Balcony', false
FROM seat_row,
     seat_num
WHERE seat_row.row in ('AA', 'BB', 'CC', 'DD')
  AND seat_num.num >= 1
  AND seat_num.num <= 13
  AND seat_num.num % 2 = 1;

DELETE FROM seat WHERE SeatRow = 'AA' AND side = 'Middle' AND SeatNumber > 13;

-- Test Query: Upper Balcony, Middle, Balcony --> 55 Seats
-- SELECT * FROM seat WHERE (section, side, pricingtier, wheelchair) = ('Orchestra', 'Middle', 'Balcony', false);

INSERT INTO seat (seatrow, seatnumber, section, side, pricingtier, wheelchair)
SELECT seat_row.row, seat_num.num, 'Orchestra', 'Right', 'Main Floor', false
FROM seat_row,
     seat_num
WHERE seat_row.row in ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R')
  AND seat_num.num >= 102
  AND seat_num.num <= 106
  AND seat_num.num % 2 = 0;

-- Test Query: Orchestra, Right, Main Floor --> 51 Seats
-- SELECT * FROM seat WHERE (section, side, pricingtier, wheelchair) = ('Orchestra', 'Right', 'Main Floor', false);

INSERT INTO seat (seatrow, seatnumber, section, side, pricingtier, wheelchair)
SELECT seat_row.row, seat_num.num, 'Orchestra', 'Left', 'Main Floor', false
FROM seat_row,
     seat_num
WHERE seat_row.row in ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R')
  AND seat_num.num >= 101
  AND seat_num.num <= 105
  AND seat_num.num % 2 = 1;

-- Test Query: Orchestra, Left, Main Floor --> 51 Seats
-- SELECT * FROM seat WHERE (section, side, pricingtier, wheelchair) = ('Orchestra', 'Left', 'Main Floor', false);

INSERT INTO seat (seatrow, seatnumber, section, side, pricingtier, wheelchair)
SELECT seat_row.row, seat_num.num, 'Side', 'Right', 'Main Floor', false
FROM seat_row,
     seat_num
WHERE seat_row.row in ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R')
  AND seat_num.num >= 108
  AND seat_num.num <= 122
  AND seat_num.num % 2 = 0;

DELETE FROM seat WHERE SeatRow = 'A' AND side = 'Right' AND SeatNumber > 114;
DELETE FROM seat WHERE SeatRow = 'B' AND side = 'Right' AND SeatNumber > 116;
DELETE FROM seat WHERE SeatRow = 'C' AND side = 'Right' AND SeatNumber > 116;
DELETE FROM seat WHERE SeatRow = 'D' AND side = 'Right' AND SeatNumber > 116;
DELETE FROM seat WHERE SeatRow = 'E' AND side = 'Right' AND SeatNumber > 116;
DELETE FROM seat WHERE SeatRow = 'F' AND side = 'Right' AND SeatNumber > 118;
DELETE FROM seat WHERE SeatRow = 'G' AND side = 'Right' AND SeatNumber > 118;
DELETE FROM seat WHERE SeatRow = 'H' AND side = 'Right' AND SeatNumber > 118;
DELETE FROM seat WHERE SeatRow = 'J' AND side = 'Right' AND SeatNumber > 118;
DELETE FROM seat WHERE SeatRow = 'K' AND side = 'Right' AND SeatNumber > 120;
DELETE FROM seat WHERE SeatRow = 'L' AND side = 'Right' AND SeatNumber > 120;
DELETE FROM seat WHERE SeatRow = 'M' AND side = 'Right' AND SeatNumber > 120;
DELETE FROM seat WHERE SeatRow = 'N' AND side = 'Right' AND SeatNumber > 120;

UPDATE seat SET wheelchair = true WHERE SeatRow = 'P' AND SeatNumber > 108;
UPDATE seat SET wheelchair = true WHERE SeatRow = 'Q' AND SeatNumber > 108;
UPDATE seat SET wheelchair = true WHERE SeatRow = 'R' AND SeatNumber > 108;

-- Test Query: Orchestra, Right, Main Floor --> 108 Seats
-- SELECT * FROM seat WHERE (section, side, pricingtier) = ('Side', 'Right', 'Main Floor');

INSERT INTO seat (seatrow, seatnumber, section, side, pricingtier, wheelchair)
SELECT seat_row.row, seat_num.num, 'Side', 'Left', 'Main Floor', false
FROM seat_row,
     seat_num
WHERE seat_row.row in ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R')
  AND seat_num.num >= 107
  AND seat_num.num <= 121
  AND seat_num.num % 2 = 1;

DELETE FROM seat WHERE SeatRow = 'A' AND side = 'Left' AND SeatNumber > 113;
DELETE FROM seat WHERE SeatRow = 'B' AND side = 'Left' AND SeatNumber > 115;
DELETE FROM seat WHERE SeatRow = 'C' AND side = 'Left' AND SeatNumber > 115;
DELETE FROM seat WHERE SeatRow = 'D' AND side = 'Left' AND SeatNumber > 115;
DELETE FROM seat WHERE SeatRow = 'E' AND side = 'Left' AND SeatNumber > 115;
DELETE FROM seat WHERE SeatRow = 'F' AND side = 'Left' AND SeatNumber > 117;
DELETE FROM seat WHERE SeatRow = 'G' AND side = 'Left' AND SeatNumber > 117;
DELETE FROM seat WHERE SeatRow = 'H' AND side = 'Left' AND SeatNumber > 117;
DELETE FROM seat WHERE SeatRow = 'J' AND side = 'Left' AND SeatNumber > 117;
DELETE FROM seat WHERE SeatRow = 'K' AND side = 'Left' AND SeatNumber > 119;
DELETE FROM seat WHERE SeatRow = 'L' AND side = 'Left' AND SeatNumber > 119;
DELETE FROM seat WHERE SeatRow = 'M' AND side = 'Left' AND SeatNumber > 119;
DELETE FROM seat WHERE SeatRow = 'N' AND side = 'Left' AND SeatNumber > 119;

UPDATE seat SET wheelchair = true WHERE SeatRow = 'P' AND SeatNumber > 107;
UPDATE seat SET wheelchair = true WHERE SeatRow = 'Q' AND SeatNumber > 107;
UPDATE seat SET wheelchair = true WHERE SeatRow = 'R' AND SeatNumber > 107;

-- Test Query: Orchestra, Right, Main Floor --> 108 Seats
-- SELECT * FROM seat WHERE (section, side, pricingtier) = ('Side', 'Left', 'Main Floor');


INSERT INTO seat (seatrow, seatnumber, section, side, pricingtier, wheelchair)
SELECT seat_row.row, seat_num.num, 'Orchestra', 'Middle', 'Main Floor', false
FROM seat_row,
     seat_num
WHERE seat_row.row in ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R')
  AND seat_num.num >= 2
  AND seat_num.num <= 14
  AND seat_num.num % 2 = 0;

INSERT INTO seat (seatrow, seatnumber, section, side, pricingtier, wheelchair)
SELECT seat_row.row, seat_num.num, 'Orchestra', 'Middle', 'Main Floor', false
FROM seat_row,
     seat_num
WHERE seat_row.row in ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R')
  AND seat_num.num >= 1
  AND seat_num.num <= 15
  AND seat_num.num % 2 = 1;

DELETE FROM seat WHERE SeatRow = 'A' AND side = 'Middle' AND SeatNumber > 10;
DELETE FROM seat WHERE SeatRow = 'B' AND side = 'Middle' AND SeatNumber > 10;
DELETE FROM seat WHERE SeatRow = 'C' AND side = 'Middle' AND SeatNumber > 10;
DELETE FROM seat WHERE SeatRow = 'D' AND side = 'Middle' AND SeatNumber > 11;
DELETE FROM seat WHERE SeatRow = 'E' AND side = 'Middle' AND SeatNumber > 11;
DELETE FROM seat WHERE SeatRow = 'F' AND side = 'Middle' AND SeatNumber > 11;
DELETE FROM seat WHERE SeatRow = 'G' AND side = 'Middle' AND SeatNumber > 12;
DELETE FROM seat WHERE SeatRow = 'H' AND side = 'Middle' AND SeatNumber > 12;
DELETE FROM seat WHERE SeatRow = 'J' AND side = 'Middle' AND SeatNumber > 12;
DELETE FROM seat WHERE SeatRow = 'K' AND side = 'Middle' AND SeatNumber > 13;
DELETE FROM seat WHERE SeatRow = 'L' AND side = 'Middle' AND SeatNumber > 13;
DELETE FROM seat WHERE SeatRow = 'M' AND side = 'Middle' AND SeatNumber > 13;
DELETE FROM seat WHERE SeatRow = 'N' AND side = 'Middle' AND SeatNumber > 14;
DELETE FROM seat WHERE SeatRow = 'O' AND side = 'Middle' AND SeatNumber > 14;
DELETE FROM seat WHERE SeatRow = 'P' AND side = 'Middle' AND SeatNumber > 14;

-- Test Query: Orchestra, Middle, Main Floor --> 210 Seats
-- SELECT * FROM seat WHERE (section, side, pricingtier, wheelchair) = ('Orchestra', 'Middle', 'Main Floor', false);

-- Test Query: All of the Seats --> 805 Seats
-- SELECT COUNT(*) FROM seat;

-- Create Customer Mike Johnson, ID: 1234, CC# 1234567887654321
INSERT INTO public.customer(customerid, firstname, lastname)
VALUES (1234, 'Mike', 'Johnson');
INSERT INTO private.customer(customerid, creditcard)
VALUES (1234, 1234567887654321);

-- Create Tickets under Mike Johnson
INSERT INTO ticket(CustomerID, SeatRow, SeatNumber, ShowTime) VALUES
(1234, 'A', 6, '2017-12-15 14:00:00'),
(1234, 'A', 8, '2017-12-15 14:00:00'),
(1234, 'A', 10, '2017-12-15 14:00:00'),
(1234, 'A', 9, '2017-12-15 14:00:00');

-- Test Queries
-- SELECT * FROM customer;
-- SELECT * FROM private.customer;
-- SELECT * FROM ticket;



