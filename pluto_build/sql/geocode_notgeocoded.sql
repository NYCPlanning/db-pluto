-- Reporting records that did not geocode
CREATE TABLE pluto_temp_qc_notgeocoded AS (
	SELECT  boro||tb||tl AS bbl,
			billingbbl,
			buildingIdentificationNumber AS bin,
			giHighHouseNumber1 AS housenumber,
			giStreetName1 AS streetname,
			stcode11,
			owner,
			COUNT(*)
	FROM pluto_rpad_geo
	WHERE geom IS NULL AND cd IS NULL
	GROUP BY boro||tb||tl, billingbbl, buildingIdentificationNumber, giHighHouseNumber1, giStreetName1, stcode11, owner
	ORDER BY bbl
);

\copy (SELECT * FROM pluto_temp_qc_notgeocoded) TO '/prod/db-pluto/pluto_build/output/qc_notgeocoded.csv' DELIMITER ',' CSV HEADER;
DROP TABLE IF EXISTS pluto_temp_qc_notgeocoded;