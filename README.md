# Inception

*This project has been created as part of the 42 curriculum by [jotrujil](https://profile-v3.intra.42.fr/users/jotrujil).*

## Description
This project is a System Administration exercise focused on the virtualization of several Docker images to create a secure, multi-service infrastructure. The goal is to build a stack from scratch using **Docker Compose**, ensuring that each service runs in its own dedicated and isolated container.

### Project Overview & Design Choices
The infrastructure consists of an **NGINX** server, a **WordPress** site with `php-fpm`, and a **MariaDB** database. All services communicate via a private bridge network and use persistent volumes for data storage.

#### Technical Comparisons:
* **Virtual Machines vs Docker**: VMs virtualize hardware and run a full OS, consuming more resources. Docker virtualizes the OS kernel, making containers lightweight and faster.
* **Secrets vs Environment Variables**: While environment variables are used for general configuration, sensitive data like passwords should be handled securely (e.g., through `.env` files ignored by git or Docker secrets) to prevent exposure.
* **Docker Network vs Host Network**: `network: host` is forbidden because it lacks isolation. We use a dedicated **Docker Network** to allow secure, internal communication between containers.
* **Docker Volumes vs Bind Mounts**: We use **Docker Volumes** with **Bind Mount** options to map container data to specific host paths (`/home/login/data/`), ensuring data survives container deletion and is easily accessible on the host.

## Instructions

### Prerequisites
* A Virtual Machine (or host with sudo permissions) running **[Debian 12](https://cdimage.debian.org/cdimage/archive/12.0.0/amd64/iso-cd/)** (or the penultimate stable version, which I choose based on [this index](https://www.debian.org/releases/index.es.html)).
* **Docker** and **Docker Compose** installed.
* `make` utility.

### Compilation and Execution
The project is fully managed through the **Makefile**, which automates the initial setup and container orchestration.

1.  **Clone the repository**:
    ```bash
    git clone <repository_url> inception && cd inception
    ```

2.  **Launch the project**:
    ```bash
    make
    ```
    *This command automatically detects if the `srcs/.env` file exists. If it is missing, it will launch the `env_generator.sh` script to prompt for credentials before building and starting the infrastructure.*

3.  **Basic Management**:
    * **Stop services**: `make down`
    * **Check status**: `make status`
    * **View logs**: `make logs`
    * **Full Cleanup**: `make clean` (Deletes containers, images, and data in `/home/$USER/data/`).
    * **Clean and recreates the site**: `make re`

### Accessing the Site
Once the services are running, you can access the WordPress site. Note that the infrastructure only allows secure connections via port 443.

* **URL**: `https://jotrujil.42.fr`
* **Admin Panel**: `https://jotrujil.42.fr/wp-admin`
  
*More information about how to test the site without a graphical enviroment on DEV_DOC.md*
## Resources
* [Docker Official Documentation](https://docs.docker.com/)
* [WordPress php-fpm Configuration](https://www.php.net/manual/en/install.fpm.php)
* [MariaDB Security Best Practices](https://mariadb.com/kb/en/securing-mariadb/)

### AI Usage
AI was used in this project as a supportive peer for the following tasks:
* **Learning**: Learning about Docker, containers, and Linux.
* **Architecture Review**: Validating the `docker-compose` network and volume logic.
* **Debugging**: Troubleshooting `docker-network` inspection and volume visibility.
* **Documentation**: Structuring the mandatory documentation files (`README.md`, `USER_DOC.md`, `DEV_DOC.md`) according to the project requirements.
