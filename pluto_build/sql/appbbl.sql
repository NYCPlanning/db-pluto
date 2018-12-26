-- set appbbl as a numeric field rounded to two digits
UPDATE pluto
SET appbbl = round(appbbl::numeric, 2)::text;
-- set appbbl length of appbl to 11 decimal places where appbbl is zero
UPDATE pluto
SET appbbl = '0.00000000000'
WHERE appbbl::numeric = 0;