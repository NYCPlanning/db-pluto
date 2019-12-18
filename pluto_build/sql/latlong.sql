-- populate the lat and long fields
UPDATE pluto a
SET latitude = ST_Y(ST_Transform(ST_SetSRID(ST_MakePoint(a.xcoord::double precision,a.ycoord::double precision),2263), 4326)),
	longitude = ST_X(ST_Transform(ST_SetSRID(ST_MakePoint(a.xcoord::double precision,a.ycoord::double precision),2263), 4326))
WHERE a.xcoord IS NOT NULL;