# Báo cáo Linux cơ bản: từ khái niệm đến thực hành

*Tài liệu tìm hiểu hệ điều hành Linux, dòng lệnh, quản trị hệ thống, mạng và tự động hóa bằng shell script.*

## Phần 1: Giới thiệu tổng quan về Linux

### 1. Linux là gì?

#### 1.1. Khái niệm hệ điều hành mã nguồn mở

Linux là một họ hệ điều hành giống Unix (Unix-like), được xây dựng xung quanh **Linux kernel** (nhân Linux). Điểm cốt lõi của Linux là **mã nguồn mở (open source)**: toàn bộ mã nguồn được công khai, bất kỳ ai cũng có quyền xem, sửa đổi và phân phối lại theo các điều khoản của giấy phép, phổ biến nhất là **GNU GPL v2** (đối với kernel).

Bốn quyền tự do cơ bản của phần mềm tự do (theo Free Software Foundation):

- **Quyền 0:** chạy chương trình cho bất kỳ mục đích nào.
- **Quyền 1:** nghiên cứu cách chương trình hoạt động và sửa đổi nó (cần có mã nguồn).
- **Quyền 2:** phân phối lại các bản sao.
- **Quyền 3:** phân phối các bản đã sửa đổi của mình cho người khác.

Nhờ mô hình này, Linux được phát triển bởi một cộng đồng toàn cầu gồm hàng nghìn lập trình viên cá nhân và các công ty lớn như Red Hat, Intel, Google, IBM, Microsoft, Huawei... cùng đóng góp.

#### 1.2. Lịch sử phát triển của Linux

| Mốc thời gian | Sự kiện |
| --- | --- |
| 1969 | Ken Thompson và Dennis Ritchie tại Bell Labs phát triển Unix. |
| 1983 | Richard Stallman khởi xướng dự án GNU với mục tiêu xây dựng một hệ điều hành tự do hoàn chỉnh. |
| 1987 | Andrew Tanenbaum phát hành MINIX, hệ điều hành Unix-like phục vụ giảng dạy. |
| 25/8/1991 | **Linus Torvalds**, sinh viên Đại học Helsinki (Phần Lan), thông báo trên nhóm tin comp.os.minix rằng mình đang viết một hệ điều hành miễn phí "chỉ để làm vui". |
| 17/9/1991 | Phát hành phiên bản Linux 0.01 đầu tiên. |
| 1992 | Linux chuyển sang giấy phép GNU GPL, kết hợp với các công cụ của dự án GNU tạo nên hệ điều hành hoàn chỉnh (thường gọi là GNU/Linux). |
| 1993 – 1996 | Ra đời Slackware, Debian (1993), Red Hat (1994); Linux 1.0 (1994) và 2.0 (1996). |
| 2004 | Ubuntu phát hành, đưa Linux đến gần hơn với người dùng phổ thông. |
| 2007 | Android (xây dựng trên Linux kernel) ra mắt, mở ra làn sóng Linux trên thiết bị di động. |
| 2011 | Linux 3.0; Linux trở thành nền tảng của phần lớn siêu máy tính. |
| 2015 – nay | Linux 4.x, 5.x, 6.x; thống trị hạ tầng cloud, container (Docker, Kubernetes). |

Tên "Linux" là sự ghép giữa tên **Linus** và **Unix**. Linh vật chính thức của Linux là chú chim cánh cụt **Tux**.

#### 1.3. Phân biệt Linux kernel và các bản phân phối (distribution)

Đây là điểm hay bị nhầm lẫn: **Linux thực chất chỉ là kernel**, tức thành phần lõi giao tiếp trực tiếp với phần cứng. Một hệ điều hành dùng được hằng ngày cần thêm nhiều thành phần khác. Gói đầy đủ đó gọi là **bản phân phối (distribution, distro)**.

Một distro thường gồm:

- **Linux kernel**: quản lý CPU, bộ nhớ, thiết bị, tiến trình, hệ thống file.
- **Các công cụ GNU**: bash, coreutils (ls, cp, mv...), gcc, glibc.
- **Trình quản lý gói**: apt, dnf, pacman...
- **Hệ thống khởi tạo (init)**: phổ biến nhất là systemd.
- **Môi trường desktop (tùy chọn)**: GNOME, KDE Plasma, Xfce.
- **Phần mềm ứng dụng** và cấu hình mặc định do nhà phát hành lựa chọn.

Các họ distro phổ biến:

| Họ | Distro tiêu biểu | Trình quản lý gói | Đặc điểm |
| --- | --- | --- | --- |
| Debian | Debian, Ubuntu, Linux Mint, Kali Linux | `apt`, `dpkg` (file `.deb`) | Ổn định, kho phần mềm rất lớn, dễ dùng. Ubuntu phổ biến nhất cho người mới. |
| Red Hat | RHEL, CentOS Stream, Fedora, Rocky Linux, AlmaLinux | `dnf`/`yum`, `rpm` (file `.rpm`) | Hướng doanh nghiệp, hỗ trợ dài hạn, phổ biến trên server. |
| Arch | Arch Linux, Manjaro | `pacman` | Rolling release, tối giản, người dùng tự cấu hình. |
| SUSE | openSUSE, SLES | `zypper` | Công cụ quản trị YaST, mạnh ở thị trường châu Âu. |
| Alpine | Alpine Linux | `apk` | Rất nhẹ, hay dùng làm image container. |

**Lưu ý về CentOS:** CentOS Linux (bản clone của RHEL) đã kết thúc vòng đời, được thay bằng CentOS Stream. Các hệ thống cần sự ổn định tương tự RHEL hiện thường chuyển sang Rocky Linux hoặc AlmaLinux.

Ví dụ minh họa: kernel giống như "động cơ", còn distro là "chiếc xe hoàn chỉnh" gồm động cơ, khung gầm, nội thất. Cùng một động cơ nhưng mỗi hãng xe (distro) lắp ráp theo phong cách khác nhau.

### 2. Tại sao nên học Linux?

#### 2.1. Ứng dụng rộng rãi

- **Server và web hosting:** phần lớn máy chủ web trên Internet chạy Linux (Apache, Nginx, các stack LAMP/LEMP).
- **Cloud computing:** AWS, Google Cloud, Azure, cũng như các nền tảng private cloud như OpenStack đều dựa trên Linux; hầu hết máy ảo trên cloud là Linux. Công nghệ ảo hóa KVM nằm ngay trong Linux kernel.
- **DevOps và container:** Docker, Kubernetes, Ansible, Terraform, Jenkins, GitLab CI đều vận hành chủ yếu trên Linux. Container về bản chất dựa trên các tính năng của kernel Linux (namespaces, cgroups).
- **AI và khoa học dữ liệu:** các máy chủ GPU huấn luyện mô hình (CUDA, PyTorch, TensorFlow) gần như mặc định chạy Linux.
- **Lập trình hệ thống và nhúng:** driver, kernel module, firmware, IoT, router, thiết bị mạng, ô tô.
- **Siêu máy tính:** 100% các hệ thống trong danh sách TOP500 chạy Linux.
- **Thiết bị di động:** Android dùng Linux kernel.

#### 2.2. Sự khác biệt giữa Linux và Windows/macOS

