/* ----------------------- begin --------------------------- */
-- Q1. Importing specified text file
COPY movies
FROM
    '..\assets\ch4q1.txt' WITH (FORMAT txt, HEADER, DELIMITER ':');

-- Q2. 
-- Q3. Fixed-point numbers
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