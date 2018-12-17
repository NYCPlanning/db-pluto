-- create dtm from mappluto
DROP TABLE IF EXISTS dof_dtm;
CREATE TABLE dof_dtm AS (
	SELECT bbl::text, borocode::text AS boro, block::text, lot::text, geom
	FROM dcp_mappluto);

-- create dcp_zoning_maxfar with old FAR values
DROP TABLE IF EXISTS dcp_zoning_maxfar;
CREATE TABLE dcp_zoning_maxfar AS (
	WITH resid as (
		SELECT DISTINCT zonedist1, residfar
		FROM dcp_mappluto
		GROUP BY zonedist1, residfar 
		ORDER BY zonedist1, residfar),
		comm as (
		SELECT DISTINCT zonedist1, commfar
		FROM dcp_mappluto
		GROUP BY zonedist1, commfar 
		ORDER BY zonedist1, commfar),
		facil as (
		SELECT DISTINCT zonedist1, facilfar
		FROM dcp_mappluto
		GROUP BY zonedist1, facilfar 
		ORDER BY zonedist1, facilfar)
		SELECT a.zonedist1 as zonedist, a.residfar, b.commfar, c.facilfar
		FROM resid a
		JOIN comm b
		ON a.zonedist1=b.zonedist1
		JOIN facil c
		ON a.zonedist1=c.zonedist1);

-- update mappluto
DROP TABLE IF EXISTS dcp_mappluto_18v11;
CREATE TABLE dcp_mappluto_18v11 AS (
SELECT * FROM dcp_mappluto);
-- correcting the land use error
UPDATE dcp_mappluto_18v11
SET landuse = '04'
WHERE bldgclass = 'C7';

UPDATE dcp_mappluto_18v11
SET zonedist1 = NULL,
	zonedist2 = NULL,
	zonedist3 = NULL,
	zonedist4 = NULL,
	overlay1 = NULL,
	overlay2 = NULL,
	spdist1 = NULL,
	spdist2 = NULL,
	spdist3 = NULL,
	ltdheight = NULL,
	splitzone = NULL,
	zonemap = NULL,
	zmcode = NULL,
	residfar = NULL,
	commfar = NULL,
	facilfar = NULL;

alter table dcp_mappluto_18v11 ALTER COLUMN zonedist1 TYPE text;
alter table dcp_mappluto_18v11 ALTER COLUMN zonedist2 TYPE text;
alter table dcp_mappluto_18v11 ALTER COLUMN zonedist3 TYPE text;
alter table dcp_mappluto_18v11 ALTER COLUMN zonedist4 TYPE text;
alter table dcp_mappluto_18v11 ALTER COLUMN commercialoverlay1 TYPE text;
alter table dcp_mappluto_18v11 ALTER COLUMN commercialoverlay2 TYPE text;
alter table dcp_mappluto_18v11 ALTER COLUMN spdist1 TYPE text;
alter table dcp_mappluto_18v11 ALTER COLUMN spdist2 TYPE text;
alter table dcp_mappluto_18v11 ALTER COLUMN spdist3 TYPE text;
alter table dcp_mappluto_18v11 ALTER COLUMN ltdheight TYPE text;
alter table dcp_mappluto_18v11 ALTER COLUMN zonemap TYPE text;
alter table dcp_mappluto_18v11 ALTER COLUMN zmcode TYPE text;

alter table dcp_mappluto_18v11 ALTER COLUMN residfar TYPE text;
alter table dcp_mappluto_18v11 ALTER COLUMN commfar TYPE text;
alter table dcp_mappluto_18v11 ALTER COLUMN facilfar TYPE text;

alter table dcp_mappluto_18v11 ALTER COLUMN version TYPE text;
-- join on bbl
UPDATE dcp_mappluto_18v11 a
SET zonedist1 = b.zoningdistrict1,
	zonedist2 = b.zoningdistrict2,
	zonedist3 = b.zoningdistrict3,
	zonedist4 = b.zoningdistrict4,
	overlay1 = b.commercialoverlay1,
	overlay2 = b.commercialoverlay2,
	spdist1 = b.specialdistrict1,
	spdist2 = b.specialdistrict2,
	spdist3 = b.specialdistrict3,
	ltdheight = b.limitedheightdistrict,
	zonemap = b.zoningmapnumber,
	zmcode = b.zoningmapcode