| Tiêu chí | Linux | Windows | macOS |
| --- | --- | --- | --- |
| Giấy phép | Mã nguồn mở, miễn phí | Mã nguồn đóng, trả phí | Mã nguồn đóng (nhân Darwin có phần mở), gắn với phần cứng Apple |
| Nguồn gốc | Unix-like | Windows NT | Unix (BSD/Darwin) |
| Giao diện chính | Terminal + nhiều desktop để lựa chọn | Giao diện đồ họa là chủ đạo | Giao diện đồ họa Aqua, có Terminal |
| Hệ thống file | ext4, xfs, btrfs... | NTFS, ReFS | APFS |
| Phân cách đường dẫn | `/` | `\` | `/` |
| Phân biệt hoa/thường | Có (`File` khác `file`) | Không | Mặc định không |
| Quyền truy cập | Mô hình user/group/other rất chặt | ACL phức tạp | Giống Unix |
| Quản lý phần mềm | Trình quản lý gói tập trung | Tải file cài đặt (.exe/.msi), winget | App Store, Homebrew |
| Tùy biến | Rất cao, có thể thay đổi cả kernel | Hạn chế hơn | Hạn chế |
| Vai trò phổ biến | Server, cloud, nhúng | Desktop doanh nghiệp, game | Sáng tạo nội dung, lập trình viên |

Một số khác biệt cần nhớ khi chuyển từ Windows sang Linux: không có ổ đĩa `C:`, `D:` mà mọi thứ nằm trong một cây thư mục duy nhất bắt đầu từ `/`; mọi thứ đều được coi là file (kể cả thiết bị); đa số cấu hình được lưu bằng file văn bản thuần.

#### 2.3. Ưu điểm của Linux

- **Bảo mật:** mô hình phân quyền chặt chẽ, người dùng thường không có quyền root; mã nguồn công khai nên lỗ hổng được cộng đồng phát hiện và vá nhanh; ít bị mã độc nhắm tới trên desktop; có các cơ chế bổ sung như SELinux, AppArmor, firewall tích hợp.
- **Miễn phí:** không tốn chi phí bản quyền hệ điều hành, đặc biệt có lợi khi triển khai hàng trăm, hàng nghìn máy chủ.
- **Tùy biến:** chọn distro, desktop, kernel, dịch vụ cần chạy; có thể cắt giảm hệ thống xuống mức tối giản.
- **Hiệu suất cao và nhẹ:** chạy tốt trên phần cứng cũ, tiêu tốn ít tài nguyên, có thể chạy nhiều tháng không cần khởi động lại.
- **Ổn định:** thích hợp cho các hệ thống chạy liên tục 24/7.
- **Công cụ cho lập trình viên:** sẵn compiler, shell mạnh, công cụ xử lý văn bản, quản lý gói; hỗ trợ tự động hóa rất tốt.
- **Cộng đồng lớn:** tài liệu phong phú, diễn đàn, man page, wiki của các distro.

**Nhược điểm cần thừa nhận:** đường cong học tập dốc với người mới, một số phần mềm thương mại (Adobe, nhiều game) không hỗ trợ chính thức, hỗ trợ driver phần cứng đôi khi chậm hơn Windows.

### 3. Kiến trúc hệ thống Linux

#### 3.1. Các tầng: Kernel, Shell, Application

Kiến trúc Linux có thể hình dung theo các lớp từ dưới lên:

```
+---------------------------------------------+
|  Application layer (trình duyệt, Nginx,     |
|  MySQL, trình soạn thảo, game...)           |
+---------------------------------------------+
|  Shell / System libraries (bash, glibc)     |
+---------------------------------------------+
|  Kernel (quản lý tiến trình, bộ nhớ,        |
|  file system, thiết bị, mạng)               |
+---------------------------------------------+
|  Phần cứng (CPU, RAM, đĩa, card mạng)       |
+---------------------------------------------+
```

- **Kernel:** lõi của hệ điều hành, chạy ở chế độ đặc quyền (kernel space). Các chức năng chính: quản lý tiến trình và lập lịch CPU, quản lý bộ nhớ (bộ nhớ ảo, swap), quản lý hệ thống file, quản lý thiết bị thông qua driver, ngăn xếp mạng (TCP/IP), bảo mật và phân quyền. Linux dùng kiến trúc **monolithic kernel** có hỗ trợ nạp module động (`lsmod`, `modprobe`).
- **Shell:** chương trình đọc lệnh người dùng nhập, diễn giải và yêu cầu kernel thực thi thông qua **system call**. Các shell phổ biến: bash, zsh, sh, fish.
- **Application layer (user space):** gồm các chương trình người dùng và dịch vụ. Chúng không truy cập phần cứng trực tiếp mà gọi kernel qua system call (ví dụ `open`, `read`, `write`, `fork`, `execve`), thường thông qua thư viện C (glibc).

Sự tách biệt **kernel space** và **user space** giúp một chương trình lỗi không thể làm sập cả hệ thống.

#### 3.2. Quá trình khởi động (boot process) cơ bản

Các bước khởi động của một máy Linux điển hình:

1. **BIOS/UEFI:** firmware chạy tự kiểm tra phần cứng (POST), sau đó tìm thiết bị khởi động. UEFI đọc phân vùng ESP, còn BIOS đọc MBR của đĩa.
2. **Bootloader (GRUB2):** được nạp từ đĩa, hiển thị menu chọn hệ điều hành/kernel, nạp **kernel** và **initramfs** vào bộ nhớ, truyền tham số khởi động.
3. **Kernel khởi tạo:** giải nén, khởi tạo CPU, bộ nhớ, driver cần thiết. **initramfs** là hệ thống file tạm trong RAM chứa driver giúp kernel mount được root filesystem thật.
4. **Mount root filesystem** và chạy tiến trình đầu tiên (PID 1).
5. **init/systemd (PID 1):** khởi chạy các dịch vụ theo **target** (tương đương runlevel): ví dụ `multi-user.target` (chế độ dòng lệnh nhiều người dùng), `graphical.target` (có giao diện đồ họa).
6. **Màn hình đăng nhập:** login console hoặc display manager (GDM, LightDM); sau đăng nhập, shell hoặc desktop được khởi chạy.

Các lệnh liên quan hữu ích: `dmesg` (xem log kernel lúc khởi động), `systemd-analyze` (đo thời gian boot), `systemctl get-default` (xem target mặc định).

#### 3.3. Các thư mục hệ thống chính

Linux tuân theo chuẩn **FHS (Filesystem Hierarchy Standard)**: mọi thứ nằm trong một cây thư mục duy nhất, gốc là `/` (root directory).

| Thư mục | Ý nghĩa |
| --- | --- |
| `/` | Thư mục gốc, điểm bắt đầu của toàn bộ cây thư mục. |
| `/bin` | Các lệnh thiết yếu cho mọi người dùng (`ls`, `cp`, `cat`...). Trên nhiều distro hiện đại là liên kết tới `/usr/bin`. |
| `/sbin` | Các lệnh quản trị hệ thống (`fdisk`, `reboot`, `ip`...). |
| `/boot` | File khởi động: kernel (`vmlinuz`), initramfs, cấu hình GRUB. |
| `/dev` | File thiết bị (`/dev/sda`, `/dev/null`, `/dev/tty`). |
| `/etc` | Các file cấu hình hệ thống và dịch vụ (`/etc/passwd`, `/etc/ssh/sshd_config`). |
| `/home` | Thư mục cá nhân của người dùng thường (`/home/an`). |
| `/root` | Thư mục home của tài khoản root. |
| `/lib`, `/lib64` | Thư viện dùng chung cần cho `/bin` và `/sbin`. |
| `/media`, `/mnt` | Điểm mount cho USB, ổ đĩa ngoài, mount tạm thời. |
| `/opt` | Phần mềm bên thứ ba cài thêm. |
| `/proc` | Hệ thống file ảo, thể hiện thông tin tiến trình và kernel (`/proc/cpuinfo`, `/proc/meminfo`). |
| `/sys` | File system ảo, thông tin thiết bị và driver. |
| `/run` | Dữ liệu trạng thái lúc đang chạy (PID file, socket), mất khi khởi động lại. |
| `/tmp` | File tạm, thường bị xóa khi khởi động lại. |
| `/usr` | Chương trình và thư viện của người dùng (`/usr/bin`, `/usr/lib`, `/usr/share`). |
| `/var` | Dữ liệu biến đổi: log (`/var/log`), cache, spool, cơ sở dữ liệu web. |

Ghi nhớ nhanh: **`/etc` = cấu hình, `/var/log` = nhật ký, `/home` = dữ liệu người dùng, `/usr` = phần mềm, `/proc` & `/sys` = thông tin hệ thống ảo.**

## Phần 2: Làm quen với Terminal và Shell

### 4. Terminal và Shell là gì?

#### 4.1. Terminal

**Terminal** (hay terminal emulator) là ứng dụng cung cấp cửa sổ để người dùng gõ lệnh và xem kết quả dưới dạng văn bản, gọi là giao diện dòng lệnh (**CLI - Command Line Interface**). Tên gọi bắt nguồn từ các thiết bị đầu cuối vật lý thời xưa kết nối với máy tính lớn. Ví dụ: GNOME Terminal, Konsole, xterm, Alacritty, hoặc Windows Terminal/PuTTY khi kết nối từ xa.

Ưu điểm của CLI so với GUI: nhanh hơn khi đã quen, dễ tự động hóa bằng script, tiêu tốn rất ít tài nguyên, thao tác được trên server từ xa không có giao diện đồ họa.

#### 4.2. Shell

**Shell** là chương trình chạy bên trong terminal, đóng vai trò **trung gian giữa người dùng và kernel**: nhận lệnh, phân tích cú pháp, tìm chương trình tương ứng và chạy nó. Shell còn là một ngôn ngữ lập trình (biến, điều kiện, vòng lặp).

| Shell | Đặc điểm |
| --- | --- |
| `sh` | Bourne shell, chuẩn POSIX, nhẹ, hay dùng trong script tương thích. |
| `bash` | Bourne Again Shell, mặc định trên đa số distro, mạnh và phổ biến nhất. |
| `zsh` | Tương thích bash, gợi ý thông minh, nhiều plugin (Oh My Zsh), mặc định trên macOS. |
| `fish` | Thân thiện, tự gợi ý lệnh, cú pháp khác bash. |
| `dash` | Rất nhẹ, là `/bin/sh` mặc định trên Debian/Ubuntu. |

Các lệnh liên quan: `echo $SHELL` (shell mặc định), `cat /etc/shells` (danh sách shell hợp lệ), `chsh -s /bin/zsh` (đổi shell mặc định).

#### 4.3. Mở terminal và chạy lệnh cơ bản

- Trên desktop Ubuntu: nhấn **Ctrl + Alt + T** hoặc tìm "Terminal" trong menu ứng dụng.
- Trên server: đăng nhập qua console hoặc SSH, shell xuất hiện ngay.

Cấu trúc dấu nhắc lệnh (prompt):

```bash
an@ubuntu:~$
```

- `an`: tên người dùng; `ubuntu`: tên máy (hostname); `~`: thư mục hiện tại (home); `$`: người dùng thường (còn `#` nghĩa là đang là root).

Cấu trúc chung của một lệnh: `lệnh [tùy chọn] [đối số]`

```bash
ls -l /etc          # lệnh: ls, tùy chọn: -l, đối số: /etc
echo "Xin chao Linux"
date
whoami
```

Xem hướng dẫn: `man ls` (trang hướng dẫn đầy đủ), `ls --help` (tóm tắt), `whatis ls` (mô tả một dòng).

### 5. Lệnh cơ bản trong Linux

#### 5.1. Các lệnh thường dùng

