-- if the lot is in a historical district add in the name of the Historic District from lpc_historic_districts
-- concatenates historic districts seperated by a comma for lots within more than one Historic District 
UPDATE pluto a
SET histdist = c.hist_dist_list
FROM (SELECT b.bbl, string_agg(b.hist_dist, ', ') AS hist_dist_list
		FROM  (
			SELECT DISTINCT bbl, hist_dist 
			FROM lpc_historic_districts) AS b
	WHERE hist_dist <> '0'
	GROUP BY b.bbl) c
WHERE a.borocode||lpad(a.block, 5, '0')||lpad(a.lot, 4, '0') = c.bbl;

-- if the lot contains a landmark add in the name of the landmark from lpc_landmarks
-- concatenates landmark names seperated by a comma for lots with more than one landmark
UPDATE pluto a
SET landmark = c.lm_name_list
FROM (SELECT b.bbl, string_agg(b.lm_name, ', ') AS lm_name_list
		FROM (
			SELECT DISTINCT bbl, lm_name 
			FROM lpc_landmarks) AS b
		GROUP BY b.bbl) c
WHERE a.borocode||lpad(a.block, 5, '0')||lpad(a.lot, 4, '0') = c.bbl;