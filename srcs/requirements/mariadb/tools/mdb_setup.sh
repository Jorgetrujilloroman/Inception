#!/bin/bash

# Start MariaDB in the background
service mariadb start

# Wait for MariaDB to be ready
sleep 5

# Create the database if it doesn't exist
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"

# Create the user and set the password
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

# Grant all privileges on the database to the new user
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';"

# Set the root password
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"

# Flush privileges to apply changes
mysql -e "FLUSH PRIVILEGES;"

# Shutdown MariaDB to restart it in the foreground later
mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown

# Execute the main command (mariadbd)
exec "$@"
