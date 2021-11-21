--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- 1st Edition
-- Chapter 9 "Try It Yourself" Exercises
--------------------------------------------------------------


----------
-- Q1-3 --
----------


-- creating count of different activities at the plant
-- Step 1: create two new columns

ALTER TABLE meat_poultry_egg_inspect
    ADD COLUMN meat_processing boolean,
    ADD COLUMN poultry_processing boolean;

-- Step 2: set them to true based on activities column

UPDATE
    meat_poultry_egg_inspect
SET
    meat_processing = TRUE
WHERE
    activities ILIKE '%Meat Processing%';

UPDATE
    meat_poultry_egg_inspect
SET
    poultry_processing = TRUE
WHERE
    activities ILIKE '%Poultry Processing%';

-- Step 3: counts
-- Meat Processing: 4832

SELECT
    count(*) AS meat_processing_total
FROM
    meat_poultry_egg_inspect
WHERE
    meat_processing IS NOT NULL;

-- Poultry Processing: 3787

SELECT
    count(*) AS poultry_processing
FROM
    meat_poultry_egg_inspect
WHERE
    poultry_processing IS NOT NULL;

-- Both activities: 3395

SELECT
    count(*) AS both_activities
FROM
    meat_poultry_egg_inspect
WHERE
    (poultry_processing IS NOT NULL)
    AND (meat_processing IS NOT NULL);
