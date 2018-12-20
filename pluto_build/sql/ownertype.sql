-- set the owner type code based on data from COLP

-- set M owner tyoe
UPDATE pluto a
SET ownertype = 'M'
FROM dcas_facilities_colp b
WHERE b.code LIKE '%X%'
AND a.bbl= b.bbl;
-- set P owner tyoe
UPDATE pluto a
SET ownertype = 'P'
FROM dcas_facilities_colp b
WHERE b.code LIKE '%P%'
AND a.bbl= b.bbl;
-- set O as owner type
UPDATE pluto a
SET ownertype = 'O'
FROM dcas_facilities_colp b
WHERE b.code LIKE '%Q%'
AND a.bbl= b.bbl;
-- set C as owner type
UPDATE pluto a
SET ownertype = 'C'
FROM dcas_facilities_colp b
WHERE b.type = 'OF'
AND a.ownertype IS NULL
AND a.bbl= b.bbl;
-- set X as owner type
UPDATE pluto a
SET ownertype = 'X'
FROM dcas_facilities_colp b
WHERE a.ownertype IS NULL
AND a.bbl= b.bbl;