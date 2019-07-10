DROP TABLE IF EXISTS pluto_input_cama;
CREATE TABLE pluto_input_cama AS (
SELECT a.*, b.billingbbl
FROM pluto_input_cama_dof a
LEFT JOIN pluto_input_geocodes b
ON LEFT(a.bbl,10)=b.borough||lpad(b.block,5,'0')||lpad(b.lot,4,'0')
);

ALTER TABLE pluto_input_cama
ADD COLUMN primebbl text;

UPDATE pluto_input_cama
SET primebbl = billingbbl
WHERE billingbbl IS NOT NULL AND billingbbl <> '0000000000';
-- assign prime bbl for noncondo lots
UPDATE pluto_input_cama
SET primebbl = LEFT(bbl,10)
WHERE primebbl IS NULL;