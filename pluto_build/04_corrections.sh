#!/bin/bash
DBNAME='postgres'
DBUSER='postgres'

docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/corr_create.sql

echo "Applying corrections to PLUTO"
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/corr_lotarea.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/corr_yearbuilt_lpc.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/corr_ownername_city.sql

docker exec pluto bash -c '
        TABLE_NAME=19v2_w_corrections
        echo $TABLE_NAME
        pg_dump -t pluto --no-owner -U postgres -d postgres | psql $EDM_DATA
        psql $EDM_DATA -c "DROP INDEX idx_pluto_bbl;";
        psql $EDM_DATA -c "DROP INDEX pbbl_ix;";
        psql $EDM_DATA -c "DROP INDEX pluto_gix;";
        psql $EDM_DATA -c "CREATE SCHEMA IF NOT EXISTS dcp_pluto;";
        psql $EDM_DATA -c "ALTER TABLE pluto SET SCHEMA dcp_pluto;";
        psql $EDM_DATA -c "DROP TABLE IF EXISTS dcp_pluto.\"$TABLE_NAME\";";
        psql $EDM_DATA -c "ALTER TABLE dcp_pluto.pluto RENAME TO \"$TABLE_NAME\";";
    '
    
echo "Exporting pluto csv and shapefile"
docker exec pluto psql -U $DBUSER -d $DBNAME  -c "\COPY (SELECT * FROM pluto) TO 'output/pluto_w_corrections.csv' DELIMITER ',' CSV HEADER;"

zip output/pluto_w_corrections.zip output/pluto_w_corrections.csv
rm -f output/pluto_w_corrections.csv