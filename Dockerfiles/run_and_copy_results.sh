#!/bin/bash

# Define the image name and file path within the container
USR="dnz75396"
IMAGE_NAME="synthetic_regression"
FILE_PATH="/root/gpu_benchmark_metrics/results"
DESTINATION_PATH="/home/$USR/results_$IMAGE_NAME"

# Check if container is running
if sudo docker ps -f "name=$IMAGE_NAME" --format '{{.Status}}' | grep -q "Up"; then
    echo "Container $IMAGE_NAME is already running."
else
    echo "Starting container $IMAGE_NAME..."
    sudo docker start "$IMAGE_NAME"
    if [ $? -eq 0 ]; then
        echo "Container $IMAGE_NAME started successfully."
    else
        echo "Failed to start container $IMAGE_NAME. Please check Docker logs."
        exit 1
    fi
fi

# Run Container
sudo docker run --gpus all "$IMAGE_NAME"

# Find the container ID by image name
CONTAINER_ID=$(sudo docker ps -a --filter "ancestor=$IMAGE_NAME:latest" -q | head -n 1)

# Check if container ID is found
if [ -z "$CONTAINER_ID" ]; then
    echo "No container found for image $IMAGE_NAME."
    exit 1
fi

# Copy the Results from the container to host
echo "Copying files from container to host..."
sudo docker cp "$CONTAINER_ID:$FILE_PATH/." "$DESTINATION_PATH"

# Check if docker cp command executed successfully
if [ $? -ne 0 ]; then
    echo "Failed to copy files from container to host."
    exit 1
fi

# Change Ownership and Permissions
sudo chown -R $USR:wheel "$DESTINATION_PATH"
sudo chmod -R u+rw "$DESTINATION_PATH"

echo "Files copied successfully from container to host."
