-- calculate the built FAR
-- divide the total building are (bldgarea) by the total lot area (lotarea)
UPDATE pluto
SET builtfar = round(bldgarea::numeric / lotarea::numeric, 2)
WHERE lotarea <> '0' AND lotarea IS NOT NULL;

-- using dcp_zoning_maxfar maintained by zoning division
-- base on zoning district 1
UPDATE pluto a
SET residfar = b.residfar,
	commfar = b.commfar,
	facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist1=b.zonedist;
-- zoning district 1 with / first part 
UPDATE pluto a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist1, '/', 1)=b.zonedist
AND a.residfar IS NULL;

UPDATE pluto a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist1, '/', 1)=b.zonedist
AND a.commfar IS NULL;

UPDATE pluto a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist1, '/', 1)=b.zonedist
AND a.facilfar IS NULL;
-- zoning district 1 with / second part 

UPDATE pluto a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist1, '/', 2)=b.zonedist
AND a.residfar IS NULL;

UPDATE pluto a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist1, '/', 2)=b.zonedist
AND a.commfar IS NULL;

UPDATE pluto a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist1, '/', 2)=b.zonedist
AND a.facilfar IS NULL;

-- base on zoning district 2
UPDATE pluto a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist2=b.zonedist
AND a.residfar IS NULL;

UPDATE pluto a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist2=b.zonedist
AND a.commfar IS NULL;

UPDATE pluto a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist2=b.zonedist
AND a.facilfar IS NULL;
-- zoning district 2 with / first part 
UPDATE pluto a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist2, '/', 1)=b.zonedist
AND a.residfar IS NULL;

UPDATE pluto a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist2, '/', 1)=b.zonedist
AND a.commfar IS NULL;

UPDATE pluto a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist2, '/', 1)=b.zonedist
AND a.facilfar IS NULL;

-- zoning district 2 with / second part 
UPDATE pluto a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist2, '/', 2)=b.zonedist
AND a.residfar IS NULL;

UPDATE pluto a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist2, '/', 2)=b.zonedist
AND a.commfar IS NULL;

UPDATE pluto a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist2, '/', 2)=b.zonedist
AND a.facilfar IS NULL;

-- base on zoning district 3
UPDATE pluto a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist3=b.zonedist
AND a.residfar IS NULL;

UPDATE pluto a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist3=b.zonedist
AND a.commfar IS NULL;

UPDATE pluto a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist3=b.zonedist
AND a.facilfar IS NULL;

-- zoning district 3 with / first part 
UPDATE pluto a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist3, '/', 1)=b.zonedist
AND a.residfar IS NULL;

UPDATE pluto a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist3, '/', 1)=b.zonedist
AND a.commfar IS NULL;

UPDATE pluto a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist3, '/', 1)=b.zonedist
AND a.facilfar IS NULL;

-- zoning district 3 with / second part 
UPDATE pluto a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist3, '/', 2)=b.zonedist
AND a.residfar IS NULL;

UPDATE pluto a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist3, '/', 2)=b.zonedist
AND a.commfar IS NULL;

UPDATE pluto a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist3, '/', 2)=b.zonedist
AND a.facilfar IS NULL;

-- make NULLs zeros
UPDATE pluto a
SET residfar = 0
WHERE a.residfar IS NULL
OR a.residfar = '-';

UPDATE pluto a
SET commfar = 0
WHERE a.commfar IS NULL
OR a.commfar = '-';

UPDATE pluto a
SET facilfar = 0
WHERE a.facilfar IS NULL
OR a.facilfar = '-';

-- make values numeric
UPDATE pluto a
SET residfar = residfar::double precision;

UPDATE pluto a
SET commfar = commfar::double precision;

UPDATE pluto a
SET facilfar = facilfar::double precision;
