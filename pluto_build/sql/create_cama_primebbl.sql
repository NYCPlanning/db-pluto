DROP TABLE IF EXISTS pluto_input_cama;
CREATE TABLE pluto_input_cama AS (
SELECT a.*, b.billingbbl
FROM pluto_input_cama_dof a
LEFT JOIN pluto_input_geocodes b
ON a.boro||a.block||a.lot=b.borough||lpad(b.block,5,'0')||lpad(b.lot,4,'0')
);

ALTER TABLE pluto_input_cama
ADD COLUMN primebbl text;

UPDATE pluto_input_cama
SET primebbl = billingbbl
WHERE billingbbl IS NOT NULL AND billingbbl <> '0000000000';
-- assign prime bbl for noncondo lots
UPDATE pluto_input_cama
SET primebbl = boro||block||lot
WHERE primebbl IS NULL;