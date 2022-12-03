SELECT 
    COALESCE(rpad.primebbl, cama.primebbl) as primebbl,
    COALESCE(
        NULLIF(rpad.commercial_area, 0),
        NULLIF(cama.commercial_area, 0)
    ) as commercial_area,
    COALESCE(
        NULLIF(rpad.residential_area, 0),
        NULLIF(cama.residential_area, 0)
    ) as residential_area,
    COALESCE(
        NULLIF(rpad.office_area, 0),
        NULLIF(cama.office_area, 0)
    ) as office_area,
    COALESCE(
        NULLIF(rpad.retail_area, 0),
        NULLIF(cama.retail_area, 0)
    ) as retail_area,
    COALESCE(
        NULLIF(rpad.garage_area, 0),
        NULLIF(cama.garage_area, 0)
    ) as garage_area,
    COALESCE(
        NULLIF(rpad.storage_area, 0),
        NULLIF(cama.storage_area, 0)
    ) as storage_area,
    COALESCE(
        NULLIF(rpad.factory_area, 0),
        NULLIF(cama.factory_area, 0)
    ) as factory_area,
    COALESCE(
        NULLIF(rpad.other_area, 0),
        NULLIF(cama.other_area, 0)
    ) as other_area,
    COALESCE(
        NULLIF(rpad.gross_area, 0),
        NULLIF(cama.gross_area, 0),
        rpad._gross_area
    ) as bldg_area, 
    COALESCE(
        CASE WHEN NULLIF(rpad.gross_area, 0) IS NOT NULL THEN '2' END,
        CASE WHEN NULLIF(cama.gross_area, 0) IS NOT NULL THEN '7' END,
        CASE WHEN NULLIF(rpad._gross_area, 0) IS NOT NULL THEN '5' END
    ) as area_source
FROM {{ ref('calc_areas_rpad') }} rpad 
FULL OUTER JOIN {{ ref('calc_areas_cama') }} cama
ON rpad.primebbl = cama.primebbl