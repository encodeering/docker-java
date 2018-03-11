#!/usr/bin/env bash

set -e

import com.encodeering.ci.common
import com.encodeering.ci.config
import com.encodeering.ci.docker

[ "$VARIANT" = "openjdk" ] || die "$VARIANT unsupported"

docker-pull "$REPOSITORY/alpine-$ARCH:3.7" "alpine:3.6"

docker-build "$PROJECT/$VERSION/alpine"
