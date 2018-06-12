-- calculate the built FAR
-- divide the total building are (bldgarea) by the total lot area (lotarea)
UPDATE pluto
SET builtfar = round(bldgarea::numeric / lotarea::numeric, 2)
WHERE lotarea <> '0' AND lotarea IS NOT NULL;

-- add FAR values based on zonedist and using lookup table
DROP TABLE IF EXISTS fars;
-- create view of lookup table
CREATE TABLE fars AS (
	SELECT zoningdistrict,
		resequivalent,
		NULL AS residfar,
		 (CASE
			WHEN commfar IS NULL THEN commfarr6otr10
			ELSE commfar
		END) AS commfar,
		NULL AS facilfar
	FROM dcp_zoning_comm
	UNION
	SELECT zoningdistrict,
	 	NULL AS resequivalent,
		NULL AS residfar,
		mnffar AS commfar,
		NULL AS facilfar
	FROM dcp_zoning_mnf
	UNION
	SELECT zoningdistrict,
		NULL AS resequivalent,
		resfarbasic AS residfar,
		NULL AS commfar,
		commfacfar AS facilfar
	FROM dcp_zoning_res1to5
	UNION
	SELECT zoningdistrict,
		NULL AS resequivalent,
		(CASE
			WHEN widestreetfarmax IS NOT NULL THEN widestreetfarmax
			ELSE farmax
			END) AS residfar,
		 NULL AS commfar,
		commfacfar AS facilfar
	FROM dcp_zoning_res6to10
);
UPDATE fars
SET zoningdistrict = LEFT(zoningdistrict,length(zoningdistrict)-2)
WHERE zoningdistrict LIKE '%HF';
-- update resid and commfacility far based on resequivalent
UPDATE fars a
SET residfar = c.residfar
FROM (SELECT a.resequivalent, b.residfar, b.facilfar 
	FROM fars a
	JOIN fars b
	ON a.resequivalent=b.zoningdistrict
) c
WHERE c.resequivalent=a.resequivalent;
UPDATE fars a
SET facilfar = c.facilfar
FROM (SELECT a.resequivalent, b.residfar, b.facilfar 
	FROM fars a
	JOIN fars b
	ON a.resequivalent=b.zoningdistrict
) c
WHERE c.resequivalent=a.resequivalent;

-- base on zoning district 1
UPDATE pluto a
SET residfar = b.residfar,
	commfar = b.commfar,
	facilfar = b.facilfar
FROM fars b
WHERE a.zonedist1=b.zoningdistrict;
-- zoning district 1 with / first part 
UPDATE pluto a
SET residfar = b.residfar,
	commfar = b.commfar,
	facilfar = b.facilfar
FROM fars b
WHERE split_part(a.zonedist1, '/', 1)=b.zoningdistrict
AND a.zonedist1 LIKE '%/%';
-- zoning district 1 with / second part 
UPDATE pluto a
SET residfar = b.residfar
FROM fars b
WHERE split_part(a.zonedist1, '/', 2)=b.zoningdistrict
AND a.residfar IS NULL;
UPDATE pluto a
SET commfar = b.commfar
FROM fars b
WHERE split_part(a.zonedist1, '/', 2)=b.zoningdistrict
AND a.commfar IS NULL;
UPDATE pluto a
SET facilfar = b.facilfar
FROM fars b
WHERE split_part(a.zonedist1, '/', 2)=b.zoningdistrict
AND a.facilfar IS NULL;

-- base on zoning district 2
UPDATE pluto a
SET residfar = b.residfar
FROM fars b
WHERE a.zonedist2=b.zoningdistrict
AND a.residfar IS NULL;
UPDATE pluto a
SET commfar = b.commfar
FROM fars b
WHERE a.zonedist2=b.zoningdistrict
AND a.commfar IS NULL;
UPDATE pluto a
SET facilfar = b.facilfar
FROM fars b
WHERE a.zonedist2=b.zoningdistrict
AND a.facilfar IS NULL;
-- zoning district 2 with / first part 
UPDATE pluto a
SET residfar = b.residfar
FROM fars b
WHERE split_part(a.zonedist2, '/', 1)=b.zoningdistrict
AND a.residfar IS NULL;
UPDATE pluto a
SET commfar = b.commfar
FROM fars b
WHERE split_part(a.zonedist2, '/', 1)=b.zoningdistrict
AND a.commfar IS NULL;
UPDATE pluto a
SET facilfar = b.facilfar
FROM fars b
WHERE split_part(a.zonedist2, '/', 1)=b.zoningdistrict
AND a.facilfar IS NULL;
-- zoning district 2 with / second part 
UPDATE pluto a
SET residfar = b.residfar
FROM fars b
WHERE split_part(a.zonedist2, '/', 2)=b.zoningdistrict
AND a.residfar IS NULL;
UPDATE pluto a
SET commfar = b.commfar
FROM fars b
WHERE split_part(a.zonedist2, '/', 2)=b.zoningdistrict
AND a.commfar IS NULL;
UPDATE pluto a
SET facilfar = b.facilfar
FROM fars b
WHERE split_part(a.zonedist2, '/', 2)=b.zoningdistrict
AND a.facilfar IS NULL;

-- base on zoning district 3
UPDATE pluto a
SET residfar = b.residfar
FROM fars b
WHERE a.zonedist3=b.zoningdistrict
AND a.residfar IS NULL;
UPDATE pluto a
SET commfar = b.commfar
FROM fars b
WHERE a.zonedist3=b.zoningdistrict
AND a.commfar IS NULL;
UPDATE pluto a
SET facilfar = b.facilfar
FROM fars b
WHERE a.zonedist3=b.zoningdistrict
AND a.facilfar IS NULL;
-- zoning district 2 with / first part 
UPDATE pluto a
SET residfar = b.residfar
FROM fars b
WHERE split_part(a.zonedist3, '/', 1)=b.zoningdistrict
AND a.residfar IS NULL;
UPDATE pluto a
SET commfar = b.commfar
FROM fars b
WHERE split_part(a.zonedist3, '/', 1)=b.zoningdistrict
AND a.commfar IS NULL;
UPDATE pluto a
SET facilfar = b.facilfar
FROM fars b
WHERE split_part(a.zonedist3, '/', 1)=b.zoningdistrict
AND a.facilfar IS NULL;
-- zoning district 2 with / second part 
UPDATE pluto a
SET residfar = b.residfar
FROM fars b
WHERE split_part(a.zonedist3, '/', 2)=b.zoningdistrict
AND a.residfar IS NULL;
UPDATE pluto a
SET commfar = b.commfar
FROM fars b
WHERE split_part(a.zonedist3, '/', 2)=b.zoningdistrict
AND a.commfar IS NULL;
UPDATE pluto a
SET facilfar = b.facilfar
FROM fars b
WHERE split_part(a.zonedist3, '/', 2)=b.zoningdistrict
AND a.facilfar IS NULL;
-- drop far table
DROP TABLE IF EXISTS fars;
-- make NULLs zeros
UPDATE pluto a
SET residfar = 0
WHERE a.residfar IS NULL;
UPDATE pluto a
SET commfar = 0
WHERE a.commfar IS NULL;
UPDATE pluto a
SET facilfar = 0
WHERE a.facilfar IS NULL;

