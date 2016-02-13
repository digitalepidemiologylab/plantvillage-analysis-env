#!/bin/bash


if [ ! -d /plantvillage/models/alexnet ]; then
  mkdir -p /plantvillage/models/alexnet

  # Downloading directly from the BVLC Servers is **ridiculously** slow !! Hence moving the downloaded
  # model to a custom S3 Bucket !!
  # /home/$1/caffe/scripts/download_model_binary.py /home/$1/caffe/models/bvlc_alexnet
  # cp /home/$1/caffe/models/bvlc_alexnet/bvlc_alexnet.caffemodel /plantvillage/models/alexnet/

  # Moving BVLC Alexnet Caffe Model to Custom S3 bucket
  wget http://plantvillage.s3-website-us-east-1.amazonaws.com/models/bvlc_alexnet.caffemodel -O /plantvillage/models/alexnet/bvlc_alexnet.caffemodel
  chown -R $1:$1 /plantvillage/models/alexnet/
fi
