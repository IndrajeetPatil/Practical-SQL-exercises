/* ----------------------- begin --------------------------- */
-- create a database for a grocery delivery company 
CREATE DATABASE grocery;

-- create a table for drivers
-- choose the correct datatype for miles driven with required precision
/* 
 -- since mileage can't be more than 999 (3 digits on the left), and
 -- needed precision is one tenth of a mile (1 digit on the right)
 the correct datatype would be decimal(4, 1)
 */
-- why have separate columns for first and last names?
/* 
 - we can then sort either by first or last names
 - query them further (e.g. check if two drivers have same name)
 - etc.
 */
CREATE TABLE drivers(
    driver_id serial,
    first_name varchar(50),
    last_name varchar(50),
    workday date,
    clock_in time with time zone,
    clock_out time with time zone,
    miles_driven decimal(4, 1)
);

-- add entries to the table
INSERT INTO
    drivers (
        first_name,
        last_name,
        workday,
        clock_in,
        clock_out,
        miles_driven
    )
VALUES
    (
        'Adam',
        'Driver',
        '2021-04-05',
        '08:15 GMT+1',
        '13:00 GMT+1',
        123.4545
    ),
    (
        'Adam',
        'Driver',
        '2021-04-05',
        '11:30 CET',
        '18:00 CET',
        234
    ),
    (
        'Krystyna',
        'Pszczyna',
        '2021-04-06',
        '13:15 EST',
        '23:00 EST',
        678.4344
    );

-- Q3. what do you see when a malformed date entry is cast to timestamp?
CREATE TABLE drivers2(
    first_name varchar(50),
    workhours timestamp
);

INSERT INTO
    drivers2 (first_name, workhours)
VALUES
    ('X', '4//2017');

/* 
 ERROR:  invalid input syntax for type timestamp: "4//2017"
 LINE 9:     ('X', '4//2017');
 ^
 SQL state: 22007
 Character: 146
 */
-- delete this unnecessary table
DROP TABLE drivers2;

/* ----------------------- end --------------------------- */
--
-- Practising more with the drivers table