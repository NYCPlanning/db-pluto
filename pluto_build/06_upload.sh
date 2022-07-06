#!/bin/bash

CURRENT_DIR=$(dirname "$(readlink -f "$0")")
cd $CURRENT_DIR
source bin/config.sh

wait
Upload latest & 
Upload $DATE &
Upload $VERSION &
 
wait
exit 0