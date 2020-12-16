#!/bin/bash
function numbldgs_geocode {
     docker run --rm\
        -v $(pwd)/python:/home/python\
        -w /home/python\
        -e RECIPE_ENGINE=$RECIPE_ENGINE\
        -e API_TOKEN=$API_TOKEN\
       nycplanning/docker-geosupport:latest python3 numbldgs.py
}
register 'numbldgs' 'geocode' 'geocode numbldgs' numbldgs_geocode