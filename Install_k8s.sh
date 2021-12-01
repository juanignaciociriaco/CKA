#!/bin/bash
# 172.30.0.0/16
sudo systemctl disable systemd-resolved.service
sudo systemctl stop systemd-resolved
rm -rf /etc/resolv.conf
echo "nameserver 1.1.1.1
nameserver 4.2.2.2
nameserver 8.8.8.8" > /etc/resolv.conf

echo "
10.233.1.10 k8s-master
10.233.1.11 k8s-worker01
10.233.1.12 k8s-worker02
10.233.1.13 k8s-worker03
10.233.1.14 k8s-worker04
" >> /etc/hosts
echo "Añadir repositorios"
add-apt-repository universe
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> /etc/apt/sources.list.d/kubernetes.list
echo "Instalar kubernetes"
apt-get update && apt-get install -y docker.io kubelet kubeadm kubectl kubernetes-cni
echo "Quitar la swap"
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
echo "Reiniciar el servicio "
systemctl daemon-reload && systemctl restart kubelet
echo "habilitar docker"
systemctl enable docker.service
echo "Solo en el master"
#kubeadm init --pod-network-cidr=10.244.0.0/16
echo "Instalar sistema de networking"
#kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

kubeadm join 10.233.1.10:6443 --token 809js5.qsf7clc7cyhej1yq --discovery-token-ca-cert-hash sha256:8812c87cf3866cb970300ae40e046d9bd72b45952cde459a85d9e557c22ac4c8
