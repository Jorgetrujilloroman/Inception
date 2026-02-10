#!/bin/bash

# Check if the certificate already exists to avoid overwriting
if [ ! -f /etc/nginx/ssl/inception.crt ]; then
    echo "NGINX: setting up SSl...";
    mkdir -p /etc/nginx/ssl;
    
    # Generate self-signed certificate
    # req: request for certificate
    # -x509: output a self-signed certificate
    # -nodes: no DES (do not encrypt the private key)
    # -out: where to save the certificate
    # -keyout: where to save the private key
    # -subj: certificate information (C=Country, ST=State, L=Locality, O=Organization, CN=CommonName)
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=ES/ST=Malaga/L=Malaga/O=42/OU=42/CN=jotrujil.42.fr";
fi

# Execute the main NGINX command passed as arguments
exec "$@"
