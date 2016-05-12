#!/bin/bash

set -ev

TAG="$REPOSITORY/$PROJECT-$ARCH"
TAGSPECIFIER="$VERSION"

case "$VERSION" in
    *-jre) PACKTAG=jessie-curl ;;
    *-jdk) PACKTAG=jessie-scm  ;;
    *    ) exit 1
esac

docker pull   "$REPOSITORY/buildpack-$ARCH:$PACKTAG"
docker tag -f "$REPOSITORY/buildpack-$ARCH:$PACKTAG" "buildpack-deps:$PACKTAG"

docker build -t "$TAG:$TAGSPECIFIER" "$PROJECT/$VERSION"
