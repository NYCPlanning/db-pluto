-- Take the year built from lpc_historic_districts
-- Insert new records into pluto_input_corrections for year built from LPC data
INSERT INTO pluto_input_corrections
WITH lpcyears AS (
SELECT bbl, 
	min(yearbuilt::numeric)::text as yearbuilt
FROM lpc_historic_districts
WHERE yearbuilt::numeric > 0
GROUP BY bbl)
SELECT DISTINCT a.bbl, 
	'yearbuilt' as field, 
	a.yearbuilt as old_value, 
	b.yearbuilt as new_value
FROM pluto a, lpcyears b
WHERE a.bbl = b.bbl
	AND a.yearbuilt<>b.yearbuilt
	AND a.bbl NOT IN (SELECT bbl FROM pluto_input_corrections WHERE field = 'yearbuilt');

-- Update records in pluto_input_corrections for year built from LPC data
WITH lpcyears AS (
SELECT bbl, 
	min(yearbuilt::numeric)::text as yearbuilt
FROM lpc_historic_districts
WHERE yearbuilt::numeric > 0
GROUP BY bbl)

UPDATE pluto_input_corrections a
SET new_value = b.yearbuilt
FROM lpcyears b
WHERE a.bbl = b.bbl
	AND a.field = 'yearbuilt'
	AND a.new_value<>b.yearbuilt
	AND b.yearbuilt::numeric > 0;