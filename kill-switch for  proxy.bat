::route kill-switch
::route delete 0.0.0.0 MASK 0.0.0.0 192.168.123.1
::route add 0.0.0.0 MASK 0.0.0.0 192.168.123.1
REM  这部分不需要了，通过路由拦截是windows的下OpenVPN使用的。
ipconfig/flushdns
netsh advfirewall reset
netsh advfirewall set allprofiles state on
netsh advfirewall set allprofiles firewallpolicy blockinbound,blockoutbound
REM if your openvpn ip is 1.2.3.4,this is a simple example.
set ALLOWED_IPS=192.168.1.1,1.2.3.4

netsh advfirewall reset
netsh advfirewall firewall add rule name="Block dangerous inbound ports" dir=in action=block protocol=TCP localport=135-139,445,1433,3306,3389
netsh advfirewall firewall add rule name="Allow only from specific IP - Inbound" dir=in action=allow protocol=any localip=any remoteip=1.2.3.4
netsh advfirewall firewall add rule name="Allow only to specific IP - Outbound" dir=out action=allow protocol=any localip=any remoteip=1.2.3.4
netsh advfirewall firewall add rule name="Block all other traffic - Outbound" dir=out action=block protocol=any localip=any remoteip=!1.2.3.4
netsh advfirewall firewall add rule name=""Allow only from specific IP - Outbound" dir=in action=block protocol=any localip=any remoteip=!1.2.3.4
netsh advfirewall refresh

REM 这是注释符号，REM也是注释符号,开启代理并使用代理
echo y | reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1
echo y | reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d http=127.0.0.1:10809;::https=127.0.0.1:10809;ftp=127.0.0.1:10809;socks=127.0.0.1:10808
REM   echo y | reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0   
REM  上面这个是关闭代理
REM 代理软件通常缺少kill-switch功能，这一点非常烦。，加一个防火墙保护一下。
