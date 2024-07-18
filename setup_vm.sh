#!/bin/bash

# Update package list
sudo apt update

# Install Docker
sudo apt install -y docker.io

# Add the NVIDIA Docker repository (if using NVIDIA GPUs)
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

# Update package list again
sudo apt update

# Install NVIDIA Docker (if using NVIDIA GPUs)
sudo apt-get install -y nvidia-docker2

# Add your user to the Docker group
USR=$(whoami)
sudo groupadd docker
sudo usermod -aG docker $USR

# Restart Docker to apply changes
sudo systemctl restart docker

# Install NVIDIA drivers (if needed)
sudo apt install -y nvidia-driver-535

# Reboot the system to finish setup
sudo reboot
