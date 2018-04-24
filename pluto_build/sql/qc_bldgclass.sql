COPY(
	SELECT bldg_cl,
		COUNT(*),
		(CASE
			WHEN bldg_cl NOT IN (SELECT DISTINCT bldgclass FROM pluto_input_landuse_bldgclass) THEN 'NEW'
			ELSE NULL
		END) AS new
	FROM pluto_input_allocated
	GROUP BY bldg_cl
	ORDER BY bldg_cl
)TO '/prod/db-pluto/pluto_build/output/qc_bldgclass.csv' DELIMITER ',' CSV HEADER;
