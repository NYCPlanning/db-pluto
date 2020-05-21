#!/bin/bash

function drop_all {
    psql $BUILD_ENGINE -c "
    DO \$\$ DECLARE
        r RECORD;
    BEGIN
        FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public' and tablename !='spatial_ref_sys') LOOP
            EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
        END LOOP;
    END \$\$;
    "
}
register 'dataloading' 'drop' 'drop all tables' drop_all

function load {
    ## load data into the pluto db
    docker run --rm\
        -v $(pwd)/python:/home/python\
        -w /home/python\
        -e BUILD_ENGINE=$BUILD_ENGINE\
        -e RECIPE_ENGINE=$RECIPE_ENGINE\
        sptkl/cook:latest python3 fastloading.py
}
register 'dataloading' 'load' 'load all tables' load

function source_data_versions {
    # Create data version table 
    psql $BUILD_ENGINE -f sql/source_data_versions.sql
}
register 'dataloading' 'source' 'create data version table' source_data_versions

function load_all {
    drop_all
    load
    source_data_versions
}
register 'dataloading' 'all' '(main) drop all, then load all, and create data version table' load_all