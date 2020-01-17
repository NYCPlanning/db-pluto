-- getting distinct BBLs FROM raw data
ALTER TABLE pluto_input_geocodes
RENAME bbl to geo_bbl;

ALTER TABLE pluto_input_geocodes
SET (parallel_workers=10);

UPDATE pluto_input_geocodes
SET xcoord = ST_X(ST_TRANSFORM(geom, 2263))::integer,
    ycoord = ST_Y(ST_TRANSFORM(geom, 2263))::integer,
    censustract2010 = (CASE 
                       WHEN censustract2010::numeric = 0 THEN NULL
                       ELSE censustract2010 END);

DROP TABLE IF EXISTS pluto_rpad_geo;
CREATE TABLE pluto_rpad_geo AS (
SELECT a.*, b.*
FROM (
	SELECT * FROM (
		SELECT a.*, ROW_NUMBER()
			OVER (PARTITION BY boro||tb||tl
			ORDER BY curavt_act::numeric DESC, land_area::numeric DESC, ease ASC) AS row_number
		FROM dof_pts_propmaster a) z
	WHERE row_number = 1) a
LEFT JOIN pluto_input_geocodes b
ON a.boro||a.tb||a.tl=b.borough||lpad(b.block,5,'0')||lpad(b.lot,4,'0'));

-- enable parallel_workers
ALTER TABLE pluto_rpad_geo
SET (parallel_workers=10);

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
	RENAME numberofexistingstructures TO numberOfExistingStructuresOnLot;

ALTER TABLE pluto_rpad_geo 
	RENAME sanitationcollectionscheduling TO sanitsub;
	
ALTER TABLE pluto_rpad_geo 
	RENAME taxmapnumbersectionandvolume TO taxmap;

ALTER TABLE pluto_rpad_geo 
	ADD sanitdistrict text,
	ADD ap_datef text;

UPDATE pluto_rpad_geo
	SET sanitdistrict = sanitationdistrict;

UPDATE pluto_rpad_geo
	SET bbl = borough||lpad(block,5,'0')||lpad(lot,4,'0');
    

UPDATE pluto_rpad_geo
	SET lfft = round(lfft::numeric, 2)::text,
		bfft = round(bfft::numeric, 2)::text,
		bdft = round(bdft::numeric, 2)::text;

UPDATE pluto_rpad_geo
	SET ldft = round(ldft::numeric, 2)::text
	WHERE ldft <> 'ACRE';

-- backfill X and Y coordinates
UPDATE pluto_rpad_geo a
SET xcoord = ST_X(ST_TRANSFORM(b.geom, 2263))::integer,
ycoord = ST_Y(ST_TRANSFORM(b.geom, 2263))::integer
FROM (
	SELECT a.bbl,
		ST_SetSRID(ST_MakePoint(a.longitude::double precision, a.latitude::double precision),4326) as geom
	FROM pluto_rpad_geo a
	WHERE a.longitude IS NOT NULL) b
WHERE a.bbl = b.bbl;