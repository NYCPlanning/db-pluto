#!/bin/sh
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

psql $BUILD_ENGINE -f sql/corr_create.sql

echo "Applying corrections to PLUTO"
psql $BUILD_ENGINE -f sql/corr_lotarea.sql
psql $BUILD_ENGINE -f sql/corr_yearbuilt_lpc.sql
psql $BUILD_ENGINE -f sql/corr_ownername_city.sql
psql $BUILD_ENGINE -f sql/corr_inwoodrezoning.sql
psql $BUILD_ENGINE -f sql/corr_dropoldrecords.sql
psql $BUILD_ENGINE -f sql/remove_unitlots.sql


# docker exec pluto bash -c '
#         TABLE_NAME=19v2_w_corrections
#         echo $TABLE_NAME
#         pg_dump -t pluto --no-owner -U postgres -d postgres | psql $EDM_DATA
#         psql $EDM_DATA -c "DROP INDEX idx_pluto_bbl;";
#         psql $EDM_DATA -c "DROP INDEX pbbl_ix;";
#         psql $EDM_DATA -c "DROP INDEX pluto_gix;";
#         psql $EDM_DATA -c "CREATE SCHEMA IF NOT EXISTS dcp_pluto;";
#         psql $EDM_DATA -c "ALTER TABLE pluto SET SCHEMA dcp_pluto;";
#         psql $EDM_DATA -c "DROP TABLE IF EXISTS dcp_pluto.\"$TABLE_NAME\";";
#         psql $EDM_DATA -c "ALTER TABLE dcp_pluto.pluto RENAME TO \"$TABLE_NAME\";";
#     '

# echo "Exporting pluto csv and shapefile"
psql $BUILD_ENGINE  -c "\COPY (SELECT * FROM pluto) TO 'output/pluto.csv' DELIMITER ',' CSV HEADER;"

rm -f output/pluto.zip
zip output/pluto.zip output/pluto.csv
rm -f output/pluto.csv

psql $BUILD_ENGINE  -c "\COPY (SELECT * FROM pluto_corrections) TO 'output/pluto_corrections.csv' DELIMITER ',' CSV HEADER;"

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

# psql $EDM_DATA -c "DROP VIEW IF EXISTS dcp_zoningtaxlots.latest"
# psql $EDM_DATA -c "CREATE VIEW dcp_zoningtaxlots.latest AS 
#                     (SELECT * FROM dcp_zoningtaxlots.\"${DATE}\")"
