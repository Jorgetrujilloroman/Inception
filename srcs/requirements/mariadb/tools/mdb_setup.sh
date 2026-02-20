#!/bin/bash

# Ensure the database directory exists and has the correct ownership
# The 'mysql' user must own this folder to write the ddl_recovery.log and data
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "MariaDB: Initializing data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

# Fix permissions on every startup to prevent "Permission Denied" errors 
# on mounted volumes from the host (/home/jotrujil/data/mariadb)
chown -R mysql:mysql /var/lib/mysql /run/mysqld
chmod 777 /run/mysqld

# Start MariaDB in a temporary mode to configure users and databases
# This is necessary to set the root password and create the WP database
mysqld_safe --datadir='/var/lib/mysql' &

# Wait for MariaDB to be ready
until mysqladmin ping >/dev/null 2>&1; do
    echo "MariaDB: Waiting for database..."
    sleep 2
done

# Configure the database using variables from the .env file
# Ensure root cannot login without a password: 
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Shut down the temporary server to start it normally via the Docker CMD
mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown

echo "MariaDB: Setup completed successfully."

# Execute the main command (mariadbd) passed from the Dockerfile
exec "$@"
