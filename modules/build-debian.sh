#!/usr/bin/env bash

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
        patch -p1 --no-backup-if-mismatch --directory=$PROJECT < patch/$BASE/$VERSION/Dockerfile.patch

        docker build -t "$DOCKER_IMAGE" "$PROJECT/$VERSION"
        ;;
    oracle )
        docker build -t "$DOCKER_IMAGE" \
                     --build-arg VERSION="$VERSION"       \
                     --build-arg VERSIONSHA="$VERSIONSHA" \
                     --build-arg DOWNLOAD="$DOWNLOAD"     \
                     --build-arg LEGAL="$LEGAL"           \
                     "java-oracle"
        ;;
esac


