#!/bin/bash

function setup {
    sudo apt update
    sudo apt install -y curl zip

    curl -O https://dl.min.io/client/mc/release/linux-amd64/mc
    chmod +x mc
    sudo mv ./mc /usr/bin
    mc config host add spaces $AWS_S3_ENDPOINT $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY --api S3v4

    docker-compose up -d
}
register 'setup' 'init' 'install all dependencies' setup
