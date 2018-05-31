COPY(
SELECT a.zonedist1, b.zonedist1, a.zonedist2, b.zonedist2, a.zonedist3, b.zonedist3, a.residfar, b.residfar, a.commfar, b.commfar, a.facilfar, b.facilfar, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE round(a.residfar::numeric) <> round(b.residfar::numeric) OR round(a.commfar::numeric) <> round(b.commfar::numeric)
OR round(a.facilfar::numeric) <> round(b.facilfar::numeric)
GROUP BY a.zonedist1, b.zonedist1, a.zonedist2, b.zonedist2, a.zonedist3, b.zonedist3, a.residfar, b.residfar, a.commfar, b.commfar, a.facilfar, b.facilfar
) TO '/prod/db-pluto/pluto_build/output/qc_zoningfars.csv' DELIMITER ',' CSV HEADER;

SELECT a.ownername, b.ownername, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.ownername <> b.ownername
GROUP BY a.ownername, b.ownername
ORDER BY count DESC

UPDATE pluto
SET residfar = NULL,
commfar = NULL,
facilfar = NULL