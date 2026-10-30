# Báo cáo Tuần 2 — Linux cơ bản

> **Trạng thái: BẢN NHÁP** — đã hoàn thành đủ 9 phần; đang chờ rà soát lần cuối trước khi nộp.
>
> **Môi trường thực hành:** Ubuntu 26.04 LTS (host thật), kernel `7.0.0-38-generic`, shell `/bin/bash`.
> Các thao tác thực hành được thực hiện trong thư mục lab `~/Desktop/TYP_CLOUD_TRAINING/linux-lab`.

---

## Phần 1: Giới thiệu tổng quan về Linux

### 1.1 Linux là gì?

**Linux** là một hệ điều hành **mã nguồn mở**, được tạo thành từ **nhân Linux (kernel)** kết hợp với các thư viện và tiện ích của dự án **GNU**. Đây là hệ điều hành **đa nhiệm, đa người dùng**, chạy được trên rất nhiều kiến trúc phần cứng (x86-64, ARM, RISC-V...).

**Lịch sử phát triển:**

| Mốc thời gian | Sự kiện |
| --- | --- |
| 1969 | Ken Thompson & Dennis Ritchie tạo **Unix** tại Bell Labs — nền tảng tư tưởng của Linux |
| 1983 | Richard Stallman khởi động **dự án GNU**, xây dựng bộ công cụ mã nguồn mở (gcc, bash, coreutils...) |
| 1991 | **Linus Torvalds** công bố phiên bản kernel Linux 0.01 đầu tiên |
| 1992 | Kernel Linux phát hành theo giấy phép **GPLv2**, ghép với công cụ GNU → hệ điều hành "GNU/Linux" |
| 2000s – nay | Linux trở thành nền tảng chủ đạo của server, cloud, Android, siêu máy tính |

**Phân biệt Linux kernel và bản phân phối (distribution):**

| Thành phần | Vai trò |
| --- | --- |
| **Kernel** | Lõi hệ điều hành: lập lịch CPU, quản lý bộ nhớ, hệ thống tệp, mạng, driver thiết bị |
| **Distribution (distro)** | "Đóng gói" hoàn chỉnh: kernel + công cụ GNU + package manager + giao diện + ứng dụng |

Một số distro phổ biến: **Ubuntu / Debian** (dùng `apt`), **RHEL / CentOS / Fedora** (dùng `dnf`/`yum`), Arch Linux (`pacman`), Alpine Linux...

### 1.2 Tại sao nên học Linux?

- Được dùng ở hầu hết **server, cloud (AWS/GCP/Azure), DevOps, AI/học máy, thiết bị nhúng** → kỹ năng nền tảng không thể thiếu.
- **Miễn phí, mã nguồn mở**, cộng đồng lớn, tài liệu phong phú.
- **Ổn định, bảo mật, hiệu năng cao**, tiêu tốn ít tài nguyên hơn Windows.
- **Tự động hóa mạnh mẽ** bằng shell script, cron, SSH → thuận tiện quản trị từ xa.

So sánh nhanh:

| Tiêu chí | Linux | Windows | macOS |
| --- | --- | --- | --- |
| Mã nguồn | Mở | Đóng | Đóng |
| Chi phí | Miễn phí | Bản quyền | Kèm phần cứng Apple |
| Shell mặc định | bash / zsh | PowerShell / CMD | zsh |
| Quản trị từ xa | SSH có sẵn | RDP / PowerShell remoting | SSH |
| Ứng dụng server | Phổ biến nhất | Ít hơn | Rất ít |
| Khả năng tùy biến | Rất cao | Hạn chế | Hạn chế |

### 1.3 Kiến trúc hệ thống Linux

Kiến trúc phân tầng:

```text
+------------------------------------------------------+
|               Ứng dụng (Application)                 |   vim, firefox, docker...
+------------------------------------------------------+
|              Shell (bash, zsh) / GUI                 |   cầu nối người dùng
+------------------------------------------------------+
|                  Kernel (Linux)                      |   scheduler, memory,
|    scheduler | memory | VFS | network | driver       |   filesystem, driver
+------------------------------------------------------+
|                Phần cứng (Hardware)                  |   CPU, RAM, ổ đĩa, NIC
+------------------------------------------------------+
```

- **Kernel**: lập lịch tiến trình, quản lý bộ nhớ, hệ thống tệp (VFS), ngăn xếp mạng, quản lý thiết bị (driver/module).
- **Shell**: trình thông dịch dòng lệnh — nhận lệnh người dùng, chuyển cho kernel thực thi, trả kết quả về terminal.
- **Application layer**: các chương trình người dùng chạy phía trên (trình soạn thảo, trình duyệt, docker...).

**Quá trình khởi động (boot process) cơ bản:**

1. **BIOS/UEFI** kiểm tra phần cứng (POST) → xác định thiết bị khởi động.
2. **Bootloader (GRUB)** nạp kernel và initramfs vào RAM.
3. **Kernel** khởi tạo phần cứng, mount hệ thống tệp gốc, chạy chương trình đầu tiên.
4. **init / systemd (PID 1)** khởi động các service và đưa hệ thống về target (ví dụ `graphical.target`).
5. Hiển thị màn hình đăng nhập.


**Các thư mục hệ thống chính (chuẩn FHS):**

| Thư mục | Nội dung |
| --- | --- |
| `/bin` | Lệnh cơ bản của hệ thống (trên Ubuntu hiện là symlink → `/usr/bin`) |
| `/etc` | File cấu hình hệ thống (`passwd`, `fstab`, `ssh/`...) |
| `/home` | Thư mục cá nhân của từng người dùng |
| `/usr` | Chương trình, thư viện, tài nguyên dùng chung |
| `/var` | Dữ liệu biến động: log (`/var/log`), cache, spool |
| `/tmp` | File tạm, thường bị xóa khi khởi động lại |
| `/opt` | Phần mềm cài thêm của bên thứ ba |
| `/dev` | File thiết bị (ổ đĩa, terminal, chuột...) |
| `/proc` | Hệ thống tệp ảo của kernel (tiến trình, CPU, bộ nhớ...) |
| `/root` | Thư mục home của người dùng `root` |


