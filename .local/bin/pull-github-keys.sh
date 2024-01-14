#! /usr/bin/env bash

usernames=("test482")

# 目录预处理
# 检查 $XDG_RUNTIME_DIR/github-user-ssh-keys 目录是否存在
runtime_dir=${XDG_RUNTIME_DIR:-~/.cache}/github-user-ssh-keys
if [ -d "$runtime_dir" ]; then
    # 如果目录存在，清空目录下的所有 .keys 文件
    echo "Clearing directory *.keys file."
    rm --verbose "$runtime_dir"/*.keys
else
    # 如果目录不存在，创建目录
    echo "Directory does not exist. Creating directory."
    mkdir -p "$runtime_dir"
fi

# 遍历每个用户名
for username in "${usernames[@]}"; do
    link="https://github.com/$username.keys"
    echo "Downloading content from $link."
    curl --remote-name --location --output-dir "$runtime_dir" "$link" || exit 1
done

# 遍历 $XDG_RUNTIME_DIR/github-user-ssh-keys 文件夹中的每个文件
for file in "$runtime_dir"/*.keys; do
    # 读取文件中的每一行
    while read -r line; do
        # 检查该行是否符合常见 SSH 公钥的格式
        if [[ "$line" == ssh-rsa* || "$line" == ssh-ed25519* ]]; then
            # 检查 ~/.ssh/authorized_keys 文件中是否存在该公钥
            if grep -Fq "$line" ~/.ssh/authorized_keys; then
                # 如果存在，则输出日志
                echo "Key $line already exists in authorized_keys."
            else
                # 如果不存在，则添加到 ~/.ssh/authorized_keys 文件中
                echo "Adding $line to authorized_keys."
                echo "$line" >>~/.ssh/authorized_keys
            fi
        else
            echo "Ignoring line: $line"
        fi
    done <"$file"
done

