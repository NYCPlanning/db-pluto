#!/bin/sh
# load config
DBNAME='postgres'
DBUSER='postgres'

echo "\nStarting to build PLUTO ... \e[32m"
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/preprocessing.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/pts_clean.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/create_rpad_geo.sql

echo '\nReporting records that did not get geocoded... \e[32m'
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/geocode_notgeocoded.sql

echo '\nMaking DCP edits to RPAD... \e[32m'
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zerovacantlots.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/lotarea.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/primebbl.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/apdate.sql

echo '\nCreating table that aggregates condo data and is used to build PLUTO... \e[32m'
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/create_allocated.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/yearbuiltalt.sql

echo '\nCreating base PLUTO table \e[32m'
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/create.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/bbl.sql

echo '\nAdding on RPAD data attributes \e[32m'
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/allocated.sql

echo '\nAdding on spatial data attributes \e[32m'
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/geocodes.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/spatialjoins.sql
# clean up numeric fields
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/numericfields.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/condono.sql

echo '\nAdding on CAMA data attributes \e[32m'
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/landuse.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/create_cama_primebbl.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/cama_bsmttype.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/cama_lottype.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/cama_proxcode.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/cama_bldgarea_1.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/cama_bldgarea_2.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/cama_bldgarea_3.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/cama_bldgarea_4.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/cama_easements.sql

echo '\nAdding on data attributes from other sources \e[32m'
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/lpc.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/edesignation.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/ownertype.sql

echo '\nTransform RPAD data attributes \e[32m'
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/irrlotcode.sql

echo '\nAdding DCP data attributes \e[32m'
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/address.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/sanitboro.sql

echo '\nCreate base DTM \e[32m'
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/dedupecondotable.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/dtmmergepolygons.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/plutogeoms.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/geomclean.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/shorelineclip.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/spatialindex.sql

echo '\nComputing zoning fields \e[32m'
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_create_priority.sql&
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_zoningdistrict_mn.sql&
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_zoningdistrict_qn.sql&
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_zoningdistrict_si.sql&
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_zoningdistrict_bk.sql&
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_zoningdistrict_bx.sql
wait
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_zoningdistrict.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_commercialoverlay.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_specialdistrict.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_limitedheight.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_zonemap.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_parks.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_correctdups.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_correctgaps.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/zoning_splitzone.sql


echo '\nFilling in FAR values \e[32m'
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/far.sql

echo '\nPopulating building class for condos lots and land use field \e[32m'
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/bldgclass.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/landuse.sql

echo '\nFlagging tax lots within the FEMA floodplain \e[32m'
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/flood_flag.sql

# echo '\nBackfilling'
# docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/backfill.sql

echo '\nAdding in geometries that are in the DTM but not in RPAD'
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/dtmgeoms.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/geomclean.sql

echo '\nPopulating PLUTO tags and version fields \e[32m'
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/plutomapid.sql
docker exec pluto psql -U $DBUSER -d $DBNAME -f sql/versions.sql