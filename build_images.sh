#!/bin/bash

# Build gpu_base image
echo "Building gpu_base image..."
docker build -t gpu_base -f Dockerfiles/Dockerfile.gpu_base .

# Build sciml_base image using gpu_base as base
echo "Building sciml_base image..."
docker build -t sciml_base -f Dockerfiles/Dockerfile.sciml_base .

## Build sciml benchmark containers

# Build synthetic_regression image using sciml_base as base
echo "Building synthetic_regression image..."
docker build -t synthetic_regression -f Dockerfiles/Dockerfile.synthetic_regression .

# Build stemdl_classification image using sciml_base as base
echo "Building stemdl_classification image..."
docker build -t stemdl_classification -f Dockerfiles/Dockerfile.stemdl_classification .

# Build mnist_tf_keras image using sciml_base as base
echo "Building mnist_tf_keras image..."
docker build -t mnist_tf_keras -f Dockerfiles/Dockerfile.mnist_tf_keras .

echo -e "Build process completed.\n"