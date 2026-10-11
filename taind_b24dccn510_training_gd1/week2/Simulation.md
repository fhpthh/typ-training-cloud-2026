# Phần 9: Thực hành tổng hợp & Mô phỏng thực tế

Tài liệu này mô phỏng chi tiết các kịch bản thực hành quản trị hệ thống Linux cốt lõi của Tuần 2 trên môi trường **Container LXC rỗng mới (Ubuntu 22.04 / 24.04 LTS)** kết nối với **máy Client Windows (PowerShell & WinSCP)**, cùng các tác vụ tự động hóa với Shell Script và Cronjob.

---

## 0. Thiết lập môi trường mô phỏng

Mô phỏng gồm 2 thành phần chính:
1. **Server (Target):** Container LXC (Ubuntu 22.04 LTS hoặc 24.04 LTS) vừa tạo mới tinh trên Proxmox VE / LXD, đăng nhập ban đầu bằng Console với quyền `root`. Địa chỉ IP giả định: `192.168.1.150`.
2. **Client (Workstation):** Máy tính Windows 10/11 sử dụng **Windows PowerShell** (CLI) và **WinSCP** (SFTP GUI).

---

## 1. Khởi tạo Container LXC, tạo user từ root và cấp quyền hạn chế

### Mục tiêu

Từ console `root` trên container LXC rỗng mới, cập nhật hệ thống, cài đặt dịch vụ OpenSSH và sudo, tạo tài khoản người dùng thường `skyboy12`, gán quyền `sudo` và phân quyền thư mục dự án dùng chung.

### Thực hiện

Từ console của Container LXC (quyền `root`):

```bash
# Kiểm tra phiên bản hệ điều hành và địa chỉ IP
cat /etc/os-release
ip -br a
```

Cập nhật kho gói và cài đặt các tiện ích thiết yếu:

```bash
apt update && apt upgrade -y
apt install -y openssh-server sudo curl net-tools ufw
```

Kích hoạt và khởi động dịch vụ SSH:

```bash
# Với Ubuntu 22.04 LTS:
systemctl enable --now ssh

# Với Ubuntu 24.04 LTS (Socket activation):
systemctl enable --now ssh.socket
```

Tạo người dùng mới `skyboy12` và cấp quyền `sudo`:

```bash
adduser skyboy12
usermod -aG sudo skyboy12
id skyboy12
```

Output của lệnh `id skyboy12`:

```text
uid=1000(skyboy12) gid=1000(skyboy12) groups=1000(skyboy12),27(sudo)
```

Tạo thư mục dự án `/opt/app_project`, tạo nhóm `cloud_team` và phân quyền nhóm `775`:

```bash
groupadd cloud_team
usermod -aG cloud_team skyboy12
mkdir -p /opt/app_project
chown -R root:cloud_team /opt/app_project
chmod -R 775 /opt/app_project
```

Cấu hình quyền sudo hạn chế trong file `/etc/sudoers.d/skyboy12_restricted`:

```bash
cat << 'EOF' > /etc/sudoers.d/skyboy12_restricted
skyboy12 ALL=(ALL) /bin/systemctl restart nginx, /bin/systemctl status nginx
EOF
chmod 440 /etc/sudoers.d/skyboy12_restricted
```

Kiểm tra phân quyền từ user `skyboy12`:

```bash
su - skyboy12
cd /opt/app_project
touch test_dev.txt
ls -l test_dev.txt
exit
```

Kết quả: File `test_dev.txt` được tạo thành công với quyền `skyboy12:cloud_team`.

---

## 2. Thiết lập SSH Keypair (Ed25519) và kết nối từ Windows PowerShell

### Mục tiêu

Tạo cặp khóa SSH Ed25519 trên máy trạm Windows bằng PowerShell, chuyển khóa công khai (Public Key) lên container LXC và đăng nhập không cần mật khẩu.

### Thực hiện

