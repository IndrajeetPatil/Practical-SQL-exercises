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
-- identify which counties don’t exist in either of the tables
/*
 Present in 2000 but not in 2010 (these counties were incorporated in city-and-borough)
 - Clifton Forge city, Virginia
 - Prince of Wales-Outer Ketchikan Census Area, Alaska
 - Skagway-Hoonah-Angoon Census Area, Alaska
 - Wrangell-Petersburg Census Area, Alaska

 Present in 2010 but not in 2000 (newly created counties)
 - Broomfield County
 - Hoonah-Angoon Census Area
 - Petersburg Census Area
 - Prince of Wales-Hyder Census Area
 - Skagway Municipality
 - Wrangell City and Borough
 */

SELECT
    c2000.geo_name AS county_2000_name,
    c2000.county_fips AS county_2000,
    c2010.geo_name AS county_2010_name,
    c2010.county_fips AS county_2010
FROM
    us_counties_2010 AS c2010 FULL
    JOIN us_counties_2000 AS c2000 ON c2010.state_fips = c2000.state_fips
    AND c2010.county_fips = c2000.county_fips
WHERE
    (c2010.county_fips IS NULL)
    OR (c2000.county_fips IS NULL)
ORDER BY
    county_2010_name;

---------
-- Q2 --
---------


-- median of the percent change in county population: 3.2%

SELECT
    percentile_cont(.5) WITHIN GROUP (
        ORDER BY
            (
                (c2010.p0010001::numeric - c2000.p0010001) / c2000.p0010001 * 100
            )
    ) AS median_pct_change
FROM
    us_counties_2010 AS c2010
    INNER JOIN us_counties_2000 AS c2000 ON c2010.state_fips = c2000.state_fips
    AND c2010.county_fips = c2000.county_fips
    AND c2010.p0010001 <> c2000.p0010001;


---------
-- Q3 --
---------


-- the greatest percentage loss of population
/*
 The greatest percentage loss of population between 2000 and 2010 was seen
 in St. Bernard Parish, Louisiana (-46.6%). This was because, on August 29, 2005,
 St. Bernard was devastated by Hurricane Katrina.
 */

SELECT
    c2010.geo_name,
    c2010.state_us_abbreviation AS st,
    c2010.p0010001 AS pop_2010,
    c2000.p0010001 AS pop_2000,
    round(
        (c2010.p0010001::numeric - c2000.p0010001) / c2000.p0010001 * 100,
        1
    ) AS pct_change
FROM
    us_counties_2010 AS c2010
    INNER JOIN us_counties_2000 AS c2000 ON c2010.state_fips = c2000.state_fips
    AND c2010.county_fips = c2000.county_fips
    AND c2010.p0010001 <> c2000.p0010001
ORDER BY
    pct_change ASC;
