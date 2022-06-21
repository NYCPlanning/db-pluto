# [Choice] Python version (use -bullseye variants on local arm64/Apple Silicon): 3, 3.10, 3.9, 3.8, 3.7, 3.6, 3-bullseye, 3.10-bullseye, 3.9-bullseye, 3.8-bullseye, 3.7-bullseye, 3.6-bullseye, 3-buster, 3.10-buster, 3.9-buster, 3.8-buster, 3.7-buster, 3.6-buster
ARG VARIANT=3-bullseye
FROM mcr.microsoft.com/vscode/devcontainers/python:${VARIANT}

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# [Optional] If your pip requirements rarely change, uncomment this section to add them to the image.
# COPY requirements.txt /tmp/pip-tmp/
# RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
#    && rm -rf /tmp/pip-tmp

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1
# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends postgresql-client git build-essential cmake proj-bin

# Install Docker CE CLI
RUN apt-get update \
    && apt-get install -y apt-transport-https ca-certificates curl gnupg2 lsb-release \
    && curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null \
    && echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce-cli

# Install Docker Compose
RUN export LATEST_COMPOSE_VERSION=$(curl -sSL "https://api.github.com/repos/docker/compose/releases/latest" | grep -o -P '(?<="tag_name": ").+(?=")') \
    && curl -sSL "https://github.com/docker/compose/releases/download/${LATEST_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# compile the gdal for geodatabase exporting
# RUN curl --silent --show-error \
#     https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
#     curl --silent --show-error \
#     https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
#     apt-get update && \
#     ACCEPT_EULA=Y DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
#     unixodbc-dev \
#     msodbcsql \
#     mssql-tools && \
#     rm -rf /var/lib/apt/lists/*

# RUN sudo su \
#     curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
#     #Download appropriate package for the OS version
#     #Debian 11
#     curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
#     exit \
#     sudo apt-get update \ 
#     sudo ACCEPT_EULA=Y apt-get install -y msodbcsql17 \
#     # optional: for bcp and sqlcmd
#     sudo ACCEPT_EULA=Y apt-get install -y mssql-tools \
#     echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc \
#     source ~/.bashrc \
#     # optional: for unixODBC development headers
#     sudo apt-get install -y unixodbc-dev \
#     # optional: kerberos library for debian-slim distributions
#     sudo apt-get install -y libgssapi-krb5-2

ENV FGDB_SOURCE https://raw.githubusercontent.com/Esri/file-geodatabase-api/master/FileGDB_API_1.5/FileGDB_API_1_5_64gcc51.tar.gz
RUN curl --silent --show-error -o /usr/local/src/filgdb_api.tar.gz ${FGDB_SOURCE} && \
    tar -xzvf /usr/local/src/filgdb_api.tar.gz -C /usr/local && \
    rm /usr/local/FileGDB_API-64gcc51/lib/libstdc++.so.6 && \
    ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/local/FileGDB_API-64gcc51/lib/libstdc++.so.6
ENV LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:/usr/local/FileGDB_API-64gcc51/lib"

ENV GDAL_SOURCE https://github.com/OSGeo/gdal/archive/refs/heads/master.zip
RUN wget -O /usr/local/src/gdal-master.zip ${GDAL_SOURCE} && \
    unzip /usr/local/src/gdal-master.zip -d /usr/local/src && \
    cd /usr/local/src/gdal-master && \
    mkdir build && cd build && \
    cmake .. && cmake --build . && cmake --build . --target install && \
    cmake FileGDB_INCLUDE_DIR=/usr/local/FileGDB_API-64gcc51/include FileGDB_LIBRARY=LD_LIBRARY_PATH \
    #PROJ_LIBRARY= PROJ_INCLUDE_DIR=
    #autoconf -i && \
    # ./configure \
    # --with-python \
    # --with-geos \
    # --with-spatialite \
    # --with-pg \
    # --with-freexl \
    # --with-curl \
    # --with-libkml \
    # --with-wfs \
    # --with-odbc=/opt/microsoft/msodbcsql/lib64 \
    # --with-fgdb=/usr/local/FileGDB_API-64gcc51 \
    # --with-proj=/usr/local && \
    # make && make install && ldconfig