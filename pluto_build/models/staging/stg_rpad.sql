WITH pluto_rpad_rownum AS (
	SELECT 
        a.*, 
        ROW_NUMBER() OVER (
            PARTITION BY boro||tb||tl
      	    ORDER BY 
            curavt_act DESC 
            ,land_area DESC
            ,ease ASC
        ) AS rn,
        (curavl_act = curavt_act AND upper(bldgcl) LIKE 'V%') AS dcp_edit_flag 
  	FROM {{ ref('stg_pts') }} a
)
SELECT 
    boro,
    tb,
    tl,
    bbl,
    street_name,
    housenum_lo,
    housenum_hi,
    aptno,
    zip,
    bldgcl,
    ease,
    owner,
    (CASE 
        WHEN (land_area IS NULL OR land_area = 0) 
            AND irreg <> 'I'
            AND lfft > 0 
            AND ldft > 0
        THEN lfft * ldft
        ELSE land_area
    END) AS land_area,
    gross_sqft,
    residarea,
    officearea,
    retailarea,
    garagearea,
    storagearea,
    factoryarea,
    otherarea,
    (CASE WHEN dcp_edit_flag THEN 0 ELSE bldgs END) AS bldgs,
    (CASE WHEN dcp_edit_flag THEN 0 ELSE story END) AS story,
    coop_apts,
    units,
    lfft,
    ldft,
    (CASE WHEN dcp_edit_flag THEN 0 ELSE bfft END) AS bfft,
    (CASE WHEN dcp_edit_flag THEN 0 ELSE bdft END) AS bdft,
    ext,
    irreg,
    curavl_act,
    curavt_act,
    curext_act,
    yrbuilt,
    yralt1,
    yralt2,
    condo_number,
    ap_boro,
    ap_block,
    ap_lot,
    ap_ease,
    ap_date
FROM pluto_rpad_rownum 
WHERE rn = 1