-- Setting the landuse of the lot based on the building class
-- uses the pluto_input_landuse_bldgclass lookup table
UPDATE pluto a
SET landuse = b.landuse
FROM pluto_input_landuse_bldgclass b
WHERE a.bldgclass = b.bldgclass;