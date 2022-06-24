#!/bin/bash
CURRENT_DIR=$(dirname "$(readlink -f "$0")")
cd $CURRENT_DIR
source bin/config.sh

mkdir -p output && 
  (cd output 
    echo "version: $VERSION" > version.txt
    echo "date: $DATE" >> version.txt
    CSV_export pluto_corrections
    CSV_export pluto_removed_records
    zip pluto_corrections.zip *
    ls | grep -v pluto_corrections.zip | xargs rm 
  )

mkdir -p output &&
  (cd output
    CSV_export source_data_versions
  )

# mappluto.gdb
FGDB_export mappluto_gdb &

# mappluto_unclipped.gdb
FGDB_export mappluto_unclipped_gdb &

# mappluto
SHP_export mappluto &

# mappluto_unclipped
SHP_export mappluto_unclipped &

# Pluto
mkdir -p output/pluto &&
  (cd output/pluto
    rm -f pluto.zip
    psql $BUILD_ENGINE -c "\COPY ( 
          SELECT * FROM export_pluto
        ) TO STDOUT DELIMITER ',' CSV HEADER;" > pluto.csv
    echo "$VERSION" > version.txt
    echo "$(wc -l pluto.csv)" >> version.txt
    zip pluto.zip *
    ls | grep -v pluto.zip | xargs rm
  )

# BBL and Council info for DOF
mkdir -p output/dof && 
  (cd output/dof
    rm -f bbl_council.zip
    psql $BUILD_ENGINE -c "\COPY ( 
          SELECT bbl, council FROM export_pluto
          WHERE bbl is not null
        ) TO STDOUT DELIMITER ',' CSV HEADER;" > bbl_council.csv
    echo "$VERSION" > version.txt
    zip bbl_council.zip *
    ls | grep -v bbl_council.zip | xargs rm
  )

wait