## Phần 2: Làm quen với Terminal và Shell

### 2.1 Terminal & Shell là gì

- **Terminal** (terminal emulator): chương trình mở "cửa sổ dòng lệnh" để người dùng gõ lệnh (GNOME Terminal, Konsole, Windows Terminal...).
- **Shell**: chương trình trung gian giữa người dùng và kernel — nhận lệnh, thông dịch rồi yêu cầu kernel thực thi. Phổ biến: **bash** (mặc định trên Ubuntu), zsh, fish, sh.


### 2.2 Các lệnh cơ bản

| Lệnh | Chức năng |
| --- | --- |
| `pwd` | In đường dẫn của thư mục hiện tại |
| `ls` | Liệt kê nội dung thư mục |
| `cd` | Chuyển sang thư mục khác |
| `clear` | Xóa màn hình terminal |
| `history` | Xem lịch sử các lệnh đã gõ |


**Phím tắt quan trọng:**

| Phím tắt | Tác dụng |
| --- | --- |
| `Tab` | Tự động hoàn thiện tên lệnh / đường dẫn |
| `Ctrl + C` | Hủy lệnh đang chạy |
| `Ctrl + D` | Kết thúc nhập (thoát shell / EOF) |
| `Ctrl + L` | Xóa màn hình (giống `clear`) |
| `Ctrl + A` / `Ctrl + E` | Nhảy về đầu / cuối dòng lệnh |
| `Ctrl + R` | Tìm lại lệnh cũ theo từ khóa |
| `↑` / `↓` | Duyệt lại các lệnh đã gõ |

### 2.3 Hiểu cấu trúc đường dẫn

- **Đường dẫn tuyệt đối**: bắt đầu bằng `/`, mô tả đầy đủ từ thư mục gốc — ví dụ `/home/tien/Desktop`.
- **Đường dẫn tương đối**: tính từ thư mục hiện tại — ví dụ `week2/demo`, `../..`.

| Ký hiệu | Ý nghĩa |
| --- | --- |
| `~` | Thư mục home của người dùng hiện tại (`/home/tien`) |
| `.` | Thư mục hiện tại |
| `..` | Thư mục cha |
| `-` | Thư mục vừa đứng trước đó (dùng với `cd -`) |



Với **symlink**, đường dẫn "logic" và "vật lý" có thể khác nhau — `/bin` thực chất trỏ tới `/usr/bin`:

```text
$ cd /bin
$ pwd
/bin
$ pwd -P
/usr/bin
$ realpath /bin
/usr/bin
```

---

## Phần 3: Làm việc với file và thư mục

### 3.1 Tạo, xem, xóa và di chuyển file

| Lệnh | Chức năng |
| --- | --- |
| `touch <file>` | Tạo file rỗng (hoặc cập nhật thời gian sửa đổi) |
| `cat <file>` | In toàn bộ nội dung file ra màn hình |
| `less <file>` | Xem file dạng phân trang (cuộn bằng phím, `/từkhóa` để tìm, `q` để thoát) |
| `head -n <file>` | Xem `n` dòng đầu |
| `tail -n <file>` | Xem `n` dòng cuối (kèm `-f` để theo dõi log theo thời gian thực) |
| `cp <nguồn> <đích>` | Sao chép file (thêm `-r` để sao chép thư mục) |
| `mv <nguồn> <đích>` | Di chuyển / đổi tên file |
| `rm <file>` | Xóa file (thêm `-r` để xóa thư mục, `-f` để bỏ qua cảnh báo) |
| `mkdir <dir>` | Tạo thư mục (thêm `-p` để tạo cả cây thư mục cha) |
| `rmdir <dir>` | Xóa thư mục **rỗng** |


### 3.2 Sao chép và nén file

| Lệnh | Chức năng |
| --- | --- |
| `tar -czvf <file>.tar.gz <thưmục>` | Đóng gói + nén gzip (`-c` tạo, `-z` gzip, `-v` hiện chi tiết, `-f` chỉ định file) |
| `tar -xzf <file>.tar.gz` | Giải nén (`-x` giải nén, `-C <dir>` chỉ định nơi giải nén) |
| `tar -tzvf <file>.tar.gz` | Xem nội dung archive mà không giải nén (`-t` list) |
| `gzip` / `gunzip` | Nén / giải nén từng file (thay thế file gốc, dùng `-k` để giữ lại) |
| `zip -r` / `unzip` | Nén / giải nén định dạng ZIP (thông dụng khi trao đổi với Windows) |
| `scp <file> user@host:/đường/dẫn` | Sao chép file qua mạng (sẽ thực hành ở Phần 7 — Networking) |

**Khái niệm stream (luồng dữ liệu):** mọi tiến trình trên Linux có 3 luồng chuẩn:

| Luồng | FD | Ý nghĩa | Toán tử chuyển hướng |
| --- | --- | --- | --- |
| `stdin` | 0 | Dữ liệu đầu vào | `<` |
| `stdout` | 1 | Kết quả bình thường | `>` (ghi đè), `>>` (ghi tiếp) |
| `stderr` | 2 | Thông báo lỗi | `2>` |


### 3.3 Tìm kiếm file

| Lệnh | Chức năng |
| --- | --- |
| `find <dir> -name "<mẫu>"` | Tìm theo tên file/thư mục |
| `find <dir> -type f -size +100k` | Tìm file lớn hơn 100 KB (`d` = thư mục, `k/M/G` = đơn vị) |
| `locate <từkhóa>` | Tìm cực nhanh nhờ database (`/var/lib/plocate`), cập nhật bằng `sudo updatedb` |
| `grep "<mẫu>" <file>` | Tìm dòng chứa mẫu trong file (`-n` kèm số dòng, `-i` không phân biệt hoa/thường, `-r` tìm đệ quy) |
| `<lệnh> \| grep <mẫu>` | Lọc kết quả của lệnh khác qua pipe |


---

## Phần 4: Quyền truy cập và người dùng

### 4.1 Người dùng và nhóm (User & Group)

