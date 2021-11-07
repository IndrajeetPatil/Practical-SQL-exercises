/* ----------------------- begin --------------------------- */
-- create a database for a zoo 
CREATE DATABASE zoo;

-- create a table describing animals in zoo (humans not included ;-) )
-- total_count is smallint coz a zoo won't have thousands of same animals
/*
 why isn't smallserial highlighted here?
 https://stackoverflow.com/questions/69873070/data-type-smallserial-in-postgres-not-highlighted-in-visual-studio-code/69873573#69873573
 */
CREATE TABLE animals (
    species_counter smallserial,
    species_name varchar(100),
    total_count smallint,
    avg_weight numeric,
    date_acquisition date
);

-- insert some made up data into it
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