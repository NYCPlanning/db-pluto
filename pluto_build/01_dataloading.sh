#!/bin/bash

################################################################################################
### OBTAINING DATA
################################################################################################
### NOTE: This script requires you to setup the DATABASE_URL environment variable.
### Directions are in the README.md.

## Load all datasets from sources using the civic data loader
## https://github.com/NYCPlanning/data-loading-scripts

# make sure we are at the top of the git directory
REPOLOC="$(git rev-parse --show-toplevel)"
cd $REPOLOC
# go back one level to folder with all repos
cd ..
# enter the data-loading-scripts repo
cd 'data-loading-scripts'

## Open_datasets - PULLING FROM OPEN DATA
echo 'Loading open source datasets...'
node loader.js install dcp_edesignation
node loader.js install dcp_zoning_taxlot
node loader.js install dcas_facilities_colp
node loader.js install dcp_zoningmapindex
node loader.js install lpc_historic_districts
node loader.js install lpc_landmarks
# for spatial joins
node loader.js install dcp_cdboundaries
node loader.js install dcp_censustracts
node loader.js install dcp_censusblocks
node loader.js install dcp_school_districts
node loader.js install dcp_councildistricts
node loader.js install doitt_zipcodes
node loader.js install dcp_firecompanies
node loader.js install dcp_policeprecincts
node loader.js install dcp_healthareas
node loader.js install dcp_healthcenters
node loader.js install dsny_frequencies

## Other_datasets - PULLING FROM FTP or PLUTO GitHub repo
echo 'Loading datasets from PLUTO GitHub repo...'
node loader.js install dcp_zoning_maxfar
node loader.js install pluto_input_bsmtcode
node loader.js install pluto_input_landuse_bldgclass
node loader.js install pluto_input_condo_bldgclass

echo 'Loading datasets from FTP...'
# raw RPAD data from DOF
node loader.js install pluto_rpad
# Geocoded RPAD data (includes billing BBL for condo lots and geospatial fields returned by GeoSupport)
node loader.js install pluto_input_geocodes
# raw CAMA data from DOF
node loader.js install pluto_input_cama_dof
# raw Digital Tax Map from DOF
node loader.js install dof_dtm
# raw NYC shoreline file from DOF
node loader.js install dof_shoreline
# raw DOF condo table
node loader.js install dof_condo
# DCP zoning datasets
node loader.js install dcp_zoningfeatures
# FEMA 2007 and preliminary 2015 100 year flood zones 
node loader.js install fema_firms2007_100yr
node loader.js install fema_pfirms2015_100yr
