# ================================================================================================================
#
# Shaarli with NGINX and PHP-FPM
#
# @see https://github.com/AlbanMontaigu/docker-nginx-php/blob/master/Dockerfile
# @see https://github.com/AlbanMontaigu/docker-dokuwiki
# ================================================================================================================

# Base is a nginx install with php
FROM amontaigu/nginx-php-plus:5.6.27

# Maintainer
MAINTAINER alban.montaigu@gmail.com

# Shaarli env variables
ENV SHAARLI_VERSION="v0.8.0"

# Get Shaarli and install it
RUN mkdir -p --mode=777 /var/backup/shaarli \
    && mkdir -p --mode=777 /usr/src/shaarli \
    && curl -o shaarli.tar -SL https://github.com/shaarli/Shaarli/releases/download/$SHAARLI_VERSION/shaarli-$SHAARLI_VERSION-full.tar \
    && tar -xf shaarli.tar -C /usr/src/shaarli \
        --exclude=CONTRIBUTING.md \
        --exclude=COPYING \
        --exclude=doc \
        --exclude=README.md \
    && rm shaarli.tar \
    && chown -Rfv nginx:nginx /usr/src/shaarli

# NGINX tuning for SHAARLI
COPY ./nginx/conf/sites-enabled/default.conf /etc/nginx/sites-enabled/default.conf

# Entrypoint to enable live customization
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Volume for shaarli backup
VOLUME /var/backup/shaarli

# grr, ENTRYPOINT resets CMD now
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
