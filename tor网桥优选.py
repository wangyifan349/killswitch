import re 
import socket

# 从 bridge 字符串中提取端口号
def extract_port(bridge):
    match = re.search(r':(\d+)', bridge)
    if match:
        return int(match.group(1))
    else:
        return None

# 从 bridge 字符串中提取 IP 地址
def extract_ip(bridge):
    match = re.search(r'(\d+\.\d+\.\d+\.\d+)', bridge)
    if match:
        return match.group(1)
    else:
        return None

# 定义函数测试洋葱网桥是否可用
def test_bridge(bridge_ip, bridge_port):
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(4)#大概需要3秒吧，可惜是单线程的，如果可以变成多线程就好了。。。。所以耐心等。。。
        sock.connect((bridge_ip, bridge_port))
        sock.close()
        return True
    except Exception as e:
        return False

bridges = [] # 初始化一个空列表来存储洋葱网桥

# 打开 bridges.txt 文件进行读取，并循环遍历每一行
with open("bridges.txt", "r") as file:
    for line in file:
        # 使用正则表达式找到所有以 "obfs4" 开头的行
        match = re.search(r"obfs4.*", line)
        if match: # 如果匹配成功
            bridges.append(match.group()) # 将匹配到的内容添加到洋葱网桥列表中

unique_bridges = list(set(bridges))#去重

# 检测洋葱网桥可用性，并将不可用网桥移至一个新的列表末尾
available_bridges = []
unavailable_bridges = []

for bridge in unique_bridges:
    bridge_ip = extract_ip(bridge)
    bridge_port = extract_port(bridge)
    if test_bridge(bridge_ip, bridge_port):
        available_bridges.append(bridge)
    else:
        unavailable_bridges.append(bridge)

# 按端口号排序
sorted_available_bridges = sorted(available_bridges, key=extract_port)

# 将端口号为 443 或 80 的洋葱网桥移到列表前面
sorted_available_bridges = [bridge for bridge in sorted_available_bridges if ':443' in bridge or ':80' in bridge] + \
                           [bridge for bridge in sorted_available_bridges if ':443' not in bridge and ':80' not in bridge]

# 将可用和不可用的洋葱网桥按照分界线组合成一个新的列表
sorted_bridges = sorted_available_bridges + ['--------------'] + unavailable_bridges


with open("bridges.txt", "w") as file:
    file.write("\n".join(sorted_bridges)) # 覆盖写入原来的
print("总共找到洋葱网桥数量:", len(bridges))
print("去重后洋葱网桥数量:", len(unique_bridges))
print("可用洋葱网桥数量:", len(available_bridges))
