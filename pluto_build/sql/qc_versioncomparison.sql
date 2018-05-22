DROP TABLE IF EXISTS pluto_qc_versioncomparisoncount;
CREATE TABLE pluto_qc_versioncomparisoncount AS (
	WITH pluto AS (SELECT * FROM pluto),
dcp_mappluto AS (SELECT * FROM dcp_mappluto),
countchange AS (
SELECT 'zonedist1' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.zonedist1 <> b.zonedist1
UNION
SELECT 'zonedist2' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.zonedist2 <> b.zonedist2
UNION
SELECT 'zonedist3' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.zonedist3 <> b.zonedist3
UNION
SELECT 'zonedist4' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.zonedist4 <> b.zonedist4
UNION
SELECT 'overlay1' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.overlay1 <> b.overlay1
UNION
SELECT 'overlay2' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.overlay2 <> b.overlay2
UNION
SELECT 'spdist1' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.spdist1 <> b.spdist1
UNION
SELECT 'spdist2' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.spdist2 <> b.spdist2
UNION
SELECT 'spdist3' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.spdist3 <> b.spdist3
UNION
SELECT 'ltdheight' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.ltdheight <> b.ltdheight
UNION
SELECT 'splitzone' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.splitzone <> b.splitzone
UNION
SELECT 'bldgclass' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.bldgclass <> b.bldgclass
UNION
SELECT 'landuse' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.landuse <> b.landuse
UNION
SELECT 'easements' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.easements::text <> b.easements::text
UNION
SELECT 'ownertype' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.ownertype <> b.ownertype
UNION
SELECT 'ownername' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.ownername <> b.ownername
UNION
SELECT 'lotarea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.lotarea::text <> b.lotarea::text
UNION
SELECT 'bldgarea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.bldgarea::numeric <> b.bldgarea::numeric
UNION
SELECT 'comarea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.comarea::numeric <> b.comarea::numeric
UNION
SELECT 'resarea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.resarea::numeric <> b.resarea::numeric
UNION
SELECT 'officearea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.officearea::numeric <> b.officearea::numeric
UNION
SELECT 'retailarea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.retailarea::numeric <> b.retailarea::numeric
UNION
SELECT 'garagearea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.garagearea::numeric <> b.garagearea::numeric
UNION
SELECT 'strgearea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.strgearea::numeric <> b.strgearea::numeric
UNION
SELECT 'factryarea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.factryarea::numeric <> b.factryarea::numeric
UNION
SELECT 'otherarea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.otherarea::numeric <> b.otherarea::numeric
UNION
SELECT 'areasource' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.areasource::text <> b.areasource::text
UNION
SELECT 'numbldgs' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.numbldgs::text <> b.numbldgs::text
UNION
SELECT 'numfloors' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.numfloors::text <> b.numfloors::text
UNION
SELECT 'unitstotal' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.unitstotal::text <> b.unitstotal::text
UNION
SELECT 'lotfront' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.lotfront::double precision <> b.lotfront::double precision
UNION
SELECT 'lotdepth' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.lotdepth::text <> b.lotdepth::text
UNION
SELECT 'bldgfront' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.bldgfront::text <> round(b.bldgfront)::text
UNION
SELECT 'bldgdepth' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.bldgdepth::double precision <> b.bldgdepth::double precision
UNION
SELECT 'ext' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.ext <> b.ext
UNION
SELECT 'proxcode' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.proxcode <> b.proxcode
UNION
SELECT 'irrlotcode' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.irrlotcode <> b.irrlotcode
UNION
SELECT 'lottype' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.lottype::text <> b.lottype::text
UNION
SELECT 'bsmtcode' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.bsmtcode::text <> b.bsmtcode::text
UNION
SELECT 'assessland' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.assessland::text <> round(b.assessland)::text
UNION
SELECT 'assesstot' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.assesstot::text <> round(b.assesstot)::text
UNION
SELECT 'exemptland' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.exemptland::double precision <> b.exemptland::double precision
UNION
SELECT 'exempttot' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.exempttot::double precision <> b.exempttot::double precision
UNION
SELECT 'yearbuilt' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.yearbuilt::text <> b.yearbuilt::text
UNION
SELECT 'yearalter1' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.yearalter1::text <> b.yearalter1::text
UNION
SELECT 'yearalter2' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.yearalter2::text <> b.yearalter2::text
UNION
SELECT 'histdist' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.histdist <> b.histdist
UNION
SELECT 'landmark' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.landmark <> b.landmark
UNION
SELECT 'builtfar' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.builtfar::double precision <> b.builtfar::double precision
UNION
SELECT 'residfar' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.residfar::text <> b.residfar::text
UNION
SELECT 'commfar' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.commfar::text <> b.commfar::text
UNION
SELECT 'facilfar' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.facilfar::text <> b.facilfar::text
UNION
SELECT 'borocode' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.borocode::text <> b.borocode::text
UNION
SELECT 'condono' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_mappluto b
ON a.bbl||'.00'::text=b.bbl::text
WHERE a.condono::text <> b.condono::text
)

SELECT * FROM countchange ORDER BY count DESC)


COPY(
SELECT * FROM pluto_qc_versioncomparisoncount ORDER BY count DESC
) TO '/prod/db-pluto/pluto_build/output/qc_versioncomparisoncount.csv' DELIMITER ',' CSV HEADER;