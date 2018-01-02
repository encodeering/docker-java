#!/usr/bin/env bash
# configuration
#   env.ARCH
#   env.PROJECT
#   env.VERSION
#   env.VERSIONSHA
#   env.REPOSITORY
#   env.DOWNLOAD
#   env.LEGAL

set -e

import com.encodeering.docker.config
import com.encodeering.docker.docker

case "$VERSION" in
    *-jre) PACKTAG=jessie-curl ;;
    *-jdk) PACKTAG=jessie-scm  ;;
    *    ) exit 1
esac

docker-pull "$REPOSITORY/buildpack-$ARCH:$PACKTAG" "buildpack-deps:$PACKTAG"

case "$VARIANT" in
    openjdk )
        patch -p1 --no-backup-if-mismatch --directory=$PROJECT < patch/$VERSION/Dockerfile.patch

        docker build -t "$DOCKER_IMAGE" "$PROJECT/$VERSION"

        docker run --rm "$DOCKER_IMAGE" java -version
        ;;
    oracle )
        docker build -t "$DOCKER_IMAGE" \
                     --build-arg VERSION="$VERSION"       \
                     --build-arg VERSIONSHA="$VERSIONSHA" \
                     --build-arg DOWNLOAD="$DOWNLOAD"     \
                     --build-arg LEGAL="$LEGAL"           \
                     "java-oracle"

        if docker run --rm -e eula-java=accept "$DOCKER_IMAGE" java -version; then             true; fi
        if docker run --rm -e eula-java=       "$DOCKER_IMAGE" java -version; then false; else true; fi
        ;;
esac


