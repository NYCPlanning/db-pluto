SELECT 
    bbl as primebbl,
    (
        rpad.officearea + 
        rpad.retailarea +
        rpad.garagearea + 
        rpad.storagearea + 
        rpad.factoryarea + 
        rpad.otherarea
    ) as commercial_area,
	rpad.residarea as residential_area,
	rpad.officearea as office_area,
	rpad.retailarea as retail_area,
	rpad.garagearea as garage_area,
	rpad.storagearea as storage_area,
	rpad.factoryarea as factory_area,
	rpad.otherarea as other_area,
    rpad.gross_sqft as gross_area,
    rpad.lfft * rpad.ldft * rpad.story as _gross_area
FROM {{ ref('stg_rpad') }} as rpad
WHERE RIGHT(rpad.bbl, 4) NOT LIKE '75%'