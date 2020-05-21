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

# Create data version table 
 psql $BUILD_ENGINE -f sql/source_data_versions.sql
