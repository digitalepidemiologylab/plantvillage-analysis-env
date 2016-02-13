export PLANTVILLAGE_MODE="AWS-GPU"
cd /plantvillage-common/scripts
./ebs-setup.sh
./dependencies.sh
./cuda-setup.sh
./cudnn-setup.sh
./caffe-setup.sh ubuntu
./digits-setup.sh ubuntu
./nginx-setup.sh
./alexnet-setup.sh ubuntu

# Pass control to post provision handler script
./post-provision.sh
