-- remove inactive records from the corrections file
DELETE FROM pluto_corrections
WHERE bbl NOT IN (SELECT bbl FROM pluto);