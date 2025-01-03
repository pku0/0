#!/bin/bash

# 检查是否以 root 用户运行
if [ "$(id -u)" != "0" ]; then
   echo "该脚本必须以 root 用户运行" 1>&2
   exit 1
fi

# 检查 .bashrc 文件是否存在
if [ -f "$HOME/.bashrc" ]; then
    # 将代理设置追加到 .bashrc 文件的尾部
    echo 'export http_proxy=http://child-prc.intel.com:913' >> "$HOME/.bashrc"
    echo 'export https_proxy=http://child-prc.intel.com:913' >> "$HOME/.bashrc"
else
    echo ".bashrc 文件不存在"
fi



# 定义APT文件路径
APT_CONF="/etc/apt/apt.conf"

# 检查 /etc/apt/apt.conf 文件是否存在，如果不存在则创建
if [ ! -f "$APT_CONF" ]; then
    echo "创建 /etc/apt/apt.conf 文件"
    touch "$APT_CONF"
    chmod 644 "$APT_CONF"
    chown root:root "$APT_CONF"
fi

# 将代理设置追加到 /etc/apt/apt.conf 文件的尾部
echo 'Acquire::http::Proxy "http://child-prc.intel.com:913";' >> "$APT_CONF"
echo 'Acquire::https::Proxy "http://child-prc.intel.com:913";' >> "$APT_CONF"




# 安装 openssh-server
apt update
apt install -y openssh-server