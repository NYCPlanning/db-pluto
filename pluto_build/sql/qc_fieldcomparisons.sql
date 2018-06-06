COPY(
SELECT a.zonedist1, b.zonedist1, a.zonedist2, b.zonedist2, a.zonedist3, b.zonedist3, a.residfar, b.residfar, a.commfar, b.commfar, a.facilfar, b.facilfar, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE round(a.residfar::numeric) <> round(b.residfar::numeric) OR round(a.commfar::numeric) <> round(b.commfar::numeric)
OR round(a.facilfar::numeric) <> round(b.facilfar::numeric)
GROUP BY a.zonedist1, b.zonedist1, a.zonedist2, b.zonedist2, a.zonedist3, b.zonedist3, a.residfar, b.residfar, a.commfar, b.commfar, a.facilfar, b.facilfar
) TO '/prod/db-pluto/pluto_build/output/qc_zoningfars.csv' DELIMITER ',' CSV HEADER;

COPY(
SELECT a.ownername, b.ownername, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.ownername <> b.ownername
GROUP BY a.ownername, b.ownername
ORDER BY count DESC
) TO '/prod/db-pluto/pluto_build/output/qc_ownername.csv' DELIMITER ',' CSV HEADER;

COPY(
SELECT DISTINCT a.ownername as newownername, b.ownername as pluto17v11name,
COUNT(*) 
FROM pluto a, dcp_mappluto b
WHERE (a.ownertype = 'O' OR a.ownertype = 'C') AND a.bbl||'.00'=b.bbl::text
GROUP BY a.ownername, b.ownername ORDER BY a.ownername
) TO '/prod/db-pluto/pluto_build/output/qc_ownernameCOtype.csv' DELIMITER ',' CSV HEADER;

COPY(
WITH bbllottypes AS (
	SELECT DISTINCT boro||block||lot as bbl, lottype
	FROM pluto_input_cama_dof
	WHERE lottype <> '5')
SELECT a.* , b.lottype as newplutolt, c.lottype as pluto17v11ly
FROM bbllottypes a
LEFT JOIN pluto b
ON a.bbl=b.bbl
LEFT JOIN dcp_mappluto c
ON a.bbl||'.00'=c.bbl::text
WHERE a.bbl IN (SELECT bbl FROM bbllottypes GROUP BY bbl HAVING COUNT(bbl)>1)
ORDER BY a.bbl, lottype
) TO '/prod/db-pluto/pluto_build/output/qc_lottypemultibbl.csv' DELIMITER ',' CSV HEADER;

COPY(
SELECT DISTINCT a.lottype as nplt, b.lottype p17lt, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.lottype::text <> b.lottype::text
GROUP BY a.lottype, b.lottype
) TO '/prod/db-pluto/pluto_build/output/qc_lottypediff.csv' DELIMITER ',' CSV HEADER;

