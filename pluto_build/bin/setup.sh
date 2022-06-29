#!/bin/bash

function setup {
    mc config host add spaces $AWS_S3_ENDPOINT $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY --api S3v4
}
register 'setup' 'init' 'install all dependencies' setup