| Lệnh | Chức năng |
| --- | --- |
| `whoami` | Cho biết đang đăng nhập bằng user nào |
| `id` | Xem UID, GID và danh sách nhóm |
| `adduser <user>` / `deluser <user>` | Tạo / xóa user (cần quyền `sudo`) |
| `su - <user>` | Chuyển hẳn sang phiên làm việc của user khác |
| `sudo <lệnh>` | Chạy **một lệnh** với quyền root |
| `/etc/passwd` | Danh sách user của hệ thống (ai cũng đọc được) |

```text
$ whoami
tien

$ id
uid=1000(tien) gid=1000(tien) groups=1000(tien),27(sudo),100(users),980(libvirt),986(docker),993(kvm)

$ groups
tien sudo users libvirt docker kvm
```

### 4.2 Phân quyền file

Cấu trúc quyền khi chạy `ls -l`:

```text
-rwxr-xr-x  1  tien  tien  1234  Oct  9  script.sh
│└┬┘└┬┘└┬┘  │   │     │
│ │  │  │   │   │     └── nhóm sở hữu (group)
│ │  │  │   │   └── chủ sở hữu (owner/user)
│ │  │  │   └── số liên kết cứng (hard link)
│ │  │  └── quyền của other (3 ký tự cuối)
│ │  └── quyền của group
│ └── quyền của user (owner)
└── loại file: `-` file thường, `d` thư mục, `l` symlink
```

Quyền `rwx` và giá trị số:

| Ký hiệu | Tên | Ý nghĩa với file | Ý nghĩa với thư mục | Giá trị |
| --- | --- | --- | --- | --- |
| `r` | read | Đọc nội dung | Liệt kê (`ls`) | 4 |
| `w` | write | Sửa nội dung | Tạo/xóa file bên trong | 2 |
| `x` | execute | Chạy file (script/binary) | Đi vào thư mục (`cd`) | 1 |

#### `chmod` — thay đổi quyền truy cập

- **Định nghĩa:** đổi quyền `r/w/x` cho file/thư mục. Chỉ **chủ sở hữu** hoặc **root** mới được thay đổi quyền.
- **Cách dùng:** `chmod <quyền> <file>` — quyền viết được dưới dạng **số (octal)** hoặc **ký hiệu**.

Ví dụ tổng quan:

```bash
chmod 755 script.sh          # chủ: rwx | nhóm: r-x | khác: r-x
chmod 644 note.txt           # chủ: rw- | nhóm: r-- | khác: r--
chmod +x script.sh           # thêm quyền thực thi cho mọi người
chmod u=rw,g=r,o= file.txt   # chủ: rw, nhóm: r, khác: không quyền
```

| Số | Ký hiệu | Dùng cho |
| --- | --- | --- |
| `644` | `rw-r--r--` | File thông thường |
| `755` | `rwxr-xr-x` | Script, thư mục chia sẻ |
| `600` | `rw-------` | File riêng tư (SSH key, `.env`...) |
| `700` | `rwx------` | Thư mục riêng tư của user |
| `777` | `rwxrwxrwx` | Toàn quyền cho tất cả — **không nên dùng** |

#### `chown` / `chgrp` — đổi chủ sở hữu / nhóm

- **Định nghĩa:** `chown` đổi **chủ sở hữu** (và có thể đổi cả nhóm), `chgrp` chỉ đổi **nhóm**. Vì ảnh hưởng tới an toàn hệ thống nên thao tác này thường cần quyền root (`sudo`).
- **Cách dùng:** `chown <user>[:<group>] <file>` và `chgrp <group> <file>`.

Ví dụ tổng quan:

```bash
sudo chown sv_lab report.txt             # đổi chủ sở hữu thành sv_lab
sudo chown sv_lab:sv_lab report.txt      # đổi cả chủ sở hữu và nhóm
sudo chown -R sv_lab:sv_lab duan/        # áp dụng cho toàn bộ thư mục con
sudo chgrp sv_lab baocao.txt             # chỉ đổi nhóm sở hữu
```

> Ghi chú: user thường chỉ đổi được nhóm sang nhóm mà mình **là thành viên**; muốn đổi chủ sở hữu bắt buộc dùng `sudo`.

### 4.3 Quyền root và an toàn

**Vì sao không nên chạy mọi thứ bằng root:**

- Root có toàn quyền — một lệnh gõ sai có thể xóa/phá hỏng hệ thống, không có "thùng rác" để khôi phục.
- Mọi chương trình (kể cả mã độc) chạy dưới quyền root đều nắm toàn bộ hệ thống: đọc dữ liệu, cài backdoor, sửa file hệ thống.
- Nguyên tắc **least privilege** (đặc quyền tối thiểu): chỉ nâng lên root khi thật cần, trong thời gian ngắn nhất.

**Phân biệt `sudo` và `su`:**

| Tiêu chí | `sudo` | `su` |
| --- | --- | --- |
| Mật khẩu cần nhập | Mật khẩu **của chính mình** | Mật khẩu **của user đích** (mặc định là root) |
| Phạm vi | Chạy **1 lệnh** với quyền cao (`sudo -i` nếu muốn mở shell root) | Mở hẳn **phiên làm việc** của user đích |
| Ghi log | Có — dùng để truy vết (`journalctl`, `/var/log/auth.log`) | Hạn chế |
| Phân quyền | Qua `/etc/sudoers`, group `sudo` (ai được chạy gì) | Phải biết mật khẩu user đích |

---

## Phần 5: Quản lý tiến trình và hệ thống

### 5.1 Quản lý tiến trình (process)

Mỗi chương trình đang chạy là một **tiến trình**, được định danh bằng **PID** (mã số) và có tiến trình cha (**PPID**).

