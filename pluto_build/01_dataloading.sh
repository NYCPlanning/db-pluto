#!/bin/bash
source bin/config.sh

# DROP all tables
psql $BUILD_ENGINE -c "
DO \$\$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public' and tablename !='spatial_ref_sys') LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END \$\$;
"

# Import PTS and CAMA from data library
import pluto_pts &
import pluto_input_cama_dof &
import pluto_input_numbldgs &
import pluto_input_geocodes &

# Import spatial bounaries from data library
import dcp_edesignation &
import dcp_cdboundaries &
import dcp_censustracts &
import dcp_censusblocks &
import dcp_school_districts &
import dcp_firecompanies &
import dcp_policeprecincts &
import dcp_councildistricts &
import dcp_healthareas &
import dcp_healthcenters &
import dof_shoreline &
import doitt_zipcodeboundaries &
import fema_firms2007_100yr &
import fema_pfirms2015_100yr &

# Import zoning files from data library
import dcp_commercialoverlay &
import dcp_limitedheight &
import dcp_zoningdistricts &
import dcp_specialpurpose &
import dcp_specialpurposesubdistricts &
import dcp_zoningmapamendments &
import dcp_zoningmapindex &

# Import other
import pluto_corrections &
import dpr_greenthumb &
import dsny_frequencies &
import lpc_historic_districts &
import lpc_landmarks &
import dcp_colp &
import dof_dtm &
import dof_condo

wait

## Load local CSV files
psql $BUILD_ENGINE -f sql/_create.sql

# Create data version table 
psql $BUILD_ENGINE -f sql/source_data_versions.sql