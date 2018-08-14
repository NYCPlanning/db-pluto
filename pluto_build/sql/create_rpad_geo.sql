-- create RPAD table that is run through Geoclient
DROP TABLE IF EXISTS pluto_rpad_geo;
CREATE TABLE pluto_rpad_geo AS (
SELECT a.*,
	(CASE
		WHEN a.boro = '1' THEN 'Manhattan'
		WHEN a.boro = '2' THEN 'Bronx'
		WHEN a.boro = '3' THEN 'Brooklyn'
		WHEN a.boro = '4' THEN 'Queens'
		WHEN a.boro = '5' THEN 'Staten Island'
		ELSE NULL
	END) AS borough
FROM pluto_rpad a
);

ALTER TABLE pluto_rpad_geo
ADD COLUMN bbl text,
ADD COLUMN billingbbl text,
ADD COLUMN giHighHouseNumber1 text,
ADD COLUMN giStreetName1 text,
ADD COLUMN boePreferredStreetName text,
ADD COLUMN buildingIdentificationNumber text,
ADD COLUMN numberOfExistingStructuresOnLot text,
ADD COLUMN cd text,
ADD COLUMN ct2010 text,
ADD COLUMN cb2010 text,
ADD COLUMN schooldist text,
ADD COLUMN council text,
ADD COLUMN zipcode text,
ADD COLUMN firecomp text,
ADD COLUMN policeprct text,
ADD COLUMN healthcenterdistrict text,
ADD COLUMN healtharea text,	
ADD COLUMN sanitboro text,
ADD COLUMN sanitdistrict text,
ADD COLUMN sanitsub text,
ADD COLUMN billingblock text,
ADD COLUMN billinglot text,
ADD COLUMN primebbl text,
ADD COLUMN ap_datef text,
ADD COLUMN geom geometry;

UPDATE pluto_rpad_geo
SET housenum_lo = NULL
WHERE housenum_lo = ' ';

UPDATE pluto_rpad_geo
SET street_name = NULL
WHERE street_name = ' ';