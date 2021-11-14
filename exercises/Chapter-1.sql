--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- 1st Edition
-- Chapter 1 "Try It Yourself" Exercises
--------------------------------------------------------------
--
/* ----------------------- begin --------------------------- */
-- create a database for a zoo 
CREATE DATABASE zoo;

-- Q1. create a table describing animals in zoo (humans not included ;-) )
-- total_count is smallint coz a zoo won't have thousands of same animals
CREATE TABLE animals (
    species_counter smallserial,
    species_name varchar(100),
    total_count smallint,
    avg_weight numeric,
    date_acquisition date
);

-- Q2. insert some made up data into it
INSERT INTO
    animals (
        species_name,
        total_count,
        avg_weight,
        date_acquisition
    )
VALUES
    ('Zebra', 2, 200.10, '2020-2-3'),
    ('Lion', 1, 190.50, '2018-7-8'),
    ('Tiger', 2, 150.40, '2017-12-1');

/* ----------------------- end --------------------------- */