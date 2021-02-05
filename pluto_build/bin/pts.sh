#!/bin/bash
DIR=$(pwd)

function import_pts {
   # create temporary location
   NAME="pluto_pts"
   VERSION=$(date "+%Y%m%d")

   mkdir -p /tmp/pts && 
   (
      cd /tmp/pts

      ssh_cmd get Prod_FromDOF/PTS_Propmast.gz .
      gunzip PTS_Propmast.gz
      
      # remove last column of pts --> empty column
      cut -d$'\t' -f1-139 PTS_Propmast > $NAME.csv

      # remove spaces between delimiters
      sed -i 's/ *\t/\t/g' $NAME.csv
      sed -i 's/\"//g' $NAME.csv

      # Check number of rows
      wc -l $NAME.csv

      # Check number of columns
      awk -F'\t' '{print NF; exit}' $NAME.csv

      # Load to psql
      cat $NAME.csv | psql $RECIPE_ENGINE -v NAME=$NAME -v VERSION=$VERSION -f $DIR/sql/_load_pts.sql
      rm $NAME.csv

      # Create Outputs in preparation for data library
      psql $RECIPE_ENGINE -1 -c "\COPY ( SELECT * FROM $NAME ) TO stdout DELIMITER ',' CSV HEADER;" > $NAME.csv
      pg_dump $RECIPE_ENGINE -t $NAME -x -O -c > $NAME.sql
      mc cp $NAME.csv spaces/edm-recipes/datasets/$NAME/$VERSION/$NAME.csv
      mc cp $NAME.sql spaces/edm-recipes/datasets/$NAME/$VERSION/$NAME.sql
      mc cp $NAME.csv spaces/edm-recipes/datasets/$NAME/latest/$NAME.csv
      mc cp $NAME.sql spaces/edm-recipes/datasets/$NAME/latest/$NAME.sql

      # Tag table
      psql $RECIPE_ENGINE -1 -v NAME=$NAME -v VERSION=$VERSION -f $DIR/sql/_tag.sql
   )
   rm -rf /tmp/pts
}
register 'import' 'pts' 'import pts' import_pts

function pts_geocode {
   docker run --rm\
      -v $(pwd)/python:/home/python\
      -w /home/python\
      -e RECIPE_ENGINE=$RECIPE_ENGINE\
      nycplanning/docker-geosupport:latest python3 geocode.py
}
register 'geocode' 'pts' 'geocode pts' pts_geocode