SELECT 
    a.bbl,
    parcelcard,
    bldgnum,
    bldgclass,
    primaryusecode,
    NULLIF(developmentname, '') AS developmentname,
    streettype,
    lottype,
    residarea::integer,
    officearea::integer,
    retailarea::integer,
    garagearea::integer,
    storagearea::integer,
    factoryarea::integer,
    otherarea::integer,
    grossarea::integer,
    ownerarea::integer,
    grossvolume,
    commercialarea::integer,
    proxcode,
    bsmnt_type,
    bsmntgradient,
    bsmntarea::integer,
    firstfloorarea::integer,
    secondfloorarea::integer,
    upperfloorarea::integer,
    partresfloorarea::integer,
    unfinishedfloorarea::integer,
    finishedfloorarea::integer,
    nonresidfloorarea::integer,
    NULLIF(residconstrtype, '') AS residconstrtype,
    NULLIF(commercialconstrtype, '') AS commercialconstrtype,
    NULLIF(condomainconstrtype, '') AS condomainconstrtype,
    NULLIF(condounitsconstrtype, '') AS condounitsconstrtype,
    b.billingbbl,
    (CASE 
        WHEN b.billingbbl IS NOT NULL AND b.billingbbl <> '0000000000' 
            THEN b.billingbbl 
        ELSE LEFT(a.bbl,10) 
    END) AS primebbl
FROM {{ source('public', 'pluto_input_cama_dof') }} a
LEFT JOIN {{ source('public', 'pluto_input_geocodes') }} b
ON LEFT(a.bbl,10)=b.borough||lpad(b.block,5,'0')||lpad(b.lot,4,'0')