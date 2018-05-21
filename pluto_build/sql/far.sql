-- calculate the built FAR
-- divide the total building are (bldgarea) by the total lot area (lotarea)
UPDATE pluto
SET builtfar = round(bldgarea::numeric / lotarea::numeric, 2)
WHERE lotarea <> '0' AND lotarea IS NOT NULL;

-- add FAR values based on zonedist and using lookup table
WITH fars AS (
	SELECT zoningdistrict,
		NULL AS residfar,
		 (CASE
			WHEN commfar IS NULL THEN commfarr6otr10
			ELSE commfar
			END) AS commfar,
		NULL AS facilfar
	FROM dcp_zoning_comm
	UNION
	SELECT zoningdistrict,
		NULL AS residfar,
		mnffar AS commfar,
		NULL AS facilfar
	FROM dcp_zoning_mnf
	UNION
	SELECT zoningdistrict,
		resfarbasic AS residfar,
		NULL AS commfar,
		commfacfar AS facilfar
	FROM dcp_zoning_res1to5
	UNION
	SELECT zoningdistrict,
		CASE
			WHEN widestreetfarmax IS NOT NULL THEN widestreetfarmax
			ELSE farmax
			END) AS commfar,
		 NULL AS commfar,
		NULL AS facilfar
	FROM dcp_zoning_res6to10
)


SELECT * FROM fars ORDER BY zoningdistrict

UPDATE pluto a
SET residfar = b.residfar,
	commfar = b.commfar,
	facilfar = b.facilfar
FROM fars b
WHERE a.zonedist1=b.zoningdistrict;

SELECT DISTINCT zonedist1 FROM pluto where residfar IS NULL and commfar IS NULL and facilfar IS NULL;


 R7-2
 R7-1
 M1-4/R8A
 R6
 M1-4/R6A
 M1-2/R6A
 M1-1/R7-2
 M1-5/R8A
 PARKNYS
 R8
 M1-3/R8
 M1-4/R7A
 M1-4/R7X
 PARK
