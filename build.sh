#!/bin/sh
set -eux

ARCH=$(uname -m)
TAG=beohoang98/canvas-lms-docker:$ARCH
docker build -t $TAG --platform $ARCH .
docker tag $TAG beohoang98/canvas-lms-docker:latest
