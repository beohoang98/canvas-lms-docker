#!/bin/sh
set -eux

for f in $HOME/canvas-lms/config/*.yml; do
  echo "Injecting environment variables into $f"
  envsubst < $f > $f.new
  mv $f.new $f
done

/sbin/my_init
