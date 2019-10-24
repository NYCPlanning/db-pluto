#!/bin/bash
# load config
DBNAME=postgres
DBUSER=postgres

# some final processing is done in Esri to create the Esri file formats
# please go to NYC Planning's Bytes of the Big Apple to download the offical versions of PLUTO and MapPLUTO
# https://www1.nyc.gov/site/planning/data-maps/open-data.page

echo "Exporting pluto csv and shapefile"
docker exec pluto psql -U $DBUSER -d $DBNAME  -c "\COPY ( SELECT borough,block,lot,cd,ct2010,cb2010,schooldist,council,zipcode,firecomp,policeprct,healtharea,sanitboro,sanitsub,address,zonedist1,zonedist2,zonedist3,zonedist4,overlay1,overlay2,spdist1,spdist2,spdist3,ltdheight,splitzone,bldgclass,landuse,easements,ownertype,ownername,lotarea,bldgarea,comarea,resarea,officearea,retailarea,garagearea,strgearea,factryarea,otherarea,areasource,numbldgs,numfloors,unitsres,unitstotal,lotfront,lotdepth,bldgfront,bldgdepth,ext,proxcode,irrlotcode,lottype,bsmtcode,assessland,assesstot,exempttot,yearbuilt,yearalter1,yearalter2,histdist,landmark,builtfar,residfar,commfar,facilfar,borocode,bbl,condono,tract2010,xcoord,ycoord,zonemap,zmcode,sanborn,taxmap,edesignum,appbbl,appdate,plutomapid,version,sanitdistrict,healthcenterdistrict,firm07_flag,pfirm15_flag,rpaddate,dcasdate,zoningdate,landmkdate,basempdate,masdate,polidate,edesigdate FROM pluto) TO 'output/pluto.csv' DELIMITER ',' CSV HEADER;"

zip output/pluto.zip output/pluto.csv
rm output/pluto.csv
# pgsql2shp -u $DBUSER -f pluto_build/output/mappluto $DBNAME "SELECT * FROM pluto WHERE geom IS NOT NULL"

# ogr2ogr -f "GeoJSON" pluto_build/output/mappluto_clipped.geojson PG:"host=localhost dbname=$DBNAME user=$DBUSER" \
# -sql "SELECT * FROM mappluto_clipped WHERE geom IS NOT NULL"