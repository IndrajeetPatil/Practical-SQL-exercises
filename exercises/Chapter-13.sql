--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- 1st Edition
-- Chapter 13 "Try It Yourself" Exercises
--------------------------------------------------------------


---------
-- Q1 --
---------


-- function to remove the comma: regexp_replace. For example:

SELECT
    regexp_replace('Alvarez, Jr.', ',', '');

-- can regex help?
-- just to extract first name: outputs 'Alvarez'

SELECT
    (regexp_match('Alvarez, Jr.', '\w+')) [1];

-- just to extract suffix: outputs 'Jr.'

SELECT
    (regexp_match('Alvarez, Jr.', '\s.+')) [1];

-- create a table with author names with suffixes and add values

CREATE TABLE authors(
    author_id bigserial,
    author_name varchar(50)
);

INSERT INTO
    authors (author_name)
VALUES
    ('Anthony'),
    ('Alvarez, Jr.'),
    ('Williams, Sr.');

-- add a new column for suffixes and extract suffixes to it

ALTER TABLE
    authors
ADD COLUMN
    suffix varchar(10);

UPDATE
    authors
SET
    suffix = (regexp_match(author_name, '\s.+')) [1];

-- now the suffixes can be removed from the original name

UPDATE
    authors
SET
    author_name = regexp_replace(author_name, ',\s.+', '');


---------
-- Q2 --
---------


-- for simplicity, let's create a new table only with one speech

CREATE TABLE speech AS (
    SELECT
        *
    FROM
        president_speeches
    where
        sotu_id = 4
);

-- convert all text to lower case
-- split the text into words based on space character (\s)
-- then remove '.' and ',' and ':'
-- then select only distinct words
-- then counts only the words whose length is equal to or more than 5
-- answer for this particular speech is 850

WITH words AS (
    SELECT
        DISTINCT regexp_replace(
            regexp_split_to_table(lower(speech_text), '\s+'),
            '[.,:]',
            ''
        ) AS clean_words
    FROM
        speech
    ORDER BY
        clean_words DESC
)
SELECT
    count(clean_words)
FROM
    words
WHERE
    length(clean_words) >= 5;


---------
-- Q3 --
---------


-- Using ts_rank_cd() function
/*
 Yes, ts_rank_cd() instead of ts_rank() does change result.
 With the former, the rankings are:
 Dwight D. Eisenhower, Richard M. Nixon, Harry S. Truman, Gerald R. Ford, Dwight D. Eisenhower
 Compare this rankind with that in table on page 238
 */

SELECT
    president,
    speech_date,
    ts_rank_cd(
        search_speech_text,
        to_tsquery('war & security & threat & enemy')
    ) AS score
FROM
    president_speeches
WHERE
    search_speech_text @ @ to_tsquery('war & security & threat & enemy')
ORDER BY
    score DESC
LIMIT
    5;
