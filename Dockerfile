FROM python:latest


FROM webmapp/gdal-docker AS gdal-docker

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends postgresql-client git build-essential cmake proj-bin jq curl zip
    
RUN curl https://dl.min.io/client/mc/release/linux-amd64/mc \
    --create-dirs \
    -o $HOME/minio-binaries/mc \
    && chmod +x $HOME/minio-binaries/mc \ 
    && export PATH=$PATH:$HOME/minio-binaries/
