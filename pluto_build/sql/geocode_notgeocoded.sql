-- Reporting records that did not geocode
DROP TABLE IF EXISTS pluto_temp_qc_notgeocoded;
CREATE TABLE pluto_temp_qc_notgeocoded AS (
	SELECT  bbl,
			billingbbl,
			housenum_lo,
			street_name,
			stcode11,
			COUNT(*)
	FROM pluto_rpad_geo
	WHERE cd IS NULL AND bbl IS NOT NULL
	GROUP BY bbl, billingbbl, housenum_lo, street_name, stcode11
	ORDER BY bbl
);

\copy (SELECT * FROM pluto_temp_qc_notgeocoded) TO '/prod/db-pluto/pluto_build/output/qc_notgeocoded.csv' DELIMITER ',' CSV HEADER;
DROP TABLE IF EXISTS pluto_temp_qc_notgeocoded;