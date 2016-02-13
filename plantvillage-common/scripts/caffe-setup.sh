#!/bin/bash
cd $(eval echo ~$1)
echo "Checking if Caffe is present..."
python -c "import caffe" >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Installing Caffe-nv....."
    git clone https://github.com/NVIDIA/caffe
    cd caffe
    git checkout tags/v0.14.0-rc.3 -b  v0.14.0-rc.3

    #Use GPU mode when making Caffee
    sed -e 's/# USE_CUDNN/USE_CUDNN/' Makefile.config.example > Makefile.config
    mkdir build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr/local/caffe ..
    make -j2 all
    make -j2 runtest
    make install
    cd ..
    cat python/requirements.txt | xargs -n1 pip install
    if ! [ -L /usr/lib/python2.7/dist-packages/caffe ]; then
        ln -s /usr/local/caffe/python/caffe /usr/lib/python2.7/dist-packages/caffe
    fi
    chown -R $1 .
else
    echo "Caffe is already present!"
fi
