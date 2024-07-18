# Benchmark_Dockerfiles

### Table of Contents
[Set Up VM](https://https://github.com/bryceshirley/Benchmark_Dockerfiles#set-up-vm)
[Build and Run Containers for Benchmarks](https://https://github.com/bryceshirley/Benchmark_Dockerfiles#build-and-run-containers-for-benchmarks)
[Benchmark and GPU Performance Results](https://https://github.com/bryceshirley/Benchmark_Dockerfiles#benchmark-and-gpu-performance-results)

-----------

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

-----------

## Build and Run Containers for Benchmarks

1. **Build Benchmark Images**

To build all the benchmark images run:
```
./build_images.sh
```
This will build the images for all the benchmarks available on this repo.

2. **Run Benchmark Containers**

To run Benchmark Containers use the ``./run_container`` bash script:

```
Usage: ./run_container <benchmark>
Available benchmarks:
    synthetic_regression 
```

-----------

## Benchmark and GPU Performance Results

The results can be found in ``/Benchmark_Dockerfiles/results_<benchmark>``.

The results for the Benchmark includes the Benchmark Specific Results but also
GPU monitoring results; GPU power/energy usage, GPU utilization and real-time
GPU carbon emissions from the benchmark run.

For more information about the GPU monitoring tool used please visit:
<https://github.com/bryceshirley/gpu_benchmark_metrics>