| Lệnh | Chức năng | Ví dụ |
| --- | --- | --- |
| `pwd` | In ra thư mục làm việc hiện tại (print working directory). | `pwd` → `/home/an` |
| `ls` | Liệt kê file/thư mục. Tùy chọn: `-l` (chi tiết), `-a` (hiện file ẩn), `-h` (kích thước dễ đọc), `-t` (sắp xếp theo thời gian). | `ls -lah` |
| `cd` | Chuyển thư mục. `cd` (không đối số) về home, `cd -` quay lại thư mục trước. | `cd /var/log` |
| `clear` | Xóa màn hình terminal (tương đương Ctrl + L). | `clear` |
| `history` | Hiển thị lịch sử lệnh đã gõ (lưu ở `~/.bash_history`). | \`history |

Một số mẹo với history: `!!` chạy lại lệnh vừa rồi, `!n` chạy lệnh số n trong lịch sử, `Ctrl + R` tìm kiếm ngược trong lịch sử.

```bash
pwd
ls -la
cd /etc
cd ..
history | grep ssh
```

#### 5.2. Phím tắt thường dùng

| Phím tắt | Tác dụng |
| --- | --- |
| `Tab` | Tự động hoàn thành tên lệnh, file, thư mục; nhấn hai lần để liệt kê gợi ý. |
| `Ctrl + C` | Ngắt (gửi tín hiệu SIGINT) tiến trình đang chạy ở foreground. |
| `Ctrl + D` | Gửi ký tự kết thúc file (EOF); khi dòng lệnh trống sẽ thoát shell/đăng xuất. |
| `Ctrl + L` | Xóa màn hình. |
| `Ctrl + A` / `Ctrl + E` | Nhảy về đầu / cuối dòng lệnh. |
| `Ctrl + U` / `Ctrl + K` | Xóa từ con trỏ về đầu / về cuối dòng. |
| `Ctrl + R` | Tìm kiếm ngược trong lịch sử lệnh. |
| `Ctrl + Z` | Tạm dừng tiến trình, đưa xuống background (dùng với `bg`, `fg`). |
| `↑` / `↓` | Duyệt lại các lệnh đã gõ. |

### 6. Hiểu cấu trúc đường dẫn

#### 6.1. Đường dẫn tuyệt đối và tương đối

- **Đường dẫn tuyệt đối (absolute path):** bắt đầu từ thư mục gốc `/`, luôn chỉ đến cùng một vị trí bất kể đang đứng ở đâu. Ví dụ: `/home/an/docs/baocao.txt`.
- **Đường dẫn tương đối (relative path):** tính từ thư mục hiện tại, không bắt đầu bằng `/`. Ví dụ: nếu đang ở `/home/an` thì `docs/baocao.txt` chính là file trên.

```bash
cd /home/an            # tuyệt đối
cd docs                # tương đối, đi vào /home/an/docs
cat baocao.txt         # tương đối
cat /home/an/docs/baocao.txt   # tuyệt đối, chạy ở đâu cũng đúng
```

Khi viết script hoặc cấu hình dịch vụ, nên dùng đường dẫn tuyệt đối để tránh lỗi do thư mục làm việc khác nhau.

#### 6.2. Ý nghĩa của `~`, `.`, `..`

| Ký hiệu | Ý nghĩa | Ví dụ |
| --- | --- | --- |
| `~` | Thư mục home của người dùng hiện tại. | `cd ~/Downloads` |
| `.` | Thư mục hiện tại. | `./script.sh` (chạy script trong thư mục hiện tại) |
| `..` | Thư mục cha (cấp trên một bậc). | `cd ../..` (lên hai cấp) |
| `-` | (với `cd`) thư mục trước đó. | `cd -` |

Ví dụ: đang ở `/home/an/docs`, `cp ../anh.png .` nghĩa là sao chép file `anh.png` ở `/home/an` vào thư mục hiện tại (`/home/an/docs`).

## Phần 3: Làm việc với file và thư mục

### 7. Tạo, xem, xóa và di chuyển file

#### 7.1. Tạo và xem nội dung file

| Lệnh | Chức năng | Ví dụ |
| --- | --- | --- |
| `touch` | Tạo file rỗng, hoặc cập nhật thời gian sửa đổi nếu file đã có. | `touch a.txt b.txt` |
| `cat` | Hiển thị toàn bộ nội dung file; cũng dùng để nối file hoặc tạo file nhỏ. | `cat a.txt`, `cat a.txt b.txt > c.txt` |
| `less` | Xem file dài theo trang, cuộn lên/xuống, tìm kiếm bằng `/từ_khóa`, thoát bằng `q`. | `less /var/log/syslog` |
| `head` | Xem N dòng đầu (mặc định 10). | `head -n 5 a.txt` |
| `tail` | Xem N dòng cuối; `-f` theo dõi file liên tục khi có dòng mới (rất hữu ích để xem log). | `tail -f /var/log/syslog` |

```bash
touch ghichu.txt
echo "Dong 1" > ghichu.txt     # ghi đè
echo "Dong 2" >> ghichu.txt    # ghi nối thêm
cat ghichu.txt
head -n 1 ghichu.txt
tail -n 1 ghichu.txt
```

#### 7.2. Sao chép, di chuyển, xóa, tạo thư mục

| Lệnh | Chức năng | Tùy chọn hay dùng |
| --- | --- | --- |
| `cp` | Sao chép file/thư mục. | `-r` (thư mục, đệ quy), `-i` (hỏi trước khi ghi đè), `-v` (hiển thị chi tiết), `-p` (giữ quyền, thời gian) |
| `mv` | Di chuyển hoặc **đổi tên** file/thư mục. | `-i`, `-v` |
| `rm` | Xóa file. **Không có thùng rác**, xóa là mất. | `-r` (xóa thư mục), `-f` (không hỏi), `-i` (hỏi từng file) |
| `mkdir` | Tạo thư mục. | `-p` (tạo cả chuỗi thư mục cha) |
| `rmdir` | Xóa thư mục **rỗng**. | `-p` |

```bash
mkdir -p project/src/utils
cp a.txt project/
cp -r project project_backup
mv a.txt ghichu_moi.txt          # đổi tên
mv ghichu_moi.txt project/src/   # di chuyển
rm project/src/ghichu_moi.txt
rmdir project/src/utils
rm -r project_backup
```

**Cảnh báo an toàn:** lệnh `rm -rf /` hoặc `rm -rf *` đặt sai chỗ có thể xóa sạch dữ liệu. Nên kiểm tra bằng `pwd` và `ls` trước khi xóa; dùng `rm -i` khi chưa chắc chắn; với biến trong script, luôn kiểm tra biến không rỗng trước khi `rm -rf "$DIR"/*`.

### 8. Sao chép và nén file

#### 8.1. Đóng gói và nén

Cần phân biệt hai khái niệm: **đóng gói (archive)** gộp nhiều file thành một file duy nhất (như `tar`), còn **nén (compress)** làm giảm dung lượng (như `gzip`). Hai bước này thường kết hợp: file `.tar.gz` (hay `.tgz`).

| Lệnh | Chức năng |
| --- | --- |
| `tar` | Đóng gói/giải gói nhiều file; kết hợp nén bằng gzip, bzip2, xz. |
| `gzip` / `gunzip` | Nén/giải nén một file thành `.gz` (file gốc bị thay thế). |
| `zip` / `unzip` | Nén/giải nén định dạng `.zip`, tương thích tốt với Windows. |
| `scp` | Sao chép file giữa các máy qua SSH (xem thêm mục 23). |

Các tùy chọn thường dùng của `tar`: `-c` (create), `-x` (extract), `-v` (verbose), `-f` (chỉ định tên file), `-z` (gzip), `-j` (bzip2), `-J` (xz), `-t` (liệt kê nội dung), `-C` (giải nén vào thư mục khác).

```bash
# Nén thư mục thành tar.gz
tar -czvf backup.tar.gz /home/an/docs

# Xem nội dung mà không giải nén
tar -tzvf backup.tar.gz

# Giải nén
tar -xzvf backup.tar.gz
tar -xzvf backup.tar.gz -C /tmp/restore

# gzip
gzip data.log          # tạo data.log.gz
gunzip data.log.gz

# zip
zip -r docs.zip docs/
unzip docs.zip -d /tmp/

# scp: gửi file đến máy từ xa
scp backup.tar.gz user@192.168.1.10:/home/user/
```

#### 8.2. Khái niệm stream: `stdin`, `stdout`, `stderr`

Mỗi tiến trình trong Linux mở sẵn ba luồng dữ liệu chuẩn, mỗi luồng gắn với một **file descriptor**:

| Luồng | File descriptor | Ý nghĩa | Mặc định |
| --- | --- | --- | --- |
| `stdin` | 0 | Đầu vào chuẩn | Bàn phím |
| `stdout` | 1 | Đầu ra chuẩn (kết quả bình thường) | Màn hình |
| `stderr` | 2 | Đầu ra lỗi (thông báo lỗi) | Màn hình |

Các toán tử **chuyển hướng (redirection)**:

| Toán tử | Ý nghĩa |
| --- | --- |
| `>` | Ghi stdout vào file (ghi đè). |
| `>>` | Ghi nối thêm stdout vào cuối file. |
| `<` | Lấy nội dung file làm stdin. |
| `2>` | Ghi stderr vào file. |
| `2>&1` | Gộp stderr vào cùng nơi với stdout. |
| `&>` | Ghi cả stdout và stderr vào file (bash). |
| `\|` | Pipe: nối stdout của lệnh này vào stdin của lệnh kế tiếp. |

```bash
ls /etc > danhsach.txt             # kết quả vào file
ls /khongtontai 2> loi.txt         # chỉ lỗi vào file
ls /etc /khongtontai > ok.txt 2> loi.txt
find / -name "*.conf" 2>/dev/null  # bỏ qua thông báo lỗi
sort < danhsach.txt
command > all.log 2>&1
```

`/dev/null` là "hố đen": mọi dữ liệu ghi vào đều bị loại bỏ, thường dùng để ẩn đầu ra không cần thiết.

### 9. Tìm kiếm file

#### 9.1. `find`, `locate`, `grep`

| Lệnh | Mục đích | Đặc điểm |
| --- | --- | --- |
| `find` | Tìm **file/thư mục** theo tên, loại, kích thước, thời gian, quyền, chủ sở hữu. | Duyệt trực tiếp hệ thống file, luôn cập nhật nhưng chậm với cây thư mục lớn. |
| `locate` | Tìm file theo tên rất nhanh. | Dùng cơ sở dữ liệu dựng sẵn; cập nhật bằng `sudo updatedb`. Có thể không thấy file mới tạo. |
| `grep` | Tìm **nội dung** (chuỗi, biểu thức chính quy) bên trong file. | Tùy chọn: `-i` (không phân biệt hoa/thường), `-r` (đệ quy), `-n` (số dòng), `-v` (đảo ngược), `-c` (đếm), `-l` (chỉ tên file). |

Các ví dụ với `find`:

```bash
find /home/an -name "*.txt"             # theo tên
find /home/an -iname "report*"          # không phân biệt hoa/thường
find /var/log -type f -size +100M       # file lớn hơn 100 MB
find . -type d -name "backup"           # chỉ thư mục
find . -mtime -7                         # sửa đổi trong 7 ngày qua
find . -name "*.tmp" -delete             # tìm và xóa
find . -name "*.log" -exec ls -lh {} \;   # chạy lệnh trên từng kết quả
```

Ví dụ với `locate` và `grep`:

```bash
locate sshd_config
sudo updatedb

grep "error" /var/log/syslog
grep -in "failed" /var/log/auth.log
grep -rn "TODO" ./src
grep -v "^#" /etc/ssh/sshd_config      # bỏ qua các dòng comment
```

#### 9.2. Kết hợp `grep` với pipe (`|`)

Pipe cho phép xâu chuỗi các lệnh nhỏ thành một công cụ xử lý mạnh, theo triết lý Unix: *mỗi chương trình làm tốt một việc*.

```bash
ps aux | grep nginx                       # tìm tiến trình nginx
history | grep "apt install"               # tìm lại lệnh đã gõ
ls -l /etc | grep "^d"                     # chỉ liệt kê thư mục
cat /var/log/auth.log | grep "Failed" | wc -l   # đếm số lần đăng nhập thất bại
dpkg -l | grep -i python                   # kiểm tra gói python đã cài
journalctl -u ssh | grep -i error | tail -n 20
du -ah /var | sort -rh | head -n 10         # 10 file/thư mục lớn nhất trong /var
```

Các lệnh lọc/biến đổi thường đi kèm pipe: `sort`, `uniq`, `wc`, `cut`, `awk`, `sed`, `tr`, `head`, `tail`.

## Phần 4: Quyền truy cập và người dùng

### 10. Người dùng và nhóm (User & Group)

#### 10.1. Khái niệm

Linux là hệ điều hành **đa người dùng (multi-user)**. Mỗi người dùng có một định danh số **UID**, mỗi nhóm có **GID**. Có ba loại tài khoản chính:

- **root (UID 0):** siêu quản trị, có toàn quyền trên hệ thống.
- **Người dùng hệ thống (UID thường từ 1 đến 999):** dành cho dịch vụ như `www-data`, `sshd`, `mysql`, thường không đăng nhập được.
- **Người dùng thường (UID từ 1000 trở lên):** tài khoản của con người.

Mỗi người dùng thuộc một **nhóm chính (primary group)** và có thể thuộc nhiều **nhóm phụ (supplementary groups)**. Nhóm giúp cấp quyền cho nhiều người cùng lúc (ví dụ nhóm `sudo`, `docker`, `developers`).

#### 10.2. Các lệnh cơ bản

| Lệnh | Chức năng |
| --- | --- |
| `whoami` | Hiển thị tên người dùng hiện tại. |
| `id` | Hiển thị UID, GID và các nhóm của người dùng. |
| `groups` | Liệt kê các nhóm mà người dùng thuộc về. |
| `adduser` | Tạo người dùng mới (Debian/Ubuntu, tương tác, thân thiện: tự tạo thư mục home, hỏi mật khẩu). |
| `useradd` | Lệnh cấp thấp tạo người dùng (có ở mọi distro, cần chỉ rõ nhiều tùy chọn như `-m`, `-s`). |
| `deluser` / `userdel` | Xóa người dùng (`deluser --remove-home` xóa luôn thư mục home). |
| `passwd` | Đặt hoặc đổi mật khẩu. |
| `usermod` | Sửa tài khoản, ví dụ thêm vào nhóm: `usermod -aG sudo an`. |
| `groupadd` / `groupdel` | Tạo / xóa nhóm. |

```bash
whoami
id
# uid=1000(an) gid=1000(an) groups=1000(an),27(sudo),999(docker)

sudo adduser minh                 # tạo user minh
sudo usermod -aG developers minh   # thêm minh vào nhóm developers
sudo passwd minh                   # đổi mật khẩu
sudo deluser --remove-home minh    # xóa user và thư mục home
```

Lưu ý: dùng `-aG` (append) khi thêm nhóm. Nếu quên `-a`, người dùng sẽ bị **gỡ khỏi mọi nhóm phụ khác**.

#### 10.3. `su`, `sudo` và `/etc/passwd`

- **`su` (switch user):** chuyển sang người dùng khác. `su - minh` mở shell đăng nhập đầy đủ của `minh` (cần mật khẩu của `minh`); `su -` chuyển sang root (cần mật khẩu của root).
- **`sudo` (superuser do):** chạy **một lệnh** với quyền root (hoặc người dùng khác), dùng mật khẩu của **chính mình**. Người dùng phải nằm trong nhóm `sudo` (Debian/Ubuntu) hoặc `wheel` (RHEL), hoặc được khai báo trong `/etc/sudoers` (sửa bằng `visudo`).

Các file quản lý tài khoản:

| File | Nội dung |
| --- | --- |
| `/etc/passwd` | Thông tin tài khoản, ai cũng đọc được. |
| `/etc/shadow` | Mật khẩu đã băm (hash), chỉ root đọc được. |
| `/etc/group` | Danh sách nhóm và thành viên. |
| `/etc/sudoers` | Cấu hình quyền sudo. |

Mỗi dòng của `/etc/passwd` có 7 trường phân cách bằng dấu hai chấm:

```
an:x:1000:1000:An Nguyen,,,:/home/an:/bin/bash
1    2  3    4       5          6        7
```

1. Tên đăng nhập. 2. Ký tự `x` nghĩa là mật khẩu nằm trong `/etc/shadow`. 3. UID. 4. GID nhóm chính. 5. Ghi chú (GECOS, họ tên). 6. Thư mục home. 7. Shell đăng nhập (`/usr/sbin/nologin` nghĩa là không cho đăng nhập).

### 11. Phân quyền file

#### 11.1. Đọc hiểu `ls -l`

```bash
ls -l
# -rwxr-xr--  1  an  developers  2048  Oct 9 10:30  script.sh
# drwxr-xr-x  2  an  an          4096  Oct 9 10:00  docs
```

| Vị trí | Giá trị ví dụ | Ý nghĩa |
| --- | --- | --- |
| Ký tự 1 | `-` hoặc `d` hoặc `l` | Loại: `-` file thường, `d` thư mục, `l` liên kết mềm (symlink). |
| Ký tự 2-4 | `rwx` | Quyền của **chủ sở hữu (user/owner)**. |
| Ký tự 5-7 | `r-x` | Quyền của **nhóm sở hữu (group)**. |
| Ký tự 8-10 | `r--` | Quyền của **những người còn lại (other)**. |
| Tiếp theo | `1` | Số hard link. |
| Tiếp theo | `an developers` | Chủ sở hữu và nhóm sở hữu. |
| Tiếp theo | `2048` | Kích thước (byte). |

#### 11.2. Ba quyền `r`, `w`, `x`

| Quyền | Giá trị số | Với **file** | Với **thư mục** |
| --- | --- | --- | --- |
| `r` (read) | 4 | Đọc nội dung | Liệt kê tên file bên trong (`ls`) |
| `w` (write) | 2 | Sửa/ghi nội dung | Tạo, xóa, đổi tên file bên trong |
| `x` (execute) | 1 | Thực thi như chương trình | Được phép `cd` vào và truy cập file bên trong |

Quyền được cộng theo hệ bát phân: `rwx` = 4+2+1 = **7**, `rw-` = **6**, `r-x` = **5**, `r--` = **4**. Vì vậy `755` nghĩa là chủ `rwx`, nhóm `r-x`, người khác `r-x`; còn `644` là chủ `rw-`, còn lại `r--`.

#### 11.3. `chmod`, `chown`, `chgrp`

- **`chmod`** đổi quyền. Có hai cách viết: dạng số (`chmod 755 file`) và dạng ký hiệu (`u`, `g`, `o`, `a` kết hợp `+`, `-`, `=`).
- **`chown`** đổi chủ sở hữu (thường cần sudo): `chown user:group file`.
- **`chgrp`** đổi nhóm sở hữu.

```bash
chmod 755 script.sh          # rwxr-xr-x
chmod 644 note.txt           # rw-r--r--
chmod u+x script.sh          # thêm quyền thực thi cho chủ
chmod g-w,o-rwx secret.txt   # bỏ ghi của nhóm, bỏ hết quyền của người khác
chmod -R 750 /srv/project    # đệ quy cho cả thư mục

sudo chown minh file.txt
sudo chown minh:developers file.txt
sudo chown -R www-data:www-data /var/www/html
sudo chgrp developers file.txt
```

Các quyền đặc biệt (mở rộng): **setuid** (`4xxx`), **setgid** (`2xxx`), **sticky bit** (`1xxx`, ví dụ `/tmp` có `drwxrwxrwt`, ngăn người khác xóa file của nhau). Mặt nạ mặc định khi tạo file do `umask` quy định (thường `022`, nghĩa là file mới `644`, thư mục mới `755`).

### 12. Quyền root và an toàn

#### 12.1. Tại sao không nên chạy mọi thứ bằng root?

- **Sai sót có hậu quả lớn:** một lệnh gõ nhầm (`rm -rf` sai đường dẫn) có thể phá hỏng cả hệ thống, vì root không bị ngăn cản bởi bất kỳ quyền nào.
- **Mở rộng bề mặt tấn công:** nếu một ứng dụng chạy bằng root bị khai thác, kẻ tấn công chiếm toàn quyền máy chủ. Chạy bằng tài khoản hạn chế sẽ giới hạn thiệt hại.
- **Khó truy vết:** nhiều người dùng chung tài khoản root thì không biết ai đã làm gì.
- **Nguyên tắc đặc quyền tối thiểu (least privilege):** chỉ cấp đúng quyền cần thiết cho đúng việc.

Thực hành tốt: dùng tài khoản thường hằng ngày, chỉ nâng quyền bằng `sudo` khi cần; đăng nhập SSH bằng root nên bị tắt (`PermitRootLogin no`); chạy dịch vụ bằng người dùng riêng; xem log sudo tại `/var/log/auth.log` (Debian/Ubuntu) hoặc `/var/log/secure` (RHEL).

#### 12.2. Phân biệt `sudo` và `su`

| Tiêu chí | `sudo` | `su` |
| --- | --- | --- |
| Mật khẩu yêu cầu | Mật khẩu của **chính người gọi** | Mật khẩu của **tài khoản đích** (ví dụ root) |
| Phạm vi | Chạy từng lệnh với quyền cao | Chuyển hẳn sang shell của người dùng khác |
| Kiểm soát | Chi tiết, phân quyền theo lệnh trong `/etc/sudoers` | Gần như toàn quyền khi đã vào |
| Ghi log | Mỗi lệnh sudo được ghi lại | Chỉ ghi lại việc chuyển user |
| Phù hợp | Quản trị hằng ngày, an toàn hơn | Trường hợp đặc biệt, khi cần phiên làm việc đầy đủ |
| Ubuntu mặc định | Dùng được ngay (root bị khóa mật khẩu) | Cần đặt mật khẩu root trước |

```bash
sudo apt update          # chạy một lệnh với quyền root
sudo -i                  # mở shell root tương tác (qua sudo)
sudo -u minh whoami      # chạy lệnh dưới danh nghĩa người dùng minh
su - minh                # chuyển sang minh
su -                     # chuyển sang root (cần mật khẩu root)
```

## Phần 5: Quản lý tiến trình và hệ thống

### 13. Quản lý tiến trình (process)

#### 13.1. Khái niệm

Một **tiến trình (process)** là một chương trình đang chạy, có **PID** (Process ID) riêng và **PPID** (PID của tiến trình cha). Tiến trình đầu tiên khi boot là `systemd` (PID 1). Tiến trình mới được tạo bằng cơ chế `fork` rồi `exec`. Các trạng thái thường gặp: **R** (đang chạy), **S** (ngủ, chờ sự kiện), **D** (chờ I/O, không ngắt được), **T** (bị dừng), **Z** (zombie, đã kết thúc nhưng chưa được tiến trình cha thu dọn).

#### 13.2. Các lệnh xem và điều khiển tiến trình

| Lệnh | Chức năng |
| --- | --- |
| `ps` | Chụp nhanh danh sách tiến trình tại một thời điểm. `ps aux` (toàn bộ, định dạng BSD) hoặc `ps -ef` (định dạng System V). |
| `top` | Theo dõi tiến trình theo thời gian thực: CPU, RAM, load average. Phím `q` thoát, `k` kill, `M` sắp xếp theo RAM, `P` theo CPU. |
| `htop` | Phiên bản `top` thân thiện, có màu sắc, cuộn, tìm kiếm (thường phải cài thêm). |
| `pgrep` | Tìm PID theo tên: `pgrep nginx`. |
| `kill` | Gửi tín hiệu (signal) đến tiến trình theo PID. |
| `killall` | Gửi tín hiệu đến tất cả tiến trình theo **tên**. |
| `pkill` | Gửi tín hiệu theo mẫu tên. |

Các tín hiệu thường gặp:

| Tín hiệu | Số | Ý nghĩa |
| --- | --- | --- |
| `SIGHUP` | 1 | Báo treo, nhiều daemon dùng để đọc lại cấu hình. |
| `SIGINT` | 2 | Ngắt (Ctrl + C). |
| `SIGKILL` | 9 | Buộc dừng ngay, tiến trình không thể bắt hoặc bỏ qua. |
| `SIGTERM` | 15 | Yêu cầu kết thúc nhẹ nhàng (mặc định của `kill`). |
| `SIGSTOP` / `SIGCONT` | 19 / 18 | Tạm dừng / tiếp tục. |

```bash
ps aux | head
ps aux | grep nginx
ps -ef --forest                  # hiển thị dạng cây cha-con
top
sleep 300 &                      # tạo tiến trình thử nghiệm
pgrep sleep                      # tìm PID
kill 12345                       # SIGTERM, dừng nhẹ nhàng
kill -9 12345                    # SIGKILL, dùng khi tiến trình không phản hồi
killall firefox
```

Nên thử `kill` (SIGTERM) trước để tiến trình có cơ hội dọn dẹp, chỉ dùng `kill -9` như biện pháp cuối cùng.

#### 13.3. Foreground và background

- **Foreground:** tiến trình chiếm terminal, phải chờ nó xong mới gõ lệnh khác.
- **Background:** tiến trình chạy ngầm, terminal vẫn dùng được.

| Thao tác | Ý nghĩa |
| --- | --- |
| `lệnh &` | Chạy lệnh ở background ngay từ đầu. |
| `Ctrl + Z` | Tạm dừng tiến trình foreground (trạng thái Stopped). |
| `bg` | Cho tiến trình đang dừng tiếp tục chạy ở background. |
| `fg` | Đưa tiến trình background về foreground. |
| `jobs` | Liệt kê các job của phiên shell hiện tại. |
| `nohup lệnh &` | Chạy nền và **không bị dừng khi đóng terminal**. |

```bash
sleep 100 &        # [1] 4321  chạy nền
jobs               # [1]+ Running  sleep 100 &
fg %1              # đưa job 1 lên foreground
# nhấn Ctrl + Z    # tạm dừng
bg %1              # tiếp tục chạy nền
nohup ./backup.sh > backup.out 2>&1 &
```

### 14. Kiểm tra tài nguyên hệ thống

| Lệnh | Chức năng | Ví dụ hay dùng |
| --- | --- | --- |
| `df` | Dung lượng sử dụng của các **hệ thống file** (phân vùng). | `df -h` (đơn vị dễ đọc), `df -hT` (kèm kiểu file system) |
| `du` | Dung lượng của **thư mục/file** cụ thể. | `du -sh /var/log`, `du -ah . \| sort -rh \| head` |
| `free` | Bộ nhớ RAM và swap. | `free -h` |
| `uptime` | Thời gian hệ thống đã chạy, số người dùng, **load average** (1, 5, 15 phút). | `uptime -p` |
| `uname` | Thông tin hệ thống và kernel. | `uname -a`, `uname -r` (phiên bản kernel) |
| `lscpu` | Thông tin CPU: kiến trúc, số nhân, tốc độ, hỗ trợ ảo hóa. | `lscpu` |
| `lsblk` | Liệt kê thiết bị khối (ổ đĩa, phân vùng) dạng cây. | `lsblk -f` (kèm file system, UUID) |

```bash
df -h
# Filesystem   Size  Used Avail Use% Mounted on
# /dev/sda1     50G   18G   30G  38% /

free -h
#               total   used   free   shared  buff/cache  available
# Mem:          7.7Gi  2.1Gi  3.2Gi   120Mi      2.4Gi      5.3Gi

uptime
# 10:42:11 up 5 days, 3:12, 2 users, load average: 0.45, 0.60, 0.52

uname -a
lscpu | grep -E "Model name|^CPU\(s\)|Virtualization"
lsblk
```

Ghi chú khi đọc kết quả:

- **`df` và `du` có thể cho số khác nhau**, vì `df` đọc từ file system còn `du` cộng dồn file. Nguyên nhân thường gặp: file đã bị xóa nhưng vẫn được tiến trình giữ mở.
- **Với `free`**, hãy nhìn cột **available** thay vì **free**. Linux dùng RAM trống làm cache nên `free` thấp là bình thường.
- **Load average** so với số nhân CPU: load bằng số nhân nghĩa là đã đầy tải; cao hơn nhiều nghĩa là tiến trình đang phải xếp hàng.
- Các công cụ bổ sung: `vmstat`, `iostat`, `iotop`, `ss`, `lsof`, `dmesg`, `lspci`, `lsusb`.

### 15. Dịch vụ và tiến trình nền (daemon)

#### 15.1. Daemon và systemd

**Daemon** là tiến trình nền chạy liên tục, thường khởi động cùng hệ thống và phục vụ yêu cầu (web server `nginx`, SSH server `sshd`, cron `crond`, ...). Tên daemon thường kết thúc bằng chữ `d`. Hầu hết distro hiện đại dùng **systemd** để quản lý dịch vụ qua các file **unit** (thường có đuôi `.service`) đặt trong `/etc/systemd/system/` hoặc `/lib/systemd/system/`.

#### 15.2. `systemctl`, `service`, `journalctl`

| Lệnh | Chức năng |
| --- | --- |
| `systemctl start <dịch vụ>` | Khởi động dịch vụ. |
| `systemctl stop <dịch vụ>` | Dừng dịch vụ. |
| `systemctl restart <dịch vụ>` | Dừng rồi khởi động lại. |
| `systemctl reload <dịch vụ>` | Nạp lại cấu hình mà không ngắt dịch vụ (nếu dịch vụ hỗ trợ). |
| `systemctl status <dịch vụ>` | Xem trạng thái, PID, log gần nhất. |
| `systemctl enable <dịch vụ>` | Bật tự khởi động cùng hệ thống. |
| `systemctl disable <dịch vụ>` | Tắt tự khởi động. |
| `systemctl is-active` / `is-enabled` | Kiểm tra nhanh đang chạy / đã bật chưa. |
| `systemctl list-units --type=service` | Liệt kê các dịch vụ. |
| `systemctl daemon-reload` | Nạp lại sau khi sửa file unit. |
| `service <dịch vụ> start\|stop\|status` | Lệnh kiểu cũ (SysV), nay thường chuyển tiếp sang systemctl. |
| `journalctl` | Xem log do systemd journal thu thập. |

```bash
sudo systemctl status ssh
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
sudo systemctl enable --now nginx     # bật khởi động cùng hệ thống và chạy luôn
systemctl list-units --type=service --state=running

journalctl -u nginx                   # log của dịch vụ nginx
journalctl -u nginx -f                # theo dõi liên tục (giống tail -f)
journalctl -u nginx --since "1 hour ago"
journalctl -p err -b                  # chỉ lỗi, từ lần boot hiện tại
journalctl --disk-usage
```

Tên dịch vụ SSH khác nhau theo distro: `ssh` (Debian/Ubuntu) và `sshd` (RHEL/CentOS).

#### 15.3. Ví dụ file unit tối giản

```ini
# /etc/systemd/system/myapp.service
[Unit]
Description=My Simple App
After=network.target

[Service]
ExecStart=/usr/bin/python3 /opt/myapp/app.py
Restart=on-failure
User=www-data

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now myapp
```

## Phần 6: Quản lý gói phần mềm

### 16. Trình quản lý gói (Package Manager)

**Package manager** là công cụ tự động tải, cài đặt, nâng cấp và gỡ phần mềm từ các **kho (repository)**, đồng thời xử lý **phụ thuộc (dependency)** giữa các gói. Việc này an toàn và tiện hơn nhiều so với tải file cài đặt thủ công, vì gói được ký số và có cập nhật bảo mật tập trung.

#### 16.1. Debian/Ubuntu: `apt`, `apt-get`, `dpkg`

- **`dpkg`:** công cụ cấp thấp, thao tác trực tiếp trên file `.deb`, **không tự xử lý phụ thuộc**.
- **`apt-get` / `apt-cache`:** công cụ cấp cao truyền thống, ổn định, phù hợp để dùng trong script.
- **`apt`:** giao diện hiện đại, gộp các chức năng hay dùng của `apt-get` và `apt-cache`, có thanh tiến trình, thân thiện cho dùng tương tác.

#### 16.2. RedHat/CentOS: `yum`, `dnf`, `rpm`

- **`rpm`:** công cụ cấp thấp cho file `.rpm`.
- **`yum`:** công cụ cấp cao đời cũ (RHEL/CentOS 7 trở về trước).
- **`dnf`:** thế hệ kế nhiệm của `yum` (Fedora, RHEL/CentOS 8 trở lên, Rocky, Alma), giải quyết phụ thuộc tốt hơn, cú pháp gần như tương thích với `yum`.

#### 16.3. Bảng đối chiếu lệnh

| Tác vụ | Debian/Ubuntu | RHEL/CentOS/Fedora |
| --- | --- | --- |
| Cập nhật danh sách gói | `sudo apt update` | `sudo dnf check-update` |
| Nâng cấp toàn bộ | `sudo apt upgrade` | `sudo dnf upgrade` |
| Cài gói | `sudo apt install nginx` | `sudo dnf install nginx` |
| Gỡ gói | `sudo apt remove nginx` | `sudo dnf remove nginx` |
| Tìm gói | `apt search nginx` | `dnf search nginx` |
| Xem thông tin gói | `apt show nginx` | `dnf info nginx` |
| Liệt kê gói đã cài | `dpkg -l` hoặc `apt list --installed` | `rpm -qa` hoặc `dnf list installed` |
| Cài file cục bộ | `sudo dpkg -i file.deb` | `sudo dnf install ./file.rpm` |
| Dọn cache | `sudo apt clean` | `sudo dnf clean all` |
| File kho phần mềm | `/etc/apt/sources.list`, `/etc/apt/sources.list.d/` | `/etc/yum.repos.d/` |

### 17. Cài đặt và gỡ bỏ phần mềm

#### 17.1. Quy trình chuẩn trên Ubuntu/Debian

```bash
sudo apt update                  # làm mới danh sách gói từ các kho
sudo apt upgrade                 # nâng cấp các gói đã cài lên phiên bản mới
sudo apt install htop            # cài một gói
sudo apt install -y git curl     # cài nhiều gói, tự trả lời yes
sudo apt remove htop             # gỡ gói, giữ lại file cấu hình
sudo apt purge htop              # gỡ gói và xóa cả file cấu hình
sudo apt autoremove              # gỡ các gói phụ thuộc không còn cần
```

Phân biệt dễ nhầm:

- **`apt update`** chỉ **tải danh sách** gói mới, **không** nâng cấp phần mềm nào.
- **`apt upgrade`** **nâng cấp** các gói đã cài, không gỡ gói nào.
- **`apt full-upgrade`** (hay `dist-upgrade`) nâng cấp và được phép cài thêm hoặc gỡ gói để giải quyết phụ thuộc.
- **`remove`** giữ lại cấu hình, **`purge`** xóa sạch cả cấu hình.

#### 17.2. Kiểm tra gói đang cài đặt

```bash
dpkg -l                          # liệt kê toàn bộ gói đã cài
dpkg -l | grep nginx             # kiểm tra một gói cụ thể
dpkg -s nginx                    # trạng thái chi tiết của gói
dpkg -L nginx                    # liệt kê các file mà gói đã cài
dpkg -S /usr/sbin/nginx          # file này thuộc gói nào
apt list --installed | grep nginx
apt policy nginx                 # phiên bản đã cài và phiên bản khả dụng
```

Trong kết quả của `dpkg -l`, cột đầu có thể thấy `ii` (đã cài đặt đúng), `rc` (đã gỡ nhưng còn file cấu hình). Trên RHEL dùng tương ứng `rpm -qa | grep nginx`, `rpm -ql nginx`, `rpm -qf /usr/sbin/nginx`.

Ngoài trình quản lý gói của distro, còn có các định dạng đóng gói độc lập: **snap**, **flatpak**, **AppImage**, cùng trình quản lý theo ngôn ngữ như `pip`, `npm`, `cargo`.

### 18. Tạo và sử dụng alias

**Alias** là tên gọi tắt thay cho một lệnh dài, giúp gõ nhanh và hạn chế sai sót.

```bash
alias                            # liệt kê alias hiện có
alias ll='ls -alF'               # tạo alias tạm thời (mất khi đóng terminal)
ll                               # dùng thử
unalias ll                       # xóa alias
```

#### 18.1. Lưu alias lâu dài trong `~/.bashrc`

Alias gõ trực tiếp chỉ có hiệu lực trong phiên hiện tại. Để dùng lâu dài, ghi vào file `~/.bashrc` (cho bash, được đọc mỗi khi mở terminal tương tác), rồi nạp lại:

```bash
nano ~/.bashrc
```

Thêm vào cuối file:

```bash
# --- Alias cá nhân ---
alias ll='ls -alF'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias update='sudo apt update && sudo apt upgrade -y'
alias ports='ss -tuln'
alias df='df -h'
alias rm='rm -i'                 # hỏi xác nhận trước khi xóa cho an toàn
```

Nạp lại cấu hình mà không cần mở terminal mới:

```bash
source ~/.bashrc
# hoặc: . ~/.bashrc
```

Lưu ý: với zsh thì dùng `~/.zshrc`. Nếu alias phức tạp (cần tham số ở giữa), nên dùng **hàm (function)** thay vì alias. Để bỏ qua alias một lần, đặt dấu gạch chéo ngược trước lệnh: `\rm file`.

## Phần 7: Làm việc với mạng (Networking)

### 19. Mô hình TCP/IP và OSI

#### 19.1. Mô hình OSI 7 tầng

OSI (Open Systems Interconnection) là mô hình tham chiếu chia quá trình truyền thông mạng thành 7 tầng. Dữ liệu đi từ ứng dụng xuống tầng vật lý ở máy gửi (**đóng gói - encapsulation**), rồi đi ngược lên ở máy nhận (**mở gói - decapsulation**).

| Tầng | Tên | Chức năng | Đơn vị dữ liệu (PDU) | Ví dụ |
| --- | --- | --- | --- | --- |
| 7 | Application (Ứng dụng) | Giao diện giữa ứng dụng và mạng | Data | HTTP, HTTPS, FTP, SSH, DNS, SMTP |
| 6 | Presentation (Trình diễn) | Mã hóa, nén, chuyển đổi định dạng dữ liệu | Data | TLS/SSL, JPEG, ASCII |
| 5 | Session (Phiên) | Thiết lập, duy trì, kết thúc phiên | Data | NetBIOS, RPC |
| 4 | Transport (Giao vận) | Truyền dữ liệu đầu cuối, kiểm soát lỗi và luồng | Segment / Datagram | TCP, UDP |
| 3 | Network (Mạng) | Định địa chỉ logic và định tuyến | Packet | IP, ICMP, router |
| 2 | Data Link (Liên kết dữ liệu) | Truyền frame giữa các nút kề nhau, địa chỉ MAC | Frame | Ethernet, Wi-Fi, switch |
| 1 | Physical (Vật lý) | Truyền bit qua môi trường vật lý | Bit | Cáp UTP, cáp quang, sóng vô tuyến |

Mẹo nhớ thứ tự từ tầng 7 xuống 1: **All People Seem To Need Data Processing** (Application, Presentation, Session, Transport, Network, Data link, Physical).

#### 19.2. Mô hình TCP/IP 4 tầng

TCP/IP là mô hình thực tế mà Internet đang dùng, gọn hơn OSI:

| Tầng TCP/IP | Tương ứng OSI | Giao thức tiêu biểu |
| --- | --- | --- |
| Application (Ứng dụng) | 5, 6, 7 | HTTP, HTTPS, DNS, SSH, FTP, SMTP, DHCP |
| Transport (Giao vận) | 4 | TCP, UDP |
| Internet | 3 | IP (IPv4/IPv6), ICMP, ARP (nằm giữa tầng 2 và 3) |
| Network Access (Truy cập mạng) | 1, 2 | Ethernet, Wi-Fi |

#### 19.3. TCP và UDP

| Tiêu chí | TCP | UDP |
| --- | --- | --- |
| Kết nối | Hướng kết nối, bắt tay 3 bước (SYN, SYN-ACK, ACK) | Không kết nối |
| Độ tin cậy | Đảm bảo thứ tự, truyền lại khi mất gói | Không đảm bảo |
| Tốc độ | Chậm hơn do có kiểm soát | Nhanh, ít overhead |
| Dùng cho | Web, SSH, email, truyền file | DNS, streaming, VoIP, game |

Các cổng (port) phổ biến: **22** (SSH), **80** (HTTP), **443** (HTTPS), **53** (DNS), **25** (SMTP), **3306** (MySQL), **5432** (PostgreSQL), **3389** (RDP).

### 20. Địa chỉ IP, Subnet và CIDR

#### 20.1. Địa chỉ IPv4

Địa chỉ **IPv4** gồm 32 bit, viết thành 4 octet thập phân cách bằng dấu chấm (ví dụ `192.168.1.10`). Mỗi địa chỉ gồm hai phần: **phần mạng (network)** và **phần máy (host)**, phân định bằng **subnet mask**.

**Dải địa chỉ riêng (private)** không định tuyến trên Internet (RFC 1918):

| Dải | CIDR | Thường dùng |
| --- | --- | --- |
| `10.0.0.0` đến `10.255.255.255` | `10.0.0.0/8` | Doanh nghiệp lớn, cloud |
| `172.16.0.0` đến `172.31.255.255` | `172.16.0.0/12` | Mạng vừa |
| `192.168.0.0` đến `192.168.255.255` | `192.168.0.0/16` | Mạng gia đình, văn phòng nhỏ |

Các địa chỉ đặc biệt: `127.0.0.1` (loopback, chính máy mình), `0.0.0.0` (mọi địa chỉ/không xác định), `169.254.0.0/16` (tự cấp APIPA khi không có DHCP). **IPv6** dùng 128 bit (ví dụ `2001:db8::1`) để giải quyết tình trạng cạn kiệt địa chỉ IPv4.

#### 20.2. Subnet mask và CIDR

**CIDR (Classless Inter-Domain Routing)** viết `địa chỉ/số bit mạng`. Ví dụ `192.168.1.0/24` nghĩa là 24 bit đầu là phần mạng, 8 bit còn lại là phần máy.

| CIDR | Subnet mask | Tổng địa chỉ | Máy khả dụng |
| --- | --- | --- | --- |
| `/8` | 255.0.0.0 | 16.777.216 | 16.777.214 |
| `/16` | 255.255.0.0 | 65.536 | 65.534 |
| `/24` | 255.255.255.0 | 256 | 254 |
| `/25` | 255.255.255.128 | 128 | 126 |
| `/26` | 255.255.255.192 | 64 | 62 |
| `/27` | 255.255.255.224 | 32 | 30 |
| `/28` | 255.255.255.240 | 16 | 14 |
| `/30` | 255.255.255.252 | 4 | 2 |

Công thức: số địa chỉ = 2^(32 - n), số máy khả dụng = 2^(32 - n) - 2 (trừ **địa chỉ mạng** ở đầu và **địa chỉ broadcast** ở cuối).

**Ví dụ tính toán:** mạng `192.168.10.0/26`

- Mask: `255.255.255.192`; kích thước khối: 256 - 192 = **64**.
- Các mạng con: `192.168.10.0`, `.64`, `.128`, `.192`.
- Mạng con đầu: địa chỉ mạng `192.168.10.0`, máy khả dụng `192.168.10.1` đến `192.168.10.62`, broadcast `192.168.10.63`.

Chia mạng con (subnetting) giúp tiết kiệm địa chỉ, tách biệt lưu lượng và tăng bảo mật. Có thể tính nhanh bằng công cụ `ipcalc` (`sudo apt install ipcalc`, sau đó `ipcalc 192.168.10.0/26`).

### 21. Gateway, Routing và DNS

#### 21.1. Gateway và routing

- **Default gateway (cổng mặc định):** địa chỉ của router mà máy gửi gói tin đến khi đích **nằm ngoài mạng nội bộ**. Nếu đích cùng subnet, máy gửi trực tiếp (qua ARP để tìm địa chỉ MAC).
- **Bảng định tuyến (routing table):** danh sách quy tắc cho kernel biết gửi gói đến mạng nào qua cổng nào. Khi nhiều dòng cùng khớp, kernel chọn dòng có **tiền tố dài nhất (longest prefix match)**.
- **NAT:** router chuyển địa chỉ private sang địa chỉ public khi ra Internet.

```bash
ip route                         # xem bảng định tuyến
# default via 192.168.1.1 dev eth0 proto dhcp metric 100
# 192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.10

ip route get 8.8.8.8             # đường đi tới một đích cụ thể
sudo ip route add 10.10.0.0/16 via 192.168.1.254   # thêm route tĩnh (tạm thời)
sudo ip route del 10.10.0.0/16
traceroute 8.8.8.8               # các chặng đường đi (sudo apt install traceroute)
```

Dòng `default via 192.168.1.1` chính là default gateway. Route thêm bằng `ip route add` sẽ mất sau khi khởi động lại; muốn lâu dài phải cấu hình qua Netplan (Ubuntu), NetworkManager hoặc file cấu hình mạng của distro.

#### 21.2. DNS

**DNS (Domain Name System)** chuyển tên miền sang địa chỉ IP (ví dụ `example.com` thành `93.184.216.34`). Quy trình tra cứu tên: kiểm tra cache cục bộ, file `/etc/hosts`, rồi hỏi **DNS resolver** (cấu hình trong `/etc/resolv.conf` hoặc qua `systemd-resolved`); resolver sẽ truy vấn lần lượt máy chủ gốc (root), TLD (`.com`), và máy chủ có thẩm quyền của tên miền.

Các loại bản ghi DNS thường gặp:

| Bản ghi | Ý nghĩa |
| --- | --- |
| `A` / `AAAA` | Tên miền sang địa chỉ IPv4 / IPv6 |
| `CNAME` | Bí danh trỏ sang tên miền khác |
| `MX` | Máy chủ nhận mail |
| `NS` | Máy chủ DNS có thẩm quyền |
| `TXT` | Văn bản (SPF, xác minh tên miền) |
| `PTR` | Tra ngược từ IP ra tên |

```bash
cat /etc/resolv.conf
resolvectl status                # xem cấu hình DNS (systemd-resolved)
nslookup example.com
dig example.com                  # chi tiết hơn (gói dnsutils / bind-utils)
dig +short example.com MX
dig @8.8.8.8 example.com         # hỏi trực tiếp một DNS server cụ thể
host example.com
cat /etc/hosts                   # ánh xạ tên thủ công, ưu tiên trước DNS
```

### 22. Lệnh kiểm tra mạng

| Lệnh | Chức năng | Ví dụ |
| --- | --- | --- |
| `ping` | Kiểm tra kết nối bằng gói ICMP, đo độ trễ và mất gói. | `ping -c 4 8.8.8.8` |
| `ifconfig` | Xem/cấu hình giao diện mạng (lệnh cũ, thuộc gói `net-tools`). | `ifconfig eth0` |
| `ip addr` | Xem/cấu hình địa chỉ IP (lệnh hiện đại, thay `ifconfig`). | `ip addr show`, `ip -br a` |
| `ip link` | Trạng thái giao diện mạng, địa chỉ MAC. | `ip link show` |
| `netstat` | Xem kết nối, cổng, bảng route (lệnh cũ). | `netstat -tuln` |
| `ss` | Thay thế hiện đại cho `netstat`, nhanh hơn. | `ss -tulnp` |
| `curl` | Gửi yêu cầu HTTP/HTTPS, kiểm tra API, tải nội dung. | `curl -I https://example.com` |
| `wget` | Tải file từ web, hỗ trợ tải tiếp và đệ quy. | `wget https://example.com/file.zip` |

```bash
ping -c 4 google.com             # -c 4: gửi 4 gói rồi dừng
ip addr show                     # hoặc: ip -br a
ip -4 addr show eth0
ifconfig                         # cần cài net-tools

ss -tuln                         # cổng đang lắng nghe
ss -tulnp                        # kèm tên tiến trình (cần sudo)
ss -s                            # thống kê tổng quan
netstat -tuln

curl https://example.com
curl -I https://example.com      # chỉ xem header
curl -o page.html https://example.com
curl -X POST -d "name=an" https://httpbin.org/post
wget -c https://example.com/big.iso    # -c: tải tiếp khi bị gián đoạn
```

Quy trình **kiểm tra sự cố mạng** theo từng bước:

1. `ip -br a`: giao diện có lên (UP) và có IP chưa.
2. `ping 127.0.0.1`: ngăn xếp TCP/IP của máy có hoạt động.
3. `ping <gateway>`: có thông tới router không.
4. `ping 8.8.8.8`: có ra được Internet bằng địa chỉ IP không.
5. `ping google.com`: DNS có phân giải được không. Nếu bước 4 thành công mà bước 5 lỗi thì nguyên nhân là DNS.
6. `traceroute`, `curl -v`, `ss -tuln`: xác định chặng nghẽn hoặc dịch vụ chưa lắng nghe.

### 23. Kết nối SSH và truyền file

#### 23.1. SSH cơ bản

**SSH (Secure Shell)** cho phép đăng nhập và điều khiển máy từ xa qua kênh **mã hóa** (mặc định cổng TCP 22), thay thế các giao thức không an toàn như Telnet.

```bash
ssh user@192.168.1.10                # đăng nhập
ssh -p 2222 user@192.168.1.10        # cổng khác mặc định
ssh -i ~/.ssh/id_ed25519 user@host   # chỉ định khóa riêng
ssh user@host "uptime; df -h"        # chạy lệnh từ xa rồi thoát
ssh -L 8080:localhost:80 user@host   # chuyển tiếp cổng (tunnel)
```

Lần đầu kết nối, SSH hỏi xác nhận **dấu vân tay (fingerprint)** của máy chủ rồi lưu vào `~/.ssh/known_hosts`. Muốn chạy máy chủ SSH cần cài `openssh-server`: `sudo apt install openssh-server`.

#### 23.2. Truyền file: `scp` và `rsync`

```bash
# scp: sao chép qua SSH
scp file.txt user@192.168.1.10:/home/user/          # gửi file lên máy từ xa
scp user@192.168.1.10:/var/log/syslog ./            # tải file về
scp -r thumuc/ user@192.168.1.10:/home/user/        # cả thư mục
scp -P 2222 file.txt user@host:/tmp/                # lưu ý: -P viết hoa

# rsync: đồng bộ thông minh, chỉ gửi phần thay đổi
rsync -avz thumuc/ user@192.168.1.10:/backup/thumuc/
rsync -avz --progress --delete /data/ user@host:/backup/data/
rsync -avzn thumuc/ user@host:/backup/     # -n: chạy thử, không thực hiện thật
```

| Tiêu chí | `scp` | `rsync` |
| --- | --- | --- |
| Cách hoạt động | Sao chép toàn bộ file | So sánh và chỉ truyền phần khác biệt |
| Tiếp tục khi gián đoạn | Không | Có (`--partial`) |
| Đồng bộ, xóa file thừa | Không | Có (`--delete`) |
| Phù hợp | Gửi nhanh vài file | Sao lưu, đồng bộ thư mục lớn |

Ý nghĩa tùy chọn `rsync`: `-a` (archive, giữ quyền, thời gian, đệ quy), `-v` (chi tiết), `-z` (nén khi truyền). Lưu ý dấu `/` cuối đường dẫn nguồn: `thumuc/` đồng bộ **nội dung bên trong**, còn `thumuc` đồng bộ **cả thư mục**.

#### 23.3. Thiết lập SSH key

Xác thực bằng **cặp khóa công khai/riêng** an toàn hơn mật khẩu: khóa riêng (`id_ed25519`) giữ trên máy bạn, khóa công khai (`id_ed25519.pub`) đặt trên máy chủ trong `~/.ssh/authorized_keys`.

```bash
# 1. Tạo cặp khóa trên máy client
ssh-keygen -t ed25519 -C "an@laptop"
# (có thể đặt passphrase để bảo vệ khóa riêng)
# Hoặc RSA: ssh-keygen -t rsa -b 4096

# 2. Đưa khóa công khai lên máy chủ
ssh-copy-id user@192.168.1.10

# 3. Đăng nhập thử, không cần mật khẩu tài khoản
ssh user@192.168.1.10
```

Nếu không có `ssh-copy-id`, có thể làm thủ công: `cat ~/.ssh/id_ed25519.pub | ssh user@host "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"`. Quyền thư mục phải chặt, nếu không SSH sẽ từ chối: `chmod 700 ~/.ssh` và `chmod 600 ~/.ssh/authorized_keys`.

Tăng cường bảo mật trong `/etc/ssh/sshd_config` (**chỉ làm sau khi chắc chắn đăng nhập bằng key thành công**, tránh tự khóa mình):

```
PasswordAuthentication no
PermitRootLogin no
Port 2222            # tùy chọn, đổi cổng mặc định
```

```bash
sudo sshd -t                     # kiểm tra cú pháp cấu hình
sudo systemctl restart ssh       # áp dụng (tên dịch vụ: ssh hoặc sshd)
```

Mẹo: file `~/.ssh/config` giúp đặt tên tắt cho máy chủ:

```
Host web1
    HostName 192.168.1.10
    User an
    Port 22
    IdentityFile ~/.ssh/id_ed25519
```

Khi đó chỉ cần gõ `ssh web1`.

### 24. Kiểm tra cổng và firewall

#### 24.1. Kiểm tra cổng đang mở

```bash
ss -tuln                         # t: TCP, u: UDP, l: đang lắng nghe, n: hiển thị số cổng
# Netid State  Recv-Q Send-Q Local Address:Port
# tcp   LISTEN 0      128    0.0.0.0:22
# tcp   LISTEN 0      511    0.0.0.0:80

sudo ss -tulnp | grep :80        # cổng 80 do tiến trình nào giữ
sudo lsof -i :80
nc -zv 192.168.1.10 22           # kiểm tra cổng của máy khác có mở không
nmap -p 22,80,443 192.168.1.10   # quét cổng (chỉ quét hệ thống của bạn hoặc được phép)
```

Phân biệt: `0.0.0.0:22` nghĩa là lắng nghe trên **mọi giao diện**; `127.0.0.1:3306` chỉ cho phép kết nối **từ chính máy đó**. Một cổng ở trạng thái `LISTEN` nhưng vẫn không truy cập được từ xa thường do **firewall** chặn.

#### 24.2. Firewall: `ufw` và `iptables`

Firewall lọc gói tin theo quy tắc. Trong Linux, bộ lọc nằm ở kernel (**netfilter**); `iptables` (và `nftables`, thế hệ mới) là giao diện cấu hình, còn `ufw` (Uncomplicated Firewall) là lớp bọc đơn giản trên Ubuntu. Trên RHEL/CentOS có `firewalld` (`firewall-cmd`).

**`ufw`:**

```bash
sudo ufw status verbose
sudo ufw default deny incoming       # chặn mọi kết nối vào theo mặc định
sudo ufw default allow outgoing
sudo ufw allow 22/tcp                # cho phép SSH (làm TRƯỚC khi bật ufw)
sudo ufw allow 80,443/tcp
sudo ufw allow from 192.168.1.0/24 to any port 3306
sudo ufw deny 23
sudo ufw delete allow 80/tcp
sudo ufw enable                      # bật firewall
sudo ufw disable
```

Cẩn thận: bật `ufw` mà chưa cho phép cổng SSH sẽ **mất kết nối từ xa** vào máy.

**`iptables`:** tổ chức theo **bảng (table)** gồm các **chuỗi (chain)**: `INPUT` (vào máy), `OUTPUT` (ra khỏi máy), `FORWARD` (đi xuyên qua máy). Mỗi gói được so khớp lần lượt với các quy tắc và chịu hành động đầu tiên khớp: `ACCEPT`, `DROP` (bỏ im lặng), `REJECT` (từ chối có phản hồi).

```bash
sudo iptables -L -n -v --line-numbers          # xem quy tắc hiện có
sudo iptables -A INPUT -i lo -j ACCEPT         # cho phép loopback
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT   # cho SSH
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT   # cho HTTP
sudo iptables -P INPUT DROP                    # chính sách mặc định: chặn hết còn lại
sudo iptables -D INPUT 3                       # xóa quy tắc số 3

sudo iptables-save > /etc/iptables/rules.v4    # lưu (gói iptables-persistent)
```

Thứ tự rất quan trọng: phải thêm các quy tắc `ACCEPT` cho SSH và kết nối đã thiết lập **trước khi** đặt chính sách mặc định `DROP`.

## Phần 8: Script và Automation cơ bản

### 25. Shell Script là gì?

**Shell script** là file văn bản chứa một chuỗi lệnh shell, thực thi lần lượt, dùng để tự động hóa các tác vụ lặp lại (sao lưu, cài đặt, giám sát, triển khai).

#### 25.1. File `.sh` và shebang

Dòng đầu tiên `#!/bin/bash` gọi là **shebang**, cho hệ điều hành biết dùng trình thông dịch nào để chạy file. Đuôi `.sh` chỉ là quy ước, không bắt buộc. Dòng bắt đầu bằng `#` (trừ shebang) là chú thích.

```bash
#!/bin/bash
# hello.sh - script đầu tiên
echo "Xin chào, $USER!"
echo "Hôm nay là: $(date '+%d/%m/%Y')"
echo "Bạn đang ở: $(pwd)"
```

#### 25.2. Cách chạy script

```bash
# Cách 1: gọi trực tiếp bằng bash (không cần quyền thực thi)
bash hello.sh

# Cách 2: cấp quyền thực thi rồi chạy
chmod +x hello.sh
./hello.sh                       # phải có ./ vì thư mục hiện tại không nằm trong PATH

# Cách 3: chạy trong shell hiện tại (biến được giữ lại sau khi chạy)
source hello.sh
```

[Tham khao](https://dataonline.vn/tu-hoc-bash-scripting/#Bash_Script_la_gi)
[Tham khao](https://www.freecodecamp.org/news/bash-scripting-tutorial-linux-shell-script-and-command-line-for-beginners/)

Để gọi script từ bất kỳ đâu, đặt vào thư mục có trong `PATH` (ví dụ `/usr/local/bin` hoặc `~/bin`). Kiểm tra `echo $PATH`.

Các tham số và biến đặc biệt:

| Biến | Ý nghĩa |
| --- | --- |
| `$0` | Tên script |
| `$1`, `$2`, ... | Tham số thứ 1, 2, ... |
| `$#` | Số lượng tham số |
| `$@` | Toàn bộ tham số (từng phần tử riêng) |
| `$?` | Mã thoát (exit code) của lệnh vừa chạy; `0` là thành công |
| `$$` | PID của chính script |

### 26. Biến, vòng lặp và điều kiện

#### 26.1. Biến

```bash
#!/bin/bash
TEN="An"                         # KHÔNG có dấu cách quanh dấu =
tuoi=20
echo "Tên: $TEN, tuổi: $tuoi"
echo "Tên: ${TEN}Nguyen"         # dùng {} để ngăn nhầm tên biến
NGAY=$(date +%F)                 # gán kết quả của lệnh
echo "Ngày: $NGAY"
read -p "Nhập tên thư mục: " DIR   # nhập từ bàn phím
export MY_VAR="hello"            # biến môi trường cho tiến trình con
```

**Biến môi trường** thường dùng:

| Biến | Ý nghĩa |
| --- | --- |
| `$USER` | Tên người dùng hiện tại |
| `$HOME` | Thư mục home |
| `$PWD` | Thư mục hiện tại |
| `$PATH` | Danh sách thư mục tìm lệnh |
| `$SHELL` | Shell mặc định |
| `$HOSTNAME` | Tên máy |

Xem tất cả bằng `env` hoặc `printenv`. Phân biệt dấu nháy: nháy kép `"..."` cho phép thay thế biến (`"$USER"`), nháy đơn `'...'` giữ nguyên văn bản (`'$USER'` in ra đúng chữ `$USER`). Luôn đặt biến trong nháy kép (`"$FILE"`) để an toàn với tên file có dấu cách.

#### 26.2. Điều kiện `if`

```bash
#!/bin/bash
read -p "Nhập một số: " so

if [ "$so" -gt 0 ]; then
    echo "Số dương"
elif [ "$so" -eq 0 ]; then
    echo "Bằng không"
else
    echo "Số âm"
fi

# Kiểm tra file / thư mục
if [ -f /etc/passwd ]; then echo "File tồn tại"; fi
if [ ! -d /tmp/backup ]; then mkdir /tmp/backup; fi
```

| Loại | Toán tử | Ý nghĩa |
| --- | --- | --- |
| Số | `-eq`, `-ne`, `-gt`, `-lt`, `-ge`, `-le` | bằng, khác, lớn hơn, nhỏ hơn, lớn hơn hoặc bằng, nhỏ hơn hoặc bằng |
| Chuỗi | `=`, `!=`, `-z`, `-n` | bằng, khác, rỗng, không rỗng |
| File | `-e`, `-f`, `-d`, `-r`, `-w`, `-x`, `-s` | tồn tại, là file, là thư mục, đọc/ghi/thực thi được, có dung lượng > 0 |
| Logic | `&&`, `\|\|`, `!` | và, hoặc, phủ định |

Cũng có thể dùng `case` cho nhiều nhánh và `[[ ... ]]` (bash) cho so khớp mẫu mạnh hơn.

#### 26.3. Vòng lặp `for` và `while`

```bash
#!/bin/bash
# for: duyệt danh sách
for ten in an binh chi; do
    echo "Xin chào $ten"
done

# for: duyệt dải số và file
for i in {1..5}; do echo "Lần $i"; done
for f in /var/log/*.log; do echo "Log: $f"; done

# for kiểu C
for ((i=1; i<=3; i++)); do echo "i=$i"; done

# while: lặp khi điều kiện đúng
n=1
while [ $n -le 5 ]; do
    echo "n = $n"
    n=$((n + 1))
done

# đọc từng dòng của file
while read -r dong; do
    echo "Dòng: $dong"
done < /etc/hostname
```

Điều khiển vòng lặp: `break` (thoát vòng lặp), `continue` (bỏ qua lần lặp hiện tại). Hàm trong bash:

```bash
chao() {
    echo "Xin chào $1"
}
chao "An"
```

Thói quen tốt khi viết script: đặt `set -euo pipefail` ở đầu (dừng khi có lỗi, báo biến chưa khai báo, bắt lỗi trong pipe); luôn đặt biến trong nháy kép; kiểm tra thư mục tồn tại trước khi thao tác; ghi log kèm thời gian; kiểm tra script bằng `bash -n script.sh` (kiểm tra cú pháp) và `bash -x script.sh` (gỡ lỗi từng dòng) hoặc công cụ `shellcheck`.

### 27. Tự động hóa tác vụ

#### 27.1. `cron` và `crontab`

**cron** là dịch vụ lập lịch chạy lệnh/script theo thời gian định sẵn, chạy nền bằng daemon `cron` (hoặc `crond`). Mỗi người dùng có một bảng lịch riêng gọi là **crontab**.

| Lệnh | Chức năng |
| --- | --- |
| `crontab -e` | Soạn lịch của người dùng hiện tại (lần đầu sẽ hỏi chọn trình soạn thảo). |
| `crontab -l` | Xem lịch hiện có. |
| `crontab -r` | Xóa toàn bộ lịch (cẩn thận, không hỏi lại). |
| `sudo crontab -u user -e` | Sửa lịch của người dùng khác. |
| `sudo systemctl status cron` | Kiểm tra dịch vụ cron (`crond` trên RHEL). |

**Cú pháp một dòng crontab** gồm 5 trường thời gian và lệnh:

```
┌──────── phút (0-59)
│ ┌────── giờ (0-23)
│ │ ┌──── ngày trong tháng (1-31)
│ │ │ ┌── tháng (1-12)
│ │ │ │ ┌ thứ trong tuần (0-7, 0 và 7 đều là Chủ nhật)
│ │ │ │ │
* * * * *  lệnh_cần_chạy
```

Các ký hiệu: `*` (mọi giá trị), `,` (liệt kê: `1,15`), `-` (khoảng: `1-5`), `/` (bước: `*/10` là mỗi 10 đơn vị).

| Biểu thức | Ý nghĩa |
| --- | --- |
| `* * * * *` | Mỗi phút |
| `*/5 * * * *` | Mỗi 5 phút |
| `0 * * * *` | Đầu mỗi giờ |
| `30 2 * * *` | 02:30 mỗi ngày |
| `0 9 * * 1-5` | 09:00 các ngày thứ Hai đến thứ Sáu |
| `0 0 1 * *` | 00:00 ngày mùng 1 hàng tháng |
| `0 3 * * 0` | 03:00 sáng Chủ nhật hàng tuần |
| `@reboot` | Mỗi lần hệ thống khởi động |
| `@daily`, `@weekly`, `@hourly` | Viết tắt tiện lợi |

#### 27.2. Lên lịch chạy script

```bash
crontab -e
# Thêm các dòng sau:

