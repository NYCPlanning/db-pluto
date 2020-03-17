-- After geocoding, where values are none set values to NULL
-- this script is no longer needed 
UPDATE pluto_rpad_geo
SET bbl = NULL 
WHERE bbl = 'none';
UPDATE pluto_rpad_geo
SET billingbbl = NULL 
WHERE billingbbl = 'none';
UPDATE pluto_rpad_geo
SET giHighHouseNumber1 = NULL 
WHERE giHighHouseNumber1 = 'none';
UPDATE pluto_rpad_geo
SET buildingIdentificationNumber = NULL 
WHERE buildingIdentificationNumber = 'none';
UPDATE pluto_rpad_geo
SET numberOfExistingStructuresOnLot = NULL 
WHERE numberOfExistingStructuresOnLot = 'none';
UPDATE pluto_rpad_geo
SET cd = NULL 
WHERE cd = 'none' OR cd = 'foo';
UPDATE pluto_rpad_geo
SET ct2010 = NULL 
WHERE ct2010 = 'none';
SET cb2010 = NULL 
WHERE cb2010 = 'none';
UPDATE pluto_rpad_geo
SET schooldist = NULL 
WHERE schooldist = 'none';
UPDATE pluto_rpad_geo
SET council = NULL 
WHERE council = 'none';
UPDATE pluto_rpad_geo
SET zipcode = NULL 
WHERE zipcode = 'none';
UPDATE pluto_rpad_geo
SET firecomp = NULL 
WHERE firecomp = 'none';
UPDATE pluto_rpad_geo
SET policeprct = NULL 
WHERE policeprct = 'none';
UPDATE pluto_rpad_geo
SET zipcode = NULL 
WHERE zipcode = 'none';
UPDATE pluto_rpad_geo
SET healthcenterdistrict = NULL 
WHERE healthcenterdistrict = 'none';
UPDATE pluto_rpad_geo
SET healtharea = NULL 
WHERE healtharea = 'none';
UPDATE pluto_rpad_geo
SET sanitdistrict = NULL 
WHERE sanitdistrict = 'none';
UPDATE pluto_rpad_geo
SET sanitsub = NULL 
WHERE sanitsub = 'none';