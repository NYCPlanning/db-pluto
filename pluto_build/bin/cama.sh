#!/bin/bash
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
        VERSION=$(date "+%Y%m%d")
        mv $PATH_TXT pluto_input_cama_dof.csv

        # Check number of rows
        wc -l pluto_input_cama_dof.csv

        # Check number of columns
        awk -F'|' '{print NF; exit}' pluto_input_cama_dof.csv

        # Data Cleaning, remove special characters
        sed -i 's/\r$//g' pluto_input_cama_dof.csv
        sed -i 's/\"//g' pluto_input_cama_dof.csv

        # Load to psql
        cat pluto_input_cama_dof.csv | psql $RECIPE_ENGINE -v NAME=$NAME -v VERSION=$VERSION -f $DIR/sql/_load_cama.sql
        rm pluto_input_cama_dof.csv

        # Create Outputs in preparation for data library
        psql $RECIPE_ENGINE -1 -c "\COPY ( SELECT * FROM $NAME ) TO stdout DELIMITER ',' CSV HEADER;" > pluto_input_cama_dof.csv
        mc cp pluto_input_cama_dof.csv spaces/edm-recipes/tmp/pluto_input_cama_dof.csv
        
        # Tag table
        psql $RECIPE_ENGINE -1 -v NAME=$NAME -v VERSION=$VERSION -f $DIR/sql/_tag.sql
    )
}
register 'import' 'cama' 'import cama' cama

function clean_cama {
    rm -rf /tmp/cama
    mc rm spaces/edm-recipes/tmp/pluto_input_cama_dof.csv
}
register 'clean' 'cama' 'clean cama' clean_cama 