| Lệnh | Chức năng |
| --- | --- |
| `ps aux` | Liệt kê mọi tiến trình (kèm user, %CPU, %MEM) |
| `ps -ef` | Liệt kê dạng đầy đủ (PID, PPID, thời gian bắt đầu) |
| `ps -p <PID>` | Xem một tiến trình cụ thể |
| `top` | Theo dõi realtime; nhấn `q` để thoát, `P` sắp theo CPU, `M` sắp theo RAM, `k` để kill |
| `htop` | Như `top` nhưng trực quan hơn (cài bằng `sudo apt install htop`) |
| `kill <PID>` | Gửi tín hiệu dừng tới một tiến trình |
| `killall <tên>` | Dừng mọi tiến trình theo tên |
| `pkill -f <chuỗi>` | Dừng tiến trình theo mẫu trong dòng lệnh |

Ví dụ:

```bash
ps aux | grep nginx        # tìm nhanh tiến trình theo tên
kill 1234                  # yêu cầu dừng "nhẹ nhàng" (SIGTERM)
kill -9 1234               # buộc dừng ngay (SIGKILL)
killall firefox            # dừng toàn bộ tiến trình firefox
```

> **Trường hợp đặc biệt:**
> - `kill` mặc định gửi **SIGTERM (15)** — tiến trình có cơ hội lưu dữ liệu rồi thoát; `kill -9` (**SIGKILL**) không thể bị chặn nhưng có thể gây mất dữ liệu → chỉ dùng khi SIGTERM không hiệu quả.
> - Tín hiệu thông dụng khác: `SIGHUP (1)` yêu cầu nạp lại cấu hình, `SIGSTOP/SIGCONT` tạm dừng/tiếp tục tiến trình.

**Foreground / Background:**

| Thao tác | Cách dùng | Ý nghĩa |
| --- | --- | --- |
| Chạy nền | `./script.sh &` | Tiến trình chạy dưới nền, trả prompt ngay |
| Xem danh sách job | `jobs` | Liệt kê các job đang chạy nền |
| Đưa job ra nền | `bg %1` | Tiếp tục job 1 đang tạm dừng ở chế độ nền |
| Đưa job lên tiền cảnh | `fg %1` | Đưa job 1 trở lại foreground |
| Tạm dừng | `Ctrl + Z` | Tạm dừng tiến trình đang chạy foreground |
| Chạy bền khi thoát terminal | `nohup ./script.sh &` | Tiến trình không bị dừng khi đóng terminal (bỏ qua SIGHUP) |

### 5.2 Kiểm tra tài nguyên hệ thống

| Lệnh | Chức năng |
| --- | --- |
| `df -h` | Dung lượng còn trống của các ổ đĩa |
| `du -sh <dir>` | Dung lượng một thư mục chiếm (`--max-depth=1` để xem từng thư mục con) |
| `free -h` | RAM và swap đang dùng/còn trống |
| `uptime` | Thời gian hệ thống đã chạy + load average 1/5/15 phút |
| `uname -a` | Thông tin kernel, kiến trúc máy |
| `lscpu` | Thông tin CPU |
| `lsblk` | Danh sách ổ đĩa và phân vùng |

Ví dụ:

```bash
df -h /                       # dung lượng ổ gốc
du -sh ~/Downloads            # thư mục Downloads chiếm bao nhiêu
du -h --max-depth=1 /var      # thư mục con nào trong /var nặng nhất
free -h
uptime                        # ví dụ: load average: 0.52, 0.58, 0.59
```

> **Trường hợp đặc biệt:**
> - `df` báo đầy nhưng `du` tính không khớp → thường do file đã bị xóa nhưng tiến trình vẫn giữ handle; tìm bằng `sudo lsof +L1`.
> - Load average cao hơn số nhân CPU (xem bằng `nproc`) nghĩa là hệ thống đang quá tải.

### 5.3 Dịch vụ và tiến trình nền (daemon)

**Daemon** là tiến trình chạy nền, không gắn với terminal (ví dụ `sshd`, `cron`). Trên Ubuntu hiện đại, dịch vụ được quản lý bởi **systemd**.

| Lệnh | Chức năng |
| --- | --- |
| `systemctl status <svc>` | Xem trạng thái dịch vụ |
| `sudo systemctl start/stop/restart <svc>` | Bật / tắt / khởi động lại dịch vụ |
| `sudo systemctl enable/disable <svc>` | Bật / tắt tự khởi động cùng hệ thống |
| `systemctl list-units --type=service` | Liệt kê các dịch vụ |
| `journalctl -u <svc>` | Xem log của dịch vụ (`-f` theo dõi realtime, `-n 20` lấy 20 dòng cuối) |
| `service <svc> <action>` | Cách cũ, trên Ubuntu là wrapper gọi `systemctl` |


> **Lưu ý:**
> - `start` và `enable` khác nhau: `start` chạy ngay lập tức, `enable` chỉ đăng ký tự chạy khi khởi động — dùng `enable --now` để làm cả hai.
> - Dịch vụ hệ thống cần `sudo`; dịch vụ riêng của user dùng `systemctl --user`.
> - Cấu hình dịch vụ sửa trong `/etc/systemd/system/` (hoặc `/lib/systemd/system/`) → sau khi sửa phải `sudo systemctl daemon-reload`.

---

## Phần 6: Quản lý gói phần mềm

### 6.1 Trình quản lý gói (Package Manager)

**Định nghĩa:** công cụ tự động tải, cài đặt, nâng cấp, gỡ bỏ phần mềm và giải quyết **phụ thuộc (dependency)** giữa các gói.

| Hệ điều hành | Công cụ | Định dạng gói |
| --- | --- | --- |
| Debian / Ubuntu | `apt`, `apt-get`, `dpkg` | `.deb` |
| RedHat / CentOS / Fedora | `yum`, `dnf`, `rpm` | `.rpm` |
| Arch Linux | `pacman` | `.pkg.tar.zst` |
| Alpine | `apk` | `.apk` |

> `apt` là phiên bản thân thiện của `apt-get` (có thanh tiến trình, gợi ý) — phù hợp gõ tay; `apt-get` có output ổn định nên hay dùng trong script tự động.

### 6.2 Cài đặt và gỡ bỏ phần mềm

