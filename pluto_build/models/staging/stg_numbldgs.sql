SELECT
    geo.bbl,
    coalesce (
        numbldgs.count::integer,
        numberOfExistingStructuresOnLot::integer
    ) as numbldgs
FROM {{ ref('stg_geocodes') }} geo
    LEFT JOIN {{ source('public', 'pluto_input_numbldgs') }} numbldgs ON geo.bbl::bigint = numbldgs.bbl::bigint