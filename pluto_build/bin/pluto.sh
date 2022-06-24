#!/bin/bash
function dataloading {
    docker compose exec -T pluto /src/pluto_build/01_dataloading.sh
}
register 'build' 'dataloading' 'build dataloading' dataloading

function build {
    docker compose exec -T pluto /src/pluto_build/02_build.sh
}
register 'build' 'build' 'build build' build

function corrections {
        docker compose exec -T pluto /src/pluto_build/03_corrections.sh
}
register 'build' 'corrections' 'build corrections' corrections

function archive {
        docker compose exec -T pluto /src/pluto_build/04_archive.sh
}
register 'build' 'archive' 'build archive' archive

function export {
        docker compose exec -T pluto /src/pluto_build/05_export.sh
}
register 'build' 'export' 'build export' export

function upload {
        docker compose exec -T pluto /src/pluto_build/06_upload.sh
}
register 'build' 'upload' 'build upload' upload

case $1 in 
    dataloading) dataloading ;;
    build) build ;;
    corrections) corrections;;
    archive) archive;;
    export) export;;
    upload) upload;;
esac