#!/bin/bash

function setup {
    curl https://dl.min.io/client/mc/release/linux-amd64/mc \
    --create-dirs \
    -o $HOME/minio-binaries/mc \
    chmod +x $HOME/minio-binaries/mc 
    export PATH=$PATH:$HOME/minio-binaries

    mc config host add spaces $AWS_S3_ENDPOINT $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY --api S3v4
}

register 'setup' 'init' 'install all dependencies' setup