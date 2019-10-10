-- Where the lot area is zero but the geometry is not null
-- compute the lot area from the geometry in sq feet
UPDATE pluto
SET lotarea = round(ST_Area(ST_Transform(geom,2263)))::text,
	dcpedited = 't'
WHERE lotarea = '0' 
	AND geom IS NOT NULL;