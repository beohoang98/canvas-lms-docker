#!/bin/bash

set -e

mv db/migrate/20210823222355_change_immersive_reader_allowed_on_to_on.rb . || true
mv db/migrate/20210812210129_add_singleton_column.rb db/migrate/20111111214311_add_singleton_column.rb || true
bundle exec rake db:initial_setup
mv 20210823222355_change_immersive_reader_allowed_on_to_on.rb db/migrate/. || true
bundle exec rake db:migrate

bundle exec rake brand_configs:generate_and_upload_all
