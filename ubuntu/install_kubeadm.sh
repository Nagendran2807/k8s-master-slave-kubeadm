#!/bin/bash

set -e
eth_name=$1
ip_addr=`ifconfig $eth_name | grep "inet" | head -n 1 | awk '{print $2}'`

#### Kube Master only ####
sudo kubeadm init --pod-network-cidr=10.250.0.0/16 --apiserver-advertise-address=$ip_addr 


mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

### Pod Network 
kubectl apply -f https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')

#kubeadm token create --print-join-command > /vagrant/join.sh
#chmod +x $OUTPUT_FILE

kubectl get po --all-namespaces

kubectl get nodes