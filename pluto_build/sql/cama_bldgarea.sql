-- fill in area for each use from PTS
UPDATE pluto a
SET comarea = (b.officearea::numeric+b.retailarea::numeric+b.garagearea::numeric+b.storagearea::numeric+b.factoryarea::numeric+b.otherarea::numeric),
	resarea = b.residarea,
	officearea = b.officearea,
	retailarea = b.retailarea,
	garagearea = b.garagearea,
	strgearea = b.storagearea,
	factryarea = b.factoryarea,
	otherarea = b.otherarea
FROM pluto_rpad_geo b
WHERE a.bbl=b.primebbl
AND a.lot NOT LIKE '75%'
AND (b.residarea::numeric > 0
	OR b.officearea::numeric > 0
	OR b.retailarea::numeric > 0
	OR b.garagearea::numeric > 0
	OR b.storagearea::numeric > 0
	OR b.factoryarea::numeric > 0
	OR b.otherarea::numeric > 0);

-- populate the fields that where values are aggregated
WITH primesums AS (
	SELECT primebbl,
	SUM(residarea::double precision) as residarea,
	SUM(officearea::double precision) as officearea,
	SUM(retailarea::double precision) as retailarea,
	SUM(garagearea::double precision) as garagearea,
	SUM(storagearea::double precision) as storagearea,
	SUM(factoryarea::double precision) as factoryarea,
	SUM(otherarea::double precision) as otherarea
	FROM pluto_rpad_geo
	WHERE 
	primebbl::numeric > 0
	GROUP BY primebbl)

UPDATE pluto a
SET comarea = (b.officearea::numeric+b.retailarea::numeric+b.garagearea::numeric+b.storagearea::numeric+b.factoryarea::numeric+b.otherarea::numeric),
	resarea = b.residarea,
	officearea = b.officearea,
	retailarea = b.retailarea,
	garagearea = b.garagearea,
	strgearea = b.storagearea,
	factryarea = b.factoryarea,
	otherarea = b.otherarea
FROM primesums b
WHERE a.bbl=b.primebbl
AND a.lot LIKE '75%'
AND (b.residarea::numeric > 0
	OR b.officearea::numeric > 0
	OR b.retailarea::numeric > 0
	OR b.garagearea::numeric > 0
	OR b.storagearea::numeric > 0
	OR b.factoryarea::numeric > 0
	OR b.otherarea::numeric > 0);

-- fill in area for each use from CAMA if not filled in from PTS
UPDATE pluto a
SET comarea = b.commercialarea,
	resarea = b.residarea,
	officearea = b.officearea,
	retailarea = b.retailarea,
	garagearea = b.garagearea,
	strgearea = b.storagearea,
	factryarea = b.factoryarea,
	otherarea = b.otherarea
FROM pluto_input_cama b
WHERE a.bbl=b.primebbl
AND b.bldgnum = '1'
AND a.lot NOT LIKE '75%'
AND (b.commercialarea::numeric > 0
	OR b.residarea::numeric > 0
	OR b.officearea::numeric > 0
	OR b.retailarea::numeric > 0
	OR b.garagearea::numeric > 0
	OR b.storagearea::numeric > 0
	OR b.factoryarea::numeric > 0
	OR b.otherarea::numeric > 0)
AND (a.comarea IS NULL
	AND a.resarea IS NULL
	AND a.officearea IS NULL
	AND a.retailarea IS NULL
	AND a.garagearea IS NULL
	AND a.strgearea IS NULL
	AND a.factryarea IS NULL
	AND a.otherarea IS NULL)
;

-- populate the fields that where values are aggregated
WITH primesums AS (
	SELECT billingbbl as primebbl,
	SUM(commercialarea::double precision) as commercialarea,
	SUM(residarea::double precision) as residarea,
	SUM(officearea::double precision) as officearea,
	SUM(retailarea::double precision) as retailarea,
	SUM(garagearea::double precision) as garagearea,
	SUM(storagearea::double precision) as storagearea,
	SUM(factoryarea::double precision) as factoryarea,
	SUM(otherarea::double precision) as otherarea
	FROM pluto_input_cama
	WHERE bldgnum = '1' AND billingbbl::numeric > 0
	GROUP BY billingbbl)

UPDATE pluto a
SET comarea = b.commercialarea,
	resarea = b.residarea,
	officearea = b.officearea,
	retailarea = b.retailarea,
	garagearea = b.garagearea,
	strgearea = b.storagearea,
	factryarea = b.factoryarea,
	otherarea = b.otherarea
FROM primesums b
WHERE a.bbl=b.primebbl
AND a.lot LIKE '75%'
AND (b.commercialarea::numeric > 0
	OR b.residarea::numeric > 0
	OR b.officearea::numeric > 0
	OR b.retailarea::numeric > 0
	OR b.garagearea::numeric > 0
	OR b.storagearea::numeric > 0
	OR b.factoryarea::numeric > 0
	OR b.otherarea::numeric > 0)
AND (a.comarea IS NULL
	AND a.resarea IS NULL
	AND a.officearea IS NULL
	AND a.retailarea IS NULL
	AND a.garagearea IS NULL
	AND a.strgearea IS NULL
	AND a.factryarea IS NULL
	AND a.otherarea IS NULL);

-- assign an area source to records that aready have bldgarea from RPAD
UPDATE pluto a
SET areasource = '2'
WHERE bldgarea::numeric <> 0 AND bldgarea IS NOT NULL;

-- populate bldgarea from CAMA data
UPDATE pluto a
SET bldgarea = b.grossarea,
areasource = '7'
FROM pluto_input_cama b
WHERE a.bbl=b.primebbl
AND (bldgarea::numeric = 0 OR bldgarea IS NULL)
AND b.bldgnum = '1'
AND a.lot NOT LIKE '75%';
-- for condos
WITH primesums AS (
	SELECT billingbbl as primebbl,
	SUM(grossarea::double precision) as grossarea
	FROM pluto_input_cama
	WHERE bldgnum = '1' AND billingbbl::numeric > 0
	GROUP BY billingbbl)

UPDATE pluto a
SET bldgarea = b.grossarea,
areasource = '7'
FROM primesums b
WHERE a.bbl=b.primebbl
AND (bldgarea::numeric = 0 OR bldgarea IS NULL)
AND a.lot LIKE '75%';

-- calcualte bldgarea by multiplying bldgfront x bldgdepth X num stories
-- set area source to 5
UPDATE pluto a
SET bldgarea = a.bldgfront::numeric*a.bldgdepth::numeric*numfloors::numeric,
areasource = '5'
WHERE (a.bldgarea::numeric = 0 OR a.bldgarea IS NULL)
AND a.bldgfront::numeric <> 0
AND a.numfloors::numeric <> 0
AND a.areasource IS NULL;

-- set area source to 4 for vacant lots
-- for vacant lots and number of buildings is 0 and building floor area is 0
UPDATE pluto a
SET areasource = '4'
WHERE areasource IS NULL
	AND landuse = '11'
	AND (numbldgs::numeric = 0 OR numbldgs IS NULL)
	AND (bldgarea::numeric = 0 OR bldgarea IS NULL);

-- set area source to 0 where building area is not avialble because it's still 0 or null
UPDATE pluto a
SET areasource = '0'
WHERE a.areasource IS NULL
AND (bldgarea::numeric = 0 OR bldgarea IS NULL);