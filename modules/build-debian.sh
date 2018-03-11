#!/usr/bin/env bash

set -e

import com.encodeering.ci.config
import com.encodeering.ci.docker

case "$VERSION" in
    *-jre) PACKTAG=jessie-curl ;;
    *-jdk) PACKTAG=jessie-scm  ;;
    *    ) exit 1
esac

docker-pull "$REPOSITORY/buildpack-$ARCH:$PACKTAG" "buildpack-deps:$PACKTAG"

case "$VARIANT" in
    openjdk )
        docker-build "$PROJECT/$VERSION"
        ;;
    oracle )
        docker-build --build-arg VERSION="$VERSION"       \
                     --build-arg VERSIONSHA="$VERSIONSHA" \
                     --build-arg DOWNLOAD="$DOWNLOAD"     \
                     --build-arg LEGAL="$LEGAL"           \
                     "java-oracle"
        ;;
esac


