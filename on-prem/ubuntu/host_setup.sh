#!/bin/bash
set -e
eth_name=$1
ip_addr=`ifconfig $eth_name | grep "inet" | head -n 1 | awk '{print $2}'`
sed -e "s/^.*${HOSTNAME}.*/${ip_addr} ${HOSTNAME} ${HOSTNAME}.local/" -i /etc/hosts

# remove ubuntu-bionic entry
sed -e '/^.*ubuntu-bionic.*/d' -i /etc/hosts

# Update /etc/hosts about other hosts
cat >> /etc/hosts <<EOF
192.168.50.11  master-1
192.168.50.12  master-2
192.168.50.21  worker-1
192.168.50.22  worker-2
192.168.50.30  lb
EOF
