---scratch
SELECT
 boro||block||lot,
 COUNT (boro||block||lot)
FROM
 pluto_input_cama_dof
 WHERE officearea <> '0'
GROUP BY
boro||block||lot
HAVING
 COUNT (boro||block||lot) > 1;

 2024450028
 2033430331
 2036970018


SELECT a.bsmtcode as newpluto, b.bsmtcode as pluto17v11, a.bbl
FROM pluto a, dcp_mappluto b
WHERE a.bbl||'.00'=b.bbl::text AND a.bsmtcode::text<>b.bsmtcode::text

GROUP BY a.bsmtcode, b.bsmtcode
ORDER BY a.bsmtcode, count DESC, b.bsmtcode


SELECT a.lottype as newpluto, b.lottype as pluto17v11, a.bbl
FROM pluto a, dcp_mappluto b
WHERE a.bbl||'.00'=b.bbl::text AND a.lottype::text<>b.lottype::text




AND a.bsmtcode::text<>b.bsmtcode::text


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


WITH dcpbbl AS (
	SELECT DISTINCT boro::text||lpad(block::text,5,'0')||lpad(lot::text,4,'0') as bbl, proxcode
FROM pluto_input_cama_dcp
),
WITH dofbbl AS (
	SELECT DISTINCT boro::text||lpad(block::text,5,'0')||lpad(lot::text,4,'0') as bbl, proxcode
FROM pluto_input_cama_dof
),
pluto17 AS (
SELECT DISTINCT bbl, proxcode
FROM dcp_mappluto)

SELECT DISTINCT pluto17.proxcode as dcpproxcode, dofbbl.proxcode dofproxcode, COUNT(*)
FROM pluto17, dofbbl
WHERE pluto17.bbl::text = dofbbl.bbl||'.00' 
GROUP BY dofbbl.proxcode, pluto17.proxcode
ORDER BY dofproxcode, dcpproxcode;

SELECT dcpbbl.proxcode as dcpproxcode, dcpbbl.bbl, dofbbl.proxcode dofproxcode 
FROM dcpbbl, dofbbl
WHERE dcpbbl.bbl = dofbbl.bbl 
AND ((dcpbbl.proxcode = '0' AND dofbbl.proxcode <> '0') 
OR (dcpbbl.proxcode = '2' AND dofbbl.proxcode = '0')
OR (dcpbbl.proxcode = '3' AND dofbbl.proxcode = '0'))
ORDER BY dcpproxcode,dofproxcode, bbl



WITH dcpbbl AS (
	SELECT DISTINCT boro::text||lpad(block::text,5,'0')||lpad(lot::text,4,'0') as bbl, bsmnt_type
FROM pluto_input_cama_dcp
),
dofbbl AS (
	SELECT DISTINCT boro::text||lpad(block::text,5,'0')||lpad(lot::text,4,'0') as bbl, bsmnt_type||bsmntgradient as dofbasement
FROM pluto_input_cama_dof
),
pluto17 AS (
SELECT DISTINCT bbl, bsmtcode
FROM dcp_mappluto)

SELECT DISTINCT pluto17.bsmtcode as dcpbsmnt, dofbbl.dofbasement dofbsmnt, COUNT(*)
FROM pluto17, dofbbl
WHERE pluto17.bbl::text = dofbbl.bbl||'.00' 
GROUP BY dofbbl.dofbasement, pluto17.bsmtcode
ORDER BY dofbsmnt, dcpbsmnt;

WITH dcpbbl AS (
	SELECT DISTINCT boro::text||lpad(block::text,5,'0')||lpad(lot::text,4,'0') as bbl, lottype
FROM pluto_input_cama_dcp
),
WITH dofbbl AS (
	SELECT DISTINCT boro::text||lpad(block::text,5,'0')||lpad(lot::text,4,'0') as bbl, lottype
FROM pluto_input_cama_dof)

SELECT * FROM dofbbl WHERE bbl = '2023300044'
),
pluto17 AS (
SELECT DISTINCT bbl, lottype
FROM dcp_mappluto)

SELECT DISTINCT pluto17.lottype as dcplottype, dofbbl.lottype doflottype, COUNT(*)
FROM pluto17, dofbbl
WHERE pluto17.bbl::text = dofbbl.bbl||'.00'  
GROUP BY pluto17.lottype, dofbbl.lottype
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


