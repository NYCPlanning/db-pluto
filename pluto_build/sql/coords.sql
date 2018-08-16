-- calculate the x and y coordinates
WITH coords AS
(SELECT bbl, ST_Centroid(geom) as geom
	FROM pluto
	WHERE geom IS NOT NULL
)

UPDATE pluto a
SET xcoord = ST_X(b.geom),
	ycoord = ST_Y(b.geom)
FROM coords b
WHERE a.bbl = b.bbl;