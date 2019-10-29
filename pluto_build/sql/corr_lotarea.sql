-- Where the lot area is zero but the geometry is not null
-- compute the lot area from the geometry in sq feet

-- Insert old and new values into tracking table
INSERT INTO pluto_corrections
SELECT DISTINCT a.bbl, 
	'lotarea' as field, 
	a.lotarea as old_value, 
	round(ST_Area(ST_Transform(a.geom,2263)))::text as new_value
FROM pluto a
WHERE a.lotarea = '0' 
	AND a.geom IS NOT NULL
	AND a.bbl NOT IN (SELECT bbl FROM pluto_corrections WHERE field = 'lotarea');
	
-- Apply correction
UPDATE pluto a
SET lotarea = b.new_value,
	dcpedited = 't'
FROM pluto_corrections b
WHERE a.bbl = b.bbl
	AND b.field = 'lotarea'
	AND a.lotarea = '0' 
	AND a.geom IS NOT NULL;
	
-- recalculate builtfar
UPDATE pluto
SET builtfar = round(bldgarea::numeric / lotarea::numeric, 2)
WHERE lotarea <> '0' AND lotarea IS NOT NULL
AND bbl IN (SELECT bbl FROM pluto_corrections WHERE field = 'lotarea');