# ChenChenTown-CryptoBackup

## 项目概述

此项目旨在通过压缩和加密用户指定的文件夹来创建备份，并将其保存到外部 USB 驱动器。该项目包括一个定时任务，每天在指定时间提醒用户进行备份。

## 文件列表

- `backup.sh`: 用于压缩和加密文件夹的备份脚本。
- `backup_notification.scpt`: 用于显示提醒通知并启动备份脚本的 AppleScript。
- `com.user.backupreminder.plist`: 用于配置定时任务的 plist 文件。

## 设置步骤

### 步骤 1：配置备份脚本

1. 打开 `backup.sh` 文件，并确认或修改以下内容：
    - 要备份的文件夹路径。
    - 外部 USB 驱动器的挂载路径。
    - 加密密码（`encryption_password="your_password_here"`）。

2. 确保脚本具有执行权限：

    ```sh
    chmod +x backup.sh
    ```

### 步骤 2：配置通知脚本

1. 打开 `backup_notification.scpt` 文件，并确认或修改以下内容：
    - 备份脚本的路径（`/path/to/your/backup.sh`）。

### 步骤 3：配置定时任务

1. 打开 `com.user.backupreminder.plist` 文件，并确认或修改以下内容：
    - 通知脚本的路径（`/path/to/your/backup_notification.scpt`）。
    - 每天提醒的时间（小时和分钟）。

2. 将 `com.user.backupreminder.plist` 文件放置在 `~/Library/LaunchAgents/` 目录下。

### 步骤 4：加载定时任务

使用以下命令加载定时任务：

```sh
launchctl unload ~/Library/LaunchAgents/com.user.backupreminder.plist
launchctl load ~/Library/LaunchAgents/com.user.backupreminder.plist
