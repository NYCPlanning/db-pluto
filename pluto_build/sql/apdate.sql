-- converting datetime from year and day of year e.g. 93005 to 1993-01-05 then MM/DD/YYYY
UPDATE pluto_rpad_geo
SET ap_datef = to_char(to_date(lpad(ap_date, 5, '0'), 'YYDDD'), 'MM/DD/YYYY')
WHERE ap_date::numeric > 0;