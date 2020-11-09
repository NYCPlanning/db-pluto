#!/bin/bash
function pts_geocode {
     docker run --rm\
        -v $(pwd)/python:/home/python\
        -w /home/python\
        -e BUILD_ENGINE=$BUILD_ENGINE\
        -e RECIPE_ENGINE=$RECIPE_ENGINE\
       nycplanning/docker-geosupport:latest python3 geocode.py
}
register 'pts' 'geocode' 'geocode pts' pts_geocode