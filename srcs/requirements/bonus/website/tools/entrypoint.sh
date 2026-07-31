#!/bin/sh
set -e

envsubst '$WEBSITE_PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

exec "$@"