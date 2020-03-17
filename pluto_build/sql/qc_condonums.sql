 -- report zero or missing condo numbers
 -- these records need to be corrected
 CREATE TABLE qc_condonums AS (
	 SELECT * 
	 FROM pluto_rpad 
	 WHERE tl::double precision > 1000
		 AND (ease IS NULL OR ease = ' ' OR ease = '')
		 AND (bldgcl LIKE '%R%' OR bldgcl IS NULL OR bldgcl = ' ')
		 AND (condo_number = '0' OR condo_number IS NULL OR condo_number = ' ')
		 );
 
 \copy (SELECT * FROM qc_condonums) TO 'output/qc_condonums.csv' DELIMITER ',' CSV HEADER;

DROP TABLE qc_condonums;