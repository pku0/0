#!/bin/bash

# 检查是否以 root 用户运行
if [ "$(id -u)" != "0" ]; then
   echo "该脚本必须以 root 用户运行" 1>&2
   exit 1
fi

# 创建 docker 文件夹并进入
mkdir -p docker
cd docker

# 下载 .deb 文件
wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/containerd.io_1.7.21-1_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/docker-ce_27.2.1-1~ubuntu.24.04~noble_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/docker-ce-cli_27.2.1-1~ubuntu.24.04~noble_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/docker-buildx-plugin_0.17.1-1~ubuntu.24.04~noble_amd64.deb
wget https://download.docker.com/linux/ubuntu/dists/noble/pool/stable/amd64/docker-compose-plugin_2.29.2-1~ubuntu.24.04~noble_amd64.deb

# 安装 .deb 文件
dpkg -i containerd.io_1.7.21-1_amd64.deb
dpkg -i docker-ce_27.2.1-1~ubuntu.24.04~noble_amd64.deb
dpkg -i docker-ce-cli_27.2.1-1~ubuntu.24.04~noble_amd64.deb
dpkg -i docker-buildx-plugin_0.17.1-1~ubuntu.24.04~noble_amd64.deb
dpkg -i docker-compose-plugin_2.29.2-1~ubuntu.24.04~noble_amd64.deb

# 启动 Docker 服务
service docker start








# 创建 docker.service.d 目录
mkdir -p /etc/systemd/system/docker.service.d

# 创建并添加代理配置到 http-proxy.conf 文件
cat > /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF
[Service]
Environment="HTTP_PROXY=http://child-prc.intel.com:913/" "NO_PROXY=localhost,127.0.0.1"
Environment="HTTPS_PROXY=http://child-prc.intel.com:913/" "NO_PROXY=localhost,127.0.0.1"
EOF

# 重新加载 Systemd 守护进程
systemctl daemon-reload

# 重新启动 Docker 服务
systemctl restart docker

echo "Docker 代理设置完成。"








#添加用户
usermod -aG docker $USER #sudo
# sudo reboot








# 验证 Docker 安装
docker run hello-world