Trên máy Client (Windows PowerShell):

```powershell
# Kiểm tra OpenSSH client
ssh -V

# Sinh cặp khóa chuẩn Ed25519
ssh-keygen -t ed25519 -C "skyboy12@windows-laptop" -f "$env:USERPROFILE\.ssh\id_ed25519_lxc"
```

Hai file được sinh ra tại `C:\Users\<User>\.ssh\`:
- `id_ed25519_lxc`: Khóa bí mật (Private Key).
- `id_ed25519_lxc.pub`: Khóa công khai (Public Key).

Đẩy Public Key lên Container LXC qua pipeline PowerShell:

```powershell
Get-Content "$env:USERPROFILE\.ssh\id_ed25519_lxc.pub" | ssh skyboy12@192.168.1.150 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
```

Nhập mật khẩu của `skyboy12` một lần duy nhất để ghi khóa vào `authorized_keys`.

Kiểm tra kết nối SSH không dùng mật khẩu:

```powershell
ssh -i "$env:USERPROFILE\.ssh\id_ed25519_lxc" skyboy12@192.168.1.150
```

Kết quả:

```text
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 5.15.0-107-generic x86_64)
skyboy12@ubuntu-lxc:~$
```

Đăng nhập thành công tức thì mà không yêu cầu nhập mật khẩu!

Cấu hình alias trong file `$env:USERPROFILE\.ssh\config` để kết nối nhanh:

```text
Host lxc-ubuntu
    HostName 192.168.1.150
    User skyboy12
    Port 22
    IdentityFile ~/.ssh/id_ed25519_lxc
```

Từ nay trên PowerShell chỉ cần gõ:

```powershell
ssh lxc-ubuntu
```

---

## 3. Kết nối WinSCP (SFTP) và truyền nhận file đồ họa bằng Private Key

### Mục tiêu

Sử dụng phần mềm WinSCP trên Windows để kết nối SFTP với Container LXC thông qua Private Key, cho phép truyền nhận file an toàn bằng giao diện kéo thả trực quan.

### Thực hiện

#### Chuyển đổi khóa sang định dạng `.ppk` với PuTTYgen
1. Mở công cụ **PuTTYgen** trên Windows.
2. Chọn menu **Conversions** $\rightarrow$ **Import key**.
3. Chọn bộ lọc **All Files (`*.*`)**, mở file `C:\Users\<User>\.ssh\id_ed25519_lxc`.
4. Nhấn **Save private key** và lưu thành `id_ed25519_lxc.ppk` trong thư mục `.ssh`.

*(WinSCP bản mới 5.21+ có thể tự động nhận file OpenSSH và convert sang `.ppk` khi được chọn).*

#### Cấu hình Session trong WinSCP
1. Khởi động **WinSCP**:
   - **File protocol:** `SFTP` (Port `22`).
   - **Host name:** `192.168.1.150`.
   - **User name:** `skyboy12`.
   - **Password:** *Để trống*.
2. Nhấn **Advanced...** $\rightarrow$ chọn **SSH** $\rightarrow$ **Authentication**.
3. Tại ô **Private key file**, duyệt chọn file `C:\Users\<User>\.ssh\id_ed25519_lxc.ppk`.
4. Nhấn **OK**, nhấn **Save** lưu lại session với tên `LXC-Ubuntu-Skyboy12`, rồi nhấn **Login**.

#### Kết quả kết nối
WinSCP thông báo:
```text
Authenticating with public key "skyboy12@windows-laptop"
Authenticated.
```
Cửa sổ 2 bên hiển thị: bên trái là thư mục máy Windows, bên phải là thư mục `/home/skyboy12` trên LXC Container. Có thể kéo thả truyền file 2 chiều mượt mà.

---

## 4. Siết chặt bảo mật SSH Server (Hardening) và chặn Brute-Force

### Mục tiêu

Vô hiệu hóa hoàn toàn phương thức đăng nhập bằng mật khẩu (`PasswordAuthentication no`) và cấm tài khoản root đăng nhập trực tiếp qua SSH (`PermitRootLogin no`) để triệt tiêu nguy cơ tấn công dò mật khẩu.

### Thực hiện

Từ phiên kết nối SSH của `skyboy12`:

```bash
sudo nano /etc/ssh/sshd_config
```

Cấu hình các chỉ thị bảo mật:

```text
PubkeyAuthentication yes
PasswordAuthentication no
PermitEmptyPasswords no
PermitRootLogin no
```

*(Lưu ý trên Ubuntu 22/24: Kiểm tra thêm thư mục `/etc/ssh/sshd_config.d/` nếu có file cấu hình ghi đè như `50-cloud-init.conf`)*.

Kiểm tra cú pháp và khởi động lại dịch vụ SSH daemon:

```bash
sudo sshd -t
sudo systemctl restart ssh
# Hoặc trên Ubuntu 24.04: sudo systemctl restart ssh.socket
```

Kiểm tra an toàn từ máy Client (Windows PowerShell):

```powershell
# Thử đăng nhập bằng root (Kỳ vọng: Bị từ chối ngay lập tức)
ssh root@192.168.1.150
```

Kết quả:

```text
root@192.168.1.150: Permission denied (publickey).
```

Thử đăng nhập bằng user đúng kèm SSH Key:

```powershell
ssh lxc-ubuntu
```

Kết quả: Đăng nhập thành công và an toàn tuyệt đối!

---

## 5. Viết Shell Script tự động sao lưu log hệ thống và lập lịch Cron

### Mục tiêu

Viết file shell script `backup_logs.sh` tự động nén thư mục log hệ thống `/var/log` kèm timestamp, tự động xóa các bản sao lưu cũ quá 7 ngày để tránh đầy bộ nhớ, và thiết lập `crontab` chạy định kỳ lúc 02:00 sáng hàng ngày.

### Thực hiện

Tạo file script `/usr/local/bin/backup_logs.sh`:

```bash
sudo nano /usr/local/bin/backup_logs.sh
```

Nội dung script `backup_logs.sh`:

```bash
#!/bin/bash
set -euo pipefail