# Chạy script sao lưu lúc 02:30 mỗi ngày, ghi log đầu ra và lỗi
30 2 * * * /home/an/scripts/backup.sh >> /home/an/logs/backup.log 2>&1

# Dọn file tạm mỗi Chủ nhật
0 3 * * 0 find /tmp -type f -mtime +7 -delete
```

Những lưu ý quan trọng để cron chạy đúng:

- **Dùng đường dẫn tuyệt đối** cho script và các file bên trong, vì cron chạy với môi trường rất tối giản (`PATH` ngắn, không có biến của shell đăng nhập).
- Script phải có quyền thực thi (`chmod +x`) và có shebang.
- **Chuyển hướng đầu ra** (`>> file.log 2>&1`); nếu không, cron cố gửi mail cục bộ hoặc bỏ mất kết quả, rất khó gỡ lỗi.
- Xem log cron: `grep CRON /var/log/syslog` hoặc `journalctl -u cron`.
- Ngoài crontab người dùng còn có `/etc/crontab`, thư mục `/etc/cron.d/` và `/etc/cron.daily/`, `/etc/cron.weekly/`. Lệnh cho phép chỉ định người chạy ở trường thứ 6.
- Để chạy một lần vào thời điểm định trước dùng `at`; để lập lịch hiện đại có thể dùng **systemd timer**.

## Phần 9: Thực hành tổng hợp

### 28. Bài tập thực tế

Các bài tập dưới đây tổng hợp kiến thức của toàn bộ báo cáo. Nên thực hành trên máy ảo Ubuntu (VirtualBox, VMware, KVM) để tránh ảnh hưởng đến hệ thống thật.

#### Bài 1: Tạo user mới, cấp quyền hạn chế

**Yêu cầu:** tạo người dùng `devuser` thuộc nhóm `developers`, có thư mục dùng chung `/srv/project`; chỉ nhóm này được đọc và ghi, người khác không được truy cập; `devuser` chỉ được chạy một số lệnh với `sudo`.

```bash
# 1. Tạo nhóm và người dùng
sudo groupadd developers
sudo adduser devuser                       # nhập mật khẩu theo hướng dẫn
sudo usermod -aG developers devuser
id devuser                                 # kiểm tra nhóm

