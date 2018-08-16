-- when the address is still null poptulate the address
UPDATE pluto a
SET address = trim(leading '0' FROM b.prime)||' '||b.street_name
FROM pluto_rpad_geo b
WHERE a.bbl = b.primebbl AND a.address IS NULL;