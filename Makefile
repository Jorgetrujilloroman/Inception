NAME = inception

# Path to the docker-compose file
COMPOSE_FILE = srcs/docker-compose.yml

# Commands
DOCKER_COMPOSE = docker compose -f $(COMPOSE_FILE)

# Environment generation script
ENV_SCRIPT = ./env_generator.sh

# Default target: ensure the setup script runs, builds and starts the infrastructure
all: setup build up

# Runs the environment generator script if not exists
setup:
	@echo "Checking configuration file..."
	@if [ ! -f srcs/.env ]; then \
		echo "Environment file not found. Starting setup..."; \
		bash $(ENV_SCRIPT); \
	else \
		echo "Environment file already exists."; \
	fi

# Build the images defined in the compose file
build:
	@echo "Building Inception images..."
	$(DOCKER_COMPOSE) build

# Start the containers in detached mode
up:
	@echo "Starting Inception containers..."
	$(DOCKER_COMPOSE) up -d

# Stop and remove containers, networks, and images defined in the compose file
down:
	@echo "Stopping Inception containers..."
	$(DOCKER_COMPOSE) down

# Stop the containers without removing them
stop:
	@echo "Stopping Inception services..."
	$(DOCKER_COMPOSE) stop

# Start previously stopped containers
start:
	@echo "Starting Inception services..."
	$(DOCKER_COMPOSE) start

# Full cleanup: stops containers and deletes ALL data including volumes.
clean: down
	@echo "Cleaning up volumes and data..."
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@sudo rm -rf /home/$(shell whoami)/data/mariadb/*
	@sudo rm -rf /home/$(shell whoami)/data/wordpress/*

# Rebuild everything from scratch
re: clean all

# Show logs for all services
logs:
	$(DOCKER_COMPOSE) logs -f

# Check the status of the containers
status:
	@docker ps -a

.PHONY: all build up down stop start clean re logs status
