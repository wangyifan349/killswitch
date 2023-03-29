什么是 Kill-switch？
Kill-switch 是一种防范意外断开 VPN 连接时的数据泄漏的安全机制。当 VPN 连接意外中断时，kill-switch 会立即禁用所有网络连接，以避免数据通过本机的原始 IP 地址传输，从而保护您的隐私。

这个文件项目中，有两个一个是OpenVPN在Ubuntu下的完整脚本，另一个是windows  bat脚本。
另外补充了一个windows的v2ray防火墙的脚本。

What is a Kill-switch?

A Kill-switch is a security mechanism designed to prevent data leakage in the event of an accidental disconnection of a VPN connection. When a VPN connection is interrupted, the Kill-switch immediately disables all network connections to avoid data transmission through the original IP address of the local machine, thus protecting your privacy.

In this repository, there are two scripts available: one for OpenVPN on Ubuntu and another one for Windows in bat format. Additionally, a firewall script for v2ray on Windows is also provided.
