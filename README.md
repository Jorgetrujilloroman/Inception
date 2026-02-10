# Inception
System Administration related exercise.

## Distribution:
Based on this [Index](https://www.debian.org/releases/index.es.html), I chosed the OS version: [Debian 12.0.0](https://cdimage.debian.org/cdimage/archive/12.0.0/amd64/iso-cd/) -> penultimate stable (Bookworm)

## Installation:
RAM: 2 GB
CPUs: 2
HDD: 20 GB

- Graphical install: 1 GB Swap

## Configuration:

```
su - 
apt update && apt install -y sudo
usermod -aG sudo jotrujil
```

## Docker install


```
# Update repositories and install necessary dependencies
sudo apt update
sudo apt install -y ca-certificates curl gnupg
```
```
# Add the official Docker GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```
```
# Configure the repository
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
```
# Install Docker Engine and Docker Compose
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

#### Docker conf:
```
# Add user to Docker group
sudo usermod -aG docker jotrujil
```
```
#Verify installation
docker --version
docker compose version
```
#### Dirs & folders
```
# Create main project directory
mkdir -p ~/Inception/srcs/requirements
```
```
# Create subdirectories for mandatory services
mkdir -p ~/Inception/srcs/requirements/mariadb/conf
mkdir -p ~/Inception/srcs/requirements/mariadb/tools
mkdir -p ~/Inception/srcs/requirements/nginx/conf
mkdir -p ~/Inception/srcs/requirements/nginx/tools
mkdir -p ~/Inception/srcs/requirements/wordpress/conf
mkdir -p ~/Inception/srcs/requirements/wordpress/tools
```
```
# Create volume folders
sudo mkdir -p /home/jotrujil/data/mariadb
sudo mkdir -p /home/jotrujil/data/wordpress
sudo chown -R jotrujil:jotrujil /home/jotrujil/data
```
