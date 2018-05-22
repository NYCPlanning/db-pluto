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
		(CASE
			WHEN widestreetfarmax IS NOT NULL THEN widestreetfarmax
			ELSE farmax
			END) AS commfar,
		 NULL AS commfar,
		NULL AS facilfar
	FROM dcp_zoning_res6to10
)

UPDATE pluto a
SET residfar = b.residfar,
	commfar = b.commfar,
	facilfar = b.facilfar
FROM fars b
WHERE a.zonedist1=b.zoningdistrict;

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
		(CASE
			WHEN widestreetfarmax IS NOT NULL THEN widestreetfarmax
			ELSE farmax
			END) AS commfar,
		 NULL AS commfar,
		NULL AS facilfar
	FROM dcp_zoning_res6to10
),
distinctzoneing AS (
	SELECT DISTINCT zonedist1, b.residfar, b.commfar, b.facilfar, 
		c.residfar as residfar2, c.commfar as commfar2, c.facilfar as facilfar
	FROM pluto a
	LEFT JOIN fars b
	ON split_part(a.zonedist1, '/', 1)=b.zoningdistrict
	LEFT JOIN fars c
	ON split_part(a.zonedist1, '/', 1)=b.zoningdistrict
	WHERE zonedist1 LIKE '%/%'
)

SELECT * FROM distinctzoneing;

merged AS(
SELECT DISTINCT a.zonedist1, a.residfar, a.commfar, a.facilfar 
FROM distinctzoneing a
UNION (
	SELECT zonedist1, residfar2 AS residfar
	FROM distinctzoneing 
	WHERE residfar IS NOT NULL ) b
ON a.zonedist1=b.zonedist1
LEFT JOIN (
	SELECT zonedist1, commfar 
	FROM distinctzoneing 
	WHERE commfar IS NOT NULL) c
ON a.zonedist1=b.zonedist1
LEFT JOIN (
	SELECT zonedist1, facilfar 
	FROM distinctzoneing 
	WHERE facilfar IS NOT NULL) d
ON a.zonedist1=b.zonedist1
)

SELECT * FROM merged;


UPDATE pluto a
SET residfar = b.residfar,
	commfar = b.commfar,
	facilfar = b.facilfar
FROM distinctzoneing b
WHERE a.zonedist1=b.zonedist1
AND a.residfar IS NULL
AND a.commfar IS NULL
AND a.facilfar IS NULL 
AND b.residfar IS NOT NULL
AND b.commfar IS NOT NULL
AND b.facilfar IS NOT NULL;

SELECT * FROM distinctzoneing;

UPDATE pluto a
SET residfar = b.residfar,
	commfar = b.commfar,
	facilfar = b.facilfar
FROM distinctzoneing b
WHERE a.zonedist1=b.zoningdistrict
AND zonedist1 LIKE '%/%' 
AND (a.residfar IS NULL
AND a.commfar IS NULL
AND a.facilfar IS NULL;


SELECT * FROM fars ORDER BY zoningdistrict;

SELECT DISTINCT zonedist1, zonedist2, zonedist3, zonedist4, residfar, commfar, facilfar FROM nycpluto_all ORDER BY zonedist1



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