| Lệnh | Chức năng |
| --- | --- |
| `sudo apt update` | Cập nhật **danh sách** gói từ kho (không nâng cấp gì) |
| `sudo apt upgrade` | Nâng cấp các gói đã cài lên bản mới |
| `sudo apt install <gói>` | Cài gói mới |
| `sudo apt remove <gói>` | Gỡ gói (giữ lại file cấu hình) |
| `sudo apt purge <gói>` | Gỡ gói + xóa cả file cấu hình |
| `sudo apt autoremove` | Dọn các gói phụ thuộc không còn dùng |
| `apt search <từkhóa>` | Tìm gói trong kho |
| `apt show <gói>` | Xem thông tin chi tiết gói |
| `dpkg -l` | Liệt kê các gói đã cài (`dpkg -l \| grep <tên>`) |
| `sudo dpkg -i <file>.deb` | Cài trực tiếp từ file `.deb` tải ngoài |

> **Note:**
> - Quy trình chuẩn: `apt update` → `apt install` → (tùy chọn) `apt upgrade`.
> - `apt update` chỉ làm mới **danh sách gói**; muốn nâng cấp thật phải chạy `apt upgrade` — hai việc khác nhau.
> - Cài file `.deb` bằng `dpkg -i` bị thiếu phụ thuộc → chạy `sudo apt install -f` để apt tự bổ sung.

### 6.3 Tạo và sử dụng alias

**Định nghĩa:** alias là "bí danh" cho lệnh dài/khó nhớ, giúp gõ nhanh hơn.

| Thao tác | Cách dùng |
| --- | --- |
| Xem danh sách alias | `alias` |
| Tạo tạm thời | `alias ll='ls -alF'` (mất khi đóng terminal) |
| Tạo vĩnh viễn | Thêm dòng alias vào `~/.bashrc` |
| Áp dụng ngay | `source ~/.bashrc` |
| Xóa alias | `unalias <tên>` |

Ví dụ — thêm vào cuối `~/.bashrc`:

```bash
alias ll='ls -alF'
alias cls='clear'
alias gs='git status'
alias update='sudo apt update && sudo apt upgrade -y'
```
---

## Phần 7: Làm việc với mạng (Networking)

### 7.1 Mô hình OSI và TCP/IP

**Mô hình OSI (7 tầng)** — cách chia bài toán mạng thành các tầng độc lập, mỗi tầng chỉ làm một việc:

| # | Tầng | Chức năng | Ví dụ |
| --- | --- | --- | --- |
| 7 | Application | Giao diện với ứng dụng | HTTP, FTP, SMTP, DNS |
| 6 | Presentation | Mã hóa, nén, định dạng dữ liệu | SSL/TLS, JPEG, ASCII |
| 5 | Session | Quản lý phiên làm việc | RPC, NetBIOS |
| 4 | Transport | Chia nhỏ dữ liệu, cổng, độ tin cậy | TCP, UDP |
| 3 | Network | Địa chỉ IP, định tuyến | IP, ICMP, router |
| 2 | Data Link | Địa chỉ MAC, đóng gói frame | Ethernet, switch |
| 1 | Physical | Truyền bit trên cáp/sóng | Cáp mạng, card mạng (NIC) |

**Mô hình TCP/IP (4 tầng)** — mô hình thực tế Internet đang dùng:

| TCP/IP | Tương ứng OSI | Giao thức tiêu biểu |
| --- | --- | --- |
| Application | 5 – 7 | HTTP, DNS, SSH, SMTP |
| Transport | 4 | TCP, UDP |
| Internet | 3 | IP, ICMP |
| Network Access | 1 – 2 | Ethernet, Wi-Fi |

**So sánh TCP và UDP:**

| Tiêu chí | TCP | UDP |
| --- | --- | --- |
| Kết nối | Có (3-way handshake) | Không kết nối |
| Độ tin cậy | Cao — đủ thứ tự, mất gói thì gửi lại (ACK) | Không đảm bảo |
| Tốc độ / overhead | Chậm hơn, nặng hơn | Nhanh, nhẹ |
| Ứng dụng | Web (HTTP), SSH, email, truyền file | DNS, streaming, game, VoIP |


### 7.2 IP Address, Subnet và CIDR

- **IPv4**: dài 32-bit, viết dưới dạng 4 octet — ví dụ `192.168.1.10`. Mỗi địa chỉ gồm phần **network** (mạng) và phần **host** (máy).
- Địa chỉ đặc biệt cần nhớ:

| Dải địa chỉ | Ý nghĩa |
| --- | --- |
| `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16` | Địa chỉ **nội bộ (private)** — dùng trong LAN |
| `127.0.0.0/8` | **Loopback** — `127.0.0.1` chính là `localhost` |
| `169.254.0.0/16` | Link-local — máy tự gán khi **không xin được DHCP** |

- **Subnet mask** xác định đâu là phần network, đâu là phần host. **CIDR** là cách viết tắt: `/24` = `255.255.255.0`.

| CIDR | Subnet mask | Tổng địa chỉ | Host dùng được |
| --- | --- | --- | --- |
| `/30` | 255.255.255.252 | 4 | 2 |
| `/25` | 255.255.255.128 | 128 | 126 |
| `/24` | 255.255.255.0 | 256 | 254 |
| `/16` | 255.255.0.0 | 65.536 | 65.534 |
| `/8` | 255.0.0.0 | 16.777.216 | 16.777.214 |

### 7.3 Gateway, Routing và DNS

- **Gateway (default gateway)**: "cửa ra" khỏi mạng nội bộ — muốn đi ra Internet, máy phải biết gateway (thường là router, ví dụ `192.168.1.1`).
- **Routing**: mỗi gói tin được đối chiếu với **bảng định tuyến** để chọn đường đi phù hợp.

```bash
ip route                                        # xem bảng định tuyến (dòng "default via ...")
sudo ip route add 10.10.0.0/16 via 192.168.1.254  # thêm route tĩnh
traceroute google.com                           # xem đường đi qua từng chặng
```

- **DNS**: dịch tên miền thành địa chỉ IP (ví dụ `github.com` → `140.82.x.x`).

| Lệnh | Chức năng |
| --- | --- |
| `dig <tênmiền>` | Truy vấn DNS chi tiết (`+short` để gọn) |
| `nslookup <tênmiền>` | Truy vấn DNS nhanh |
| `resolvectl status` | Xem DNS đang dùng (systemd-resolved) |

