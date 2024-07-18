# Benchmark_Dockerfiles

## Set Up VM

To run the benchmark Dockerfiles you must setup the VM first:

1. **Install Docker**

```
sudo apt update
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
```

2. **Install Nvidia-Docker (CHECK THIS IS CORRECT)**

```
# Add the NVIDIA Docker repository
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

# Update and install NVIDIA Docker
sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
```

3. **Add USR to docker-user-group**

```
USR=$(whoami)
sudo groupadd docker
sudo usermod -aG docker $USER
```

4. **Install Nvidia Drivers**

```
sudo apt install nvidia-driver-535 -y
```

5. **Reboot VM to Finish Setup**

```
sudo reboot
```