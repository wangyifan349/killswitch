import re
import socket
import threading
import concurrent.futures

# 用于确保线程安全文件操作的锁
file_lock = threading.Lock()

# 从桥地址中提取端口的函数
def extract_port(bridge):
    match = re.search(r':(\d+)', bridge)
    if match:
        return int(match.group(1))
    else:
        return None

# 从桥地址中提取IP地址的函数
def extract_ip(bridge):
    match = re.search(r'(\d+\.\d+\.\d+\.\d+)', bridge)
    if match:
        return match.group(1)
    else:
        return None

# 使用套接字连接测试桥的可用性的函数
def test_bridge(bridge_ip, bridge_port):
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(5)
        sock.connect((bridge_ip, bridge_port))
        sock.close()
        return True
    except Exception as e:
        return False

# 存储从文件中读取的所有桥
bridges = []

# 从名为 "bridges.txt" 的文件中读取桥
with open("bridges.txt", "r") as file:
    for line in file:
        match = re.search(r"obfs4.*", line)
        if match:
            bridges.append(match.group())


unique_bridges = list(set(bridges))# 去除重复的桥

# 存储可用和不可用桥的列表
available_bridges = []
unavailable_bridges = []


def test_bridge(bridge_ip, bridge_port):# 在单独的线程中测试桥的函数
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(5)# 创建套接字对象并设置超时时间
        sock.connect((bridge_ip, bridge_port))# 尝试连接桥的IP和端口
        sock.close()# 关闭套接字连
        return True# 连接成功，返回True表示桥可用
    except Exception as e:
        return False# 连接失败或出现异常，返回False表示桥不可用


# 最大线程数，用于测试桥的并发
max_threads = 60

# 使用 ThreadPoolExecutor 进行并发桥测试
with concurrent.futures.ThreadPoolExecutor(max_workers=max_threads) as executor:
    future_to_bridge = {executor.submit(test_bridge_thread, bridge): bridge for bridge in unique_bridges}
    concurrent.futures.wait(future_to_bridge)

for future in concurrent.futures.as_completed(future_to_bridge):
    # 获取当前已完成任务对应的桥
    bridge = future_to_bridge[future]
    try:
        result = future.result()# 获取任务的结果
        if result:# 根据结果将桥添加到可用或不可用列表
            with file_lock:
                available_bridges.append(bridge)  # 添加到可用列表
        else:
            with file_lock:
                unavailable_bridges.append(bridge)  # 添加到不可用列表
    except Exception as e:
        print(f"测试桥 {bridge} 时出现错误: {str(e)}")# 如果出现异常，打印错误消息



special_ports = [':443', ':80', ':8080']# 定义感兴趣的特定端口
# 根据特定端口将可用和不可用的桥分开
special_available_bridges = [bridge for port in special_ports for bridge in available_bridges if port in bridge]
special_unavailable_bridges = [bridge for port in special_ports for bridge in unavailable_bridges if port in bridge]
# 根据其他端口将可用和不可用的桥分开
other_available_bridges = [bridge for bridge in available_bridges if all(port not in bridge for port in special_ports)]
other_unavailable_bridges = [bridge for bridge in unavailable_bridges if all(port not in bridge for port in special_ports)]
# 组合最终排序的桥列表
sorted_bridges = special_available_bridges + ['--------------'] + special_unavailable_bridges + ['--------------'] + other_available_bridges + other_unavailable_bridges

# 将排序后的桥写回文件
with open("bridges.txt", "w") as file:
    file.write("\n".join(sorted_bridges))

# 输出关于桥的统计信息
print("总共找到桥数量:", len(bridges))
print("去重后桥数量:", len(unique_bridges))
#print("特定端口可用桥数量:", len(special_available_bridges))
#print("特定端口不可用桥数量:", len(special_unavailable_bridges))
#print("其他端口可用桥数量:", len(other_available_bridges))
#print("其他端口不可用桥数量:", len(other_unavailable_bridges))

# 输出唯一可用桥和特定端口可用桥的数量
unique_available_bridges = list(set(special_available_bridges + other_available_bridges))
unique_special_available_bridges = [bridge for port in special_ports for bridge in unique_available_bridges if port in bridge]

print("去重后可用桥数量:", len(unique_available_bridges))
print("去重后特定端口可用桥数量:", len(unique_special_available_bridges))
