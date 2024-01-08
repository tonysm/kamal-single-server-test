FROM serversideup/php:8.2-fpm-nginx as base

# Nothing

FROM base as builder

# Cache the vendor files first
COPY composer.json composer.lock /var/www/html

# Run Composer without scripts and empty autoloader...
RUN mkdir -p app && \
    mkdir -p database/{factories,seeders} && \
    composer install --no-interaction --prefer-dist --no-scripts

FROM base

ENV SSL_MODE="off"

# Copy the app files...
COPY --chown=webuser:webgroup . /var/www/html

# Copy the vendor folder from builder step...
COPY --from=builder --chown=webuser:webgroup /var/www/html/vendor /var/www/html/vendor

# Re-run install, but now with scripts and optimizing the autoloader (should be faster)...
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

ENTRYPOINT ["/var/www/html/resources/docker/entrypoint.sh"]
