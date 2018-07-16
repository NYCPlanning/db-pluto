-- Setting the lot area (land_area) field in pluto_rpad_geo
-- if lot area = 0 or is NULL and if lot is not irregular and 
-- and if lot depth and lot front have valid values then 
-- multiply lot front x lot depth to get lot area
UPDATE pluto_rpad_geo
SET land_area = lfft::double precision * ldft::double precision
FROM pluto_rpad_geo a
WHERE (a.land_area IS NULL OR a.land_area = '0') 
	AND a.irreg <> 'I'
	AND a.lfft ~ '[0-9]' 
	AND a.ldft ~ '[0-9]'
	AND a.lfft::double precision > 0 
	AND a.ldft::double precision > 0;

-- if lot area = 0 or is NULL 
-- and lot depth =  ACRE 
-- then lot area = lot front x 43560 + .5
UPDATE pluto_rpad_geo
SET land_area = lfft::double precision * 43560 + 0.5
FROM pluto_rpad_geo a
WHERE (a.land_area IS NULL OR a.land_area = '0')
	AND upper(ldft) LIKE '%ACRE%'
	AND a.lfft ~ '[0-9]'
	AND a.lfft::double precision > 0;