# 2. Tạo thư mục dùng chung và phân quyền
sudo mkdir -p /srv/project
sudo chown root:developers /srv/project
sudo chmod 2770 /srv/project               # rwxrws---, setgid: file mới thừa kế nhóm developers
ls -ld /srv/project

# 3. Cấp sudo giới hạn (chỉ cho phép restart nginx và xem log)
sudo visudo -f /etc/sudoers.d/devuser
# Nội dung:
# devuser ALL=(root) /usr/bin/systemctl restart nginx, /usr/bin/journalctl

# 4. Kiểm tra
sudo -u devuser touch /srv/project/test.txt     # thành công
sudo -u nobody ls /srv/project                  # bị từ chối (Permission denied)
sudo -l -U devuser                              # liệt kê quyền sudo của devuser
```

**Giải thích:** `2770` gồm số `2` là bit **setgid** (file tạo ra trong thư mục tự mang nhóm `developers`), `770` là chủ và nhóm toàn quyền, người khác không có quyền. Dùng `visudo` để kiểm tra cú pháp, tránh làm hỏng sudo. Tuân theo nguyên tắc đặc quyền tối thiểu: không thêm `devuser` vào nhóm `sudo`.

#### Bài 2: Tạo và nén backup thư mục

**Yêu cầu:** nén thư mục `~/documents` thành file có gắn ngày tháng, kiểm tra tính toàn vẹn, thử giải nén.

```bash
# Tạo dữ liệu mẫu
mkdir -p ~/documents && echo "du lieu 1" > ~/documents/a.txt && echo "du lieu 2" > ~/documents/b.txt

