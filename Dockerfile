# ================================================================================================================
#
# Shaarli with NGINX and PHP-FPM
#
# @see https://github.com/AlbanMontaigu/docker-nginx-php/blob/master/Dockerfile
# @see https://github.com/AlbanMontaigu/docker-dokuwiki
# ================================================================================================================

# Base is a nginx install with php
FROM amontaigu/nginx-php

# Maintainer
MAINTAINER alban.montaigu@gmail.com

# Shaarli env variables
ENV SHAARLI_VERSION="v0.5.0"

# System update & install the PHP extensions we need
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y libpng12-dev libjpeg-dev && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd

# Get Shaarli and install it
RUN mkdir -p --mode=777 /var/backup/shaarli \
    && mkdir -p --mode=777 /usr/src/shaarli \
    && curl -o shaarli.tgz -SL https://github.com/shaarli/Shaarli/archive/$SHAARLI_VERSION.tar.gz \
    && tar -xzf shaarli.tgz --strip-components=1 -C /usr/src/shaarli \
        --exclude=.gitignore \
        --exclude=.travis.yml \
        --exclude=CONTRIBUTING.md \
        --exclude=COPYING \
        --exclude=Makefile \
        --exclude=README.md \
        --exclude=composer.json \
        --exclude=phpunit.xml \
        --exclude=tests \
        --exclude=doc \
    && rm shaarli.tgz \
    && chown -R nginx:nginx /usr/src/shaarli

# NGINX tuning for SHAARLI
COPY ./nginx/conf/sites-enabled/default.conf /etc/nginx/sites-enabled/default.conf

# Entrypoint to enable live customization
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Volume for shaarli backup
VOLUME /var/backup/shaarli

# grr, ENTRYPOINT resets CMD now
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
