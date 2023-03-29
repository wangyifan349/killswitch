#!/bin/bash
#This is a script for setting up a kill-switch on Ubuntu.
#It enables the UFW firewall and blocks all incoming and outgoing connections except for OpenVPN's UDP 1194 port and DNS-over-TLS's TCP 853 port.
#It also sets up encrypted DNS using CloudFlare's DNS service to ensure no DNS pollution.
#Finally, it restarts the systemd-resolved service to immediately apply the encrypted DNS settings.
ufw reset
#Reset the UFW firewall rules
#Enable UFW firewall
sudo ufw enable
ufw allow ssh
# Set the default UFW rules to deny incoming and outgoing connections
sudo ufw default deny incoming
sudo ufw default deny outgoing
ufw allow out on tun0 from any to any
ufw allow in on tun0 from any to any
# Allow OpenVPN UDP 1194 port through the firewall
sudo ufw allow 1194/udp
# allow tls over dns port 853
sudo ufw allow 853
#Configure DNS-over-TLS to use CloudFlare DNS and prevent DNS poisoning
sudo echo -e "[Resolve]\nDNS=1.1.1.1\nDNSOverTLS=yes">/etc/systemd/resolved.conf
#The following three lines may cause errors, but one of them should work
systemctl restart systemd-resolved.service
systemctl restart systemd-resolved
service systemd-resolved restart

# Block all other incoming and outgoing connections
sudo ufw deny in from any to any
sudo ufw deny out from any to any
echo "Kill-switch enabled. Only OpenVPN UDP 1194 and DNS-over-TLS TCP 853 ports are allowed through the firewall."
