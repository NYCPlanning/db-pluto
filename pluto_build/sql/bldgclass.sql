-- set the building class to Q0 where the zoning district is park
UPDATE pluto 
SET bldgclass = 'Q0'
WHERE zonedist1 = 'PARK';

-- set building class for condo lots