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
 psql $BUILD_ENGINE -c "
 DROP TABLE IF EXISTS pluto_input_research;
 CREATE TABLE pluto_input_research (
    bbl text,
    field text,
    old_value text,
    new_value text,
    Type text,
    reason text,
    version text
 );

DROP TABLE IF EXISTS pluto_input_landuse_bldgclass;
CREATE TABLE pluto_input_landuse_bldgclass (
    bldgclass text,
    landuse text,
    landusevalue text
 );

DROP TABLE IF EXISTS pluto_input_condolot_descriptiveattributes;
CREATE TABLE pluto_input_condolot_descriptiveattributes (
    CondNO text,
    Boro text,
    PARID text,
    BC text,
    TC text,
    LandSize text,
    Story text,
    YearBuilt text
);

DROP TABLE IF EXISTS pluto_input_condo_bldgclass;
CREATE TABLE pluto_input_condo_bldgclass (
    code character varying,
    description character varying,
    type character varying,
    dcpcreated character varying,
    logic character varying
);

DROP TABLE IF EXISTS pluto_input_bsmtcode;
CREATE TABLE pluto_input_bsmtcode (
    bsmnt_type character varying,
    bsmntgradient character varying,
    bsmtcode character varying,
    bsmnt_typevalue character varying,
    bsmntgradientvalue character varying,
    bsmtcodevalue character varying
);

DROP TABLE IF EXISTS dcp_zoning_maxfar;
CREATE TABLE dcp_zoning_maxfar (
    zonedist character varying,
    contextual character varying,
    zoningdistricttype character varying,
    residfar character varying,
    facilfar character varying,
    commfar character varying,
    mnffar character varying,
    column1 character varying,
    verified character varying,
    extra character varying
)
"

imports_csv pluto_input_research &
imports_csv pluto_input_landuse_bldgclass &
imports_csv pluto_input_condolot_descriptiveattributes &
imports_csv pluto_input_condo_bldgclass &
imports_csv pluto_input_bsmtcode &
imports_csv dcp_zoning_maxfar

# Create data version table 
 psql $BUILD_ENGINE -f sql/source_data_versions.sql