#!/usr/bin/env bash

set -e

import com.encodeering.ci.config
import com.encodeering.ci.docker

case "$VERSION" in
    7-jre) PACKTAG=jessie-curl ;;
    7-jdk) PACKTAG=jessie-scm  ;;
    8-jre) PACKTAG=stretch-curl ;;
    8-jdk) PACKTAG=stretch-scm  ;;
    *    ) exit 1
esac

docker-pull "$REPOSITORY/buildpack-$ARCH:$PACKTAG" "buildpack-deps:$PACKTAG"

docker-build "$PROJECT/${VERSION%%-*}/${VERSION##*-}"

docker-verify java -version 2>&1 | dup | contains "${ALIAS}"