FROM dcp_zoning_taxlot b
WHERE b.bbl=a.bbl::text;
-- join on appbbl
UPDATE dcp_mappluto_18v11 a
SET zonedist1 = b.zoningdistrict1,
	zonedist2 = b.zoningdistrict2,
	zonedist3 = b.zoningdistrict3,
	zonedist4 = b.zoningdistrict4,
	overlay1 = b.commercialoverlay1,
	overlay2 = b.commercialoverlay2,
	spdist1 = b.specialdistrict1,
	spdist2 = b.specialdistrict2,
	spdist3 = b.specialdistrict3,
	ltdheight = b.limitedheightdistrict,
	zonemap = b.zoningmapnumber,
	zmcode = b.zoningmapcode
FROM dcp_zoning_taxlot b
WHERE b.bbl=a.appbbl::text
AND zonedist1 IS NULL;
-- assign PARK to properties owned by DPR
UPDATE dcp_mappluto_18v11 a
SET zonedist1 = 'PARK'
WHERE upper(ownername) LIKE '%NYC%PARKS%'
AND zonedist1 IS NULL;
-- calculate the split zones
UPDATE dcp_mappluto_18v11 
SET splitzone = 'Y'
WHERE zonedist1 IS NOT NULL
AND (zonedist2 IS NOT NULL 
	OR overlay1 IS NOT NULL 
	OR spdist1 IS NOT NULL);

UPDATE dcp_mappluto_18v11 
SET splitzone = 'Y'
WHERE overlay1 IS NOT NULL
AND (zonedist1 IS NOT NULL 
	OR overlay2 IS NOT NULL 
	OR spdist1 IS NOT NULL)
AND splitzone IS NULL;

UPDATE dcp_mappluto_18v11 
SET splitzone = 'Y'
WHERE spdist1 IS NOT NULL
AND (zonedist1 IS NOT NULL 
	OR overlay1 IS NOT NULL 
	OR spdist2 IS NOT NULL)
AND splitzone IS NULL;

UPDATE dcp_mappluto_18v11 
SET splitzone = 'N'
WHERE splitzone IS NULL AND zonedist1 IS NOT NULL;
-- if the zoning information didn't change
-- assign the FAR values from the current PLUTO
UPDATE dcp_mappluto_18v11 a
SET residfar = b.residfar,
	commfar = b.commfar,
	facilfar = b.facilfar
FROM dcp_mappluto b
WHERE b.bbl::text=a.bbl::text
AND a.zonedist1=b.zonedist1;

-- running far.sql
-- using dcp_zoning_maxfar maintained by zoning division
-- base on zoning district 1
UPDATE dcp_mappluto_18v11 a
SET residfar = b.residfar,
	commfar = b.commfar,
	facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist1=b.zonedist
AND a.residfar IS NULL;
-- zoning district 1 with / first part 
UPDATE dcp_mappluto_18v11 a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist1, '/', 1)=b.zonedist
AND a.residfar IS NULL;
UPDATE dcp_mappluto_18v11 a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist1, '/', 1)=b.zonedist
AND a.commfar IS NULL;
UPDATE dcp_mappluto_18v11 a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist1, '/', 1)=b.zonedist
AND a.facilfar IS NULL;
-- zoning district 1 with / second part 
UPDATE dcp_mappluto_18v11 a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist1, '/', 2)=b.zonedist
AND a.residfar IS NULL;
UPDATE dcp_mappluto_18v11 a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist1, '/', 2)=b.zonedist
AND a.commfar IS NULL;
UPDATE dcp_mappluto_18v11 a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist1, '/', 2)=b.zonedist
AND a.facilfar IS NULL;

