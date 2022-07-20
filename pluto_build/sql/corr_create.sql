-- add field to pluto to indicate a value has been edited
ALTER TABLE pluto
ADD COLUMN dcpedited text;

DROP TABLE IF EXISTS pluto_corrections_not_applied;
CREATE TABLE pluto_corrections_not_applied (LIKE pluto_corrections INCLUDING ALL);

DROP TABLE IF EXISTS pluto_corrections_applied;
CREATE TABLE pluto_corrections_applied (LIKE pluto_corrections INCLUDING ALL);
