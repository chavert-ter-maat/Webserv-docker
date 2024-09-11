# Variables
DOCKER_IMAGE := webserv_image
DOCKER_CONTAINER := webserv_container
DOCKERFILE := Dockerfile
DOCKER_PORTS := 8080-8093

# Build the Docker image
build:
	@docker build -t $(DOCKER_IMAGE) -f $(DOCKERFILE) .
	@echo "Docker image $(DOCKER_IMAGE) built successfully."

# Run the Docker container interactively and start a shell
run:
	@docker rm -f $(DOCKER_CONTAINER) || true
	@docker run --name $(DOCKER_CONTAINER) -p $(DOCKER_PORTS):$(DOCKER_PORTS) -it $(DOCKER_IMAGE) /bin/bash

# Stop the Docker container
stop:
	@docker stop $(DOCKER_CONTAINER) || true
	@docker rm $(DOCKER_CONTAINER) || true
	@echo "Docker container $(DOCKER_CONTAINER) stopped and removed."

# Remove the Docker image
clean: stop
	@docker rmi $(DOCKER_IMAGE) || true
	@echo "Docker image $(DOCKER_IMAGE) removed."

# Stop the Docker container, remove the Docker image, and remove all Docker images
fclean: clean
	@docker rmi -f $$(docker images -q) || true
	@echo "All Docker images removed."

# Rebuild the Docker image and run the container interactively
re: stop clean build

# Check if the Docker container is running
status:
	@docker ps -f name=$(DOCKER_CONTAINER)

.PHONY: build run stop clean fclean re status
