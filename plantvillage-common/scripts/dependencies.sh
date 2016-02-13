#!/bin/bash
echo "Installing Dependencies....."
apt-get update
apt-get install -y git cmake g++ libboost-all-dev protobuf-compiler libhdf5-serial-dev \
                  liblmdb-dev libleveldb-dev libsnappy-dev libopencv-dev libatlas-base-dev \
                  libgoogle-glog-dev libprotobuf-dev python-pip Cython python-numpy python-scipy \
                  python-skimage python-matplotlib ipython python-h5py python-leveldb \
                  python-networkx python-nose python-pandas python-protobuf python-gflags \
                  python-tornado python-gevent python-Flask python-flaskext.wtf gunicorn \
                  libopencv-core-dev libopencv-highgui-dev libprotoc-dev libsnappy1 libsnappy-dev \
                  libstdc++6-4.8-dbg opencl-headers \
                  dtrx graphviz

# Quick hack to fix stupid OpenCV bug: libdc1394 error: Failed to initialize libdc1394
sudo ln /dev/null /dev/raw1394
