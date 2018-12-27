-- create mappluto file
DROP TABLE IF EXISTS dof_shoreline_union;
CREATE TABLE dof_shoreline_union AS
SELECT ST_Union(geom) as geom
FROM dof_shoreline;

-- DROP TABLE IF EXISTS mappluto_clipped;
-- CREATE TABLE mappluto_clipped AS (
-- 	SELECT * FROM pluto
-- 	WHERE geom IS NOT NULL);

-- -- clip mappluto to shoreline
-- UPDATE mappluto_clipped a
-- SET geom = ST_Difference(a.geom, b.geom)
-- FROM dof_shoreline b
-- WHERE a.geom && b.geom;