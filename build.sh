#!/bin/sh
set -eux

TAG=beohoang98/canvas-lms-docker:latest

docker build -t $TAG --cache-from $TAG .
