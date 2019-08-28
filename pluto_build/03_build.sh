#!/bin/bash

# load config
DBNAME='postgres'
DBUSER='postgres'

start=$(date +'%T')

echo "Starting to build PLUTO"
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/pts_clean.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/create_rpad_geo.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/geocode_nones.sql

# echo 'Reporting records that did not get geocoded...'
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/geocode_notgeocoded.sql

# echo 'Making DCP edits to RPAD...'
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zerovacantlots.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/lotarea.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/primebbl.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/apdate.sql

# echo 'Creating table that aggregates condo data and is used to build PLUTO...'
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/create_allocated.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/yearbuiltalt.sql

# echo 'Creating base PLUTO table'
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/create.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/bbl.sql

# echo 'Adding on RPAD data attributes'
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/allocated.sql
# echo 'Adding on spatial data attributes'
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/geocodes.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/spatialjoins.sql
# # clean up numeric fields
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/numericfields.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/condono.sql

# echo 'Adding on CAMA data attributes'
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/landuse.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/create_cama_primebbl.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/cama_bsmttype.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/cama_lottype.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/cama_proxcode.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/cama_bldgarea.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/cama_easements.sql

# echo 'Adding on data attributes from other sources'
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/lpc.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/edesignation.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/ownertype.sql

# echo 'Transform RPAD data attributes'
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/irrlotcode.sql

# echo 'Adding DCP data attributes'
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/address.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/sanitboro.sql

# echo 'Create base DTM'
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/dedupecondotable.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/dtmmergepolygons.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/plutogeoms.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/geomclean.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/shorelineclip.sql

# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/spatialindex.sql
# echo 'Computing zoning fields'
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_zoningdistrict.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_commercialoverlay.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_specialdistrict.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_limitedheight.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_zonemap.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_parks.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_correctdups.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_correctgaps.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_splitzone.sql
# echo 'Filling in FAR values'
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/far.sql

# echo 'Populating building class for condos lots and land use field'
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/bldgclass.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/landuse.sql

# echo 'Flagging tax lots within the FEMA floodplain'
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/flood_flag.sql
# echo 'Adding in geometries that are in the DTM but not in RPAD'
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/dtmgeoms.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/geomclean.sql
# echo 'Populating PLUTO tags and version fields '
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/plutomapid.sql
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/versions.sql