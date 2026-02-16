# Use the penultimate stable version of Debian
FROM debian:bookworm

# Install PHP-FPM and dependencies in a single layer to optimize size
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    mariadb-client \
    curl && \
    rm -rf /var/lib/apt/lists/*

# Download wp-cli directly (more reliable than downloading the full zip)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# PHP-FPM needs this directory to run correctly
RUN mkdir -p /run/php

# Copy the configuration and the setup script
# Note: Use the full path from the build context (srcs/)
COPY ./requirements/wordpress/conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY ./requirements/wordpress/tools/wp_setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wp_setup.sh

# Set the working directory to match NGINX root
WORKDIR /var/www/wordpress

ENTRYPOINT ["/usr/local/bin/wp_setup.sh"]

# Start PHP-FPM in foreground to keep the container alive
CMD ["/usr/sbin/php-fpm8.2", "-F"]
