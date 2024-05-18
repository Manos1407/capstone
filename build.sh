#!/bin/bash

# Set default image name
IMAGE_NAME="mycapstone_app"

# Allow customization through arguments
while getopts ":n:" opt; do
  case $opt in
    n) IMAGE_NAME="$OPTARG" ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

# Shift arguments after processing options
shift $((OPTIND-1))

# Set the image tag based on the branch name
if [ "$BRANCH_NAME" == "dev" ]; then
    IMAGE_TAG="dev"
elif [ "$BRANCH_NAME" == "master" ]; then
    IMAGE_TAG="latest"
else
    # Default to "latest" tag for other branches
    IMAGE_TAG="latest"
fi

# Set the build context directory
BUILD_CONTEXT="/home/ubuntu/devops-build/build"  # Update this path as needed

# Validate Dockerfile existence
if [[ ! -f Dockerfile ]]; then
  echo "Error: Dockerfile not found in the build context ($BUILD_CONTEXT)." >&2
  exit 1
fi

# Multi-stage build for efficiency
echo "Building Docker image: $IMAGE_NAME:$IMAGE_TAG"
docker build -t "$IMAGE_NAME:$IMAGE_TAG" --build-arg BRANCH_NAME="$BRANCH_NAME" $BUILD_CONTEXT

echo "Successfully built Docker image: $IMAGE_NAME:$IMAGE_TAG"

