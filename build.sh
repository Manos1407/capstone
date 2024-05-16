#!/bin/bash

# Set default image name and tag
IMAGE_NAME="mycapstone_app"
IMAGE_TAG="latest"

# Allow customization through arguments
while getopts ":n:t:" opt; do
  case $opt in
    n) IMAGE_NAME="$OPTARG" ;;
    t) IMAGE_TAG="$OPTARG" ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

# Shift arguments after processing options
shift $((OPTIND-1))

# Build context (replace with your actual project directory)
BUILD_CONTEXT="/home/ubuntu/devops-build/build"  # Update this path

# Validate Dockerfile existence
if [[ ! -f Dockerfile ]]; then
  echo "Error: Dockerfile not found in the build context ($BUILD_CONTEXT)." >&2
  exit 1
fi

# Multi-stage build for efficiency (replace with your commands)
echo "Building base image..."
docker build -t "${IMAGE_NAME}-base" -f Dockerfile.base $BUILD_CONTEXT

echo "Building final image..."
docker build -t "$IMAGE_NAME:$IMAGE_TAG" --cache-from "${IMAGE_NAME}-base" $BUILD_CONTEXT

# Clean up intermediate image (optional)
docker image rm "${IMAGE_NAME}-base" 2> /dev/null

echo "Successfully built Docker image: $IMAGE_NAME:$IMAGE_TAG"

