# User Documentation

## 1. Provided Services
* **NGINX**: Secure HTTPS entry point using TLS v1.2/v1.3 on Port 443.
* **WordPress**: Website management powered by php-fpm.
* **MariaDB**: Relational database storage.

## 2. Managing the Project
Use the **Makefile** in the root directory:
* **Start**: `make` (Handles setup, build, and launch).
* **Stop**: `make stop` (Pauses services) or `make down` (Removes containers).
* **Status**: `make status` (Shows running containers).
* **Logs**: `make logs` (Live view of service output).
* **Recreate**: `make re` Perform a full clean, setup and build the whole infrastructure.

## 3. Access and Credentials
* **Access**: Use `https://username.42.fr`.
* **Credentials**: Managed via `srcs/.env`. If the file is missing, `make` will prompt you to create it using the `env_generator.sh` script.
* **Admin User**: The administrator username does not contain 'admin' or 'administrator'.

## 4. Verification
* Ensure all containers show "Up" in `make status`.
* Verify that the database is not accessible as root without a password.
