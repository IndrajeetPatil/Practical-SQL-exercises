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
            (ST_Area(geom::geography) / 2589988.110336)::numeric,
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
            (ST_Area(geom::geography) / 2589988.110336)::numeric,
            2
        )
    ) AS square_miles
FROM
    us_counties_2010_shp
GROUP BY
    statefp10
HAVING
    sum(
        (ST_Area(geom::geography) / 2589988.110336)::numeric
    ) > (
        SELECT
            (ST_Area(geom::geography) / 2589988.110336)::numeric
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
-- compute distance between these two markets

WITH
    market_start (geog_point) AS
    (
     SELECT geog_point
     FROM farmers_markets
     WHERE market_name = 'The Oakleaf Greenmarket'
    ),
    market_end (geog_point) AS
    (
     SELECT geog_point
     FROM farmers_markets
     WHERE market_name = 'Columbia Farmers Market'
    )
SELECT ST_Distance(market_start.geog_point, market_end.geog_point) / 1609.344 -- convert to meters to miles
FROM market_start, market_end;


---------
-- Q3 --
---------


-- cast column geom from geometry type to geography
-- create two CTEs, one for US county

WITH us_counties AS (
    SELECT
        namelsad10,
        ST_SetSRID(geom::geography, 4326) AS "geom"
    FROM
        us_counties_2010_shp
),
markets AS (
    SELECT
        *
    FROM
        farmers_markets
    WHERE
        county IS NULL
)
SELECT
    markets.county,
    us_counties.namelsad10,
    us_counties.geom
FROM
    markets
    JOIN us_counties ON ST_Intersects(markets.geog_point, us_counties.geom)
ORDER BY
    markets.fmid;
