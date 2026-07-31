#!/bin/bash
set -e

sed -i "s/WORDPRESS_PORT_PLACEHOLDER/${WORDPRESS_PORT}/g" /etc/php/8.2/fpm/pool.d/www.conf

log() {
    echo -e "\033[0;32m[Inception-WP] $(date +'%H:%M:%S')\033[0m $1"
}

log "Starting WordPress entrypoint script..."

if [ -z "$DB_PASSWORD_FILE" ] || [ -z "$WP_ADMIN_PASSWORD_FILE" ]; then
    echo "Error: Password secret files are not defined!"
    exit 1
fi

log "Reading secrets..."
DB_PASS=$(cat $DB_PASSWORD_FILE)
WP_ADMIN_PASS=$(cat $WP_ADMIN_PASSWORD_FILE)
WP_USER_PASS=$(cat $WP_USER_PASSWORD_FILE)

log "Waiting for MariaDB connection on mariadb:$MARIADB_PORT..."
attempt=0
while ! (echo > /dev/tcp/mariadb/$MARIADB_PORT) >/dev/null 2>&1; do
    attempt=$((attempt+1))
    echo "  [Retrying...] MariaDB not reachable yet (Attempt $attempt)"
    sleep 2
done
log "Success: Connected to MariaDB!"

if [ ! -f /var/www/wordpress/wp-config.php ]; then
    log "No wp-config.php found. Installing WordPress..."
    
    log "Current directory owner: $(ls -ld /var/www/wordpress | awk '{print $3:$4}')"
    
    cd /var/www/wordpress

    log "Downloading WordPress Core..."
    wp core download --path=/var/www/wordpress --allow-root

    log "Creating config file..."
    wp config create --path=/var/www/wordpress --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --dbhost=mariadb:$MARIADB_PORT --allow-root

    log "Installing WordPress site..."
    wp core install --path=/var/www/wordpress --url=$DOMAINE_NAME --title="Inception" --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root

    log "Creating secondary user ($WP_USER)..."
    wp user create $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASS --role=author --path=/var/www/wordpress --allow-root
    
    log "Setting up redis cache plugin..."
    wp plugin install redis-cache --activate --path=/var/www/wordpress --allow-root
    wp config set WP_REDIS_HOST redis --path=/var/www/wordpress --allow-root
    wp config set WP_REDIS_PORT $REDIS_PORT --path=/var/www/wordpress --allow-root
    wp redis enable --path=/var/www/wordpress --allow-root

    
    log "WordPress installation finished."
else
    log "wp-config.php already exists. Skipping installation."
fi

mkdir -p /run/php
log "Starting PHP-FPM..."

chown -R www-data:www-data /var/www/wordpress
chmod -R 775 /var/www/wordpress

exec "$@"