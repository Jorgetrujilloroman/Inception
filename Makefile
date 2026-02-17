# Define the project name
NAME = inception

# Path to the docker-compose file
COMPOSE_FILE = srcs/docker-compose.yml

# Commands
DOCKER_COMPOSE = docker compose -f $(COMPOSE_FILE)

# Default target: builds and starts the infrastructure
all: build up

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

# Full cleanup: stops containers and deletes ALL data (volumes included)
clean: down
	@echo "Cleaning up volumes and data..."
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@sudo rm -rf /home/jotrujil/data/mariadb/*
	@sudo rm -rf /home/jotrujil/data/wordpress/*

# Rebuild everything from scratch
re: clean all

# Show logs for all services
logs:
	$(DOCKER_COMPOSE) logs -f

# Check the status of the containers
status:
	@docker ps -a

.PHONY: all build up down stop start clean re logs status
