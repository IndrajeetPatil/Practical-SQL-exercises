--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- 1st Edition
-- Chapter 12 "Try It Yourself" Exercises
--------------------------------------------------------------


---------
-- Q1 --
---------


-- Groupings of Waikiki's daily maximum temperatures
/*
 In this news schema, Waikiki’s daily maximum temperature fall most often in the
 '86-87' group (118 observations), while the least observed bins are
 '90 or more' (5 observations) and '79 or less' (8 observations).
 */

WITH temps_collapsed (max_temperature_group) AS (
    SELECT
        CASE
            WHEN max_temp >= 90 THEN '90 or more'
            WHEN max_temp BETWEEN 88
            AND 89 THEN '88-89'
            WHEN max_temp BETWEEN 86
            AND 87 THEN '86-87'
            WHEN max_temp BETWEEN 84
            AND 85 THEN '84-85'
            WHEN max_temp BETWEEN 82
            AND 83 THEN '82-83'
            WHEN max_temp BETWEEN 80
            AND 81 THEN '80-81'
            WHEN max_temp <= 79 THEN '79 or less'
        END
    FROM
        temperature_readings
    WHERE
        station_name = 'WAIKIKI 717.2 HI US'
)
SELECT
    max_temperature_group,
    count(max_temperature_group) AS n_obs
FROM
    temps_collapsed
GROUP BY
    max_temperature_group
ORDER BY
    n_obs DESC;


---------
-- Q2 --
---------


-- instead of office-by-flavor, make flavor-by-office crosstabs table
-- the counts remain the same

SELECT *
FROM crosstab('SELECT
               flavor,
               office,
               count(*)
               FROM ice_cream_survey
               GROUP BY flavor, office
               ORDER BY flavor',

              'SELECT office
               FROM ice_cream_survey
               GROUP BY office
               ORDER BY office')

AS (flavor varchar(20),
    Downtown bigint,
    Midtown bigint,
    Uptown bigint);
