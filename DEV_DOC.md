# Developer Documentation

## 1. Development Environment
* **Hypervisor**: VirtualBox.
* **OS**: Debian 12 (Bookworm).
* **Resources**: 2 GB RAM, 2 CPUs, 20 GB HDD.
* **Interface**: Headless (No GUI).

## 2. Development and Graphical Testing
Since the environment lacks a graphical interface, **X11 Forwarding** is used to test the WordPress site locally from the host (I also tested it on Windows).

### X11 Forwarding Setup
1.  **VM Side (Debian)**: 
    * Install tools: `sudo apt install xauth x11-apps firefox-esr`.
    * Configure SSH: uncomment following lines in `/etc/ssh/sshd_config`:   ```X11Forwarding yes``` ```X11DisplayOffset 10``` ```X11UseLocalhost yes```
2.  **Windows Host Side**:
    * Install an X-Server (e.g., **VcXsrv**). 
    * Set display: `set DISPLAY=127.0.0.1:0.0`.
3.  **Test X11 forwarding**
    ```echo $DISPLAY``` -> Should display something similar to: ```localhost:10.0```
    ```xeyes``` 
5.    **Connection**: 
    * Connect via `ssh -X user@<vm_ip>`.
    * Launch the browser to visualize the site: `firefox`.

## 3. Build Process
The **Makefile** orchestrates the build:
* `setup`: Checks for `srcs/.env` and runs `env_generator.sh` if needed.
* `build`: Executes `docker compose build` for custom Dockerfiles.
* `up`: Launches containers in detached mode.

## 4. Storage and Persistence
Data is mapped to the host system for persistence:
* **Paths**: `/home/$USER/data/mariadb` and `/home/$USER/data/wordpress`.
* **Persistence Test**: `make clean` deletes these paths and the `.env` file to ensure a fresh state. Normal restarts via `make down` preserve data.

## 5. Network and Security
* **Network**: A bridge network `inception_network` ensures container isolation.
* **Security**: No passwords are hardcoded in Dockerfiles. No `tail -f` or infinite loops are used in entrypoints.
