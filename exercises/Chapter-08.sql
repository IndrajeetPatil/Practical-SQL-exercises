--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- 1st Edition
-- Chapter 8 "Try It Yourself" Exercises
--------------------------------------------------------------


---------
-- Q1 --
---------


-- Use of technology in library
-- Create tables using Listing 8-1 and Listing 8-2
/*
 Results show that-

 1. There has been a big increases in gpterms (the number of internet-connected
 computers used by the public), with the biggest being 827% for Guam.
 Only two states had decrease: Hawaii (-2.4%) and Puerto Rico (-6.18%)

 2. The pitusr (use of public internet computers per year), on the other hand,
 has seen both increase and descrease across states.
 */

SELECT
    pls14.stabr,
    SUM(pls14.gpterms) AS gpterms_14,
    SUM(pls09.gpterms) AS gpterms_09,
    SUM(pls14.pitusr) AS pitusr_14,
    SUM(pls09.pitusr) AS pitusr_09,
    round(
        (
            CAST(
                SUM(pls14.gpterms) - SUM(pls09.gpterms) AS numeric(10, 1)
            ) / SUM(pls09.gpterms)
        ) * 100,
        2
    ) AS pct_change_gpterms,
    round(
        (
            CAST(
                SUM(pls14.pitusr) - SUM(pls09.pitusr) AS numeric(10, 1)
            ) / SUM(pls09.pitusr)
        ) * 100,
        2
    ) AS pct_change_pitusr
FROM
    pls_fy2014_pupld14a AS pls14
    INNER JOIN pls_fy2009_pupld09a AS pls09 ON pls14.fscskey = pls09.fscskey
WHERE
    -- negative integers means missing entries
    (pls14.gpterms > 0)
    AND (pls09.gpterms > 0)
    AND (pls14.pitusr > 0)
    AND (pls09.pitusr > 0)
GROUP BY
    pls14.stabr
ORDER BY
    pct_change_gpterms DESC;


---------
-- Q2 --
---------


-- create a table with Bureau of Economic Analysis Codes and corresponding regions
-- Ref: <https://www.icip.iastate.edu/maps/refmaps/bea>

CREATE TABLE region_details (
    obereg varchar(2) CONSTRAINT region_key PRIMARY KEY,
    region_name text
);

INSERT INTO
    region_details(obereg, region_name)
VALUES
    ('01', 'New England Region'),
    ('02', 'Mideast Region'),
    ('03', 'Great Lakes Region'),
    ('04', 'Plain Region'),
    ('05', 'Southeast Region'),
    ('06', 'Southwest Region'),
    ('07', 'Rocky Mountain Region'),
    ('08', 'Far West Region'),
    ('09', 'Territories Region');

-- percent change in visit by Bureau of Economic Analysis Code regions
/*
 All regions have seen decrease, with the highest one (-12.66%) in Great Lakes region,
 while the lowest in (-1.78%) in Rocky Mountain Region.
*/

SELECT
    pls14.region_name,
    pls14.obereg,
    round(
        (
            (sum(pls14.visits) :: numeric - sum(pls09.visits)) / sum(pls09.visits)
        ) * 100,
        2
    ) AS pct_change_visits
FROM
    (
        SELECT
            pls14.obereg,
            region_name,
            visits,
            fscskey
        FROM
            pls_fy2014_pupld14a AS pls14
            LEFT JOIN region_details AS regions ON pls14.obereg = regions.obereg
    ) AS pls14
    INNER JOIN pls_fy2009_pupld09a AS pls09 ON pls14.fscskey = pls09.fscskey
WHERE
    pls14.visits > 0
    AND pls09.visits > 0
GROUP BY
    pls14.region_name,
    pls14.obereg
ORDER BY
    pct_change_visits;


---------
-- Q3 --
---------


-- Missing agencies
-- There are 236 agencies which are not present in either of the tables

SELECT
    *
FROM
    (
        SELECT
            fscskey,
            libname
        FROM
            pls_fy2014_pupld14a
    ) AS pls14 FULL
    JOIN (
        SELECT
            fscskey,
            libname
        FROM
            pls_fy2009_pupld09a
    ) AS pls09 ON pls14.fscskey = pls09.fscskey
WHERE
    (pls14.fscskey IS NULL)
    OR (pls09.fscskey IS NULL);
