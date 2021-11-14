--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- 1st Edition
-- Chapter 7 "Try It Yourself" Exercises
--------------------------------------------------------------
--
-- Q1. Choosing primary and foreign keys and imposing constraints
-- with justification
CREATE DATABASE vinyl;

CREATE TABLE albums (
    album_id bigserial,
    --each album should have a unique catalog code
    album_catalog_code varchar(100) NOT NULL,
    -- why not unique?: multiple artists can have albums with the same title
    album_title text,
    -- why not unique?: same artist can release multiple albums in a year
    album_artist text,
    -- why not unique?: multiple albums released on the same date
    album_release_date date,
    album_genre varchar(40),
    --each album should have a unique description
    album_description text,
    CONSTRAINT album_description_unique UNIQUE (album_description),
    CONSTRAINT album_code_unique UNIQUE (album_catalog_code),
    CONSTRAINT albums_key PRIMARY KEY (album_id)
);

CREATE TABLE songs (
    song_id bigserial,
    song_title text,
    song_artist text,
    -- no midnight calls and consistent with albums data type
    album_id bigserial REFERENCES albums (album_id),
    CONSTRAINT songs_key PRIMARY KEY (album_id)
);

-- Q2. Alternative natural primary key
/*
 Instead of `album_id` column as a *surrogate* primary key for the `albums` table, 
 `album_artist` column could be a *natural* primary key. 
 In this case, the foreign key for `songs` table will be `song_artist`.
 */
CONSTRAINT albums_key PRIMARY KEY (album_artist);

-- Q3. Possible indexing columns
/*
 good candidates for indexes: `album_id`, `album_catalog_code`, `album_description`
 */