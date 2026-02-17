#!/bin/bash

# Wait for MariaDB to be fully initialized before attempting connection
while ! mariadb-admin ping -h"mariadb" --silent; do
    echo "WordPress: Waiting for MariaDB connection..."
    sleep 2
done

# Navigate to the WordPress directory
cd /var/www/wordpress

# Check if WordPress is already installed
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "WordPress: Downloading core files..."
    wp core download --allow-root

    echo "WordPress: Creating configuration file..."
    # Uses variables from the .env file injected by Docker Compose
    wp config create --allow-root \
        --dbname=$SQL_DATABASE \
        --dbuser=$SQL_USER \
        --dbpass=$SQL_PASSWORD \
        --dbhost=mariadb:3306

    echo "WordPress: Running installation..."
    # Sets up the site and the primary administrator
    wp core install --allow-root \
        --url=$WP_URL \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL

    echo "WordPress: Creating secondary user..."
    # Creates the non-admin user required by the project subject
    wp user create --allow-root \
        $WP_USER $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --role=author
fi

echo "WordPress: Setup finished. Starting PHP-FPM..."

# Execute the command passed as CMD in the Dockerfile (starts php-fpm8.2 -F)
exec "$@"
