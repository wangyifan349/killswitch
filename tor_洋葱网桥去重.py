import re

def extract_port(bridge):
    match = re.search(r':(\d+)', bridge)
    if match:
        return int(match.group(1))
    else:
        return None

bridges = [] # 初始化一个列表来存储洋葱网桥
with open("bridges.txt", "r") as file: # 打开文件
    for line in file: # 遍历每一行
        match = re.search(r"obfs4.*", line) # 使用正则表达式找到所有以"obfs4"开头的行
        if match: # 如果匹配成功
            bridges.append(match.group()) # 将匹配到的内容添加到列表中

unique_bridges = list(set(bridges)) # 使用set()函数去重，然后转换为列表

# 按端口号对unique_bridges进行排序
sorted_bridges = sorted(unique_bridges, key=extract_port)

# 将端口号为443或80的桥移到列表前面
bridges_443_80 = []
bridges_others = []
for bridge in sorted_bridges:
    if ':443' in bridge or ':80' in bridge:
        bridges_443_80.append(bridge)
    else:
        bridges_others.append(bridge)

sorted_bridges = bridges_443_80 + bridges_others

with open("bridges.txt", "w") as file: # 打开文件以覆盖写入模式
    file.write("\n".join(sorted_bridges)) # 使用"\n"将列表中的元素连接成字符串，然后写回到文件中

print("总共找到洋葱网桥数量:", len(bridges)) # 输出找到的洋葱网桥总数
print("去重后洋葱网桥数量:", len(unique_bridges)) # 输出去重后的洋葱网桥数量
