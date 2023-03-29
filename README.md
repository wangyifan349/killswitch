什么是 Kill-switch？
Kill-switch 是一种防范意外断开 VPN 连接时的数据泄漏的安全机制。当 VPN 连接意外中断时，kill-switch 会立即禁用所有网络连接，以避免数据通过本机的原始 IP 地址传输，从而保护您的隐私。

在这个仓库中，提供了两个脚本：一个是用于 Ubuntu 的 OpenVPN 脚本，另一个是 Windows 上的批处理格式脚本，帮助kill-switch。

此外，另外补充了一个windows的v2ray防火墙的脚本。

免责声明：

此存储库中提供的脚本仅用于教育和参考目的。 对于因使用这些脚本而导致的任何后果，作者不承担任何责任。

需要注意的是，VPN 的使用在某些国家或地区可能会受到限制甚至是非法的。 在使用这些脚本之前，用户有责任了解并遵守当地的法律法规。 对于因使用这些脚本而引起的任何法律或安全问题，作者不承担任何责任。

此外，强烈建议用户在将这些脚本部署到生产环境之前，先在自己的环境中对其进行彻底的测试和验证。 作者不保证这些脚本的准确性或有效性，并且不对使用它们可能产生的任何问题负责。


What is a Kill-switch?

A Kill-switch is a security mechanism designed to prevent data leakage in the event of an accidental disconnection of a VPN connection. When a VPN connection is interrupted, the Kill-switch immediately disables all network connections to avoid data transmission through the original IP address of the local machine, thus protecting your privacy.

In this repository, there are two scripts available: one for OpenVPN on Ubuntu and another one for Windows in bat format. Additionally, a firewall script for v2ray on Windows is also provided.

Disclaimer:

The scripts provided in this repository are for educational and reference purposes only. The author does not take any responsibility for any consequences resulting from the use of these scripts.

It is important to note that the use of VPNs may be restricted or even illegal in some countries or regions. It is the responsibility of the user to understand and comply with local laws and regulations before using these scripts. The author will not be held liable for any legal or security issues arising from the use of these scripts.

Furthermore, it is strongly recommended that users thoroughly test and verify these scripts in their own environment before deploying them in a production environment. The author does not guarantee the accuracy or effectiveness of these scripts and cannot be held responsible for any issues that may arise from their use.
