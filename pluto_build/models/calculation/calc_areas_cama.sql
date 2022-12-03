SELECT 
    cama.primebbl,
    SUM(commercialarea) as commercial_area,
	SUM(residarea) as residential_area,
	SUM(officearea) as office_area,
	SUM(retailarea) as retail_area,
	SUM(garagearea) as garage_area,
	SUM(storagearea) as storage_area,
	SUM(factoryarea) as factory_area,
	SUM(otherarea) as other_area,
	SUM(grossarea) as gross_area
FROM {{ ref('stg_cama') }} as cama
WHERE bldgnum = '1'
GROUP BY cama.primebbl