#!/bin/bash
set -e;
DIR=$(pwd)
function cama {
    # create temporary location
    mkdir -p /tmp/cama && 
    (
        NAME="pluto_input_cama_dof"

        cd /tmp/cama

        # copy to directory
        ssh_cmd get Prod_FromDOF/P9035_CAMAEXT_012921.zip cama.zip
        unzip cama.zip -d $(pwd)
        PATH_TXT=$(ls *.txt)
        BASE_TXT=$(echo $(basename $PATH_TXT) | cut -d'.' -f1)
        VERSION=$(echo $BASE_TXT | cut -d'_' -f 3)
        mv $PATH_TXT $NAME.csv

        # Check number of rows
        wc -l $NAME.csv

        # Check number of columns
        awk -F'|' '{print NF; exit}' $NAME.csv

        # Data Cleaning, remove special characters
        sed -i 's/\r$//g' $NAME.csv
        sed -i 's/\"//g' $NAME.csv

        # Load to psql
        cat $NAME.csv | psql $RECIPE_ENGINE -v NAME=$NAME -v VERSION=$VERSION -f $DIR/sql/_load_cama.sql
        rm $NAME.csv

        # Create Outputs in preparation for data library
        psql $RECIPE_ENGINE -1 -c "\COPY ( SELECT * FROM $NAME ) TO stdout DELIMITER ',' CSV HEADER;" > $NAME.csv
        pg_dump $RECIPE_ENGINE -t $NAME -x -O -c > $NAME.sql
        mc cp $NAME.csv spaces/edm-recipes/datasets/$NAME/$VERSION/$NAME.csv
        mc cp $NAME.sql spaces/edm-recipes/datasets/$NAME/$VERSION/$NAME.sql
        mc cp $NAME.csv spaces/edm-recipes/datasets/$NAME/latest/$NAME.csv
        mc cp $NAME.sql spaces/edm-recipes/datasets/$NAME/latest/$NAME.sql

        # Tag table
        psql $RECIPE_ENGINE -1 -v NAME=$NAME -v VERSION=$VERSION -f $DIR/sql/_tag_cama.sql
    )
    rm -rf /tmp/cama
}
register 'import' 'cama' 'import cama' cama