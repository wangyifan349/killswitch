#!/usr/bin/python3
#encoding:utf-8
#这是一个简单的对域名进行提取和去重的算法。需要找到足够的二级域名和顶级域名，然后对他们进行提取和去重，最终生成一个简单的列表，本代码用于屏蔽广告或者遥感的用途。GitHub上面很多域名表。
import json,re
def extract_domain(domain):# 提取二级和顶级域名
    parts = domain.split('.')
    if len(parts) > 2:
        return parts[-2] + '.' + parts[-1]
    return domain
def remove_duplicates(domains):
    extracted_domains = []  # 存储提取后的域名
    for domain in domains:
        extracted_domain = extract_domain(domain)  # 提取域名的二级和顶级部分
        extracted_domains.append(extracted_domain)  # 将提取后的域名添加到列表中
    unique_domains = list(set(extracted_domains))  # 列表去重
    return unique_domains  # 返回去重后的域名列表
def read_domains_from_file(filename):
    domains = []# 从文件中读取域名
    with open(filename, 'r') as file:
        content = file.read()
        domains = re.findall(r'\b((?:\w+[-\w]*\.)+\w+)\b', content)
    return domains

def write_domains_to_json(domains, filename):
    with open(filename, 'w') as file:# 将域名列表保存到 JSON 文件中
        json.dump(domains, file)
domains = read_domains_from_file('config.json')# 读取域名
unique_domains = remove_duplicates(domains)# 去重并提取
write_domains_to_json(unique_domains, 'unique_domains.json')# 写入 JSON 文件
