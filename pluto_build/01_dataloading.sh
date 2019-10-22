#!/bin/bash

# Create a postgres database container pluto
DB_CONTAINER_NAME=pluto
# command line argument, yes or no
GEOCODE=$1
PUBLISH=$2

[ ! "$(docker ps -a | grep $DB_CONTAINER_NAME)" ]\
     && docker run -itd --name=$DB_CONTAINER_NAME\
            -v `pwd`:/home/pluto_build\
            -w /home/pluto_build\
            --shm-size=4g\
            --env-file .env\
            -p 3484:5432\
            mdillon/postgis

## Wait for database to get ready, this might take 5 seconds of trys
docker start $DB_CONTAINER_NAME
until docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres; do
    echo "Waiting for postgres container..."
    sleep 0.5
done

docker inspect -f '{{.State.Running}}' $DB_CONTAINER_NAME
docker exec pluto psql -U postgres -h localhost -c "SELECT 'DATABSE IS UP';"

## load data into the pluto container
docker run --rm\
            --network=host\
            -v `pwd`/python:/home/python\
            -w /home/python\
            --env-file .env\
            sptkl/cook:latest python3 dataloading.py $GEOCODE

# if yes, then geocode, if no skip
if [ "$GEOCODE" == "yes" ]; then
    echo "geocoding pts starts here, might take a while ..."
    # Geocode pts
    docker run --rm\
                -v `pwd`/python:/home/python\
                -w /home/python\
                --env-file .env\
                --network=host\
                sptkl/docker-geosupport:19b2 bash -c "pip install pandas sqlalchemy psycopg2-binary; python3 geocode.py"

    docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "
    DROP TABLE IF EXISTS pluto_input_geocodes;
    CREATE TABLE pluto_input_geocodes (
        borough text,
        block text,
        lot text,
        input_hnum text,
        input_sname text,
        easement text,
        billingbbl text,
        bbl text,
        communitydistrict text,
        censustract2010 text,
        censusblock2010 text,
        communityschooldistrict text,
        citycouncildistrict text,
        zipcode text,
        firecompanynumber text,
        policeprecinct text,
        healthcenterdistrict text,
        healtharea text,
        sanitationdistrict text,
        sanitationcollectionscheduling text,
        boepreferredstreetname text,
        numberofexistingstructures text,
        taxmapnumbersectionandvolume text,
        sanbornmapidentifier text,
        xcoord text,
        ycoord text,
        longitude text,
        latitude text,
        grc text,
        grc2 text, 
        msg text,
        msg2 text
    );"

    docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "\COPY pluto_input_geocodes FROM python/geo_result.csv WITH NULL AS '' DELIMITER ',' CSV HEADER;"

    docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres -c "
        ALTER TABLE pluto_input_geocodes
            ADD COLUMN IF NOT EXISTS wkb_geometry geometry(Geometry,4326);

        UPDATE pluto_input_geocodes
        SET wkb_geometry = ST_SetSRID(ST_Point(longitude::DOUBLE PRECISION,
                            latitude::DOUBLE PRECISION), 4326),
            xcoord = ST_X(ST_TRANSFORM(wkb_geometry, 2263))::integer,
            ycoord = ST_Y(ST_TRANSFORM(wkb_geometry, 2263))::integer
        ;
    "
    if [ "$PUBLISH" == "yes" ]; then
        docker exec $DB_CONTAINER_NAME bash -c '
            pg_dump -t pluto_input_geocodes --no-owner -U postgres -d postgres | psql $RECIPE_ENGINE
            DATE=$(date "+%Y/%m/%d"); 
            psql $RECIPE_ENGINE -c "CREATE SCHEMA IF NOT EXISTS pluto_input_geocodes;";
            psql $RECIPE_ENGINE -c "ALTER TABLE pluto_input_geocodes SET SCHEMA pluto_input_geocodes;";
            psql $RECIPE_ENGINE -c "DROP TABLE IF EXISTS pluto_input_geocodes.\"$DATE\";";
            psql $RECIPE_ENGINE -c "ALTER TABLE pluto_input_geocodes.pluto_input_geocodes RENAME TO \"$DATE\";";
        '
    fi
    docker exec $DB_CONTAINER_NAME rm python/geo_result.csv
fi