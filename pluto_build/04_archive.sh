#!/bin/bash
source bin/config.sh

echo 'Create Export'
psql $BUILD_ENGINE -f sql/export.sql

pg_dump -t archive_pluto $BUILD_ENGINE -O -c | psql $EDM_DATA
psql $EDM_DATA -c "
    CREATE SCHEMA IF NOT EXISTS dcp_pluto;
    ALTER TABLE archive_pluto SET SCHEMA dcp_pluto;
    DROP TABLE IF EXISTS dcp_pluto.\"$VERSION\";
    ALTER TABLE dcp_pluto.archive_pluto RENAME TO \"$VERSION\";";

# QAQC EXPECTED VALUE ANALYSIS
psql $EDM_DATA \
  -v VERSION=$VERSION \
  -f sql/qaqc_expected.sql &

# QAQC MISMATCH ANALYSIS
psql $EDM_DATA \
  -v VERSION=$VERSION \
  -v VERSION_PREV=$VERSION_PREV \
  -v CONDO='TRUE' \
  -v MAPPED='FALSE'\
  -v CONDITION="WHERE right(a.bbl::bigint::text, 4) LIKE '75%%'" \
  -f sql/qaqc_mismatch.sql &

psql $EDM_DATA \
  -v VERSION=$VERSION \
  -v VERSION_PREV=$VERSION_PREV \
  -v CONDO='TRUE' \
  -v MAPPED='TRUE'\
  -v CONDITION="WHERE right(a.bbl::bigint::text, 4) LIKE '75%%' AND a.geom IS NOT NULL" \
  -f sql/qaqc_mismatch.sql &

psql $EDM_DATA \
  -v VERSION=$VERSION \
  -v VERSION_PREV=$VERSION_PREV \
  -v CONDO='FALSE' \
  -v MAPPED='FALSE'\
  -v CONDITION="" \
  -f sql/qaqc_mismatch.sql &

psql $EDM_DATA \
  -v VERSION=$VERSION \
  -v VERSION_PREV=$VERSION_PREV \
  -v CONDO='FALSE' \
  -v MAPPED='TRUE'\
  -v CONDITION="WHERE a.geom IS NOT NULL" \
  -f sql/qaqc_mismatch.sql &

# QAQC NULL ANALYSIS
psql $EDM_DATA \
  -v VERSION=$VERSION \
  -v CONDO='TRUE' \
  -v MAPPED='FALSE'\
  -v CONDITION="WHERE right(bbl::bigint::text, 4) LIKE '75%%'" \
  -f sql/qaqc_null.sql &

psql $EDM_DATA \
  -v VERSION=$VERSION \
  -v CONDO='TRUE' \
  -v MAPPED='TRUE'\
  -v CONDITION="WHERE right(bbl::bigint::text, 4) LIKE '75%%' AND a.geom IS NOT NULL" \
  -f sql/qaqc_null.sql &

psql $EDM_DATA \
  -v VERSION=$VERSION \
  -v CONDO='FALSE' \
  -v MAPPED='FALSE'\
  -v CONDITION="" \
  -f sql/qaqc_null.sql &

psql $EDM_DATA \
  -v VERSION=$VERSION \
  -v CONDO='FALSE' \
  -v MAPPED='TRUE'\
  -v CONDITION="WHERE a.geom IS NOT NULL" \
  -f sql/qaqc_null.sql &

# QAQC AGGREGATE ANALYSIS
psql $EDM_DATA \
  -v VERSION=$VERSION \
  -v CONDO='TRUE' \
  -v MAPPED='FALSE'\
  -v CONDITION="WHERE right(bbl::bigint::text, 4) LIKE '75%%'" \
  -f sql/qaqc_aggregate.sql &

psql $EDM_DATA \
  -v VERSION=$VERSION \
  -v CONDO='TRUE' \
  -v MAPPED='TRUE'\
  -v CONDITION="WHERE right(bbl::bigint::text, 4) LIKE '75%%' AND geom IS NOT NULL" \
  -f sql/qaqc_aggregate.sql &

psql $EDM_DATA \
  -v VERSION=$VERSION \
  -v CONDO='FALSE' \
  -v MAPPED='FALSE'\
  -v CONDITION="" \
  -f sql/qaqc_aggregate.sql &

psql $EDM_DATA \
  -v VERSION=$VERSION \
  -v CONDO='FALSE' \
  -v MAPPED='TRUE'\
  -v CONDITION="WHERE geom IS NOT NULL" \
  -f sql/qaqc_aggregate.sql

wait 
echo 'QAQC is complete!'
exit 0