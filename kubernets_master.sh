#!/bin/bash



source /etc/init.d/functions
echo '开始配置yum源'
cat >/etc/yum.repos.d/kubernetes.repo <<EOF
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
wget -P /etc/yum.repos.d/ https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

#安装kubernets组件
yum install -y docker-ce kubeadm kubectl kubelet ipvsadm
systemctl enable docker && systemctl start docker
systemctl enable kubelet && systemctl start kubelet

#配置内核参数
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system

#忽略swap警告
echo 'KUBELET_EXTRA_ARGS="--fail-swap-on=false"' >/etc/sysconfig/kubelet


master(){
read -p 'masterIP: ' master_ip
read -p 'serviceIP段: ' service_ip
read -p 'podIP段: ' pod_ip
kubeadm init  --apiserver-advertise-address=$master_ip --image-repository registry.aliyuncs.com/google_containers --service-cidr=$servie_ip --pod-network-cidr=$pod_ip --service-dns-domain=cluster.local --ignore-preflight-errors=Swap --service-dns-domain=cluster.local >/tmp/kubejoin
tail -n 2 /tmp/kubejoin >/tmp/joinkube
echo '请牢记您的token，在node上执行以加入 ' 
cat /tmp/joinkube
}
master;
