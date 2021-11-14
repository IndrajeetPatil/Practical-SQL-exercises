-- Q1. Relationship between masters degree and median household income
/* 
 The r of the variables pct_bachelors_higher and median_hh_income was about .68,
 while the r of pct_masters_higher and median_hh_income is lower (.57).
 
 */
SELECT
    round(
        cast(
            corr(acs.pct_masters_higher, acs.median_hh_income) AS numeric
        ),
        2
    )
FROM
    acs_2011_2015_stats AS acs;

-- Q2. Meaningful comparisons
-- Milwaukee is at the top with 12.29 motor vehicle thefts per 1000 people
SELECT
    city,
    motor_vehicle_theft,
    population,
    round(
        (motor_vehicle_theft :: numeric / population) * 1000,
        2
    ) AS pct_motor_vehicle_theft
FROM
    fbi_crime_data_2015
WHERE
    population > 500000
ORDER BY
    pct_motor_vehicle_theft DESC;

-- Detroit is at the top with 17.60 violent crimes per 1000 people
SELECT
    city,
    violent_crime,
    population,
    round(
        (violent_crime :: numeric / population) * 1000,
        2
    ) AS pct_violent_crime
FROM
    fbi_crime_data_2015
WHERE
    population > 500000
ORDER BY
    pct_violent_crime DESC;

-- Q3. Ranking library agencies based on rates of visits
/* 
 The highest rate (of 12962.83 per 1000 people) is the Cuyahoga County Public Library, 
 which has 27 branches and serve 47 communities in Cuyahoga County, Ohio. 
 For more, see: <https://en.wikipedia.org/wiki/Cuyahoga_County_Public_Library>
 */
SELECT
    libname,
    city,
    stabr,
    visits,
    popu_lsa,
    round((visits :: numeric / popu_lsa) * 1000, 2) AS pct_visits,
    rank() over (
        ORDER BY
            round((visits :: numeric / popu_lsa) * 1000, 2) DESC
    )
FROM
    pls_fy2014_pupld14a
WHERE
    (popu_lsa > 250000)
    AND (visits > 0)
ORDER BY
    pct_visits DESC;

/* ----------------------- end --------------------------- */
-- Practice
-- TODO: how to avoid the repeated computation of pct_violent_crime here?
-- Select a few states and rank cities according to violent crime rates
SELECT
    st,
    city,
    violent_crime,
    population,
    round(
        (violent_crime :: numeric / population) * 1000,
        2
    ) AS pct_violent_crime,
    rank() over (
        PARTITION BY st
        ORDER BY
            round(
                (violent_crime :: numeric / population) * 1000,
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
            round((visits :: numeric / popu_lsa) * 1000, 2) AS pct_visits,
            rank() over (
                ORDER BY
                    round((visits :: numeric / popu_lsa) * 1000, 2) DESC
            )
        FROM
            pls_fy2014_pupld14a
        WHERE
            (popu_lsa > 250000)
            AND (visits > 0)
        ORDER BY
            pct_visits DESC
    ) AS pct_data;