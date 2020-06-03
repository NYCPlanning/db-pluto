#!/bin/bash
source bin/config.sh

mkdir -p output && 
  (cd output 
    echo "version: $VERSION" > version.txt
    echo "date: $DATE" >> version.txt
    CSV_export pluto_corrections
    CSV_export pluto_removed_records
    zip pluto_corrections.zip *
    ls | grep -v pluto_corrections.zip | xargs rm
    CSV_export source_data_versions
  )

# mappluto
SHP_export mappluto &

# mappluto_unclipped
SHP_export mappluto_unclipped

wait
# mappluto.gdb
FGDB_export mappluto

# mappluto_unclipped.gdb
FGDB_export mappluto_unclipped

# Pluto
mkdir -p output/pluto &&
  (cd output/pluto
    rm -f pluto.zip
    psql $BUILD_ENGINE -c "\COPY ( 
          SELECT
          borough,block,lot,cd,ct2010,cb2010,schooldist,
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
          firm07_flag,pfirm15_flag,dcpedited,notes FROM export_pluto
          ) TO STDOUT DELIMITER ',' CSV HEADER;" > pluto.csv
    echo "$VERSION" > version.txt
    echo "$(wc -l pluto.csv)" >> version.txt
    zip pluto.zip *
    ls | grep -v pluto.zip | xargs rm
  )

wait
Upload latest & 
Upload $DATE &
Upload $VERSION &
 
wait
exit 0
