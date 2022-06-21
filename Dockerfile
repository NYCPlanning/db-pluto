FROM python:latest

FROM webmapp/gdal-docker AS gdal-docker

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends postgresql-client git build-essential cmake proj-bin jq
