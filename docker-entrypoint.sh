#!/bin/bash
set -e

# Backup the prev install in case of fail...
tar -zcf /var/backup/shaarli/shaarli-v$(date '+%y%m%d%H%M%S').tar.gz /var/www

# Since shaarli can be upgraded by overwriting files do the upgrade !
# @TODO use VERSION file to check if necessary
# @see https://github.com/shaarli/Shaarli#upgrading
# 
# File copy strategy taken from wordpress entrypoint
# @see https://github.com/docker-library/wordpress/blob/master/fpm/docker-entrypoint.sh
echo >&2 "Installing or upgrading shaarli in $(pwd) - copying now..."
find -maxdepth 1 ! -regex '^\./data.*$' ! -regex '^\.$' -exec rm -rf {} +
tar cf - --one-file-system -C /usr/src/shaarli . | tar xf -
chown -R nginx:nginx *
echo >&2 "Complete! Shaarli has been successfully installed / upgraded to $(pwd)"

# Exec main command
exec "$@"
