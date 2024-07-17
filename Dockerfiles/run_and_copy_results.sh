#!/bin/bash

# Define the image name and file path within the container
CURRENT_USR=$(whoami)
CURRENT_HOST=$(hostname)
HOST_AND_PATH="${CURRENT_USER}@${CURRENT_HOST}"
IMAGE_NAME="synthetic_regression"
CONTAINER_NAME="synthetic_regression"
FILE_PATH="/root/gpu_benchmark_metrics/results"
DESTINATION_PATH="/home/$CURRENT_USR/Benchmark_Dockerfiles/results_$IMAGE_NAME"

# # Check if container is Up
# if sudo docker ps -f "name=$IMAGE_NAME" --format '{{.Status}}' | grep -q "Up"; then
#     echo "Container $IMAGE_NAME is already up."
# else
#     echo "Starting container $IMAGE_NAME..."
#     sudo docker start "$IMAGE_NAME"

#     # Wait for the container to be fully up
#     sleep 5  # Adjust the sleep time if needed

#     # Check if the container started successfully
#     CONTAINER_STATUS=$(sudo docker ps -q -f name=$CONTAINER_NAME)
#     if [ -z "$CONTAINER_STATUS" ]; then
#         echo "Failed to start the container."
#         exit 1
#     else
#         echo "Container $CONTAINER_NAME started successfully."
#     fi
# fi

# Execute the command inside the container
echo "Executing command inside the container..."
sudo docker run --gpus all $IMAGE_NAME:latest /bin/bash -c "
  source /root/anaconda3/bin/activate bench &&
  cd /root/gpu_benchmark_metrics/ &&

  # Run and Monitor Benchmark
  ./monitor.sh $IMAGE_NAME --plot
"

# Check if the command executed successfully
if [ $? -ne 0 ]; then
    echo "Failed to execute the command inside the container."
    exit 1
else
    echo "Command executed successfully."
fi

# Find the container ID by image name
CONTAINER_ID=$(sudo docker ps -a --filter "ancestor=$IMAGE_NAME:latest" -q | head -n 1)

# Check if container ID is found
if [ -z "$CONTAINER_ID" ]; then
    echo "No container found for image $IMAGE_NAME."
    exit 1
fi

echo "Copying files from container to host..."
sudo docker cp "$CONTAINER_ID:$FILE_PATH/." "$DESTINATION_PATH"

# Check if docker cp command executed successfully
if [ $? -ne 0 ]; then
    echo "Failed to copy files from container to host."
    exit 1
fi

# # Change Ownership and Permissions
sudo chown -R $CURRENT_USR:wheel "$DESTINATION_PATH"
sudo chmod -R u+rw "$DESTINATION_PATH"

sudo docker rm $CONTAINER_ID

echo "Files copied successfully from container to host."
