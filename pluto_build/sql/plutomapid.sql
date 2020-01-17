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

-- set the mappluto ID based on the critera above
-- values can overwrite each other
UPDATE pluto
SET plutomapid = '1'
WHERE geom IS NOT NULL
AND plutomapid IS NULL;

UPDATE pluto
SET plutomapid = '2'
WHERE geom IS NULL;

-- UPDATE pluto
-- SET plutomapid = '3'
-- WHERE appbbl IS NULL
-- AND geom IS NOT NULL;

-- UPDATE pluto a
-- SET plutomapid = '4'
-- FROM dof_shoreline_union b
-- WHERE a.geom IS NOT NULL
-- AND ST_Within(a.geom, b.geom)
-- AND plutomapid = '1';

-- UPDATE pluto a
-- SET plutomapid = '5'
-- FROM dof_shoreline_union b
-- WHERE a.geom IS NOT NULL
-- AND ST_Within(a.geom, b.geom)
-- AND plutomapid = '3';

DROP TABLE IF EXISTS dof_shoreline_subdivide;
CREATE TABLE dof_shoreline_subdivide as (
     select ST_SubDivide(ST_MakeValid(geom), 10) as geom
    from dof_shoreline_union);
DROP INDEX IF EXISTS shore_subdivide_idx;
CREATE INDEX shore_subdivide_idx on dof_shoreline_subdivide USING GIST(geom);
ALTER TABLE dof_shoreline_subdivide SET (parallel_workers=10);

WITH 
pluto_shore_intersection as (
	select a.bbl as bbl, a.geom as pluto_geom, b.geom as geom
	from pluto a, dof_shoreline_subdivide b
	where a.plutomapid = '1' 
        and a.geom IS NOT NULL
        and a.geom&&ST_MakeValid(b.geom) 
        and ST_intersects(a.geom, ST_MakeValid(b.geom))),
new_shoreline as (
    select st_union(geom) as geom
    from pluto_shore_intersection),
pluto_within as (
	select a.bbl as bbl, a.pluto_geom as geom 
	from pluto_shore_intersection a, new_shoreline b
	where ST_within(a.pluto_geom, b.geom))
UPDATE pluto a
SET plutomapid = '4'
FROM pluto_within b
WHERE a.bbl = b.bbl;

WITH 
pluto_shore_intersection as (
	select a.bbl as bbl, a.geom as pluto_geom, b.geom as geom
	from pluto a, dof_shoreline_subdivide b
	where a.plutomapid = '3' 
        and a.geom IS NOT NULL
        and a.geom&&ST_MakeValid(b.geom) 
        and ST_intersects(a.geom, ST_MakeValid(b.geom))),
new_shoreline as (
    select st_union(geom) as geom
    from pluto_shore_intersection),
pluto_within as (
	select a.bbl as bbl, a.pluto_geom as geom 
	from pluto_shore_intersection a, new_shoreline b
	where ST_within(a.pluto_geom, b.geom))
UPDATE pluto a
SET plutomapid = '5'
FROM pluto_within b
WHERE a.bbl = b.bbl;