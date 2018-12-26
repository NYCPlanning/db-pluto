-- converting datetime e.g. 93005 --> 1993-01-05
UPDATE pluto_rpad_geo
SET ap_date =
    CASE WHEN length(ap_date) = 5 THEN to_date(ap_date, 'YYDDD')
    ELSE NULL
    END
