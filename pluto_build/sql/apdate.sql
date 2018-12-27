-- converting datetime from year and day of year e.g. 93005 to 1993-01-05 then MM/DD/YYYY
UPDATE pluto_rpad_geo
SET ap_datef =
    CASE WHEN length(ap_date) = 5 THEN to_char(to_date(ap_date, 'YYDDD'), 'MM/DD/YYYY')
    ELSE NULL
    END;