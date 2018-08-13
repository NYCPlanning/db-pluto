-- Adding on data from geocodes input table
UPDATE pluto a
SET cd = b.borocode||b.cd,
	ct2010 = b.census_tract_2010,
	cb2010 = b.census_block_2010,
	schooldist = b.school_dstrict,
	council = b.cc_district,
	zipcode = b.zipcode,
	firecomp = b.fire_company_type||b.fire_company_num,
	policeprct = b.police_prct,
	healthcenterdistrict = b.health_center_district,
	healtharea = b.health_area,
	sanitboro = b.sanitation_district_boro,
	sanitdistrict = b.sanitation_district,
	sanitsub = b.sanitation_subsection,
	address = trim(leading '0' FROM b.hsnum)||' '||b.stname
FROM pluto_rpad_geo b
WHERE a.bbl = b.primebbl;

--updating the building code if it was not updated in alloceted
UPDATE pluto a
SET bldgclass = b.bldg_cl
FROM pluto_rpad_geo b
WHERE a.bbl = b.primebbl
	AND bldgclass IS NULL;