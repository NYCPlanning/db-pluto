-- set the geometry type to be multipolygon
UPDATE pluto
SET geom=ST_Multi(geom)
WHERE ST_GeometryType(geom) = 'ST_Polygon';