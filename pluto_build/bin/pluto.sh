#!/bin/bash
function first_step {
    echo "This is happening"
    docker compose exec -T pluto /src/pluto_build/00_setup.sh
}
register 'run' 'first_step' 'run first_step' first_step

function dataloading {
    docker compose exec -T pluto /src/pluto_build/01_dataloading.sh
}
register 'run' 'dataloading' 'run dataloading' dataloading

function build {
    docker compose exec -T pluto /src/pluto_build/02_build.sh
}
register 'run' 'build' 'run build' build

function corrections {
        docker compose exec -T pluto /src/pluto_build/03_corrections.sh
}
register 'run' 'corrections' 'run corrections' corrections

function archive {
        docker compose exec -T pluto /src/pluto_build/04_archive.sh
}
register 'run' 'archive' 'run archive' archive

function export {
        docker compose exec -T pluto /src/pluto_build/05_export.sh
}
register 'run' 'export' 'run export' export

function upload {
        docker compose exec -T pluto /src/pluto_build/06_upload.sh
}
register 'run' 'upload' 'run upload' upload

case $1 in
        setup) setup;;
    dataloading) dataloading ;;
    build) build ;;
    corrections) corrections;;
    archive) archive;;
    export) export;;
    upload) upload;;
esac