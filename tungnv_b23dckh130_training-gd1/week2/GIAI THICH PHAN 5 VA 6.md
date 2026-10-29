# TÀI LIỆU GIẢI THÍCH CHUYÊN SÂU: PHẦN 5 VÀ PHẦN 6
## Quản Lý Tiến Trình, Hệ Thống và Quản Lý Gói Phần Mềm Trong Linux

- **Tác giả:** Nguyễn Vĩnh Tùng (B23DCKH130)
- **Tài liệu gốc tham chiếu:** [BAO CAO TUAN 2.md](file:///d:/typ-training-cloud-2026/tungnv_b23dckh130_training-gd1/week2/BAO%20CAO%20TUAN%202.md)
- **Phạm vi nội dung:** Giải thích chi tiết bản chất kỹ thuật, cơ chế tầng nhân (Kernel Space / User Space), các tùy chọn cờ tham số và ứng dụng thực tế của toàn bộ các lệnh trong **Phần 5** và **Phần 6**.

---

## MỤC LỤC CHI TIẾT

- [A. PHẦN 5: QUẢN LÝ TIẾN TRÌNH VÀ HỆ THỐNG](#a-phần-5-quản-lý-tiến-trình-và-hệ-thống)
  - [1. Mục 13: Quản lý tiến trình (Process Management)](#1-mục-13-quản-lý-tiến-trình-process-management)
    - [1.1. Lệnh `ps` - Chụp ảnh trạng thái tiến trình](#11-lệnh-ps---chụp-ảnh-trạng-thái-tiến-trình)
    - [1.2. Lệnh `top` và `htop` - Giám sát tài nguyên thời gian thực](#12-lệnh-top-và-htop---giám-sát-tài-nguyên-thời-gian-thực)
    - [1.3. Lệnh `kill` và `killall` - Cơ chế tín hiệu điều khiển POSIX](#13-lệnh-kill-và-killall---cơ-chế-tín-hiệu-điều-khiển-posix)
    - [1.4. Quản lý tác vụ Tiền cảnh (Foreground) và Hậu cảnh (Background)](#14-quản-lý-tác-vụ-tiền-cảnh-foreground-và-hậu-cảnh-background)
  - [2. Mục 14: Kiểm tra tài nguyên hệ thống (System Resources)](#2-mục-14-kiểm-tra-tài-nguyên-hệ-thống-system-resources)
    - [2.1. Lệnh `df` (Disk Free) và `du` (Disk Usage)](#21-lệnh-df-disk-free-và-du-disk-usage)
    - [2.2. Lệnh `free` - Phân tích trạng thái bộ nhớ RAM và Swap](#22-lệnh-free---phân-tích-trạng-thái-bộ-nhớ-ram-và-swap)
    - [2.3. Lệnh `uptime` - Phụ tải hệ thống (Load Average)](#23-lệnh-uptime---phụ-tải-hệ-thống-load-average)
    - [2.4. Lệnh `uname`, `lscpu`, `lsblk` - Thông tin phần cứng và hệ thống](#24-lệnh-uname-lscpu-lsblk---thông-tin-phần-cứng-và-hệ-thống)
  - [3. Mục 15: Dịch vụ và tiến trình nền (systemd Daemons & Services)](#3-mục-15-dịch-vụ-và-tiến-trình-nền-systemd-daemons--services)
    - [3.1. Kiến trúc `systemd` và vai trò của Service Unit](#31-kiến-trúc-systemd-và-vai-trò-của-service-unit)
    - [3.2. Lệnh `systemctl` - Điều khiển vòng đời dịch vụ](#32-lệnh-systemctl---điều-khiển-vòng-đời-dịch-vụ)
    - [3.3. So sánh `systemctl` và lệnh cổ điển `service`](#33-so-sánh-systemctl-và-lệnh-cổ-điển-service)
    - [3.4. Lệnh `journalctl` - Truy vấn nhật ký tập trung hệ thống](#34-lệnh-journalctl---truy-vấn-nhật-ký-tập-trung-hệ-thống)
- [B. PHẦN 6: QUẢN LÝ GÓI PHẦN MỀM](#b-phần-6-quản-lý-gói-phần-mềm)
  - [4. Mục 16: Trình quản lý gói (Package Managers Architecture)](#4-mục-16-trình-quản-lý-gói-package-managers-architecture)
    - [4.1. Phân tầng công cụ: Cấp thấp (Low-level) vs Cấp cao (High-level)](#41-phân-tầng-công-cụ-cấp-thấp-low-level-vs-cấp-cao-high-level)
    - [4.2. Cơ chế Repository và Xác thực chữ ký điện tử GPG](#42-cơ-chế-repository-và-xác-thực-chữ-ký-điện-tử-gpg)
    - [4.3. Đối chiếu hai họ Linux: Debian/Ubuntu vs Red Hat/CentOS (`apt` vs `dnf`)](#43-đối-chiếu-hai-họ-linux-debianubuntu-vs-red-hatcentos-apt-vs-dnf)
  - [5. Mục 17: Cài đặt và gỡ bỏ phần mềm](#5-mục-17-cài-đặt-và-gỡ-bỏ-phần-mềm)
    - [5.1. Bộ đôi `apt update` và `apt upgrade` (So sánh với `full-upgrade`)](#51-bộ-đôi-apt-update-và-apt-upgrade-so-sánh-với-full-upgrade)
    - [5.2. Lệnh `sudo apt install` và quy trình 5 bước cài đặt](#52-lệnh-sudo-apt-install-và-quy-trình-5-bước-cài-đặt)
    - [5.3. Gỡ bỏ phần mềm: `apt remove` vs `apt purge`](#53-gỡ-bỏ-phần-mềm-apt-remove-vs-apt-purge)
    - [5.4. Các lệnh bảo trì dọn dẹp: `apt autoremove` và `apt clean`](#54-các-lệnh-bảo-trì-dọn-dẹp-apt-autoremove-và-apt-clean)
    - [5.5. Thao tác gói nhị phân cấp thấp với `dpkg`](#55-thao-tác-gói-nhị-phân-cấp-thấp-với-dpkg)
  - [6. Mục 18: Bí danh dòng lệnh (Alias)](#6-mục-18-bí-danh-dòng-lệnh-alias)
    - [6.1. Bản chất hoạt động của Alias trong Bash Shell](#61-bản-chất-hoạt-động-của-alias-trong-bash-shell)
    - [6.2. Cấu hình vĩnh viễn trong `~/.bashrc` và lệnh `source`](#62-cấu-hình-vĩnh-viễn-trong-bashrc-và-lệnh-source)
    - [6.3. Mổ xẻ chi tiết lệnh mẫu `alias ll='ls -alF'`](#63-mổ-xẻ-chi-tiết-lệnh-mẫu-alias-llls--alf)
    - [6.4. Quản trị, hủy bỏ (`unalias`) và thủ thuật bypass Alias](#64-quản-trị-hủy-bỏ-unalias-và-thủ-thuật-bypass-alias)

---

# A. PHẦN 5: QUẢN LÝ TIẾN TRÌNH VÀ HỆ THỐNG
*(Tham chiếu gốc tại [BAO CAO TUAN 2.md:L376-496](file:///d:/typ-training-cloud-2026/tungnv_b23dckh130_training-gd1/week2/BAO%20CAO%20TUAN%202.md#L376-L496))*

---

## 1. Mục 13: Quản lý tiến trình (Process Management)

### 1.1. Lệnh `ps` - Chụp ảnh trạng thái tiến trình
- **Bản chất kỹ thuật:** Lệnh `ps` (*Process Status*) chụp lại trạng thái tức thời (*snapshot*) của các tiến trình tại thời điểm thực thi. Dữ liệu mà `ps` hiển thị không phải do nó tự sinh ra, mà được đọc trực tiếp từ hệ thống tệp ảo `/proc` do Kernel duy trì trong RAM. Mỗi thư mục mang tên số `/proc/<PID>/` lưu giữ thông tin chi tiết của tiến trình đó (như `/proc/<PID>/cmdline`, `/proc/<PID>/status`, `/proc/<PID>/stat`).
- **Hai phong cách sử dụng kinh điển:**
  1. **Phong cách BSD (`ps aux` - Không dùng dấu gạch ngang):**
     - `a` (*all users*): Hiển thị tiến trình của tất cả người dùng trong hệ thống.
     - `u` (*user-oriented*): Định dạng hiển thị tập trung vào người dùng, bổ sung các cột tài nguyên như `%CPU`, `%MEM`, `USER`.
     - `x` (*without tty*): Liệt kê cả những tiến trình không gắn liền với màn hình Terminal ảo nào (ví dụ các daemon hệ thống `nginx`, `systemd`, `sshd`).
  2. **Phong cách chuẩn UNIX/POSIX (`ps -ef` - Có dấu gạch ngang):**
     - `-e` (*every process*): Chọn tất cả các tiến trình đang chạy.
     - `-f` (*full format*): Định dạng đầy đủ nhiều trường, đặc biệt cung cấp cột **`PPID` (Parent Process ID)** giúp xác định tiến trình cha đã sinh ra tiến trình này.

- **Ý nghĩa chi tiết các cột đầu ra của `ps aux`:**
  - `USER`: Tên tài khoản người dùng đang sở hữu tiến trình.
  - `PID`: Process ID - Mã số định danh duy nhất của tiến trình.
  - `%CPU`: Tỷ lệ phần trăm chu kỳ CPU mà tiến trình đang chiếm dụng.
  - `%MEM`: Tỷ lệ phần trăm bộ nhớ RAM vật lý tiến trình đang dùng.
  - `VSZ` (*Virtual Memory Size*): Tổng dung lượng bộ nhớ ảo tiến trình được cấp phát (tính bằng KB), bao gồm cả code, thư viện liên kết và vùng nhớ chưa nạp vào RAM.
  - `RSS` (*Resident Set Size*): Dung lượng bộ nhớ RAM vật lý thực tế không hoán đổi mà tiến trình đang chiếm đóng.
  - `TTY`: Thiết bị Terminal điều khiển tiến trình (dấu `?` nghĩa là tiến trình nền không gắn với Terminal).
  - `STAT`: Trạng thái vận hành hiện tại của tiến trình.
  - `START`: Thời điểm tiến trình được khởi chạy.
  - `TIME`: Tổng thời gian tích lũy mà CPU đã trực tiếp xử lý các chỉ lệnh của tiến trình này.
  - `COMMAND`: Câu lệnh khởi chạy kèm toàn bộ đối số truyền vào.

- **Giải mã chi tiết các ký tự trạng thái `STAT`:**
  - `R` (*Running or Runnable*): Đang chạy trên CPU hoặc nằm trong hàng đợi sẵn sàng chạy (*run queue*).
  - `S` (*Interruptible Sleep*): Đang ngủ ngắt được, chờ một sự kiện (như chờ dữ liệu mạng, bàn phím, tín hiệu).
  - `D` (*Uninterruptible Sleep*): Đang ngủ không thể ngắt, thường là đang chờ phần cứng ổ đĩa đọc ghi khối dữ liệu (I/O wait). Không thể dùng `kill -9` để tắt tiến trình ở trạng thái này.
  - `Z` (*Zombie / Defunct*): Tiến trình đã chết (gọi hàm `exit()`) nhưng tiến trình cha chưa gọi `wait()` để đọc mã trạng thái kết thúc. Bản ghi của nó vẫn nằm trong bảng tiến trình của kernel, gây tốn PID.
  - `T` (*Stopped*): Tiến trình bị tạm dừng (do người dùng bấm `Ctrl + Z` hoặc nhận tín hiệu `SIGSTOP`).
  - Các ký tự bổ trợ: `<` (độ ưu tiên cao), `N` (độ ưu tiên thấp - nice value cao), `s` (là session leader), `l` (đa luồng - multithreaded), `+` (nằm ở foreground).

---

### 1.2. Lệnh `top` và `htop` - Giám sát tài nguyên thời gian thực
- **Lệnh `top`:**
  - Giám sát liên tục và cập nhật động mỗi 3 giây một lần.
  - **Phân tích dòng Header của `top`:**
    - `load average: 0.15, 0.22, 0.18`: Phụ tải trung bình trong 1, 5 và 15 phút.
    - `Tasks`: Tổng số tiến trình, số tiến trình running, sleeping, stopped, zombie.
    - `%Cpu(s)`:
      - `us` (*user*): Thời gian CPU chạy ứng dụng người dùng không có độ ưu tiên thấp.
      - `sy` (*system*): Thời gian CPU phục vụ các lời gọi hệ thống của Kernel (*system calls*).
      - `ni` (*nice*): Thời gian chạy các tiến trình người dùng có điều chỉnh mức ưu tiên.
      - `id` (*idle*): Tỷ lệ thời gian CPU rảnh rỗi.
      - `wa` (*iowait*): Tỷ lệ CPU rảnh rỗi nhưng phải ngồi chờ phần cứng ổ cứng hoàn tất đọc/ghi dữ liệu. Nếu `wa` cao, ổ đĩa chính là nút thắt cổ chai (*bottleneck*).
      - `hi` / `si`: Phục vụ ngắt phần cứng (*hardware interrupts*) và ngắt mềm (*software interrupts*).
      - `st` (*steal time*): Tỷ lệ CPU ảo bị máy chủ vật lý lấy đi cấp cho máy ảo khác trong môi trường ảo hóa Cloud.
    - `MiB Mem` và `MiB Swap`: Trạng thái RAM vật lý và phân vùng hoán đổi.
  - **Phím tắt điều khiển nhanh:**
    - `M`: Sắp xếp danh sách giảm dần theo dung lượng RAM (`%MEM`).
    - `P`: Sắp xếp danh sách giảm dần theo CPU (`%CPU`).
    - `k`: Nhập PID để gửi tín hiệu ngắt/diệt tiến trình trực tiếp.
    - `1`: Hiển thị thông số chi tiết từng lõi CPU riêng biệt.
    - `q`: Thoát khỏi chương trình.

- **Lệnh `htop`:**
  - Bản nâng cấp đồ họa dạng text (*ncurses*) của `top`.
  - Hỗ trợ thanh đo trực quan màu sắc cho từng CPU core, RAM, Swap.
  - Cho phép cuộn chuột, xem quan hệ cha con dạng cây (`F5` - Tree view), tìm kiếm tiến trình theo tên (`F3`), lọc theo chuỗi (`F4`), gửi tín hiệu nhanh (`F9`).

---

### 1.3. Lệnh `kill` và `killall` - Cơ chế tín hiệu điều khiển POSIX
- **Bản chất:** `kill` không chỉ là "diệt tiến trình", bản chất của nó là gửi **Tín hiệu POSIX (Signals)** tới một tiến trình thông qua Kernel.

| Số hiệu tín hiệu | Tên chuẩn | Hành vi mặc định | Khả năng chặn/bắt | Mô tả và cơ chế hoạt động |
| :---: | :---: | :---: | :---: | :--- |
| **1** | `SIGHUP` | Terminate | Có thể bắt | Hangup: Báo hiệu ngắt kết nối Terminal. Các dịch vụ daemon (Nginx, Apache) bắt tín hiệu này để **Reload lại cấu hình** mà không cần tắt tiến trình. |
| **2** | `SIGINT` | Terminate | Có thể bắt | Interrupt: Phát ra khi người dùng ấn **`Ctrl + C`** trên bàn phím để yêu cầu dừng tiến trình đang chạy. |
| **9** | `SIGKILL` | Terminate | **Không thể bắt / Cấm bỏ qua** | Kill ngay lập tức: Kernel thu hồi RAM, dọn tài nguyên và hủy tiến trình ngay tại chỗ. Ứng dụng không có cơ hội lưu dữ liệu hay dọn file tạm. |
| **15** | `SIGTERM` | Terminate | Có thể bắt | Terminate an toàn (Mặc định của `kill <PID>`): Yêu cầu tiến trình tự dọn dẹp, đóng kết nối database, flush dữ liệu đĩa rồi tự thoát (*Graceful Shutdown*). |
| **18** | `SIGCONT` | Continue | Có thể bắt | Cho phép tiến trình đang tạm dừng được tiếp tục chạy. |
| **19** | `SIGSTOP` | Stop | **Không thể bắt / Cấm bỏ qua** | Tạm dừng tiến trình vô điều kiện do Kernel điều khiển. |

- **Nguyên tắc vàng khi quản trị:** Luôn thử gửi tín hiệu `SIGTERM` (`kill <PID>` hoặc `kill -15 <PID>`) trước để tiến trình dọn dẹp an toàn. Chỉ dùng `SIGKILL` (`kill -9 <PID>`) khi tiến trình đã bị treo cứng (*frozen*) và từ chối phản hồi `SIGTERM`.
- **Lệnh `killall`:**
  - Cú pháp: `sudo killall <tên_chương_trình>`
  - Gửi tín hiệu tới tất cả các tiến trình có tên tương ứng thay vì phải dò từng PID. Ví dụ `sudo killall -9 nginx` sẽ quét và diệt sạch mọi worker của Nginx.

---

### 1.4. Quản lý tác vụ Tiền cảnh (Foreground) và Hậu cảnh (Background)
- **Foreground (Tiền cảnh):** Tiến trình chiếm giữ bàn phím và màn hình Terminal. Người dùng không thể nhập thêm lệnh nào khác cho đến khi tiến trình kết thúc.
- **Background (Hậu cảnh):** Tiến trình chạy ngầm, giải phóng ngay Terminal để nhận câu lệnh tiếp theo.
- **Ký tự `&`:** Đặt ở cuối câu lệnh để đẩy tác vụ xuống chạy ngầm ngay từ khi bắt đầu:
  ```bash
  tar -czvf backup.tar.gz /var/log &
  ```
- **Cơ chế Job Control trong Shell:**
  - `Ctrl + Z`: Gửi tín hiệu `SIGTSTP`, tạm dừng (*suspend/freeze*) tiến trình đang chạy ở tiền cảnh và chuyển xuống danh sách quản lý Job.
  - `jobs`: Liệt kê các tác vụ đang chạy ngầm hoặc tạm dừng trong phiên shell hiện tại.
    - Cột hiển thị: `[1]+ Stopped    vim file.txt` (Job ID là 1).
  - `bg %1`: Cho phép Job số 1 tiếp tục chạy ở chế độ nền (*background*).
  - `fg %1`: Kéo Job số 1 từ chế độ nền trở lại chạy ở tiền cảnh (*foreground*).
- **Lệnh `nohup` (No Hangup):**
  - Khi đóng cửa sổ SSH/Terminal, Shell cha gửi tín hiệu `SIGHUP` tới tất cả tiến trình con của nó, làm các tiến trình con này bị tắt theo.
  - Cú pháp: `nohup python3 server.py &`
  - Cơ chế: `nohup` chặn đứng tín hiệu `SIGHUP`, cho phép tiến trình con tiếp tục chạy ngầm vĩnh viễn kể cả khi người quản trị ngắt kết nối SSH. Toàn bộ `stdout` và `stderr` được tự động chuyển hướng vào file `nohup.out`.

---

## 2. Mục 14: Kiểm tra tài nguyên hệ thống (System Resources)

### 2.1. Lệnh `df` (Disk Free) và `du` (Disk Usage)
- **`df` (Disk Free):**
  - **Bản chất:** Đọc cấu trúc siêu dữ liệu (*Superblock*) của hệ thống tệp (VFS). Phản hồi gần như tức thì vì không cần quét qua từng tệp tin.
  - `df -h`: Hiển thị dung lượng theo đơn vị thân thiện với con người (*Human-readable*: K, M, G).
  - `df -i`: Kiểm tra tỷ lệ sử dụng bảng chỉ mục **inode** (*Index Node*).
    - *Sự cố thực tế:* Ổ cứng báo lỗi "No space left on device" mặc dù `df -h` cho thấy ổ cứng còn trống 500GB. Nguyên nhân là do có quá nhiều tệp tin rác kích thước 0 byte làm cạn kiệt 100% số lượng inode được cấp phát.
- **`du` (Disk Usage):**
  - **Bản chất:** Duyệt đệ quy qua từng tệp và thư mục trên ổ đĩa, tính tổng số khối đĩa (*blocks*) thực tế đang bị chiếm dụng.
  - `du -sh /var/log`: Tính tổng dung lượng thư mục `/var/log` (`-s` là summary, `-h` là human-readable).
  - `du -h --max-depth=1 /var`: Liệt kê dung lượng chi tiết của từng thư mục con ở cấp 1 bên dưới `/var`, công cụ hữu hiệu nhất để tìm thư mục "thủ phạm" gây đầy đĩa.
  - *Hiện tượng bất đồng bộ giữa `df` và `du`:* Khi một file nhật ký khổng lồ (ví dụ 50GB) bị lệnh `rm` xóa đi, `du` báo dung lượng đã giảm nhưng `df` vẫn báo ổ cứng bị đầy. Nguyên nhân: Một tiến trình vẫn đang mở file descriptor tới file đó. Phải khởi động lại tiến trình (hoặc reload) để file descriptor được đóng hoàn toàn thì Kernel mới giải phóng các khối đĩa vật lý.

---

### 2.2. Lệnh `free` - Phân tích trạng thái bộ nhớ RAM và Swap
- **Bản chất:** Truy vấn thông tin trực tiếp từ `/proc/meminfo`.
- **Cú pháp:** `free -h`
- **Phân tích từng trường:**
  - `total`: Tổng dung lượng RAM vật lý có sẵn trong máy.
  - `used`: Dung lượng RAM đang bị các tiến trình chiếm dụng thực tế.
  - `free`: Dung lượng RAM hoàn toàn chưa được chạm tới.
  - `shared`: Lượng bộ nhớ dùng chung (như tmpfs, shared memory segments).
  - `buff/cache`:
    - `buffers`: Vùng nhớ tạm lưu các khối dữ liệu thô chuẩn bị ghi xuống đĩa hoặc vừa đọc từ đĩa lên.
    - `cache` (*Page Cache*): Nhân Linux tận dụng RAM rảnh rỗi để lưu trữ tạm các trang dữ liệu đã đọc từ ổ cứng nhằm tăng tốc độ truy xuất trong tương lai.
    - *Nguyên tắc cốt lõi:* **Linux mượn RAM nhàn rỗi để làm bộ đệm.** Khi ứng dụng cần thêm RAM, Linux Kernel sẽ ngay lập tức thu hồi vùng `buff/cache` này để cấp phát cho ứng dụng.
  - `available`: **Chỉ số quan trọng nhất để đánh giá sức khỏe RAM.** Đại diện cho lượng RAM có thể cấp phát ngay lập tức cho các tiến trình mới mà không cần phải đẩy dữ liệu ra phân vùng Swap.

---

### 2.3. Lệnh `uptime` - Phụ tải hệ thống (Load Average)
- **Cú pháp:** `uptime`
- **Đầu ra mẫu:** `20:15:32 up 45 days, 3:12,  2 users,  load average: 1.25, 0.85, 0.40`
- **Bản chất của Load Average:**
  - Đại diện cho số lượng tiến trình trung bình đang ở trạng thái **Running (`R`)** (đang chạy hoặc chờ chạy trên CPU) cộng với số tiến trình ở trạng thái **Uninterruptible Sleep (`D`)** (chờ I/O đĩa).
  - Ba mốc thời gian: 1 phút, 5 phút và 15 phút gần nhất.
- **Cách đánh giá chỉ số:**
  - Cần so sánh Load Average với **tổng số lõi CPU** của hệ thống (kiểm tra bằng `nproc` hoặc `lscpu`).
  - Ví dụ máy chủ có 4 CPU Cores:
    - Load = 2.0: Hệ thống đang sử dụng 50% công suất CPU.
    - Load = 4.0: Hệ thống hoạt động 100% công suất lý tưởng.
    - Load = 8.0: Hệ thống quá tải nghiêm trọng, trung bình luôn có 4 tiến trình phải xếp hàng chờ phục vụ.

---

### 2.4. Lệnh `uname`, `lscpu`, `lsblk` - Thông tin phần cứng và hệ thống
- **`uname` (Unix Name):**
  - Thực hiện system call `uname()` để đọc cấu trúc `utsname` từ Kernel.
  - `uname -r`: Trả về phiên bản bản dựng của Kernel (ví dụ `5.15.0-89-generic`).
  - `uname -a`: Trích xuất toàn bộ thông tin: Tên kernel, tên máy chủ (*hostname*), phiên bản kernel, kiến trúc vi xử lý (`x86_64`), hệ điều hành GNU/Linux.
- **`lscpu`:**
  - Thu thập thông tin từ `/proc/cpuinfo` và cây thư mục `/sys/devices/system/cpu/`.
  - Hiển thị: Kiến trúc (`Architecture: x86_64`), số CPU sockets vật lý, số Cores per socket, Threads per core (Hyper-Threading), các cờ tính năng CPU (như ảo hóa VT-x/AMD-V) và kích thước bộ nhớ đệm L1d, L1i, L2, L3.
- **`lsblk` (List Block Devices):**
  - Đọc cấu trúc từ `/sys/block/` để hiển thị sơ đồ phân cấp dạng cây của các thiết bị lưu trữ dạng khối.
  - Cung cấp: Tên thiết bị (`sda`, `nvme0n1`), số định danh Major:Minor, kích thước (`SIZE`), loại thiết bị (`disk`, `part`, `lvm`), và điểm gắn kết vào thư mục gốc (`MOUNTPOINTS`).

---

## 3. Mục 15: Dịch vụ và tiến trình nền (systemd Daemons & Services)

### 3.1. Kiến trúc `systemd` và vai trò của Service Unit
- `systemd` là hệ thống quản lý khởi tạo hệ thống (PID 1) thay thế cho SysV init truyền thống.
- **Cơ chế Unit File:** Quản lý dịch vụ thông qua các tệp văn bản có phần mở rộng `.service` được lưu trữ tại:
  - `/lib/systemd/system/`: Chứa các unit mặc định do gói phần mềm cài vào.
  - `/etc/systemd/system/`: Chứa các cấu hình tùy biến của quản trị viên (có độ ưu tiên cao nhất, ghi đè lên thư mục `/lib/`).
- `systemd` sử dụng **cgroups (Control Groups)** của Kernel để nhóm toàn bộ các tiến trình của một dịch vụ lại với nhau, đảm bảo khi dừng một dịch vụ thì mọi tiến trình con/cháu của nó đều bị tắt triệt để, không bị sót lại tiến trình mồ côi.

---

### 3.2. Lệnh `systemctl` - Điều khiển vòng đời dịch vụ
Lệnh quản trị trung tâm của `systemd` hỗ trợ các thao tác chính:

- **Thao tác tức thời (Runtime):**
  - `sudo systemctl start nginx`: Khởi động dịch vụ Nginx ngay lập tức.
  - `sudo systemctl stop nginx`: Dừng dịch vụ Nginx ngay lập tức.
  - `sudo systemctl restart nginx`: Tắt hoàn toàn rồi bật lại mới dịch vụ (làm gián đoạn các kết nối mạng hiện tại trong vài tích tắc).
  - `sudo systemctl reload nginx`: **Gửi tín hiệu nạp lại file cấu hình mới mà không tắt tiến trình**, giữ nguyên mọi phiên kết nối đang phục vụ của khách hàng.
  - `systemctl status nginx`: Hiển thị trạng thái chi tiết: active/inactive, thời gian hoạt động, PID chính, Memory/CPU tiêu thụ, và 10 dòng log mới nhất.
  - `systemctl is-active nginx`: Trả về chuỗi `active` hoặc `inactive` (thích hợp dùng trong các câu lệnh điều kiện của Bash Script).

- **Thao tác khởi động cùng hệ thống (Boot time):**
  - `sudo systemctl enable nginx`: Bật chế độ tự động khởi chạy cùng máy. **Bản chất:** `systemd` tạo một liên kết mềm (*symlink*) từ tệp cấu hình `.service` vào thư mục mục tiêu khởi động `/etc/systemd/system/multi-user.target.wants/`.
  - `sudo systemctl disable nginx`: Tắt tự khởi chạy cùng máy. **Bản chất:** Xóa tệp liên kết mềm symlink khỏi thư mục `.wants`.
  - `systemctl is-enabled nginx`: Kiểm tra dịch vụ có được bật tự khởi động hay không.
  - `sudo systemctl mask nginx`: Khóa hoàn toàn dịch vụ bằng cách trỏ symlink của nó tới `/dev/null`, ngăn chặn mọi tiến trình khác vô tình kích hoạt dịch vụ này.

---

### 3.3. So sánh `systemctl` và lệnh cổ điển `service`
- Lệnh `service` là công cụ từ thời kỳ SysV init (tương tác với các tệp kịch bản bash trong `/etc/init.d/`).
- Trên các hệ thống Linux hiện đại (Ubuntu 16.04+, CentOS 7+), lệnh `service <tên_dịch_vụ> <hành_động>` chỉ là một lớp bọc tương thích ngược (*compatibility wrapper*). Khi người dùng gõ lệnh này, hệ điều hành tự động chuyển hướng sang cú pháp chuẩn `systemctl <hành_động> <tên_dịch_vụ>`.

---

### 3.4. Lệnh `journalctl` - Truy vấn nhật ký tập trung hệ thống
- **Bản chất:** Dịch vụ `systemd-journald` thu thập toàn bộ log từ Kernel, tiến trình hệ thống, syslog, cũng như luồng xuất chuẩn `stdout`/`stderr` của mọi service. Toàn bộ log được lưu dưới dạng file nhị phân đã lập chỉ mục index (tại `/run/log/journal/` hoặc `/var/log/journal/`), giúp tốc độ tìm kiếm nhanh hơn định dạng văn bản truyền thống.
- **Các câu lệnh thông dụng:**
  - `journalctl -u nginx`: Chỉ lọc xem các bản ghi log phát sinh từ đơn vị dịch vụ `nginx.service`.
  - `journalctl -u nginx -f`: Chế độ bám sát liên tục (*follow*), hiển thị các dòng log mới theo thời gian thực tương tự lệnh `tail -f`.
  - `journalctl -xe`: Mở xem log tại thời điểm gần nhất có lỗi xảy ra (`-e` tự động nhảy xuống cuối trang, `-x` cung cấp thông tin giải thích bổ sung nguyên nhân lỗi từ tài liệu hệ thống).
  - `journalctl --since "1 hour ago"`: Lọc log phát sinh trong vòng 1 giờ vừa qua.
  - `journalctl -b`: Chỉ xem log ghi nhận kể từ lần khởi động máy gần nhất.
  - `sudo journalctl --vacuum-size=500M`: Tự động xóa các file nhật ký cũ để giới hạn tổng dung lượng log không vượt quá 500MB.

---

# B. PHẦN 6: QUẢN LÝ GÓI PHẦN MỀM
*(Tham chiếu gốc tại [BAO CAO TUAN 2.md:L498-647](file:///d:/typ-training-cloud-2026/tungnv_b23dckh130_training-gd1/week2/BAO%20CAO%20TUAN%202.md#L498-L647))*

---

## 4. Mục 16: Trình quản lý gói (Package Managers Architecture)

### 4.1. Phân tầng công cụ: Cấp thấp (Low-level) vs Cấp cao (High-level)
Kiến trúc quản lý gói trong Linux được thiết kế phân tầng rõ rệt:

```text
┌────────────────────────────────────────────────────────┐
│  TẦNG CẤP CAO (High-Level Package Managers)           │
│  - Debian/Ubuntu: apt, apt-get, apt-cache              │
│  - RedHat/CentOS: dnf, yum                             │
│  => Chức năng: Kết nối Internet, tải Metadata,         │
│     giải quyết đồ thị phụ thuộc (Dependencies Graph)   │
└──────────────────────────┬─────────────────────────────┘
                           │ (Tự động gọi tầng dưới)
                           ▼
┌────────────────────────────────────────────────────────┐
│  TẦNG CẤP THẤP (Low-Level Package Managers)            │
│  - Debian/Ubuntu: dpkg                                 │
│  - RedHat/CentOS: rpm                                  │
│  => Chức năng: Thao tác file cục bộ (.deb / .rpm),     │
│     giải nén file, ghi nhận DB trạng thái (/var/lib/)  │
└────────────────────────────────────────────────────────┘
```

- **Tệp `.deb` là gì?** Về bản chất kỹ thuật, tệp `.deb` là một file nén định dạng `ar` tiêu chuẩn chứa 3 thành phần con:
  1. `debian-binary`: Tệp văn bản chứa số hiệu phiên bản định dạng gói (thường là 2.0).
  2. `control.tar.xz`: Chứa thông tin mô tả gói, danh sách các gói phụ thuộc (*dependencies*), và các kịch bản kích hoạt trước/sau khi cài đặt (`preinst`, `postinst`, `prerm`, `postrm`).
  3. `data.tar.xz`: Chứa toàn bộ cây thư mục và tệp nhị phân thực thi thực tế sẽ được bung ra trên hệ thống.

---

### 4.2. Cơ chế Repository và Xác thực chữ ký điện tử GPG
- **Tệp cấu hình kho:** Danh mục máy chủ lưu trữ được khai báo trong `/etc/apt/sources.list` và các tệp mở rộng `.list` hoặc `.sources` trong thư mục `/etc/apt/sources.list.d/`.
- **Cấu trúc một dòng khai báo chuẩn:**
  ```text
  deb http://archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse
  [1]                [2]                 [3]                     [4]
  ```
  - `[1] deb`: Loại kho nhị phân biên dịch sẵn (nếu là `deb-src` nghĩa là kho chứa mã nguồn để người dùng tự biên dịch).
  - `[2] URL`: Địa chỉ mạng của máy chủ Mirror chứa kho phần mềm.
  - `[3] jammy`: Tên mã phiên bản của hệ điều hành (Ubuntu 22.04 LTS có tên mã là Jammy Jellyfish).
  - `[4] Thành phần (Components):`
    - `main`: Phần mềm mã nguồn mở được Canonical hỗ trợ và cập nhật bảo mật chính thức.
    - `restricted`: Các trình điều khiển phần cứng (*drivers*) độc quyền nguồn đóng được hỗ trợ.
    - `universe`: Phần mềm mã nguồn mở do cộng đồng duy trì.
    - `multiverse`: Phần mềm có bản quyền hạn chế, có thể vi phạm vấn đề pháp lý hoặc bằng sáng chế.
- **Xác thực chữ ký số GPG (GNU Privacy Guard):**
  - Khi tải tệp chỉ mục từ kho, `apt` tải kèm tệp chữ ký điện tử `InRelease`.
  - Hệ thống sử dụng khóa công khai GPG được lưu trữ an toàn trong `/etc/apt/keyrings/` để giải mã chữ ký, so sánh mã băm SHA256 của các tệp gói phần mềm. Nếu phát hiện tệp tin bị chỉnh sửa hoặc máy chủ giả mạo, `apt` lập tức từ chối cài đặt.

---

### 4.3. Đối chiếu hai họ Linux: Debian/Ubuntu vs Red Hat/CentOS (`apt` vs `dnf`)
- **Lệnh `yum` vs `dnf` trên Red Hat/CentOS:**
  - `yum` là công cụ thế hệ cũ (viết bằng Python 2), thuật toán giải quyết phụ thuộc chậm và tiêu tốn nhiều bộ nhớ RAM.
  - `dnf` (*Dandified YUM*) là công cụ thế hệ mới (mặc định từ RHEL 8, CentOS 8, Fedora):
    - Sử dụng thuật toán giải quyết phụ thuộc thông minh **SAT solver** thông qua thư viện C `libsolv`.
    - Tốc độ xử lý siêu dữ liệu nhanh hơn, quản lý bộ đệm thông minh, tiết kiệm tài nguyên hệ thống.

---

## 5. Mục 17: Cài đặt và gỡ bỏ phần mềm

### 5.1. Bộ đôi `apt update` và `apt upgrade` (So sánh với `full-upgrade`)
- **`sudo apt update`:**
  - **Bản chất:** Kết nối tới danh sách máy chủ trong `sources.list`, tải về các tệp chỉ mục metadata mới nhất và lưu cục bộ tại thư mục `/var/lib/apt/lists/`.
  - **Lưu ý cốt tử:** Lệnh này **hoàn toàn KHÔNG tải hay nâng cấp bất kỳ phần mềm nào trên máy**. Nó chỉ cập nhật danh bạ phiên bản để hệ thống biết hiện tại trên kho có bản cập nhật nào mới.
- **`sudo apt upgrade`:**
  - **Bản chất:** So sánh danh bạ phiên bản vừa tải về với các gói đang cài đặt trên máy. Nếu có gói nào có phiên bản mới hơn, nó tải file `.deb` về bộ nhớ đệm `/var/cache/apt/archives/` và gọi `dpkg` nâng cấp.
  - **Nguyên tắc an toàn:** `apt upgrade` **không bao giờ tự ý xóa bất kỳ gói phần mềm nào đang có trên máy**. Nếu một bản nâng cấp mới yêu cầu phải gỡ bỏ một gói phần mềm cũ xung đột, nó sẽ giữ nguyên gói đó ở trạng thái chưa cập nhật (*kept back*).
- **`sudo apt full-upgrade` (hoặc `apt-get dist-upgrade`):**
  - Nâng cấp toàn diện và thông minh hơn: Sẵn sàng tự động cài thêm gói phụ thuộc mới hoặc **gỡ bỏ các gói cũ bị xung đột** để hoàn tất việc nâng cấp toàn bộ hệ thống lên phiên bản mới nhất.

---

### 5.2. Lệnh `sudo apt install` và quy trình 5 bước cài đặt
Khi thực thi `sudo apt install <package>`, hệ thống trải qua 5 bước tuần tự:
1. **Tra cứu Metadata:** Đọc cơ sở dữ liệu `/var/lib/apt/lists/` để xác định gói có tồn tại hay không và phiên bản chính xác là gì.
2. **Dựng đồ thị phụ thuộc (Dependency Graph Resolution):** Quét toàn bộ các thư viện mà gói yêu cầu (`Depends:`) và kiểm tra xem hệ thống đã cài chưa, nếu chưa thì thêm vào danh sách tải.
3. **Tải tệp `.deb`:** Tải đồng thời các gói cần thiết từ repository về lưu tạm tại thư mục `/var/cache/apt/archives/`.
4. **Xác thực chữ ký:** Đối chiếu mã băm SHA256 của các tệp vừa tải với tệp chỉ mục đã được xác thực qua GPG key.
5. **Ủy quyền cho `dpkg` thực thi:**
   - Chạy kịch bản `preinst` (chuẩn bị môi trường trước khi cài).
   - Giải nén tệp `data.tar.xz`, chép các binary vào `/usr/bin/`, thư viện vào `/usr/lib/`, file cấu hình vào `/etc/`.
   - Chạy kịch bản `postinst` (cấu hình dịch vụ, tạo user hệ thống, cập nhật liên kết thư viện động bằng `ldconfig`).
   - Cập nhật bản ghi trạng thái vào cơ sở dữ liệu `/var/lib/dpkg/status`.

- **Các cờ tham số quan trọng:**
  - `-y` (*Yes*): Tự động trả lời `Yes` cho mọi câu hỏi xác nhận, dùng trong kịch bản tự động hóa Bash Script.
  - `--reinstall`: Cài đặt đè lại gói phần mềm nếu các file thực thi bị hỏng hoặc vô tình bị xóa mất.
  - `--no-install-recommends`: Chỉ cài đặt các gói phụ thuộc bắt buộc (`Depends`), bỏ qua các gói phụ trợ khuyến nghị (`Recommends`), giúp tiết kiệm tối đa dung lượng ổ cứng.

---

### 5.3. Gỡ bỏ phần mềm: `apt remove` vs `apt purge`
- **`sudo apt remove <package>`:**
  - Gỡ bỏ các tệp nhị phân thực thi (`/usr/bin/`) và tài liệu hướng dẫn khỏi hệ thống.
  - **Điểm mấu chốt:** **Cố tình giữ lại toàn bộ các tệp cấu hình** của phần mềm trong thư mục `/etc/` để nếu người dùng cài lại phần mềm trong tương lai, mọi thiết lập tùy biến cũ vẫn còn nguyên.
- **`sudo apt purge <package>`:**
  - Gỡ bỏ triệt để và toàn diện: Xóa sạch toàn bộ tệp nhị phân, **đồng thời xóa sạch mọi tệp cấu hình trong `/etc/`** và dữ liệu liên quan. Thường dùng khi muốn xóa trắng một dịch vụ bị lỗi cấu hình để cài lại từ đầu.

---

### 5.4. Các lệnh bảo trì dọn dẹp: `apt autoremove` và `apt clean`
- **`sudo apt autoremove`:**
  - Quét tìm và gỡ bỏ các gói phụ thuộc mồ côi (*orphaned dependencies*).
  - *Ví dụ:* Trước đây cài phần mềm A, hệ thống tự động kéo thêm thư viện B về. Sau đó người dùng gỡ phần mềm A, nhưng thư viện B vẫn nằm lại trong máy mà không còn bất kỳ phần mềm nào khác cần tới nó. Lệnh `autoremove` sẽ phát hiện và dọn dẹp sạch thư viện B này.
- **`sudo apt clean`:**
  - Xóa sạch toàn bộ các tệp `.deb` đã tải về nằm trong thư mục bộ đệm `/var/cache/apt/archives/`.
  - Giúp giải phóng ngay lập tức hàng gigabyte dung lượng ổ cứng mà hoàn toàn không ảnh hưởng tới các phần mềm đang hoạt động.

---

### 5.5. Thao tác gói nhị phân cấp thấp với `dpkg`
- **`dpkg -l` (Liệt kê các gói đã cài đặt):**
  - Đọc trực tiếp cơ sở dữ liệu `/var/lib/dpkg/status`.
  - **Giải mã 2 ký tự trạng thái ở đầu mỗi dòng:**
    - Ký tự thứ nhất (Trạng thái mong muốn - Desired): `u` (Unknown), `i` (Install - muốn cài), `r` (Remove - muốn gỡ), `p` (Purge - muốn xóa sạch).
    - Ký tự thứ hai (Trạng thái thực tế - Current Status): `i` (Installed - đã cài đặt hoàn chỉnh), `c` (Config-files - đã xóa binary bằng `remove` nhưng vẫn còn file cấu hình), `n` (Not-installed).
    - Cặp ký tự chuẩn **`ii`** biểu thị gói phần mềm đang được cài đặt hoàn hảo và hoạt động bình thường.
- **`sudo dpkg -i package.deb`:**
  - Lệnh cài đặt trực tiếp một file `.deb` tải về thủ công từ bên ngoài.
  - **Cách xử lý lỗi vỡ phụ thuộc kinh điển:**
    - Nếu `dpkg -i` báo lỗi thiếu thư viện phụ thuộc và không thể tiếp tục, hãy chạy ngay câu lệnh cứu hộ:
      ```bash
      sudo apt install -f
      # (hoặc cú pháp tương đương: sudo apt --fix-broken install)
      ```
    - Lệnh này sẽ yêu cầu `apt` quét các gói đang bị dở dang (*broken dependencies*), tự động kết nối kho lưu trữ chính thức để tải các thư viện còn thiếu về và cấu hình hoàn tất việc cài đặt.
- **`dpkg -L <package>`:**
  - Liệt kê toàn bộ danh sách đường dẫn các file và thư mục mà gói phần mềm đó đã bung ra trên ổ cứng (cực kỳ hữu ích để tìm xem file cấu hình mẫu hoặc binary của gói nằm ở đâu).
- **`dpkg -S <đường_dẫn_file>`:**
  - Truy vấn ngược: Cho biết một file cụ thể trên hệ thống (ví dụ `/etc/nginx/nginx.conf` hoặc `/bin/ls`) thuộc về gói phần mềm nào quản lý.

---

## 6. Mục 18: Bí danh dòng lệnh (Alias)

### 6.1. Bản chất hoạt động của Alias trong Bash Shell
- Bí danh là cơ chế thay thế chuỗi ký tự ở tầng phân tích từ vựng (*Lexer / Tokenizer*) của trình thông dịch Bash.
- Trước khi thực thi một câu lệnh, Shell luôn kiểm tra từ đầu tiên nhập vào xem có nằm trong bảng bí danh đã lưu trong bộ nhớ hay không. Nếu trùng khớp, từ đó được thay thế bằng chuỗi lệnh mở rộng tương ứng trước khi phân tích cú pháp tiếp.

---

### 6.2. Cấu hình vĩnh viễn trong `~/.bashrc` và lệnh `source`
- **Bí danh tạm thời:**
  ```bash
  alias c='clear'
  ```
  Chỉ tồn tại trong bộ nhớ RAM của phiên làm việc hiện tại. Khi tắt Terminal, bí danh này tự động biến mất.
- **Bí danh vĩnh viễn:**
  - Được lưu vào tệp kịch bản khởi tạo cá nhân `~/.bashrc` nằm trong thư mục home của người dùng.
  - Tệp này được Bash tự động đọc và thực thi mỗi khi người dùng mở một cửa sổ dòng lệnh tương tác mới (*interactive non-login shell*).
- **Lệnh `source ~/.bashrc` (hoặc `. ~/.bashrc`):**
  - **Bản chất:** Lệnh `source` yêu cầu tiến trình Shell hiện tại đọc và thực thi trực tiếp các câu lệnh trong tệp `~/.bashrc` ngay tại phiên làm việc này mà không sinh ra tiến trình con (*subshell*). Nhờ đó, các bí danh mới thêm vào sẽ có hiệu lực tức thì mà không cần phải đăng xuất hay mở lại cửa sổ Terminal.

---

### 6.3. Mổ xẻ chi tiết lệnh mẫu `alias ll='ls -alF'`
Lệnh này gán chuỗi `ls -alF` cho bí danh ngắn gọn `ll`:
- **`-a` (`--all`):** Hiển thị toàn bộ tệp tin và thư mục, bao gồm cả các tệp ẩn bắt đầu bằng dấu chấm (`.`).
- **`-l` (`--long`):** Định dạng hiển thị danh sách chi tiết nhiều cột: Chuỗi quyền (`drwxr-xr-x`), số liên kết cứng (*hard links*), người sở hữu, nhóm sở hữu, kích thước tệp (bytes), và thời gian chỉnh sửa lần cuối.
- **`-F` (`--classify`):** Tự động thêm một ký tự đánh dấu trực quan vào cuối tên tệp để nhận diện loại đối tượng mà không cần nhìn vào chuỗi quyền:
  - Dấu gạch chéo `/` : Thư mục (directory).
  - Dấu hoa thị `*` : Tệp có quyền thực thi (executable binary hoặc script).
  - Ký tự `@` : Liên kết mềm (symbolic link).
  - Dấu bằng `=` : Socket giao tiếp mạng nội bộ (UNIX domain socket).
  - Dấu gạch đứng `|` : Đường ống đặt tên (FIFO / Named Pipe).

---

### 6.4. Quản trị, hủy bỏ (`unalias`) và thủ thuật bypass Alias
- `alias`: Gõ lệnh không kèm tham số để in ra toàn bộ danh sách các bí danh đang có hiệu lực trong phiên.
- `unalias <tên_alias>`: Hủy bỏ một bí danh khỏi phiên làm việc hiện tại (ví dụ `unalias ll`).
- **Thủ thuật Bypass Alias (Gọi lệnh gốc nguyên bản):**
  - Khi đã gán `alias ls='ls --color=auto'`, nếu trong một trường hợp nào đó muốn chạy lệnh `ls` nguyên bản của hệ thống mà không qua bí danh, chỉ cần thêm dấu gạch chéo ngược `\` ở đầu:
    ```bash
    \ls
    ```
  - Khi phát hiện ký tự `\`, Bash Lexer sẽ bỏ qua việc tra cứu bảng alias và gọi trực tiếp chương trình thực thi tương ứng trong biến môi trường `$PATH`.
