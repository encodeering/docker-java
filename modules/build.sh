#!/usr/bin/env bash

set -e

import com.encodeering.docker.config
import com.encodeering.docker.docker

./build-${BASE}.sh

case "$VARIANT" in
    openjdk )
        docker run --rm "$DOCKER_IMAGE" java -version
        ;;
    oracle )
        if docker run --rm -e eula-java=accept "$DOCKER_IMAGE" java -version; then             true; fi
        if docker run --rm -e eula-java=       "$DOCKER_IMAGE" java -version; then false; else true; fi
        ;;
esac
