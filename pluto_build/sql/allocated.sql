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
	lotfront = b.lot_front_ft,
	lotdepth = b.lot_depth_ft,
	bldgfront = b.bld_front_ft,
	bldgdepth = b.bld_depth_ft,
	ext = b.extension,
	--irrlotcode = b.irregular,
	assessland = b.av_land,
	assesstot = b.av_land_total,
	exemptland = b.exempt_value_land,
	exempttot = b.exempt_value_total,
	--yearbuilt = b.yr_built,
	yearalter1 = b.yr_alt_1,
	yearalter2 = b.yr_alt_2,
	--condono	= b.condo_num,
	--appbbl = b.ap_boro||b.ap_block||b.ap_lot,
	--appdate = b.ap_date
FROM pluto_input_allocated b
WHERE a.borocode||lpad(a.block, 5, '0')||lpad(a.lot, 4, '0') = b.boro::text||lpad(b.block::text, 5, '0')||lpad(b.lot::text, 4, '0');