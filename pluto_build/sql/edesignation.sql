-- set the E Designation number
-- if there is more than one enumber for one lot take the enumber from the lowest ceqr_num and ulurp_num
WITH edesignation AS (
	SELECT bbl, enumber 
	FROM (
		SELECT bbl, enumber, ROW_NUMBER()
    	OVER (PARTITION BY bbl
      	ORDER BY ceqr_num, ulurp_num) AS row_number
  		FROM dcp_edesignation) x
	WHERE x.row_number = 1)

UPDATE pluto a
SET edesignum = b.enumber
FROM edesignation b 
WHERE a.bbl||'.00'=b.bbl::text;