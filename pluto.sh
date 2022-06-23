#!/bin/bash
source pluto_build/bin/config.sh
max_bg_procs 5

function dataloading {
    docker compose exec -T ./01_dataloading.sh
}
register 'build ''dataloading' 'build dataloading' dataloading