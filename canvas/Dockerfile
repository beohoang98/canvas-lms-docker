FROM ghcr.io/beohoang98/canvas-lms-base:latest as canvas

LABEL org.opencontainers.image.source="github.com/beohoang98/canvas-lms-docker"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.authors="An Hoang <hdan@tma.com.vn>"
LABEL org.opencontainers.image.title="Canvas LMS"
LABEL org.opencontainers.image.description="Canvas LMS Docker image"

# Set correct environment variables.
ENV HOME /home/app
ENV RAILS_ENV="production"
ENV ENCRYPTION_KEY="12345678901234567890123456789012"
ENV CANVAS_DOMAIN="localhost"
ENV CANVAS_SSL="false"
ENV REDIS_URL="redis://localhost:6379"
ENV DATABASE_URL="postgresql://postgres:postgres@localhost:5432/canvas"
ENV SMTP_HOST=""
ENV SMTP_PORT=""
ENV SMTP_USER=""
ENV SMTP_PASSWORD=""
ENV SMTP_AUTHENTICATION=login
ENV SMTP_OUTGOING_ADDRESS="Canvas LMS <noreply@${CANVAS_DOMAIN}>"
ENV CANVAS_LMS_ADMIN_EMAIL="admin@example.com"
ENV CANVAS_LMS_ADMIN_PASSWORD="123456789"
ENV CANVAS_LMS_ADMIN_NAME="Admin"
ENV CANVAS_LMS_STATS_COLLECTION="opt_out"
ENV TZ="UTC"

WORKDIR /home/app/canvas-lms

RUN git clone https://github.com/instructure/canvas-lms.git . --depth 1 --branch prod \
    && git submodule update --init --recursive

COPY nginx.conf /etc/nginx/sites-enabled/default
COPY config ./config/

RUN bundle config --local without "development test" \
    && bundle config --local path "vendor/bundle" \
    && bundle install

RUN DISABLE_POSTINSTALL=1 yarn install --pure-lockfile \
    && yarn build:packages \
    && yarn cache clean

ENV COMPILE_ASSETS_API_DOCS=0
ENV COMPILE_ASSETS_NPM_INSTALL=0
ENV COMPILE_ASSETS_STYLEGUIDE=0
ENV COMPILE_ASSETS_BRAND_CONFIGS=0
ENV NODE_OPTIONS="--max-old-space-size=4096"

RUN bundle exec rake canvas:compile_assets

VOLUME /home/app/canvas-lms/tmp/files
VOLUME /home/app/canvas-lms/log

COPY migration.sh .
COPY entrypoint.sh /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

EXPOSE 80
EXPOSE 443
