-- adding in unqique BBL information
INSERT INTO pluto (
	bbl,
	borocode,
	borough,
	block,
	lot
	)
SELECT
	b.boro||lpad(b.block, 5, '0')||lpad(b.lot, 4, '0'),
	b.boro,
	(CASE
		WHEN b.boro = '1' THEN 'MN'
		WHEN b.boro = '2' THEN 'BX'
		WHEN b.boro = '3' THEN 'BK'
		WHEN b.boro = '4' THEN 'QN'
		WHEN b.boro = '5' THEN 'SI'
		ELSE NULL
	END),
	trim(leading '0' FROM b.block),
	trim(leading '0' FROM b.lot)
FROM (SELECT DISTINCT boro, block, lot FROM pluto_input_allocated) AS b;