-- base on zoning district 2
UPDATE dcp_mappluto_18v11 a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist2=b.zonedist
AND a.residfar IS NULL;
UPDATE dcp_mappluto_18v11 a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist2=b.zonedist
AND a.commfar IS NULL;
UPDATE dcp_mappluto_18v11 a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist2=b.zonedist
AND a.facilfar IS NULL;
-- zoning district 2 with / first part 
UPDATE dcp_mappluto_18v11 a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist2, '/', 1)=b.zonedist
AND a.residfar IS NULL;
UPDATE dcp_mappluto_18v11 a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist2, '/', 1)=b.zonedist
AND a.commfar IS NULL;
UPDATE dcp_mappluto_18v11 a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist2, '/', 1)=b.zonedist
AND a.facilfar IS NULL;
-- zoning district 2 with / second part 
UPDATE dcp_mappluto_18v11 a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist2, '/', 2)=b.zonedist
AND a.residfar IS NULL;
UPDATE dcp_mappluto_18v11 a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist2, '/', 2)=b.zonedist
AND a.commfar IS NULL;
UPDATE dcp_mappluto_18v11 a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist2, '/', 2)=b.zonedist
AND a.facilfar IS NULL;

-- base on zoning district 3
UPDATE dcp_mappluto_18v11 a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist3=b.zonedist
AND a.residfar IS NULL;
UPDATE dcp_mappluto_18v11 a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist3=b.zonedist
AND a.commfar IS NULL;
UPDATE dcp_mappluto_18v11 a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist3=b.zonedist
AND a.facilfar IS NULL;
-- zoning district 3 with / first part 
UPDATE dcp_mappluto_18v11 a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist3, '/', 1)=b.zonedist
AND a.residfar IS NULL;
UPDATE dcp_mappluto_18v11 a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist3, '/', 1)=b.zonedist
AND a.commfar IS NULL;
UPDATE dcp_mappluto_18v11 a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist3, '/', 1)=b.zonedist
AND a.facilfar IS NULL;
-- zoning district 3 with / second part 
UPDATE dcp_mappluto_18v11 a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist3, '/', 2)=b.zonedist
AND a.residfar IS NULL;
UPDATE dcp_mappluto_18v11 a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist3, '/', 2)=b.zonedist
AND a.commfar IS NULL;
UPDATE dcp_mappluto_18v11 a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist3, '/', 2)=b.zonedist
AND a.facilfar IS NULL;

-- make NULLs zeros
UPDATE dcp_mappluto_18v11 a
SET residfar = 0
WHERE a.residfar IS NULL
OR a.residfar = '-';
UPDATE dcp_mappluto_18v11 a
SET commfar = 0
WHERE a.commfar IS NULL
OR a.commfar = '-';
UPDATE dcp_mappluto_18v11 a
SET facilfar = 0
WHERE a.facilfar IS NULL
OR a.facilfar = '-';
--
UPDATE dcp_mappluto_18v11
SET version = '18V1.1';

\copy (SELECT * FROM dcp_mappluto_18v11) TO '/prod/db-pluto/pluto_build/output/dcp_mappluto_18v11.csv' DELIMITER ',' CSV HEADER;

-- update pluto
DROP TABLE IF EXISTS dcp_pluto_18v11;
CREATE TABLE dcp_pluto_18v11 AS (
SELECT * FROM dcp_pluto);
-- correcting the land use error
UPDATE dcp_pluto_18v11
SET landuse = '04'
WHERE bldgclass = 'C7';

UPDATE dcp_pluto_18v11
SET zonedist1 = NULL,
	zonedist2 = NULL,
	zonedist3 = NULL,
	zonedist4 = NULL,
	overlay1 = NULL,
	overlay2 = NULL,
	spdist1 = NULL,
	spdist2 = NULL,
	spdist3 = NULL,
	ltdheight = NULL,
	splitzone = NULL,
	zonemap = NULL,
	zmcode = NULL,
	residfar = NULL,
	commfar = NULL,
	facilfar = NULL;

alter table dcp_pluto_18v11 ALTER COLUMN zonedist1 TYPE text;
alter table dcp_pluto_18v11 ALTER COLUMN zonedist2 TYPE text;
alter table dcp_pluto_18v11 ALTER COLUMN zonedist3 TYPE text;
alter table dcp_pluto_18v11 ALTER COLUMN zonedist4 TYPE text;
alter table dcp_pluto_18v11 ALTER COLUMN commercialoverlay1 TYPE text;
alter table dcp_pluto_18v11 ALTER COLUMN commercialoverlay2 TYPE text;
alter table dcp_pluto_18v11 ALTER COLUMN spdist1 TYPE text;
alter table dcp_pluto_18v11 ALTER COLUMN spdist2 TYPE text;
alter table dcp_pluto_18v11 ALTER COLUMN spdist3 TYPE text;
alter table dcp_pluto_18v11 ALTER COLUMN ltdheight TYPE text;
alter table dcp_pluto_18v11 ALTER COLUMN zonemap TYPE text;
alter table dcp_pluto_18v11 ALTER COLUMN zmcode TYPE text;

