#!/bin/sh
set -e

exec php -S "0.0.0.0:${ADMINER_PORT}" -t "/var/www/html"