--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- 1st Edition
-- Chapter 2 "Try It Yourself" Exercises
--------------------------------------------------------------


---------
-- Q1 --
---------

-- list in the format specified by the superintendant

SELECT
    school,
    last_name
FROM
    teachers
ORDER BY
    school,
    last_name DESC;


---------
-- Q2 --
---------

-- find teachers with specified conditions

SELECT
    *
FROM
    teachers
WHERE
    (first_name LIKE 'S%')
    AND (salary > 40000);


---------
-- Q3 --
---------

-- find and order teachers by hiring date and salary

SELECT
    *
FROM
    teachers
WHERE
    hire_date > '2010-1-1'
ORDER BY
    salary DESC;
