#!/bin/bash
ufw reset
# 启用 UFW 防火墙
sudo ufw enable
ufw allow ssh
# 设置默认规则为拒绝所有入站和出站连接
sudo ufw default deny incoming
sudo ufw default deny outgoing
ufw allow out on tun0 from any to any
ufw allow in on tun0 from any to any
# 允许 OpenVPN 的 UDP 1194 端口通过
sudo ufw allow 1194/udp
# 允许 DNS-over-TLS 的 TCP 853 端口通过
sudo ufw allow 853
#设置DNS over TLS，确保没有DNS污染，使用CloudFlare的DNS
sudo echo -e "[Resolve]\nDNS=1.1.1.1\nDNSOverTLS=yes">/etc/systemd/resolved.conf
#使加密DNS立刻生效，下面三行命令有可能报错，但是大概率其中一条能够解决问题
systemctl restart systemd-resolved.service
systemctl restart systemd-resolved
service systemd-resolved restart

# 阻止所有其它连接通过防火墙
sudo ufw deny in from any to any
sudo ufw deny out from any to any
echo "Kill-switch 已启用。只有 OpenVPN UDP 1194 端口和 DNS-over-TLS TCP 853 端口被允许通过防火墙。"
