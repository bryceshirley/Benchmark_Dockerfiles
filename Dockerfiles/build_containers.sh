#!/bin/bash

sudo docker build -t gpu_base -f Dockerfile.gpu_base .
sudo docker build -t sciml_base -f Dockerfile.sciml_base .
sudo docker build -t synthetic_regression -f Dockerfile.synthetic_regression .