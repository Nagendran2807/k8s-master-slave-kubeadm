#!/bin/bash

#### Load br_netfilter module and bridged traffic
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

### Install docker ####
sudo apt-get update && sudo apt-get install docker.io -y
sudo docker version 
sudo systemctl enable docker 
sudo systemctl restart docker

#### Install kubeadm, kubectl & kubelet
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo kubeadm version
### cgroup is not applicable if use docker as CRT engine 
### Kubeadm automatically detect cgroup driver in kubelet If not using docker then have to install cgroup driver 