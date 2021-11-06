-- create a database for a zoo 
CREATE DATABASE zoo;

-- create a table describing animals in zoo (humans not included ;-) )
CREATE TABLE animals (
    species_counter bigserial,
    species_name varchar,
    total_count numeric,
    date_acquisition date
);

-- insert some made up data into it
INSERT INTO
    animals (species_name, total_count, date_acquisition)
VALUES
    ('Zebra', 2, '2020-2-3'),
    ('Lion', 1, '2018-7-8'),
    ('Tiger', 2, '2017-12-1');