### 7.4 Các lệnh kiểm tra mạng

| Lệnh | Chức năng |
| --- | --- |
| `ping <host>` | Kiểm tra kết nối, đo độ trễ (ICMP) |
| `ifconfig` | Xem/cấu hình interface — công cụ cũ (gói `net-tools`) |
| `ip addr` / `ip link` | Công cụ hiện đại thay thế `ifconfig` |
| `netstat -tuln` | Xem cổng đang mở — công cụ cũ |
| `ss -tuln` | Công cụ hiện đại thay thế `netstat` |
| `curl <url>` | Gửi request HTTP và xem nội dung |
| `wget <url>` | Tải file từ web |
| `traceroute <host>` | Xem đường đi của gói tin qua từng router |

```bash
ping -c 4 8.8.8.8                  # gửi đúng 4 gói rồi dừng
ip -br addr
ss -tuln | grep LISTEN
curl -I https://example.com        # chỉ lấy HTTP header
curl -o page.html https://example.com
curl ifconfig.me                   # xem IP công khai
wget -c https://example.com/file.zip   # -c: tiếp tục tải nếu bị đứt
``` 

### 7.5 Kết nối SSH và truyền file

**SSH (Secure Shell)** — kết nối tới shell của máy khác qua mạng với toàn bộ phiên được mã hóa:

```bash
ssh user@192.168.1.10            # kết nối (mặc định cổng 22)
ssh -p 2222 user@server          # chỉ định cổng khác
ssh -i ~/.ssh/key user@server    # chỉ định private key
```

**Thiết lập SSH key (đăng nhập không cần mật khẩu):**

```bash
ssh-keygen -t ed25519 -C "email@example.com"   # tạo cặp khóa trong ~/.ssh/
ssh-copy-id user@server                        # copy public key lên server
ssh user@server                                # đăng nhập bằng key
```

**Truyền file:**

| Lệnh | Chức năng |
| --- | --- |
| `scp <file> user@ip:/path` | Sao chép file qua SSH |
| `scp -r <dir> user@ip:/path` | Sao chép cả thư mục |
| `scp -P 2222 <file> ...` | Chỉ định cổng (chú ý `-P` viết hoa) |
| `rsync -avz <dir>/ user@ip:/path` | Đồng bộ — chỉ truyền phần thay đổi |
| `rsync -avz --delete ...` | Đồng bộ + xóa file ở đích nếu nguồn không còn |

```bash
scp baocao.pdf sv@10.0.0.5:/home/sv/
scp -r duan/ sv@10.0.0.5:/home/sv/
rsync -avz --progress duan/ sv@10.0.0.5:/home/sv/duan/
```

> **Trường hợp đặc biệt:**
> - Lần đầu kết nối, SSH hỏi xác nhận **fingerprint** của server — cần kiểm tra trước khi gõ `yes`.
> - `ssh-keygen` tạo 2 file: **private key** (giữ kín, quyền `600`) và **public key** `.pub` (được copy đi). Nếu quyền `~/.ssh` (700) hoặc key (600) sai, SSH sẽ **từ chối dùng key**.
> - `scp` dùng `-P` cho cổng; `ssh` dùng `-p` thường.
> - Có thể lưu cấu hình trong `~/.ssh/config` để đặt tên ngắn (`Host sv` → `HostName`, `User`, `Port`...).

#### Cơ chế mã hóa và xác thực của SSH

**A. Mã hóa — bảo vệ đường truyền**

1. **Thương lượng thuật toán**: hai bên gửi `KEXINIT`, chọn thuật toán chung theo thứ tự ưu tiên (kex, cipher, MAC).

2. **Trao đổi khóa — sinh khóa phiên**
   - **Cổ điển (DH nhóm nguyên tố)**: thống nhất `p` (số nguyên tố) và `g` (generator); mỗi bên chọn bí mật `a`/`b`, trao đổi công khai `A = g^a mod p`, `B = g^b mod p`; khóa chung `K = B^a mod p = A^b mod p`. Vẫn được hỗ trợ cho tương thích nhưng xếp cuối bảng ưu tiên.
   - **Hiện đại (X25519 / ECDH)**: mỗi bên sinh số bí mật tạm thời `a`, gửi `Q = a·B`; hai bên tự tính shared secret là x-coordinate của `ab·B`. An toàn dựa trên bài toán logarit rời rạc trên đường cong elliptic (ECDLP): từ `a·B` tìm `a` cần ~2¹²⁸ bước → bất khả thi.
   - **Mới nhất**: hybrid post-quantum (`mlkem768x25519`) — kết hợp X25519 + ML-KEM-768, chống cả máy tính lượng tử.
   - Private tạm thời bị hủy sau handshake → **forward secrecy**: lộ host key sau này vẫn không giải mã được traffic cũ.

   *Phương trình đường cong Curve25519 (dạng Montgomery):*

   ```
   y² = x³ + 486662x² + x  (mod p),   p = 2²⁵⁵ − 19
   ```

   Điểm gốc `B` là điểm trên đường cong có `x = 9`; X25519 chỉ dùng x-coordinate (Montgomery ladder).

   *Công thức cộng điểm trên đường cong dạng Weierstrass `y² = x³ + ax + b (mod p)`:*

   | Phép toán | Hệ số góc λ | Tọa độ kết quả |
   | --- | --- | --- |
   | `P + Q` (P ≠ Q) | `λ = (y₂ − y₁)/(x₂ − x₁)` | `x₃ = λ² − x₁ − x₂`; `y₃ = λ(x₁ − x₃) − y₁` |
   | `2P` (tiếp tuyến) | `λ = (3x₁² + a)/(2y₁)` | `x₃ = λ² − 2x₁`; `y₃ = λ(x₁ − x₃) − y₁` |

   Mọi phép tính đều `mod p`. `a·B` = cộng `B` với chính nó `a` lần, tính nhanh bằng double-and-add (~255 bước với số 255-bit).

