-- only allow numeric values in the lot depth field
UPDATE pluto a
SET lotdepth = NULL 
WHERE a.lotdepth ~ '[^0-9]';
-- only allow numeric values in the numfloors field
UPDATE pluto a
SET numfloors = NULL 
WHERE a.numfloors ~ '[^0-9]';