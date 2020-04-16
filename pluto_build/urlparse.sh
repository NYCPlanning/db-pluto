#!/bin/bash
proto="$(echo $1 | grep :// | sed -e's,^\(.*://\).*,\1,g')"
url=$(echo $1 | sed -e s,$proto,,g)
userpass="$(echo $url | grep @ | cut -d@ -f1)"
BUILD_PWD=`echo $userpass | grep : | cut -d: -f2`
BUILD_USER=`echo $userpass | grep : | cut -d: -f1`
hostport=$(echo $url | sed -e s,$userpass@,,g | cut -d/ -f1)
BUILD_HOST="$(echo $hostport | sed -e 's,:.*,,g')"
BUILD_PORT="$(echo $hostport | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"
BUILD_DB="$(echo $url | grep / | cut -d/ -f2-)"