#!/bin/bash
max_bg_procs 5

function dataloading {
    docker compose exec -T ./01_dataloading.sh
}
register 'build ''dataloading' 'build dataloading' dataloading

case $1 in 
    dataloading) dataloading
esac