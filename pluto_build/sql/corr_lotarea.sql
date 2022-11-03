-- Where the lot area is zero but the geometry is not null
-- compute the lot area from the geometry in sq feet

-- Insert old and new values into tracking table
INSERT INTO pluto_corrections
SELECT DISTINCT 
	a.bbl as bbl, 
	'lotarea' as field, 
	a.lotarea as old_value, 
	round(ST_Area(ST_Transform(a.geom,2263)))::text as new_value,
	'1' as type,
	'Zero lot area' as reason,
	a.version as version
FROM pluto a
WHERE a.lotarea = '0' 
	AND a.geom IS NOT NULL
	AND a.bbl NOT IN (SELECT bbl FROM pluto_corrections WHERE field = 'lotarea');

-- -- Redundant code	
-- -- Apply correction
-- UPDATE pluto a
-- SET lotarea = b.new_value,
-- 	dcpedited = 't'
-- FROM pluto_corrections b
-- WHERE a.bbl = b.bbl
-- 	AND b.field = 'lotarea'
-- 	AND a.lotarea = '0' 
-- 	AND a.geom IS NOT NULL;

-- Take researched lot area values from the research table
INSERT INTO pluto_corrections
SELECT DISTINCT a.bbl, 
	'lotarea' as field, 
	a.lotarea as old_value, 
	b.new_value as new_value,
	b.type as type,
	b.reason as reason,
	b.version as version
FROM pluto a, pluto_input_research b
WHERE a.bbl = b.bbl
	AND a.lotarea::numeric=b.old_value::numeric
	AND b.field = 'lotarea'
	AND a.bbl NOT IN (SELECT bbl FROM pluto_corrections WHERE field = 'lotarea');

INSERT INTO pluto_corrections_not_applied
SELECT DISTINCT b.*
FROM pluto_corrections b, pluto a
WHERE b.bbl=a.bbl 
	AND b.field='lotarea' 
	AND b.old_value::numeric <> a.lotarea::numeric;

INSERT INTO pluto_corrections_applied
SELECT DISTINCT b.*
FROM pluto_corrections b, pluto a
WHERE b.bbl=a.bbl 
	AND b.field='lotarea' 
	AND b.old_value::numeric=a.lotarea::numeric;

-- Apply correction to PLUTO
UPDATE pluto a
SET lotarea = b.new_value,
	dcpedited = 't'
FROM pluto_corrections b
WHERE a.bbl = b.bbl
	AND b.field = 'lotarea'
	AND a.lotarea::numeric=b.old_value::numeric;

-- Take researched building area values from the research table
INSERT INTO pluto_corrections
SELECT DISTINCT a.bbl, 
	'bldgarea' as field, 
	a.bldgarea as old_value, 
	b.new_value as new_value,
	b.type as type,
	b.reason as reason,
	b.version as version
FROM pluto a, pluto_input_research b
WHERE a.bbl = b.bbl
	AND a.bldgarea::numeric=b.old_value::numeric
	AND b.field = 'bldgarea'
	AND a.bbl NOT IN (SELECT bbl FROM pluto_corrections WHERE field = 'bldgarea');

INSERT INTO pluto_corrections_not_applied
SELECT DISTINCT b.*
FROM pluto_corrections b, pluto a
WHERE b.bbl=a.bbl 
	AND b.field='bldgarea' 
	AND b.old_value::numeric <> a.bldgarea::numeric;

INSERT INTO pluto_corrections_applied
SELECT DISTINCT b.*
FROM pluto_corrections b, pluto a
WHERE b.bbl=a.bbl 
	AND b.field='bldgarea' 
	AND b.old_value::numeric=a.bldgarea::numeric;

-- Apply correction to PLUTO
UPDATE pluto a
SET bldgarea = b.new_value,
	dcpedited = 't'
FROM pluto_corrections b
WHERE a.bbl = b.bbl
	AND b.field = 'bldgarea'
	AND a.bldgarea::numeric=b.old_value::numeric;

-- recalculate builtfar
UPDATE pluto
SET builtfar = round(bldgarea::numeric / lotarea::numeric, 2)
WHERE lotarea <> '0' AND lotarea IS NOT NULL
AND bbl IN (SELECT bbl FROM pluto_corrections WHERE field = 'lotarea' OR field = 'bldgarea');