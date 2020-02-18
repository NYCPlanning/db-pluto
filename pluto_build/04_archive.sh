if [ -f versions.env ]
then
  export $(cat versions.env | sed 's/#.*//g' | xargs)
fi
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

pg_dump -t pluto $BUILD_ENGINE | psql $EDM_DATA
psql $EDM_DATA -c "
    DROP INDEX idx_pluto_bbl;
    DROP INDEX pbbl_ix;
    DROP INDEX pluto_gix;
    CREATE SCHEMA IF NOT EXISTS dcp_pluto;
    ALTER TABLE pluto SET SCHEMA dcp_pluto;
    DROP TABLE IF EXISTS dcp_pluto.\"$VERSION\";
    ALTER TABLE dcp_pluto.pluto RENAME TO \"$VERSION\";";