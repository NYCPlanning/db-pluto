-- Create qaqc table of all PLUTO records where there is a match in Housing Database 
-- and the PLUTO residential units value does not match the housing database certificates 
-- of occupancy value. Have flag indicating if bbl has residential unit correction in manual corrections table.


-- Data Dictionary 
-- bbl - billing BBL
-- job_number - The DOB job application number assigned when the applicant begins the application. This is the unique identifier for the application submitted to the Department of Buildings (DOB). 
-- unitsres - The number of residential units as reported by PLUTO database
-- units_co - The number of units listed on the DOB issued Certificate of Occupancy 
-- new_value - The new number of residential units as reported by the current version of PLUTO
-- old_value - The old number of residential units as reported by the previous version of PLUTO


CREATE TABLE IF NOT EXISTS qaqc_housing_units(
  bbl text,
  job_number text,
  unitsres text,
  units_co text,
  new_value text,
  old_value text
);

INSERT INTO qaqc_housing_units
WITH base as(
SELECT DISTINCT round(a.bbl::numeric,0)::text as bbl,b.job_number,a.unitsres,round(b.units_co::numeric,0)::text as units_co
FROM pluto a, dcp_housing b
WHERE b.bbl||b.date_lastupdt IN (
-- get the most recent DOB record for a BBL based on date of last update field
	SELECT bbl||max(date_lastupdt::date) maxDate
        FROM dcp_housing
      GROUP BY bbl)
AND round(a.bbl::numeric,0)::text=b.bbl 
AND a.unitsres<>round(b.units_co::numeric,0)::text),
-- select only corrections to unitsres field
corrections_subset as (
SELECT * 
FROM pluto_corrections 
WHERE field='unitsres')
-- combine PLUTO, DOB, and corrections data for final output
SELECT a.*, c.new_value, c.old_value
FROM base a
LEFT JOIN corrections_subset c
ON a.bbl=c.bbl;
