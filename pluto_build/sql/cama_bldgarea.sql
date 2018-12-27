-- fill in area for each use from CAMA
UPDATE pluto a
SET comarea = b.commercialarea,
	resarea = b.residarea,
	officearea = b.officearea,
	retailarea = b.retailarea,
	garagearea = b.garagearea,
	strgearea = b.storagearea,
	factryarea = b.factoryarea,
	otherarea = b.otherarea
FROM pluto_input_cama_dof b
WHERE a.bbl=b.boro||b.block||b.lot
AND b.bldgnum = '1';

-- assign an area source to records that aready have bldgarea from RPAD
UPDATE pluto a
SET areasource = '2'
WHERE bldgarea::numeric <> 0 AND bldgarea IS NOT NULL;

-- populate bldgarea from CAMA data
UPDATE pluto a
SET bldgarea = b.grossarea,
areasource = '7'
FROM pluto_input_cama_dof b
WHERE a.bbl=b.boro||b.block||b.lot
AND (bldgarea::numeric = 0 OR bldgarea IS NULL);

-- calcualte bldgarea by multiplying bldgfront x bldgdepth
-- set area source to 5
UPDATE pluto a
SET bldgarea = a.bldgfront::numeric*a.bldgdepth::numeric,
areasource = '5'
WHERE (a.bldgarea::numeric = 0 OR a.bldgarea IS NULL)
AND a.bldgfront::numeric <> 0
AND a.areasource IS NULL;

-- set area source to 4 for vacant lots
-- for vacant lots and number of buildings is 0 and building floor area is 0
UPDATE pluto a
SET areasource = '4'
WHERE areasource IS NULL
	AND landuse = '11'
	AND numbldgs::numeric = 0
	AND (bldgarea::numeric = 0 OR bldgarea IS NULL);

-- set area source to 0 where building area is not avialble because it's still 0 or null
UPDATE pluto a
SET areasource = '0'
WHERE a.areasource IS NULL
AND (bldgarea::numeric = 0 OR bldgarea IS NULL);