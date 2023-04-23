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
ENV CANVAS_LMS_ADMIN_EMAIL="admin@${CANVAS_DOMAIN}"
ENV CANVAS_LMS_ADMIN_PASSWORD="123456789"
ENV CANVAS_LMS_ADMIN_NAME="Admin"
ENV CANVAS_LMS_STATS_COLLECTION="opt_out"
ENV TZ="UTC"

WORKDIR /home/app/canvas-lms

COPY canvas-lms-prod.zip .
RUN unzip canvas-lms-prod.zip \
    && rm canvas-lms-prod.zip \
    && mv canvas-lms-prod/* . \
    && rm -rf canvas-lms-prod

COPY nginx.conf /etc/nginx/sites-enabled/default
COPY config ./config/

RUN bundle config --local without "development test" \
    && bundle config --local path "vendor/bundle" \
    && bundle install

RUN yarn install --pure-lockfile \
    && yarn cache clean

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