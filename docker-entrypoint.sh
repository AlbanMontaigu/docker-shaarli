#!/bin/bash -e

# Who and where am I ?
echo >&2 "[INFO] ---------------------------------------------------------------"
echo >&2 "[INFO] GLOBAL INFORMATIONS"
echo >&2 "[INFO] ---------------------------------------------------------------"
echo >&2 "[INFO] whoami : $(whoami)"
echo >&2 "[INFO] pwd : $(pwd)"

# Backup the prev install in case of fail...
echo >&2 "[INFO] ---------------------------------------------------------------"
echo >&2 "[INFO] Backup old shaarli installation in $(pwd)"
echo >&2 "[INFO] ---------------------------------------------------------------"
tar -zcvf /var/backup/shaarli/shaarli-v$(date '+%Y%m%d%H%M%S').tar.gz .

# Since shaarli can be upgraded by overwriting files do the upgrade !
# @TODO use VERSION file to check if necessary
# @see https://github.com/shaarli/Shaarli#upgrading
# 
# File copy strategy taken from wordpress entrypoint
# @see https://github.com/docker-library/wordpress/blob/master/fpm/docker-entrypoint.sh
echo >&2 "[INFO] ---------------------------------------------------------------"
echo >&2 "[INFO] Installing or upgrading shaarli in $(pwd)"
echo >&2 "[INFO] ---------------------------------------------------------------"

# Removing old files
echo >&2 "[INFO] Removing old installation"
find -maxdepth 1 ! -regex '^\./data.*$' ! -regex '^\.$' -exec rm -rvf {} +

# Extracting new files
echo >&2 "[INFO] Extracting new installation"
tar cvf - --one-file-system -C /usr/src/shaarli . | tar xvf -

# Rights correction
echo >&2 "[INFO] Fixing rights"
chown -Rfv nginx:nginx .

# Done
echo >&2 "[INFO] Complete! Shaarli has been successfully installed / upgraded to $(pwd)"

# Exec main command
exec "$@"
