-- create table for tracking dcp edits
DROP TABLE IF EXISTS pluto_corrections CASCADE;
CREATE TABLE pluto_corrections (
	bbl text,
	field text,
	old_value text, 
	new_value text,
	reason text);

-- add field to pluto to indicate a value has been edited
ALTER TABLE pluto
ADD COLUMN dcpedited text;