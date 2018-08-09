-- Adding on data from allocated input table
UPDATE pluto a
SET --bldgclass = b.bldg_cl,
	ownertype = b.owner_code_ipis,
	--ownername = b.owner,
	--lotarea = b.lot_area,
	bldgarea = b.gross_area_rpad,
	--numbldgs = b.blgds,
	--numfloors = b.stories,
	--unitsres = b.apts,
	--unitstotal = b.units,
	--lotfront = b.lot_front_ft,
	--lotdepth = b.lot_depth_ft,
	--bldgfront = b.bld_front_ft,
	--bldgdepth = b.bld_depth_ft,
	--ext = b.extension,
	--irrlotcode = b.irregular,
	--assessland = b.av_land, -- check to see if other fields are summed in
	--assesstot = b.av_land_total,
	--exemptland = b.exempt_value_land,
	--exempttot = b.exempt_value_total,
	--yearbuilt = b.yr_built,
	--yearalter1 = b.yr_alt_1,
	--yearalter2 = b.yr_alt_2,
	--condono	= b.condo_num,
	--appbbl = b.ap_boro||b.ap_block||b.ap_lot,
	--appdate = b.ap_date
FROM pluto_input_allocated b
WHERE a.borocode||lpad(a.block, 5, '0')||lpad(a.lot, 4, '0') = b.boro::text||lpad(b.block::text, 5, '0')||lpad(b.lot::text, 4, '0');

1016617501.00 (condo)
bldgarea   | 19738
assessland | 112497.000000
assesstot  | 2812501.00000
exemptland | 71010.0000000
exempttot  | 2771014.00000

1016800048.00
bldgarea   | 12000
assessland | 123278.000000
assesstot  | 400390.000000
exemptland | 123278.000000
exempttot  | 400390.000000


1012310038.00
bldgarea   | 7371
assessland | 363600.000000
assesstot  | 1224450.00000
exemptland | 178164.000000
exempttot  | 561809.000000
