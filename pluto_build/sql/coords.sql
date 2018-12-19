-- calculate the x and y coordinates
WITH coords AS
(SELECT bbl, ST_Centroid(geom) as geom
	FROM pluto
	WHERE geom IS NOT NULL
)

UPDATE pluto a
SET ycoord = ST_Y(ST_Transform(b.geom, 2263)),
	xcoord = ST_X(ST_Transform(b.geom, 2263))
FROM coords b
WHERE a.bbl = b.bbl;