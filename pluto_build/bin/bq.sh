#!/bin/bash
function upload_to_bigquery {
    local dataset=${1:-dcp_mappluto}
    FILEPATH=$dataset/$VERSION/$dataset.csv
    echo https://nyc3.digitaloceanspaces.com/edm-recipes/datasets/$FILEPATH
    curl -O https://nyc3.digitaloceanspaces.com/edm-recipes/datasets/$FILEPATH
    gsutil cp $dataset.csv gs://edm-temporary/$FILEPATH
    rm $dataset.csv
    location=US
    dataset=$dataset
    tablename=$dataset.$(tr [A-Z] [a-z] <<< "$VERSION")
    echo $tablename
    bq show $dataset || bq mk --location=$location --dataset $dataset
    bq show $tablename || bq mk $tablename
    bq load \
        --location=$location\
        --source_format=CSV\
        --quote '"' \
        --skip_leading_rows 1\
        --replace\
        --allow_quoted_newlines\
        $tablename \
        gs://edm-temporary/$FILEPATH \
        ../schemas/$dataset.json
}

register 'bq' 'publish' 'publish to bigquery' upload_to_bigquery