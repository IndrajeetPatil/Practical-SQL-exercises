--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- 1st Edition
-- Chapter 11 "Try It Yourself" Exercises
--------------------------------------------------------------


---------
-- Q1 --
---------


-- sorted durations of journeys
/*
 The longest journey durations are astoundingly close to 24 hours, even though
 the trip distance is a mere few kilometers. Is this due to traffic jams?

 On the lower end, the shortest durations are instantenous (0 seconds), and yet
 the customers seem to have paid a handsome sum. Why were they charged?!
 */

SELECT
    trip_id,
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    (tpep_dropoff_datetime - tpep_pickup_datetime) AS duration,
    trip_distance,
    total_amount
FROM
    nyc_yellow_taxi_trips_2016_06_01
ORDER BY
    duration DESC;


---------
-- Q2 --
---------


-- exploring time zones

CREATE TABLE time_test_table(test_dttm timestamptz);

-- without daylight saving (which usually lasts from March to November)

INSERT INTO
    time_test_table
VALUES
    ('2100-01-01 00:00:00 UTC-04:00');

-- London: 2099-12-31 20:00:00

SELECT
    test_dttm AT TIME ZONE 'GMT'
FROM
    time_test_table;

-- Johannesburg: 2099-12-31 18:00:00

SELECT
    test_dttm AT TIME ZONE 'GMT+2'
FROM
    time_test_table;

-- Moscow: 2099-12-31 17:00:00

SELECT
    test_dttm AT TIME ZONE 'GMT+2'
FROM
    time_test_table;

-- Melbourne: 2099-12-31 09:00:00

SELECT
    test_dttm AT TIME ZONE 'GMT+11'
FROM
    time_test_table;

-- Los Angeles (for fun): 2100-01-01 04:00:00

SELECT
    test_dttm AT TIME ZONE 'GMT-8'
FROM
    time_test_table;


---------
-- Q3 --
---------


-- correlation and r2 values for associations
/*
 Relationship between trip duration and total amount is strong (r = .80, r2 = .64),
 with 64% of the variance in total amount paid accounted for by the trip duration.

 Relationship between trip distance and total amount is stronger (r = .86, r2 = .73),
 with 73% of the variance in total amount paid accounted for by the trip duration.

 Rest of the variance is explained by other factors (e.g. the tip amount is not
 related to either duration or distance).
 */

SELECT
    -- relationship between trip duration and total amount
    round(
        corr(
            (
                date_part(
                    'epoch',
                    tpep_dropoff_datetime - tpep_pickup_datetime
                )
            ),
            total_amount
        ) :: numeric,
        2
    ) AS r_duration_amount,
    round(
        regr_r2(
            (
                date_part(
                    'epoch',
                    tpep_dropoff_datetime - tpep_pickup_datetime
                )
            ),
            total_amount
        ) :: numeric,
        2
    ) AS r2_duration_amount,
    -- relationship between trip distance and total amount
    round(corr(trip_distance, total_amount) :: numeric, 2) AS r_distance_amount,
    round(
        regr_r2(trip_distance, total_amount) :: numeric,
        2
    ) AS r2_distance_amount
FROM
    nyc_yellow_taxi_trips_2016_06_01
WHERE
    (tpep_dropoff_datetime - tpep_pickup_datetime) < '03:00:00' :: interval;
