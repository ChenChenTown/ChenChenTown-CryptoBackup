#!/bin/bash

# 定义要压缩的文件夹路径
folders=(
    "/Users/eddiechen/Desktop"
    "/Users/eddiechen/Documents"
    "/Users/eddiechen/Downloads"
)

# 定义U盘的挂载路径
usb_path="/Volumes/ed-back-up"

# 备份过程的日志文件
log_file="/Users/eddiechen/backup.log"

# 获取当前日期和时间
date_time=$(date "+%Y-%m-%d_%H-%M-%S")

# 压缩文件的目标路径
archive_name="${date_time}.tar.xz"
archive_path="${usb_path}/${archive_name}"

# 加密后的文件路径
encrypted_archive_path="${archive_path}.enc"

# 加密密码（可以根据需要更改此密码）
encryption_password="your_password_here"

# 发送通知的函数
send_notification() {
    osascript -e "display notification \"$1\" with title \"Backup Script\""
}

# 开始记录日志
echo "Backup started at $date_time" > "$log_file"

# 计算文件夹的总大小（以字节为单位）
total_size=0
for folder in "${folders[@]}"; do
    size=$(find "$folder" -type f -exec stat -f "%z" {} + | awk '{s+=$1} END {print s}')
    total_size=$((total_size + size))
done

# 压缩文件夹
echo "Compressing folders..." | tee -a "$log_file"
tar -cf - "${folders[@]}" | pv -s "$total_size" | xz -9 --threads=0 > "$archive_path"

if [ $? -eq 0 ]; then
    # 使用 openssl 加密压缩文件
    echo "Encrypting the compressed file..." | tee -a "$log_file"
    openssl enc -aes-256-cbc -salt -pbkdf2 -in "$archive_path" -out "$encrypted_archive_path" -pass pass:"$encryption_password"

    if [ $? -eq 0 ]; then
        echo "Backup completed successfully at $(date "+%Y-%m-%d_%H-%M-%S")" | tee -a "$log_file"
        send_notification "Backup completed successfully. The encrypted compressed file is saved to the USB drive: $encrypted_archive_path"
        # 删除未加密的压缩文件
        rm "$archive_path"
    else
        echo "Encryption failed at $(date "+%Y-%m-%d_%H-%M-%S")" | tee -a "$log_file"
        send_notification "Encryption failed. Please check the log file for details: $log_file"
    fi
else
    echo "Compression failed at $(date "+%Y-%m-%d_%H-%M-%S")" | tee -a "$log_file"
    send_notification "Compression failed. Please check the log file for details: $log_file"
fi
