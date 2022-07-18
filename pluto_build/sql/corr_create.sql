-- add field to pluto to indicate a value has been edited
ALTER TABLE pluto
ADD COLUMN dcpedited text;

DROP TABLE IF EXISTS pluto_corrections_not_applied;
CREATE TABLE pluto_corrections_not_applied (
	bbl 		    VARCHAR,
	field 	  		VARCHAR,
	old_value 		VARCHAR,
	new_value 		VARCHAR,
	type            VARCHAR,
    reason          VARCHAR,
    version         VARCHAR
);

DROP TABLE IF EXISTS pluto_corrections_applied;
CREATE TABLE pluto_corrections_applied (
	bbl 		    VARCHAR,
	field 	  		VARCHAR,
	old_value 		VARCHAR,
	new_value 		VARCHAR,
	type            VARCHAR,
    reason          VARCHAR,
    version         VARCHAR
);
