-- only allow numeric values in the lot depth field
UPDATE pluto a
SET lotdepth = NULL 
WHERE a.lotdepth ~ '[^0-9]';
-- only allow numeric values in the numfloors field
UPDATE pluto a
SET numfloors = NULL 
WHERE a.numfloors ~ '[^0-9]';

-- clean up year values by making them valid years
-- yearbuilt
UPDATE pluto
SET yearbuilt = (CASE 
	WHEN LEFT(yearbuilt,1) = '0' THEN '2'||yearbuilt
	ELSE '1'||yearbuilt
	END)
WHERE length(yearbuilt) = 3;

UPDATE pluto
SET yearbuilt = (CASE 
	WHEN LEFT(yearbuilt,2) = '11' THEN '20'||RIGHT(yearbuilt,2)
	ELSE yearbuilt
	END)
WHERE LEFT(yearbuilt,2) = '11';

UPDATE pluto
SET yearbuilt = '0'
WHERE yearbuilt IS NULL;

-- clean up year values by making them valid years
-- yearalter1
UPDATE pluto
SET yearalter1 = (CASE 
	WHEN LEFT(yearalter1,1) = '0' THEN '2'||yearalter1
	ELSE '1'||yearalter1
	END)
WHERE length(yearalter1) = 3;

UPDATE pluto
SET yearalter1 = (CASE 
	WHEN LEFT(yearalter1,2) = '11' THEN '20'||RIGHT(yearalter1,2)
	ELSE yearalter1
	END)
WHERE LEFT(yearalter1,2) = '11';

UPDATE pluto
SET yearalter1 = '0'
WHERE yearalter1 IS NULL;

-- yearalter2
UPDATE pluto
SET yearalter2 = (CASE 
	WHEN LEFT(yearalter2,1) = '0' THEN '2'||yearalter2
	ELSE '1'||yearalter2
	END)
WHERE length(yearalter2) = 3;

UPDATE pluto
SET yearalter2 = (CASE 
	WHEN LEFT(yearalter2,2) = '11' THEN '20'||RIGHT(yearalter2,2)
	ELSE yearalter2
	END)
WHERE LEFT(yearalter2,2) = '11';

UPDATE pluto
SET yearalter2 = '0'
WHERE yearalter2 IS NULL;

