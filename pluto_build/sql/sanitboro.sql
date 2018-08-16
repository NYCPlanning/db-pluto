-- set the sanitation boro
UPDATE pluto
SET sanitboro = LEFT(sanitdistrict,1)
WHERE sanitdistrict IS NOT NULL;