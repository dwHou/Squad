#!/usr/bin/env python3
"""
Sample file with Chinese comments for testing scan_non_ascii.py
用于测试 scan_non_ascii.py 的示例文件
"""


def calculate_sum(a, b):
    """计算两个数的和"""
    return a + b  # 返回结果


def get_user_data(user_id):
    """获取用户数据"""
    # 从数据库查询
    data = database.query(user_id)

    # 验证数据有效性
    if not data:
        raise ValueError("用户不存在")

    return data


def format_message(msg):
    """格式化消息"""
    # 添加时间戳
    timestamp = get_timestamp()

    # 组合消息
    formatted = f"[{timestamp}] {msg}"

    return formatted


# 主函数
if __name__ == "__main__":
    # 测试代码
    result = calculate_sum(10, 20)
    print(f"结果: {result}")

    # 获取用户数据
    user = get_user_data(123)
    print(f"用户: {user}")
