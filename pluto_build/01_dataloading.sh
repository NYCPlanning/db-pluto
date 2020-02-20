#!/bin/bash
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

# ## load data into the pluto container
# psql $BUILD_ENGINE -c "
# DO \$\$ DECLARE
#     r RECORD;
# BEGIN
#     FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public' and tablename !='spatial_ref_sys') LOOP
#         EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
#     END LOOP;
# END \$\$;
# "
docker run --rm\
            --network=host\
            -v `pwd`/python:/home/python\
            -w /home/python\
            --env-file .env\
            sptkl/cook:latest python3 fastloading.py