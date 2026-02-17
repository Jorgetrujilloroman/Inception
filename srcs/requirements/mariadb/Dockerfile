# Use the penultimate stable version of Debian
FROM debian:bookworm

# Install MariaDB server and create necessary log directories
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/* && \
    # Create log directory and set correct permissions for the mysql user
    mkdir -p /var/log/mysql && \
    chown -R mysql:mysql /var/log/mysql && \
    chmod 777 /var/log/mysql

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
