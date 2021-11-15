--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- 1st Edition
-- Chapter 6 "Try It Yourself" Exercises
--------------------------------------------------------------


---------
-- Q1 --
---------

-- The curious case of missing counties
-- identify which counties don’t exist in both tables
/*
 Present in 2000 but not in 2010 (these counties were incorporated in city-and-borough)
 - Clifton Forge city, Virginia
 - Wrangell-Petersburg Census Area, Alaska

 Present in 2010 but not in 2000 (newly created counties)
 - Prince of Wales-Hyder Census Area
 - Skagway Municipality
 - Broomfield County
 */

SELECT
    *
FROM
    (
        SELECT
            county_fips,
            geo_name
        FROM
            us_counties_2000
    ) AS us00 FULL
    JOIN (
        SELECT
            county_fips,
            geo_name
        FROM
            us_counties_2010
    ) AS us10 ON us00.county_fips = us10.county_fips
WHERE
    (us10.county_fips IS NULL)
    OR (us00.county_fips IS NULL);