alter table dcp_pluto_18v11 ALTER COLUMN residfar TYPE text;
alter table dcp_pluto_18v11 ALTER COLUMN commfar TYPE text;
alter table dcp_pluto_18v11 ALTER COLUMN facilfar TYPE text;

alter table dcp_pluto_18v11 ALTER COLUMN version TYPE text;
-- join on bbl
UPDATE dcp_pluto_18v11 a
SET zonedist1 = b.zoningdistrict1,
	zonedist2 = b.zoningdistrict2,
	zonedist3 = b.zoningdistrict3,
	zonedist4 = b.zoningdistrict4,
	overlay1 = b.commercialoverlay1,
	overlay2 = b.commercialoverlay2,
	spdist1 = b.specialdistrict1,
	spdist2 = b.specialdistrict2,
	spdist3 = b.specialdistrict3,
	ltdheight = b.limitedheightdistrict,
	zonemap = b.zoningmapnumber,
	zmcode = b.zoningmapcode
FROM dcp_zoning_taxlot b
WHERE b.bbl=a.bbl||'.00'::text;
-- join on appbbl
UPDATE dcp_pluto_18v11 a
SET zonedist1 = b.zoningdistrict1,
	zonedist2 = b.zoningdistrict2,
	zonedist3 = b.zoningdistrict3,
	zonedist4 = b.zoningdistrict4,
	overlay1 = b.commercialoverlay1,
	overlay2 = b.commercialoverlay2,
	spdist1 = b.specialdistrict1,
	spdist2 = b.specialdistrict2,
	spdist3 = b.specialdistrict3,
	ltdheight = b.limitedheightdistrict,
	zonemap = b.zoningmapnumber,
	zmcode = b.zoningmapcode
FROM dcp_zoning_taxlot b
WHERE b.bbl=a.appbbl||'.00'::text
AND zonedist1 IS NULL;
-- assign PARK as zonedist1 where NYC Parks is the owner
UPDATE dcp_pluto_18v11 a
SET zonedist1 = 'PARK'
WHERE upper(ownername) LIKE '%NYC%PARKS%'
AND zonedist1 IS NULL;
-- calcualte the split zone field
UPDATE dcp_pluto_18v11 
SET splitzone = 'Y'
WHERE zonedist1 IS NOT NULL
AND (zonedist2 IS NOT NULL 
	OR overlay1 IS NOT NULL 
	OR spdist1 IS NOT NULL);

UPDATE dcp_pluto_18v11 
SET splitzone = 'Y'
WHERE overlay1 IS NOT NULL
AND (zonedist1 IS NOT NULL 
	OR overlay2 IS NOT NULL 
	OR spdist1 IS NOT NULL);

UPDATE dcp_pluto_18v11 
SET splitzone = 'Y'
WHERE spdist1 IS NOT NULL
AND (zonedist1 IS NOT NULL 
	OR overlay1 IS NOT NULL 
	OR spdist2 IS NOT NULL);

UPDATE dcp_pluto_18v11 
SET splitzone = 'N'
WHERE splitzone IS NULL AND zonedist1 IS NOT NULL;
-- if the zoning information didn't change
-- assign the FAR values from the current PLUTO
UPDATE dcp_pluto_18v11 a
SET residfar = b.residfar,
	commfar = b.commfar,
	facilfar = b.facilfar
FROM dcp_pluto b
WHERE b.bbl::text=a.bbl::text
AND a.zonedist1=b.zonedist1;
-- run far.sql
-- using dcp_zoning_maxfar maintained by zoning division
-- base on zoning district 1
UPDATE dcp_pluto_18v11 a
SET residfar = b.residfar,
	commfar = b.commfar,
	facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist1=b.zonedist
