#!/bin/bash

echo "这是一个用于使用在Ubuntu下，利用xray翻墙后，实现kill-switch的脚本和方法，参考了很多博客和教程编写，但仍然可能有漏洞和疏忽的地方"
sudo -v
if [ $? -ne 0 ]; then
    echo "无法获取sudo权限，法继续执行。"
    exit 1
fi

sudo ufw reset
sudo ufw disable 
# Set the default UFW rules to deny incoming and outgoing connections
sudo ufw default deny
sudo ufw default deny incoming
sudo ufw default deny outgoing
ufw allow out on tun0 from any to any
ufw allow in on tun0 from any to any#这是如果你连接了Openvpn时，这个是虚拟网卡，允许虚拟网卡内部任意传输流量
# Allow OpenVPN UDP 1194 port through the firewall
sudo ufw allow 1194/udp
# allow tls over dns port 853
#sudo ufw allow 853
ufw allow from 1.1.1.1 to any port 853 proto tcp
#allow  dns  over tls
ufw allow from 172.67.166.125 to any
ufw allow from any  to 172.67.166.125#this is your openvpn ip address
echo "set dns over tls"

sudo echo -e "[Resolve]\nDNS=1.1.1.1\nDNSOverTLS=yes">/etc/systemd/resolved.conf

systemctl restart systemd-resolved.service
systemctl restart systemd-resolved


# Block all other incoming and outgoing connections
#sudo ufw deny in from any to any
#sudo ufw deny out from any to any
echo "Kill-switch enabled. Only OpenVPN UDP 1194 and DNS-over-TLS TCP 853 ports are allowed through the firewall."
