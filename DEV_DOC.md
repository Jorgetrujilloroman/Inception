# Developer Documentation

## 1. Development Environment
* **Hypervisor**: VirtualBox.
* **OS**: Debian 12 (Bookworm).
* **Resources**: 2 GB RAM, 2 CPUs, 20 GB HDD.
* **Interface**: Headless (No GUI).

## 2. DNS Configuration (Local Access)
To access the site via the domain `username.42.fr`, you must manually map the IP address in your host's configuration file.

* Edit `/etc/hosts` and add:
  `127.0.0.1  username.42.fr`

## 3. Development and Graphical Testing
Since the environment lacks a graphical interface, **X11 Forwarding** is used to test the WordPress site locally. This has been tested on both Windows and Ubuntu hosts.

### X11 Forwarding Setup
1.  **VM Side (Debian)**: 
    * Install tools: `sudo apt install xauth x11-apps firefox-esr`.
    * Configure SSH: Uncomment or add the following lines in `/etc/ssh/sshd_config`:
      ```text
      X11Forwarding yes
      X11DisplayOffset 10
      X11UseLocalhost yes
      ```
    * Restart SSH: `sudo systemctl restart ssh`.

2.  **Host Side Configuration**:
    * **Windows Host**: 
      * Install an X-Server (e.g., **VcXsrv**).
      * Set display environment variable: `set DISPLAY=127.0.0.1:0.0`.
    * **Ubuntu Host**: 
      * No additional X-Server installation is required as it is native. Ensure `xhost +` is run if permission issues occur.

3.  **Connection & Verification**:
    * Connect via SSH with the X11 flag: `ssh -X username@<vm_ip>`.
    * Verify: `echo $DISPLAY` (should return something like `localhost:10.0`).
    * Test: Run `xeyes` to see the graphical eyes on your host.
    * **Browser**: Launch `firefox &` to visualize the containerized site.

## 4. Build Process
The **Makefile** orchestrates the build:
* `setup`: Checks for `srcs/.env` and runs `env_generator.sh` if needed.
* `build`: Executes `docker compose build` for custom Dockerfiles.
* `up`: Launches containers in detached mode.



## 5. Storage and Persistence
Data is mapped to the host system for persistence:
* **Paths**: `/home/username/data/mariadb` and `/home/username/data/wordpress`.
* **Persistence Test**: `make clean` deletes these paths and the `.env` file to ensure a fresh state. Normal restarts via `make down` preserve data within the host directories.

## 6. Network and Security
* **Network**: A bridge network `inception_network` ensures container isolation.
* **Security**: No passwords are hardcoded in Dockerfiles. All sensitive data is injected via environment variables at runtime.
* **Stability**: No `tail -f` or infinite loops are used in entrypoints.
