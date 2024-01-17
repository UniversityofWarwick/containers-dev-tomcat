#!/bin/bash

# shellcheck disable=1091
source ./.env

if [[ "$TOMCAT_VERSION" == "" ]]; then
    echo "TOMCAT_VERSION not set"
    exit 1
fi

TAGNAME="universityofwarwick/dev-tomcat:$TOMCAT_VERSION"

docker build \
--build-arg "TOMCAT_VERSION=$TOMCAT_VERSION" \
-t "$TAGNAME" \
.

echo "🎺 Built $TAGNAME"