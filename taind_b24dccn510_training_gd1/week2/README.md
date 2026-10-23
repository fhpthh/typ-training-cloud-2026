## Phần 1. Giới thiệu tổng quan về Linux
### 1. Linux là gì?
- Là hệ điều hành mã nguồn mở:
    - Hệ điều hành (Operating System) là hệ thống chương trình quản lý phần cứng và phần mềm của máy tính.
    - Mã nguồn mở (Open Source) là phần mềm mà mã nguồn được công khai, cho phép người dùng tự do sử dụng, nghiên cứu, sửa đổi và phân phối lại.
- Lịch sử phát triển:
    - Triết lý thiết kế hệ thống Unix, được phát triển từ những năm 1970.
    - Dự án GNU (GNU's Not Unix) được Richard Stallman khởi xướng vào năm 1983 nhằm tạo ra một hệ điều hành hoàn toàn tự do, nhưng thiếu nhân (kernel) hoàn chỉnh.
    - Năm 1991, Linus Torvalds phát triển nhân Linux, kết hợp với các phần mềm của dự án GNU để tạo ra hệ điều hành Linux hoàn chỉnh (GNU/Linux).
- Phân biệt Linux Kernel và các bản phân phối Linux (Linux Distribution):
    - Linux Kernel: là nhân của hệ điều hành, chịu trách nhiệm quản lý tài nguyên phần cứng và cung cấp các dịch vụ cơ bản cho các ứng dụng. Đơn thuần chỉ là "trái tim" của hệ điều hành, không thể sử dụng trực tiếp mà cần có các phần mềm bổ sung.
    - Linux Distribution: là các phiên bản hệ điều hành dựa trên nhân Linux, bao gồm các phần mềm bổ sung, giao diện người dùng và công cụ quản lý hệ thống. Ví dụ: Ubuntu, Fedora, Debian, CentOS.
    - Bảng các bản phân phối phổ biến:
        | Dòng họ  | Bảng phân phối phổ biến      | Công cụ quản lý gói | Đặc điểm nổi bật | Đối tượng sử dụng |
        |----------|------------------------------|---------------------|------------------|------------------|
        | Debian   | Ubuntu, Kubuntu, Xubuntu     | APT                 | Ổn định, dễ sử dụng | Người mới bắt đầu, máy chủ |
        | Red Hat  | Fedora, CentOS, RHEL         | YUM                 | Cập nhật nhanh, hỗ trợ doanh nghiệp | Doanh nghiệp, máy chủ |
        | SUSE     | openSUSE                     | Zypper              | Ổn định, dễ sử dụng | Người mới bắt đầu, máy chủ |
        | Arch     | Arch Linux, Manjaro           | Pacman              | Cập nhật liên tục, tối ưu hóa | Người dùng nâng cao, máy tính cá nhân |

### 2. Tại sao nên học Linux?
- Ứng dụng rộng rãi trong hạ tầng server, cloud, DevOps, AI, lập trình hệ thống: 
    - Linux chiếm thị phần lớn trong các máy chủ web, cơ sở dữ liệu, và các dịch vụ đám mây.
    - Các công cụ DevOps phổ biến như Docker, Kubernetes, Jenkins đều chạy tốt trên Linux.
    - Nhiều dự án AI và học máy sử dụng Linux để triển khai mô hình và xử lý dữ liệu.
- Sự khác biệt giữa Linux và Windows/macOS:
    | Tiêu chí         | Linux                          | Windows                       | macOS                        |
    |------------------|--------------------------------|-------------------------------|------------------------------|
    | Mã nguồn          | Mã nguồn mở (Open Source)      | Mã nguồn đóng (Closed Source)     | Mã nguồn đóng (Closed Source) |
    | Chi phí           | Miễn phí                       | Có chi phí                     | Có chi phí                    |
    | Tính ổn định      | Rất ổn định                    | Ổn định                        | Ổn định                        |
    | Tính dễ sử dụng   | Trung bình                     | Dễ sử dụng                      | Dễ sử dụng                     |
    | Hỗ trợ cộng đồng  | Rất tốt                        | Tốt                            | Trung bình                     |
    | Hệ sinh thái       | Rộng rãi                        | Hạn chế                        | Hạn chế                        |

- Ưu điểm của Linux:
    - Bảo mật: Linux có cơ chế quản lý quyền truy cập và bảo mật tốt, ít bị tấn công bởi virus và malware.
    - Miễn phí: Hầu hết các bản phân phối Linux đều miễn phí, giúp tiết kiệm chi phí phần mềm.
    - Tùy biến: Người dùng có thể tùy chỉnh hệ thống theo nhu cầu, từ giao diện đến chức năng.
    - Hiệu suất cao: Linux thường tiêu thụ ít tài nguyên hơn so với Windows, phù hợp cho các máy chủ và hệ thống nhúng.

### 3. Kiến trúc hệ thống Linux
- Linux có kiến trúc phân tầng, bao gồm:
    - Kernel: Nhân của hệ điều hành, quản lý tài nguyên phần cứng và cung cấp các dịch vụ cơ bản cho các ứng dụng.
    - Shell: Giao diện dòng lệnh (CLI) hoặc giao diện đồ họa (GUI) cho phép người dùng tương tác với hệ thống.
    - Application layer: Các ứng dụng và dịch vụ chạy trên hệ điều hành, bao gồm trình duyệt web, trình soạn thảo văn bản, cơ sở dữ liệu, v.v.
- Quá trình khởi động (boot process) cơ bản:
    1. BIOS/UEFI: Kiểm tra phần cứng và tải bootloader.
    2. Bootloader: Tải kernel vào bộ nhớ và chuyển quyền điều khiển cho kernel.
    3. Kernel: Khởi tạo các thiết bị phần cứng và hệ thống tập tin, sau đó khởi động init/systemd.
    4. Init/Systemd: Khởi động các dịch vụ và tiến trình cần thiết, cuối cùng đưa hệ thống vào trạng thái sẵn sàng cho người dùng.
- Các thư mục hệ thống chính:
    - `/bin`: Chứa các lệnh cơ bản cần thiết cho hệ thống và người dùng.
    - `/etc`: Chứa các tập tin cấu hình hệ thống.
    - `/home`: Chứa thư mục cá nhân của người dùng.
    - `/usr`: Chứa các ứng dụng và thư viện phần mềm.
    - `/var`: Chứa các tập tin thay đổi thường xuyên, như log, spool, và dữ liệu tạm thời.
    - `/tmp`: Chứa các tập tin tạm thời được tạo ra bởi hệ thống và người dùng.

## Phần 2. Làm quen với Terminal và Shell
### 4. Terminal & Shell là gì?
- Terminal: Giao diện dòng lệnh (Command Line Interface - CLI) cho phép người dùng nhập lệnh và nhận kết quả từ hệ điều hành.
- Shell: Chương trình trung gian giữa người dùng và kernel, chịu trách nhiệm nhận lệnh từ người dùng, thực thi chúng và trả về kết quả. Một số shell phổ biến:
    - Bash (Bourne Again Shell): Shell mặc định trên nhiều bản phân phối Linux.
    - Zsh (Z Shell): Shell nâng cao với nhiều tính năng tiện ích.
    - Fish (Friendly Interactive Shell): Shell thân thiện với người dùng, dễ sử dụng.
- Mở terminal và chạy lệnh cơ bản:
    - Trên Ubuntu: Nhấn `Ctrl + Alt + T` để mở terminal.
    - Trên CentOS: Nhấn `Ctrl + Alt + T` hoặc tìm kiếm "Terminal" trong menu ứng dụng.
    - Chạy lệnh cơ bản: `ls`, `pwd`, `cd`, `echo "Hello, Linux!"`.

### 5. Lệnh cơ bản trong Linux
- `pwd`: Hiển thị đường dẫn hiện tại.
- `ls`: Liệt kê các tập tin và thư mục trong thư mục hiện tại
    - `ls -l`: Hiển thị chi tiết các tập tin và thư mục.
    - `ls -a`: Hiển thị cả các tập tin ẩn (bắt đầu bằng dấu chấm).
- `cd`: Thay đổi thư mục hiện tại.
    - `cd /path/to/directory`: Chuyển đến thư mục cụ thể.
    - `cd ..`: Quay lại thư mục cha.
    - `cd ~`: Quay về thư mục home của người dùng.
- `clear`: Xóa màn hình terminal.
- `history`: Hiển thị danh sách các lệnh đã thực hiện trước đó.

- Sử dụng phím tắt:
    - `Tab`: Tự động hoàn thành tên tập tin hoặc thư mục.
    - `Ctrl + C`: Dừng lệnh đang chạy.
    - `Ctrl + D`: Đăng xuất khỏi terminal hoặc kết thúc phiên shell.
    - `Ctrl + Insert`: Sao chép nội dung từ terminal vào clipboard.
    - `Shift + Insert`: Dán nội dung từ clipboard vào terminal.

### 6. Hiểu cấu trúc đường dẫn
- Đường dẫn tuyệt đối (Absolute Path): Là đường dẫn bắt đầu từ thư mục gốc `/`, ví dụ: `/home/user/Documents/file.txt`.
- Đường dẫn tương đối (Relative Path): Là đường dẫn bắt đầu từ thư mục hiện tại, ví dụ: `Documents/file.txt` nếu bạn đang ở trong thư mục `/home/user/` thì đường dẫn tương đối sẽ trỏ đến `/home/user/Documents/file.txt`.
- Dấu `~`: Đại diện cho thư mục home của người dùng hiện tại, ví dụ: `~/Documents` sẽ trỏ đến `/home/user/Documents`.
- Dấu `.`: Đại diện cho thư mục hiện tại, ví dụ: `./script.sh` sẽ chạy tập tin `script.sh` trong thư mục hiện tại.
- Dấu `..`: Đại diện cho thư mục cha, ví dụ: `../file.txt` sẽ trỏ đến tập tin `file.txt` trong thư mục cha của thư mục hiện tại.

## Phần 3. Làm việc với file và thư mục
### 7. Tạo, xem, xóa và di chuyển file
- Tạo file:
    - `touch filename.txt`: Tạo một tập tin rỗng có tên `filename.txt`.
- Xem file:
    - `cat filename.txt`: Hiển thị nội dung của tập tin `filename.txt`.
    - `less filename.txt`: Xem nội dung của tập tin `filename.txt` theo chế độ phân trang.
- Xóa file:
    - `rm filename.txt`: Xóa tập tin `filename.txt`.
- Di chuyển file:
    - `mv old_filename.txt new_filename.txt`: Đổi tên tập tin từ `old_filename.txt` thành `new_filename.txt`.
    - `mv filename.txt /path/to/destination/`: Di chuyển tập tin `filename.txt` đến thư mục `/path/to/destination/`.
- Tạo thư mục:
    - `mkdir new_directory`: Tạo một thư mục mới có tên `new_directory`.
- Xóa thư mục:
    - `rmdir directory_name`: Xóa thư mục rỗng có tên `directory_name`.
- Xóa thư mục và tất cả nội dung bên trong:
    - `rm -r directory_name`: Xóa thư mục `directory_name` và tất cả các tập tin và thư mục con bên trong.
- Di chuyển thư mục:
    - `mv old_directory /path/to/destination/`: Di chuyển thư mục `old_directory` đến thư mục `/path/to/destination/`.
- Copy thư mục:
    - `cp -r source_directory destination_directory`: Sao chép thư mục `source_directory` và tất cả nội dung bên trong đến `destination_directory`.

### 8. Sao chép và nén file
- Nén file:
    - `tar -cvf archive.tar file1 file2`: Tạo một tập tin nén `archive.tar` chứa `file1` và `file2`.
    - `tar -xvf archive.tar`: Giải nén tập tin `archive.tar`.
    - `gzip file.txt`: Nén tập tin `file.txt` thành `file.txt.gz`.
    - `gunzip file.txt.gz`: Giải nén tập tin `file.txt.gz` thành `file.txt`.
    - `zip archive.zip file1 file2`: Tạo một tập tin nén `archive.zip` chứa `file1` và `file2`.
    - `unzip archive.zip`: Giải nén tập tin `archive.zip`.
    - `scp file.txt user@remote_host:/path/to/destination/`: Sao chép tập tin `file.txt` từ máy cục bộ đến máy chủ từ xa `remote_host`.
- Giải thích khái niệm stream:
    - `stdin`: Standard Input, luồng dữ liệu đầu vào từ người dùng hoặc từ một chương trình khác.
    - `stdout`: Standard Output, luồng dữ liệu đầu ra từ chương trình đến màn hình hoặc một tập tin.
    - `stderr`: Standard Error, luồng dữ liệu lỗi từ chương trình đến màn hình hoặc một tập tin.

### 9. Tìm kiếm file
- `find`: Tìm kiếm tập tin và thư mục dựa trên tên, loại, kích thước, ngày tạo, quyền truy cập, v.v.
    - Ví dụ: `find /path/to/search -name "filename.txt"` sẽ tìm kiếm tập tin có tên `filename.txt` trong thư mục `/path/to/search`.
- `locate`: Tìm kiếm tập tin nhanh chóng dựa trên cơ sở dữ liệu đã được lập chỉ mục trước đó.
    - Ví dụ: `locate filename.txt` sẽ tìm kiếm tập tin có tên ` filename.txt` trong cơ sở dữ liệu.
- `grep`: Tìm kiếm nội dung trong tập tin dựa trên từ khóa hoặc biểu thức chính quy (regex).
    - Ví dụ: `grep "keyword" filename.txt` sẽ tìm kiếm từ khóa "keyword" trong tập tin `filename.txt`.

- Kết hợp `grep` với `pipe (|)`:
    - pipe (`|`) cho phép kết quả của một lệnh được truyền trực tiếp làm đầu vào cho lệnh tiếp theo.
    - Khi kết hợp `grep` với `pipe`, bạn có thể lọc kết quả từ một lệnh khác. Ví dụ:
        - `ls -l | grep "filename"`: Liệt kê các tập tin và thư mục trong thư mục hiện tại, sau đó lọc ra các dòng chứa từ khóa "filename".
        - `cat file.txt | grep "keyword"`: Hiển thị nội dung của `file.txt` và lọc ra các dòng chứa từ khóa "keyword".
        - `ps aux | grep "process_name"`: Hiển thị danh sách các tiến trình đang chạy và lọc ra các tiến trình có tên chứa "process_name".
        - `dmesg | grep "error"`: Hiển thị các thông điệp hệ thống và lọc ra các dòng chứa từ khóa "error".

### Phần 4. Quyền truy cập và người dùng
### 10. Người dùng và nhóm (User & Group)
- `whoami`: Hiển thị tên người dùng hiện tại.
- `id`: Hiển thị thông tin về người dùng hiện tại, bao gồm UID, GID và các nhóm mà người dùng thuộc về.
- `adduser username`: Tạo một người dùng mới với tên `username`.
- `deluser username`: Xóa người dùng có tên `username`.
- `su`: Chuyển đổi sang người dùng khác, thường là root. Ví dụ: `su - username` sẽ chuyển sang người dùng `username`.
- `sudo`: Thực thi lệnh với quyền của người dùng khác, thường là root. Ví dụ: `sudo apt update` sẽ cập nhật danh sách gói phần mềm với quyền root.
- `/etc/passwd`: Tập tin chứa thông tin về người dùng trên hệ thống, bao gồm tên người dùng, UID, GID, thư mục home và shell mặc định.
### 11. Phân quyền file
- `ls -l`: Hiển thị chi tiết các tập tin và thư mục, bao gồm quyền truy cập.
    - Ví dụ: `-rw-r--r--` có nghĩa là:
        - Chủ sở hữu (owner) có quyền đọc và ghi (rw-).
        - Nhóm (group) có quyền đọc (r--).
        - Người khác (others) có quyền đọc (r--).
- Quyền đọc/ghi/thực thi (`rwx`):
    - `r` (read): Quyền đọc tập tin hoặc liệt kê thư mục
    - `w` (write): Quyền ghi tập tin hoặc tạo/xóa tập tin trong thư mục
    - `x` (execute): Quyền thực thi tập tin hoặc truy cập vào thư mục
    - `-` (no permission): Không có quyền truy cập
    - Quyền đọc/ghi/thực thi được biểu diễn bằng các ký tự `r`, `w`, `x` trong chuỗi quyền truy cập, ví dụ: `-rw-r--r--` có nghĩa là chủ sở hữu có quyền đọc và ghi, nhóm có quyền đọc, và người khác cũng có quyền đọc.
    - Quyền đọc/ghi/thực thi lưu trữ trong hệ thống Linux bằng 3 bit nhị phân, mỗi bit đại diện cho một quyền truy cập. Ví dụ: `rwx` được biểu diễn bằng `111`, `rw-` được biểu diễn bằng `110`, và `r--` được biểu diễn bằng `100`.
- `chmod`: Thay đổi quyền truy cập của tập tin hoặc thư mục.
    - 3 kí tự số đại diện cho quyền truy cập của chủ sở hữu, nhóm và người khác được biểu diễn bằng octal của chuỗi nhị phân ứng với quyền truy cập `rwx`. Ví dụ: `chmod 755 filename.txt` sẽ đặt quyền truy cập cho `filename.txt` là `rwxr-xr-x`.
    - Ví dụ: `chmod 755 filename.txt` sẽ đặt quyền truy cập cho `filename.txt` là `rwxr-xr-x`.
- `chown`: Thay đổi chủ sở hữu của tập tin hoặc thư mục.
    - Ví dụ: `chown user:group filename.txt` sẽ thay đổi chủ sở hữu của `filename.txt` thành `user` và nhóm thành `group`.
- `chgrp`: Thay đổi nhóm của tập tin hoặc thư mục.
    - Ví dụ: `chgrp groupname filename.txt` sẽ thay đổi nhóm của `filename.txt` thành `groupname`.
### 12. Quyền root và an toàn
- Tại sao không nên chạy mọi thứ bằng root:
    - Chạy mọi thứ bằng root có thể gây ra rủi ro bảo mật, vì nếu một lệnh hoặc chương trình bị lỗi hoặc bị tấn công, nó có thể gây hại cho toàn bộ hệ thống.
    - Root có quyền truy cập đầy đủ vào tất cả các tập tin và thư mục trên hệ thống, vì vậy việc sử dụng root không cẩn thận có thể dẫn đến mất dữ liệu hoặc hỏng hệ thống.
- Phân biệt `sudo` và `su`:
    - `sudo`: Cho phép người dùng thực thi một lệnh với quyền của người dùng khác, thường là root, mà không cần chuyển đổi hoàn toàn sang người dùng đó. Ví dụ: `sudo apt update` sẽ cập nhật danh sách gói phần mềm với quyền root.
    - `su`: Cho phép người dùng chuyển đổi hoàn toàn sang người dùng khác, thường là root, và tất cả các lệnh tiếp theo sẽ được thực thi với quyền của người dùng đó. Ví dụ: `su - username` sẽ chuyển sang người dùng `username`, và tất cả các lệnh tiếp theo sẽ được thực thi với quyền của `username`.

## Phần 5. Quản lý tiến trình và hệ thống
### 13. Quản lý tiến trình (process)
- `ps`: Hiển thị danh sách các tiến trình đang chạy trên hệ thống.
    - `top`: Hiển thị thông tin về các tiến trình đang chạy theo thời gian thực, bao gồm CPU và bộ nhớ sử dụng.
    - `htop`: Phiên bản nâng cao của `top`, cung cấp giao diện người dùng thân thiện hơn và nhiều tính năng hơn.
    - `kill`: Gửi tín hiệu để dừng hoặc kết thúc một tiến trình. Ví dụ: `kill -9 PID` sẽ kết thúc tiến trình với ID là PID.
    - `pkill`: Dừng hoặc kết thúc tiến trình dựa trên tên thay vì PID. Ví dụ: `pkill process_name` sẽ kết thúc tất cả các tiến trình có tên là `process_name`.
    - `nice` và `renice`: Thay đổi mức độ ưu tiên của tiến trình. Ví dụ: `nice -n 10 command` sẽ chạy lệnh với mức độ ưu tiên thấp hơn, trong khi `renice -n 5 -p PID` sẽ thay đổi mức độ ưu tiên của tiến trình với ID là PID.
- `jobs`: Hiển thị danh sách các tiến trình đang chạy trong nền (background) của shell hiện tại.
- Foreground và background process:
    - Foreground process: Là tiến trình đang chạy trong terminal hiện tại và chiếm quyền điều khiển của terminal. Người dùng không thể nhập lệnh khác cho đến khi tiến trình kết thúc.
    - Background process: Là tiến trình chạy trong nền, cho phép người dùng tiếp tục sử dụng terminal để thực hiện các lệnh khác. Để chạy một tiến trình trong nền, bạn có thể thêm ký tự `&` vào cuối lệnh, ví dụ: `command &`.
    - `fg`: Chuyển một tiến trình từ background sang foreground. Ví dụ: `fg %1` sẽ đưa tiến trình có ID là 1 từ background sang foreground.
    - `bg`: Chuyển một tiến trình từ foreground sang background. Ví dụ: `bg %1` sẽ đưa tiến trình có ID là 1 từ foreground sang background.

### 14. Kiểm tra tài nguyên hệ thống
- `free`: Hiển thị thông tin về bộ nhớ RAM và swap trên hệ thống.
- `df`: Hiển thị thông tin về không gian đĩa đã sử dụng và còn trống.
- `du`: Hiển thị thông tin về dung lượng sử dụng của các tập tin và thư mục.
- `uptime`: Hiển thị thời gian hoạt động của hệ thống và tải trung bình.
- `uname`: Hiển thị thông tin về hệ điều hành và kernel.
- `lscpu`: Hiển thị thông tin chi tiết về CPU, bao gồm số lõi, kiến trúc, tốc độ xung nhịp và các tính năng hỗ trợ.
- `lsblk`: Hiển thị thông tin về các thiết bị lưu trữ khối, bao gồm ổ cứng, SSD, USB và các phân vùng của chúng.

### 15. Dịch vụ (service) và tiến trình nền (daemon)
- `systemctl`: Quản lý các dịch vụ và tiến trình nền trên hệ thống sử dụng systemd. Ví dụ: `systemctl start service_name` sẽ khởi động dịch vụ có tên là `service_name`.
- `service`: Quản lý các dịch vụ trên hệ thống sử dụng init. Ví dụ: `service service_name start` sẽ khởi động dịch vụ có tên là `service_name`.
- `journalctl`: Hiển thị các thông điệp log từ systemd journal. Ví dụ: `journalctl -u service_name` sẽ hiển thị các thông điệp log liên quan đến dịch vụ có tên là `service_name`.
- Start/stop/restart dịch vụ:
    - `systemctl start service_name`: Khởi động dịch vụ.
    - `systemctl stop service_name`: Dừng dịch vụ.
    - `systemctl restart service_name`: Khởi động lại dịch vụ.
    - `systemctl status service_name`: Kiểm tra trạng thái của dịch vụ.

## Phần 6. Quản lý gói phần mềm
### 16. Trình quản lý gói (Package Manager)
- Trình quản lý gói là công cụ giúp người dùng cài đặt, cập nhật và gỡ bỏ phần mềm trên hệ thống Linux. Các trình quản lý gói phổ biến bao gồm:
    - APT (Advanced Package Tool): Dùng cho các bản phân phối dựa trên Debian, như Ubuntu. Ví dụ: `sudo apt install package_name` để cài đặt gói.
        - APT-GET là một công cụ dòng lệnh để quản lý các gói phần mềm trên hệ thống Debian và Ubuntu. Nó cho phép người dùng cài đặt, nâng cấp, gỡ bỏ và quản lý các gói phần mềm từ kho lưu trữ của hệ thống. Ví dụ: `sudo apt-get update` để cập nhật danh sách các gói phần mềm, và `sudo apt-get upgrade` để nâng cấp các gói phần mềm đã cài đặt.
    - YUM (Yellowdog Updater, Modified): Dùng cho các bản phân phối dựa trên Red Hat, như CentOS. Ví dụ: `sudo yum install package_name` để cài đặt gói.
    - DNF (Dandified YUM): Phiên bản mới của YUM, được sử dụng trong Fedora và các bản phân phối mới hơn của Red Hat. Ví dụ: `sudo dnf install package_name`.
    - Zypper: Dùng cho các bản phân phối dựa trên SUSE, như openSUSE. Ví dụ: `sudo zypper install package_name`.
    - Pacman: Dùng cho Arch Linux và các bản phân phối dựa trên Arch. Ví dụ: `sudo pacman -S package_name`.
- Tất cả các trình quản lý gói đều phải được chạy với quyền root hoặc sử dụng `sudo` để cài đặt, cập nhật hoặc gỡ bỏ phần mềm trên hệ thống.
### 17. Cài đặt và gỡ bỏ phần mềm
- Cài đặt phần mềm (trên hệ thống Debian/Ubuntu):
    - `sudo apt install package_name`: Cài đặt gói phần mềm trên hệ thống Debian/Ubuntu.
    - `sudo apt remove package_name`: Gỡ bỏ gói phần mềm trên hệ thống Debian/Ubuntu.
    - `sudo apt update`: Cập nhật danh sách các gói phần mềm từ kho lưu trữ.
    - `sudo apt upgrade`: Nâng cấp tất cả các gói phần mềm đã cài đặt lên phiên bản mới nhất.
- Kiểm tra package đang cài đặt:
    - `dpkg -l`: Liệt kê tất cả các gói phần mềm đã cài đặt trên hệ điều hành.

### 18. Tạo và sử dụng alias
- Alias là một cách để tạo lệnh tắt hoặc thay thế cho các lệnh dài hoặc phức tạp trong shell. Người dùng có thể tạo alias để tiết kiệm thời gian và tăng hiệu quả khi làm việc với terminal.
- Tạo lệnh tắt trong file `~/.bashrc`:
    - Mở file `~/.bashrc` bằng trình soạn thảo văn bản, ví dụ: `nano ~/.bashrc`.
    - Thêm dòng sau vào cuối file để tạo alias:
        ```bash
        alias ll='ls -alF'
        ```
    - Lưu và thoát khỏi trình soạn thảo (với nano thì nhấn Ctrl+X, sau đó nhấn Y để lưu và Enter để thoát).
    - Chạy lệnh `source ~/.bashrc` để áp dụng các thay đổi.
- Sử dụng alias:
    - Sau khi tạo alias, bạn có thể sử dụng lệnh tắt thay vì gõ lệnh dài. Ví dụ, thay vì gõ `ls -alF`, bạn chỉ cần gõ `ll` để liệt kê các tập tin và thư mục với định dạng chi tiết.
    - Bạn có thể tạo nhiều alias khác nhau cho các lệnh mà bạn thường xuyên sử dụng, giúp tăng tốc độ làm việc trên terminal.
## Phần 7. Làm việc với mạng (Networking)
### 19. Kiến thức cơ bản về mạng
- Mạng máy tính là hệ thống kết nối các thiết bị để chia sẻ dữ liệu và tài nguyên. Các thành phần cơ bản của mạng bao gồm:
    - Thiết bị mạng: Router, Switch, Hub, Access Point.
    - Giao thức mạng: TCP/IP, UDP, HTTP, HTTPS, FTP, SSH.
    - Địa chỉ IP: IPv4 (32-bit) và IPv6 (128-bit).
    - Subnetting: Phân chia mạng con để quản lý địa chỉ IP hiệu quả.
- Mô hình TCP/IP và OSI:
    - Mô hình TCP/IP: Gồm 4 tầng (Application, Transport, Internet, Network Access).
    - Mô hình OSI: Gồm 7 tầng (Physical, Data Link, Network, Transport, Session, Presentation, Application).
### 20. Địa chỉ IP, Subnet và CIDR
- Địa chỉ IP (IP Address): Là một địa chỉ duy nhất được gán cho mỗi thiết bị trong mạng để nhận dạng và giao tiếp với nhau. Có hai loại địa chỉ IP chính:
    - IPv4: Địa chỉ 32-bit, ví dụ: `192.168.1.1`, `127.0.0.1`.
    - IPv4 có thể được biểu diễn dưới dạng thập phân với 4 octet, mỗi octet có giá trị từ 0 đến 255, và được phân tách bằng dấu chấm.
    - IPv6: Địa chỉ 128-bit, ví dụ: `2001:0db8:85a3:0000:0000:8a2e:0370:7334` hay viết gọn là `2001:db8:85a3::8a2e:370:7334`.
    - IPv6 được biểu diễn dưới dạng thập lục phân với 8 nhóm, mỗi nhóm có 4 ký tự, và được phân tách bằng dấu hai chấm. Các nhóm liên tiếp có giá trị bằng 0 có thể được rút gọn bằng cách sử dụng `::`.
- Subnet: Là một phần của mạng lớn hơn, được tạo ra bằng cách chia nhỏ mạng thành các mạng con để quản lý địa chỉ IP hiệu quả hơn. Subnet giúp giảm lưu lượng mạng và tăng tính bảo mật.
    - Ví dụ: Mạng `192.168.1.0/24` có thể được chia thành các subnet nhỏ hơn như `192.168.1.0/26`, `192.168.1.64/26`, v.v.
- CIDR (Classless Inter-Domain Routing): Là phương pháp phân bổ địa chỉ IP và định tuyến mạng mà không dựa vào các lớp mạng truyền thống (Class A, B, C). CIDR sử dụng ký hiệu `/n` để chỉ định số bit của phần mạng trong địa chỉ IP.
- Lưu ý:
    - Địa chỉ IP và Subnet phải được cấu hình đúng để các thiết bị trong mạng có thể giao tiếp với nhau.
    - CIDR giúp tối ưu hóa việc sử dụng địa chỉ IP và giảm lãng phí địa chỉ.
    - Việc xây dựng Subnet phải dựa trên tiền đề về số lượng thiết bị trong mạng và yêu cầu bảo mật, hiệu suất.
### 21. Gateway, Routing và DNS
- Gateway: Là thiết bị mạng (thường là router) cho phép các thiết bị trong mạng nội bộ kết nối và giao tiếp với các mạng khác, bao gồm Internet. Gateway thường được cấu hình với địa chỉ IP của mạng nội bộ và địa chỉ IP của mạng bên ngoài.
    - Ví dụ: Nếu mạng nội bộ có địa chỉ `192.168.1.x`, gateway thường có địa chỉ trùng với địa chỉ IP của router, ví dụ: `192.168.1.1`.
    - Lưu ý: Gateway không phải là router, nhưng router có thể hoạt động như một gateway. Gateway giúp định tuyến lưu lượng mạng từ mạng nội bộ ra ngoài và ngược lại.
- Routing: Là quá trình xác định đường đi tốt nhất cho dữ liệu từ nguồn đến đích trong mạng. Routing được thực hiện bởi các thiết bị mạng như router, sử dụng các bảng định tuyến để quyết định đường đi của gói dữ liệu.
    - Các giao thức định tuyến phổ biến: RIP (Routing Information Protocol), OSPF (Open Shortest Path First), BGP (Border Gateway Protocol).
    - Lưu ý: Routing giúp tối ưu hóa việc truyền dữ liệu trong mạng và đảm bảo rằng dữ liệu đến đúng đích một cách hiệu quả.
- DNS (Domain Name System): Là hệ thống tên miền giúp chuyển đổi tên miền (ví dụ: `www.google.com`) thành địa chỉ IP (ví dụ: `142.250.191.14`). DNS giúp người dùng dễ dàng truy cập vào các trang web mà không cần nhớ địa chỉ IP.
    - Lưu ý: DNS là một phần quan trọng trong việc kết nối các thiết bị trong mạng và Internet, giúp người dùng dễ dàng truy cập vào các trang web và dịch vụ trực tuyến.

### 22. Lệnh kiểm tra mạng
- `ping`: Kiểm tra kết nối mạng giữa máy tính của bạn và một địa chỉ IP hoặc tên miền. Ví dụ: `ping google.com` sẽ gửi các gói tin ICMP đến máy chủ của Google và hiển thị thời gian phản hồi.
- `ifconfig`: Hiển thị thông tin cấu hình mạng của các giao diện mạng trên hệ thống. Ví dụ: `ifconfig` sẽ liệt kê các giao diện mạng, địa chỉ IP, MAC address và trạng thái kết nối.
- `ip addr`: Hiển thị thông tin về các giao diện mạng và địa chỉ IP của chúng. Ví dụ: `ip addr show` sẽ liệt kê tất cả các giao diện mạng và địa chỉ IP tương ứng.
- `netstat`: Hiển thị thông tin về các kết nối mạng, bảng định tuyến và các thống kê giao thức mạng. Ví dụ: `netstat -tuln` sẽ liệt kê tất cả các kết nối TCP và UDP đang lắng nghe trên hệ thống.
- `ss`: Hiển thị thông tin về các kết nối mạng và socket trên hệ thống. Ví dụ: `ss -tuln` sẽ liệt kê tất cả các kết nối TCP và UDP đang lắng nghe trên hệ thống.
- `traceroute`: Hiển thị đường đi của các gói tin từ máy tính của bạn đến một địa chỉ IP hoặc tên miền, giúp xác định các nút trung gian và thời gian phản hồi. Ví dụ: `traceroute google.com` sẽ hiển thị các bước mà gói tin đi qua để đến máy chủ của Google.
- `curl`: Dùng để gửi yêu cầu HTTP và nhận dữ liệu từ một URL. Ví dụ: `curl http://example.com` sẽ hiển thị nội dung của trang web `example.com`.\
- `wget`: Dùng để tải xuống các tập tin từ Internet thông qua giao thức HTTP, HTTPS hoặc FTP. Ví dụ: `wget http://example.com/file.zip` sẽ tải tập tin `file.zip` từ trang web `example.com`.

### 23. Kết nối SSH và truyền file
- SSH (Secure Shell): Là giao thức mạng cho phép kết nối an toàn đến một máy chủ từ xa thông qua mạng không an toàn. SSH sử dụng mã hóa để bảo vệ dữ liệu truyền giữa máy khách và máy chủ, giúp ngăn chặn việc nghe lén và tấn công từ bên ngoài.
    - Cài đặt SSH server:
        - Trên Ubuntu/Debian: `sudo apt install openssh-server`
        - Trên CentOS/RHEL: `sudo yum install openssh-server`
    - Khởi động dịch vụ SSH:
        - Trên Ubuntu/Debian: `sudo systemctl start ssh`
        - Trên CentOS/RHEL: `sudo systemctl start sshd`
    - Kết nối SSH từ máy khách:
        - Sử dụng lệnh: `ssh username@remote_host`, trong đó `username` là tên người dùng trên máy chủ từ xa và `remote_host` là địa chỉ IP hoặc tên miền của máy chủ.
    - SFTP (Secure File Transfer Protocol): Là giao thức dùng để truyền file an toàn giữa máy khách và máy chủ thông qua SSH. SFTP cung cấp các lệnh để quản lý tập tin và thư mục trên máy chủ từ xa, bao gồm tải lên, tải xuống, xóa và đổi tên tập tin.
- SCP (Secure Copy Protocol): Là giao thức dùng để truyền file an toàn giữa máy khách và máy chủ thông qua SSH. SCP sử dụng mã hóa để bảo vệ dữ liệu trong quá trình truyền, giúp ngăn chặn việc nghe lén và tấn công từ bên ngoài.
    - Cài đặt SCP:
        - Trên Ubuntu/Debian: `sudo apt install openssh-client`
        - Trên CentOS/RHEL: `sudo yum install openssh-clients`
    - Truyền file từ máy khách đến máy chủ:
        - Sử dụng lệnh: `scp /path/to/local/file username@remote_host:/path/to/remote/destination`, trong đó `/path/to/local/file` là đường dẫn đến tập tin trên máy khách, `username` là tên người dùng trên máy chủ từ xa, `remote_host` là địa chỉ IP hoặc tên miền của máy chủ, và `/path/to/remote/destination` là đường dẫn đến thư mục đích trên máy chủ.
    - Truyền file từ máy chủ đến máy khách:
        - Sử dụng lệnh: `scp username@remote_host:/path/to/remote/file /path/to/local/destination`, trong đó `/path/to/remote/file` là đường dẫn đến tập tin trên máy chủ, và `/path/to/local/destination` là đường dẫn đến thư mục đích trên máy khách.
- `rsync`: Là công cụ dùng để đồng bộ hóa và truyền file giữa máy khách và máy chủ, hỗ trợ truyền dữ liệu qua SSH. `rsync` chỉ truyền những phần thay đổi của tập tin, giúp tiết kiệm băng thông và thời gian.
    - Cài đặt rsync:
        - Trên Ubuntu/Debian: `sudo apt install rsync`
        - Trên CentOS/RHEL: `sudo yum install rsync`
    - Đồng bộ hóa thư mục từ máy khách đến máy chủ:
        - Sử dụng lệnh: `rsync -avz /path/to/local/directory/ username@remote_host:/path/to/remote/directory/`, trong đó `/path/to/local/directory/` là đường dẫn đến thư mục trên máy khách, `username` là tên người dùng trên máy chủ từ xa, `remote_host` là địa chỉ IP hoặc tên miền của máy chủ, và `/path/to/remote/directory/` là đường dẫn đến thư mục đích trên máy chủ.
    - Đồng bộ hóa thư mục từ máy chủ đến máy khách:
        - Sử dụng lệnh: `rsync -avz username@remote_host:/path/to/remote/directory/ /path/to/local/directory/`, trong đó `/path/to/remote/directory/` là đường dẫn đến thư mục trên máy chủ, và `/path/to/local/directory/` là đường dẫn đến thư mục đích trên máy khách.

- SSH key-based authentication: Là phương pháp xác thực không cần mật khẩu, sử dụng cặp khóa công khai và riêng tư để xác thực người dùng. Khi sử dụng SSH key-based authentication, người dùng tạo một cặp khóa (public key và private key) và lưu public key trên máy chủ từ xa. Khi kết nối, máy chủ sẽ kiểm tra public key và xác thực người dùng mà không yêu cầu nhập mật khẩu.
    - Tạo cặp khóa SSH:
        - Sử dụng lệnh `ssh-keygen -t <key-type> -b <key-size> -C "key-info"`, trong đó `<key-type>` là loại khóa (ví dụ: rsa, ed25519), `<key-size>` là độ dài khóa (ví dụ: 2048, 4096), và `"key-info"` là chú thích cho khóa.
        - Với chuẩn RSA: `ssh-keygen -t rsa -b 4096 -C "key-info"`, trong đó `-t rsa` chỉ định loại khóa RSA, `-b 4096` chỉ định độ dài khóa 4096 bit, và `-C "key-info"` thêm một chú thích cho khóa.
        - Với chuẩn Ed25519: `ssh-keygen -t ed25519 -C "key-info"`, trong đó `-t ed25519` chỉ định loại khóa Ed25519 và `-C "key-info"` thêm một chú thích cho khóa.
    - Lưu ý: Khi tạo cặp khóa, người dùng sẽ được yêu cầu nhập mật khẩu bảo vệ private key. Mật khẩu này giúp bảo vệ private key khỏi việc bị sử dụng trái phép nếu nó bị lộ.
    - `ssh-copy-id`: Là công cụ dùng để sao chép public key từ máy khách đến máy chủ từ xa, giúp thiết lập xác thực dựa trên khóa SSH. Khi sử dụng `ssh-copy-id`, public key sẽ được thêm vào tập tin `~/.ssh/authorized_keys` trên máy chủ từ xa, cho phép người dùng kết nối mà không cần nhập mật khẩu.
        - Cách sử dụng: `ssh-copy-id username@remote_host`, trong đó `username` là tên người dùng trên máy chủ từ xa và `remote_host` là địa chỉ IP hoặc tên miền của máy chủ.
        - Lưu ý: Trước khi sử dụng `ssh-copy-id`, người dùng cần đảm bảo rằng dịch vụ SSH đang chạy trên máy chủ từ xa và có quyền truy cập để sao chép public key.

### 24. Kiểm tra và cấu hình firewall
- Firewall: Là hệ thống bảo mật mạng giúp kiểm soát lưu lượng mạng vào và ra khỏi hệ thống, ngăn chặn các kết nối không mong muốn và bảo vệ hệ thống khỏi các cuộc tấn công từ bên ngoài. Firewall có thể được cấu hình để cho phép hoặc chặn các kết nối dựa trên địa chỉ IP, cổng, giao thức và các quy tắc khác.
- Các công cụ quản lý firewall phổ biến:
    - `iptables`: Là công cụ dòng lệnh mạnh mẽ để quản lý firewall trên Linux. `iptables` cho phép người dùng tạo các quy tắc để kiểm soát lưu lượng mạng dựa trên địa chỉ IP, cổng, giao thức và các điều kiện khác.
        - Ví dụ: `sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT` sẽ cho phép lưu lượng TCP đến cổng 22 (SSH) từ bên ngoài.
        - Lưu ý: `iptables` yêu cầu quyền root để thực hiện các thay đổi và có thể phức tạp đối với người mới bắt đầu.
    - `ufw` (Uncomplicated Firewall): Là công cụ quản lý firewall đơn giản hơn, được thiết kế để dễ sử dụng cho người dùng mới. `ufw` cung cấp các lệnh đơn giản để bật/tắt firewall và thêm/xóa các quy tắc.
        - Ví dụ: `sudo ufw enable` sẽ bật firewall, và `sudo ufw allow 22/tcp` sẽ cho phép lưu lượng TCP đến cổng 22 (SSH).
        - Lưu ý: `ufw` là một lớp trừu tượng trên `iptables`, giúp người dùng dễ dàng quản lý firewall mà không cần hiểu sâu về cấu trúc của `iptables`.
    - `firewalld`: Là dịch vụ quản lý firewall động, cung cấp giao diện dòng lệnh và giao diện đồ họa để quản lý các quy tắc firewall. `firewalld` sử dụng khái niệm "zones" để phân loại các kết nối mạng và áp dụng các quy tắc tương ứng.
        - Ví dụ: `sudo firewall-cmd --zone=public --add-port=22/tcp --permanent` sẽ thêm quy tắc cho phép lưu lượng TCP đến cổng 22 trong zone "public".
        - Lưu ý: Sau khi thêm hoặc xóa quy tắc, cần chạy lệnh `sudo firewall-cmd --reload` để áp dụng các thay đổi.
- `ss` và `netstat`: Là các công cụ dòng lệnh để kiểm tra các kết nối mạng và socket trên hệ thống. Chúng giúp người dùng xác định các kết nối đang hoạt động, các cổng đang lắng nghe và các thông tin liên quan đến giao thức mạng.
    - Ví dụ: `ss -tuln` sẽ liệt kê tất cả các kết nối TCP và UDP đang lắng nghe trên hệ thống, trong khi `netstat -tuln` cung cấp thông tin tương tự.
    - Lưu ý: Cả hai công cụ đều yêu cầu quyền root để hiển thị đầy đủ thông tin về các kết nối mạng và socket.
## Phần 8. Script và Automation cơ bản
### 25. Shell script là gì?
- Shell script là một tập tin văn bản chứa các lệnh shell được viết theo cú pháp của shell (như Bash, Zsh, v.v.). Shell script cho phép người dùng tự động hóa các tác vụ lặp đi lặp lại, quản lý hệ thống và thực hiện các công việc phức tạp một cách dễ dàng. Khi chạy shell script, các lệnh trong tập tin sẽ được thực thi theo thứ tự từ trên xuống dưới.
- Cấu trúc cơ bản của một shell script:
```bash
#!/bin/bash #Dòng này chỉ định shell sẽ được sử dụng để thực thi script, trong trường hợp này là Bash.
# Đây là một shell script mẫu
# Các lệnh shell sẽ được viết ở đây
echo "Hello, World!"  # In ra màn hình dòng chữ "Hello, World!"
```
- Cách chạy shell script:
    - Cấp quyền thực thi cho script: `chmod +x script.sh`
    - Chạy script: `./script.sh` hoặc `bash script.sh`

### 26. Biến, vòng lặp và điều kiện trong shell script
- Biến trong shell script là các tên đại diện cho giá trị dữ liệu, có thể là chuỗi, số hoặc kết quả của một lệnh. Biến giúp lưu trữ và quản lý dữ liệu trong quá trình thực thi script.
    - Cách khai báo và sử dụng biến:
        - Khai báo biến: `variable_name="value"`
        - Sử dụng biến: `$variable_name` hoặc `${variable_name}`
        - Ví dụ:
    ```bash
    # Khai báo biến
    name="Alice"
    age=25

    # Sử dụng biến
    echo "Name: $name, Age: $age"
    ```
- Vòng lặp trong shell script cho phép thực hiện một khối lệnh nhiều lần dựa trên điều kiện hoặc danh sách các giá trị. Các loại vòng lặp phổ biến trong shell script bao gồm:
    - Vòng lặp `for`: Dùng để lặp qua một danh sách các giá trị hoặc phạm vi số. Ví dụ:
    ```bash
    for i in {1..5}; do
        echo "Iteration: $i"
    done
    ``` 
    - Vòng lặp `while`: Dùng để lặp khi một điều kiện còn đúng. Ví dụ:
     ```bash
    count=1
    while [ $count -le 5 ]; do
        echo "Count: $count"
        ((count++))
    done
    ```
- Vòng lặp `until`: Dùng để lặp cho đến khi một điều kiện trở thành đúng. Ví dụ:
    ```bash
    count=1
    until [ $count -gt 5 ]; do
        echo "Count: $count"
        ((count++))
    done
    ```
- Cấu trúc điều kiện trong shell script cho phép thực hiện các khối lệnh khác nhau dựa trên kết quả của một điều kiện. Cấu trúc điều kiện phổ biến trong shell script bao gồm:
    - Cấu trúc `if-then`: Dùng để kiểm tra một điều kiện và thực hiện các khối lệnh khác nhau dựa trên kết quả. Ví dụ:
    ```bash
    if [ $age -ge 18 ]; then
        echo "You are an adult."
    else
        echo "You are a minor."
    fi
    ```
- Biến môi trường (environment variables) là các biến được định nghĩa trong hệ thống và có thể được truy cập bởi các tiến trình và shell. Biến môi trường giúp lưu trữ thông tin cấu hình và dữ liệu quan trọng cho hệ thống và ứng dụng.
    - Ví dụ về biến môi trường phổ biến:
        - `PATH`: Chứa danh sách các thư mục mà shell sẽ tìm kiếm khi thực thi lệnh.
        - `HOME`: Chứa đường dẫn đến thư mục home của người dùng hiện tại.
        - `USER`: Chứa tên người dùng hiện tại.
    - Cách xem biến môi trường: Sử dụng lệnh `printenv` hoặc `env`.
    - Cách thiết lập biến môi trường tạm thời: `export VARIABLE_NAME="value"`, ví dụ: `export MY_VAR="Hello"`.
    - Cách thiết lập biến môi trường vĩnh viễn: Thêm dòng `export VARIABLE_NAME="value"` vào file cấu hình shell như `~/.bashrc` hoặc `~/.bash_profile`, sau đó chạy lệnh `source ~/.bashrc` để áp dụng thay đổi.
### 27. Tự động hóa tác vụ với cron
- `cron` là một dịch vụ trên hệ thống Linux dùng để tự động hóa việc thực hiện các tác vụ theo lịch trình định kỳ. `cron` cho phép người dùng lên lịch chạy các lệnh hoặc script vào các thời điểm cụ thể, giúp tiết kiệm thời gian và tăng hiệu quả quản lý hệ thống.
    - Cấu trúc của một cron job:
        ```
        * * * * * command_to_execute
        ```
        Trong đó:
            - Dấu `*` đại diện cho các giá trị thời gian (phút, giờ, ngày trong tháng, tháng, ngày trong tuần).
            - `command_to_execute` là lệnh hoặc script mà bạn muốn thực hiện.
    - Ví dụ về cron job:
        - `0 5 * * * /path/to/script.sh`: Chạy script vào lúc 5:00 sáng hàng ngày.
        - `30 2 * * 1 /path/to/backup.sh`: Chạy script backup vào lúc 2:30 sáng mỗi thứ Hai.
        - `*/10 * * * * /path/to/cleanup.sh`: Chạy script cleanup mỗi 10 phút.
    - Cách chỉnh sửa và lên lịch các cron jobs:
        - Sử dụng lệnh `crontab -e` để mở trình soạn thảo và chỉnh sửa cron jobs cho người dùng hiện tại.
        - Sau khi chỉnh sửa, lưu và thoát khỏi trình soạn thảo để áp dụng các thay đổi.
## Phần 9. Thực hành tổng hợp

- [Mô phỏng giả lập](Simulation.md)