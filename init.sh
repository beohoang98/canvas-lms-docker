#!/bin/sh
set -eux

for f in $HOME/canvas-lms/config/*.yml; do
  envsubst < "$f" > "$f"
done

/sbin/my_init
