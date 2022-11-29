SELECT 
    a.boro,
    a.tb,
    a.tl,
    a.bbl,
    b.billingbbl,
    (CASE 
        WHEN NULLIF(b.billingbbl, '0000000000') IS NOT NULL 
        THEN b.billingbbl
        ELSE a.boro||a.tb||a.tl
    END) AS primebbl
FROM {{ ref('stg_pts') }} a
LEFT JOIN {{ ref('stg_geocodes') }} b
ON a.boro||a.tb||a.tl = b.bbl