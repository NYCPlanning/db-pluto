#!/bin/sh
docker exec pluto bash -c '
        TABLE_NAME=19v2_wo_corrections_backfill
        #TABLE_NAME=19v2_w_corrections
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