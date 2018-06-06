-- update ownername and owner type based on bbl matches in COLP
WITH colp AS (
	SELECT 
	(CASE WHEN boro = 'STATEN ISLAND' THEN '5'
		WHEN boro = 'QUEENS' THEN '4'
		WHEN boro = 'BROOKLYN' THEN '3'
		WHEN boro = 'BRONX' THEN '2'
		WHEN boro = 'MANHATTAN' THEN '1'
		ELSE '0'
	END)||lpad(a.block, 5, '0')||lpad(a.lot, 4, '0') AS bbl,
	agency
	FROM dcas_facilities_colp a
	WHERE type = 'OF'
)

UPDATE pluto a
SET ownertype = 'C',
ownername = b.agency
FROM colp b
WHERE a.bbl = b.bbl;