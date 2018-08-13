-- create mappluto file
CREATE TABLE mappluto_clipped AS (
	SELECT * FROM pluto_rpad_geo
	WHERE geom IS NOT NULL);

-- clip mappluto to shoreline
UPDATE mappluto_clipped a
SET geom = ST_Intersection(a.geom, b.geom)
FROM pluto_shoreline b;