#!/bin/sh

# downlad Dockerfile from grafan repo
curl -L https://raw.githubusercontent.com/grafana/grafana/master/packaging/docker/Dockerfile > ./Dockerfile

curl -L https://raw.githubusercontent.com/grafana/grafana/master/packaging/docker/run.sh > ./build/run.sh
# set contents of geturl.sh to variable
GETURL=$(cat geturl.sh)

# remove ARG GRAFANA_TGZ line from file
sed -i "/ARG GRAFANA_TGZ/cENV DEBIAN_FRONTEND=noninteractive" ./Dockerfile

# add wget to apt-get install
sed -i '/RUN apt-get update && apt-get install -qq -y tar/cRUN apt-get update && apt-get install -qq -y tar wget && \\' ./Dockerfile

# replace the add file with the contents of $GETURL
sed -i "/COPY \${GRAFANA_TGZ} \/tmp\/grafana.tar.gz/cRUN $GETURL" ./Dockerfile
