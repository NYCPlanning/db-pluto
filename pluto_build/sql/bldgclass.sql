-- set the building class to Q0 
-- where the zoning district is park and the building class is null or vacant
UPDATE pluto 
SET bldgclass = 'Q0'
WHERE zonedist1 = 'PARK'
AND (bldgclass IS NULL OR bldgclass LIKE 'V%');

-- set building class for condo lots