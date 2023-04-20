@echo off
REM  这部分用于OpenVPN的kill-switch
REM  route delete 0.0.0.0 MASK 0.0.0.0 192.168.123.1
REM  route add 0.0.0.0 MASK 0.0.0.0 192.168.123.1
REM这个版本添加了放行默认ip4网关，禁止ping

REM 获取正在使用的网络连接名称
for /f "tokens=3 delims=: " %%i in ('netsh interface show interface ^| findstr "Connected"') do (
    set "interfaceName=%%i"
)

REM 获取默认网关
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr "Default Gateway"') do (
    set "gateway=%%i"
)

REM 添加默认路由
route add 0.0.0.0 mask 0.0.0.0 %gateway% metric 10 if %interfaceName%

REM 显示结果
echo 默认路由已添加。
echo 默认网关: %gateway%

ipconfig/flushdns
netsh advfirewall reset
netsh advfirewall set allprofiles state on
netsh advfirewall set allprofiles firewallpolicy blockinbound,blockoutbound

REM 极端网络情况下的 kill-switch
REM netsh advfirewall reset
netsh advfirewall firewall add rule name="Allow local IP range - Inbound" dir=in action=allow protocol=any localip=any remoteip=192.168.123.1-192.168.123.255
netsh advfirewall firewall add rule name="Allow local IP range - Outbound" dir=out action=allow protocol=any localip=any remoteip=192.168.123.1-192.168.123.255
REM 上面是允许局域网的ip访问
netsh advfirewall firewall add rule name="dangeous  in  tcp" dir=in action=block protocol=tcp localport=135-139,445,1433,3306,3389,53
netsh advfirewall firewall add rule name="dangeous  in  udp" dir=in action=block protocol=udp localport=135-139,445,1433,3306,3389,53
netsh advfirewall firewall add rule name="dangerous  out  tcp" dir=out action=block protocol=tcp localport=135-139,445,1433,3306,3389,53
netsh advfirewall firewall add rule name="dangers udp out" dir=out action=block protocol=udp localport=135-139,445,1433,3306,3389,53
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
echo 已添加防火墙规则以允许通过默认网关的流量。
echo 默认网关: %gateway%
echo 正在禁止 ICMP ping 请求，请稍等...
netsh firewall set icmpsetting 8 disable >nul
echo 成功禁止 ICMP ping 请求！
netsh advfirewall refresh

::这是注释符号，REM也是注释符号
::/f可以代替echo y
echo y | reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "http=127.0.0.1:10809;https=127.0.0.1:10809;ftp=127.0.0.1:10809;socks=127.0.0.1:10808" /f

::reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f

pause
