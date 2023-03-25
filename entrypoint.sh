#!/bin/sh
set -eux

for f in $HOME/canvas-lms/config/*.yml; do
  echo "Injecting environment variables into $f"
  envsubst < $f > $f.new
  mv $f.new $f
done

nohup $HOME/canvas-lms/script/canvas_init start &

# given folder permissions to app user
chown -R app:app $HOME/canvas-lms/tmp
chown -R app:app $HOME/canvas-lms/log

exec "$@"
