-- get the frequency of the building codes from DOF RPAD data and 
-- flag any building codes that do not appear in pluto_input_landuse_bldgclass
COPY(
	SELECT bldgcl,
		COUNT(*),
		(CASE
			WHEN bldgcl NOT IN (SELECT DISTINCT bldgclass FROM pluto_input_landuse_bldgclass) THEN 'NEW'
			ELSE NULL
		END) AS new
	FROM pluto_rpad
	GROUP BY bldgcl
	ORDER BY bldgcl
)TO '/prod/db-pluto/pluto_build/output/qc_bldgclass.csv' DELIMITER ',' CSV HEADER;