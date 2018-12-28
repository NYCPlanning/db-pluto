-- if a lot did not get assigned service areas through Geosupport assign service areas spatially

UPDATE pluto a
SET cd = b.borocd
FROM dcp_cdboundaries b
WHERE ST_Within(ST_Transform(ST_SetSRID(ST_MakePoint(a.xcoord::double precision,a.ycoord::double precision),2263), 4326),b.geom)
AND a.cd IS NULL
AND a.xcoord IS NOT NULL;

UPDATE pluto a
SET ct2010 = b.ct2010,
tract2010 = b.ct2010
FROM dcp_censustracts b
WHERE ST_Within(ST_Transform(ST_SetSRID(ST_MakePoint(a.xcoord::double precision,a.ycoord::double precision),2263), 4326),b.geom)
AND a.ct2010 IS NULL
AND a.xcoord IS NOT NULL;

UPDATE pluto a
SET cb2010 = b.cb2010
FROM dcp_censusblocks b
WHERE ST_Within(ST_Transform(ST_SetSRID(ST_MakePoint(a.xcoord::double precision,a.ycoord::double precision),2263), 4326),b.geom)
AND a.cb2010 IS NULL
AND a.xcoord IS NOT NULL;

UPDATE pluto a
SET schooldist = b.schooldist
FROM dcp_school_districts b
WHERE ST_Within(ST_Transform(ST_SetSRID(ST_MakePoint(a.xcoord::double precision,a.ycoord::double precision),2263), 4326),b.geom)
AND a.schooldist IS NULL
AND a.xcoord IS NOT NULL;

UPDATE pluto a
SET council = ltrim(b.coundist::text, '0')
FROM dcp_councildistricts b
WHERE ST_Within(ST_Transform(ST_SetSRID(ST_MakePoint(a.xcoord::double precision,a.ycoord::double precision),2263), 4326),b.geom)
AND a.council IS NULL
AND a.xcoord IS NOT NULL;

UPDATE pluto a
SET zipcode = b.zipcode
FROM doitt_zipcodes b
WHERE ST_Within(ST_Transform(ST_SetSRID(ST_MakePoint(a.xcoord::double precision,a.ycoord::double precision),2263), 4326),b.geom)
AND a.zipcode IS NULL
AND a.xcoord IS NOT NULL;

UPDATE pluto a
SET firecomp = b.firecotype||lpad(b.fireconum::text,3,'0')
FROM dcp_firecompanies b
WHERE ST_Within(ST_Transform(ST_SetSRID(ST_MakePoint(a.xcoord::double precision,a.ycoord::double precision),2263), 4326),b.geom)
AND a.firecomp IS NULL
AND a.xcoord IS NOT NULL;

UPDATE pluto a
SET policeprct = b.precinct
FROM dcp_policeprecincts b
WHERE ST_Within(ST_Transform(ST_SetSRID(ST_MakePoint(a.xcoord::double precision,a.ycoord::double precision),2263), 4326),b.geom)
AND a.policeprct IS NULL
AND a.xcoord IS NOT NULL;

UPDATE pluto a
SET healthcenterdistrict = b.hcentdist
FROM dcp_healthcenters b
WHERE ST_Within(ST_Transform(ST_SetSRID(ST_MakePoint(a.xcoord::double precision,a.ycoord::double precision),2263), 4326),b.geom)
AND a.healthcenterdistrict IS NULL
AND a.xcoord IS NOT NULL;

UPDATE pluto a
SET healtharea = b.healtharea
FROM dcp_healthareas b
WHERE ST_Within(ST_Transform(ST_SetSRID(ST_MakePoint(a.xcoord::double precision,a.ycoord::double precision),2263), 4326),b.geom)
AND a.healtharea IS NULL
AND a.xcoord IS NOT NULL;

-- working on
UPDATE pluto a
SET sanitdistrict = LEFT(sectioncode,3)
sanitsub = 
FROM dsny_sections b
WHERE ST_Within(ST_Transform(ST_SetSRID(ST_MakePoint(a.xcoord::double precision,a.ycoord::double precision),2263), 4326),b.geom)
AND a.sanitsub IS NULL
AND a.xcoord IS NOT NULL;

