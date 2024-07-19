#!/bin/bash

# Ensure a benchmark is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <benchmark>"
    echo -e "\nAvailable benchmarks:\n  synthetic_regression\n  mnist_tf_keras\n  stemdl_classification (not working)"
    exit 1
fi
BENCHMARK="$1"

# Define the image name and file path within the container
CURRENT_USR=$(whoami)
CURRENT_HOST=$(hostname)
HOST_AND_PATH="${CURRENT_USER}@${CURRENT_HOST}"
IMAGE_NAME=$BENCHMARK
CONTAINER_NAME=$BENCHMARK
FILE_PATH="/root/gpu_benchmark_metrics/results"
DESTINATION_PATH="/home/$CURRENT_USR/Benchmark_Dockerfiles/results_$BENCHMARK"


# Run the Benchmark in the container
docker run --shm-size=2g --name $CONTAINER_NAME --gpus all $IMAGE_NAME:latest

# Check if the container exists
if ! docker ps -a --filter name=$CONTAINER_NAME --format '{{.Names}}' | grep -q $CONTAINER_NAME; then
    echo "Container failed to start."
    exit 1
fi

# Find the container ID by image name
CONTAINER_ID=$(docker ps -a --filter "name=$CONTAINER_NAME" --format "{{.ID}}")

# Check if container ID is found
if [ -z "$CONTAINER_ID" ]; then
    echo "No container found for image $IMAGE_NAME."
    docker rm $CONTAINER_NAME
    exit 1
fi

echo "Copying files from container to host..."
docker cp "$CONTAINER_ID:$FILE_PATH/." "$DESTINATION_PATH"

# Check if docker cp command executed successfully
if [ $? -ne 0 ]; then
    echo "Failed to copy files from container to host."
    docker rm $CONTAINER_NAME
    exit 1
fi

# Remove Container
docker rm $CONTAINER_NAME

echo "Files copied successfully from container to host."
