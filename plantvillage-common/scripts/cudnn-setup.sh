#!/bin/bash
echo "Setting up cudnn..."
wget http://developer.download.nvidia.com/compute/redist/cudnn/v4/cudnn-7.0-linux-x64-v4.0-rc.tgz
tar -xf cudnn-7.0-linux-x64-v4.0-rc.tgz
cp cuda/include/cudnn.h /usr/local/cuda/include/cudnn.h
cp -P cuda/lib64/libcudnn* /usr/local/cuda/lib64/
echo '/usr/local/cuda/lib64' > /etc/ld.so.conf.d/cuda_hack.conf
ldconfig /usr/local/cuda/lib64
