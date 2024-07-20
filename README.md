# GPU Benchmark Dockerfiles

-----------
### Table of Contents
* [Set Up VM](https://github.com/bryceshirley/Benchmark_Dockerfiles?tab=readme-ov-file#set-up-vm)

* [Build and Run Containers for Benchmarks](https://github.com/bryceshirley/Benchmark_Dockerfiles?tab=readme-ov-file#build-and-run-containers-for-benchmarks)

* [Benchmark and GPU Performance Results](https://github.com/bryceshirley/Benchmark_Dockerfiles?tab=readme-ov-file#benchmark-and-gpu-performance-results)

-----------

## Set Up VM

#### To run the benchmark Dockerfiles you must setup the VM by running:

```bash
./setup_vm.sh
```

This will reboot your VM and once your VM is back up it will be ready to go!

-----------

## Build and Run Containers for Benchmarks

1. **Build Benchmark Images**

To build all the benchmark images run:
```bash
./build_images.sh
```
This will build the images for all the benchmarks available on this repo.

2. **Run Benchmark Containers**

To run Benchmark Containers use the ``./run_container`` bash script:

```bash
Usage: ./run_container <benchmark>
Available benchmarks:
    synthetic_regression
    stemdl_classification(1 or more GPUs)
    mnist_tf_keras 
```

``stemdl_classification`` use a forked branch (Fixed-Bryce) versions of sciml-bench to fix version and dependency issues and can be found [here](https://github.com/bryceshirley/sciml-bench/tree/Fixes-Bryce). It works for more than one GPU but at the moment you must change the option in Dockerfile.stemdl_classification from "-b gpus 1" to "-b gpus 2" or more before building the image. For 2 or more GPUs, the GPU performance monitoring support multiple GPUs yet, hence the [gpu_benchmark_metrics](https://github.com/bryceshirley/gpu_benchmark_metrics) github needs updating to support multi-gpu.

-----------

## Benchmark and GPU Performance Results

The results can be found in ``/Benchmark_Dockerfiles/results_<benchmark>``.

The results for the Benchmark includes the Benchmark Specific Results but also
GPU monitoring results; GPU power/energy usage, GPU utilization and real-time
GPU carbon emissions from the benchmark run.

For more information about the GPU monitoring tool used please visit:
[https://github.com/bryceshirley/gpu_benchmark_metrics](https://github.com/bryceshirley/gpu_benchmark_metrics#gpu-energy-and-carbon-performance-benchmarking)
