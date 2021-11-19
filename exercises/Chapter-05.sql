--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- 1st Edition
-- Chapter 5 "Try It Yourself" Exercises
--------------------------------------------------------------


---------
-- Q1 --
---------


-- calculating the area of a circle whose radius is 5 inches
/* no paranthese needed because exponent/square function has
 a higher precedence than multiplication
 */

SELECT
    3.14 * SQUARE(5);


---------
-- Q2 --
---------


/*
 You first need to have created a database and then also a table
 code here: https://github.com/anthonydb/practical-sql/blob/ebc2233c41f2ba18512daf7c4a1a2f4c7f72a520/Chapter_04/Chapter_04.sql#L20-L123

 -- Importing data from csv (path to file will be different for everyone)
 -- If you get 'Permission denied' error, see: https://stackoverflow.com/a/65459173/7973626
 -- If that still doesn't work, use the pgAdmin GUI to import data
 -- configure binary path, see: https://dba.stackexchange.com/questions/149169/binary-path-in-the-pgadmin-preferences
 */
-- Q2. NY county with the highest percentage of
-- CREATE DATABASE us_census;


COPY us_counties_2010
FROM -- your file path will be different
    'C:\Users\IndrajeetPatil\Documents\GitHub\Practical-SQL-exercises\assets'
WITH (FORMAT csv, HEADER);

-- Frankin County with just about 7% people identifying as American Indian and Alaska Native alone
-- You can see map here: https://www.census.gov/quickfacts/fact/map/franklincountynewyork/RHI325219
-- As to why? I have no clue. Google search wasn't that helpful.

SELECT
    geo_name,
    (
        CAST(p0010005 AS numeric(8, 1)) / population_count_100_percent
    ) * 100 AS "prop"
FROM
    us_counties_2010
WHERE
    state_us_abbreviation = 'NY'
ORDER BY
    prop DESC;


---------
-- Q3 --
---------


-- median county population in CA (179140.5) was higher than NY (91301)

SELECT
    state_us_abbreviation,
    percentile_cont(0.5) WITHIN GROUP (
        ORDER BY
            population_count_100_percent
    )
FROM
    us_counties_2010
WHERE
    state_us_abbreviation IN ('NY', 'CA')
GROUP BY
    state_us_abbreviation;
