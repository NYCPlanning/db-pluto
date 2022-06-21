-- Replace X/Y and Lat/Long fields that are NULL with Lot Centroids
-- Update Xcoord, Ycoord, lat, long, and centroid fields
UPDATE pluto b
SET xcoord = tmp.new_x,
	ycoord = tmp.new_y,
	longitude = tmp.lon,
	latitude = tmp.lat,
	centroid = tmp.centroid
FROM (
	WITH Centroids AS 
	(SELECT p.bbl as bbl, 
	 g.geom_4326 as geom, 
	 ST_X(ST_Centroid(g.geom_4326)) as lon, 
	 ST_Y(ST_Centroid(g.geom_4326)) as lat
	FROM pluto as p, pluto_geom as g
	WHERE p.xcoord is NULL and p.bbl = g.bbl)
    SELECT bbl, lon,lat,
	CAST(ST_X(ST_Transform(ST_SetSRID(ST_MakePoint(lon,lat),4326),2263)) AS INTEGER) as new_x,
	CAST(ST_Y(ST_Transform(ST_SetSRID(ST_MakePoint(lon,lat),4326),2263)) AS INTEGER) as new_y,
	ST_SetSRID(ST_MakePoint(lon,lat),4326) as centroid,
	_ST_CONTAINS(geom, ST_SetSRID(ST_POINT(lon,lat),4326)) as contain
	FROM Centroids
) AS tmp
WHERE b.bbl=tmp.bbl and b.xcoord is NULL and tmp.contain is TRUE