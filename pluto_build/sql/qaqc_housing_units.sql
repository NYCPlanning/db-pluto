-- Create qaqc table All PLUTO records where there is a match in Housing Database 
-- and the PLUTO residential units value does not match the housing database certificates 
-- of occupancy value. Have flag indicating if bbl has residential unit correction in manual corrections table.
-- select PLUTO records that have a match in the HousingDB subset where unitsres does not equal units co
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
