#!/bin/bash
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi
if [ -f version.env ]
then
  export $(cat version.env | sed 's/#.*//g' | xargs)
fi

DATE=$(date "+%Y-%m-%d")
apt update 
apt install -y zip curl

source ./url_parse.sh $BUILD_ENGINE

mkdir -p output && 
  (cd output 
    echo "version: $VERSION" > version.txt
    echo "date: $DATE" >> version.txt
    psql $BUILD_ENGINE  -c "\COPY (SELECT * FROM pluto_corrections) TO STDOUT DELIMITER ',' CSV HEADER;" > pluto_corrections.csv
    echo "$(wc -l pluto_corrections.csv)" >> version.txt
    psql $BUILD_ENGINE  -c "\COPY (SELECT * FROM pluto_removed_records) TO STDOUT DELIMITER ',' CSV HEADER;" > pluto_removed_records.csv
    echo "$(wc -l pluto_removed_records.csv)" >> version.txt
    zip pluto_corrections.zip *
    ls | grep -v pluto_corrections.zip | xargs rm
  )

# mappluto
mkdir -p output/mappluto &&
  (cd output/mappluto
    pgsql2shp -u $BUILD_USER -h $BUILD_HOST -p $BUILD_PORT -P $BUILD_PWD -f mappluto $BUILD_DB \
      "SELECT ST_Transform(geom, 2263) FROM pluto WHERE geom IS NOT NULL"
      rm -f mappluto.zip
      echo "$VERSION" > version.txt
      zip mappluto.zip *
      ls | grep -v mappluto.zip | xargs rm
    )

# Pluto
mkdir -p output/pluto &&
  (cd output/pluto
    rm -f pluto.zip
    psql $BUILD_ENGINE -c "\COPY ( 
          SELECT borough,block,lot,cd,ct2010,cb2010,schooldist,
          council,zipcode,firecomp,policeprct,healtharea,
          sanitboro,sanitsub,address,zonedist1,zonedist2,
          zonedist3,zonedist4,overlay1,overlay2,spdist1,
          spdist2,spdist3,ltdheight,splitzone,bldgclass,
          landuse,easements,ownertype,ownername,lotarea,
          bldgarea,comarea,resarea,officearea,retailarea,
          garagearea,strgearea,factryarea,otherarea,
          areasource,numbldgs,numfloors,unitsres,unitstotal,
          lotfront,lotdepth,bldgfront,bldgdepth,ext,proxcode,
          irrlotcode,lottype,bsmtcode,assessland,assesstot,
          exempttot,yearbuilt,yearalter1,yearalter2,histdist,
          landmark,builtfar,residfar,commfar,facilfar,borocode,
          bbl,condono,tract2010,xcoord,ycoord,latitude,longitude,
          zonemap,zmcode,sanborn,taxmap,edesignum,appbbl,appdate,
          plutomapid,version,sanitdistrict,healthcenterdistrict,
          firm07_flag,pfirm15_flag,dcpedited,notes FROM pluto
          ) TO STDOUT DELIMITER ',' CSV HEADER;" > pluto.csv
    echo "$VERSION" > version.txt
    echo "$(wc -l pluto.csv)" >> version.txt
    zip pluto.zip *
    ls | grep -v pluto.zip | xargs rm
  )

curl -O https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc

./mc config host add spaces $AWS_S3_ENDPOINT $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY --api S3v4
./mc rm -r --force spaces/edm-publishing/db-pluto/latest
./mc rm -r --force spaces/edm-publishing/db-pluto/$DATE
./mc cp -r output spaces/edm-publishing/db-pluto/latest
./mc cp -r output spaces/edm-publishing/db-pluto/$DATE

exit 0
