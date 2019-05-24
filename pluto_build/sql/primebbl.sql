-- assign the prime BBL to each PTS collapsed record
-- assign prime bbl for condo records
UPDATE pluto_rpad_geo
SET primebbl = billingbbl
WHERE billingbbl IS NOT NULL AND billingbbl <> '0000000000';
-- assign prime bbl for noncondo lots
UPDATE pluto_rpad_geo
SET primebbl = boro||tb||tl
WHERE primebbl IS NULL;

-- assign the prime BBL to each PTS record
-- assign prime bbl for condo records
UPDATE dof_pts_propmaster a
SET primebbl = b.billingbbl
FROM pluto_input_geocodes b
WHERE a.boro||a.tb||a.tl=b.borough||lpad(b.block,5,'0')||lpad(b.lot,4,'0')
AND b.billingbbl IS NOT NULL AND billingbbl <> '0000000000';
-- assign prime bbl for noncondo lots
UPDATE dof_pts_propmaster
SET primebbl = boro||tb||tl
WHERE primebbl IS NULL;