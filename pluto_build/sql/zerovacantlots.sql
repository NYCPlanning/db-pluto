-- Zeroing out values for vacant land
-- If vacant building and AV land = AV total 
-- then zero out building frontage, building debth, num stories, and number of buildings
SELECT COUNT(*) 
UPDATE pluto_rpad_geo a
SET bfft = '0',
	bdft = '0',
	story = '0',
	bldgs = '0'
WHERE a.curavl = a.curavl AND upper(bldgcl) LIKE 'V%';