3. **Từ shared secret → khóa phiên (KDF)**
   - KDF sinh 6 giá trị: IV, khóa mã hóa, khóa MAC — riêng cho từng chiều (A–F).
   - Ghép thêm exchange hash `H` + `session_id` → khóa gắn chặt với phiên này.

4. **Mã hóa dữ liệu**
   - Cipher hiện đại: ChaCha20-Poly1305 / AES-GCM (mã hóa + toàn vẹn gộp), hoặc AES-CTR + HMAC (Encrypt-then-MAC).
   - Mỗi gói có: payload + padding + MAC (phủ cả số thứ tự gói → chống replay/xáo trộn).
   - Rekey định kỳ (~1GB / 1 giờ) → khóa mới.

**B. Xác thực danh tính — hai tầng, hai loại khóa**

**Tầng 1 — Xác thực server (host key) — chống MITM**
- Server ký exchange hash `H` bằng host key; `H` chứa version, thuật toán, `Q_C/Q_S`, shared secret.
- Client đối chiếu fingerprint trong `known_hosts` (lần đầu = TOFU), hoặc qua host certificate/SSHFP-DNS.
- Không verify host key → mất toàn bộ bảo mật, kể cả dùng key auth.

**Tầng 2 — Xác thực user (RFC 4252)**

| | Password | Public key |
| --- | --- | --- |
| Cơ chế | Gửi password trong tunnel đã mã hóa | Client **ký** dữ liệu bằng private key |
| Dữ liệu ký | — | `session ID` + user + service + key blob |
| Server kiểm | PAM/`/etc/shadow` | Public key trong `authorized_keys` + verify chữ ký |
| Private key | — | Không bao giờ rời máy client |
| Replay | — | Bất khả (chữ ký gắn session ID) |
| Yếu điểm | Brute-force; lộ nếu server bị hack | Mất file key; agent forwarding |

- Password có thể nâng cấp bằng **keyboard-interactive** (OTP/2FA) hoặc kết hợp `AuthenticationMethods publickey,password`.

### 7.6 Kiểm tra cổng và firewall

**Cổng (port)** là số 16-bit (0–65535) để phân biệt các dịch vụ trên cùng một máy: well-known (0–1023), registered (1024–49151), dynamic (49152–65535).

| Cổng | Dịch vụ |
| --- | --- |
| 22 | SSH |
| 53 | DNS |
| 80 / 443 | HTTP / HTTPS |
| 3306 | MySQL |
| 5432 | PostgreSQL |

```bash
ss -tuln                 # t: TCP, u: UDP, l: đang listen, n: hiện số cổng
sudo ss -tlnp            # thêm tiến trình đang giữ cổng (-p)
sudo lsof -i :80         # tiến trình nào đang dùng cổng 80
```

**Firewall bằng `ufw` (Uncomplicated Firewall):**

```bash
sudo ufw status verbose
sudo ufw allow 22/tcp                                  # mở cổng SSH
sudo ufw allow from 192.168.1.0/24 to any port 3306    # mở theo dải IP
sudo ufw delete allow 22/tcp                           # xóa rule
sudo ufw enable        # bật firewall
sudo ufw disable       # tắt firewall
```

**Firewall bằng `iptables`:**

```bash
sudo iptables -L -n -v                                  # xem danh sách rule
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT      # thêm rule
sudo iptables -D INPUT -p tcp --dport 22 -j ACCEPT      # xóa rule
```

> **Trường hợp đặc biệt:**
> - `ufw` là lớp dễ dùng bọc trên `iptables`. Trên server từ xa, phải `allow` cổng SSH **trước khi** `ufw enable`, nếu không sẽ tự khóa mình khỏi server.
> - Rule `iptables` có hiệu lực ngay nhưng **mất sau reboot** nếu không lưu (`sudo netfilter-persistent save` với gói `iptables-persistent`); các bản Ubuntu mới dùng backend `nftables`.
> - `ss -tuln` xem được cổng không cần `sudo`; thêm `-p` cần `sudo` mới thấy tiến trình của user khác.

---

## Phần 8: Script & Automation cơ bản

### 8.1 Shell Script là gì

- **Định nghĩa:** file văn bản chứa các lệnh shell chạy tuần tự — công cụ tự động hóa các tác vụ lặp lại.
- **Shebang** — dòng đầu tiên cho biết dùng trình thông dịch nào: `#!/bin/bash`.
- **Cách chạy:**

| Cách chạy | Đặc điểm |
| --- | --- |
| `bash script.sh` | Chạy bằng shell mới — không cần quyền thực thi |
| `./script.sh` | Cần `chmod +x`; dùng shebang trong file |
| `source script.sh` / `. script.sh` | Chạy **trong shell hiện tại** — biến/hàm giữ lại sau khi chạy |

Ví dụ (`hello.sh`):

```bash
#!/bin/bash
# Script chao mung
echo "Xin chao $USER"
echo "Hom nay: $(date '+%d/%m/%Y')"
echo "Thu muc hien tai: $(pwd)"
```

### 8.2 Biến, vòng lặp và điều kiện

**Biến — khai báo và sử dụng:**

```bash
TEN="Tien"                  # khai báo — KHÔNG có khoảng trắng quanh dấu =
echo "Xin chao $TEN"        # đọc giá trị bằng $
readonly VERSION="1.0"      # hằng số, không sửa được nữa

echo "User: $USER | Home: $HOME | Shell: $SHELL"    # biến môi trường có sẵn
echo "Tham so thu nhat: $1 — tong so: $#"           # tham số dòng lệnh ($1, $2, $#, $@)
```

**Điều kiện `if`:**

```bash
if [ "$USER" = "root" ]; then
    echo "Dang la root"
elif [ -f /etc/passwd ]; then
    echo "File /etc/passwd ton tai"
else
    echo "Khong phai root"
fi
```

| Kiểm tra | Ý nghĩa |
| --- | --- |
| `-eq -ne -lt -le -gt -ge` | So sánh **số** |
| `= !=` | So sánh **chuỗi** |
| `-f` / `-d` | File thường / thư mục |
| `-z` / `-n` | Chuỗi rỗng / khác rỗng |

**Vòng lặp:**

