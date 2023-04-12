::route kill-switch
route delete 0.0.0.0 MASK 0.0.0.0 192.168.123.1
::route add 0.0.0.0 MASK 0.0.0.0 192.168.123.1

ipconfig/flushdns
netsh advfirewall reset
netsh advfirewall set allprofiles state on
netsh advfirewall set allprofiles firewallpolicy blockinbound,blockoutbound
#if your openvpn ip is 1.2.3.4,this is a simple example.
set ALLOWED_IPS=192.168.1.1,1.2.3.4

netsh advfirewall reset
netsh advfirewall firewall add rule name="Allow local IP range - Inbound" dir=in action=allow protocol=any localip=any remoteip=192.168.123.1-192.168.123.255
netsh advfirewall firewall add rule name="Allow local IP range - Outbound" dir=out action=allow protocol=any localip=any remoteip=192.168.123.1-192.168.123.255
REM 上面是允许局域网的ip访问
netsh advfirewall firewall add rule name="屏蔽危险端口" dir=in action=block protocol=TCP localport=135-139,445,1433,3306,3389
netsh advfirewall firewall add rule name="Allow only from specific IP - Inbound" dir=in action=allow protocol=any localip=any remoteip=104.21.75.19
netsh advfirewall firewall add rule name="Allow only to specific IP - Outbound" dir=out action=allow protocol=any localip=any remoteip=104.21.75.19
netsh advfirewall firewall add rule name="Block all other traffic - Outbound" dir=out action=block protocol=any localip=any remoteip=0.0.0.0-104.21.75.18
netsh advfirewall firewall add rule name="Block all other traffic - Outbound" dir=out action=block protocol=any localip=any remoteip=104.21.75.20-255.255.255.255
netsh advfirewall firewall add rule name="Block all other traffic - Inbound" dir=in action=block protocol=any localip=any remoteip=0.0.0.0-104.21.75.18
netsh advfirewall firewall add rule name="Block all other traffic - Inbound" dir=in action=block protocol=any localip=any remoteip=104.21.75.20-255.255.255.255
netsh advfirewall firewall add rule name="Block ICMPv4" protocol=icmpv4:any,any dir=in action=block
netsh advfirewall firewall add rule name="Block ICMPv6" protocol=icmpv6:any,any dir=in action=block
netsh advfirewall firewall add rule name="Block ICMPv42" protocol=icmpv4:any,any dir=out action=block
netsh advfirewall firewall add rule name="Block ICMPv62" protocol=icmpv6:any,any dir=out action=block

::这部分用于处理路由问题
route delete 0.0.0.0 mask 0.0.0.0 192.168.123.1::假设你的路由器网关是192.168.123.1
::route add   0.0.0.0 mask 0.0.0.0 192.168.123.1::这是恢复方法
route change 0.0.0.0 mask 0.0.0.0 10.8.8.1 metric 15::这部分改OpenVPN的路由，将OpenVPN的路由降低。
route change 0.0.0.0 mask 128.0.0.0 10.8.8.1 metric 6::这部分改OpenVPN的路由，将OpenVPN的路由降低。

::这是注释符号，REM也是注释符号,对xray有用，帮助翻墙软件的而非针对OpenVPN
::echo y | reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1
::echo y | reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d http=127.0.0.1:10809;::https=127.0.0.1:10809;ftp=127.0.0.1:10809;socks=127.0.0.1:10808
::使用regexp:windows.+等方法来屏蔽不必要的更新等。
