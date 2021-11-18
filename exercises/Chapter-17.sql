--------------------------------------------------------------
-- Practical SQL: A Beginner's Guide to Storytelling with Data
-- by Anthony DeBarros
-- 1st Edition
-- Chapter 17 "Try It Yourself" Exercises
--------------------------------------------------------------

-- backing up entire gis_analysis database

-- note that this needs to be used with the normal, and not psql, command prompt
pg_dump -d gis_analysis -U postgres -Fc > gis_analysis_backup.sql

-- backing only a single table from this database
pg_dump -t 'spatial_ref_sys' -d gis_analysis -U postgres -Fc > spatial_ref_sys_backup.sql

-- delete the database using pgAdmin

-- restore using the backup
pg_restore -C -d gis_anaylsis -U postgres gis_analysis_backup.sql
