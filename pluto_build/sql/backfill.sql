-- # Update lot area with lot area value from 18v2.1
ALTER TABLE dcp_mappluto 
RENAME COLUMN wkb_geometry TO geom;

UPDATE pluto a
SET lotarea = b.lotarea
FROM dcp_mappluto b
WHERE a.bbl=b.bbl::bigint::text
AND a.lotarea = '0'
AND b.lotarea <> 0
AND (((ST_Area(ST_Transform(a.geom,2263))::numeric - ST_Area(ST_Transform(b.geom,2263))::numeric) / ST_Area(ST_Transform(b.geom,2263))::numeric) < 5 
	AND  ((ST_Area(ST_Transform(a.geom,2263))::numeric - ST_Area(ST_Transform(b.geom,2263))::numeric) / ST_Area(ST_Transform(b.geom,2263))::numeric) > -5);

-- # Update lotfront and lotdepth from 18v2.1
UPDATE pluto a
SET lotfront = b.lotfront,
	lotdepth = b.lotdepth
FROM dcp_mappluto b
WHERE a.bbl=b.bbl::bigint::text
AND a.lotfront::numeric = 0
AND a.lotdepth::numeric = 0
AND (b.lotfront::numeric > 0 OR b.lotdepth > 0)
AND a.lotarea::numeric = b.lotarea::numeric;

-- # Update bldgfront and bldgdepth from 18v2.1
UPDATE pluto a
SET bldgfront = b.bldgfront,
	bldgdepth = b.bldgdepth
FROM dcp_mappluto b
WHERE a.bbl=b.bbl::bigint::text
AND a.bldgfront::numeric = 0
AND a.bldgdepth::numeric = 0
AND (b.bldgfront::numeric > 0 OR b.bldgdepth::numeric > 0)
AND a.yearbuilt::numeric = b.yearbuilt::numeric
AND a.lotfront::numeric = b.lotfront::numeric
AND a.lotdepth::numeric = b.lotdepth::numeric;

-- # Recalculate lot area
UPDATE pluto
SET builtfar = round(bldgarea::numeric / lotarea::numeric, 2)
WHERE lotarea <> '0' AND lotarea IS NOT NULL;

-- # Update irrlotcode from 18v2.1
UPDATE pluto a
SET irrlotcode = b.irrlotcode
FROM dcp_mappluto b
WHERE a.bbl=b.bbl::bigint::text
AND a.lotfront::numeric = b.lotfront::numeric
AND a.lotdepth::numeric = b.lotdepth::numeric
AND b.irrlotcode = 'Y';

-- # Set year fileds to 0 where year < 1600
UPDATE pluto a
SET yearbuilt = 0
WHERE yearbuilt::numeric < 1600;

UPDATE pluto a
SET yearalter1 = 0
WHERE yearalter1::numeric < 1600;

UPDATE pluto a
SET yearalter2 = 0
WHERE yearalter2::numeric < 1600;

-- # Take zipcode from 18v2.1
UPDATE pluto a
SET zipcode = b.zipcode
FROM dcp_mappluto b
WHERE a.bbl=b.bbl::bigint::text
AND length(b.zipcode::text) = 5
AND a.zipcode IS NULL;

UPDATE pluto a
SET zipcode = b.zipcode
FROM dcp_mappluto b
WHERE a.bbl=b.bbl::bigint::text
AND (a.zipcode::numeric<>b.zipcode::numeric)
AND length(b.zipcode::text) = 5;

-- # Drop column
ALTER TABLE pluto
DROP COLUMN mappluto_f;

-- # Create table where areas were updated based on 18v2.1 values
-- DROP TABLE IF EXISTS pluto_backfill;
-- CREATE TABLE pluto_backfill AS (
-- SELECT a.bbl, a.lotarea, b.lotarea as lotareaprev, c.lotarea as lotarea18v21, a.lotfront, b.lotfront as lotfrontprev, c.lotfront as lotfront18v21, a.lotdepth, b.lotdepth as lotdepthprev, c.lotdepth as lotdepth18v21, a.bldgfront, b.bldgfront as bldgfrontprev, c.bldgfront as bldgfront18v21, a.bldgdepth, b.bldgdepth as bldgdepthprev, c.bldgdepth as bldgdepth18v21, a.builtfar
-- FROM pluto a, pluto_19v1backup b, dcp_mappluto c
-- WHERE a.bbl=b.bbl AND a.bbl||'.00'=c.bbl::text
-- AND((a.lotarea::numeric > 0 AND b.lotarea::numeric = 0)
-- OR (a.lotfront::numeric > 0 AND b.lotfront::numeric = 0)
-- OR (a.lotdepth::numeric > 0 AND b.lotdepth::numeric = 0)
-- OR (a.bldgfront::numeric > 0 AND b.bldgfront::numeric = 0)
-- OR (a.bldgdepth::numeric > 0 AND b.bldgdepth::numeric = 0)
-- ));

-- \copy (SELECT * FROM pluto_backfill18v21) TO '/prod/db-pluto/pluto_build/output/pluto_backfill18v21.csv' DELIMITER ',' CSV HEADER;