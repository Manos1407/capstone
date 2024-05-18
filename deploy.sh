#!/bin/bash

# Set image name and tag (assuming same as build script)
IMAGE_NAME="mycapstone_app"  # Assuming it matches your build script
TAG="latest"  # Default tag

# Check if Docker is running
if ! docker ps >/dev/null 2>&1; then
  echo "Error: Docker is not running!"
  exit 1
fi

# Check if image exists locally
if ! docker image inspect "$IMAGE_NAME:$TAG" >/dev/null 2>&1; then
  echo "Error: Image $IMAGE_NAME:$TAG not found locally!"
  echo "Please build the image first using build.sh"
  exit 1
fi

# Define default ports (consider prompting for customization if needed)
HOST_PORT=80
CONTAINER_PORT=80

# Run the container with port mapping (use single quotes for clarity)
docker run -d -p "$HOST_PORT:$CONTAINER_PORT" "$IMAGE_NAME:$TAG"

echo "Container for image $IMAGE_NAME:$TAG started successfully!"

