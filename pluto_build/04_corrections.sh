#!/bin/sh
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

psql $BUILD_ENGINE -f sql/corr_create.sql

# echo "Applying corrections to PLUTO"
psql $BUILD_ENGINE -f sql/corr_lotarea.sql
psql $BUILD_ENGINE -f sql/corr_yearbuilt_lpc.sql
psql $BUILD_ENGINE -f sql/corr_ownername_city.sql
psql $BUILD_ENGINE -f sql/corr_inwoodrezoning.sql
psql $BUILD_ENGINE -f sql/corr_dropoldrecords.sql
psql $BUILD_ENGINE -f sql/remove_unitlots.sql

psql $BUILD_ENGINE  -c "\COPY (SELECT * FROM pluto_corrections) TO 'output/pluto_corrections.csv' DELIMITER ',' CSV HEADER;"
psql $BUILD_ENGINE  -c "\COPY (SELECT * FROM pluto_removed_records) TO 'output/pluto_removed_records.csv' DELIMITER ',' CSV HEADER;"

curl -d "{
    \"src_engine\":\"${BUILD_ENGINE}\",
    \"dst_engine\": \"${EDM_DATA}\",
    \"src_schema_name\": \"public\",
    \"dst_schema_name\": \"dcp_pluto\",
    \"src_version\": \"pluto\",
    \"dst_version\": \"${VERSION}\"
    }"\
    -H "Content-Type: application/json"\
    -X POST $GATEWAY/migrate