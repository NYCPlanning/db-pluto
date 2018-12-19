-- Code of 1 means that some portion of the tax lot falls within the 1% annual chance floodplain
-- using defs from here https://snmapmod.snco.us/fmm/document/fema-flood-zone-definitions.pdf

-- for 2007 floodplain
WITH floodplain AS (
	SELECT *
	FROM fema_firms2007_100yr b
	WHERE (b.fld_zone <> 'X' AND b.fld_zone <> 'AE')
)
UPDATE pluto a
SET firm07_flag = '1'
FROM floodplain b
WHERE ST_Intersects(a.geom,b.geom);

-- for 2015 p floodplain
WITH floodplain AS (
	SELECT *
	FROM fema_pfirms2015_100yr b
	WHERE (b.fld_zone <> 'X' AND b.fld_zone <> 'AE')
)
UPDATE pluto a
SET pfirm15_flag = '1'
FROM floodplain b
WHERE ST_Intersects(a.geom,b.geom);