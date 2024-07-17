#!/bin/bash

BENCHMARK="synthetic_regression"

# Define the image name and file path within the container
CURRENT_USR=$(whoami)
CURRENT_HOST=$(hostname)
HOST_AND_PATH="${CURRENT_USER}@${CURRENT_HOST}"
IMAGE_NAME=$BENCHMARK
CONTAINER_NAME=$BENCHMARK
FILE_PATH="/root/gpu_benchmark_metrics/results"
DESTINATION_PATH="/home/$CURRENT_USR/Benchmark_Dockerfiles/results_$BENCHMARK"

# Run the Benchmark in the container
sudo docker run --name $CONTAINER_NAME --gpus all synthetic-regression:latest

# Check if the command executed successfully
if [ $? -ne 0 ]; then
    echo "Failed to execute the command inside the container."
    exit 1
else
    echo "Command executed successfully."
fi

# Find the container ID by image name
CONTAINER_ID=$(sudo docker ps -a --filter "name=$CONTAINER_NAME" --format "{{.ID}}")

# Check if container ID is found
if [ -z "$CONTAINER_ID" ]; then
    echo "No container found for image $IMAGE_NAME."
    sudo docker rm $CONTAINER_NAME
    exit 1
fi

echo "Copying files from container to host..."
sudo docker cp "$CONTAINER_ID:$FILE_PATH/." "$DESTINATION_PATH"

# Check if docker cp command executed successfully
if [ $? -ne 0 ]; then
    echo "Failed to copy files from container to host."
    sudo docker rm $CONTAINER_NAME
    exit 1
fi

# Change Ownership and Permissions
sudo chown -R $CURRENT_USR:wheel "$DESTINATION_PATH"
sudo chmod -R u+rw "$DESTINATION_PATH"

# Remove Container
sudo docker rm $CONTAINER_NAME

echo "Files copied successfully from container to host."
