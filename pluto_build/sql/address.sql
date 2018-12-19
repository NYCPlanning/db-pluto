-- when the address is still null populate the address
UPDATE pluto a
SET address = trim(leading '0' FROM b.prime)||' '||b.street_name
FROM pluto_rpad_geo b
WHERE a.bbl = b.primebbl AND a.address IS NULL;

-- remove extra spaces from the address
UPDATE pluto a
SET address = trim(regexp_replace(a.address, '\s+', ' ', 'g'))
WHERE a.address IS NOT NULL
	AND replace(a.address, '-', '') ~ '[0-9]';