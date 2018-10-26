#!/bin/sh

log() {
    TIMESTAMP=[`date "+%Y-%m-%d %H:%M:%S"`]
    echo "$TIMESTAMP $1"
}

log "Start $(basename "$0")"

# set script working directory 
ROOT_DIR=$(dirname "$0")

# get latest download link from the grafan website
URL=$(wget -O - https://grafana.com/grafana/download?platform=arm | grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//' | grep armv7.tar.gz)

# strip version from url
VERSION=$(echo "$URL" | rev | cut -d- -f 2 | cut -d. -f 2,3,4 | rev)

if [ -f "$ROOT_DIR/latest" ]; then
    CURRENT=$(cat $ROOT_DIR/latest)
fi

if [ "$VERSION" != "$CURRENT" ]; then

    log "new version found: '$CURRENT' -> '$VERSION'"

    # downlad Dockerfile from grafana repo
    curl -L https://raw.githubusercontent.com/grafana/grafana/master/packaging/docker/Dockerfile > $ROOT_DIR/Dockerfile

    # download run script from grafan repo
    curl -L https://raw.githubusercontent.com/grafana/grafana/master/packaging/docker/run.sh > $ROOT_DIR/run.sh

    # instructions to get grafana.tar.gz
    GETURL="wget -O /tmp/grafana.tar.gz $URL"

    # remove ARG GRAFANA_TGZ line from Dockerfile
    sed -i "/ARG GRAFANA_TGZ/cENV DEBIAN_FRONTEND=noninteractive" $ROOT_DIR/Dockerfile

    # add wget to apt-get install in Dockerfile
    sed -i '/RUN apt-get update && apt-get install -qq -y tar/cRUN apt-get update && apt-get install -qq -y tar wget && \\' $ROOT_DIR/Dockerfile

    # replace the add file with the contents of $GETURL
    sed -i "/COPY \${GRAFANA_TGZ} \/tmp\/grafana.tar.gz/cRUN $GETURL" $ROOT_DIR/Dockerfile

    echo "$VERSION" > $ROOT_DIR/latest
else
    log "no new version found"
fi