-- Q1. Use of technology in library
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

-- Q2.
-- Q3. Missing agencies
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