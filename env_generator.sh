#!/bin/bash

# Detect current system user automatically
INCEPTION_USER=$(whoami)

# Name for the environment file
ENV_FILE="srcs/.env"

# Directory Creation
echo "Creating data directories in /home/$INCEPTION_USER/data/..."
mkdir -p /home/$INCEPTION_USER/data/wordpress
mkdir -p /home/$INCEPTION_USER/data/mariadb

# Set permissions to ensure Docker can write to these folders
chmod 755 /home/$INCEPTION_USER/data/wordpress
chmod 755 /home/$INCEPTION_USER/data/mariadb

echo "Configuring Inception for user: $INCEPTION_USER"

# Function to read passwords without showing them in cosole:
read_password() {
    local prompt_message=$1
    local password
    while true; do
        read -sp "$prompt_message: " password >&2
        echo >&2
        if [ -z "$password" ]; then
            echo "Error: Password cannot be empty." >&2
        else
            break
        fi
    done
    echo "$password"
}

# Database Variables
read -p "Database Name [wordpress_db]: " SQL_DATABASE
SQL_DATABASE=${SQL_DATABASE:-wordpress_db}

read -p "Database User [$INCEPTION_USER]: " SQL_USER
SQL_USER=${SQL_USER:-$INCEPTION_USER}

SQL_PASSWORD=$(read_password "Database Password")
SQL_ROOT_PASSWORD=$(read_password "Database Root Password")


# WordPress Variables 
read -p "Site Title [Inception]: " WP_TITLE
WP_TITLE=${WP_TITLE:-Inception}

while true; do
    read -p "WP Admin Username (cannot contain 'admin'): " WP_ADMIN_USER
    if [[ "$WP_ADMIN_USER" == *[Aa][Dd][Mm][Ii][Nn]* ]]; then
        echo "Error: Dont include 'admin' in the username."
    elif [ -z "$WP_ADMIN_USER" ]; then
        echo "Error: Admin username is required."
    else
        break
    fi
done

WP_ADMIN_PASSWORD=$(read_password "WP Admin Password")
read -p "WP Admin Email [$INCEPTION_USER@student.42.fr]: " WP_ADMIN_EMAIL
WP_ADMIN_EMAIL=${WP_ADMIN_EMAIL:-$INCEPTION_USER@student.42.fr}

#Secondary User
read -p "WP Secondary User [user]: " WP_USER
WP_USER=${WP_USER:-user}
#Secondary user password:
WP_USER_PASSWORD=$(read_password "WP Secondary Password")
#Secondary user email:
read -p "WP Secondary Email [$WP_USER@student.42.fr]: " WP_USER_EMAIL
WP_USER_EMAIL=${WP_USER_EMAIL:-$WP_USER@student.42.fr}

#Paths and Networking
WP_URL="$INCEPTION_USER.42.fr"

# Write all variables to the .env file
cat <<EOL > $ENV_FILE
# Database
SQL_DATABASE=$SQL_DATABASE
SQL_USER=$SQL_USER
SQL_PASSWORD=$SQL_PASSWORD
SQL_ROOT_PASSWORD=$SQL_ROOT_PASSWORD

# WordPress
WP_URL=$WP_URL
WP_TITLE=$WP_TITLE
WP_ADMIN_USER=$WP_ADMIN_USER
WP_ADMIN_PASSWORD=$WP_ADMIN_PASSWORD
WP_ADMIN_EMAIL=$WP_ADMIN_EMAIL
WP_USER=$WP_USER
WP_USER_PASSWORD=$WP_USER_PASSWORD
WP_USER_EMAIL=$WP_USER_EMAIL

# Volume Paths 
WP_DATA_PATH=/home/$INCEPTION_USER/data/wordpress
DB_DATA_PATH=/home/$INCEPTION_USER/data/mariadb
EOL

echo "Success: $ENV_FILE has been generated for $INCEPTION_USER."
