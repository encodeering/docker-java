#!/usr/bin/env bash

set -e

import com.encodeering.ci.common
import com.encodeering.ci.config
import com.encodeering.ci.docker

docker-pull "$REPOSITORY/alpine-$ARCH:3.8" "alpine:3.8"

docker-build "$PROJECT/${VERSION%%-*}/${VERSION##*-}/alpine"

docker-verify java -version
