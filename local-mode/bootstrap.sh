export PLANTVILLAGE_MODE="LOCAL"
cd /plantvillage-common/scripts
./dependencies.sh
./caffe-setup.sh vagrant
./digits-setup.sh vagrant
./nginx-setup.sh
./caffe-setup.sh
./digits-setup.sh

./alexnet-setup.sh vagrant

# Pass control to post provision handler script
./post-provision.sh
