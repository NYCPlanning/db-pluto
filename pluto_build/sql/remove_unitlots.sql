-- drop records from pluto
-- where it's a unit lot, it's unmapped, and the number of units is > 1
DELETE FROM pluto
WHERE RIGHT(bbl,4) LIKE '1%'
AND unitstotal::numeric > 1
AND geom IS NULL;