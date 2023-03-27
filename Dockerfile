FROM ubuntu:20.04 as build

WORKDIR /home/app

# Install git
RUN apt-get update && apt-get install -y git-core curl unzip

# Pull canvas-lms source from branch archive
RUN curl -o canvas-lms.zip -L https://github.com/instructure/canvas-lms/archive/refs/heads/prod.zip && \
  unzip canvas-lms.zip && \
  mv canvas-lms-prod canvas-lms && \
  rm canvas-lms.zip
WORKDIR /home/app/canvas-lms

FROM build as build-gems

ENV TZ=UTC
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get install -y ruby2.7 ruby2.7-dev zlib1g-dev libxml2-dev \
  libsqlite3-dev postgresql-client libpq-dev \
  libxmlsec1-dev libidn11-dev make g++ && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Nodejs 16
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
  apt-get install -y nodejs && \
  npm install -g yarn

WORKDIR /home/app/canvas-lms

# Install gems
RUN gem install bundler --version 2.2.33 \
  && bundle config --local without 'test,development' \
  && bundle config --local path 'vendor/bundle' \
  && bundle config --local force_ruby_platform true \
  && bundle install

# Build assets
RUN yarn install --network-timeout 1000000 --frozen-lockfile

# Build canvas
ENV RAILS_ENV=production
ENV COMPILE_ASSETS_STYLEGUIDE=0
ENV COMPILE_ASSETS_DEV=0
ENV COMPILE_ASSETS_API_DOCS=0
ENV CANVAS_BUILD_NO_MIGRATE=1
ENV COMPILE_ASSETS_BRAND_CONFIGS=0

RUN bundle exec rake canvas:compile_assets
RUN rm -rf node_modules
RUN rm -rf vendor/bundle/

FROM phusion/passenger-ruby27:2.5.0 as canvas
LABEL maintainer="An Hoang <hdan@tma.com.vn>"
LABEL description="Canvas LMS"
LABEL repository="github.com/beohoang98/canvas-lms-docker"
LABEL license="N/A"

# Canvas dependencies
RUN echo "Acquire { https::Verify-Peer false }" >> /etc/apt/apt.conf.d/99verify-peer.conf && \
  apt-get update && \
  apt-get install -y \
  zlib1g-dev libxml2-dev \
  libsqlite3-dev postgresql-client-12 libpq-dev \
  libxmlsec1-dev libidn11-dev \
  gettext ruby2.7-dev \
  libssl-dev openssl \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN rm -f /etc/service/nginx/down
RUN gem install bundler --version 2.2.33 && \
  gem install strscan --version 3.0.5

# Set correct environment variables.
ENV HOME /home/app
ENV RAILS_ENV=production
ENV ENCRYPTION_KEY=12345678901234567890123456789012
ENV CANVAS_DOMAIN=localhost
ENV CANVAS_SSL=false
ENV REDIS_URL=redis://localhost:6379
ENV DATABASE_URL=postgresql://postgres:postgres@localhost:5432/canvas
ENV SMTP_HOST=
ENV SMTP_PORT=
ENV SMTP_USER=
ENV SMTP_PASSWORD=
ENV SMTP_OUTGOING_ADDRESS="Canvas LMS <noreply@${CANVAS_DOMAIN}>"
ENV TZ=UTC

WORKDIR /home/app/canvas-lms

COPY --from=build-gems --chown=app:app /home/app/canvas-lms /home/app/canvas-lms
COPY ./nginx.conf /etc/nginx/sites-enabled/default
COPY ./config/ ./config/

RUN bundle install

VOLUME /home/app/canvas-lms/tmp/files
VOLUME /home/app/canvas-lms/log

COPY ./migration.sh .
COPY ./entrypoint.sh /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

EXPOSE 80
EXPOSE 443
