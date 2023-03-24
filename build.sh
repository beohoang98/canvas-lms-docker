#!/bin/sh
set -eux

TAG=beohoang98/canvas-lms:latest
docker build -t $TAG .
