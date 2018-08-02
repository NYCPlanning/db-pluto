-- create the allocated table from pluto_rpad_geo

-- fill in one-to-one attributes
-- for noncondo records
UPDATE pluto_allocated a
SET bldgclass = bldgcl,
	numfloors = story,
	condono = condo_number,
	lotarea = land_area,
	yearbuilt = yrbuilt,
	ownername = owner,
	irrlotcode = irreg
FROM pluto_rpad_geo
WHERE a.bbl=b.primebbl
AND b.tl NOT LIKE '75%'
AND b.condo_number = '0';

-- for condos get values from records where tax lot starts with 75, which indicates that this is the condo
UPDATE pluto_allocated a
SET bldgclass = bldgcl,
	numfloors = story,
	condono = condo_number,
	lotarea = land_area,
	yearbuilt = yrbuilt,
	ownername = owner,
	irrlotcode = irreg
FROM pluto_rpad_geo
WHERE a.bbl=b.primebbl
AND b.tl LIKE '75%'
AND b.condo_number IS NOT NULL
AND b.condo_number <> '0';

-- populate the fields that where values are aggregated
UPDATE pluto_allocated a
SET unitsres = SUM(coop_apts::integer),
	unitstotal = SUM(units::integer)
FROM pluto_rpad_geo b
WHERE a.bbl=b.primebbl
GROUP BY primebbl;

UPDATE pluto_allocated a
address = trim(leading '0' FROM b.prime)||' '||b.boePreferredStreetName

-- set the number of buildings on a lot
-- if GeoClient returned a value then we use the value GeoClient returned
UPDATE pluto_allocated a
SET numbldgs = (CASE 
					WHEN numberOfExistingStructuresOnLot::integer > 0 THEN numberOfExistingStructuresOnLot
					ELSE bldgs
				END)
WHERE a.bbl=b.primebbl;



psudo code
get doe preffered street name, use prime house number, and get the number of buildings on lot to from geocoding it pick up number of structures, which gets inserted into number of building field to replace RPAD value

how do you get the right owner?