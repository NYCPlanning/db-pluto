-- create table for tracking dcp edits
-- DROP TABLE IF EXISTS pluto_corrections CASCADE;
-- CREATE TABLE pluto_corrections (
-- 	bbl text,
-- 	field text,
-- 	old_value text, 
-- 	new_value text,
-- 	type text,
-- 	reason text,
-- 	version text);

-- -- insert current table published csv into postgres table
-- \COPY pluto_corrections FROM 'https://raw.githubusercontent.com/NYCPlanning/db-pluto/future/pluto_build/output/pluto_corrections.csv' DELIMITER ',' CSV;

-- add field to pluto to indicate a value has been edited
ALTER TABLE pluto
ADD COLUMN dcpedited text;

-- ALTER TABLE pluto_corrections
-- ADD COLUMN version text;

-- ALTER TABLE pluto_corrections
-- ADD COLUMN type text;