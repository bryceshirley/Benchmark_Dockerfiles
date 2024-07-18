#!/bin/bash


##### INSTALL OFFICAL DOCKER #####
# Update package list
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


##### INSTALL docker-nvidia #####

# Update package list again
sudo apt update

# Install NVIDIA Docker (if using NVIDIA GPUs)
#echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update
export DEBIAN_FRONTEND=noninteractive
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker

# Restart Docker to apply changes
sudo systemctl start docker-desktop
sudo systemctl enable docker-desktop

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
