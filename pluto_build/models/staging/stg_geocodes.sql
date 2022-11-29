WITH backfill_geom AS (
    SELECT
        ogc_fid,
        COALESCE(
            wkb_geometry,
            ST_SetSRID(
                ST_MakePoint(
                    longitude::double precision,
                    latitude::double precision
                ),
                4326
            )
        ) as geom
    FROM {{ source('public', 'pluto_input_geocodes') }}
)
SELECT
    a.ogc_fid,
    bbl as geo_bbl,
    borough||lpad(block,5,'0')||lpad(lot,4,'0') as bbl,
    ST_X(ST_TRANSFORM(geom, 2263))::integer as xcoord,
    ST_Y(ST_TRANSFORM(geom, 2263))::integer as ycoord,
    (CASE WHEN ct2010::numeric = 0 THEN NULL ELSE ct2010 END) as ct2010,
    numberofexistingstructures as numberOfExistingStructuresOnLot,
    geom AS wkb_geometry,
    billingbbl,
    cd,
    cb2010,
    ct2020,
    cb2020,
    schooldist,
    council,
    zipcode,
    firecomp,
    policeprct,
    healthcenterdistrict,
    healtharea,
    sanitdistrict,
    sanitsub,
    boepreferredstreetname,
    taxmap,
    sanbornmapidentifier,
    latitude,
    longitude,
    grc,
    grc2,
    msg,
    msg2,
    borough,
    block,
    lot,
    easement,
    input_hnum,
    input_sname
FROM {{ source('public', 'pluto_input_geocodes') }} a
LEFT JOIN backfill_geom b ON a.ogc_fid = b.ogc_fid
