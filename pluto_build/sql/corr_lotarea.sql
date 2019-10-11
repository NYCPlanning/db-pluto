-- Where the lot area is zero but the geometry is not null
-- compute the lot area from the geometry in sq feet

-- Insert old and new values into tracking table
INSERT INTO pluto_input_corrections b
SELECT DISTINCT a.bbl, 
	'lotarea' as field, 
	a.lotarea as old_value, 
	round(ST_Area(ST_Transform(a.geom,2263)))::text as new_value
FROM pluto a
WHERE a.lotarea = '0' 
	AND a.geom IS NOT NULL
	AND a.bbl NOT IN (SELECT bbl FROM pluto_input_corrections WHERE field = 'lotarea');
	
-- Apply correction
UPDATE pluto
SET lotarea = round(ST_Area(ST_Transform(geom,2263)))::text,
	dcpedited = 't'
WHERE lotarea = '0' 
	AND geom IS NOT NULL;