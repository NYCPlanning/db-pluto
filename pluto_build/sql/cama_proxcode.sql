-- assigning proxy code
-- recode DOF values to DCP values and remove 0s (Not Available)
-- select proxcode for lot from record where bldgnum is 1
-- all bbl reocrds have at least one record with a bldgnum = '1'
UPDATE pluto a
SET proxcode = b.proxcode
FROM (
	SELECT DISTINCT primebbl AS bbl,
		(CASE
			WHEN proxcode = '5' THEN '2'
			WHEN proxcode = '4' THEN '3'
			WHEN proxcode = '6' THEN '3'
			ELSE proxcode
		END) proxcode
	FROM pluto_input_cama
	WHERE proxcode <> '0'
	AND proxcode <> 'N'
	AND bldgnum = '1'
) b
WHERE a.bbl = b.bbl;

-- assign 0 (Not Available) to remaining records
UPDATE pluto
SET proxcode = '0'
WHERE proxcode IS NULL;