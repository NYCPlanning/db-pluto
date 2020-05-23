#!/bin/bash

function setup {
sudo apt update
sudo apt install -y curl zip

sudo tee /etc/apt/sources.list.d/pgdg.list << END
deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main
END
# get the signing key and import it
curl -O https://www.postgresql.org/media/keys/ACCC4CF8.asc
sudo apt-key add ACCC4CF8.asc

sudo apt update
sudo apt install -y postgresql-client-11 gdal-bin
sudo apt autoremove
rm ACCC4CF8.asc

curl -O https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
sudo mv ./mc /usr/bin
mc config host add spaces $AWS_S3_ENDPOINT $AWS_ACCESS_KEY_ID $AWS_SECRET_ACCESS_KEY --api S3v4
}
register 'setup' 'init' 'install all dependencies' setup
