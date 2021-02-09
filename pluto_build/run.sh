#!/bin/bash
source bin/config.sh
source bin/pts.sh
source bin/ssh.sh

case $1 in 
    import_pts) import_pts;;
    geocode_pts) geocode_pts;;
    clean_pts) clean_pts;;
    *) echo $@;;
esac