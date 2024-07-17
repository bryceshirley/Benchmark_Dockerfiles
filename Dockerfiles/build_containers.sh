#!/bin/bash

# Build gpu_base image
echo "Building gpu_base image..."
sudo docker build -t gpu_base -f Dockerfile.gpu_base .

# Build sciml_base image using gpu_base as base
echo "Building sciml_base image..."
sudo docker build -t sciml_base -f Dockerfile.sciml_base .

## Build sciml benchmark containers

# Build synthetic_regression image using sciml_base as base
echo "Building synthetic_regression image..."
sudo docker build -t synthetic_regression -f Dockerfile.synthetic_regression .

# Build stemdl_classification image using sciml_base as base

# Build slstr_cloud image using sciml_base as base

echo -e "Build process completed.\n"