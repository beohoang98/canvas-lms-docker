#!/bin/sh
set -eux

nohup $HOME/canvas-lms/script/canvas_init start &

# given folder permissions to app user
chown -R app:app $HOME/canvas-lms/tmp
chown -R app:app $HOME/canvas-lms/log

mkdir -p $HOME/canvas-lms/public/dist/brandable_css
chown -R app:app $HOME/canvas-lms/public/dist/brandable_css

exec "$@"
