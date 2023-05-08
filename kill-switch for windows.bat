@echo off
REM  这部分用于OpenVPN的kill-switch，而非xray的
REM  如果你要用的话，把这个和你的xray目录放在一起就可以了。能够拦截很多流量，v2rayN设计的。。。。差一点防火墙的功能，那系统的防火墙帮它补充下。
REM  就只是能提升一点点点点隐私，一点点而已。
REM  route delete 0.0.0.0 MASK 0.0.0.0 192.168.123.1
REM  route add 0.0.0.0 MASK 0.0.0.0 192.168.123.1
:: 检测管理员权限
setlocal EnableDelayedExpansion
net session >nul 2>&1
if %errorLevel% neq 0 (
  echo "程序需要以管理员身份运行，请右键单击脚本文件，然后选择“以管理员身份运行"
  pause
  exit
)
ipconfig/flushdns
netsh advfirewall reset
netsh advfirewall set allprofiles state on
netsh advfirewall set allprofiles firewallpolicy blockinbound,blockoutbound
REM 极端网络情况下的 kill-switch
REM netsh advfirewall reset
netsh advfirewall firewall add rule name="Allow local IP range - Inbound" dir=in action=allow protocol=any localip=any remoteip=192.168.123.1-192.168.123.255
netsh advfirewall firewall add rule name="Allow local IP range - Outbound" dir=out action=allow protocol=any localip=any remoteip=192.168.123.1-192.168.123.255
REM 上面是允许局域网的ip访问
::这部分是允许局域网网关的访问
setlocal EnableDelayedExpansion

for /f "tokens=2 delims=:" %%a in ('ipconfig ^| find "IPv4"') do (
  set ip_address=%%a
  rem 从 ipconfig 输出中提取 IPv4 地址，并赋值给 ip_address 变量
  set rule_name=Allow_TCP_UDP_!ip_address:~1!
  rem 设置规则名称，以 IP 地址为前缀
  
  rem 添加入站 TCP 规则
  netsh advfirewall firewall add rule name="%rule_name%_Inbound_TCP" dir=in action=allow protocol=TCP localip=!ip_address! enable=yes
  
  rem 添加入站 UDP 规则
  netsh advfirewall firewall add rule name="%rule_name%_Inbound_UDP" dir=in action=allow protocol=UDP localip=!ip_address! enable=yes
  
  rem 添加出站 TCP 规则
  netsh advfirewall firewall add rule name="%rule_name%_Outbound_TCP" dir=out action=allow protocol=TCP localip=!ip_address! enable=yes
  
  rem 添加出站 UDP 规则
  netsh advfirewall firewall add rule name="%rule_name%_Outbound_UDP" dir=out action=allow protocol=UDP localip=!ip_address! enable=yes
  
  echo 针对 IP 地址 !ip_address! 添加了防火墙规则。
)

::这部分是允许局域网网关的访问
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

netsh advfirewall reset

::这是注释符号，REM也是注释符号
::/f可以代替echo y
echo y | reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "http=127.0.0.1:10809;https=127.0.0.1:10809;ftp=127.0.0.1:10809;socks=127.0.0.1:10808" /f

::reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f

setlocal enabledelayedexpansion

REM 获取脚本运行的位置
set "SCRIPT_DIR=%~dp0"

REM 切换到xray所在的目录并执行命令
cd /d "%SCRIPT_DIR%"
.\xray.exe run

::netsh advfirewall reset
