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

patch -p1 --no-backup-if-mismatch --directory=$PROJECT < .patch/$VERSION/Dockerfile.patch

docker build -t "$TAG:$TAGSPECIFIER" \
             --build-arg ARCH="$ARCH" \
             --build-arg JAVA_DEBIAN_VERSION="$VERSIONPIN" \
             "$PROJECT/$VERSION"

docker run --rm "$TAG:$TAGSPECIFIER" java -version
