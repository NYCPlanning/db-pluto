-- assigning proxy code
-- recode DOF values to DCP values and remove 0s (Not Available)
-- select proxcode for lot from record where bldgnum is 1
-- all bbl reocrds have at least one record with a bldgnum = '1'
WITH dcpcamavals AS(
	SELECT DISTINCT boro||block||lot AS bbl,
		(CASE
			WHEN proxcode = '5' THEN '2'
			WHEN proxcode = '4' THEN '3'
			WHEN proxcode = '6' THEN '3'
			ELSE proxcode
		END) proxcode
	FROM pluto_input_cama_dof
	WHERE proxcode <> '0'
	AND bldgnum = '1'
)

UPDATE pluto a
SET proxcode = dcpcamavals.proxcode
FROM dcpcamavals
WHERE a.bbl = dcpcamavals.bbl;

-- assign 0 (Not Available) to remaining records
UPDATE pluto
SET proxcode = '0'
WHERE proxcode IS NULL;

-- assigning lot type
-- remove 0s (Not Available) and 5 (none of the other types)
-- select lowest lot type value for record where bldgnum is 1
WITH dcpcamavals AS(
	SELECT DISTINCT bbl,
	lottype
	FROM (
		SELECT boro||block||lot AS bbl, lottype, ROW_NUMBER()
    	OVER (PARTITION BY boro||block||lot
      	ORDER BY lottype) AS row_number
  		FROM pluto_input_cama_dof
  		WHERE lottype <> '0' 
		AND lottype <> '5'
		AND bldgnum = '1') x
	WHERE x.row_number = 1)	

UPDATE pluto a
SET lottype = dcpcamavals.lottype
FROM dcpcamavals
WHERE a.bbl = dcpcamavals.bbl;

-- update lots with lot type value of 5
UPDATE pluto a
SET lottype = b.lottype
FROM pluto_input_cama_dof b
WHERE a.bbl = b.boro||b.block||b.lot
AND b.lottype = '5'
AND a.lottype IS NULL;

-- assign 0 (Mixed or Unknown) to remaining records
UPDATE pluto
SET lottype = '0'
WHERE lottype IS NULL;

-- assigning basement type
-- remove 0 (Unknown) bsmnt_type 
-- get highest bsmnt_type and bsmntgradient value for each lot
-- match bsmnt_type and bsmntgradient values to pluto_input_bsmtcode lookup table to get and assign bsmtcode value
WITH dcpcamavals AS(
	SELECT DISTINCT x.bbl, x.bsmnt_type, x.bsmntgradient, b.bsmtcode
	FROM (
		SELECT boro||block||lot AS bbl, bsmnt_type, bsmntgradient, ROW_NUMBER()
    	OVER (PARTITION BY boro||block||lot
      	ORDER BY bsmnt_type DESC) AS row_number
  		FROM pluto_input_cama_dof
  		WHERE bsmnt_type <> '0'
		AND bldgnum = '1') x
	LEFT JOIN pluto_input_bsmtcode b
	ON x.bsmnt_type = b.bsmnt_type AND x.bsmntgradient = b.bsmntgradient
	WHERE x.row_number = 1)

UPDATE pluto a
SET bsmtcode = b.bsmtcode
FROM dcpcamavals b
WHERE a.bbl=b.bbl;

-- assign 5 (Unknown) to remaining records
UPDATE pluto
SET bsmtcode = '5'
WHERE bsmtcode IS NULL;



---scratch
SELECT * FROM dcpcamavals WHERE bbl = '2026210001';



WITH bldgnumtest AS (
	SELECT bbl, bldgnum
	FROM (
		SELECT boro||block||lot AS bbl, bldgnum, ROW_NUMBER()
    	OVER (PARTITION BY boro||block||lot
      	ORDER BY bldgnum) AS row_number
  		FROM pluto_input_cama_dof) x
	WHERE x.row_number = 1)

SELECT DISTINCT bldgnum FROM bldgnumtest


SELECT * FROM dcpcamavals WHERE bbl = '2026210001';

SELECT bbl FROM dcpcamavals GROUP BY bbl HAVING COUNT(*) > 1 ;

WHERE bbl = '2025340008';

 2025970001
 2025950107
 2026320001
 2026210001

--
WITH dcpcamavals AS(
	SELECT DISTINCT boro||block||lot AS bbl,
		bsmnt_type
	FROM pluto_input_cama_dof
	WHERE bldgnum = '1'
	AND bsmnt_type <> '0'
)

SELECT COUNT(*) FROM dcpcamavals

SELECT DISTINCT bsmnt_type FROM dcpcamavals

