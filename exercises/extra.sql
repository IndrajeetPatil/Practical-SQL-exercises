-- The following exercises are not from the book, but just for my own practice
-- This script will keep updating while I keep practicing
-- the tables come from datasets mentioned across various chapters in the book

----------
--- P1 ---
----------

-- find first_name with at least one 'e' *and* 'a' at second position

SELECT
    first_name
FROM
    teachers
WHERE
    (first_name LIKE '%e%')
    AND (first_name LIKE '_a%');

----------
--- P2 ---
----------

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

----------
--- P3 ---
----------

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

----------
--- P4 ---
----------

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
    rank() over (PARTITION BY st ORDER BY round((violent_crime::numeric / population) * 1000, 2) DESC)
FROM
    fbi_crime_data_2015
WHERE
    (population > 500000)
    AND (st IN('Texas', 'California'));

----------
--- P5 ---
----------

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

----------
--- P6 ---
----------

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

----------
--- P7 ---
----------

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


----------
--- P8 ---
----------

-- calculate the descriptives for passenger count per trip for each vendor and hour
-- but only for trips with pick up times between 8-6 pm
-- we can see that vendor_id 2 consistently gets more passengers per trip pretty much
-- across all hours of interest

SELECT
    date_part('hour', tpep_pickup_datetime) AS pickup_hour,
    vendor_id,
    round(
        sum(passenger_count)::numeric / count(trip_id),
        2
    ) AS avg_passenger_per_trip,
    min(passenger_count) AS min_passenger_count,
    max(passenger_count) AS max_passenger_count
FROM
    nyc_yellow_taxi_trips_2016_06_01
GROUP BY
    vendor_id,
    pickup_hour
HAVING
    date_part('hour', tpep_pickup_datetime) BETWEEN '8' AND '18'
ORDER BY
    pickup_hour,
    vendor_id;


----------
--- P9 ---
----------

-- See how media proportion of each type has changed across years across libraries

-- update tables to add a new column for total of all media

ALTER TABLE
    pls_fy2014_pupld14a
ADD
    total_media integer;

UPDATE
    pls_fy2014_pupld14a
SET
    total_media = (bkvol + ebook + audio_ph + video_ph);

ALTER TABLE
    pls_fy2009_pupld09a
ADD
    total_media integer;

UPDATE
    pls_fy2009_pupld09a
SET
    total_media = (bkvol + ebook + audio + video);

-- create a view out of proportions
-- create CTEs that show the proportion of each type of media,
-- namely, books, ebooks, audio books, videos
-- two CTEs: one for 2009 and one for 2014

CREATE OR REPLACE VIEW media_pct_change AS
WITH media14 AS (
    SELECT
        stabr,
        fscskey,
        bkvol,
        (bkvol::numeric / total_media) AS book_prop,
        ebook,
        (ebook::numeric / total_media) AS ebook_prop,
        audio_ph,
        (audio_ph::numeric / total_media) AS audio_prop,
        video_ph,
        (video_ph::numeric / total_media) AS video_prop,
        total_media
    FROM
        pls_fy2014_pupld14a
    WHERE
        total_media > 0
),
media09 AS (
    SELECT
        fscskey,
        bkvol,
        (bkvol::numeric / total_media) AS book_prop,
        ebook,
        (ebook::numeric / total_media) AS ebook_prop,
        audio,
        (audio::numeric / total_media) AS audio_prop,
        video,
        (video::numeric / total_media) AS video_prop,
        total_media
    FROM
        pls_fy2009_pupld09a
    WHERE
        total_media > 0
)
SELECT
    stabr,
    media14.fscskey,
    round(
        (
            (media14.total_media - media09.total_media)::numeric / media09.total_media
        ) * 100,
        2
    ) AS pct_total_media,
    round(
        (
            (media14.book_prop - media09.book_prop)::numeric / media09.book_prop
        ) * 100,
        2
    ) AS pct_book_prop,
    round(
        (
            (media14.ebook_prop - media09.ebook_prop)::numeric / media09.ebook_prop
        ) * 100,
        2
    ) AS pct_ebook_prop,
    round(
        (
            (media14.audio_prop - media09.audio_prop)::numeric / media09.audio_prop
        ) * 100,
        2
    ) AS pct_audio_prop,
    round(
        (
            (media14.video_prop - media09.video_prop)::numeric / media09.video_prop
        ) * 100,
        2
    ) AS pct_video_prop
FROM
    media14
    INNER JOIN media09 ON media14.fscskey = media09.fscskey
WHERE
    media14.book_prop > 0
    AND media09.book_prop > 0
    AND media14.ebook_prop > 0
    AND media09.ebook_prop > 0
    AND media14.audio_prop > 0
    AND media09.audio_prop > 0
    AND media14.video_prop > 0
    AND media09.video_prop > 0;

-- a view table with average changes in media

CREATE
OR REPLACE VIEW avg_media_pct_change AS
SELECT
    stabr,
    round(avg(pct_total_media), 2) AS avg_pct_total_media,
    round(avg(pct_book_prop), 2) AS avg_pct_book_prop,
    round(avg(pct_ebook_prop), 2) AS avg_pct_ebook_prop,
    round(avg(pct_audio_prop), 2) AS avg_pct_audio_prop,
    round(avg(pct_video_prop), 2) AS avg_pct_video_prop
FROM
    media_pct_change
GROUP BY
    stabr
ORDER BY
    avg_pct_total_media DESC;

-- descriptive statistics for these changes
-- median of average changes across states

SELECT
    percentile_cont(0.5) WITHIN GROUP (ORDER BY avg_pct_book_prop DESC) AS median_avg_pct_book_prop,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY avg_pct_ebook_prop DESC) AS median_avg_pct_ebook_prop,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY avg_pct_audio_prop DESC) AS median_avg_pct_audio_prop,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY avg_pct_video_prop DESC) AS median_avg_pct_video_prop
FROM
    avg_media_pct_change;

/*
 From results, we can see that there has been a massive uptick in ebooks in libraries.
 The median of avergae change in ebooks across state libraries from 2009 to 2014 is
 is a whopping 22,000%!
 There has been a decrease in physical books with a median change of -11%. Similar
 trend is observed for audio books: -9%.
 For video collection, there is a modest increase, with a median at 16%.
*/

-- the state where maximum percentage increase was seen in ebooks: Delware (613,276%)
-- this massive change is mostly due to Milford Public Library, which had 1 ebook
-- in 2009 and 19,770 ebooks in 2014, which is 1,976,900% change!

SELECT
    stabr,
    avg_pct_ebook_prop
FROM
    avg_media_pct_change
WHERE
    avg_pct_ebook_prop = (
        SELECT
            max(avg_pct_ebook_prop)
        FROM
            avg_media_pct_change
    );

-- the state where minimum percentage increase was seen in ebooks: Minnesota (51%)
-- (using derived table to figure this out)

SELECT
    stabr,
    avg_pct_ebook_prop
FROM
    avg_media_pct_change
WHERE
    avg_pct_ebook_prop = (
        SELECT
            min(avg_pct_ebook_prop)
        FROM
            avg_media_pct_change
    );