AND a.residfar IS NULL;
-- zoning district 1 with / first part 
UPDATE dcp_pluto_18v11 a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist1, '/', 1)=b.zonedist
AND a.residfar IS NULL;
UPDATE dcp_pluto_18v11 a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist1, '/', 1)=b.zonedist
AND a.commfar IS NULL;
UPDATE dcp_pluto_18v11 a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist1, '/', 1)=b.zonedist
AND a.facilfar IS NULL;
-- zoning district 1 with / second part 
UPDATE dcp_pluto_18v11 a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist1, '/', 2)=b.zonedist
AND a.residfar IS NULL;
UPDATE dcp_pluto_18v11 a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist1, '/', 2)=b.zonedist
AND a.commfar IS NULL;
UPDATE dcp_pluto_18v11 a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist1, '/', 2)=b.zonedist
AND a.facilfar IS NULL;

-- base on zoning district 2
UPDATE dcp_pluto_18v11 a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist2=b.zonedist
AND a.residfar IS NULL;
UPDATE dcp_pluto_18v11 a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist2=b.zonedist
AND a.commfar IS NULL;
UPDATE dcp_pluto_18v11 a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist2=b.zonedist
AND a.facilfar IS NULL;
-- zoning district 2 with / first part 
UPDATE dcp_pluto_18v11 a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist2, '/', 1)=b.zonedist
AND a.residfar IS NULL;
UPDATE dcp_pluto_18v11 a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist2, '/', 1)=b.zonedist
AND a.commfar IS NULL;
UPDATE dcp_pluto_18v11 a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist2, '/', 1)=b.zonedist
AND a.facilfar IS NULL;
-- zoning district 2 with / second part 
UPDATE dcp_pluto_18v11 a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist2, '/', 2)=b.zonedist
AND a.residfar IS NULL;
UPDATE dcp_pluto_18v11 a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist2, '/', 2)=b.zonedist
AND a.commfar IS NULL;
UPDATE dcp_pluto_18v11 a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist2, '/', 2)=b.zonedist
AND a.facilfar IS NULL;

-- base on zoning district 3
UPDATE dcp_pluto_18v11 a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist3=b.zonedist
AND a.residfar IS NULL;
UPDATE dcp_pluto_18v11 a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist3=b.zonedist
AND a.commfar IS NULL;
UPDATE dcp_pluto_18v11 a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE a.zonedist3=b.zonedist
AND a.facilfar IS NULL;
-- zoning district 3 with / first part 
UPDATE dcp_pluto_18v11 a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist3, '/', 1)=b.zonedist
AND a.residfar IS NULL;
UPDATE dcp_pluto_18v11 a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist3, '/', 1)=b.zonedist
AND a.commfar IS NULL;
UPDATE dcp_pluto_18v11 a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist3, '/', 1)=b.zonedist
AND a.facilfar IS NULL;
-- zoning district 3 with / second part 
UPDATE dcp_pluto_18v11 a
SET residfar = b.residfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist3, '/', 2)=b.zonedist
AND a.residfar IS NULL;
UPDATE dcp_pluto_18v11 a
SET commfar = b.commfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist3, '/', 2)=b.zonedist
AND a.commfar IS NULL;
UPDATE dcp_pluto_18v11 a
SET facilfar = b.facilfar
FROM dcp_zoning_maxfar b
WHERE split_part(a.zonedist3, '/', 2)=b.zonedist
AND a.facilfar IS NULL;

-- make NULLs zeros
UPDATE dcp_pluto_18v11 a
SET residfar = 0
WHERE a.residfar IS NULL
OR a.residfar = '-';
UPDATE dcp_pluto_18v11 a
SET commfar = 0
WHERE a.commfar IS NULL
OR a.commfar = '-';
UPDATE dcp_pluto_18v11 a
SET facilfar = 0
WHERE a.facilfar IS NULL
OR a.facilfar = '-';
--
UPDATE dcp_pluto_18v11
SET version = '18V1.1';

\copy (SELECT * FROM dcp_pluto_18v11) TO '/prod/db-pluto/pluto_build/output/dcp_pluto_18v11.csv' DELIMITER ',' CSV HEADER;