# Nén với tên có ngày
mkdir -p ~/backups
tar -czvf ~/backups/documents_$(date +%F).tar.gz -C ~ documents

# Kiểm tra
ls -lh ~/backups
tar -tzf ~/backups/documents_$(date +%F).tar.gz       # liệt kê nội dung
gzip -t ~/backups/documents_$(date +%F).tar.gz && echo "File nén hợp lệ"
sha256sum ~/backups/documents_$(date +%F).tar.gz > ~/backups/documents_$(date +%F).sha256

# Thử khôi phục sang thư mục khác
mkdir -p /tmp/restore
tar -xzvf ~/backups/documents_$(date +%F).tar.gz -C /tmp/restore
diff -r ~/documents /tmp/restore/documents && echo "Dữ liệu khớp hoàn toàn"
```

Dùng `-C ~ documents` để trong file nén chỉ chứa đường dẫn tương đối `documents/...` thay vì đường dẫn tuyệt đối dài. Một bản sao lưu chỉ thực sự đáng tin khi **đã thử khôi phục thành công**.

#### Bài 3: Viết script tự động sao lưu log hệ thống hàng ngày

**Yêu cầu:** script nén log hệ thống vào thư mục backup, đặt tên theo ngày, giữ lại 7 ngày gần nhất, ghi nhật ký hoạt động, chạy tự động lúc 02:00 mỗi ngày.

Tạo file `/usr/local/bin/backup_logs.sh`:

```bash
#!/bin/bash
# backup_logs.sh - Sao lưu log hệ thống hàng ngày
set -euo pipefail

