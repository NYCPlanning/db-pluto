#!/bin/bash
source bin/config.sh

# # QAQC EXPECTED VALUE ANALYSIS
# psql $BUILD_ENGINE \
#   -v VERSION=$VERSION \
#   -f sql/qaqc_expected.sql &

# QAQC MISMATCH ANALYSIS
echo "Running QAQC Mismatch"
echo "Condo=true, mapped=false, condition is bbl ends with 75%%"
psql $BUILD_ENGINE \
  -v VERSION=$VERSION \
  -v VERSION_PREV=$VERSION_PREV \
  -v CONDO='TRUE' \
  -v MAPPED='FALSE'\
  -v CONDITION="WHERE right(a.bbl::bigint::text, 4) LIKE '75%%'" \
  -f sql/qaqc_mismatch.sql 

echo "Condo=true, mapped=true, condition is bbl ends with 75%% and geom not null"
psql $BUILD_ENGINE \
  -v VERSION=$VERSION \
  -v VERSION_PREV=$VERSION_PREV \
  -v CONDO='TRUE' \
  -v MAPPED='TRUE'\
  -v CONDITION="WHERE right(a.bbl::bigint::text, 4) LIKE '75%%' AND a.geom IS NOT NULL" \
  -f sql/qaqc_mismatch.sql 

echo "Condo=false, mapped=false, no condition passed"
psql $BUILD_ENGINE \
  -v VERSION=$VERSION \
  -v VERSION_PREV=$VERSION_PREV \
  -v CONDO='FALSE' \
  -v MAPPED='FALSE'\
  -v CONDITION="" \
  -f sql/qaqc_mismatch.sql 

echo "Condo=false, mapped=true, condition is geom is not null"
psql $BUILD_ENGINE \
  -v VERSION=$VERSION \
  -v VERSION_PREV=$VERSION_PREV \
  -v CONDO='FALSE' \
  -v MAPPED='TRUE'\
  -v CONDITION="WHERE a.geom IS NOT NULL" \
  -f sql/qaqc_mismatch.sql 

# # QAQC NULL ANALYSIS
# psql $BUILD_ENGINE \
#   -v VERSION=$VERSION \
#   -v VERSION_PREV=$VERSION_PREV \
#   -v CONDO='TRUE' \
#   -v MAPPED='FALSE'\
#   -v CONDITION="WHERE right(a.bbl::bigint::text, 4) LIKE '75%%'" \
#   -f sql/qaqc_null.sql &

# psql $BUILD_ENGINE \
#   -v VERSION=$VERSION \
#   -v VERSION_PREV=$VERSION_PREV \
#   -v CONDO='TRUE' \
#   -v MAPPED='TRUE'\
#   -v CONDITION="WHERE right(a.bbl::bigint::text, 4) LIKE '75%%' AND a.geom IS NOT NULL" \
#   -f sql/qaqc_null.sql &

# psql $BUILD_ENGINE \
#   -v VERSION=$VERSION \
#   -v VERSION_PREV=$VERSION_PREV \
#   -v CONDO='FALSE' \
#   -v MAPPED='FALSE'\
#   -v CONDITION="" \
#   -f sql/qaqc_null.sql &

# psql $BUILD_ENGINE \
#   -v VERSION=$VERSION \
#   -v VERSION_PREV=$VERSION_PREV \
#   -v CONDO='FALSE' \
#   -v MAPPED='TRUE'\
#   -v CONDITION="WHERE a.geom IS NOT NULL" \
#   -f sql/qaqc_null.sql &

# # QAQC AGGREGATE ANALYSIS
# psql $BUILD_ENGINE \
#   -v VERSION=$VERSION \
#   -v CONDO='TRUE' \
#   -v MAPPED='FALSE'\
#   -v CONDITION="WHERE right(bbl::bigint::text, 4) LIKE '75%%'" \
#   -f sql/qaqc_aggregate.sql &

# psql $BUILD_ENGINE \
#   -v VERSION=$VERSION \
#   -v CONDO='TRUE' \
#   -v MAPPED='TRUE'\
#   -v CONDITION="WHERE right(bbl::bigint::text, 4) LIKE '75%%' AND geom IS NOT NULL" \
#   -f sql/qaqc_aggregate.sql &

# psql $BUILD_ENGINE \
#   -v VERSION=$VERSION \
#   -v CONDO='FALSE' \
#   -v MAPPED='FALSE'\
#   -v CONDITION="" \
#   -f sql/qaqc_aggregate.sql &

# psql $BUILD_ENGINE \
#   -v VERSION=$VERSION \
#   -v CONDO='FALSE' \
#   -v MAPPED='TRUE'\
#   -v CONDITION="WHERE geom IS NOT NULL" \
#   -f sql/qaqc_aggregate.sql

# wait 
# echo 'QAQC is complete!'
# exit 0