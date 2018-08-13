-- create the allocated table from pluto_rpad_geo
DROP TABLE IF EXISTS pluto_allocated CASCADE;
CREATE TABLE pluto_allocated (
	bbl text,
	bldgclass text,
	ownertype  text,
	ownername text,
	lotarea text,
	bldgarea text,
	numbldgs text,
	numfloors text,
	unitsres text,
	unitstotal text,
	lotfront text,
	lotdepth text,
	bldgfront text,
	bldgdepth text,
	ext text,
	irrlotcode text,
	assessland text,
	assesstot text,
	exemptland text,
	exempttot text,
	yearbuilt text,
	yearalter1 text,
	yearalter2 text,
	condono text,
	appbbl text,
	appdate text
);

INSERT INTO pluto_allocated (
	bbl
	)
SELECT
	b.primebbl
FROM (SELECT DISTINCT primebbl FROM pluto_rpad_geo) AS b;

-- fill in one-to-one attributes
-- for noncondo records
UPDATE pluto_allocated a
SET bldgclass = bldgcl,
	numfloors = story,
	lotfront = lfft::integer,
	lotdepth = ldft::integer,
	bldgfront = bfft::integer,
	bldgdepth = bdft:integer,
	ext = b.ext,
	condono = condo_number,
	lotarea = land_area,
	yearbuilt = yrbuilt,
	yearalter1 = yralt1,
	yearalter2 = yralt1,
	ownername = owner,
	irrlotcode = irreg,
	address = trim(leading '0' FROM prime)||' '||boePreferredStreetName,
-- set the number of buildings on a lot
-- if GeoClient returned a value then we use the value GeoClient returned
	numbldgs = (CASE 
					WHEN numberOfExistingStructuresOnLot::integer > 0 THEN numberOfExistingStructuresOnLot
					ELSE bldgs
				END),
	appbbl = ap_boro||lpad(ap_block, 5, '0')||lpad(ap_lot, 4, '0'),
	appdate = ap_datef
FROM pluto_rpad_geo b
WHERE a.bbl=b.primebbl
AND b.tl NOT LIKE '75%'
AND b.condo_number = '0';

-- for condos get values from records where tax lot starts with 75, which indicates that this is the condo
UPDATE pluto_allocated a
SET bldgclass = bldgcl,
	numfloors = story,
	lotfront = lfft::integer,
	lotdepth = ldft::integer,
	bldgfront = bfft::integer,
	bldgdepth = bdft:integer,
	ext = b.ext,
	condono = condo_number,
	lotarea = land_area,
	yearbuilt = yrbuilt,
	yearalter1 = yralt1,
	yearalter2 = yralt1,
	ownername = owner,
	irrlotcode = irreg,
	address = trim(leading '0' FROM prime)||' '||boePreferredStreetName,
-- set the number of buildings on a lot
-- if GeoClient returned a value then we use the value GeoClient returned
	numbldgs = (CASE 
					WHEN numberOfExistingStructuresOnLot::integer > 0 THEN numberOfExistingStructuresOnLot
					ELSE bldgs
				END),
	appbbl = ap_boro||lpad(ap_block, 5, '0')||lpad(ap_lot, 4, '0'),
	appdate = ap_datef
FROM pluto_rpad_geo
WHERE a.bbl=b.primebbl
AND b.tl LIKE '75%'
AND b.condo_number IS NOT NULL
AND b.condo_number <> '0';

-- populate the fields that where values are aggregated
UPDATE pluto_allocated a
SET unitsres = SUM(coop_apts::integer),
	unitstotal = SUM(units::integer),
	assessland = SUM(curavl_act::double precision),
	assesstot = SUM(curavt_act::double precision),
	exemptland = SUM(curexl_act::double precision),
	exempttot = SUM(curext_act::double precision)
FROM pluto_rpad_geo b
WHERE a.bbl=b.primebbl
GROUP BY primebbl;