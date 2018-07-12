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
LIMIT 100
);

ALTER TABLE pluto_rpad_geo
ADD bbl text;
ALTER TABLE pluto_rpad_geo
ADD billingbbl text;
ALTER TABLE pluto_rpad_geo
ADD giHighHouseNumber text;
ALTER TABLE pluto_rpad_geo
ADD giStreetCode text;
ALTER TABLE pluto_rpad_geo
ADD rpadBldgClass text;
ALTER TABLE pluto_rpad_geo
ADD numBldgs text;
ALTER TABLE pluto_rpad_geo
ADD geom geometry;