SRC_DIR="/var/log"
DEST_DIR="/var/backups/logs"
KEEP_DAYS=7
DATE=$(date +%F_%H%M)
ARCHIVE="$DEST_DIR/logs_${DATE}.tar.gz"
LOG_FILE="/var/log/backup_logs.log"

log() { echo "[$(date '+%F %T')] $*" >> "$LOG_FILE"; }

# Bắt buộc chạy bằng root để đọc được toàn bộ log
if [ "$(id -u)" -ne 0 ]; then
    echo "Cần chạy bằng root (sudo)." >&2
    exit 1
fi

mkdir -p "$DEST_DIR"
log "Bắt đầu sao lưu $SRC_DIR"

# Nén log (tar có thể cảnh báo với file đang được ghi, nên chấp nhận mã thoát 1)
rc=0
tar -czf "$ARCHIVE" --exclude="log/journal" -C /var log 2>/dev/null || rc=$?

if [ "$rc" -le 1 ] && [ -s "$ARCHIVE" ]; then
    SIZE=$(du -h "$ARCHIVE" | cut -f1)
    log "Thành công: $ARCHIVE ($SIZE)"
else
    log "LỖI: không tạo được $ARCHIVE (mã thoát $rc)"
    exit 1
fi

# Xóa bản sao lưu cũ hơn KEEP_DAYS ngày
DELETED=$(find "$DEST_DIR" -name "logs_*.tar.gz" -mtime +"$KEEP_DAYS" -print -delete | wc -l)
log "Đã xóa $DELETED bản sao lưu cũ (> $KEEP_DAYS ngày)"
```

Cấp quyền và thử chạy:

```bash
sudo chmod +x /usr/local/bin/backup_logs.sh
sudo /usr/local/bin/backup_logs.sh
ls -lh /var/backups/logs/
tail /var/log/backup_logs.log
```

Lên lịch bằng crontab của root:

```bash
sudo crontab -e
# Thêm dòng:
0 2 * * * /usr/local/bin/backup_logs.sh >> /var/log/backup_logs.cron.log 2>&1

