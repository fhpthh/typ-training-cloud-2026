# Tuần 3: Ảo hóa, Container, Docker và Docker Compose

## Phần 1: Tổng quan về ảo hóa

### 1. Ảo hóa là gì?
- Khái niệm ảo hóa.
- Mục đích và vai trò của ảo hóa trong hệ thống CNTT.
- Phân biệt Physical Machine và Virtual Machine.

### 2. Các loại ảo hóa phổ biến
- Ảo hóa máy chủ.
- Ảo hóa hệ điều hành.
- Ảo hóa lưu trữ.
- Ảo hóa mạng.
- Phân biệt Full Virtualization, Para-Virtualization và Hardware-Assisted Virtualization.
- Kiểm tra CPU hỗ trợ ảo hóa (Intel VT-x, AMD-V).

### 3. Hypervisor và các công nghệ ảo hóa
- Hypervisor là gì? Vai trò của Hypervisor.
- Phân biệt Hypervisor Type 1 và Type 2.
- Kể tên các công nghệ ảo hóa phổ biến (VMware ESXi, KVM, Hyper-V, Xen, Proxmox, VirtualBox).

## Phần 2: Virtual Machine

### 4. Tổng quan về Virtual Machine
- Khái niệm Virtual Machine.
- Kiến trúc của một máy ảo.
- Phân biệt Host OS và Guest OS.
- Các thành phần được ảo hóa:
  - CPU (vCPU).
  - Memory (RAM).
  - Disk (Virtual Disk): định dạng vmdk, qcow2, vdi; Thin và Thick provisioning.
  - Network Interface (vNIC): NAT, Bridged, Host-only.
- Cơ chế chia sẻ tài nguyên giữa các VM trên cùng máy vật lý: Overcommit, Reservation, Limit, Share.

### 5. Cơ chế hoạt động của máy ảo
- Nguyên lý hoạt động: Guest OS và hypervisor kiểm soát phần cứng.
- Hardware-Assisted Virtualization: root mode, non-root mode, VM Exit, VM Entry.
- Ảo hóa CPU: lập lịch vCPU lên core vật lý.
- Ảo hóa bộ nhớ: Guest Virtual → Guest Physical → Host Physical, EPT/NPT.
- Ảo hóa I/O: Emulation, Para-virtualization (virtio), PCI Passthrough, SR-IOV.
- Mô hình KVM + QEMU + libvirt.

### 6. Vòng đời và quản lý VM
- Các trạng thái của VM: Created, Running, Paused, Stopped.
- Tạo, khởi động, tắt và xóa máy ảo.
- Cấp phát và điều chỉnh CPU, RAM, Disk.
- Snapshot, Clone và Template.
- Backup và Restore máy ảo.
- Khái niệm Live Migration và High Availability (HA).

### 7. Thực hành quản lý VM
- Kiểm tra CPU hỗ trợ ảo hóa, cài VirtualBox hoặc KVM.
- Tạo VM Ubuntu Server và quan sát tài nguyên ảo (`lscpu`, `free -h`, `lsblk`).
- Tạo Snapshot và Revert.
- Clone VM.
- Điều chỉnh CPU, RAM, Disk.
- Export/Backup, xóa và Restore VM.

## Phần 3: Tổng quan về Container

### 8. Container là gì?
- Khái niệm Container và Containerization.
- Mục đích sử dụng Container trong phát triển và triển khai ứng dụng.
- Phân biệt Container và Virtual Machine.
- Hạn chế của Container và các trường hợp nên sử dụng VM.

### 9. Cơ chế hoạt động của Container trên Linux
- Container sử dụng chung Linux Kernel như thế nào?
- Linux Namespace và vai trò trong việc cô lập tiến trình (pid, net, mnt, uts, ipc, user).
- Control Groups (cgroups): giới hạn CPU và RAM.
- Union Filesystem và OverlayFS, cơ chế Copy-on-Write.
- Phân biệt Container Image và Container Runtime.
- Chuẩn OCI (Image Spec, Runtime Spec).

## Phần 4: Docker cơ bản

### 10. Tổng quan về Docker
- Docker là gì? Tại sao cần Docker?
- Các thành phần của Docker Platform.
- Docker Engine và Docker Desktop.
- Docker CE và các sản phẩm Docker dành cho doanh nghiệp.
- Khái niệm Docker Image, Container, Registry.
- Quy trình cơ bản: Build → Ship → Run.

### 11. Cài đặt và cấu hình Docker trên Linux
- Cài đặt Docker Engine trên Ubuntu.
- Chạy Docker không cần sudo (nhóm `docker`) và lưu ý bảo mật.
- Kiểm tra Docker bằng `docker version`, `docker info`.
- Quản lý dịch vụ Docker với `systemctl`.
- Cấu hình Docker Proxy:
  - Proxy cho Docker Daemon.
  - Proxy cho Docker Client và Container.
- Cấu hình Docker Registry:
  - Registry nội bộ.
  - Cấu hình chứng chỉ CA tin cậy.
  - `insecure-registries` trong `daemon.json` cho môi trường thử nghiệm.
- Chạy Container đầu tiên bằng `docker run hello-world`.

