-- Replace X/Y and Lat/Long fields that are NULL with Lot Centroids
-- Update Xcoord, Ycoord, lat, long, and centroid fields
-- delete the temporary table after using
SELECT bbl, centroid, point_surface,
        _ST_CONTAINS(geom, ST_SetSRID(centroid ,4326)) as contain
INTO update_table
FROM(SELECT p.bbl as bbl, p.geom as geom, ST_Centroid(p.geom) as centroid, 
	 		ST_PointOnSurface(p.geom) as point_surface
	 FROM pluto p) as tmp;

-- if the centroid locates in the polygon, then update five fields: x/y, long/lat and centroid  
UPDATE pluto b
SET xcoord = CAST(ST_X(ST_Transform(t.centroid ,2263)) AS INTEGER),
	ycoord = CAST(ST_Y(ST_Transform(t.centroid ,2263)) AS INTEGER),
	longitude = ST_X(t.centroid),
	latitude = ST_Y(t.centroid),
	centroid = ST_SetSRID(t.centroid,4326)
FROM update_table as t
WHERE b.xcoord is NULL and b.bbl = t.bbl and t.contain is TRUE;

-- if the centroid does not locate in the polygon, do not update centroid field
-- use the point on surface instead
UPDATE pluto b
SET xcoord = CAST(ST_X(ST_Transform(t.point_surface ,2263)) AS INTEGER),
	ycoord = CAST(ST_Y(ST_Transform(t.point_surface ,2263)) AS INTEGER),
	longitude = ST_X(t.point_surface),
	latitude = ST_Y(t.point_surface)
FROM update_table as t
WHERE b.xcoord is NULL and b.bbl = t.bbl and t.contain is FALSE;

DROP TABLE IF EXISTS update_table;