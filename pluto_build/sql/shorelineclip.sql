-- create mappluto file
DROP TABLE IF EXISTS dof_shoreline_union;
CREATE TABLE dof_shoreline_union AS
SELECT ST_Union(wkb_geometry) as wkb_geometry
FROM dof_shoreline;

-- DROP TABLE IF EXISTS mappluto_clipped;
-- CREATE TABLE mappluto_clipped AS (
-- 	SELECT * FROM pluto
-- 	WHERE wkb_geometry IS NOT NULL);

-- -- clip mappluto to shoreline -- really slow
-- UPDATE mappluto_clipped a
-- SET wkb_geometry = ST_Difference(a.wkb_geometry, b.wkb_geometry)
-- FROM dof_shoreline b
-- WHERE a.wkb_geometry && b.wkb_geometry;