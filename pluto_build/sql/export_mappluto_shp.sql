DROP TABLE IF EXISTS :TABLE;
SELECT
	a.borough as "Borough",
	a.block as "Block",
	a.lot as "Lot",
	a.cd as "CD",
	a.ct2010 as "CT2010",
	a.cb2010 as "CB2010",
	a.schooldist as "SchoolDist",
	a.council as "Council",
	a.zipcode as "ZipCode",
	a.firecomp as "FireComp",
	a.policeprct as "PolicePrct",
	a.healthcenterdistrict as "HealthCenterDistrict",
	a.healtharea as "HealthArea",
	a.sanitboro as "Sanitboro",
	a.sanitdistrict as "SanitDistrict",
	a.sanitsub as "SanitSub",
	a.address as "Address",
	a.zonedist1 as "ZoneDist1",
	a.zonedist2 as "ZoneDist2",
	a.zonedist3 as "ZoneDist3",
	a.zonedist4 as "ZoneDist4",
	a.overlay1 as "Overlay1",
	a.overlay2 as "Overlay2",
	a.spdist1 as "SPDist1",
	a.spdist2 as "SPDist2",
	a.spdist3 as "SPDist3",
	a.ltdheight as "LtdHeight",
	a.splitzone as "SplitZone",
	a.bldgclass as "BldgClass",
	a.landuse as "LandUse",
	a.easements as "Easements",
	a.ownertype as "OwnerType",
	a.ownername as "OwnerName",
	a.lotarea as "LotArea",
	a.bldgarea as "BldgArea",
	a.comarea as "ComArea",
	a.resarea as "ResArea",
	a.officearea as "OfficeArea",
	a.retailarea as "RetailArea",
	a.garagearea as "GarageArea",
	a.strgearea as "StrgeArea",
	a.factryarea as "FactryArea",
	a.otherarea as "OtherArea",
	a.areasource as "AreaSource",
	a.numbldgs as "NumBldgs",
	a.numfloors as "NumFloors",
	a.unitsres as "UnitsRes",
	a.unitstotal as "UnitsTotal",
	a.lotfront as "LotFront",
	a.lotdepth as "LotDepth",
	a.bldgfront as "BldgFront",
	a.bldgdepth as "BldgDepth",
	a.ext as "Ext",
	a.proxcode as "ProxCode",
	a.irrlotcode as "IrrLotCode",
	a.lottype as "LotType",
	a.bsmtcode as "BsmtCode",
	a.assessland as "AssessLand",
	a.assesstot as "AssessTot",
	a.exempttot as "ExemptTot",
	a.yearbuilt as "YearBuilt",
	a.yearalter1 as "YearAlter1",
	a.yearalter2 as "YearAlter2",
	a.histdist as "HistDist",
	a.landmark as "Landmark",
	a.builtfar as "BuiltFAR",
	a.residfar as "ResidFAR",
	a.commfar as "CommFAR",
	a.facilfar as "FacilFAR",
	a.borocode as "BoroCode",
	a.bbl as "BBL",
	a.condono as "CondoNo",
	a.tract2010 as "Tract2010",
	a.xcoord as "XCoord",
	a.ycoord as "YCoord",
	a.zonemap as "ZoneMap",
	a.zmcode as "ZMCode",
	a.sanborn as "Sanborn",
	a.taxmap as "TaxMap",
	a.edesignum as "EDesigNum",
	a.appbbl as "APPBBL",
	a.appdate as "APPDate",
	a.plutomapid as "PLUTOMapID",
	a.firm07_flag as "FIRM07_FLAG",
	a.pfirm15_flag as "PFIRM15_FLAG",
	a.version as "Version",
	a.dcpedited as "DCPEdited",
	a.latitude as "Latitude",
	a.longitude as "Longitude",
	a.notes as "Notes",
	round(st_length(b.:GEOM)::numeric,11)::numeric(19,7) as "Shape_Leng",
	round(st_area(b.:GEOM)::numeric,11)::numeric(19,7) as "Shape_Area",
	st_makevalid(b.:GEOM) as geom
INTO :TABLE
FROM export_pluto a, pluto_geom b
WHERE b.:GEOM IS NOT NULL
AND a.bbl::bigint = b.bbl::bigint;

ALTER TABLE :TABLE ALTER COLUMN "Borough" SET NOT NULL;
ALTER TABLE :TABLE ALTER COLUMN "Block" SET NOT NULL;
ALTER TABLE :TABLE ALTER COLUMN "Lot" SET NOT NULL;
ALTER TABLE :TABLE ALTER COLUMN "BBL" SET NOT NULL;
ALTER TABLE :TABLE ALTER COLUMN "BoroCode" SET NOT NULL;