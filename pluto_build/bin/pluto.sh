#!/bin/bash
function dataloading {
    docker compose exec -T pluto pwd
    docker compose exec -T pluto ./pluto_build/01_dataloading.sh
}
register 'build' 'dataloading' 'build dataloading' dataloading

case $1 in 
    dataloading) dataloading ;;
esac