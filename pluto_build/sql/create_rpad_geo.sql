-- getting distinct BBLs FROM raw data
DROP TABLE IF EXISTS pluto_rpad_geo;
CREATE TABLE pluto_rpad_geo AS (
WITH pluto_rpad_rownum AS (
	SELECT a.*, ROW_NUMBER()
    	OVER (PARTITION BY boro||tb||tl
      	ORDER BY curavt_act::numeric DESC, land_area::numeric DESC, ease ASC) AS row_number
  		FROM dof_pts_propmaster a),
pluto_rpad_sub AS (
	SELECT * 
	FROM pluto_rpad_rownum 
	WHERE row_number = 1)
SELECT a.*, b.*
FROM pluto_rpad_sub a
LEFT JOIN pluto_input_geocodes b
ON a.boro||a.tb||a.tl=b.borough||lpad(b.block,5,'0')||lpad(b.lot,4,'0')
);

ALTER TABLE pluto_rpad_geo 
RENAME communitydistrict TO cd;
ALTER TABLE pluto_rpad_geo 
RENAME censustract2010 TO ct2010;
ALTER TABLE pluto_rpad_geo 
RENAME censusblock2010 TO cb2010;
ALTER TABLE pluto_rpad_geo 
RENAME communityschooldistrict TO schooldist;
ALTER TABLE pluto_rpad_geo 
RENAME citycouncildistrict TO council;
ALTER TABLE pluto_rpad_geo 
RENAME firecompanynumber TO firecomp;
ALTER TABLE pluto_rpad_geo 
RENAME policeprecinct TO policeprct;
ALTER TABLE pluto_rpad_geo 
RENAME sanitationdistrict TO sanitdistrict;
ALTER TABLE pluto_rpad_geo 
RENAME numberofexistingstructures TO numberOfExistingStructuresOnLot;
ALTER TABLE pluto_rpad_geo 
RENAME sanitationcollectionscheduling TO sanitsub;
ALTER TABLE pluto_rpad_geo 
RENAME taxmapnumbersectionandvolume TO taxmap;
ALTER TABLE pluto_rpad_geo 
RENAME sanbornboroughcode TO sanboro;
ALTER TABLE pluto_rpad_geo 
RENAME sanbornpagenumber TO sanpage;
ALTER TABLE pluto_rpad_geo 
RENAME sanbornvolumenumber TO sanvol;
ALTER TABLE pluto_rpad_geo 
ADD bbl text;
ALTER TABLE pluto_rpad_geo 
ADD primebbl text;
ALTER TABLE pluto_rpad_geo 
ADD ap_datef text;
UPDATE pluto_rpad_geo
SET bbl = borough||lpad(block,5,'0')||lpad(lot,4,'0');

UPDATE pluto_rpad_geo
SET housenum_lo = NULL
WHERE housenum_lo = ' ';

UPDATE pluto_rpad_geo
SET street_name = NULL
WHERE street_name = ' ';
-- -- no longer need to do this because feet and inches are no longer split out
-- -- append the fraction of feet as a decimal place to feet for the 4 fields
-- UPDATE pluto_rpad_geo
-- SET lfft = lfft||'.'||lfin,
-- 	bfft = bfft||'.'||bfin,
-- 	bdft = bdft||'.'||bdin;

UPDATE pluto_rpad_geo
SET lfft = round(lfft::numeric, 2)::text,
	bfft = round(bfft::numeric, 2)::text,
	bdft = round(bdft::numeric, 2)::text;
-- -- no longer need to do this because feet and inches are no longer split out
-- -- do seperately for ldft because of Acre
-- UPDATE pluto_rpad_geo
-- SET ldft = ldft||'.'||ldin
-- WHERE ldft <> 'ACRE';

UPDATE pluto_rpad_geo
SET ldft = round(ldft::numeric, 2)::text
WHERE ldft <> 'ACRE';

-- backfill X and Y coordinates
WITH geoms AS (
	SELECT a.bbl,
		ST_SetSRID(ST_MakePoint(a.longitude::double precision, a.latitude::double precision),4326) as geom
	FROM pluto_rpad_geo a
	WHERE a.longitude IS NOT NULL)
UPDATE pluto_rpad_geo a
SET xcoord = ST_X(ST_TRANSFORM(geom, 2263))::integer,
ycoord = ST_Y(ST_TRANSFORM(geom, 2263))::integer
FROM geoms b
WHERE a.bbl = b.bbl;

-- -- create RPAD table that is run through Geoclient
-- DROP TABLE IF EXISTS pluto_rpad_geo;
-- CREATE TABLE pluto_rpad_geo AS (
-- SELECT a.*,
-- 	(CASE
-- 		WHEN a.boro = '1' THEN 'Manhattan'
-- 		WHEN a.boro = '2' THEN 'Bronx'
-- 		WHEN a.boro = '3' THEN 'Brooklyn'
-- 		WHEN a.boro = '4' THEN 'Queens'
-- 		WHEN a.boro = '5' THEN 'Staten Island'
-- 		ELSE NULL
-- 	END) AS borough
-- FROM pluto_rpad a
-- );

-- -- ALTER TABLE pluto_rpad_geo
-- -- ADD COLUMN bbl text,
-- -- ADD COLUMN billingbbl text,
-- -- ADD COLUMN giHighHouseNumber1 text,
-- -- ADD COLUMN giStreetName1 text,
-- -- ADD COLUMN boePreferredStreetName text,
-- -- ADD COLUMN buildingIdentificationNumber text,
-- -- ADD COLUMN numberOfExistingStructuresOnLot text,
-- -- ADD COLUMN cd text,
-- -- ADD COLUMN ct2010 text,
-- -- ADD COLUMN cb2010 text,
-- -- ADD COLUMN schooldist text,
-- -- ADD COLUMN council text,
-- -- ADD COLUMN zipcode text,
-- -- ADD COLUMN firecomp text,
-- -- ADD COLUMN policeprct text,
-- -- ADD COLUMN healthcenterdistrict text,
-- -- ADD COLUMN healtharea text,	
-- -- ADD COLUMN sanitboro text,
-- -- ADD COLUMN sanitdistrict text,
-- -- ADD COLUMN sanitsub text,
-- -- ADD COLUMN billingblock text,
-- -- ADD COLUMN billinglot text,
-- -- ADD COLUMN primebbl text,
-- -- ADD COLUMN ap_datef text,
-- -- ADD COLUMN geom geometry;

-- -- removing blanks
-- UPDATE pluto_rpad_geo
-- SET housenum_lo = NULL
-- WHERE housenum_lo = ' ';

-- UPDATE pluto_rpad_geo
-- SET street_name = NULL
-- WHERE street_name = ' ';

-- -- append the fraction of feet as a decimal place to feet for the 4 fields
-- UPDATE pluto_rpad_geo
-- SET lfft = lfft||'.'||lfin,
-- 	bfft = bfft||'.'||bfin,
-- 	bdft = bdft||'.'||bdin;

-- UPDATE pluto_rpad_geo
-- SET lfft = round(lfft::numeric, 2)::text,
-- 	bfft = round(bfft::numeric, 2)::text,
-- 	bdft = round(bdft::numeric, 2)::text;
-- -- do seperately for ldft because of Acre
-- UPDATE pluto_rpad_geo
-- SET ldft = ldft||'.'||ldin
-- WHERE ldft <> 'ACRE';

-- UPDATE pluto_rpad_geo
-- SET ldft = round(ldft::numeric, 2)::text
-- WHERE ldft <> 'ACRE';

-- using seprate pluto_input_geocodes from mainframe processing as input


