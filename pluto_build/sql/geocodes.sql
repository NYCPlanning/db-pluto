-- Adding on data from geocodes input table
-- might need to get fire company type
UPDATE pluto a
SET cd = b.cd,
	ct2010 = b.ct2010,
	tract2010 = b.ct2010,
	cb2010 = b.cb2010,
	schooldist = b.schooldist,
	council = b.council,
	zipcode = b.zipcode,
	firecomp = b.firecomp,
	policeprct = b.policeprct,
	healthcenterdistrict = b.healthcenterdistrict,
	healtharea = b.healtharea,
	sanitdistrict = b.sanitdistrict,
	sanitsub = b.sanitsub,
	taxmap = b.taxmap,
	sanborn = b.sanboro||b.sanpage||b.sanvol,
	address = trim(leading '0' FROM b.housenum_lo)||' '||b.street_name
FROM pluto_rpad_geo b
WHERE a.bbl = b.primebbl;

--updating the building code if it was not updated in alloceted
UPDATE pluto a
SET bldgclass = b.bldgcl
FROM pluto_rpad_geo b
WHERE a.bbl = b.primebbl
	AND bldgclass IS NULL;