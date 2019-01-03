-- calculate how much (total area and percentage) of each lot is covered by a zoning district
-- assign the zoning district(s) to each tax lot
-- the order zoning districts are assigned is based on which district covers the majority of the lot
-- a district is only assigned if more than 10% of the district covers the lot
-- OR the majority of the district is within the lot
-- split and process by borough to improve processing time

DROP TABLE IF EXISTS lotzoneperordermn;
CREATE TABLE lotzoneperordermn AS (
WITH validdtm AS (
  SELECT a.bbl, a.geom 
  FROM pluto a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon' AND a.bbl LIKE '1%'),
validzones AS (
  SELECT a.zonedist, a.geom 
  FROM dcp_zoningdistricts a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon'),
lotzoneper AS (
SELECT p.bbl, n.zonedist
 , (ST_Area(CASE 
   WHEN ST_CoveredBy(p.geom, n.geom) 
   THEN p.geom::geography 
   ELSE 
    ST_Multi(
      ST_Intersection(p.geom,n.geom)
      )::geography
    END)) segbblgeom,
    (ST_Area(CASE 
   WHEN ST_CoveredBy(n.geom, p.geom) 
   THEN n.geom::geography 
   ELSE 
    ST_Multi(
      ST_Intersection(n.geom,p.geom)
      )::geography
    END)) segzonegeom,
     ST_Area(p.geom::geography) as allbblgeom,
     ST_Area(n.geom::geography) as allzonegeom
 FROM validdtm AS p 
  INNER JOIN validzones AS n 
    ON ST_Intersects(p.geom, n.geom)
)
SELECT bbl, zonedist, segbblgeom, allbblgeom, (segbblgeom/allbblgeom)*100 as perbblgeom, segzonegeom, allzonegeom, (segzonegeom/allzonegeom)*100 as perzonegeom, ROW_NUMBER()
      OVER (PARTITION BY bbl
        ORDER BY segbblgeom DESC) AS row_number
      FROM lotzoneper
);

DROP TABLE IF EXISTS lotzoneperorderbx;
CREATE TABLE lotzoneperorderbx AS (
WITH validdtm AS (
  SELECT a.bbl, a.geom 
  FROM pluto a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon' AND a.bbl LIKE '2%'),
validzones AS (
  SELECT a.zonedist, a.geom 
  FROM dcp_zoningdistricts a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon'),
lotzoneper AS (
SELECT p.bbl, n.zonedist
 , (ST_Area(CASE 
   WHEN ST_CoveredBy(p.geom, n.geom) 
   THEN p.geom::geography 
   ELSE 
    ST_Multi(
      ST_Intersection(p.geom,n.geom)
      )::geography
    END)) segbblgeom,
    (ST_Area(CASE 
   WHEN ST_CoveredBy(n.geom, p.geom) 
   THEN n.geom::geography 
   ELSE 
    ST_Multi(
      ST_Intersection(n.geom,p.geom)
      )::geography
    END)) segzonegeom,
     ST_Area(p.geom::geography) as allbblgeom,
     ST_Area(n.geom::geography) as allzonegeom
 FROM validdtm AS p 
  INNER JOIN validzones AS n 
    ON ST_Intersects(p.geom, n.geom)
)
SELECT bbl, zonedist, segbblgeom, allbblgeom, (segbblgeom/allbblgeom)*100 as perbblgeom, segzonegeom, allzonegeom, (segzonegeom/allzonegeom)*100 as perzonegeom, ROW_NUMBER()
      OVER (PARTITION BY bbl
        ORDER BY segbblgeom DESC) AS row_number
      FROM lotzoneper
);

DROP TABLE IF EXISTS lotzoneperorderbk;
CREATE TABLE lotzoneperorderbk AS (
WITH validdtm AS (
  SELECT a.bbl, a.geom 
  FROM pluto a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon' AND a.bbl LIKE '3%'),
validzones AS (
  SELECT a.zonedist, a.geom 
  FROM dcp_zoningdistricts a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon'),
lotzoneper AS (
SELECT p.bbl, n.zonedist
 , (ST_Area(CASE 
   WHEN ST_CoveredBy(p.geom, n.geom) 
   THEN p.geom::geography 
   ELSE 
    ST_Multi(
      ST_Intersection(p.geom,n.geom)
      )::geography
    END)) segbblgeom,
    (ST_Area(CASE 
   WHEN ST_CoveredBy(n.geom, p.geom) 
   THEN n.geom::geography 
   ELSE 
    ST_Multi(
      ST_Intersection(n.geom,p.geom)
      )::geography
    END)) segzonegeom,
     ST_Area(p.geom::geography) as allbblgeom,
     ST_Area(n.geom::geography) as allzonegeom
 FROM validdtm AS p 
  INNER JOIN validzones AS n 
    ON ST_Intersects(p.geom, n.geom)
)
SELECT bbl, zonedist, segbblgeom, allbblgeom, (segbblgeom/allbblgeom)*100 as perbblgeom, segzonegeom, allzonegeom, (segzonegeom/allzonegeom)*100 as perzonegeom, ROW_NUMBER()
      OVER (PARTITION BY bbl
        ORDER BY segbblgeom DESC) AS row_number
      FROM lotzoneper
);

DROP TABLE IF EXISTS lotzoneperorderqn;
CREATE TABLE lotzoneperorderqn AS (
WITH validdtm AS (
  SELECT a.bbl, ST_MakeValid(a.geom) as geom 
  FROM pluto a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon' AND a.bbl LIKE '4%'),
validzones AS (
  SELECT a.zonedist, ST_MakeValid(a.geom) as geom 
  FROM dcp_zoningdistricts a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon'),
lotzoneper AS (
SELECT p.bbl, n.zonedist
 , (ST_Area(CASE 
   WHEN ST_CoveredBy(p.geom, n.geom) 
   THEN p.geom::geography 
   ELSE 
    ST_Multi(
      ST_Intersection(p.geom,n.geom)
      )::geography
    END)) segbblgeom,
    (ST_Area(CASE 
   WHEN ST_CoveredBy(n.geom, p.geom) 
   THEN n.geom::geography 
   ELSE 
    ST_Multi(
      ST_Intersection(n.geom,p.geom)
      )::geography
    END)) segzonegeom,
     ST_Area(p.geom::geography) as allbblgeom,
     ST_Area(n.geom::geography) as allzonegeom
 FROM validdtm AS p 
  INNER JOIN validzones AS n 
    ON ST_Intersects(p.geom, n.geom)
)
SELECT bbl, zonedist, segbblgeom, allbblgeom, (segbblgeom/allbblgeom)*100 as perbblgeom, segzonegeom, allzonegeom, (segzonegeom/allzonegeom)*100 as perzonegeom, ROW_NUMBER()
      OVER (PARTITION BY bbl
        ORDER BY segbblgeom DESC) AS row_number
      FROM lotzoneper
);

DROP TABLE IF EXISTS lotzoneperordersi;
CREATE TABLE lotzoneperordersi AS (
WITH validdtm AS (
  SELECT a.bbl, a.geom 
  FROM pluto a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon' AND a.bbl LIKE '5%'),
validzones AS (
  SELECT a.zonedist, a.geom 
  FROM dcp_zoningdistricts a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon'),
lotzoneper AS (
SELECT p.bbl, n.zonedist,
  (ST_Area(CASE 
   WHEN ST_CoveredBy(p.geom, n.geom) 
   THEN p.geom::geography 
   ELSE 
    ST_Multi(
      ST_Intersection(p.geom,n.geom)
      )::geography
    END)) segbblgeom,
  (ST_Area(CASE 
   WHEN ST_CoveredBy(n.geom, p.geom) 
   THEN n.geom::geography 
   ELSE 
    ST_Multi(
      ST_Intersection(n.geom,p.geom)
      )::geography
    END)) segzonegeom,
     ST_Area(p.geom::geography) as allbblgeom,
     ST_Area(n.geom::geography) as allzonegeom
 FROM validdtm AS p 
  INNER JOIN validzones AS n 
    ON ST_Intersects(p.geom, n.geom)
)
SELECT bbl, zonedist, segbblgeom, allbblgeom, (segbblgeom/allbblgeom)*100 as perbblgeom, segzonegeom, allzonegeom, (segzonegeom/allzonegeom)*100 as perzonegeom, ROW_NUMBER()
      OVER (PARTITION BY bbl
        ORDER BY segbblgeom DESC) AS row_number
      FROM lotzoneper
);

-- join each of the boro tables into one table
DROP TABLE IF EXISTS lotzoneperorder;
CREATE TABLE lotzoneperorder AS (
  SELECT * FROM lotzoneperordermn
  UNION
  SELECT * FROM lotzoneperorderbx
  UNION
  SELECT * FROM lotzoneperorderbk
  UNION
  SELECT * FROM lotzoneperorderqn
  UNION
  SELECT * FROM lotzoneperordersi
);

-- drop each of the boro tables
DROP TABLE lotzoneperordermn;
DROP TABLE lotzoneperorderbx;
DROP TABLE lotzoneperorderbk;
DROP TABLE lotzoneperorderqn;
DROP TABLE lotzoneperordersi;


-- update each of zoning district fields
-- only say that a lot is within a zoning district if
-- more than 10% of the lot is coverd by the zoning district
-- or more than a specified area is covered by the district
UPDATE pluto a
SET zonedist1 = zonedist
FROM lotzoneperorder b
WHERE a.bbl=b.bbl 
AND row_number = 1
AND perbblgeom >= 10;

UPDATE pluto a
SET zonedist2 = zonedist
FROM lotzoneperorder b
WHERE a.bbl=b.bbl 
AND row_number = 2
AND perbblgeom >= 10;

UPDATE pluto a
SET zonedist3 = zonedist
FROM lotzoneperorder b
WHERE a.bbl=b.bbl 
AND row_number = 3
AND perbblgeom >= 10;

UPDATE pluto a
SET zonedist4 = zonedist
FROM lotzoneperorder b
WHERE a.bbl=b.bbl 
AND row_number = 4
AND perbblgeom >= 10;

-- drop the area table
DROP TABLE lotzoneperorder;

-- for lots without a zoningdistrict1
-- assign the zoning district that is 
-- within 25 feet or 7 meters
-- DROP TABLE IF EXISTS lotzonedistance;
-- CREATE TABLE lotzonedistance AS (
-- WITH validdtm AS (
--   SELECT a.bbl, a.geom 
--   FROM dof_dtm a
--   WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon' 
--   AND a.bbl IN (SELECT bbl FROM dcp_zoning_taxlot WHERE zoningdistrict1 IS NULL)),
-- validzones AS (
--   SELECT a.zonedist, a.geom 
--   FROM dcp_zoningdistricts a
--   WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon')
-- SELECT a.bbl, b.zonedist
-- FROM validdtm a, validzones b
-- WHERE ST_DWithin(a.geom::geography, b.geom::geography, 7));

-- UPDATE dcp_zoning_taxlot a
-- SET zoningdistrict1 = zonedist
-- FROM lotzonedistance b
-- WHERE a.bbl=b.bbl 
-- AND zoningdistrict1 IS NULL;


