--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- 1st Edition
-- Chapter 15 "Try It Yourself" Exercises
--------------------------------------------------------------


---------
-- Q1 --
---------


-- creating view for taxi trip counts per hour

CREATE OR REPLACE VIEW trip_hour_counts AS
SELECT
    date_part('hour', tpep_pickup_datetime) AS trip_hour,
    count(*)
FROM
    nyc_yellow_taxi_trips_2016_06_01
GROUP BY
    trip_hour;

-- Use it in Listing 11-8 to simlify it

SELECT
    *
FROM
    trip_hour_counts
ORDER BY
    trip_hour;

---------
-- Q2 --
---------


-- custom function to calculate rates per thousand

CREATE
OR REPLACE FUNCTION rates_per_thousand(
    observed_number numeric,
    base_number numeric,
    decimal_places integer DEFAULT 1
) RETURNS numeric AS '
SELECT round(
        (observed_number::numeric / base_number) * 1000, decimal_places
        );
'
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;

-- use it in Listing 10-9 to make sure you get the same results
SELECT
    city,
    st,
    population,
    property_crime,
    rates_per_thousand(property_crime, population, 1)
FROM
    fbi_crime_data_2015
WHERE
    population >= 500000
ORDER BY
    (property_crime::numeric / population) DESC;

---------
-- Q3 --
---------
-- implement a trigger that automatically adds an inspection date to the
-- meat_poultry_egg_inspect table each time you insert a new facility
CREATE TRIGGER facility_insert
BEFORE INSERT ON
FOR EACH ROW
EXECUTE PROCEDURE add_inspection_date();
