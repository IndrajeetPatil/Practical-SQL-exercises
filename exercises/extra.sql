-- The following exercises are not from the book, but just for my own practice
-- This script will keep updating while I keep practicing

-- the tables come from datasets mentioned across various chapters in the book
-- more practice with string matching
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

-- Practising more with the US census 2010 data
-- check out where housing crisis is expected to be happening

SELECT
    geo_name,
    state_us_abbreviation,
    (
        CAST(housing_unit_count_100_percent AS numeric) / CAST(population_count_100_percent AS numeric)
    ) * 100 AS housing_prop
FROM
    us_counties_2010
WHERE
    population_count_100_percent > 10000
ORDER BY
    housing_prop ASC,
    state_us_abbreviation;

-- TODO: how to avoid the repeated computation of pct_violent_crime here?
-- Select a few states and rank cities according to violent crime rates

SELECT
    st,
    city,
    violent_crime,
    population,
    round(
        (violent_crime::numeric / population) * 1000,
        2
    ) AS pct_violent_crime,
    rank() over (
        PARTITION BY st
        ORDER BY
            round(
                (violent_crime::numeric / population) * 1000,
                2
            ) DESC
    )
FROM
    fbi_crime_data_2015
WHERE
    (population > 500000)
    AND (st IN('Texas', 'California'));

-- summary of library visit rates (min, median, max)

SELECT
    MIN(pct_data.pct_visits),
    percentile_cont(0.5) WITHIN GROUP (
        ORDER BY
            pct_data.pct_visits
    ),
    MAX(pct_data.pct_visits)
FROM
    (
        SELECT
            libname,
            city,
            stabr,
            visits,
            popu_lsa,
            round((visits::numeric / popu_lsa) * 1000, 2) AS pct_visits,
            rank() over (
                ORDER BY
                    round((visits::numeric / popu_lsa) * 1000, 2) DESC
            )
        FROM
            pls_fy2014_pupld14a
        WHERE
            (popu_lsa > 250000)
            AND (visits > 0)
        ORDER BY
            pct_visits DESC
    ) AS pct_data;

-- FBI data
-- create a view with correlations between all crime variables
-- note that the maximum correlation is between violence and burglary, while
-- minimum between violence and larceny
CREATE OR REPLACE VIEW corr_table AS (
    SELECT
        round(
            corr(rpt_violent_crime, rpt_property_crime)::numeric,
            2
        ) AS r_violence_property,
        round(
            corr(rpt_violent_crime, rpt_burglary)::numeric,
            2
        ) AS r_violence_burglary,
        round(
            corr(rpt_violent_crime, rpt_larceny_theft)::numeric,
            2
        ) AS r_violence_larceny,
        round(
            corr(rpt_violent_crime, rpt_motor_vehicle_theft)::numeric,
            2
        ) AS r_violence_motor,
        round(
            corr(rpt_burglary, rpt_larceny_theft)::numeric,
            2
        ) AS r_burglary_larceny,
        round(
            corr(rpt_burglary, rpt_motor_vehicle_theft)::numeric,
            2
        ) AS r_burglary_motor,
        round(
            corr(rpt_larceny_theft, rpt_motor_vehicle_theft)::numeric,
            2
        ) AS r_larceny_motor
    FROM
        -- derived table
        (
            SELECT
                rates_per_thousand(violent_crime, population, 3) AS rpt_violent_crime,
                rates_per_thousand(property_crime, population, 3) AS rpt_property_crime,
                rates_per_thousand(burglary, population, 3) AS rpt_burglary,
                rates_per_thousand(larceny_theft, population, 3) AS rpt_larceny_theft,
                rates_per_thousand(motor_vehicle_theft, population, 3) AS rpt_motor_vehicle_theft
            FROM
                fbi_crime_data_2015
        ) AS rpt_crimes
);

-- NYC taxi data
-- min, max, and average distance travelled and passanger count by hour of travel

SELECT
    date_part('hour', tpep_pickup_datetime) as pickup_hour,
    min(trip_distance) AS min_distance_rate,
    max(trip_distance) AS max_distance_rate,
    sum(trip_distance)::numeric / count(trip_id) AS avg_distance_rate,
    min(passenger_count) AS min_passenger_count,
    max(passenger_count) AS max_passenger_count,
    sum(passenger_count)::numeric / count(trip_id) AS avg_passenger_count
FROM
    nyc_yellow_taxi_trips_2016_06_01
GROUP BY
    pickup_hour
ORDER BY
    pickup_hour;

