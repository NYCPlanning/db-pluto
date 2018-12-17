-- only allow numeric values in the lot depth field
UPDATE pluto a
SET lotdepth = NULL 
WHERE a.lotdepth ~ '[^0-9]';
-- only allow numeric values in the numfloors field
UPDATE pluto a
SET numfloors = NULL 
WHERE a.numfloors ~ '[^0-9]';

-- remove decimal places in ct2010 where it is only zero after decimal
UPDATE pluto a
SET ct2010 = trunc(a.ct2010::numeric) 
WHERE a.ct2010 ~ '[0-9]'
AND ct2010 LIKE '%.00';
-- only allow numeric values in the ct2010 field
UPDATE pluto a
SET ct2010 = NULL 
WHERE a.ct2010 !~ '[0-9]';

-- remove end zeros for numbers with only zeros past decimal and pad to 4 characters
UPDATE pluto a
SET tract2010 = lpad(trunc(a.ct2010::numeric)::text,4,'0')
WHERE tract2010 LIKE '%.00';
-- remove decimal place and pad to 6 characters
UPDATE pluto a
SET tract2010 = lpad(replace(tract2010, '.', '')::text,6,'0')
WHERE tract2010 LIKE '%.%';
-- only allow numeric values in the tract2010 field
UPDATE pluto a
SET tract2010 = NULL 
WHERE a.tract2010 ~ '[^0-9]';