-- set building class for condo lots if there is only one unique building class value
WITH bldgclass AS (
  SELECT DISTINCT billingbbl,bldgcl, ROW_NUMBER()
      OVER (PARTITION BY billingbbl
        ORDER BY bldgcl) AS row_number 
      FROM (
            SELECT DISTINCT billingbbl,bldgcl 
            FROM pluto_rpad_geo 
            WHERE bldgcl <> 'R0' AND billingbbl::numeric > 0) x ),
maxnum AS (
  SELECT billingbbl, max(row_number) as maxrow_number FROM bldgclass GROUP BY billingbbl)

UPDATE pluto a
SET bldgclass = (CASE
                WHEN c.maxrow_number = 1 THEN b.bldgcl
                ELSE NULL
                END)
FROM bldgclass b, maxnum c
WHERE a.bbl = b.billingbbl
AND c.billingbbl = a.bbl;

-- set building class for condo lots where there are multiple building class values
DROP TABLE IF EXISTS bblsbldgclasslookup;
CREATE TABLE bblsbldgclasslookup AS (
WITH bldgclass AS (
  SELECT DISTINCT billingbbl,bldgcl, ROW_NUMBER()
      OVER (PARTITION BY billingbbl
        ORDER BY bldgcl) AS row_number 
      FROM (
            SELECT DISTINCT billingbbl,bldgcl 
            FROM pluto_rpad_geo 
            WHERE bldgcl <> 'R0' AND billingbbl::numeric > 0) x ),
maxnum AS (
  SELECT billingbbl, max(row_number) as maxrow_number FROM bldgclass GROUP BY billingbbl),
bldgclassmed as (
	SELECT a.billingbbl, a.bldgcl, a.row_number, c.type
	FROM bldgclass a, maxnum b, pluto_input_condo_bldgclass c
	WHERE b.maxrow_number >= 2
	AND a.billingbbl=b.billingbbl
	AND a.bldgcl = c.code
	ORDER BY billingbbl)
SELECT DISTINCT billingbbl, type
FROM bldgclassmed
ORDER BY billingbbl,type);

DROP TABLE IF EXISTS bblsbldgclass;
CREATE TABLE bblsbldgclass AS(
SELECT billingbbl, string_agg(type, ', ') as type
FROM bblsbldgclasslookup
GROUP BY billingbbl);

UPDATE pluto a
SET bldgclass = 'RD'
FROM bblsbldgclass b
WHERE a.bbl = b.billingbbl
AND type = 'Res';
UPDATE pluto a
SET bldgclass = 'RC'
FROM bblsbldgclass b
WHERE a.bbl = b.billingbbl
AND type = 'Com';
UPDATE pluto a
SET bldgclass = 'RI'
FROM bblsbldgclass b
WHERE a.bbl = b.billingbbl
AND type = 'Com, Ind';
UPDATE pluto a
SET bldgclass = 'RM'
FROM bblsbldgclass b
WHERE a.bbl = b.billingbbl
AND type = 'Com, Res';
UPDATE pluto a
SET bldgclass = 'RX'
FROM bblsbldgclass b
WHERE a.bbl = b.billingbbl
AND type = 'Com, Ind, Res';
UPDATE pluto a
SET bldgclass = 'RZ'
FROM bblsbldgclass b
WHERE a.bbl = b.billingbbl
AND type = 'Ind, Res';
DROP TABLE IF EXISTS bblsbldgclasslookup;
DROP TABLE IF EXISTS bblsbldgclass;

-- set the building class to Q0 
-- where the zoning district is park and the building class is null or vacant
UPDATE pluto 
SET bldgclass = 'Q0'
WHERE zonedist1 = 'PARK'
AND (bldgclass IS NULL OR bldgclass LIKE 'V%');

