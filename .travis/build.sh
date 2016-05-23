#!/bin/bash

set -ev

TAG="$REPOSITORY/$PROJECT-$ARCH"
TAGSPECIFIER="$VERSION${CUSTOM:+-$CUSTOM}"

case "$VERSION" in
    *-jre) PACKTAG=jessie-curl ;;
    *-jdk) PACKTAG=jessie-scm  ;;
    *    ) exit 1
esac

docker pull   "$REPOSITORY/buildpack-$ARCH:$PACKTAG"
docker tag -f "$REPOSITORY/buildpack-$ARCH:$PACKTAG" "buildpack-deps:$PACKTAG"

case "$CUSTOM" in
    openjdk )
        patch -p1 --no-backup-if-mismatch --directory=$PROJECT < .patch/$VERSION/Dockerfile.patch

        docker build -t "$TAG:$TAGSPECIFIER" \
                     --build-arg ARCH="$ARCH" \
                     --build-arg JAVA_DEBIAN_VERSION="$VERSIONPIN" \
                     "$PROJECT/$VERSION"

        docker run --rm "$TAG:$TAGSPECIFIER" java -version
        ;;
    oracle )
        sed -i "/FROM/ s/:.*$/:$PACKTAG/g" contrib/java/Dockerfile

        docker build -t "$TAG:$TAGSPECIFIER" \
                     --build-arg VERSION="$VERSION"       \
                     --build-arg VERSIONSHA="$VERSIONSHA" \
                     --build-arg DOWNLOAD="$DOWNLOAD"     \
                     --build-arg LEGAL="$LEGAL"           \
                     "contrib/java"

        if docker run --rm -e eula-java=accept "$TAG:$TAGSPECIFIER" java -version; then             true; fi
        if docker run --rm -e eula-java=       "$TAG:$TAGSPECIFIER" java -version; then false; else true; fi
        ;;
esac


