-- assign the prime BBL to each RPAD record
-- assign prime bbl for condo records
UPDATE rpad_pluto_geo
SET primebbl = billingbbl
WHERE billingbbl IS NOT NULL AND billingbbl <> '0000000000';
-- assign prime bbl for noncondo lots
UPDATE rpad_pluto_geo
SET primebbl = boro||tb||tl
WHERE primebbl IS NULL;