SELECT 
	DISTINCT
    bbl.primebbl, 
    rpad.bldgcl as bldgclass,
	rpad.story as numfloors,
	rpad.lfft as lotfront,
	rpad.ldft as lotdepth,
	rpad.bfft as bldgfront,
	rpad.bdft as bldgdepth,
	rpad.ext as ext,
	rpad.condo_number as condono,
	rpad.land_area as lotarea,
	rpad.gross_sqft as bldgarea,
	rpad.yrbuilt as yearbuilt,
	rpad.yralt1 as yearalter1,
	rpad.yralt2 as yearalter2,
	rpad.owner as ownername,
	rpad.irreg as irrlotcode,
	concat(rpad.housenum_lo,' ',rpad.street_name) as address,
	ap_datef as appdate
FROM {{ ref('stg_bbl') }} as bbl
    LEFT JOIN {{ ref('stg_rpad') }} as rpad ON bbl.primebbl = rpad.bbl
WHERE LENGTH(bbl.bbl) = 10