sudo crontab -l        # kiểm tra lại
```

Kiểm thử nhanh trước khi chờ đến 02:00: đặt tạm lịch `* * * * *` (mỗi phút), quan sát log rồi đổi lại lịch đúng. Lưu ý: `tar` trả mã thoát 1 khi file thay đổi lúc đang đọc (log vẫn đang được ghi), đây là cảnh báo chứ không phải lỗi nghiêm trọng, nên script chỉ coi mã từ 2 trở lên là thất bại.

#### Bài 4: Dò tìm file lớn nhất trong thư mục home

**Yêu cầu:** liệt kê 10 file lớn nhất trong `$HOME` và 10 thư mục chiếm nhiều dung lượng nhất.

```bash
# Cách 1: find + sort (liệt kê FILE lớn nhất, chính xác theo byte)
find "$HOME" -type f -printf '%s\t%p\n' 2>/dev/null | sort -nr | head -n 10 \
  | awk -F'\t' '{ printf "%.1f MB\t%s\n", $1/1024/1024, $2 }'

# Cách 2: find kết hợp ls
find "$HOME" -type f -size +50M -exec ls -lh {} \; 2>/dev/null

# Cách 3: du (liệt kê file và thư mục chiếm dung lượng lớn)
du -ah "$HOME" 2>/dev/null | sort -rh | head -n 10

# Chỉ các thư mục cấp 1 chiếm nhiều dung lượng nhất
du -h --max-depth=1 "$HOME" 2>/dev/null | sort -rh | head -n 10

# Chỉ tìm file lớn nhất duy nhất
find "$HOME" -type f -printf '%s %p\n' 2>/dev/null | sort -nr | head -n 1
```

**Giải thích:** `-printf '%s\t%p\n'` in kích thước (byte) và đường dẫn; `sort -nr` sắp xếp số giảm dần; `head -n 10` lấy 10 dòng đầu; `2>/dev/null` bỏ qua thông báo lỗi quyền truy cập; `sort -rh` sắp xếp theo kích thước dễ đọc (K, M, G). Có thể đóng gói thành script nhận số lượng kết quả làm tham số (`$1`). Công cụ tương tác tiện lợi hơn: `ncdu` (`sudo apt install ncdu`).

#### Bài 5: Cấu hình SSH và kiểm tra kết nối

**Yêu cầu:** cài SSH server, tạo khóa, đăng nhập không mật khẩu, tăng cường bảo mật, kiểm tra kết nối và truyền file.

**Phía máy chủ (server):**

```bash
# 1. Cài và bật SSH server
sudo apt update && sudo apt install -y openssh-server
sudo systemctl enable --now ssh
sudo systemctl status ssh

# 2. Kiểm tra dịch vụ lắng nghe cổng 22 và lấy địa chỉ IP
ss -tuln | grep :22
ip -br a

# 3. Mở cổng trên firewall
sudo ufw allow 22/tcp
sudo ufw status
```

**Phía máy khách (client):**

```bash
# 4. Kiểm tra kết nối mạng và cổng
ping -c 3 192.168.1.10
nc -zv 192.168.1.10 22

# 5. Tạo khóa và đưa khóa công khai lên server
ssh-keygen -t ed25519 -C "an@client"
ssh-copy-id user@192.168.1.10

# 6. Đăng nhập thử bằng khóa
ssh user@192.168.1.10 "hostname && uptime"

# 7. Truyền file và đồng bộ thư mục
echo "hello" > test.txt
scp test.txt user@192.168.1.10:/tmp/
rsync -avz ~/documents/ user@192.168.1.10:/tmp/documents_backup/
```

**Tăng cường bảo mật trên server** (sau khi đăng nhập bằng khóa thành công, và giữ nguyên một phiên SSH đang mở để phòng sự cố):

```bash
sudo nano /etc/ssh/sshd_config
# PasswordAuthentication no
# PermitRootLogin no

sudo sshd -t                        # kiểm tra cú pháp, không in gì là hợp lệ
sudo systemctl restart ssh

# Mở phiên MỚI từ client để xác nhận vẫn vào được trước khi đóng phiên cũ
ssh user@192.168.1.10

# Xem log đăng nhập
sudo journalctl -u ssh --since "10 minutes ago"
sudo grep "Accepted\|Failed" /var/log/auth.log | tail
```

**Xử lý sự cố SSH thường gặp:**

| Triệu chứng | Nguyên nhân thường gặp | Cách kiểm tra |
| --- | --- | --- |
| `Connection refused` | Dịch vụ SSH chưa chạy hoặc sai cổng | `systemctl status ssh`, `ss -tuln` |
| `Connection timed out` | Firewall chặn, sai IP hoặc mạng không thông | `ping`, `ufw status`, kiểm tra security group (cloud) |
| `Permission denied (publickey)` | Khóa chưa được cài hoặc sai quyền thư mục | `chmod 700 ~/.ssh`, `chmod 600 ~/.ssh/authorized_keys`, `ssh -v` |
| `Host key verification failed` | Server đổi khóa máy chủ hoặc IP đổi chủ | `ssh-keygen -R <địa_chỉ_IP>` rồi kết nối lại |

Dùng `ssh -v user@host` (thêm `-vv`, `-vvv` để chi tiết hơn) để xem từng bước thương lượng và xác thực.

### Tổng kết

Báo cáo đã đi từ khái niệm nền tảng (Linux là gì, kiến trúc, cây thư mục) đến các kỹ năng vận hành cốt lõi: làm việc với terminal, file, người dùng và phân quyền, tiến trình và dịch vụ, quản lý gói, mạng, SSH, firewall, và cuối cùng là tự động hóa bằng shell script cùng cron. Những kỹ năng này là nền tảng để tiếp tục học quản trị server, DevOps, cloud và ảo hóa.

**Gợi ý lộ trình học tiếp:** thực hành thường xuyên trên máy ảo; đọc `man` page; học thêm `awk`, `sed`, `vim`; tìm hiểu LVM và hệ thống file, SELinux/AppArmor, Docker, Ansible, Nginx; và làm các dự án nhỏ (dựng web server, tự động sao lưu, giám sát hệ thống).

### Tài liệu tham khảo

- Trang `man` trong chính hệ thống: `man ls`, `man tar`, `man ssh`, `man 5 crontab`.
- The Linux Documentation Project (tldp.org) và tài liệu Linux kernel (kernel.org/doc).
- Ubuntu Server documentation (ubuntu.com/server/docs).
- Filesystem Hierarchy Standard (FHS) do Linux Foundation duy trì.
- Arch Wiki (wiki.archlinux.org): tài liệu chất lượng cao, áp dụng được cho nhiều distro.
- William Shotts, *The Linux Command Line* (bản miễn phí tại linuxcommand.org).
