#!/bin/bash
CURRENT_DIR=$(dirname "$(readlink -f "$0")")
source $CURRENT_DIR/bin/config.sh

wait
Upload latest & 
Upload $DATE &
Upload $VERSION &
 
wait
exit 0