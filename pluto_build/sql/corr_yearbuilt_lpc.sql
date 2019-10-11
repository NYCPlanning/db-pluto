-- Take the year built from researched lpc_historic_districts table
-- Insert records into pluto_input_corrections for year built from LPC data
INSERT INTO pluto_input_corrections
SELECT DISTINCT a.bbl, 
	'yearbuilt' as field, 
	a.yearbuilt as old_value, 
	b.lpcyearbuilt as new_value
FROM pluto a, lpcyears b
WHERE a.bbl = b.bbl
	AND a.yearbuilt=b.plutoyearbuilt
	AND a.bbl NOT IN (SELECT bbl FROM pluto_input_corrections WHERE field = 'yearbuilt');

-- Apply correction to PLUTO
UPDATE pluto a
SET yearbuilt = b.lpcyearbuilt,
	dcpedited = 't'
FROM pluto_corr_lpcyears b
WHERE a.bbl = b.bbl
	AND a.yearbuilt=b.plutoyearbuilt;