#!/bin/bash
source bin/config.sh

## DROP all tables
psql $BUILD_ENGINE -c "
DO \$\$ DECLARE
    r RECORD;
BEGIN
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public' and tablename !='spatial_ref_sys') LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    END LOOP;
END \$\$;
"
## load data into the pluto db
docker run --rm\
    -v $(pwd)/python:/home/python\
    -w /home/python\
    -e BUILD_ENGINE=$BUILD_ENGINE\
    -e RECIPE_ENGINE=$RECIPE_ENGINE\
    sptkl/cook:latest python3 fastloading.py

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
