-- The units and coop_apts values are greater than one for the billing bbl AND
-- Two or more unit bbl records have units and coop_apts values greater than 1

-- Data Dictionary 

-- primebbl - Billing BBL  
-- bbl - Unit level BBl
-- units - The number of units listed by Department of Finance for the property (compare to units_co in dcp_housing)
-- coop_apts - The number of residential units listed for the property 
-- job_number - The DOB job application number assigned when the applicant begins the application. This is the unique identifier for the application submitted to the Department of Buildings (DOB). 
-- units_co - The number of units listed on the DOB issued Certificate of Occupancy 
-- date_lastupdt - The date of the last update to the DOB record for the job filing.
-- new_value - The new number of units as reported by the pluto_corrections file
-- old_value - The previous number of units as reported by the pluto_correction file


CREATE TABLE IF NOT EXISTS qaqc_pts_condo(
	primebbl text,
	bbl text,
	units numeric,
	coop_apts numeric,
	job_number text,
	units_co text,
	date_lastupdt varchar,
	new_value text,
	old_value text
);

INSERT INTO qaqc_pts_condo
WITH pts_subset as (
SELECT primebbl, bbl, units, coop_apts
FROM pluto_rpad_geo
	WHERE primebbl IN (
		SELECT primebbl FROM (
			SELECT primebbl, COUNT(*)
			FROM pluto_rpad_geo
			WHERE tl NOT LIKE '75%'
			AND RIGHT(primebbl,4) LIKE '75%'
			AND units::integer > 1
			AND coop_apts::integer > 1
			GROUP BY primebbl, units, coop_apts) as badbases 
		WHERE count>1)
	AND primebbl IN (
		SELECT primebbl FROM (
			SELECT primebbl	
			FROM pluto_rpad_geo
			WHERE tl LIKE '75%'
			AND units::integer > 1
			AND coop_apts::integer > 1) as badbillings)),
-- get the most recent DOB record for a BBL based on date of last update field
dob_subset as (
SELECT * FROM dcp_housing b
WHERE b.bbl||b.date_lastupdt IN ( 
	SELECT bbl||max(date_lastupdt::date) maxDate
        FROM dcp_housing
      GROUP BY bbl)),
-- select only corrections to unitsres field
corrections_subset as (
SELECT * 
FROM pluto_corrections 
WHERE field='unitsres'),
-- Join PTS and DOB subsets, preserving all PTS records
pts_dob as ( 
SELECT a.*, b.job_number, round(b.units_co::numeric,0)::text as units_co, b.date_lastupdt
FROM pts_subset a
LEFT JOIN dob_subset b
ON a.bbl=b.bbl
AND a.coop_apts::text<>round(b.units_co::numeric,0)::text)
-- Join on corrections to produce final output
SELECT a.*, c.new_value, c.old_value
FROM pts_dob a
LEFT JOIN corrections_subset c
ON a.bbl=c.bbl;