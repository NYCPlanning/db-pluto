-- Adding on data from allocated input table
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
FROM pluto_input_geocodes b
WHERE a.borocode||lpad(a.block, 5, '0')||lpad(a.lot, 4, '0') = b.boro::text||lpad(b.block::text, 5, '0')||lpad(b.lot::text, 4, '0');

--updating the building code if it was not updated in alloceted
UPDATE pluto a
SET bldgclass = b.bldg_cl
FROM pluto_input_geocodes b
WHERE a.borocode||lpad(a.block, 5, '0')||lpad(a.lot, 4, '0') = b.boro::text||lpad(b.block::text, 5, '0')||lpad(b.lot::text, 4, '0')
	AND bldgclass IS NULL;