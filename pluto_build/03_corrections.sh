#!/bin/sh
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

psql $BUILD_ENGINE -f sql/corr_create.sql

# echo "Applying corrections to PLUTO"
psql $BUILD_ENGINE -f sql/corr_lotarea.sql
psql $BUILD_ENGINE -f sql/corr_yearbuilt_lpc.sql
psql $BUILD_ENGINE -f sql/corr_ownername_city.sql
psql $BUILD_ENGINE -f sql/corr_communitydistrict.sql
psql $BUILD_ENGINE -f sql/corr_inwoodrezoning.sql
psql $BUILD_ENGINE -f sql/corr_dropoldrecords.sql
psql $BUILD_ENGINE -f sql/remove_unitlots.sql

psql $BUILD_ENGINE  -c "\COPY (SELECT * FROM pluto_corrections) TO STDOUT DELIMITER ',' CSV HEADER;" > output/pluto_corrections.csv
psql $BUILD_ENGINE  -c "\COPY (SELECT * FROM pluto_removed_records) TO STDOUT DELIMITER ',' CSV HEADER;" > output/pluto_removed_records.csv

# # Run qaqc
# docker run --rm\
#     -v `pwd`/python/qaqc:/home/qaqc\
#     -w /home/qaqc\
#     --env-file .env\
#     sptkl/cook:latest python3 qaqc.py