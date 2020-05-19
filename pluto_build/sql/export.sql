DROP TABLE IF EXISTS export_pluto;
SELECT
	borough::varchar(2),
	block::integer,
	lot::smallint,
	cd::smallint,
	ct2010::varchar(7),
	cb2010::varchar(5),
	schooldist::varchar(3),
	council::smallint,
	zipcode::smallint,
	firecomp::varchar(4),
	policeprct::smallint,
	healthcenterdistrict::smallint,
	healtharea::smallint,
	sanitboro::varchar(2),
	SanitDistrict::varchar(2),
	sanitsub::varchar(2),
	address::varchar(39),
	zonedist1::varchar(9),
	zonedist2::varchar(9),
	zonedist3::varchar(9),
	zonedist4::varchar(9),
	overlay1::varchar(4),
	overlay2::varchar(4),
	spdist1::varchar(12),
	spdist2::varchar(12),
	spdist3::varchar(12),
	ltdheight::varchar(5),
	splitzone::varchar(1),
	bldgclass::varchar(2),
	landuse::varchar(2),
	easements::smallint,
	ownertype::varchar(1),
	ownername::varchar(85),
	lotarea::numeric::integer,
	bldgarea::numeric::integer,
	comarea::numeric::integer,
	resarea::numeric::integer,
	officearea::numeric::integer,
	retailarea::numeric::integer,
	garagearea::numeric::integer,
	strgearea::numeric::integer,
	factryarea::numeric::integer,
	otherarea::numeric::integer,
	areasource::varchar(1),
	numbldgs::smallint,
	numfloors::double precision,
	unitsres::smallint,
	unitstotal::smallint,
	lotfront::double precision,
	lotdepth::double precision,
	bldgfront::double precision,
	bldgdepth::double precision,
	ext::varchar(2),
	proxcode::varchar(1),
	irrlotcode::varchar(1),
	lottype::varchar(1),
	bsmtcode::varchar(1),
	assessland::double precision,
	assesstot::double precision,
	exempttot::double precision,
	yearbuilt::smallint,
	yearalter1::smallint,
	yearalter2::smallint,
	histdist::varchar(66),
	landmark::varchar(150),
	BuiltFAR::double precision,
	ResidFAR::double precision,
	CommFAR::double precision,
	FacilFAR::double precision,
	BoroCode::smallint,
	BBL::double precision,
	CondoNo::smallint,
	Tract2010::varchar(7),
	round(XCoord::numeric)::integer as XCoord,
	round(YCoord::numeric)::integer as YCoord,
	ZoneMap::varchar(3),
	ZMCode::varchar(1),
	Sanborn::varchar(8),
	TaxMap::varchar(5),
	EDesigNum::varchar(5),
	APPBBL::double precision,
	APPDate::varchar(10),
	PLUTOMapID::varchar(1),
	FIRM07_FLAG::varchar(1),
	PFIRM15_FLAG::varchar(1),
	Version::varchar(6),
	DCPEdited::varchar(3),
	latitude::double precision,
	Longitude::double precision,
	Notes::varchar(20)
INTO export_pluto
FROM pluto;

DROP TABLE IF EXISTS mappluto_unclipped;
SELECT 
	a.*, 
	st_makevalid(b.geom_2263) as geom
INTO mappluto_unclipped
FROM export_pluto a, pluto_geom b
WHERE b.geom_2263 IS NOT NULL
AND a.bbl::bigint = b.bbl::bigint;

DROP TABLE IF EXISTS mappluto;
SELECT
	a.*, 
	st_makevalid(b.clipped_2263) as geom
INTO mappluto
FROM export_pluto a, pluto_geom b
WHERE b.clipped_2263 IS NOT NULL
AND a.bbl::bigint = b.bbl::bigint;

DROP TABLE IF EXISTS archive_pluto;
SELECT a.*, b.clipped_4326 as geom
INTO archive_pluto
FROM export_pluto a
LEFT JOIN pluto_geom b
on a.bbl::bigint = b.bbl::bigint;