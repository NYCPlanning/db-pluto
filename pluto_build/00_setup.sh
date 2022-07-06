#!/bin/bash
echo "This is happening2"
CURRENT_DIR=$(dirname "$(readlink -f "$0")")
cd $CURRENT_DIR
source bin/setup.sh

setup