# Định nghĩa biến môi trường
SOURCE_LOG_DIR="/var/log"
BACKUP_DEST_DIR="/var/backups/daily_logs"
RETENTION_DAYS=7
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILENAME="syslog_backup_${TIMESTAMP}.tar.gz"
LOG_RECORD="/var/log/backup_logs_execution.log"

# Tạo thư mục lưu trữ nếu chưa có
mkdir -p "$BACKUP_DEST_DIR"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] === BẮT ĐẦU BACKUP LOG ===" >> "$LOG_RECORD"

# Đóng gói và nén
if tar -czf "${BACKUP_DEST_DIR}/${BACKUP_FILENAME}" "$SOURCE_LOG_DIR" 2>/dev/null; then
    FILE_SIZE=$(du -h "${BACKUP_DEST_DIR}/${BACKUP_FILENAME}" | awk '{print $1}')
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [SUCCESS] Đã tạo ${BACKUP_FILENAME} (${FILE_SIZE})" >> "$LOG_RECORD"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] Nén log thất bại!" >> "$LOG_RECORD"
    exit 1
fi

# Tự động dọn dẹp các bản backup cũ quá 7 ngày
DELETED_FILES=$(find "$BACKUP_DEST_DIR" -type f -name "syslog_backup_*.tar.gz" -mtime +"$RETENTION_DAYS")
if [ -n "$DELETED_FILES" ]; then
    find "$BACKUP_DEST_DIR" -type f -name "syslog_backup_*.tar.gz" -mtime +"$RETENTION_DAYS" -delete
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CLEANUP] Đã xóa các file backup cũ hơn ${RETENTION_DAYS} ngày" >> "$LOG_RECORD"
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] === HOÀN TẤT BACKUP ===" >> "$LOG_RECORD"
```

Cấp quyền thực thi và chạy thử nghiệm:

```bash
sudo chmod +x /usr/local/bin/backup_logs.sh
sudo /usr/local/bin/backup_logs.sh
```

Kiểm tra kết quả:

```bash
ls -lh /var/backups/daily_logs/
cat /var/log/backup_logs_execution.log
```

Output:

```text
[2026-10-11 10:00:00] === BẮT ĐẦU BACKUP LOG ===
[2026-10-11 10:00:02] [SUCCESS] Đã tạo syslog_backup_20261011_100000.tar.gz (1.4M)
[2026-10-11 10:00:02] === HOÀN TẤT BACKUP ===
```

Thiết lập lịch chạy tự động bằng Cron:

```bash
sudo crontab -e
```

Thêm dòng sau vào cuối file crontab:

```text
0 2 * * * /usr/local/bin/backup_logs.sh
```

Kiểm tra lịch cron đang kích hoạt:

```bash
sudo crontab -l
```

---

## 6. Dò tìm file và thư mục chiếm nhiều dung lượng đĩa nhất

### Mục tiêu

Sử dụng các lệnh dòng lệnh kết hợp pipeline để quét và lọc ra top 10 file/thư mục chiếm nhiều tài nguyên đĩa nhất trên hệ thống và thư mục home.

### Thực hiện

Dò tìm top 10 mục tốn dung lượng nhất trong thư mục home:

```bash
du -ah ~ 2>/dev/null | sort -rh | head -n 10
```

Dò tìm chính xác top 10 file đơn lẻ có kích thước lớn nhất:

```bash
find ~ -type f -exec du -h {} + 2>/dev/null | sort -rh | head -n 10
```

Tìm tất cả các file vượt ngưỡng 50MB trên toàn hệ thống:

```bash
find / -type f -size +50M -exec ls -lh {} + 2>/dev/null | awk '{print $5, $9}' | sort -hr
```

Output mẫu:

```text
145M /var/log/journal/system.journal
85M /var/cache/apt/archives/linux-image.deb
62M /usr/lib/x86_64-linux-gnu/libLLVM.so
```

Viết script tiện ích `find_largest.sh`:

```bash
cat << 'EOF' > find_largest.sh
#!/bin/bash
TARGET_DIR="${1:-$HOME}"
TOP_N="${2:-10}"
echo "Top $TOP_N file lớn nhất trong: $TARGET_DIR"
find "$TARGET_DIR" -type f -exec du -h {} + 2>/dev/null | sort -rh | head -n "$TOP_N"
EOF
chmod +x find_largest.sh
./find_largest.sh ~ 5
```

---

## Tổng kết

- Sử dụng tài khoản thông thường kèm nhóm `sudo` và phân quyền hạn chế theo nhóm thay vì vận hành trực tiếp bằng tài khoản `root`.
- Thiết lập SSH Keypair (Ed25519) kết hợp tắt mật khẩu (`PasswordAuthentication no`) và cấm root login (`PermitRootLogin no`) giúp bảo vệ máy chủ an toàn trước các cuộc tấn công Brute-force.
- Sử dụng alias trong `~/.ssh/config` trên Windows giúp tối ưu thao tác đăng nhập dòng lệnh.
- WinSCP (SFTP) kết hợp file Private Key `.ppk` mang lại giải pháp quản lý và truyền tải file đồ họa trực quan, an toàn.
- Shell Script với chuẩn an toàn `set -euo pipefail` kết hợp `crontab` là giải pháp tối ưu cho việc tự động hóa sao lưu và bảo trì hệ thống định kỳ.
- Kết hợp các công cụ `du`, `find`, `sort`, `head` cho phép chẩn đoán và xử lý nhanh chóng sự cố đầy ổ đĩa (Disk Full).

