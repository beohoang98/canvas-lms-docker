#!/bin/sh
set -eux

TAG=beohoang98/canvas-lms-docker:latest
ARCH_TAG=beohoang98/canvas-lms-docker:latest-$(uname -m)

docker build -t $TAG .
docker tag $TAG $ARCH_TAG
