-- Take the year built from researched lpc_historic_districts table
-- Insert records into pluto_corrections for year built from LPC data
INSERT INTO pluto_corrections
SELECT DISTINCT a.bbl, 
	'yearbuilt' as field, 
	a.yearbuilt as old_value, 
	b.new_value as new_value,
	b.type as type,
	b.reason as reason,
	b.version as version
FROM pluto a, pluto_input_research b
WHERE a.bbl = b.bbl
	AND a.yearbuilt=b.old_value
	AND b.field = 'yearbuilt'
	AND a.bbl NOT IN (SELECT bbl FROM pluto_corrections WHERE field = 'yearbuilt');

INSERT INTO pluto_corrections_not_applied
SELECT DISTINCT b.*
FROM pluto_corrections b, pluto a
WHERE b.bbl=a.bbl 
	AND b.field='yearbuilt'
	AND b.old_value <> a.yearbuilt;

INSERT INTO pluto_corrections_applied
SELECT DISTINCT b.*
FROM pluto_corrections b, pluto a
WHERE b.bbl=a.bbl 
	AND b.field='yearbuilt' 
	AND b.old_value = a.yearbuilt;

-- Apply correction to PLUTO
UPDATE pluto a
SET yearbuilt = b.new_value,
	dcpedited = 't'
FROM pluto_corrections b
WHERE a.bbl = b.bbl
	AND b.field = 'yearbuilt'
	AND a.yearbuilt=b.old_value;