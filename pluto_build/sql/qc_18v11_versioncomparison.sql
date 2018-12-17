-- compare two versions of pluto be calculating how many field values are differnt for the same lot between versions
-- drop existing output table
DROP TABLE IF EXISTS pluto_18v11_qc_versioncomparisoncount;
-- input the versions of pluto that you'd like to compare
CREATE TABLE pluto_18v11_qc_versioncomparisoncount AS (
	WITH pluto AS (SELECT * FROM dcp_pluto_18v11),
dcp_pluto AS (SELECT * FROM dcp_pluto_18v11_final),
countchange AS (
SELECT 'borough' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.borough <> b.borough
UNION
SELECT 'block' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.block <> b.block
UNION
SELECT 'lot' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.lot <> b.lot
UNION
SELECT 'cd' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.cd <> b.cd
UNION
SELECT 'ct2010' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.ct2010 <> b.ct2010
UNION
SELECT 'cb2010' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.cb2010 <> b.cb2010
UNION
SELECT 'schooldist' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.schooldist <> b.schooldist
UNION
SELECT 'council' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.council <> b.council
UNION
SELECT 'zipcode' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.zipcode <> b.zipcode
UNION
SELECT 'firecomp' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.firecomp <> b.firecomp
UNION
SELECT 'policeprct' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.policeprct <> b.policeprct
UNION
SELECT 'healthcenterdistrict' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.healthcenterdistrict <> b.healthcenterdistrict
UNION
SELECT 'healtharea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.healtharea <> b.healtharea
UNION
SELECT 'sanitboro' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.sanitboro <> b.sanitboro
UNION
SELECT 'sanitdistrict' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.sanitdistrict <> b.sanitdistrict
UNION
SELECT 'sanitsub' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.sanitsub <> b.sanitsub
UNION
SELECT 'address' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.address <> b.address
UNION
SELECT 'zonedist1' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.zonedist1 <> b.zonedist1
UNION
SELECT 'zonedist2' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.zonedist2 <> b.zonedist2
UNION
SELECT 'zonedist3' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.zonedist3 <> b.zonedist3
UNION
SELECT 'zonedist4' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.zonedist4 <> b.zonedist4
UNION
SELECT 'overlay1' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.overlay1 <> b.overlay1
UNION
SELECT 'overlay2' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.overlay2 <> b.overlay2
UNION
SELECT 'spdist1' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.spdist1 <> b.spdist1
UNION
SELECT 'spdist2' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.spdist2 <> b.spdist2
UNION
SELECT 'spdist3' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.spdist3 <> b.spdist3
UNION
SELECT 'ltdheight' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.ltdheight <> b.ltdheight
UNION
SELECT 'splitzone' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.splitzone <> b.splitzone
UNION
SELECT 'bldgclass' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.bldgclass <> b.bldgclass
UNION
SELECT 'landuse' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.landuse <> b.landuse
UNION
SELECT 'easements' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.easements <> b.easements
UNION
SELECT 'ownertype' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.ownertype <> b.ownertype
UNION
SELECT 'ownername' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.ownername <> b.ownername
UNION
SELECT 'lotarea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.lotarea <> b.lotarea
UNION
SELECT 'bldgarea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.bldgarea <> b.bldgarea
UNION
SELECT 'comarea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.comarea <> b.comarea
UNION
SELECT 'resarea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.resarea <> b.resarea
UNION
SELECT 'officearea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.officearea <> b.officearea
UNION
SELECT 'retailarea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.retailarea <> b.retailarea
UNION
SELECT 'garagearea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.garagearea <> b.garagearea
UNION
SELECT 'strgearea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.strgearea <> b.strgearea
UNION
SELECT 'factryarea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.factryarea <> b.factryarea
UNION
SELECT 'otherarea' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.otherarea <> b.otherarea
UNION
SELECT 'areasource' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.areasource <> b.areasource
UNION
SELECT 'numbldgs' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.numbldgs <> b.numbldgs
UNION
SELECT 'numfloors' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.numfloors <> b.numfloors
UNION
SELECT 'unitsres' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.unitsres <> b.unitsres
UNION
SELECT 'unitstotal' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.unitstotal <> b.unitstotal
UNION
SELECT 'lotfront' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.lotfront <> b.lotfront
UNION
SELECT 'lotdepth' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.lotdepth <> b.lotdepth
UNION
SELECT 'bldgfront' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.bldgfront <> b.bldgfront
UNION
SELECT 'bldgdepth' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.bldgdepth <> b.bldgdepth
UNION
SELECT 'ext' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.ext <> b.ext
UNION
SELECT 'proxcode' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.proxcode <> b.proxcode
UNION
SELECT 'irrlotcode' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.irrlotcode <> b.irrlotcode
UNION
SELECT 'lottype' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.lottype <> b.lottype
UNION
SELECT 'bsmtcode' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.bsmtcode <> b.bsmtcode
UNION
SELECT 'assessland' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.assessland <> b.assessland
UNION
SELECT 'assesstot' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.assesstot <> b.assesstot
UNION
SELECT 'exemptland' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.exemptland <> b.exemptland
UNION
SELECT 'exempttot' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.exempttot <> b.exempttot
UNION
SELECT 'yearbuilt' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.yearbuilt <> b.yearbuilt
UNION
SELECT 'yearalter1' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.yearalter1 <> b.yearalter1
UNION
SELECT 'yearalter2' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.yearalter2 <> b.yearalter2
UNION
SELECT 'histdist' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.histdist <> b.histdist
UNION
SELECT 'landmark' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.landmark <> b.landmark
UNION
SELECT 'builtfar' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.builtfar <> b.builtfar
UNION
SELECT 'residfar' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE round(a.residfar::numeric,2) <> round(b.residfar::numeric,2)
UNION
SELECT 'commfar' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE round(a.commfar::numeric,2) <> round(b.commfar::numeric,2)
UNION
SELECT 'facilfar' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE round(a.facilfar::numeric,2) <> round(b.facilfar::numeric,2)
UNION
SELECT 'borocode' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.borocode <> b.borocode
UNION
SELECT 'condono' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.condono <> b.condono
UNION
SELECT 'tract2010' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.tract2010 <> b.tract2010
UNION
SELECT 'xcoord' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.xcoord <> b.xcoord
UNION
SELECT 'ycoord' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.ycoord <> b.ycoord
UNION
SELECT 'zonemap' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.zonemap <> b.zonemap
UNION
SELECT 'zmcode' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.zmcode <> b.zmcode
UNION
SELECT 'sanborn' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.sanborn <> b.sanborn
UNION
SELECT 'taxmap' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.taxmap <> b.taxmap
UNION
SELECT 'edesignum' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.edesignum <> b.edesignum
UNION
SELECT 'appbbl' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.appbbl <> b.appbbl
UNION
SELECT 'appdate' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.appdate <> b.appdate
UNION
SELECT 'plutomapid' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.plutomapid <> b.plutomapid
UNION
SELECT 'firm07_flag' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.firm07_flag <> b.firm07_flag
UNION
SELECT 'pfirm15_flag' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.pfirm15_flag <> b.pfirm15_flag
UNION
SELECT 'version' AS field, COUNT(*)
FROM pluto a
INNER JOIN dcp_pluto b
ON a.bbl=b.bbl
WHERE a.version <> b.version
)
SELECT * FROM countchange ORDER BY count DESC
);

-- write to an output file
-- set the denominator
\copy (SELECT a.field, a.count, round(((a.count::double precision/857536)*100)::numeric,2) AS percentmismatch FROM pluto_18v11_qc_versioncomparisoncount a ORDER BY count DESC) TO '/prod/db-pluto/pluto_build/output/pluto_18v11_qc_versioncomparisoncount.csv' DELIMITER ',' CSV HEADER;