COPY(
WITH dcpbbl AS (
	SELECT DISTINCT boro::text||lpad(block::text,5,'0')||lpad(lot::text,4,'0') as bbl, proxcode
FROM pluto_input_cama_dcp
),
dofbbl AS (
	SELECT DISTINCT boro::text||lpad(block::text,5,'0')||lpad(lot::text,4,'0') as bbl, proxcode
FROM pluto_input_cama_dof
)

SELECT dcpbbl.proxcode as dcpproxcode, dcpbbl.bbl, dofbbl.proxcode dofproxcode 
FROM dcpbbl, dofbbl
WHERE dcpbbl.bbl = dofbbl.bbl 
AND ((dcpbbl.proxcode = '0' AND dofbbl.proxcode <> '0') 
OR (dcpbbl.proxcode = '2' AND dofbbl.proxcode = '0')
OR (dcpbbl.proxcode = '3' AND dofbbl.proxcode = '0'))
ORDER BY dcpproxcode,dofproxcode, bbl
)TO '/prod/db-pluto/pluto_build/output/bbl_dof_dcp_proxycode.csv' DELIMITER ',' CSV HEADER;



WITH dcpbbl AS (
	SELECT DISTINCT boro::text||lpad(block::text,5,'0')||lpad(lot::text,4,'0') as bbl, bsmnt_type
FROM pluto_input_cama_dcp
),
dofbbl AS (
	SELECT DISTINCT boro::text||lpad(block::text,5,'0')||lpad(lot::text,4,'0') as bbl, bsmnt_type||bsmntgradient as dofbasement
FROM pluto_input_cama_dof
WHERE bldgnum = '1'
),
pluto16 AS (
SELECT DISTINCT bbl, bsmtcode
FROM dcp_mappluto)

SELECT DISTINCT dcp_mappluto.bsmtcode as dcpbsmnt, dofbbl.dofbasement dofbsmnt, COUNT(*)
FROM dcp_mappluto, dofbbl
WHERE dcp_mappluto.bbl::text = dofbbl.bbl||'.00' 
GROUP BY dofbbl.dofbasement, dcp_mappluto.bsmtcode
ORDER BY dofbsmnt, dcpbsmnt;

WITH dcpbbl AS (
	SELECT DISTINCT boro::text||lpad(block::text,5,'0')||lpad(lot::text,4,'0') as bbl, lottype
FROM pluto_input_cama_dcp
),
dofbbl AS (
	SELECT DISTINCT boro::text||lpad(block::text,5,'0')||lpad(lot::text,4,'0') as bbl, lottype
FROM pluto_input_cama_dof
)

SELECT DISTINCT dcpbbl.lottype as dcplottype, dofbbl.lottype doflottype, COUNT(*)
FROM dcpbbl, dofbbl
WHERE dcpbbl.bbl = dofbbl.bbl 
GROUP BY dcpbbl.lottype, dofbbl.lottype
ORDER BY dcplottype,doflottype;

AND dcpbbl.proxcode <> dofbbl.proxcode



SELECT COUNT(DISTINCT boro::text||lpad(block::text,5,'0')||lpad(lot::text,4,'0'))
FROM pluto_input_cama_dof 
WHERE boro||block||lot NOT IN (
	SELECT DISTINCT boro||block||lot 
	FROM pluto_input_cama_dcp);

SELECT COUNT(*) 
FROM pluto_input_cama_dof 
WHERE boro||block||lot NOT IN (
	SELECT DISTINCT boro||block||lot 
	FROM pluto_input_cama_dcp);


SELECT * FROM pluto_input_cama_dof WHERE boro = '2' AND block = '4564' AND lot = '56'

WITH dcpbbl AS (
	SELECT DISTINCT boro::text||lpad(block::text,5,'0')||lpad(lot::text,4,'0') as bbl, proxcode
FROM pluto_input_cama_dcp
),
dofbbl AS (
	SELECT DISTINCT boro::text||lpad(block::text,5,'0')||lpad(lot::text,4,'0') as bbl, proxcode
FROM pluto_input_cama_dof
)

SELECT DISTINCT dcpbbl.proxcode as dcpproxcode, dofbbl.proxcode dofproxcode, 
COUNT(*)
FROM dcpbbl, dofbbl
WHERE dcpbbl.bbl = dofbbl.bbl 
GROUP BY dcpbbl.proxcode, dofbbl.proxcode
ORDER BY dcpproxcode,dofproxcode


SELECT DISTINCT bldgclass, COUNT(*) FROM dcp_mappluto
WHERE bbl::text IN (
SELECT DISTINCT bbl||'.00' FROM pluto WHERE bldgclass = 'R0')
GROUP BY bldgclass
ORDER BY bldgclass;


