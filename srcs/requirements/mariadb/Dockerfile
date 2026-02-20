# Use the penultimate stable version of Debian
FROM debian:bookworm

# Install MariaDB server and create necessary log directories
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# Create folders and ensure user 'mysql' has permissions:
RUN mkdir -p /var/lib/mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld && \
    chmod 777 /var/lib/mysql /run/mysqld

# Copy configuration file to allow external connections
COPY ./requirements/mariadb/conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy the setup script
COPY ./requirements/mariadb/tools/mdb_setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mdb_setup.sh

# Expose the default MariaDB port
EXPOSE 3306

# Run the setup script as the entrypoint
ENTRYPOINT ["/usr/local/bin/mdb_setup.sh"]

# Start MariaDB daemon in the foreground
CMD ["mariadbd", "--user=mysql", "--bind-address=0.0.0.0"]
