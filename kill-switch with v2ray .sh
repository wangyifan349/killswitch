sudo ufw reset

sudo ufw disable 

sudo ufw default deny

sudo ufw default deny incoming

sudo ufw default deny outgoing

ehco "我已经设置了默认屏蔽了~“

#ufw allow out on tun0 from any to any
#ufw allow in on tun0 from any to any#这是如果你连接了Openvpn时，这个是虚拟网卡，允许虚拟网卡内部任意传输流量,xray用不到
# Allow OpenVPN UDP 1194 port through the firewall
ufw allow out on wlp4s0  from any to 1.1.1.1 port 853 proto  tcp

#仅仅放行853向外的tcp查询的流量
#allow  dns  over tls
#ufw allow out from 172.67.166.125 to any proto tcp

sudo ufw allow out on wlp4s0 to 104.21.34.210 port 443 proto tcp

#这个使用一个CDN的ip，在xray中，出口一定要走cloudflare用vemss+tls+ws+nginx（伪装站点），然后只放行一个ip的一个443端口的tcp，其他全部拦截掉。确保规则没有遗漏

#通过v2ray的强大的分流规则，分流将完全控制你的互联网流量，让日本的VPS解锁流媒体，美国的VPS去处理洋葱流量和telegram等等。v2ray非常非常复杂，这里不详细讲解了。

#放行你的VPS ip,这是cloudflare的ip地址，这里举个例子，强烈建议使用CDN和VMESS+TLS+NGINX反代
echo "设置加密的DNS查询，避免DNS污染"

ufw deny out 53/udp

ufw deny out 80

ufw deny out 8080

ufw deny out 443

ufw deny out  from any to any

#这个规则非常非常强，拦截所有出站流量!!!!!!!!!!!!

ufw deny from 192.168.123.0/24

ufw deny out on wlp4s0 proto udp

#拦截所有出站的UDP流量!!!!!!!!!!!!

sudo echo -e "[Resolve]\nDNS=1.1.1.1\nDNSOverTLS=yes">/etc/systemd/resolved.conf

sudo ufw enable

ufw logging on

sudo ufw reload

systemctl restart systemd-resolved.service

systemctl restart systemd-resolved
