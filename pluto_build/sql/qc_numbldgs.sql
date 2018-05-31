-- using doitt_buildingfootprints checking the numbldgs 
-- based on the number of unique BINs associated with that lot
COPY(
WITH bldgfootprintcount AS (
SELECT COUNT(DISTINCT bin) AS numfootprints, bbl
FROM doitt_buildingfootprints
GROUP BY bbl
)
SELECT a.bbl, a.numbldgs, b.numfootprints, (numbldgs::numeric - numfootprints::numeric) AS difference
FROM pluto a, bldgfootprintcount b
WHERE a.bbl=b.bbl AND a.numbldgs<>b.numfootprints::text
ORDER BY difference DESC
) TO '/prod/db-pluto/pluto_build/output/qc_numbldgs.csv' DELIMITER ',' CSV HEADER;