### 12. Các câu lệnh Docker cơ bản
- `docker pull`: tải Image.
- `docker images`: liệt kê Image.
- `docker run`: tạo và chạy Container (các option `-d`, `-it`, `--name`, `-p`, `-v`, `-e`, `--rm`).
- `docker ps`: xem Container.
- `docker stop`, `docker start`, `docker restart`.
- `docker rm`, `docker rmi`: xóa Container và Image.
- `docker logs`: xem log.
- `docker exec`: thực thi lệnh bên trong Container.
- `docker inspect`: xem thông tin chi tiết.
- `docker stats`: theo dõi tài nguyên Container.
- `docker cp`, `docker top`, `docker diff`.
- Restart policy (`--restart`) và giới hạn tài nguyên (`--memory`, `--cpus`).

## Phần 5: Docker Image và Dockerfile

### 13. Docker Image là gì?
- Khái niệm Docker Image.
- Phân biệt Image và Container.
- Cấu trúc Image Layers (`docker history`).
- Image Tag và Image Digest.
- Docker Hub và Private Registry.
- Các lệnh `docker pull`, `docker tag`, `docker push`.
- Quy tắc đặt tên và quản lý phiên bản Image (Semantic Versioning, tránh dùng `latest`).
- Lưu và nạp Image offline: `docker save`, `docker load`.

### 14. Xây dựng Docker Image bằng Dockerfile
- Dockerfile là gì?
- Các chỉ thị cơ bản:
  - `FROM`, `RUN`, `COPY`, `ADD`.
  - `WORKDIR`, `ENV`, `ARG`.
  - `EXPOSE`, `CMD`, `ENTRYPOINT`.
  - `USER`, `HEALTHCHECK`.
  - `LABEL`, `VOLUME`.
- Xây dựng Image bằng `docker build`.
- Sử dụng `.dockerignore`.
- Phân biệt `CMD` và `ENTRYPOINT`; exec form và shell form.
- Giới thiệu Multi-stage Build.
- Tối ưu kích thước Image và Docker Build Cache.
- Thực hành tốt khi viết Dockerfile (chạy non-root, ghim phiên bản base image).

### 15. Thực hành Build và Push Docker Image
- Tạo một ứng dụng Web đơn giản.
- Viết Dockerfile cho ứng dụng.
- Build Image và chạy Container.
- Gắn Tag cho Image.
- Đăng nhập Docker Hub hoặc Private Registry.
- Push Image lên Registry.
- Pull Image về máy khác và chạy thử.
- Mở rộng: chuyển sang Multi-stage Build và so sánh kích thước Image.

## Phần 6: Kiến trúc và quản lý Docker

### 16. Kiến trúc Docker Engine
- Mô hình Docker Client – Server.
- Docker CLI và Docker API.
- Docker Daemon (`dockerd`) và file cấu hình `daemon.json`.
- Vai trò của containerd, containerd-shim và runc.
- Quy trình từ `docker run` đến khi Container hoạt động.
- Mối quan hệ giữa Docker Engine và Container Runtime.

### 17. Docker Networking
- Tổng quan về mạng trong Docker (veth, `docker0`, iptables).
- Các loại Docker Network:
  - Bridge Network (default bridge và user-defined bridge).
  - Host Network.
  - None Network.
  - Overlay Network.
  - Macvlan Network.
- Port Mapping với `-p`.
- DNS và giao tiếp giữa các Container.
- Tạo Network bằng `docker network create`.
- Thực hành kết nối hai Container trong cùng Network.

### 18. Docker Storage và Volume
- Dữ liệu bên trong Container được lưu trữ như thế nào?
- Khái niệm Ephemeral Storage.
- Phân biệt:
  - Docker Volume.
  - Bind Mount.
  - tmpfs Mount.
- Các lệnh `docker volume create`, `docker volume ls`, `docker volume inspect`, `docker volume rm`.
- Mount thư mục từ Host vào Container.
- Lưu trữ dữ liệu bền vững (Persistent Data), backup và restore Volume.
- Thực hành chạy MySQL Container với Docker Volume.

## Phần 7: Docker Compose

### 19. Tổng quan về Docker Compose
- Docker Compose là gì?
- Tại sao cần Docker Compose?
- Phân biệt Docker CLI và Docker Compose.
- Docker Compose V2 và cú pháp `docker compose`.
- Cấu trúc file `compose.yaml`.
- Các thành phần: Services, Networks, Volumes.

### 20. Viết và quản lý Docker Compose
- Khai báo nhiều Service trong một file Compose.
- Cấu hình Image, Build, Ports.
- Environment Variables và file `.env`.
- Cấu hình Volume và Network.
- `depends_on` và `healthcheck`.
- Các lệnh:
  - `docker compose up -d`.
  - `docker compose down`.
  - `docker compose ps`.
  - `docker compose logs`.
  - `docker compose exec`.
  - `docker compose build`.
  - `docker compose config`, `docker compose stop/start/restart`.
- `docker compose up --scale` và file `compose.override.yaml`.

### 21. Thực hành triển khai ứng dụng bằng Docker Compose
- Triển khai ứng dụng gồm Web Application và MySQL.
- Tạo Dockerfile cho Web Application.
- Viết file `compose.yaml`.
- Cấu hình Network cho các Service.
- Sử dụng Volume để lưu dữ liệu MySQL.
- Cấu hình biến môi trường kết nối Database.
- Khởi động, kiểm tra Log và xử lý lỗi.
- Dừng và triển khai lại toàn bộ ứng dụng.

