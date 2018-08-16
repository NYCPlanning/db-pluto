-- report instances where the lot area has changed for the same lot between RPAD versions
-- could indicate an error
CREATE TABLE qc_lotarea AS (
SELECT a.boro||lpad(a.tb, 5, '0')||lpad(a.block, 4, '0') as bbl
	a.land_area, 
	b.land_area, 
	a.land_area::double precision - b.land_area::double precision AS difference,
	COUNT(*)
FROM pluto_rpad a
INNER JOIN pluto_rpad_prev b
ON a.boro||lpad(a.tb, 5, '0')||lpad(a.block, 4, '0')=a.boro||lpad(b.tb, 5, '0')||lpad(b.block, 4, '0')
WHERE a.land_area <> b.land_area
GROUP BY a.boro,lpad(a.tb, 5, '0'),lpad(a.block, 4, '0'), a.land_area, b.land_area
);

\copy (SELECT * FROM qc_lotarea) TO '/prod/db-pluto/pluto_build/output/qc_lotarea.csv' DELIMITER ',' CSV HEADER;
DROP TABLE qc_lotarea;