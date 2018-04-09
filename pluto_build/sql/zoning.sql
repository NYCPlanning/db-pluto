-- add in zoning information from dcp_zoning_taxlot database
UPDATE pluto 
SET 
	zonedist1 = zoningdistrict1,
	zonedist2 = zoningdistrict2,
	zonedist3 = zoningdistrict3,
	zonedist4 = zoningdistrict4,
	overlay1 = commercialoverlay1,
	overlay2 = commercialoverlay2,
	spdist1 = specialdistrict1,
	spdist2 = specialdistrict2,
	spdist3 = specialdistrict3,
	ltdheight = limitedheightdistrict,
	zonemap = zoningmapnumber,
	zmcode = zoningmapcode
FROM dcp_zoning_taxlot
WHERE borocode||lpad(block, 5, '0')||lpad(lot, 4, '0') = boroughcode::text||lpad(taxblock::text, 5, '0')||lpad(taxlot::text, 4, '0');

-- calculate if tax lot is split by two or more zoning boundary lines and update splitzone
UPDATE pluto 
SET splitzone = 'Y'
WHERE zonedist2 IS NOT NULL OR overlay2 IS NOT NULL OR spdist2 IS NOT NULL;

UPDATE pluto 
SET splitzone = 'N'
WHERE splitzone IS NULL AND zonedist1 IS NOT NULL;
