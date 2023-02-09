-- Record PTS records that meet the criteria of
-- The units and coop_apts values are greater than one for the billing bbl AND
-- Two or more unit bbl records have units and coop_apts values greater than 1
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