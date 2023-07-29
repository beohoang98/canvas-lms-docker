FROM phusion/passenger-ruby31:2.5.1 AS canvas-base

LABEL org.opencontainers.image.source="github.com/beohoang98/canvas-lms-docker"
LABEL org.opencontainers.image.authors="beohoang98 <beohoang98@gmail.com"
LABEL org.opencontainers.image.title="Canvas LMS Base image"
LABEL org.opencontainers.image.description="Canvas LMS Base image (Deps, Nginx, Passenger, Nodejs, Ruby)"
LABEL org.opencontainers.image.licenses="MIT"

# Canvas dependencies
RUN echo "Acquire { https::Verify-Peer false }" >> /etc/apt/apt.conf.d/99verify-peer.conf && \
  apt-get update && \
  apt-get install -y \
    zlib1g-dev libxml2-dev \
    libsqlite3-dev postgresql-client-12 libpq-dev \
    libxmlsec1-dev libidn11-dev gettext \
    openssl

RUN rm -f /etc/service/nginx/down
RUN gem install bundler -v 2.3.26

# Install Nodejs 16
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
  apt-get install -y nodejs && \
  npm install -g yarn \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
