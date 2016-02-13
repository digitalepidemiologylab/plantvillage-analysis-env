#!/bin/bash
echo "Provisioning /plantvillage using EBS volume"
blkid /dev/xvdb*
if [ $? -ne 0 ]; then
   if [ -b /dev/xvdb1 ]; then
     echo "Ignoring xvdb, partition found on /dev/xvdb1"
   else
     echo "Ok: no partition on /dev/xvdb"
     parted -s /dev/xvdb mklabel msdos
     parted -s /dev/xvdb unit MB mkpart primary 0% 100%
     mkfs.ext4 /dev/xvdb1
   fi
else
  echo "Filesystem metadata found on xvdb, ignoring"
fi

blkid /dev/xvdb1*
if [ $? -eq 0 ]; then
  grep plantvillage /etc/fstab 2>/dev/null || echo $(blkid /dev/xvdb1 -o export | head -n1) /plantvillage ext4 defaults 0 0 >> /etc/fstab
  mkdir -p /plantvillage
  mountpoint /plantvillage || mount /plantvillage
else
  echo "Filesystem metadata not found on xvdb1, ignoring"
fi
