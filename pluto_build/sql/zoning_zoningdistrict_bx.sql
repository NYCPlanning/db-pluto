DROP TABLE IF EXISTS lotzoneperorderbx;
CREATE TABLE lotzoneperorderbx AS (
WITH validdtm AS (
  SELECT a.bbl, a.geom 
  FROM pluto a
  WHERE ST_GeometryType(ST_MakeValid(a.geom)) = 'ST_MultiPolygon' AND a.bbl LIKE '2%'),
validzones AS (
  SELECT a.zonedist,  ST_MakeValid(a.geom) as geom
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