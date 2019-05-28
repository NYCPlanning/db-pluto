#!/bin/bash

# make sure we are at the top of the git directory
REPOLOC="$(git rev-parse --show-toplevel)"
cd $REPOLOC

# load config
DBNAME=$(cat $REPOLOC/pluto.config.json | jq -r '.DBNAME')
DBUSER=$(cat $REPOLOC/pluto.config.json | jq -r '.DBUSER')

start=$(date +'%T')
echo "Starting to build PLUTO"
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/pts_clean.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/create_rpad_geo.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/geocode_nones.sql
echo 'Reporting records that did not get geocoded...'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/geocode_notgeocoded.sql

echo 'Making DCP edits to RPAD...'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/zerovacantlots.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/lotarea.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/primebbl.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/apdate.sql

echo 'Creating table that aggregates condo data and is used to build PLUTO...'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/create_allocated.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/yearbuiltalt.sql

echo 'Creating base PLUTO table'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/create.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/bbl.sql

echo 'Adding on RPAD data attributes'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/allocated.sql
echo 'Adding on spatial data attributes'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/geocodes.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/spatialjoins.sql
# clean up numeric fields
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/numericfields.sql

echo 'Adding on CAMA data attributes'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/landuse.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/create_cama_primebbl.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/cama_bsmttype.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/cama_lottype.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/cama_proxcode.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/cama_bldgarea.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/cama_easements.sql

echo 'Adding on data attributes from other sources'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/lpc.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/edesignation.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/ownertype.sql

echo 'Transform RPAD data attributes'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/irrlotcode.sql

echo 'Adding DCP data attributes'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/address.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/sanitboro.sql

echo 'Create base DTM'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/dedupecondotable.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/dtmmergepolygons.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/plutogeoms.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/geomclean.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/shorelineclip.sql

psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/spatialindex.sql
echo 'Computing zoning fields'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/zoning_zoningdistrict.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/zoning_commercialoverlay.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/zoning_specialdistrict.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/zoning_limitedheight.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/zoning_zonemap.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/zoning_parks.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/zoning_correctdups.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/zoning_correctgaps.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/zoning_splitzone.sql
echo 'Filling in FAR values'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/far.sql

echo 'Populating building class for condos lots and land use field'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/bldgclass.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/landuse.sql

echo 'Flagging tax lots within the FEMA floodplain'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/flood_flag.sql
echo 'Adding in geometries that are in the DTM but not in RPAD'
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/dtmgeoms.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/geomclean.sql
echo 'Populating PLUTO tags and version fields '
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/plutomapid.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/versions.sql