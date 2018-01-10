#!/usr/bin/env bash

set -e

import com.encodeering.ci.config
import com.encodeering.ci.docker

./build-${BASE}.sh

case "$VARIANT" in
    openjdk )
        docker-verify java -version
        ;;
    oracle )
           docker-verify-config "-e eula-java=accept"
        if docker-verify java -version; then             true; fi

           docker-verify-config "-e eula-java="
        if docker-verify java -version; then false; else true; fi
        ;;
esac
