--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- 1st Edition
-- Chapter 2 "Try It Yourself" Exercises
--------------------------------------------------------------
--
-- first you need to create the database and the table used in the book
-- create database
CREATE DATABASE analysis;

-- creating a table named teachers with six columns
CREATE TABLE teachers (
    id serial,
    first_name varchar(25),
    last_name varchar(50),
    school varchar(50),
    hire_date date,
    salary numeric
);

--inserting data into the teachers table
INSERT INTO
    teachers (first_name, last_name, school, hire_date, salary)
VALUES
    (
        'Janet',
        'Smith',
        'F.D. Roosevelt HS',
        '2011-10-30',
        36200
    ),
    (
        'Lee',
        'Reynolds',
        'F.D. Roosevelt HS',
        '1993-05-22',
        65000
    ),
    (
        'Samuel',
        'Cole',
        'Myers Middle School',
        '2005-08-01',
        43500
    ),
    (
        'Samantha',
        'Bush',
        'Myers Middle School',
        '2011-10-30',
        36200
    ),
    (
        'Betty',
        'Diaz',
        'Myers Middle School',
        '2005-08-30',
        43500
    ),
    (
        'Kathleen',
        'Roush',
        'F.D. Roosevelt HS',
        '2010-10-22',
        38500
    );

/* ----------------------- begin --------------------------- */
-- Q1. list for the superintendant
SELECT
    school,
    last_name
FROM
    teachers
ORDER BY
    school,
    last_name DESC;

-- Q2. find teacher
SELECT
    *
FROM
    teachers
WHERE
    (first_name LIKE 'S%')
    AND (salary > 40000);

-- Q3. rank teachers
SELECT
    *
FROM
    teachers
WHERE
    hire_date > '2010-1-1'
ORDER BY
    salary DESC;

/* ----------------------- end --------------------------- */
--
--
--
/* more practice with string matching */
-- find first_name with at least one 'e' *and* 'a' at second position
SELECT
    first_name
FROM
    teachers
WHERE
    (first_name LIKE '%e%')
    AND (first_name LIKE '_a%');

-- find teachers whose last name is not 'Bush' and someone who
-- was hired after 2005 and then sort by their school name (ascending) and 
-- salary (descending)
SELECT
    *
FROM
    teachers
WHERE
    (first_name <> 'Bush')
    AND (hire_date > '1-1-2005')
ORDER BY
    school ASC,
    salary DESC;