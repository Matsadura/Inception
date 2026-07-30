#!/bin/sh
set -e

envsubst '$NGINX_PORT $WORDPRESS_PORT $DOMAINE_NAME' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

exec "$@"