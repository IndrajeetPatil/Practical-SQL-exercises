--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- 1st Edition
-- Chapter 14 "Try It Yourself" Exercises
--------------------------------------------------------------
---------
-- Q1 --
---------
-- area of each state in square miles
SELECT
    statefp10,
    sum(
        round(
            (ST_Area(geom :: geography) / 2589988.110336) :: numeric,
            2
        )
    ) AS square_miles
FROM
    us_counties_2010_shp
GROUP BY
    statefp10
ORDER BY
    square_miles DESC;

-- How many states are bigger than Yukon-Koyukuk?
-- 3 states (statefp10: 02, 06, 48)
SELECT
    statefp10,
    sum(
        round(
            (ST_Area(geom :: geography) / 2589988.110336) :: numeric,
            2
        )
    ) AS square_miles
FROM
    us_counties_2010_shp
GROUP BY
    statefp10
HAVING
    sum(
        (ST_Area(geom :: geography) / 2589988.110336) :: numeric
    ) > (
        SELECT
            (ST_Area(geom :: geography) / 2589988.110336) :: numeric
        FROM
            us_counties_2010_shp
        WHERE
            name10 = 'Yukon-Koyukuk'
    )
ORDER BY
    square_miles DESC;

---------
-- Q2 --
---------
-- extracting lat/long info
SELECT
    market_name,
    street,
    latitude,
    longitude
FROM
    farmers_markets
WHERE
    market_name IN (
        'The Oakleaf Greenmarket',
        'Columbia Farmers Market'
    );

-- compute distance between these two markets
-- it's 405.38 miles
-- Google shows this distance to be > 1000 miles, so something is wrong here
-- https://www.google.com/maps/dir/1701+West+Ash+Street,+Columbia,+Missouri,+USA/9700+Argyle+Forest+Blvd,+Jacksonville,+FL+32222,+USA/@34.5090007,-91.5877959,6z/data=!3m1!4b1!4m15!4m14!1m5!1m1!1s0x87dcb61894dab121:0x4493302dd6707e2f!2m2!1d-92.3627!2d38.95749!1m5!1m1!1s0x88e5c19afa6ffb09:0x3789f4b88b06c4ff!2m2!1d-81.8312553!2d30.1950797!3e0!4e1
SELECT
    round(
        ST_Distance(
            ST_GeogFromText('POINT(38.9586090 -92.3636690)'),
            ST_GeogFromText('POINT(30.1942000 -81.8335000)')
        ) :: numeric / 1609.344,
        2
    ) AS oakleaf_to_columbia;

---------
-- Q3 --
---------
-- cast column geom from geometry type to geography
UPDATE
    us_counties_2010_shp
SET
    geom = ST_SetSRID(geom, 4326) :: geography;

select
    namelsad10,
    geom :: geography
from
    us_counties_2010_shp;