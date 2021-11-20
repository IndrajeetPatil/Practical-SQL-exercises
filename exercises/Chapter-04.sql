--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- 1st Edition
-- Chapter 4 "Try It Yourself" Exercises
--------------------------------------------------------------


---------
-- Q1 --
---------


-- importing specified text file
-- Ref. <https://dba.stackexchange.com/questions/76812/escaping-delimiter-in-postgresql>

COPY movies
FROM -- your file path will be different
    'C:\Users\IndrajeetPatil\Documents\GitHub\Practical-SQL-exercises\assets\ch4q1.txt'
WITH (FORMAT CSV, HEADER, DELIMITER ':', quote '#');


---------
-- Q2 --
---------


-- counties with most housing units

COPY (
    SELECT
        geo_name,
        state_us_abbreviation,
        housing_unit_count_100_percent
    FROM
        us_counties_2010
    ORDER BY
        housing_unit_count_100_percent DESC
    LIMIT
        20
)
TO -- your file path will be different
    'C:\Users\IndrajeetPatil\Documents\GitHub\Practical-SQL-exercises\assets\ch4q2.txt'
WITH (FORMAT csv, HEADER);


---------
-- Q3 --
---------


-- fixed-point numbers
/*
 numeric(3,8) will not work for the provided values and you will get the error
 'NUMERIC scale 8 must be between 0 and precision 3
 This is because with this scale all values will be to the right of the decimal
 point and so the value needs to be between 0 and 1
 */

SELECT
    CAST(17519.668 AS numeric(3, 8));

-- it instead needs to be the following
-- scale of 3 means 3 digits to the right of the decimal point

SELECT
    CAST(17519.668 AS numeric(8, 3));

-- if the value were to be between 0 and 1, the following will work

SELECT
    CAST(0.17519668 AS numeric(8, 8));
