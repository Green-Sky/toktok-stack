#!/bin/sh

set -eux

# Build the entire set of docker images for the toktok dev container.
(cd dockerfiles/bazel && ./build.sh && docker build -t ghcr.io/toktok/bazel:latest .)
docker build -t toxchat/toktok-stack:latest-third_party -f tools/built/src/Dockerfile.third_party .
docker build -t toxchat/toktok-stack:latest -f tools/built/src/Dockerfile .

docker compose run --rm fastbuild
