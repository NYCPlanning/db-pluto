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

wait
Upload latest & 
Upload $DATE &
Upload $VERSION &
 
wait
exit 0
