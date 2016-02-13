#!/bin/bash
echo "Installing Cuda..."
export DEBIAN_FRONTEND=noninteractive
apt-get upgrade -y
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/cuda-repo-ubuntu1404_7.0-28_amd64.deb
dpkg -i cuda-repo-ubuntu1404_7.0-28_amd64.deb
apt-get install -y linux-image-extra-`uname -r` linux-headers-`uname -r` linux-image-`uname -r`
apt-get install -y cuda
