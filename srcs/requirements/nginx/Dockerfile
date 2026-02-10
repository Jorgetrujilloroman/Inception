# Current penultimate stable version of Debian
FROM debian:bookworm

# Install NGINX and OpenSSL
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

# Create directory for the setup script and copy it
COPY ./tools/nginx_setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/nginx_setup.sh

# Copy the NGINX configuration file
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

# Expose only port 443
EXPOSE 443

# Start NGINX using the setup script to handle SSL generation
# -g "daemon off;" ensures NGINX runs in the foreground (required for Docker)
ENTRYPOINT ["/usr/local/bin/nginx_setup.sh"]
CMD ["nginx", "-g", "daemon off;"]
