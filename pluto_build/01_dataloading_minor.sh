#!/bin/bash
source bin/config.sh

# DROP all tables
if [[ $1 == "drop" ]]; then
    psql $BUILD_ENGINE -c "
    DO \$\$ DECLARE
        r RECORD;
    BEGIN
        FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public' and tablename !='spatial_ref_sys') LOOP
            EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
        END LOOP;
    END \$\$;
    "
fi

# This shell script is for minor releases of PLUTO where all datasets remain constant except  
# for the Zoning related data which updated monthly

# import_public PTS and CAMA from data library
import_public pluto_pts $PLUTO_WEEKLY_DATA_VERSION &  
import_public pluto_input_cama_dof 20220927 & 
import_public pluto_input_numbldgs $PLUTO_WEEKLY_DATA_VERSION &
import_public pluto_input_geocodes $PLUTO_WEEKLY_DATA_VERSION &

# import_public spatial bounaries from data library
import_public dcp_edesignation 20221109 & 
import_public dcp_cdboundaries_wi $GEOSUPPORT_VERSION &
import_public dcp_cb2010_wi $GEOSUPPORT_VERSION &
import_public dcp_ct2010_wi $GEOSUPPORT_VERSION &
import_public dcp_cb2020_wi $GEOSUPPORT_VERSION &
import_public dcp_ct2020_wi $GEOSUPPORT_VERSION &
import_public dcp_school_districts $GEOSUPPORT_VERSION &
import_public dcp_firecompanies $GEOSUPPORT_VERSION &
import_public dcp_policeprecincts $GEOSUPPORT_VERSION &
import_public dcp_councildistricts_wi $GEOSUPPORT_VERSION &
import_public dcp_healthareas $GEOSUPPORT_VERSION &
import_public dcp_healthcenters $GEOSUPPORT_VERSION &
import_public dof_shoreline $DOF_DATA_VERSION & 
import_public doitt_zipcodeboundaries 20180910 & 
import_public fema_firms2007_100yr $FEMA_FIRPS_VERSION &
import_public fema_pfirms2015_100yr $FEMA_FIRPS_VERSION &

# import_public zoning files from data library - default to latest
import_public dcp_commercialoverlay &
import_public dcp_limitedheight &
import_public dcp_zoningdistricts &
import_public dcp_specialpurpose &
import_public dcp_specialpurposesubdistricts &
import_public dcp_zoningmapamendments &
import_public dcp_zoningmapindex &

# import_public other
import_public pluto_corrections &
import_public dpr_greenthumb 20221101 &
import_public dsny_frequencies 20221105 &
import_public lpc_historic_districts 20220526 &
import_public lpc_landmarks 20220613 &
import_public dcp_colp 202206 &
import_public dof_dtm $DOF_DATA_VERSION &
import_public dof_condo $DOF_DATA_VERSION

wait

## Load local CSV files
psql $BUILD_ENGINE -f sql/_create.sql

# Create data version table 
psql $BUILD_ENGINE -f sql/source_data_versions.sql