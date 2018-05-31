-- using doitt_buildingfootprints checking the year built field 
-- based on 
COPY(
WITH freq_cnstrctyr AS (
	SELECT bbl, cnstrct_yr, freq
  	FROM (SELECT bbl, cnstrct_yr, freq, ROW_NUMBER() OVER (PARTITION BY bbl ORDER BY freq DESC) AS rn
  			FROM (SELECT bbl, cnstrct_yr, COUNT('x') AS freq
                  FROM doitt_buildingfootprints
                  WHERE cnstrct_yr <> 0 AND cnstrct_yr IS NOT NULL
                  GROUP BY 1, 2) cnstrctyr_freq) ranked_cnstrctyr
  	WHERE rn = 1)
SELECT a.bbl, a.yearbuilt, b.cnstrct_yr, b.freq, (yearbuilt::numeric - cnstrct_yr::numeric) AS difference
FROM pluto a, freq_cnstrctyr b
WHERE a.bbl=b.bbl AND a.yearbuilt<>b.cnstrct_yr::text
ORDER BY difference DESC
) TO '/prod/db-pluto/pluto_build/output/qc_yearbuilt.csv' DELIMITER ',' CSV HEADER;