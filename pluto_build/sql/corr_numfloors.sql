-- Take the community district value from research table
-- Insert records into pluto_corrections
INSERT INTO pluto_corrections
SELECT DISTINCT a.bbl, 
	'numfloors' as field, 
	a.numfloors as old_value, 
	b.new_value as new_value,
	b.type as type,
	b.reason as reason,
	b.version as version
FROM pluto a, pluto_input_research b
WHERE a.bbl = b.bbl
	AND a.cd=b.old_value
	AND b.field = 'numfloors'
	AND a.bbl NOT IN (SELECT bbl FROM pluto_corrections WHERE field = 'numfloors');

-- Apply correction to PLUTO
UPDATE pluto a
SET numfloors = b.new_value,
	dcpedited = 't'
FROM pluto_corrections b
WHERE a.bbl = b.bbl
	AND b.field = 'numfloors'
	AND a.numfloors=b.old_value;
