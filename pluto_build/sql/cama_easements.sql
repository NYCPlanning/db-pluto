-- set the number of easements associated with a lot
-- get a list of distinct easements for each lot
WITH distincteasements AS (
	SELECT DISTINCT b.boro||b.block||b.lot as bbl,
	easement
	FROM pluto_input_cama_dof b
	WHERE easement IS NOT NULL AND easement <> ' '
),
-- count the number of distinct easements for a lot
counteasements AS (
	SELECT bbl,
	COUNT(*) as numeasements
	FROM distincteasements b
	WHERE b.easement IS NOT NULL
	GROUP BY b.bbl
)
-- set the number of easements for the lot
UPDATE pluto a
SET easements = b.numeasements
FROM counteasements b
WHERE a.bbl = b.bbl;
-- for recrods whith no easement set number of easements to 0
UPDATE pluto
SET easements = '0'
WHERE easements IS NULL;