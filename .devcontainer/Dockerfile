# [Choice] Python version (use -bullseye variants on local arm64/Apple Silicon): 3, 3.10, 3.9, 3.8, 3.7, 3.6, 3-bullseye, 3.10-bullseye, 3.9-bullseye, 3.8-bullseye, 3.7-bullseye, 3.6-bullseye, 3-buster, 3.10-buster, 3.9-buster, 3.8-buster, 3.7-buster, 3.6-buster
ARG VARIANT=3-bullseye
#FROM webmapp/gdal-docker AS gdal-docker

FROM mcr.microsoft.com/vscode/devcontainers/python:${VARIANT} as base_image

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends postgresql-client git build-essential cmake proj-bin jq libproj-dev

# Potential GDAL Build Solution
# RUN curl -O https://dl.min.io/client/mc/release/linux-amd64/mc \
#     && chmod +x mc \
#     && mv ./mc /usr/bin 

ENV FGDB_SOURCE https://raw.githubusercontent.com/Esri/file-geodatabase-api/master/FileGDB_API_1.5.2/FileGDB_API-RHEL7-64gcc83.tar.gz
RUN curl --silent --show-error -o /usr/local/src/filgdb_api.tar.gz ${FGDB_SOURCE} && \
    tar -xzvf /usr/local/src/filgdb_api.tar.gz -C /usr/local
#ENV LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:/usr/local/FileGDB_API-64gcc51/lib"

ENV GDAL_SOURCE=http://download.osgeo.org/gdal/3.5.1/gdal-3.5.1.tar.gz
RUN wget -O /usr/local/src/gdal-master.tar.gz ${GDAL_SOURCE} 
RUN tar -xzvf /usr/local/src/gdal-master.tar.gz -C /usr/local/src/ 
# This step needs ENV flags to cmake .. to add FGDB support, may need addition dependency installation

RUN cd /usr/local/src/gdal-3.5.1/ && mkdir build && cmake .. && cmake --build . --target install 
#./configure --with-python --with-geos --with-spatialite --with-pg --with-freexl --with-curl --with-libkml --with-wfs --with-odbc=/opt/microsoft/msodbcsql/lib64 --with-fgdb=/usr/local/FileGDB_API-64gcc51 --with-static-proj4 && make && make install && ldconfig

# Potential Copy from gdal-docker solution

# COPY --from=gdal-docker /usr/local/FileGDB_API-64gcc51 /usr/local/FileGDB_API-64gcc51
# COPY --from=gdal-docker /usr/local/src/gdal-master/ /usr/local/src/gdal-master

# COPY --from=gdal-docker /usr/local/lib/lib* /usr/local/lib/
# COPY --from=gdal-docker /usr/local/lib/gdalplugins /usr/local/lib/

# COPY --from=gdal-docker /usr/local/src/gdal-master /usr/local/src/

# COPY --from=gdal-docker /usr/local/bin/gdal* /usr/local/bin/
# COPY --from=gdal-docker /usr/local/bin/ogr* /usr/local/bin/
# COPY --from=gdal-docker /usr/local/include/gdal* /usr/local/include/
# COPY --from=gdal-docker /usr/local/include/ogr* /usr/local/include/
# #COPY --from=gdal-docker /usr/lib/x86_64-linux-gnu/libcrypt* /usr/lib/x86_64-linux-gnu/
# COPY --from=gdal-docker /usr/lib/libgdal* /usr/lib/

#ENV LD_LIBRARY_PATH=:/usr/local/FileGDB_API-64gcc51/lib
# RUN ldconfig