```bash
for i in 1 2 3; do
    echo "Lan $i"
done

for f in *.log; do
    echo "Xu ly: $f"
done

i=0
while [ $i -lt 5 ]; do
    echo "i = $i"
    i=$((i + 1))
done
```

> **Lưu ý:**
> - `TEN = "Tien"` (có khoảng trắng quanh `=`) là **lỗi** — shell hiểu là gọi lệnh tên `TEN`.
> - `[ ]` bắt buộc khoảng trắng hai bên; bash dùng `[[ ]]` an toàn hơn (không cần quote biến).
> - Nháy đơn `'...'` không nội suy biến; muốn dùng biến phải nháy kép `"..."`.
> - Số học dùng `$(( ))`; trong `[ ]` không dùng `<` `>` (shell hiểu là chuyển hướng) mà dùng `-lt/-gt`.

### 8.3 Tự động hóa tác vụ với cron

**cron** là daemon chạy lệnh theo lịch; mỗi user có crontab riêng.

| Lệnh | Chức năng |
| --- | --- |
| `crontab -e` | Mở crontab để sửa |
| `crontab -l` | Xem crontab hiện tại |
| `crontab -r` | Xóa toàn bộ crontab |
| `sudo crontab -e` | Crontab của root |

Cú pháp 5 trường + lệnh:

```text
* * * * *  <lệnh>
│ │ │ │ │
│ │ │ │ └── thứ (0–7, 0/7 = Chủ nhật)
│ │ │ └──── tháng (1–12)
│ │ └────── ngày trong tháng (1–31)
│ └──────── giờ (0–23)
└────────── phút (0–59)
```

Ví dụ:

```bash
0 2 * * *     /home/tien/scripts/backup.sh     # 2h sáng mỗi ngày
*/5 * * * *   /home/tien/scripts/check.sh      # mỗi 5 phút
0 8 * * 1-5   /home/tien/scripts/hello.sh      # 8h sáng thứ 2 – thứ 6
@reboot       /home/tien/scripts/start.sh      # chạy khi khởi động
```
---

## Phần 9: Thực hành tổng hợp

> 5 bài tập kết hợp kiến thức Phần 1–8, trình bày dạng mục tiêu + các bước + lệnh mẫu.

### Bài 1 — Tạo user mới, cấp quyền hạn chế

**Mục tiêu:** user mới chỉ đọc được dữ liệu chia sẻ, không có quyền `sudo`.

```bash
sudo adduser sv_readonly                          # tạo user + đặt mật khẩu
sudo mkdir -p /srv/shared
echo "du lieu chia se" | sudo tee /srv/shared/data.txt

sudo chown root:sv_readonly /srv/shared/data.txt
sudo chmod 640 /srv/shared/data.txt                # nhóm chỉ được đọc
sudo chmod 750 /srv/shared                         # nhóm được vào thư mục

sudo -u sv_readonly cat /srv/shared/data.txt       # OK: đọc được
sudo -u sv_readonly touch /srv/shared/new.txt      # BỊ CHẶN: không có quyền ghi
sudo -l -U sv_readonly                             # kiểm tra: không có quyền sudo
```

### Bài 2 — Tạo và nén backup thư mục

```bash
sudo mkdir -p /srv/backup
tar -czvf /srv/backup/shared-$(date +%F).tar.gz /srv/shared
ls -lh /srv/backup/
tar -tzvf /srv/backup/shared-*.tar.gz              # kiểm tra nội dung backup
```

### Bài 3 — Script tự động sao lưu log hệ thống hàng ngày

Tạo file `/usr/local/bin/backup-logs.sh` (ví dụ bằng `sudo nano`) với nội dung:

```bash
#!/bin/bash
SRC="/var/log"
DEST="$HOME/backups"
mkdir -p "$DEST"

tar -czf "$DEST/logs-$(date +%F).tar.gz" "$SRC" 2>/dev/null
find "$DEST" -name 'logs-*.tar.gz' -mtime +7 -delete        # giữ 7 ngày gần nhất
echo "[$(date '+%F %T')] backup xong -> $DEST" >> "$DEST/backup.log"
```

```bash
sudo chmod +x /usr/local/bin/backup-logs.sh
/usr/local/bin/backup-logs.sh                      # chạy thử
cat ~/backups/backup.log

crontab -e                                         # thêm dòng đặt lịch:
0 2 * * * /usr/local/bin/backup-logs.sh
crontab -l                                         # xác nhận lịch đã lưu
```

> **Đặc biệt:** `/var/log` có file chỉ root đọc được → nếu bị `Permission denied`, dùng `sudo crontab -e` (cron của root) hoặc thu hẹp nguồn backup.

### Bài 4 — Dò tìm file lớn nhất trong thư mục home

```bash
# Top 10 file lớn nhất
find ~ -type f -printf '%s\t%p\n' 2>/dev/null | sort -nr | head -10

# Dạng dung lượng dễ đọc
du -ah ~ 2>/dev/null | sort -rh | head -10

# Chỉ liệt kê file lớn hơn 100 MB
find ~ -type f -size +100M 2>/dev/null
```

> `2>/dev/null` để ẩn lỗi "Permission denied"; `-printf` là tính năng của GNU find (có sẵn trên Ubuntu).

### Bài 5 — Cấu hình SSH và kiểm tra kết nối

```bash
# 1) Tạo key và cài public key lên server
ssh-keygen -t ed25519 -C "tien@lab"
ssh-copy-id user@server-ip

# 2) Đăng nhập bằng key + chạy lệnh từ xa
ssh user@server-ip 'hostname; whoami; uptime'

# 3) Kiểm tra mật khẩu đã bị tắt (chỉ còn key)
ssh -o PubkeyAuthentication=no user@server-ip        # -> Permission denied (publickey)

# 4) Phía server: kiểm tra cổng và dịch vụ
ss -tuln | grep :22
systemctl status ssh          # với VM/systemd
```

> Đối chiếu cơ chế chi tiết ở mục 7.5 và quy trình "key-only" đã thực hành: tạo key → copy → xác nhận → tắt password → kiểm tra.
