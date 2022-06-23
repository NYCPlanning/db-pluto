#!/bin/bash
source pluto_build/bin/config.sh
max_bg_procs 5

function init {
    docker compose up -d
    docker compose exec -T ./pluto_build pluto init
}

function pluto_execute {
    docker compose exec -T ./pluto_build pluto $@
}

case $1 in
    init) init ;;
    *) pluto_execute $@ ;;
esac
