# 备份和加密项目使用指南

## 项目概述

此项目旨在通过压缩和加密用户指定的文件夹来创建备份，并将其保存到外部 USB 驱动器。该项目包括一个定时任务，每天在指定时间提醒用户进行备份。

## 安装工具

在开始之前，请确保已安装以下工具：

1. **Homebrew**: macOS 上的包管理器（如果尚未安装）
2. **pv**: 用于显示管道传输进度
3. **zstd**: Zstandard 压缩工具
4. **rsync**: 远程同步工具（通常已预安装在 macOS 上）

### 安装 Homebrew

如果尚未安装 Homebrew，请使用以下命令进行安装：

    ```sh
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

### 安装 pv

使用 Homebrew 安装 `pv`:

    ```sh
    brew install pv
    ```

### 安装 zstd

使用 Homebrew 安装 `zstd`:

    ```sh
    brew install zstd
    ```

## 文件列表

- `backup.sh`: 用于压缩和加密文件夹的备份脚本。
- `backup_notification.scpt`: 用于显示提醒通知并启动备份脚本的 AppleScript。
- `com.user.backupreminder.plist`: 用于配置定时任务的 plist 文件。

## 使用步骤

### 配置备份脚本

1. 打开 `backup.sh` 文件，并确认或修改以下内容：
    - 要备份的文件夹路径。
    - 外部 USB 驱动器的挂载路径。
    - 加密密码（`encryption_password="your_password_here"`）。

2. 确保脚本具有执行权限：

    ```sh
    chmod +x backup.sh
    ```

### 配置通知脚本

1. 打开 `backup_notification.scpt` 文件，并确认或修改以下内容：
    - 备份脚本的路径（`/path/to/your/backup.sh`）。

### 配置定时任务

1. 打开 `com.user.backupreminder.plist` 文件，并确认或修改以下内容：
    - 通知脚本的路径（`/path/to/your/backup_notification.scpt`）。
    - 每天提醒的时间（小时和分钟）。

2. 将 `com.user.backupreminder.plist` 文件放置在 `~/Library/LaunchAgents/` 目录下。

### 加载定时任务

使用以下命令加载定时任务：

    ```sh
    launchctl unload ~/Library/LaunchAgents/com.user.backupreminder.plist
    launchctl load ~/Library/LaunchAgents/com.user.backupreminder.plist
    ```

## 解密和解压缩文件

### 步骤 1：打开终端

您可以在 `Applications > Utilities` 找到终端，或者使用 Spotlight 搜索。

### 步骤 2：导航到文件目录

使用 `cd` 命令导航到包含加密文件的目录：

    ```sh
    cd /Volumes/ed-back-up
    ```

### 步骤 3：解密文件

使用 `openssl` 命令解密文件。将 `your_password_here` 替换为用于加密的实际密码：

    ```sh
    openssl enc -d -aes-256-cbc -pbkdf2 -in 2024-12-18_12-59-04.tar.xz.enc -out 2024-12-18_12-59-04.tar.xz -pass pass:your_password_here
    ```

### 步骤 4：解压缩文件

使用 `tar` 命令解压缩文件：

    ```sh
    tar -xvf 2024-12-18_12-59-04.tar.xz
    ```

## 注意事项

- 确保更改 `backup.sh` 脚本中的加密密码 `encryption_password="your_password_here"`。
- 确保所有脚本具有执行权限：

    ```sh
    chmod +x backup.sh
    chmod +x backup_notification.scpt
    ```

- 将脚本路径替换为实际路径，例如 `/path/to/your/backup.sh`。

通过这些步骤，你将能够每天自动弹出提醒通知，并通过点击按钮启动备份和加密过程。解密和解压缩步骤可以帮助你恢复备份文件。如果你有任何进一步的问题或需要更多帮助，请随时告诉我！ 😊
