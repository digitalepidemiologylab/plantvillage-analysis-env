export PLANTVILLAGE_MODE="AWS-CPU"
cd /plantvillage-common/scripts
./ebs-setup.sh
./dependencies.sh
./caffe-setup.sh ubuntu
./digits-setup.sh ubuntu
./nginx-setup.sh
./alexnet-setup.sh ubuntu

# Pass control to post provision handler script
./post-provision.sh
