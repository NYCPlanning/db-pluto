-- set the pluto map id based on the following criteria

-- 1 In PLUTO Data File and DOF Modified DTM Tax Block and Lot
-- Clipped to the Shoreline File.
-- 2 In PLUTO Data File Only.
-- 3 In DOF Modified DTM Tax Block and Lot Clipped to the
-- Shoreline File but NOT in PLUTO.
-- 4 In PLUTO Data File and in DOF Modified DTM File but NOT in
-- DOF Modified DTM Tax Block and Lot Clipped to the Shoreline
-- File, therefore the tax lot is totally under water.
-- 5 In DOF Modified DTM but NOT in PLUTO, therefore the tax lot
-- is totally under water.

-- create index on pluto and shoreline file
DROP INDEX pluto_gix;
DROP INDEX dof_shoreline_union_gix;
CREATE INDEX pluto_gix ON pluto USING GIST (geom);
CREATE INDEX dof_shoreline_union_gix ON dof_shoreline_union USING GIST (geom);

-- set the mappluto ID based on the critera above
-- values can overwrite each other
UPDATE pluto
SET plutomapid = '1'
WHERE appbbl IS NOT NULL
AND geom IS NOT NULL;

UPDATE pluto
SET plutomapid = '2'
WHERE appbbl IS NOT NULL
AND geom IS NULL;

UPDATE pluto
SET plutomapid = '3'
WHERE appbbl IS NULL
AND geom IS NOT NULL;

UPDATE pluto a
SET plutomapid = '4'
FROM dof_shoreline_union b
WHERE appbbl IS NOT NULL
AND a.geom IS NOT NULL
AND ST_Within(a.geom, b.geom);

UPDATE pluto a
SET plutomapid = '5'
FROM dof_shoreline_union b
WHERE a.appbbl IS NULL
AND a.geom IS NOT NULL
AND ST_Within(a.geom, b.geom);

SELECT COUNT(a.*) FROM pluto a, dof_shoreline_union b WHERE ST_Within(a.geom, b.geom) 