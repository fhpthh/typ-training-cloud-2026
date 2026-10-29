# BÁO CÁO THỰC HÀNH TUẦN 3: ẢO HÓA, CONTAINER, DOCKER VÀ DOCKER COMPOSE

- **Họ và tên:** Nguyễn Vĩnh Tùng
- **Mã sinh viên:** B23DCKH130
- **Chương trình:** TYP Cloud Training 2026
- **Giai đoạn:** Giai đoạn 1 (`training-gd1`)
- **Nội dung:** Báo cáo chi tiết và bài thực hành Tuần 3 - Ảo hóa, Container, Docker và Docker Compose
- **Tài liệu tham chiếu:** [week3/README.md](file:///d:/typ-training-cloud-2026/tungnv_b23dckh130_training-gd1/week3/README.md)
- **Thư mục mã nguồn thực hành:** [demo-docker-image/](file:///d:/typ-training-cloud-2026/tungnv_b23dckh130_training-gd1/week3/demo-docker-image/)
- **Ngày thực hiện:** 18/10/2026

---

## MỤC LỤC CHI TIẾT

- [**PHẦN 1: TỔNG QUAN VỀ ẢO HÓA**](#phần-1-tổng-quan-về-ảo-hóa)
  - [1. Mục 1: Ảo hóa là gì?](#1-mục-1-ảo-hóa-là-gì)
    - [1.1. Khái niệm và bản chất cốt lõi của ảo hóa](#11-khái-niệm-và-bản-chất-cốt-lõi-của-ảo-hóa)
    - [1.2. Bối cảnh lịch sử và sự tiến hóa của công nghệ ảo hóa](#12-bối-cảnh-lịch-sử-và-sự-tiến-hóa-của-công-nghệ-ảo-hóa)
    - [1.3. Mục đích và vai trò của ảo hóa trong hệ thống CNTT & Điện toán đám mây](#13-mục-đích-và-vai-trò-của-ảo-hóa-trong-hệ-thống-cntt--điện-toán-đám-mây)
    - [1.4. Phân tích đối chiếu: Máy vật lý (Physical Machine) vs Máy ảo (Virtual Machine)](#14-phân-tích-đối-chiếu-máy-vật-lý-physical-machine-vs-máy-ảo-virtual-machine)
  - [2. Mục 2: Các loại ảo hóa phổ biến](#2-mục-2-các-loại-ảo-hóa-phổ-biến)
    - [2.1. Ảo hóa máy chủ (Server Virtualization)](#21-ảo-hóa-máy-chủ-server-virtualization)
    - [2.2. Ảo hóa hệ điều hành (OS-Level Virtualization / Containerization)](#22-ảo-hóa-hệ-điều-hành-os-level-virtualization--containerization)
    - [2.3. Ảo hóa lưu trữ (Storage Virtualization)](#23-ảo-hóa-lưu-trữ-storage-virtualization)
    - [2.4. Ảo hóa mạng (Network Virtualization - SDN & NFV)](#24-ảo-hóa-mạng-network-virtualization---sdn--nfv)
    - [2.5. Các kỹ thuật ảo hóa CPU & Phần cứng chuyên sâu](#25-các-kỹ-thuật-ảo-hóa-cpu--phần-cứng-chuyên-sâu)
      - [2.5.1. Full Virtualization (Ảo hóa toàn phần)](#251-full-virtualization-ảo-hóa-toàn-phần)
      - [2.5.2. Para-Virtualization (Ảo hóa bán phần)](#252-para-virtualization-ảo-hóa-bán-phần)
      - [2.5.3. Hardware-Assisted Virtualization (Ảo hóa hỗ trợ phần cứng)](#253-hardware-assisted-virtualization-ảo-hóa-hỗ-trợ-phần-cứng)
      - [2.5.4. Bảng phân tích và đối chiếu 3 kỹ thuật ảo hóa](#254-bảng-phân-tích-và-đối-chiếu-3-kỹ-thuật-ảo-hóa)
    - [2.6. Phương pháp kiểm tra CPU hỗ trợ ảo hóa (Intel VT-x / AMD-V)](#26-phương-pháp-kiểm-tra-cpu-hỗ-trợ-ảo-hóa-intel-vt-x--amd-v)
      - [2.6.1. Kiểm tra trên hệ điều hành Linux](#261-kiểm-tra-trên-hệ-điều-hành-linux)
      - [2.6.2. Kiểm tra trên hệ điều hành Windows](#262-kiểm-tra-trên-hệ-điều-hành-windows)
      - [2.6.3. Bật tính năng ảo hóa trong BIOS/UEFI Firmware](#263-bật-tính-năng-ảo-hóa-trong-biosuefi-firmware)
  - [3. Mục 3: Hypervisor và các công nghệ ảo hóa](#3-mục-3-hypervisor-và-các-công-nghệ-ảo-hóa)
    - [3.1. Hypervisor là gì? Bản chất và vai trò của Hypervisor / VMM](#31-hypervisor-là-gì-bản-chất-và-vai-trò-của-hypervisor--vmm)
    - [3.2. Phân biệt Hypervisor Type 1 (Bare-metal) và Type 2 (Hosted)](#32-phân-biệt-hypervisor-type-1-bare-metal-và-type-2-hosted)
      - [3.2.1. Hypervisor Type 1 (Bare-metal Hypervisor)](#321-hypervisor-type-1-bare-metal-hypervisor)
      - [3.2.2. Hypervisor Type 2 (Hosted Hypervisor)](#322-hypervisor-type-2-hosted-hypervisor)
      - [3.2.3. Bảng so sánh toàn diện Type 1 và Type 2](#323-bảng-so-sánh-toàn-diện-type-1-và-type-2)
    - [3.3. Các công nghệ và giải pháp ảo hóa phổ biến trên thị trường](#33-các-công-nghệ-và-giải-pháp-ảo-hóa-phổ-biến-trên-thị-trường)
      - [3.3.1. VMware ESXi (vSphere Ecosystem)](#331-vmware-esxi-vsphere-ecosystem)
      - [3.3.2. Kernel-based Virtual Machine (KVM) & QEMU](#332-kernel-based-virtual-machine-kvm--qemu)
      - [3.3.3. Microsoft Hyper-V](#333-microsoft-hyper-v)
      - [3.3.4. Xen Project (Citrix Hypervisor / XCP-ng)](#334-xen-project-citrix-hypervisor--xcp-ng)
      - [3.3.5. Proxmox Virtual Environment (Proxmox VE)](#335-proxmox-virtual-environment-proxmox-ve)
      - [3.3.6. Oracle VM VirtualBox](#336-oracle-vm-virtualbox)
- [**PHẦN 2: VIRTUAL MACHINE**](#phần-2-virtual-machine)
  - [4. Mục 4: Tổng quan về Virtual Machine](#4-mục-4-tổng-quan-về-virtual-machine)
    - [4.1. Khái niệm và kiến trúc của máy ảo](#41-khái-niệm-và-kiến-trúc-của-máy-ảo)
    - [4.2. Phân biệt Host OS và Guest OS](#42-phân-biệt-host-os-và-guest-os)
    - [4.3. Các thành phần phần cứng được ảo hóa](#43-các-thành-phần-phần-cứng-được-ảo-hóa)
    - [4.4. Cơ chế chia sẻ tài nguyên: Overcommit, Reservation, Limit, Share](#44-cơ-chế-chia-sẻ-tài-nguyên-overcommit-reservation-limit-share)
  - [5. Mục 5: Cơ chế hoạt động của máy ảo](#5-mục-5-cơ-chế-hoạt-động-của-máy-ảo)
    - [5.1. Nguyên lý kiểm soát phần cứng](#51-nguyên-lý-kiểm-soát-phần-cứng)
    - [5.2. Chế độ phần cứng hỗ trợ (Root, Non-Root, VM Entry, VM Exit)](#52-chế-độ-phần-cứng-hỗ-trợ-root-non-root-vm-entry-vm-exit)
    - [5.3. Ảo hóa CPU và bộ nhớ (EPT/NPT)](#53-ảo-hóa-cpu-và-bộ-nhớ-eptnpt)
    - [5.4. Ảo hóa I/O và mô hình KVM + QEMU + libvirt](#54-ảo-hóa-io-và-mô-hình-kvm--qemu--libvirt)
  - [6. Mục 6: Vòng đời và quản lý VM](#6-mục-6-vòng-đời-và-quản-lý-vm)
    - [6.1. Các trạng thái vòng đời của máy ảo](#61-các-trạng-thái-vòng-đời-của-máy-ảo)
    - [6.2. Cấp phát và điều chỉnh tài nguyên động](#62-cấp-phát-và-điều-chỉnh-tài-nguyên-động)
    - [6.3. Phân biệt Snapshot, Clone và Template](#63-phân-biệt-snapshot-clone-và-template)
- [**PHẦN 3: TỔNG QUAN VỀ CONTAINER**](#phần-3-tổng-quan-về-container)
  - [8. Mục 8: Container là gì?](#8-mục-8-container-là-gì)
    - [8.1. Khái niệm Container và Containerization](#81-khái-niệm-container-và-containerization)
    - [8.2. Mục đích và vai trò của Container](#82-mục-đích-và-vai-trò-của-container)
    - [8.3. Phân biệt Container và Virtual Machine](#83-phân-biệt-container-và-virtual-machine)
    - [8.4. Hạn chế của Container và trường hợp nên dùng VM](#84-hạn-chế-của-container-và-trường-hợp-nên-dùng-vm)
  - [9. Mục 9: Cơ chế hoạt động của Container trên Linux](#9-mục-9-cơ-chế-hoạt-động-của-container-trên-linux)
    - [9.1. Container sử dụng chung Linux Kernel như thế nào?](#91-container-sử-dụng-chung-linux-kernel-như-thế-nào)
    - [9.2. Linux Namespaces và vai trò cô lập tài nguyên](#92-linux-namespaces-và-vai-trò-cô-lập-tài-nguyên)
    - [9.3. Control Groups - Quản lý và giới hạn tài nguyên](#93-control-groups---quản-lý-và-giới-hạn-tài-nguyên)
    - [9.4. Union Filesystem, OverlayFS và cơ chế Copy-on-Write](#94-union-filesystem-overlayfs-và-cơ-chế-copy-on-write)
    - [9.5. Phân biệt Container Image và Container Runtime](#95-phân-biệt-container-image-và-container-runtime)
    - [9.6. Chuẩn OCI](#96-chuẩn-oci)
- [**PHẦN 4: DOCKER CƠ BẢN**](#phần-4-docker-cơ-bản)
  - [10. Mục 10: Tổng quan về Docker](#10-mục-10-tổng-quan-về-docker)
    - [10.1. Docker là gì và tại sao cần Docker?](#101-docker-là-gì-và-tại-sao-cần-docker)
    - [10.2. Các thành phần chính trong hệ sinh thái Docker](#102-các-thành-phần-chính-trong-hệ-sinh-thái-docker)
    - [10.3. Docker Engine và Docker Desktop](#103-docker-engine-và-docker-desktop)
    - [10.4. Các phiên bản Docker](#104-các-phiên-bản-docker)
    - [10.5. Khái niệm Image, Container, Registry và chu trình Build - Ship - Run](#105-khái-niệm-image-container-registry-và-chu-trình-build---ship---run)
  - [11. Mục 11: Cài đặt và cấu hình Docker trên Linux](#11-mục-11-cài-đặt-và-cấu-hình-docker-trên-linux)
    - [11.1. Cài đặt Docker Engine trên Ubuntu](#111-cài-đặt-docker-engine-trên-ubuntu)
    - [11.2. Chạy Docker không cần sudo và lưu ý bảo mật](#112-chạy-docker-không-cần-sudo-và-lưu-ý-bảo-mật)
    - [11.3. Kiểm tra và quản lý dịch vụ Docker](#113-kiểm-tra-và-quản-lý-dịch-vụ-docker)
    - [11.4. Cấu hình Docker Proxy](#114-cấu-hình-docker-proxy)
    - [11.5. Cấu hình Docker Registry nội bộ và insecure registries](#115-cấu-hình-docker-registry-nội-bộ-và-insecure-registries)
    - [11.6. Chạy Container đầu tiên với hello-world](#116-chạy-container-đầu-tiên-với-hello-world)
  - [12. Mục 12: Các câu lệnh Docker cơ bản](#12-mục-12-các-câu-lệnh-docker-cơ-bản)
    - [12.1. Nhóm lệnh quản lý Image](#121-nhóm-lệnh-quản-lý-image)
    - [12.2. Nhóm lệnh khởi tạo và điều khiển Container](#122-nhóm-lệnh-khởi-tạo-và-điều-khiển-container)
    - [12.3. Nhóm lệnh theo dõi, giám sát và gỡ lỗi](#123-nhóm-lệnh-theo-dõi-giám-sát-và-gỡ-lỗi)
    - [12.4. Chính sách tự khởi động lại và giới hạn tài nguyên Container](#124-chính-sách-tự-khởi-động-lại-và-giới-hạn-tài-nguyên-container)
- [**PHẦN 5: DOCKER IMAGE VÀ DOCKERFILE**](#phần-5-docker-image-và-dockerfile)
  - [13. Mục 13: Docker Image là gì?](#13-mục-13-docker-image-là-gì)
    - [13.1. Khái niệm Docker Image](#131-khái-niệm-docker-image)
    - [13.2. Phân biệt Image và Container](#132-phân-biệt-image-và-container)
    - [13.3. Cấu trúc Image Layers và lệnh `docker history`](#133-cấu-trúc-image-layers-và-lệnh-docker-history)
    - [13.4. Image Tag và Image Digest](#134-image-tag-và-image-digest)
    - [13.5. Docker Hub và Private Registry](#135-docker-hub-và-private-registry)
    - [13.6. Các lệnh `docker pull`, `docker tag`, `docker push`](#136-các-lệnh-docker-pull-docker-tag-docker-push)
    - [13.7. Quy tắc đặt tên và quản lý phiên bản Image](#137-quy-tắc-đặt-tên-và-quản-lý-phiên-bản-image)
    - [13.8. Lưu và nạp Image offline: `docker save` và `docker load`](#138-lưu-và-nạp-image-offline-docker-save-và-docker-load)
  - [14. Mục 14: Xây dựng Docker Image bằng Dockerfile](#14-mục-14-xây-dựng-docker-image-bằng-dockerfile)
    - [14.1. Dockerfile là gì?](#141-dockerfile-là-gì)
    - [14.2. Phân tích chi tiết các chỉ thị cơ bản trong Dockerfile](#142-phân-tích-chi-tiết-các-chỉ-thị-cơ-bản-trong-dockerfile)
    - [14.3. Phân biệt `CMD` và `ENTRYPOINT`; Exec form và Shell form](#143-phân-biệt-cmd-và-entrypoint-exec-form-và-shell-form)
    - [14.4. Xây dựng Image bằng `docker build` và cấu hình `.dockerignore`](#144-xây-dựng-image-bằng-docker-build-và-cấu-hình-dockerignore)
    - [14.5. Cơ chế Docker Build Cache và nguyên lý tối ưu tốc độ](#145-cơ-chế-docker-build-cache-và-nguyên-lý-tối-ưu-tốc-độ)
    - [14.6. Kỹ thuật Multi-stage Build](#146-kỹ-thuật-multi-stage-build)
    - [14.7. Các thực hành tốt nhất (Best Practices) khi viết Dockerfile](#147-các-thực-hành-tốt-nhất-best-practices-khi-viết-dockerfile)
  - [15. Mục 15: Thực hành Build và Push Docker Image (Hands-on Lab)](#15-mục-15-thực-hành-build-và-push-docker-image-hands-on-lab)
    - [15.1. Thiết kế và tạo ứng dụng Web mẫu](#151-thiết-kế-và-tạo-ứng-dụng-web-mẫu)
    - [15.2. Viết Dockerfile Single-stage cho ứng dụng](#152-viết-dockerfile-single-stage-cho-ứng-dụng)
    - [15.3. Build Image và khởi chạy Container kiểm thử](#153-build-image-và-khởi-chạy-container-kiểm-thử)
    - [15.4. Gắn Tag và chuẩn bị phân phối](#154-gắn-tag-và-chuẩn-bị-phân-phối)
    - [15.5. Đăng nhập và Push Image lên Docker Hub / Registry](#155-đăng-nhập-và-push-image-lên-docker-hub--registry)
    - [15.6. Pull Image về môi trường mới và vận hành](#156-pull-image-về-môi-trường-mới-và-vận-hành)
      - [15.8. Tổng kết và Bài học kinh nghiệm Phần 5](#158-tổng-kết-và-bài-học-kinh-nghiệm-phần-5)
- [**PHẦN 6: KIẾN TRÚC VÀ QUẢN LÝ DOCKER**](#phần-6-kiến-trúc-và-quản-lý-docker)
  - [16. Mục 16: Kiến trúc Docker Engine](#16-mục-16-kiến-trúc-docker-engine)
    - [16.1. Mô hình Docker Client – Server](#161-mô-hình-docker-client--server)
    - [16.2. Docker CLI và Docker API](#162-docker-cli-và-docker-api)
    - [16.3. Docker Daemon và file cấu hình daemon.json](#163-docker-daemon-và-file-cấu-hình-daemonjson)
    - [16.4. Vai trò của containerd, containerd-shim và runc](#164-vai-trò-của-containerd-containerd-shim-và-runc)
    - [16.5. Quy trình từ docker run đến khi Container hoạt động](#165-quy-trình-từ-docker-run-đến-khi-container-hoạt-động)
    - [16.6. Mối quan hệ giữa Docker Engine và Container Runtime](#166-mối-quan-hệ-giữa-docker-engine-và-container-runtime)
  - [17. Mục 17: Docker Networking](#17-mục-17-docker-networking)
    - [17.1. Tổng quan về mạng trong Docker (veth, docker0, iptables)](#171-tổng-quan-về-mạng-trong-docker-veth-docker0-iptables)
    - [17.2. Các loại mạng trong Docker (Bridge, Host, None, Overlay, Macvlan)](#172-các-loại-mạng-trong-docker-bridge-host-none-overlay-macvlan)
    - [17.3. Ánh xạ cổng với Port Mapping -p](#173-ánh-xạ-cổng-với-port-mapping--p)
    - [17.4. Phân giải tên miền DNS và giao tiếp giữa các Container](#174-phân-giải-tên-miền-dns-và-giao-tiếp-giữa-các-container)
    - [17.5. Thực hành kết nối hai Container trong cùng mạng User-defined Bridge](#175-thực-hành-kết-nối-hai-container-trong-cùng-mạng-user-defined-bridge)
  - [18. Mục 18: Docker Storage và Volume](#18-mục-18-docker-storage-và-volume)
    - [18.1. Cơ chế lưu trữ dữ liệu bên trong Container và Ephemeral Storage](#181-cơ-chế-lưu-trữ-dữ-liệu-bên-trong-container-và-ephemeral-storage)
    - [18.2. Phân biệt Docker Volume, Bind Mount và tmpfs Mount](#182-phân-biệt-docker-volume-bind-mount-và-tmpfs-mount)
    - [18.3. Các lệnh quản lý Docker Volume](#183-các-lệnh-quản-lý-docker-volume)
    - [18.4. Gắn thư mục từ Host vào Container (Bind Mount)](#184-gắn-thư-mục-từ-host-vào-container-bind-mount)
    - [18.5. Thực hành chạy MySQL Container với Docker Volume](#185-thực-hành-chạy-mysql-container-với-docker-volume)
    - [18.6. Sao lưu (Backup) và Phục hồi (Restore) Docker Volume](#186-sao-lưu-backup-và-phục-hồi-restore-docker-volume)
- [**PHẦN 7: DOCKER COMPOSE**](#phần-7-docker-compose)
  - [19. Mục 19: Tổng quan về Docker Compose](#19-mục-19-tổng-quan-về-docker-compose)
    - [19.1. Docker Compose là gì và tại sao cần Docker Compose?](#191-docker-compose-là-gì-và-tại-sao-cần-docker-compose)
    - [19.2. Phân biệt Docker CLI và Docker Compose](#192-phân-biệt-docker-cli-và-docker-compose)
    - [19.3. Docker Compose V2 và cú pháp docker compose](#193-docker-compose-v2-và-cú-pháp-docker-compose)
    - [19.4. Cấu trúc file compose.yaml](#194-cấu-trúc-file-composeyaml)
    - [19.5. Các thành phần cốt lõi: Services, Networks, Volumes](#195-các-thành-phần-cốt-lõi-services-networks-volumes)
  - [20. Mục 20: Viết và quản lý Docker Compose](#20-mục-20-viết-và-quản-lý-docker-compose)
    - [20.1. Khai báo nhiều Service trong một file Compose](#201-khai-báo-nhiều-service-trong-một-file-compose)
    - [20.2. Cấu hình Image, Build Context và Ports](#202-cấu-hình-image-build-context-và-ports)
    - [20.3. Quản lý biến môi trường với file .env](#203-quản-lý-biến-môi-trường-với-file-env)
    - [20.4. Cấu hình Volume và Network trong Compose](#204-cấu-hình-volume-và-network-trong-compose)
    - [20.5. Quản lý phụ thuộc và kiểm tra sức khỏe với depends_on và healthcheck](#205-quản-lý-phụ-thuộc-và-kiểm-tra-sức-khỏe-với-dependson-và-healthcheck)
    - [20.6. Bộ lệnh quản lý Docker Compose toàn diện](#206-bộ-lệnh-quản-lý-docker-compose-toàn-diện)
    - [20.7. Mở rộng quy mô với scale và ghi đè cấu hình với compose.override.yaml](#207-mở-rộng-quy-mô-với-scale-và-ghi-đè-cấu-hình-với-composeoverrideyaml)
  - [21. Mục 21: Thực hành triển khai ứng dụng bằng Docker Compose](#21-mục-21-thực-hành-triển-khai-ứng-dụng-bằng-docker-compose)
    - [21.1. Kiến trúc hệ thống Web Application kết hợp MySQL](#211-kiến-trúc-hệ-thống-web-application-kết-hợp-mysql)
    - [21.2. Tạo Dockerfile cho Web Application](#212-tạo-dockerfile-cho-web-application)
    - [21.3. Viết file cấu hình compose.yaml chuẩn sản xuất](#213-viết-file-cấu-hình-composeyaml-chuẩn-sản-xuất)
    - [21.4. Cấu hình file biến môi trường .env](#214-cấu-hình-file-biến-môi-trường-env)
    - [21.5. Khởi chạy toàn bộ hệ thống và kiểm tra Log](#215-khởi-chạy-toàn-bộ-hệ-thống-và-kiểm-tra-log)
    - [21.6. Kiểm thử kết nối, ghi dữ liệu và xác minh tính bền vững](#216-kiểm-thử-kết-nối-ghi-dữ-liệu-và-xác-minh-tính-bền-vững)
    - [21.7. Dừng, cập nhật và triển khai lại toàn bộ ứng dụng](#217-dừng-cập-nhật-và-triển-khai-lại-toàn-bộ-ứng-dụng)
- [**22. TỔNG KẾT TOÀN DIỆN VÀ BÀI HỌC KINH NGHIỆM**](#22-tổng-kết-toàn-diện-và-bài-học-kinh-nghiệm)

---

# PHẦN 1: TỔNG QUAN VỀ ẢO HÓA

# 1. Mục 1: Ảo hóa là gì?

## 1.1. Khái niệm và bản chất cốt lõi của ảo hóa

**Ảo hóa** là một công nghệ nền tảng trong khoa học máy tính cho phép tạo ra một **phiên bản ảo** của các tài nguyên điện toán thay vì sử dụng trực tiếp các thành phần vật lý hữu hình. Các tài nguyên này bao gồm:
- Bộ vi xử lý (**CPU / vCPU**)
- Bộ nhớ truy xuất ngẫu nhiên (**RAM / vRAM**)
- Ổ đĩa lưu trữ (**Storage / Virtual Disk**)
- Giao diện và thiết bị mạng (**Network Interface Cards - vNIC, Virtual Switches**)
- Toàn bộ môi trường hệ điều hành (**Operating System**)

Về mặt bản chất kỹ thuật, ảo hóa thiết lập một **lớp trừu tượng hóa** ngăn cách giữa phần cứng vật lý bên dưới và các hệ điều hành hoặc ứng dụng chạy bên trên. 

Nhờ lớp trừu tượng này:
1. Phần mềm không còn bị gắn chặt vào các đặc tính vi kiến trúc phần cứng cụ thể.
2. Một máy chủ vật lý đơn lẻ có thể được phân chia thành nhiều môi trường thực thi độc lập, an toàn và khép kín, được gọi là các **Máy ảo**.
3. Mỗi máy ảo vận hành như thể nó đang sở hữu toàn bộ tài nguyên phần cứng độc quyền của riêng mình.

```text
┌────────────────────────────────────────────────────────┐
│    Ứng dụng A        Ứng dụng B        Ứng dụng C      │
├────────────────────────────────────────────────────────┤
│    Guest OS 1        Guest OS 2        Guest OS 3      │
├────────────────────────────────────────────────────────┤
│        LỚP TRỪU TƯỢNG HÓA ẢO HÓA (HYPERVISOR)          │
│   (Quản lý, phân phối, lập lịch & cô lập tài nguyên)   │
├────────────────────────────────────────────────────────┤
│                  PHẦN CỨNG VẬT LÝ                      │
│        (Physical CPU, Memory, Disk, NIC, Chipset)      │
└────────────────────────────────────────────────────────┘
```

---

## 1.2. Bối cảnh lịch sử và sự tiến hóa của công nghệ ảo hóa

Công nghệ ảo hóa đã trải qua hơn nửa thế kỷ phát triển với các mốc chính:

- **Thập niên 1960 (IBM Mainframe):** Khởi nguyên với IBM CP-40/CP-67 và System/360, tiên phong cơ chế chia sẻ thời gian (*Time-sharing*) để tối ưu chi phí phần cứng.
- **Thập niên 1980 - 1990 (Kỷ nguyên PC x86):** Máy chủ x86 bùng nổ nhưng kiến trúc ban đầu chưa hỗ trợ ảo hóa, dẫn đến tình trạng bùng nổ máy chủ (*Server Sprawl*) và lãng phí tài nguyên (tải CPU chỉ 5% - 15%).
- **Năm 1998 - 1999 (Đột phá từ VMware):** Giới thiệu kỹ thuật Binary Translation, cho phép ảo hóa trên phần cứng x86 mà không cần chỉnh sửa hệ điều hành khách.
- **Năm 2005 - 2006 (Ảo hóa hỗ trợ phần cứng):** Intel (VT-x) và AMD (AMD-V) trực tiếp bổ sung tập lệnh ảo hóa vào CPU, giải quyết triệt để nút thắt hiệu năng.
- **Từ 2010 đến nay (Cloud & Container):** Ảo hóa trở thành xương sống của điện toán đám mây (AWS, Azure, GCP), phát triển mạnh mẽ với Linux KVM, Container (Docker) và MicroVMs.

---

## 1.3. Mục đích và vai trò của ảo hóa trong hệ thống CNTT & Điện toán đám mây

Ảo hóa không đơn thuần là một công cụ phân chia phần cứng, mà là triết lý kiến trúc tái định hình toàn bộ phương thức xây dựng, vận hành và bảo trì hạ tầng CNTT hiện đại:

### 1. Tối ưu hóa hiệu suất sử dụng tài nguyên (*Resource Utilization*)
- **Trước ảo hóa:** Mỗi máy chủ vật lý chỉ chạy một hệ điều hành và một ứng dụng duy nhất để tránh xung đột dependency. Tải CPU trung bình thường chỉ dao động từ **5% đến 15%**, RAM và ổ đĩa bị lãng phí nghiêm trọng.
- **Sau ảo hóa:** Gom (*consolidate*) từ 10 đến 30 máy ảo lên cùng một máy chủ vật lý cấu hình mạnh, đẩy tải sử dụng CPU lên mức **60% - 80%**, khai thác triệt để năng lực phần cứng đã đầu tư.

### 2. Tiết kiệm chi phí đầu tư (CapEx) và chi phí vận hành (OpEx)
- **Giảm CapEx (*Capital Expenditure*):** Doanh nghiệp giảm số lượng máy chủ vật lý cần mua sắm từ hàng trăm node xuống còn vài chục node. Kéo theo việc giảm số lượng switch mạng, cáp quang, tủ rack và thiết bị lưu trữ SAN/NAS.
- **Giảm OpEx (*Operational Expenditure*):** Giảm trực tiếp lượng điện tiêu thụ cho server, giảm tải cho hệ thống điều hòa làm mát trung tâm dữ liệu (HVAC), giảm diện tích thuê mặt sàn (*Data Center Footprint*) và giảm số lượng nhân sự System Admin cần để bảo trì phần cứng.

### 3. Tăng cường tính sẵn sàng cao (High Availability - HA) và Phục hồi sau thảm họa (Disaster Recovery - DR)
- Máy ảo được đóng gói trọn vẹn dưới dạng các tập tin logic trên đĩa (*encapsulated into files*). Do đó, việc sao lưu một máy ảo chỉ đơn giản là tạo **Snapshot** hoặc copy file đĩa ảo (`.vmdk`, `.qcow2`).
- Cho phép thực hiện **Live Migration** (chuyển dịch máy ảo đang chạy giữa hai máy chủ vật lý khác nhau mà không làm gián đoạn dịch vụ người dùng - Downtime xấp xỉ 0ms).
- Khi một máy chủ vật lý gặp sự cố cháy nổ phần cứng, các máy ảo trên đó có thể tự động được khởi động lại trên một máy chủ vật lý khác trong cụm cluster chỉ sau vài giây.

### 4. Khả năng cô lập bảo mật và kiểm soát lỗi (*Fault Isolation & Security Boundary*)
- Mỗi máy ảo là một phân vùng thực thi tách biệt hoàn toàn. Nếu ứng dụng trên Máy ảo A bị lỗi tràn bộ nhớ (Crash), dính mã độc (Ransomware) hoặc bị hacker chiếm quyền điều khiển, sự cố đó bị giới hạn tuyệt đối bên trong ranh giới của Máy ảo A, không thể ảnh hưởng hay làm sập Máy ảo B và Host vật lý bên dưới.

### 5. Triển khai nhanh chóng và Linh hoạt trong mở rộng (*Agility & Scalability*)
- Cung ứng một máy chủ vật lý truyền thống đòi hỏi quy trình từ 2 đến 6 tuần (Đặt hàng, vận chuyển, lắp đặt lên tủ rack, đấu nối mạng cáp, cài đặt OS).
- Với ảo hóa, việc tạo một máy ảo mới chỉ mất **từ 30 giây đến vài phút** thông qua các mẫu máy ảo dựng sẵn hoặc các API tự động hóa.

### 6. Trụ cột nền tảng của Điện toán đám mây (*Foundation of Cloud Computing*)
- Điện toán đám mây (*Cloud Computing*) với mô hình dịch vụ cơ sở hạ tầng **IaaS (Infrastructure as a Service)** như AWS EC2, Google Compute Engine hay Azure Virtual Machines sẽ không thể tồn tại nếu thiếu ảo hóa.
- Ảo hóa cung cấp cơ chế đa người thuê (**Multi-tenancy**): Chia sẻ cùng một hạ tầng phần cứng vật lý quy mô lớn cho hàng triệu khách hàng khác nhau trên toàn thế giới mà vẫn đảm bảo tính riêng tư, hạn mức tài nguyên (*Quotas*) và an toàn dữ liệu.

---

## 1.4. Phân tích đối chiếu: Máy vật lý (Physical Machine) vs Máy ảo (Virtual Machine)

Để hiểu sâu sắc sự khác biệt kiến trúc giữa việc triển khai ứng dụng trực tiếp trên phần cứng máy vật lý (*Bare-metal*) và trên máy ảo (*Virtual Machine*), chúng ta xem xét mô hình kiến trúc so sánh dưới đây:

```text
       MÔ HÌNH BARE-METAL                     MÔ HÌNH MÁY ẢO (VIRTUALIZATION)
 ┌─────────────────────────────┐         ┌────────────────────────────────────────────┐
 │     App A (Độc quyền)       │         │    App 1     │    App 2     │    App 3     │
 ├─────────────────────────────┤         ├──────────────┼──────────────┼──────────────┤
 │  Thư viện / Dependencies    │         │    Libs 1    │    Libs 2    │    Libs 3    │
 ├─────────────────────────────┤         ├──────────────┼──────────────┼──────────────┤
 │    Hệ điều hành Host OS     │         │  Guest OS 1  │  Guest OS 2  │  Guest OS 3  │
 ├─────────────────────────────┤         ├──────────────┴──────────────┴──────────────┤
 │      Phần cứng vật lý       │         │      LỚP HYPERVISOR (VMM Layer)            │
 │ (CPU, RAM, Ổ đĩa, NIC,...)  │         ├────────────────────────────────────────────┤
 │                             │         │             Phần cứng vật lý               │
 │ [1 Server = 1 OS = 1 App]   │         │        (CPU, RAM, Ổ đĩa, NIC,...)          │
 └─────────────────────────────┘         │         [1 Server = Nhiều Máy ảo]          │
                                         └────────────────────────────────────────────┘
```

### Bảng so sánh chi tiết giữa Physical Machine và Virtual Machine

| Tiêu chí so sánh | Máy vật lý (*Physical Machine / Bare-metal*) | Máy ảo (*Virtual Machine - VM*) |
| :--- | :--- | :--- |
| **Bản chất kiến trúc** | Phần cứng vật lý hữu hình với các bo mạch, vi xử lý, thanh RAM và ổ đĩa gắn thực tế. | Máy tính logic được mô phỏng bằng phần mềm, trừu tượng hóa từ phần cứng thực. |
| **Mối quan hệ OS - Phần cứng** | Hệ điều hành được cài đặt trực tiếp lên đĩa cứng và giao tiếp thẳng với BIOS/UEFI, CPU. | Hệ điều hành khách (*Guest OS*) giao tiếp với phần cứng thông qua sự trung gian của Hypervisor. |
| **Mức độ tận dụng tài nguyên** | Rất thấp (**5% - 20%** do phải dự phòng cho thời điểm tải đỉnh - *Peak Load*). | Rất cao (**60% - 85%** nhờ cơ chế chia sẻ và gom cụm nhiều máy ảo trên cùng một Host). |
| **Thời gian khởi tạo & Cấp phát** | Rất chậm (Từ vài ngày đến vài tuần để mua sắm, lắp ráp, cấu hình dây cáp). | Rất nhanh (Vài chục giây đến vài phút thông qua Clone, Template hoặc API script). |
| **Khả năng mở rộng (*Scalability*)** | Mở rộng theo chiều dọc (*Scale-up*) phức tạp, yêu cầu tắt máy, tháo lắp phần cứng thủ công. | Mở rộng cực kỳ linh hoạt; có thể tăng vCPU, vRAM, Disk size trực tiếp trong khi VM đang chạy (*Hot-add*). |
| **Khả năng di chuyển (*Portability*)** | Rất khó khăn; hệ điều hành bị ràng buộc bởi driver của chipset bo mạch chủ cụ thể. | Tuyệt đối linh hoạt; VM được đóng gói thành các file tĩnh, có thể di chuyển qua lại giữa các máy chủ vật lý khác hãng. |
| **Sao lưu & Khôi phục sự cố** | Cần phần mềm backup chuyên dụng cho Bare-metal, thời gian phục hồi thảm họa tính bằng ngày. | Tạo Snapshot tức thì trong vài giây; khôi phục nguyên trạng toàn bộ hệ thống bằng 1 click chuột. |
| **Hiệu năng thô (*Raw Performance*)** | Đạt **100% hiệu năng tối đa** của phần cứng (độ trễ I/O cực thấp, không có tầng trung gian). | Suy hao nhẹ (**1% - 5% overhead**) do Hypervisor xử lý trung gian (hiện nay phần cứng hiện đại đã giảm thiểu đáng kể). |
| **Trường hợp sử dụng phù hợp** | Cơ sở dữ liệu cực lớn (Oracle Exadata, SAP HANA), tính toán hiệu năng cao (HPC), AI/ML training nặng. | Phần lớn các hệ thống máy chủ doanh nghiệp: Web Server, App Server, CI/CD, ERP, CRM, Cloud Infrastructure. |

---

# 2. Mục 2: Các loại ảo hóa phổ biến

Trong bức tranh tổng thể của hệ thống CNTT hiện đại, ảo hóa được áp dụng ở nhiều tầng kiến trúc khác nhau để tạo nên một Trung tâm dữ liệu định nghĩa bằng phần mềm (**Software-Defined Data Center - SDDC**).

![Các loại ảo hóa](./images/Vietnamese%20Virtualization%20Types%20Infographic.png)

---

## 2.5. Các kỹ thuật ảo hóa CPU & Phần cứng chuyên sâu

Để hệ điều hành khách (*Guest OS*) có thể chạy mượt mà trên phần cứng máy chủ mà không làm ảnh hưởng đến Host OS hay các máy ảo khác, khoa học máy tính đã phát triển ba kỹ thuật ảo hóa CPU qua từng thời kỳ:

```text
 1. FULL VIRTUALIZATION          2. PARA-VIRTUALIZATION         3. HARDWARE-ASSISTED
 (Ảo hóa toàn phần)              (Ảo hóa bán phần)              (Hỗ trợ từ CPU)
┌──────────────────────┐        ┌──────────────────────┐       ┌──────────────────────┐
│ Unmodified Guest OS  │        │  Modified Guest OS   │       │ Unmodified Guest OS  │
├──────────────────────┤        ├──────────────────────┤       ├──────────────────────┤
│ Binary Translation   │        │ Hypercalls API       │       │ Hardware CPU Flags   │
│ & Trap-and-Emulate   │        │ (Chủ động gọi VMM)   │       │ (Intel VT-x / AMD-V) │
├──────────────────────┤        ├──────────────────────┤       ├──────────────────────┤
│      Hypervisor      │        │      Hypervisor      │       │ Hypervisor (Root)    │
├──────────────────────┤        ├──────────────────────┤       ├──────────────────────┤
│ Phần cứng x86 cũ     │        │ Phần cứng x86        │       │ CPU hỗ trợ VMX/SVM   │
└──────────────────────┘        └──────────────────────┘       └──────────────────────┘
```

---

### 2.5.1. Full Virtualization (Ảo hóa toàn phần)

- **Nguyên lý hoạt động:**
  - Máy ảo mô phỏng hoàn toàn 100% phần cứng vật lý thực tế. Hệ điều hành khách (*Guest OS*) hoàn toàn không hề biết rằng nó đang chạy trong một môi trường ảo; nó tin rằng nó đang độc quyền sở hữu CPU, bo mạch chủ và toàn bộ thiết bị ngoại vi.
  - Do đó, **hệ điều hành khách không cần phải qua bất kỳ sửa đổi nào** (chạy trực tiếp các file ISO cài đặt chuẩn của Windows hoặc Linux).
- **Cơ chế xử lý chỉ lệnh CPU:**
  - Trong kiến trúc x86 truyền thống, có 4 cấp độ đặc quyền phần cứng (*Rings*):
    - **Ring 0 (Kernel Mode):** Dành riêng cho hệ điều hành, có quyền thực thi các chỉ lệnh nhạy cảm (*Privileged Instructions*) như điều khiển bảng phân trang bộ nhớ, truy xuất cổng I/O.
    - **Ring 3 (User Mode):** Dành cho ứng dụng thông thường của người dùng.
  - Khi ảo hóa toàn phần xuất hiện, Hypervisor phải chiếm giữ **Ring 0**, đẩy Guest OS Kernel lên chạy ở **Ring 1**.
  - Khi Guest OS phát ra một chỉ lệnh nhạy cảm (vốn chỉ được phép chạy ở Ring 0), kỹ thuật **Dịch nhị phân (*Binary Translation*)** kết hợp **Bẫy và Mô phỏng (*Trap-and-Emulate*)** sẽ can thiệp: Hypervisor sẽ quét luồng mã máy nhị phân, bắt bẫy (*Trap*) các chỉ lệnh nguy hiểm, dịch chúng thành một chuỗi chỉ lệnh an toàn tương đương rồi mới chuyển cho phần cứng thực thi.
- **Ưu điểm:** Khả năng tương thích tuyệt đối. Mọi hệ điều hành có thể cài đặt trực tiếp mà không cần nguồn mã mở hay bản vá đặc biệt.
- **Nhược điểm:** Hiệu năng bị suy hao đáng kể do chi phí dịch mã nhị phân thời gian thực và việc xử lý bẫy phần mềm tốn nhiều chu kỳ CPU.

---

### 2.5.2. Para-Virtualization (Ảo hóa bán phần)

- **Nguyên lý hoạt động:**
  - Hệ điều hành khách **nhận thức được đầy đủ rằng nó đang chạy bên trong một máy ảo**.
  - Mã nguồn của nhân hệ điều hành khách (*Guest OS Kernel*) được chỉnh sửa đặc biệt: Thay vì cố gắng phát ra các chỉ lệnh phần cứng nhạy cảm ở cấp Ring 0, các đoạn mã này được thay thế bằng các lời gọi hàm trực tiếp tới Hypervisor, được gọi là các **Hypercalls** (tương tự như *System Calls* mà ứng dụng gửi tới Kernel).
- **Cơ chế:**
  - Hypervisor cung cấp một bộ giao tiếp API chuẩn cho Guest OS. Khi Guest OS cần cấp phát bộ nhớ hay xử lý ngắt, nó phát lệnh Hypercall để yêu cầu Hypervisor xử lý trực tiếp.
- **Ưu điểm:** Loại bỏ hoàn toàn sự chậm trễ của quá trình Binary Translation, đem lại hiệu năng tính toán và tốc độ xử lý I/O rất tiệm cận máy vật lý.
- **Nhược điểm:**
  - Đòi hỏi phải biên dịch lại Kernel của Guest OS.
  - Không thể chạy các hệ điều hành đóng mã nguồn thương mại như Microsoft Windows nếu nhà sản xuất không cung cấp bản build riêng biệt hỗ trợ kiến trúc Para-virtualization đó.
- **Đại diện tiêu biểu:** Dự án **Xen Project** (thời kỳ đầu với cơ chế Xen PV), các trình điều khiển tối ưu hóa **VirtIO** trong KVM.

---

### 2.5.3. Hardware-Assisted Virtualization (Ảo hóa hỗ trợ phần cứng)

- **Nguyên lý hoạt động:**
  - Thay vì phải dùng các thủ thuật phần mềm phức tạp (như Binary Translation hay sửa Kernel), các nhà sản xuất vi xử lý (Intel và AMD) đã trực tiếp tích hợp các tập lệnh và chế độ hoạt động chuyên biệt cho ảo hóa ngay trên silicon của CPU:
    - **Intel VT-x (*Intel Virtualization Technology*):** Giới thiệu thêm 2 chế độ đặc quyền mới bên dưới kiến trúc Ring:
      - **VMX Root Operation:** Chế độ dành riêng cho Hypervisor chạy với toàn quyền kiểm soát phần cứng.
      - **VMX Non-Root Operation:** Chế độ dành cho Guest OS và ứng dụng của máy ảo. Khi Guest OS chạy ở Non-Root Ring 0, nó được thực thi trực tiếp các chỉ lệnh nhạy cảm của CPU mà không cần bẫy phần mềm.
    - **AMD-V (*AMD Virtualization*):** Cơ chế tương tự với lệnh điều khiển `VMRUN` và cấu trúc khối kiểm soát `VMCB`.
- **Cơ chế chuyển đổi ngữ cảnh (*Context Switching*):**
  - **VM Entry:** Hypervisor chuyển quyền điều khiển CPU sang cho máy ảo chạy ở chế độ Non-Root.
  - **VM Exit:** Khi xảy ra sự kiện đòi hỏi sự can thiệp của Hypervisor (như truy xuất ngắt đặc thù), CPU tự động ngắt Guest OS và chuyển quyền điều khiển ngược về cho Hypervisor ở chế độ Root.
- **Ảo hóa bộ nhớ cấp phần cứng:**
  - Ban đầu, Hypervisor phải duy trì các bảng trang bóng (*Shadow Page Tables*) bằng phần mềm rất tốn tài nguyên.
  - Intel sau đó giới thiệu **EPT (Extended Page Tables)** và AMD giới thiệu **NPT (Nested Page Tables) / RVI**, hỗ trợ ánh xạ hai tầng địa chỉ trực tiếp bằng phần cứng: `Guest Virtual Address (GVA) -> Guest Physical Address (GPA) -> Host Physical Address (HPA)`.
- **Ưu điểm:**
  - Hiệu năng cực cao, độ trễ xử lý thấp nhất.
  - Chạy được mọi hệ điều hành tiêu chuẩn mà hoàn toàn không cần chỉnh sửa mã nguồn của Guest OS.
  - Là tiêu chuẩn vàng thống trị toàn bộ các nền tảng đám mây và máy chủ hiện đại ngày nay.

---

## 2.6. Phương pháp kiểm tra CPU hỗ trợ ảo hóa (Intel VT-x / AMD-V)

Trước khi tiến hành cài đặt bất kỳ nền tảng ảo hóa nào (như KVM, VirtualBox, VMware Workstation, Hyper-V hay Docker Desktop với WSL2), kỹ sư hệ thống cần xác thực xem CPU của máy chủ/máy tính có hỗ trợ và đã kích hoạt tính năng ảo hóa phần cứng trong BIOS/UEFI hay chưa.

---

### 2.6.1. Kiểm tra trên hệ điều hành Linux

Trên Linux, tất cả các thông số vi kiến trúc của CPU được nhân kernel phơi bày thông qua hệ thống tệp ảo `/proc/cpuinfo`.

#### Cách 1: Sử dụng lệnh `lscpu` (Trực quan và dễ đọc nhất)
```bash
lscpu | grep -i "virtualization"
```
*Kết quả mẫu trên chip Intel:*
```text
Virtualization:           VT-x
Virtualization type:      full
```
*Kết quả mẫu trên chip AMD:*
```text
Virtualization:           AMD-V
Virtualization type:      full
```

#### Cách 2: Tìm cờ vi xử lý `vmx` hoặc `svm` trong `/proc/cpuinfo`
- Cờ **`vmx`** (Virtual Machine eXtension): Biểu thị hỗ trợ **Intel VT-x**.
- Cờ **`svm`** (Secure Virtual Machine): Biểu thị hỗ trợ **AMD-V**.

```bash
egrep -c '(vmx|svm)' /proc/cpuinfo
```
- Nếu kết quả trả về **lớn hơn 0** (ví dụ: `8`, `12`, `16` tương ứng với số lõi logic), CPU có hỗ trợ ảo hóa phần cứng.
- Nếu kết quả trả về bằng `0`, CPU không hỗ trợ hoặc tính năng ảo hóa đang bị tắt trong BIOS/UEFI.

Để xem chi tiết cờ tính năng được highlight màu sắc:
```bash
grep -E --color=auto '(vmx|svm)' /proc/cpuinfo
```

#### Cách 3: Sử dụng công cụ chuyên dụng `cpu-checker`
Cài đặt gói công cụ kiểm tra tính tương thích KVM:
```bash
sudo apt update && sudo apt install -y cpu-checker
kvm-ok
```
*Đầu ra khi hệ thống đã sẵn sàng cho ảo hóa phần cứng:*
```text
INFO: /dev/kvm exists
KVM acceleration can be used
```
*Đầu ra khi ảo hóa bị tắt trong BIOS:*
```text
INFO: Your CPU supports KVM extensions
KVM acceleration can NOT be used
KVM is disabled by your BIOS
```

#### Cách 4: Kiểm tra module Kernel KVM đã tải hay chưa
```bash
lsmod | grep kvm
```
*Kết quả xuất hiện module `kvm_intel` hoặc `kvm_amd`:*
```text
kvm_intel             385024  0
kvm                  1105920  1 kvm_intel
```

---

### 2.6.2. Kiểm tra trên hệ điều hành Windows

Trên hệ điều hành Windows, có thể kiểm tra trạng thái ảo hóa thông qua giao diện đồ họa (GUI) hoặc bằng các lệnh PowerShell/CMD.

#### Cách 1: Qua Task Manager (Giao diện đồ họa)
1. Nhấn tổ hợp phím `Ctrl + Shift + Esc` để mở **Task Manager**.
2. Chuyển sang thẻ **Performance** (Hiệu năng) -> chọn mục **CPU**.
3. Quan sát góc dưới bên phải, tìm dòng **Virtualization** (Ảo hóa):
   - Nếu hiển thị **Enabled**: Tính năng ảo hóa phần cứng đã được kích hoạt thành công.
   - Nếu hiển thị **Disabled**: Cần khởi động lại máy vào BIOS để bật.

```text
┌────────────────────────────────────────────────────────┐
│ Task Manager - Performance Tab                         │
├────────────────────────────────────────────────────────┤
│ CPU: 12th Gen Intel(R) Core(TM) i5-12500H              │
│ Base speed: 2.50 GHz                                   │
│ Sockets: 1                                             │
│ Cores: 8                                               │
│ Logical processors: 12                                 │
│                                                        │
│ Virtualization:                  Enabled  <────────────┤
│ L1 cache: 1.2 MB                                       │
│ L2 cache: 9.0 MB                                       │
│ L3 cache: 18.0 MB                                      │
└────────────────────────────────────────────────────────┘
```

#### Cách 2: Sử dụng lệnh PowerShell `Get-CimInstance`
Mở PowerShell và thực thi câu lệnh truy vấn lớp WMI `Win32_Processor`:
```powershell
Get-CimInstance -ClassName Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors, VirtualizationFirmwareEnabled
```
*Kết quả mẫu:*
```text
Name                                 NumberOfCores NumberOfLogicalProcessors VirtualizationFirmwareEnabled
----                                 ------------- ------------------------- -----------------------------
12th Gen Intel(R) Core(TM) i5-12500H             8                        12                          True
```
- Thuộc tính `VirtualizationFirmwareEnabled = True` xác nhận firmware đã bật ảo hóa phần cứng.

#### Cách 3: Sử dụng lệnh `systeminfo`
```cmd
systeminfo
```
Cuộn xuống phần cuối cùng của danh sách để kiểm tra trường **Hyper-V Requirements**:
```text
Hyper-V Requirements:      VM Monitor Mode Extensions: Yes
                           Virtualization Enabled In Firmware: Yes
                           Second Level Address Translation: Yes
                           Data Execution Prevention Available: Yes
```
*(Lưu ý: Nếu một Hypervisor Type 1 như Hyper-V hoặc WSL2 đang chiếm giữ hệ thống, Windows sẽ thông báo: "A hypervisor has been detected. Features required for Hyper-V will not be displayed" - đây là minh chứng hệ thống đang chạy ảo hóa bình thường).*

---

### 2.6.3. Bật tính năng ảo hóa trong BIOS/UEFI Firmware

Nếu hệ thống báo `Virtualization: Disabled`, người dùng cần bật tính năng này trực tiếp từ bo mạch chủ theo quy trình chuẩn:
1. **Khởi động lại máy tính** và nhấn liên tục phím truy cập BIOS (tùy thuộc hãng phần cứng: `F2`, `F10`, `F12`, `Del` hoặc `Esc`).
2. Điều hướng đến các thẻ nâng cao: **Advanced**, **CPU Configuration**, **Security** hoặc **System Configuration**.
3. Tìm và chuyển trạng thái từ **Disabled** sang **Enabled** đối với các thiết lập:
   - Đối với vi xử lý Intel: **Intel Virtualization Technology**, **Intel VT-x**, **Vanderpool**, hoặc **VT-d**.
   - Đối với vi xử lý AMD: **AMD-V**, **SVM Mode** (*Secure Virtual Machine*), hoặc **AMD IOMMU**.
4. Nhấn phím **F10** (Save & Exit) để lưu cấu hình và khởi động lại vào hệ điều hành.

---

# 3. Mục 3: Hypervisor và các công nghệ ảo hóa

## 3.1. Hypervisor là gì? Bản chất và vai trò của Hypervisor / VMM

**Hypervisor** (còn có tên gọi kỹ thuật học thuật là **Virtual Machine Monitor - VMM**) là một khối chương trình phần mềm, firmware hoặc module tầng nhân hệ điều hành chịu trách nhiệm khởi tạo, điều phối, quản lý và giám sát các máy ảo.

Hypervisor đóng vai trò là "người phân xử" tối cao kiểm soát toàn bộ tài nguyên phần cứng vật lý bên dưới và cấp phát chúng cho các hệ điều hành khách bên trên.

### Bốn vai trò cốt lõi của một Hypervisor:
1. **Trừu tượng hóa tài nguyên (*Abstraction*):** Biến đổi các linh kiện phần cứng vật lý phức tạp, không đồng nhất thành các tài nguyên ảo hóa tiêu chuẩn hóa và đồng nhất (vCPU, vRAM, vDisk).
2. **Phân phối và Lập lịch (*Resource Allocation & Scheduling*):** Lập lịch ánh xạ các vi xử lý ảo (*vCPU*) luân phiên thực thi trên các nhân vật lý (*Physical Cores*), quản lý việc cấp phát và thu hồi bộ nhớ RAM theo thuật toán tối ưu.
3. **Cô lập và Bảo vệ (*Isolation & Protection*):** Đảm bảo tính bảo mật nghiêm ngặt giữa các máy ảo. Ngăn chặn tuyệt đối tình trạng một máy ảo truy xuất trái phép vào vùng nhớ RAM của máy ảo bên cạnh hoặc can thiệp vào hoạt động của Host.
4. **Giám sát và Điều phối I/O (*I/O Handling & Emulation*):** Bắt giữ và xử lý các yêu cầu đọc/ghi dữ liệu ổ đĩa, truyền nhận gói tin mạng từ các máy ảo, chuyển đổi chúng thành các tín hiệu I/O phần cứng thực thi an toàn.

---

## 3.2. Phân biệt Hypervisor Type 1 (Bare-metal) và Type 2 (Hosted)

Dựa theo vị trí kiến trúc trong ngăn xếp hệ thống và cách thức tương tác với phần cứng vật lý, nhà khoa học máy tính Gerald J. Popek và Robert P. Goldberg đã phân loại Hypervisor thành hai dạng kiến trúc cơ bản: **Type 1** và **Type 2**.

```text
       HYPERVISOR TYPE 1 (BARE-METAL)                   HYPERVISOR TYPE 2 (HOSTED)
 ┌───────────────────────────────────────────┐    ┌───────────────────────────────────────────┐
 │   Máy ảo 1    │   Máy ảo 2    │  Máy ảo 3 │    │   Máy ảo 1    │   Máy ảo 2    │  Máy ảo 3 │
 │  (Guest OS)   │  (Guest OS)   │ (Guest OS)│    │  (Guest OS)   │  (Guest OS)   │ (Guest OS)│
 ├───────────────┴───────────────┴───────────┤    ├───────────────┴───────────────┴───────────┤
 │         HYPERVISOR TYPE 1 BARE-METAL      │    │         HYPERVISOR TYPE 2 (HOSTED)        │
 │  (Cài trực tiếp lên phần cứng máy chủ)    │    │ (Phần mềm chạy trên nền tảng của Host OS) │
 ├───────────────────────────────────────────┤    ├───────────────────────────────────────────┤
 │                                           │    │            HỆ ĐIỀU HÀNH HOST OS           │
 │             PHẦN CỨNG VẬT LÝ              │    │        (Windows 11, macOS, Ubuntu,...)    │
 │        (CPU, RAM, Storage, Network)       │    ├───────────────────────────────────────────┤
 │                                           │    │             PHẦN CỨNG VẬT LÝ              │
 └───────────────────────────────────────────┘    └───────────────────────────────────────────┘
```

---

### 3.2.1. Hypervisor Type 1 (Bare-metal Hypervisor)

- **Đặc điểm kiến trúc:**
  - Còn được gọi là **Native Hypervisor** hoặc **Bare-metal Hypervisor**.
  - Hypervisor được cài đặt trực tiếp lên đĩa cứng của máy chủ vật lý, đóng vai trò như chính hệ điều hành của máy chủ đó (*Operating System-like*).
  - Không tồn tại bất kỳ hệ điều hành Host OS trung gian nào bên dưới. Hypervisor nắm toàn quyền kiểm soát trực tiếp phần cứng và bộ nhớ máy chủ.
- **Ưu điểm vượt trội:**
  - **Hiệu năng xuất sắc:** Không chịu tổn hao tài nguyên từ một hệ điều hành máy chủ đa dụng bên dưới. Độ trễ I/O và độ trễ ngắt cực thấp.
  - **Bảo mật tối đa:** Bề mặt tấn công (*Attack Surface*) cực kỳ nhỏ gọn vì Hypervisor chỉ chứa các đoạn mã tối giản phục vụ việc ảo hóa, không cài đặt các dịch vụ thừa (trình duyệt, giao diện đồ họa nặng nề, media player...).
  - **Độ tin cậy và Ổn định cao:** Không lo ngại việc một ứng dụng chạy nền của Host OS bị treo làm sập toàn bộ hệ thống máy ảo.
- **Nhược điểm:**
  - Danh mục tương thích phần cứng (*Hardware Compatibility List - HCL*) khắt khe. Chỉ hỗ trợ các dòng card mạng, RAID Controller của máy chủ chuyên dụng (Server Enterprise).
  - Khó sử dụng hơn đối với người dùng cá nhân; đòi hỏi quản trị viên phải cấu hình thông qua bảng điều khiển mạng (Web Interface) hoặc công cụ quản trị tập trung chuyên dụng.
- **Môi trường ứng dụng:** Tiêu chuẩn bắt buộc cho các **Data Center, Enterprise Private Cloud, Public Cloud** (AWS, Azure, GCP, Viettel Cloud, VNPT Cloud).

---

### 3.2.2. Hypervisor Type 2 (Hosted Hypervisor)

- **Đặc điểm kiến trúc:**
  - Còn được gọi là **Hosted Hypervisor**.
  - Hypervisor là một ứng dụng phần mềm thông thường được cài đặt bên trên một hệ điều hành chủ có sẵn (**Host OS** như Windows 11, macOS, Ubuntu Desktop).
  - Khi một máy ảo cần truy xuất CPU hay ổ cứng, yêu cầu phải đi qua 3 tầng: `Guest OS -> Type 2 Hypervisor -> Host OS -> Phần cứng vật lý`.
- **Ưu điểm:**
  - **Cực kỳ tiện lợi và thân thiện:** Cài đặt nhanh chóng như một phần mềm văn phòng thông thường (`.exe`, `.dmg`). Giao diện đồ họa phong phú, trực quan.
  - **Khả năng tương thích phần cứng rộng rãi:** Bất kỳ phần cứng nào được Host OS hỗ trợ (WiFi, Bluetooth, Card âm thanh, USB Webcam) đều có thể được Hypervisor nhận diện và chuyển tiếp vào máy ảo.
  - Dễ dàng trao đổi dữ liệu qua lại giữa máy ảo và máy thật thông qua cơ chế kéo thả (*Drag & Drop*) hoặc thư mục dùng chung (*Shared Folders*).
- **Nhược điểm:**
  - **Suy hao hiệu năng (High Overhead):** Phải chia sẻ tài nguyên tính toán với hàng trăm tiến trình chạy ngầm của Host OS.
  - **Bảo mật kém hơn:** Nếu Host OS bị nhiễm virus hoặc bị lỗi màn hình xanh (BSOD), toàn bộ các máy ảo đang chạy bên trong đều bị gián đoạn và có nguy cơ hỏng dữ liệu.
- **Môi trường ứng dụng:** Môi trường học tập, nghiên cứu của sinh viên, máy tính của lập trình viên (Developer Workstations), kiểm thử phần mềm trên nhiều hệ điều hành cục bộ.

---

### 3.2.3. Bảng so sánh toàn diện Type 1 và Type 2

| Tiêu chuẩn so sánh | Hypervisor Type 1 (Bare-metal) | Hypervisor Type 2 (Hosted) |
| :--- | :--- | :--- |
| **Vị trí cài đặt** | Cài trực tiếp lên phần cứng máy chủ (*Bare-metal*). | Cài như một ứng dụng trên nền Host OS. |
| **Sự phụ thuộc Host OS** | Hoàn toàn không có Host OS. | Phụ thuộc hoàn toàn vào tính ổn định của Host OS. |
| **Hiệu năng & Độ trễ** | Hiệu năng tiệm cận Native (**95% - 99%**), độ trễ thấp. | Suy hao đáng kể (**80% - 90%** hiệu năng Native). |
| **Khả năng quản lý tài nguyên** | Kiểm soát trực tiếp CPU, RAM cứng bằng thuật toán riêng. | Phụ thuộc vào cơ chế lập lịch tiến trình của Host OS. |
| **Mức độ an toàn bảo mật** | Rất cao, bề mặt tấn công cực nhỏ (Microkernel). | Phụ thuộc vào mức độ bảo mật của Host OS. |
| **Tương thích phần cứng** | Khắt khe, yêu cầu phần cứng máy chủ tương thích. | Linh hoạt, nhận mọi phần cứng mà Host OS hỗ trợ. |
| **Chi phí triển khai** | Thường yêu cầu phần cứng chuyên dụng và bản quyền đắt đỏ. | Miễn phí hoặc chi phí bản quyền cá nhân rất rẻ. |
| **Sản phẩm tiêu biểu** | VMware ESXi, KVM, Microsoft Hyper-V, Proxmox VE, Xen. | Oracle VM VirtualBox, VMware Workstation, Parallels. |

---

## 3.3. Các công nghệ và giải pháp ảo hóa phổ biến trên thị trường

Thị trường công nghệ ảo hóa hiện nay rất phong phú với nhiều giải pháp thương mại và mã nguồn mở phục vụ từ người dùng cá nhân đến các tập đoàn công nghệ lớn:

---

### 3.3.1. VMware ESXi (vSphere Ecosystem)

- **Phân loại:** Hypervisor Type 1 chuyên dụng.
- **Tổng quan:** Là giải pháp dẫn đầu thị trường doanh nghiệp suốt hơn hai thập kỷ, được phát triển bởi VMware (hiện nay thuộc Broadcom).
- **Kiến trúc:** Sử dụng nhân chuyên biệt siêu nhỏ gọn gọi là **VMkernel**. VMkernel trực tiếp quản lý vi xử lý, bộ nhớ và cung cấp hệ thống tệp tối ưu hóa cao cho máy ảo là **VMFS (Virtual Machine File System)**.
- **Tính năng nổi bật:**
  - **vMotion:** Di chuyển máy ảo đang hoạt động giữa các ESXi host mà không có downtime.
  - **Storage vMotion:** Di chuyển đĩa ảo giữa các mảng lưu trữ khác nhau trong khi VM vẫn đọc/ghi bình thường.
  - **Distributed Resource Scheduler (DRS):** Tự động cân bằng tải cụm máy chủ, tự động gom VM về ít host vào ban đêm để tắt bớt máy chủ tiết kiệm điện (DPM).
  - **Fault Tolerance (FT):** Chạy song song hai bản sao giống hệt nhau của 1 VM trên 2 server khác nhau theo thời gian thực (Zero-downtime khi sập máy chủ).
- **Đối tượng sử dụng:** Các tập đoàn tài chính, ngân hàng, viễn thông và các trung tâm dữ liệu khắt khe nhất.

---

### 3.3.2. Kernel-based Virtual Machine (KVM) & QEMU

- **Phân loại:** Hypervisor Type 1 mã nguồn mở (Tích hợp trong Linux Kernel).
- **Tổng quan:** KVM là module chính thức được tích hợp trực tiếp vào nhân Linux từ phiên bản 2.6.20 (năm 2007). KVM biến nhân Linux thành một Bare-metal Hypervisor hoàn chỉnh.
- **Kiến trúc mô hình phối hợp:**
  1. **KVM Kernel Module (`kvm.ko`, `kvm_intel.ko` / `kvm_amd.ko`):** Xử lý việc lập lịch vCPU và quản lý bộ nhớ trực tiếp thông qua phần cứng Intel VT-x/AMD-V.
  2. **QEMU (*Quick Emulator*):** Đóng vai trò không gian người dùng (*Userspace*), chịu trách nhiệm mô phỏng các thiết bị ngoại vi I/O (Bàn phím, chuột, card mạng ảo, card đồ họa).
  3. **Libvirt:** Thư viện và bộ công cụ API chuẩn hóa (đi kèm công cụ dòng lệnh `virsh`) giúp lập trình viên và quản trị viên dễ dàng điều khiển máy ảo KVM.
- **Ưu điểm:**
  - Mã nguồn mở 100%, hoàn toàn miễn phí, cộng đồng hỗ trợ toàn cầu khổng lồ.
  - Hiệu năng cực kỳ mạnh mẽ, kế thừa toàn bộ tính năng bảo mật tiên tiến của Linux (SELinux, AppArmor, cgroups).
  - Là hạt nhân cốt lõi vận hành các nền tảng đám mây mở như **OpenStack**, nền tảng **OpenShift Virtualization (KubeVirt)** và là nền móng của hệ thống siêu phân tán của Google Cloud, AWS Nitro Hypervisor.

---

### 3.3.3. Microsoft Hyper-V

- **Phân loại:** Hypervisor Type 1.
- **Tổng quan:** Giải pháp ảo hóa chiến lược của tập đoàn Microsoft, được tích hợp sẵn từ Windows Server 2008 và các bản Windows 10/11 Pro/Enterprise.
- **Kiến trúc phân vùng (Partitions):**
  - **Parent Partition (Phân vùng gốc):** Chạy hệ điều hành Windows quản trị, sở hữu các trình điều khiển phần cứng thực tế (*Hardware Device Drivers*) và điều khiển Hypervisor thông qua ngăn xếp ảo hóa (VMBus).
  - **Child Partitions (Phân vùng con):** Nơi các máy ảo khách vận hành cô lập. Giao tiếp I/O với phần cứng được tăng tốc thông qua giao thức **VMBus** và các trình điều khiển tối ưu hóa **VSC (Virtualization Service Clients)**.
- **Tính năng nổi bật:** Hỗ trợ tính năng ảo hóa lồng nhau (**Nested Virtualization**), Dynamic Memory (tự động co giãn RAM máy ảo theo tải thực tế), tích hợp chặt chẽ với Active Directory và hệ sinh thái đám mây lai **Azure Stack HCI**.

---

### 3.3.4. Xen Project (Citrix Hypervisor / XCP-ng)

- **Phân loại:** Hypervisor Type 1 (tiên phong kiến trúc Microkernel).
- **Tổng quan:** Khởi nguồn từ một dự án nghiên cứu của Đại học Cambridge, Xen là một trong những tượng đài lớn nhất của lịch sử ảo hóa.
- **Kiến trúc Domain:**
  - **Hypervisor Core:** Một lớp phần mềm siêu mỏng chạy ở mức đặc quyền cao nhất.
  - **Domain 0 (Dom0):** Một máy ảo đặc quyền đặc biệt chạy Linux, có quyền kiểm soát phần cứng thực tế và quản lý tất cả các máy ảo khác.
  - **Domain U (DomU):** Các máy ảo thông thường không có quyền truy cập trực tiếp phần cứng.
- **Lịch sử đóng góp:** Xen chính là nền tảng ảo hóa sơ khai đã giúp **Amazon Web Services (AWS)** xây dựng nên dịch vụ điện toán đám mây EC2 thống trị thế giới trong thập niên đầu tiên trước khi chuyển đổi sang Nitro/KVM. Hiện nay Xen tiếp tục phát triển mạnh mẽ qua bản phân phối mã nguồn mở **XCP-ng**.

---

### 3.3.5. Proxmox Virtual Environment (Proxmox VE)

- **Phân loại:** Nền tảng quản trị ảo hóa tích hợp Bare-metal Type 1 mã nguồn mở.
- **Tổng quan:** Được xây dựng trên nền bản phân phối **Debian Linux**, Proxmox VE là giải pháp hoàn chỉnh cho doanh nghiệp vừa và nhỏ (SMB) cũng như các hệ thống HomeLab.
- **Đặc điểm nổi bật:**
  - **Tích hợp "2 trong 1":** Hỗ trợ song song cả máy ảo đầy đủ với **KVM** và giải pháp vùng chứa siêu nhẹ với **LXC (Linux Containers)** trên cùng một giao diện quản lý.
  - **Giao diện Web GUI trực quan:** Quản lý toàn bộ cụm máy chủ (*Cluster*), mạng ảo, lưu trữ trực tiếp từ trình duyệt web mà không cần cài thêm phần mềm quản trị cồng kềnh.
  - **Hỗ trợ lưu trữ cấp doanh nghiệp:** Tích hợp sẵn hệ thống tệp **ZFS** và cụm lưu trữ phân tán **Ceph**, hỗ trợ cơ chế tự động sao lưu dữ liệu gia tăng (*Incremental Backup*) với Proxmox Backup Server.
  - Chi phí cực thấp, không có phí khóa tính năng bản quyền.

---

### 3.3.6. Oracle VM VirtualBox

- **Phân loại:** Hypervisor Type 2 (Hosted Hypervisor).
- **Tổng quan:** Ban đầu được phát triển bởi Innotek, sau đó thuộc Sun Microsystems và hiện nay được bảo trợ bởi Oracle.
- **Đặc điểm nổi bật:**
  - Mã nguồn mở (GPLv2), hoàn toàn miễn phí cho mục đích học tập và cá nhân.
  - **Đa nền tảng (*Cross-platform*):** Chạy được trên cả Windows, macOS (cả Intel và Apple Silicon), Linux và Solaris.
  - Hỗ trợ đa dạng các định dạng tệp đĩa ảo: Định dạng gốc của chính nó (`.vdi`), định dạng của VMware (`.vmdk`), định dạng của Microsoft (`.vhd`) và định dạng mở OVF/OVA.
  - Tính năng **Guest Additions** giúp tích hợp sâu máy ảo với máy thật: Tự động điều chỉnh độ phân giải màn hình, đồng bộ clipboard hai chiều, kéo thả tệp tin trực tiếp.
- **Đối tượng sử dụng:** Sinh viên, lập trình viên, chuyên gia kiểm thử bảo mật cần một môi trường thử nghiệm nhanh gọn trên laptop cá nhân.

---

# PHẦN 2: VIRTUAL MACHINE

# 4. Mục 4: Tổng quan về Virtual Machine

## 4.1. Khái niệm và kiến trúc của máy ảo

**Máy ảo (Virtual Machine - VM)** là một hệ thống máy tính hoàn chỉnh được tạo ra bằng phần mềm, vận hành độc lập trên nền tảng phần cứng vật lý. Đối với người dùng và các ứng dụng, máy ảo hoạt động và tương tác không khác gì một chiếc máy tính vật lý riêng biệt.

### Kiến trúc tổng thể của máy ảo:
```text
┌────────────────────────────────────────────────────────┐
│     Ứng dụng A        Ứng dụng B        Ứng dụng C     │
├────────────────────────────────────────────────────────┤
│    Guest OS 1        Guest OS 2        Guest OS 3      │
│  (Windows Server)     (Ubuntu)          (Debian)       │
├────────────────────────────────────────────────────────┤
│       vCPU, vRAM        vCPU, vRAM        vCPU, vRAM   │
│       vDisk, vNIC       vDisk, vNIC       vDisk, vNIC  │
├────────────────────────────────────────────────────────┤
│                 LỚP HYPERVISOR (VMM)                   │
├────────────────────────────────────────────────────────┤
│                  PHẦN CỨNG VẬT LÝ                      │
│            (CPU, RAM, Ổ cứng, Card mạng)               │
└────────────────────────────────────────────────────────┘
```

---

## 4.2. Phân biệt Host OS và Guest OS

Trong kiến trúc ảo hóa, hai khái niệm hệ điều hành cần được phân biệt rõ:

- **Host OS (Hệ điều hành chủ):** Là hệ điều hành được cài đặt trực tiếp lên phần cứng máy vật lý (thường thấy ở mô hình Type 2 Hypervisor như VirtualBox chạy trên Windows/macOS, hoặc máy chủ Linux cài KVM). Host OS đóng vai trò cung cấp môi trường nền tảng để cài đặt và vận hành Hypervisor.
- **Guest OS (Hệ điều hành khách):** Là hệ điều hành được cài đặt bên trong từng máy ảo (như Ubuntu Server, Windows 10, Rocky Linux). Guest OS hoàn toàn bị cô lập trong không gian ảo do Hypervisor cấp phát và không có quyền truy cập trực tiếp vào hệ thống tệp hay tiến trình của Host OS.

---

## 4.3. Các thành phần phần cứng được ảo hóa

Khi một máy ảo được tạo, Hypervisor sẽ trừu tượng hóa và cấp phát các tài nguyên ảo tương ứng:

### 1. Bộ vi xử lý ảo (vCPU)
- Là các nhân CPU ảo được Hypervisor lập lịch thực thi luân phiên trên các lõi/luồng CPU vật lý (*Cores/Threads*).
- Một máy chủ có 8 core / 16 thread vật lý có thể cấp phát tổng cộng nhiều hơn 16 vCPU cho các máy ảo nhờ cơ chế chia sẻ thời gian (*Time-slicing*).

### 2. Bộ nhớ ảo (vRAM)
- Là dung lượng RAM ảo được cấp phát từ thanh RAM vật lý của máy chủ.
- Dữ liệu của Guest OS được nạp vào vùng nhớ này và được Hypervisor bảo vệ nghiêm ngặt, ngăn chặn các máy ảo đọc trộm dữ liệu bộ nhớ của nhau.

### 3. Ổ đĩa ảo (Virtual Disk)
Ổ đĩa của máy ảo thực chất chỉ là một hoặc nhiều tệp tin lớn nằm trên ổ cứng của máy chủ vật lý.
- **Các định dạng đĩa ảo phổ biến:**
  - `.vmdk`: Định dạng chuẩn của hệ sinh thái VMware.
  - `.qcow2` (*QEMU Copy-On-Write*): Định dạng chuẩn của KVM/QEMU, hỗ trợ nén, snapshot và dung lượng mở rộng linh hoạt.
  - `.vdi`: Định dạng gốc của Oracle VirtualBox.
  - `.vhdx`: Định dạng nâng cao của Microsoft Hyper-V.
- **Cơ chế cấp phát dung lượng đĩa:**
  - **Thin Provisioning (Cấp phát động):** Cấp phát dung lượng theo nhu cầu thực tế. Ví dụ tạo đĩa ảo 100GB nhưng hiện chỉ chứa 5GB dữ liệu thì file đĩa trên máy thật chỉ chiếm đúng 5GB. Giúp tiết kiệm đĩa lúc ban đầu.
  - **Thick Provisioning (Cấp phát cố định):** Chiếm trọn vẹn toàn bộ dung lượng ngay khi tạo (tạo 100GB là trừ ngay 100GB trên ổ cứng thật). Đem lại tốc độ ghi nhanh và ổn định hơn, tránh nguy cơ hết đĩa bất ngờ.

### 4. Giao diện mạng ảo (vNIC)
Máy ảo kết nối mạng thông qua card mạng ảo (*vNIC*), cắm vào một Switch ảo bên trong Hypervisor với 3 chế độ cơ bản:
- **NAT (Network Address Translation):** Máy ảo đi ra ngoài Internet thông qua địa chỉ IP của máy thật. Các thiết bị bên ngoài mạng LAN không thể chủ động kết nối vào máy ảo. Đây là chế độ mặc định, phù hợp để lướt web, tải gói phần mềm.
- **Bridged (Cầu nối):** Máy ảo kết nối trực tiếp vào mạng LAN vật lý như một máy tính độc lập, nhận một IP riêng cùng dải với router mạng nhà/công ty. Thích hợp khi muốn cấu hình máy ảo làm Web Server, Database Server cho các máy khác truy cập.
- **Host-Only:** Mạng nội bộ riêng biệt chỉ cho phép máy ảo giao tiếp với máy chủ thật (và các máy ảo khác cùng chế độ). Hoàn toàn ngắt kết nối với Internet bên ngoài, phù hợp làm môi trường thử nghiệm bảo mật (Lab mã độc, test phần mềm).

---

## 4.4. Cơ chế chia sẻ tài nguyên giữa các VM trên cùng máy vật lý

Để tối ưu chi phí và kiểm soát chất lượng dịch vụ (*QoS*), Hypervisor sử dụng 4 cơ chế quản lý tài nguyên:

1. **Overcommit (Cấp phát vượt mức):**
   - Cho phép tổng lượng tài nguyên cấp phát cho các máy ảo vượt quá tài nguyên vật lý thực tế của máy chủ.
   - *Ví dụ:* Máy chủ có 32GB RAM nhưng tạo 4 máy ảo, mỗi máy ảo cấu hình 10GB RAM (tổng 40GB). Cơ chế này hoạt động an toàn dựa trên thực tế là hiếm khi tất cả các máy ảo cùng chạy 100% tải cùng một thời điểm.
2. **Reservation (Mức cam kết tối thiểu):**
   - Đảm bảo một lượng CPU hoặc RAM tối thiểu luôn được giữ riêng cho máy ảo, ngay cả khi hệ thống bị quá tải.
3. **Limit (Mức trần tối đa):**
   - Giới hạn lượng tài nguyên tối đa mà một máy ảo được phép tiêu thụ, ngăn chặn việc một máy ảo bị treo hay chạy vòng lặp vô tận làm cạn kiệt tài nguyên của toàn bộ máy chủ.
4. **Share (Độ ưu tiên tranh chấp):**
   - Trọng số ưu tiên (High, Normal, Low) được dùng để phân chia tài nguyên khi xảy ra tình trạng tắc nghẽn. Máy ảo có chỉ số Share cao hơn sẽ được phục vụ trước.

---

# 5. Mục 5: Cơ chế hoạt động của máy ảo

## 5.1. Nguyên lý kiểm soát phần cứng

Trong một hệ thống ảo hóa, Guest OS vẫn vận hành với niềm tin rằng nó đang kiểm soát toàn bộ phần cứng. Tuy nhiên:
- Mọi thao tác truy xuất tài nguyên phần cứng (CPU, thanh ghi, bảng phân trang, thiết bị I/O) của Guest OS đều bị Hypervisor giám sát.
- Khi Guest OS phát ra một lệnh đặc quyền, Hypervisor sẽ kiểm tra tính hợp lệ và điều phối lệnh đó xuống phần cứng thực tế một cách an toàn.

---

## 5.2. Chế độ phần cứng hỗ trợ (Root, Non-Root, VM Entry, VM Exit)

Các CPU hiện đại (Intel VT-x / AMD-V) bổ sung thêm 2 chế độ đặc quyền phần cứng:
- **VMX Root Operation:** Chế độ có quyền hạn cao nhất, dành riêng cho Hypervisor chạy để kiểm soát phần cứng.
- **VMX Non-Root Operation:** Chế độ dành riêng cho máy ảo (Guest OS) chạy. Trong chế độ này, các chỉ lệnh thông thường vẫn chạy trực tiếp trên CPU với tốc độ gốc.

### Chu trình chuyển đổi:
- **VM Entry:** Thao tác Hypervisor bàn giao quyền điều khiển CPU cho máy ảo chạy ở chế độ Non-Root.
- **VM Exit:** Khi Guest OS phát ra lệnh đặc quyền hoặc xảy ra ngắt phần cứng, CPU tự động tạm ngưng máy ảo và chuyển quyền điều khiển về cho Hypervisor ở chế độ Root để xử lý, sau đó lại thực hiện VM Entry để máy ảo chạy tiếp.

---

## 5.3. Ảo hóa CPU và bộ nhớ (EPT/NPT)

### 1. Ảo hóa CPU
- Hypervisor hoạt động như một bộ lập lịch cấp cao (*Scheduler*). Nó chia nhỏ thời gian xử lý (*Time-slice*) của các nhân CPU vật lý và luân chuyển phục vụ các vCPU của từng máy ảo.

### 2. Ảo hóa bộ nhớ
- Để máy ảo không ghi đè lên bộ nhớ của nhau, địa chỉ bộ nhớ phải trải qua 2 tầng chuyển đổi:
  $$\text{Guest Virtual Address (GVA)} \longrightarrow \text{Guest Physical Address (GPA)} \longrightarrow \text{Host Physical Address (HPA)}$$
- Công nghệ **EPT (*Extended Page Tables* - Intel)** và **NPT (*Nested Page Tables* - AMD)** cho phép việc dịch địa chỉ hai tầng này được thực hiện trực tiếp bằng phần cứng vi xử lý, loại bỏ hoàn toàn độ trễ phần mềm.

---

## 5.4. Ảo hóa I/O và mô hình KVM + QEMU + libvirt

### 1. Ba phương pháp ảo hóa vào/ra (I/O Virtualization)
- **Emulation (Giả lập phần mềm):** Hypervisor mô phỏng lại từng linh kiện phần cứng cũ (như card mạng Intel Pro/1000, card âm thanh Sound Blaster). Rất tương thích nhưng hiệu năng chậm do tốn nhiều lần VM Exit.
- **Para-virtualization (Trình điều khiển VirtIO):** Guest OS được cài bộ driver VirtIO chuyên dụng. Máy ảo không giả lập phần cứng mà chủ động gửi dữ liệu trực tiếp vào hàng đợi bộ nhớ chia sẻ với Hypervisor. Tốc độ rất nhanh, là chuẩn mực trên Linux KVM.
- **PCI Passthrough & SR-IOV:** Gán trực tiếp một thiết bị phần cứng thật (như GPU rời Nvidia hoặc card mạng 10Gbps) vào riêng một máy ảo. Máy ảo giao tiếp trực tiếp với thiết bị mà không qua Hypervisor, đạt 100% hiệu năng gốc.

### 2. Mô hình phối hợp KVM + QEMU + libvirt:
- **KVM (Kernel Module):** Chạy bên trong nhân Linux, phụ trách điều phối vCPU và phân trang bộ nhớ (RAM).
- **QEMU (Userspace):** Xử lý việc giả lập các thiết bị ngoại vi I/O (chuột, bàn phím, màn hình, ổ đĩa, card mạng).
- **Libvirt:** Cung cấp API và công cụ dòng lệnh (`virsh`) chuẩn hóa, giúp người dùng quản trị máy ảo dễ dàng mà không cần gõ các câu lệnh QEMU phức tạp.

---

# 6. Mục 6: Vòng đời và quản lý VM

## 6.1. Các trạng thái vòng đời của máy ảo

Một máy ảo trải qua các trạng thái hoạt động chính:

```text
[Created] ──(Start)──> [Running] ──(Pause)──> [Paused]
   │                      │                      │
   │                      ├──(Shutdown/Stop)     │(Resume)
   │                      ↓                      ↓
 (Delete) <─────────  [Stopped] <─────────── [Running]
```

- **Created (Đã tạo):** Cấu hình phần cứng logic đã được định nghĩa trên hệ thống nhưng máy chưa bật nguồn.
- **Running (Đang chạy):** Máy ảo đang hoạt động, chiếm dụng tài nguyên CPU và RAM vật lý.
- **Paused (Tạm dừng):** Toàn bộ trạng thái của CPU máy ảo bị đóng băng, dữ liệu RAM vẫn được giữ nguyên nhưng máy ảo không tiêu thụ chu kỳ CPU.
- **Stopped / Shutoff (Đã tắt):** Hệ điều hành máy ảo đã tắt, giải phóng hoàn toàn vCPU và vRAM. Dữ liệu được lưu trữ an toàn trong tệp đĩa ảo.

---

## 6.2. Cấp phát và điều chỉnh tài nguyên động

- **Tạo và Xóa VM:** Tạo máy ảo từ file ISO hệ điều hành; khi không còn nhu cầu thì xóa bỏ (*Delete/Destroy*) để giải phóng ổ cứng.
- **Điều chỉnh tài nguyên:** Dễ dàng tăng giảm số lượng vCPU, tăng dung lượng RAM hoặc mở rộng dung lượng đĩa ảo khi ứng dụng phát triển lớn hơn.
- **Hot-add / Hot-plug:** Nhiều hệ điều hành máy chủ và Hypervisor hiện đại cho phép gắn thêm RAM, vCPU hoặc gắn thêm ổ đĩa ảo ngay khi máy ảo đang hoạt động mà không cần phải khởi động lại.

---

## 6.3. Phân biệt Snapshot, Clone và Template

| Tiêu chí | Snapshot (Ảnh chụp nhanh) | Clone (Nhân bản máy ảo) | Template (Khuôn mẫu chuẩn) |
| :--- | :--- | :--- | :--- |
| **Bản chất** | Ghi lại trạng thái đĩa và RAM tại một thời điểm chính xác. | Tạo ra một bản sao máy ảo mới hoàn chỉnh và độc lập. | Một máy ảo chuẩn đã được cấu hình sẵn và đóng băng làm mẫu. |
| **Mục đích sử dụng** | Dùng để thử nghiệm an toàn trước khi cập nhật phần mềm, cài gói mới. Nếu lỗi có thể quay về (*Revert*). | Nhân bản môi trường làm việc để giao cho lập trình viên khác hoặc tạo node mới trong cụm. | Dùng làm bản gốc chuẩn để tự động tạo hàng loạt máy ảo giống hệt nhau một cách nhanh chóng. |
| **Tính độc lập** | Phụ thuộc 100% vào đĩa gốc. Không thể xóa đĩa gốc nếu muốn giữ snapshot. | **Full Clone:** Độc lập hoàn toàn.<br/>**Linked Clone:** Chia sẻ đĩa gốc. | Là bản mẫu chỉ đọc, các máy ảo mới sinh ra kế thừa cấu hình từ Template. |
| **Khuyến nghị** | **Không dùng Snapshot để thay thế bản Backup lâu dài** (để lâu sẽ làm chậm đĩa). | Chiếm dung lượng đĩa tương đương máy gốc nếu dùng Full Clone. | Tiết kiệm thời gian chuẩn bị hệ điều hành cho các dự án lớn. |

---

## 6.4. Backup, Restore, Live Migration và High Availability

1. **Backup và Restore (Sao lưu & Phục hồi):**
   - Sao chép toàn bộ tệp tin cấu hình (`.xml`, `.vmx`) và tệp đĩa ảo (`.qcow2`, `.vmdk`) sang một hệ thống lưu trữ độc lập (NAS/SAN/Cloud). Khi máy chủ chính gặp sự cố thảm họa, có thể nhập lại file để phục hồi nguyên trạng hệ thống.
2. **Live Migration (Dịch chuyển không gián đoạn):**
   - Cho phép di chuyển một máy ảo đang chạy từ máy chủ vật lý A sang máy chủ vật lý B thông qua mạng LAN nội bộ tốc độ cao.
   - Toàn bộ dữ liệu RAM và trạng thái CPU được sao chép liên tục sang máy mới. Khi đồng bộ xong, quyền điều khiển chuyển sang máy B trong tích tắc (Downtime xấp xỉ vài mili-giây, người dùng xem web không hề nhận ra máy chủ vừa bị đổi).
3. **High Availability - HA (Tính sẵn sàng cao):**
   - Nếu máy chủ vật lý A bị hỏng nguồn hoặc chết phần cứng đột ngột, cụm quản trị (*Cluster*) sẽ phát hiện sự cố và tự động khởi động lại máy ảo trên máy chủ vật lý B còn sống, giúp dịch vụ sớm hoạt động trở lại mà không cần kỹ sư đến tận nơi sửa chữa.

---

# PHẦN 3: TỔNG QUAN VỀ CONTAINER

# 8. Mục 8: Container là gì?

## 8.1. Khái niệm Container và Containerization
- **Container:** Là một đơn vị phần mềm độc lập, đóng gói trọn vẹn mã nguồn của ứng dụng cùng toàn bộ các tệp thư viện, biến môi trường và cấu hình cần thiết để ứng dụng có thể chạy được.
- **Containerization:** Là công nghệ ảo hóa ở cấp độ hệ điều hành. Khác với máy ảo phải mô phỏng toàn bộ phần cứng, các container cùng chia sẻ chung một nhân hệ điều hành máy chủ duy nhất nhưng vẫn chạy biệt lập với nhau.

## 8.2. Mục đích và vai trò của Container
- **Đảm bảo tính nhất quán môi trường:** Loại bỏ hoàn toàn sự cố ứng dụng chạy được trên máy của lập trình viên nhưng bị lỗi khi đưa lên máy chủ kiểm thử hoặc môi trường sản xuất.
- **Khởi động tức thì:** Container khởi động chỉ trong vài giây hoặc mili-giây vì không cần nạp lại toàn bộ hệ điều hành như máy ảo.
- **Tiết kiệm tài nguyên:** Kích thước nhẹ, chỉ chiếm dụng CPU và RAM tương đương với các tiến trình thông thường, giúp tận dụng tối đa dung lượng máy chủ.
- **Phù hợp kiến trúc vi dịch vụ và DevOps:** Đóng gói từng dịch vụ nhỏ độc lập, hỗ trợ quy trình tích hợp và triển khai tự động nhanh chóng.

## 8.3. Phân biệt Container và Virtual Machine

| Tiêu chí | Virtual Machine | Container |
| :--- | :--- | :--- |
| **Kiến trúc** | Chạy trên Hypervisor, mỗi máy ảo có một hệ điều hành khách hoàn chỉnh | Chạy trực tiếp trên Host OS, các container dùng chung nhân Linux Kernel |
| **Mức độ cô lập** | Cô lập mức phần cứng, an toàn và độc lập tuyệt đối | Cô lập mức tiến trình thông qua các tính năng của nhân Linux |
| **Dung lượng lưu trữ** | Rất lớn, từ vài GB đến hàng chục GB | Rất nhẹ, thường chỉ từ vài chục MB đến vài trăm MB |
| **Thời gian khởi động** | Chậm, mất từ 30 giây đến vài phút | Cực nhanh, chỉ mất vài mili-giây đến vài giây |
| **Hiệu năng thực thi** | Có suy hao do tầng trung gian Hypervisor xử lý | Gần như tương đương trực tiếp máy vật lý |

## 8.4. Hạn chế của Container và trường hợp nên dùng VM
- **Hạn chế của Container:**
  - Vì dùng chung nhân hệ điều hành nên ranh giới bảo mật không độc lập tuyệt đối bằng máy ảo. Nếu nhân hệ điều hành bị tấn công, các container trên cùng máy chủ đều có nguy cơ bị ảnh hưởng.
  - Phụ thuộc hệ điều hành nền: Không thể chạy trực tiếp container của hệ điều hành khác nếu không tương thích nhân (ví dụ container Linux không chạy trực tiếp trên nhân Windows thuần túy).
- **Trường hợp nên sử dụng VM:**
  - Khi cần chạy đồng thời các hệ điều hành hoàn toàn khác nhau trên cùng một máy chủ (ví dụ chạy cả Windows Server và Linux trên cùng phần cứng).
  - Khi ứng dụng yêu cầu mức độ bảo mật cao nhất và cô lập tài nguyên phần cứng nghiêm ngặt như hệ thống ngân hàng, tài chính.
  - Các hệ thống ứng dụng cũ yêu cầu can thiệp sâu vào cấu hình nhân hệ điều hành hoặc trình điều khiển phần cứng đặc thù.

---

# 9. Mục 9: Cơ chế hoạt động của Container trên Linux

## 9.1. Container sử dụng chung Linux Kernel như thế nào?
- Trong hệ điều hành Linux, mỗi container thực chất chỉ là một nhóm các tiến trình thông thường của máy chủ.
- Nhờ vào hai tính năng cốt lõi của nhân Linux là Namespaces và Control Groups, các tiến trình này bị giới hạn tầm nhìn và tài nguyên, khiến chúng hoạt động khép kín như một hệ điều hành độc lập.

## 9.2. Linux Namespaces và vai trò cô lập tài nguyên
Linux Namespaces tạo ra các không gian tách biệt cho từng container:
- **PID Namespace:** Cô lập cây tiến trình. Tiến trình chính của container luôn thấy mình mang mã định danh số 1 và không thể nhìn thấy các tiến trình bên ngoài máy chủ thật.
- **NET Namespace:** Cung cấp cho container card mạng, địa chỉ IP, bảng định tuyến và cổng kết nối riêng biệt.
- **MNT Namespace:** Cô lập hệ thống tệp và các điểm gắn kết thư mục, giúp container chỉ thao tác trên cây thư mục của riêng nó.
- **UTS Namespace:** Cho phép mỗi container đặt tên máy chủ và tên miền riêng.
- **IPC Namespace:** Ngăn chặn các tiến trình trong container can thiệp vào bộ nhớ chia sẻ hoặc hàng đợi thông điệp của container khác.
- **USER Namespace:** Ánh xạ tài khoản người dùng. Tài khoản quản trị root bên trong container chỉ tương đương với tài khoản người dùng thông thường trên máy chủ thật, nâng cao tính an toàn.

## 9.3. Control Groups - Quản lý và giới hạn tài nguyên
Control Groups là công cụ của nhân Linux dùng để đo lường và áp đặt hạn mức tài nguyên cho container:
- **Giới hạn CPU:** Quy định tỷ lệ thời gian xử lý hoặc số nhân CPU tối đa mà container được phép dùng, tránh việc một container chiếm dụng toàn bộ năng lực máy chủ.
- **Giới hạn RAM:** Đặt mức trần bộ nhớ cho container. Nếu vượt quá giới hạn này, cơ chế Out of Memory của Linux sẽ tự động tắt tiến trình trong container để bảo vệ hệ thống.
- **Giới hạn tốc độ I/O và mạng:** Giới hạn băng thông đọc ghi ổ đĩa và lưu lượng truyền nhận dữ liệu qua mạng của từng container.

## 9.4. Union Filesystem, OverlayFS và cơ chế Copy-on-Write
- **Union Filesystem:** Là công nghệ hệ thống tệp cho phép xếp chồng nhiều thư mục khác nhau lên nhau để tạo thành một cây thư mục thống nhất duy nhất.
- **OverlayFS:** Là trình điều khiển lưu trữ mặc định phổ biến hiện nay:
  - **Tầng dưới (LowerDir):** Chứa các lớp của hình ảnh container, hoàn toàn ở chế độ chỉ đọc.
  - **Tầng trên (UpperDir):** Là tầng ghi đọc tạm thời của riêng container, lưu trữ dữ liệu mới tạo hoặc sửa đổi.
  - **Tầng kết hợp (MergedDir):** Là không gian thư mục hoàn chỉnh mà ứng dụng bên trong container nhìn thấy.
- **Cơ chế Copy-on-Write:** Khi container cần chỉnh sửa một tệp tin có sẵn từ tầng dưới, hệ thống sẽ tự động tạo một bản sao của tệp đó lên tầng trên rồi mới ghi đè nội dung. Tệp gốc ở tầng dưới vẫn được giữ nguyên trạng, bảo toàn tính bất biến của hình ảnh gốc.

## 9.5. Phân biệt Container Image và Container Runtime
- **Container Image:** Là gói tĩnh chỉ đọc đóng gói toàn bộ mã nguồn, thư viện và cấu hình ứng dụng. Image được lưu trên đĩa hoặc chia sẻ qua các kho lưu trữ.
- **Container Runtime:** Là phần mềm chịu trách nhiệm tải image, thiết lập Namespace, cgroups và trực tiếp khởi chạy container:
  - **Runtime bậc thấp:** Làm việc trực tiếp với nhân hệ điều hành để tạo container (ví dụ: runc, crun).
  - **Runtime bậc cao:** Quản lý vòng đời hình ảnh, mạng, lưu trữ và điều khiển runtime bậc thấp (ví dụ: containerd, CRI-O, Docker Engine).

## 9.6. Chuẩn OCI
Chuẩn OCI (Open Container Initiative) là bộ tiêu chuẩn công nghiệp mở giúp các công nghệ container có thể tương thích với nhau:
- **Image Specification:** Quy định định dạng chuẩn của hình ảnh container và cách đóng gói các lớp dữ liệu. Nhờ chuẩn này, image đóng gói bởi Docker có thể chạy được trên Podman hoặc Kubernetes.
- **Runtime Specification:** Quy định cách thức cấu hình và khởi chạy container trên hệ điều hành, đảm bảo một container sẽ chạy giống hệt nhau trên bất kỳ công cụ tương thích OCI nào.

---

# PHẦN 4: DOCKER CƠ BẢN

# 10. Mục 10: Tổng quan về Docker

## 10.1. Docker là gì và tại sao cần Docker?
- **Docker là gì:** Docker là một nền tảng mã nguồn mở hàng đầu thế giới giúp tự động hóa quá trình đóng gói, phân phối và khởi chạy ứng dụng bên trong các container độc lập.
- **Tại sao cần Docker:**
  - Giải quyết bài toán kinh điển: "Ứng dụng chạy bình thường trên máy của tôi nhưng lại lỗi trên máy của bạn".
  - Chuẩn hóa môi trường làm việc từ máy cá nhân của lập trình viên, qua máy chủ thử nghiệm đến hệ thống sản xuất.
  - Tối ưu hóa việc phân bổ tài nguyên phần cứng và tăng tốc độ triển khai ứng dụng lên gấp nhiều lần so với máy ảo truyền thống.

## 10.2. Các thành phần chính trong hệ sinh thái Docker
Kiến trúc Docker hoạt động theo mô hình máy khách - máy chủ:
- **Docker Client:** Là công cụ dòng lệnh giúp người dùng tương tác trực tiếp bằng cách gõ các lệnh như docker build, docker run, docker pull.
- **Docker Daemon:** Là tiến trình dịch vụ chạy ngầm trên máy chủ, đóng vai trò đầu não tiếp nhận các yêu cầu từ Docker Client để quản lý và điều phối các image, container, mạng và ổ đĩa lưu trữ.
- **Docker Host:** Là máy tính hoặc máy chủ vật lý/máy ảo nơi cài đặt Docker Daemon và trực tiếp thực thi các container.
- **Docker Registry:** Kho lưu trữ tập trung chuyên dùng để quản lý và chia sẻ các Docker Image giữa các thành viên trong đội ngũ phát triển hoặc cho cộng đồng toàn cầu.

## 10.3. Docker Engine và Docker Desktop
- **Docker Engine:** Là gói cài đặt cốt lõi dạng dịch vụ chạy nền trên hệ điều hành Linux. Docker Engine hoạt động hoàn toàn qua dòng lệnh, không có giao diện đồ họa, nhẹ và tối ưu cho môi trường máy chủ sản xuất.
- **Docker Desktop:** Là ứng dụng hoàn chỉnh có giao diện đồ họa dành riêng cho máy tính cá nhân chạy Windows và macOS. Docker Desktop tích hợp sẵn Docker Engine, Docker Compose, Kubernetes và một máy ảo Linux chạy ngầm để phục vụ lập trình viên phát triển ứng dụng thuận tiện.

## 10.4. Các phiên bản Docker
- **Docker Community Edition (Docker CE):** Phiên bản miễn phí mã nguồn mở, hỗ trợ đầy đủ các tính năng cốt lõi của container, phù hợp cho cá nhân, nhà phát triển và các doanh nghiệp vừa và nhỏ.
- **Docker Enterprise:** Bộ giải pháp thương mại dành cho các tổ chức lớn, bổ sung dịch vụ hỗ trợ kỹ thuật trực tiếp, quản lý truy cập bảo mật tập trung, quét tự động các lỗ hổng bảo mật và chứng nhận an toàn cho các hệ thống doanh nghiệp.

## 10.5. Khái niệm Image, Container, Registry và chu trình Build - Ship - Run
- **Mối quan hệ:**
  - **Image:** Khuôn mẫu tĩnh, chỉ đọc, chứa mã nguồn và môi trường chạy của ứng dụng.
  - **Container:** Một phiên bản thực thi đang chạy được sinh ra từ Image. Một Image có thể khởi tạo hàng ngàn Container giống hệt nhau.
  - **Registry:** Kho chứa các Image.
- **Chu trình Build - Ship - Run:**
  - **Build:** Lập trình viên viết mã nguồn cùng tệp Dockerfile, sau đó dùng lệnh đóng gói thành Docker Image.
  - **Ship:** Đẩy Image vừa tạo lên Registry để chia sẻ an toàn và đồng bộ cho toàn bộ hệ thống.
  - **Run:** Máy chủ kiểm thử hoặc máy chủ sản xuất tải Image từ Registry về và khởi chạy thành Container ổn định.

---

# 11. Mục 11: Cài đặt và cấu hình Docker trên Linux

## 11.1. Cài đặt Docker Engine trên Ubuntu
Quy trình cài đặt Docker chuẩn mực từ kho lưu trữ chính thức trên Ubuntu bao gồm các bước:

```bash
# 1. Gỡ bỏ các phiên bản cũ không chính thức nếu có
sudo apt remove -y docker docker-engine docker.io containerd runc

# 2. Cập nhật chỉ mục gói và cài đặt các tiện ích cần thiết
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

# 3. Thêm khóa GPG bảo mật chính thức của Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 4. Thêm kho lưu trữ APT chính thức của Docker vào hệ thống
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. Cài đặt Docker Engine, CLI, containerd và các plugin đi kèm
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

## 11.2. Chạy Docker không cần sudo và lưu ý bảo mật
Theo mặc định, Docker Daemon giao tiếp qua socket Unix và chỉ cho phép người dùng root hoặc người dùng trong nhóm docker truy cập:
```bash
# Tạo nhóm docker nếu chưa có và thêm người dùng hiện tại vào nhóm
sudo usermod -aG docker $USER

# Áp dụng nhóm mới ngay trong phiên làm việc hiện tại
newgrp docker
```
- **Lưu ý bảo mật quan trọng:** Nhóm docker có quyền hạn kiểm soát hệ thống tương đương quyền root. Bất kỳ người dùng nào thuộc nhóm này đều có thể khởi chạy container gắn ổ cứng của máy chủ thật để xem hoặc chỉnh sửa tệp hệ thống. Do đó, chỉ nên thêm tài khoản tin cậy vào nhóm docker.

## 11.3. Kiểm tra và quản lý dịch vụ Docker
- **Kiểm tra phiên bản và thông tin hệ thống:**
  ```bash
  docker version
  docker info
  ```
- **Quản lý dịch vụ qua systemctl:**
  ```bash
  # Xem trạng thái đang chạy của Docker
  sudo systemctl status docker

  # Khởi động dịch vụ Docker
  sudo systemctl start docker

  # Thiết lập Docker tự động chạy cùng hệ điều hành khi máy chủ khởi động
  sudo systemctl enable docker
  ```

## 11.4. Cấu hình Docker Proxy
Khi máy chủ làm việc trong mạng nội bộ doanh nghiệp bắt buộc phải đi qua máy chủ ủy thác Proxy để ra ngoài Internet:
- **Proxy cho Docker Daemon:** Để Docker Daemon tải được Image từ Docker Hub, tạo tệp cấu hình dịch vụ `/etc/systemd/system/docker.service.d/http-proxy.conf`:
  ```ini
  [Service]
  Environment="HTTP_PROXY=http://proxy.company.internal:8080"
  Environment="HTTPS_PROXY=http://proxy.company.internal:8080"
  Environment="NO_PROXY=localhost,127.0.0.1,docker.internal"
  ```
  Sau đó tải lại cấu hình và khởi động lại dịch vụ: `sudo systemctl daemon-reload && sudo systemctl restart docker`.
- **Proxy cho Client và Container:** Cấu hình trong tệp `~/.docker/config.json` để các ứng dụng chạy bên trong container tự động nhận diện Proxy khi truy cập mạng bên ngoài.

## 11.5. Cấu hình Docker Registry nội bộ và insecure registries
- **Lợi ích Registry nội bộ:** Giúp lưu trữ các Image riêng tư của doanh nghiệp ngay trong mạng cục bộ, bảo vệ bí mật mã nguồn và tăng tốc độ tải image.
- **Cấu hình chứng chỉ CA tin cậy:** Tạo thư mục tương ứng với tên miền của Registry tại `/etc/docker/certs.d/<tên-miền-registry>:<cổng>/` và sao chép tệp chứng chỉ `ca.crt` vào đây.
- **Insecure Registries trong daemon.json:** Trong môi trường thử nghiệm nội bộ chưa có chứng chỉ SSL, cấu hình tệp `/etc/docker/daemon.json` để cho phép Docker kết nối qua giao thức HTTP không mã hóa:
  ```json
  {
    "insecure-registries": ["192.168.1.100:5000", "registry.local:5000"]
  }
  ```
  Khởi động lại Docker bằng `sudo systemctl restart docker` để thiết lập có hiệu lực.

---

# 12. Mục 12: Các câu lệnh Docker cơ bản

## 12.1. Nhóm lệnh quản lý Image
- `docker pull <tên-image>:<tag>`: Tải image từ Registry về máy cục bộ.
  ```bash
  docker pull nginx:alpine
  ```
- `docker images`: Liệt kê tất cả các image hiện đang có trên máy, hiển thị dung lượng và Image ID.
- `docker rmi <image-id>`: Xóa một hoặc nhiều image khỏi ổ cứng.
  ```bash
  docker rmi nginx:alpine
  ```

## 12.2. Nhóm lệnh khởi tạo và điều khiển Container
Lệnh cốt lõi để tạo và chạy container là `docker run`:
```bash
docker run -d --name web-server -p 8080:80 -v /data/html:/usr/share/nginx/html -e ENVIRONMENT=production --restart unless-stopped nginx:alpine
```
- **Ý nghĩa các tùy chọn quan trọng:**
  - `-d`: Chạy ngầm trong nền, trả lại quyền điều khiển cho cửa sổ dòng lệnh.
  - `-it`: Kết hợp chế độ tương tác và cấp phát terminal ảo để gõ lệnh trực tiếp.
  - `--name`: Đặt tên riêng dễ nhớ cho container thay vì để Docker tự sinh tên ngẫu nhiên.
  - `-p <cổng-máy-chủ>:<cổng-container>`: Chuyển tiếp cổng mạng, ví dụ mở cổng 8080 trên máy thật trỏ vào cổng 80 của ứng dụng web trong container.
  - `-v <đường-dẫn-máy-thật>:<đường-dẫn-container>`: Gắn thư mục hoặc phân vùng ổ cứng từ máy chủ vào container để dữ liệu không bị mất khi container tắt.
  - `-e <tên-biến>=<giá-trị>`: Thiết lập biến môi trường cho ứng dụng.
  - `--rm`: Tự động dọn dẹp và xóa bỏ container ngay khi tiến trình kết thúc.

- **Các lệnh điều khiển vòng đời:**
  - `docker ps`: Liệt kê các container đang hoạt động.
  - `docker ps -a`: Liệt kê tất cả các container, bao gồm cả những container đã tắt hoặc gặp lỗi.
  - `docker stop <tên>`: Tắt container một cách an toàn bằng cách gửi tín hiệu thông báo cho ứng dụng lưu dữ liệu rồi mới dừng.
  - `docker start <tên>`: Bật lại một container đã dừng trước đó.
  - `docker restart <tên>`: Khởi động lại container.
  - `docker rm <tên>`: Xóa bỏ container đã tắt khỏi hệ thống. Dùng `docker rm -f` nếu muốn ép xóa container đang chạy.

## 12.3. Nhóm lệnh theo dõi, giám sát và gỡ lỗi
- `docker logs -f <tên>`: Xem toàn bộ nhật ký đầu ra của ứng dụng trong container; tùy chọn `-f` giúp theo dõi liên tục theo thời gian thực.
- `docker exec -it <tên> sh`: Truy cập trực tiếp vào bên trong container đang chạy để kiểm tra tệp tin và chạy lệnh thử nghiệm.
- `docker inspect <tên>`: Hiển thị toàn bộ thông tin chi tiết cấu hình dạng dữ liệu JSON như địa chỉ IP nội bộ, cổng kết nối, biến môi trường và điểm gắn ổ cứng.
- `docker stats`: Bảng điều khiển giám sát theo thời gian thực mức tiêu thụ phần trăm CPU, dung lượng RAM, lưu lượng mạng và I/O đĩa của tất cả các container.
- `docker top <tên>`: Liệt kê các tiến trình của hệ điều hành đang thực thi bên trong container.
- `docker cp <nguồn> <đích>`: Sao chép tệp tin hoặc thư mục qua lại giữa máy chủ thật và bên trong container.
- `docker diff <tên>`: Xem danh sách các tệp tin đã bị thêm mới, sửa đổi hoặc xóa bỏ so với image ban đầu.

## 12.4. Chính sách tự khởi động lại và giới hạn tài nguyên Container
- **Chính sách tự khởi động lại qua tùy chọn `--restart`:**
  - `no`: Mặc định, container không bao giờ tự khởi động lại nếu bị tắt hoặc lỗi.
  - `always`: Luôn tự động bật lại container bất kể vì lý do gì, kể cả khi máy chủ Docker vừa khởi động lại.
  - `unless-stopped`: Tự động khởi động lại trong mọi trường hợp, trừ khi người quản trị chủ động ra lệnh tắt container.
  - `on-failure`: Chỉ tự khởi động lại khi ứng dụng bên trong gặp sự cố thoát với mã lỗi khác 0.
- **Giới hạn tài nguyên để bảo vệ máy chủ:**
  - `--cpus="1.5"`: Giới hạn ứng dụng chỉ được dùng tối đa năng lực tương đương 1.5 nhân CPU vật lý.
  - `--memory="512m"`: Giới hạn ứng dụng chỉ được dùng tối đa 512MB RAM, ngăn chặn tình trạng tràn bộ nhớ làm ảnh hưởng đến các ứng dụng khác trên máy chủ.

---

# PHẦN 5: DOCKER IMAGE VÀ DOCKERFILE

# 13. Mục 13: Docker Image là gì?

## 13.1. Khái niệm Docker Image

Docker Image là một **khuôn mẫu chỉ đọc** bất biến, đóng gói toàn bộ những thành phần cần thiết để một ứng dụng có thể khởi chạy và vận hành độc lập, bao gồm:
1. **Mã nguồn ứng dụng (*Application Code*):** Các tệp nhị phân, kịch bản, tài nguyên cấu hình.
2. **Môi trường thực thi (*Runtime*):** Trình thông dịch hoặc máy ảo như Node.js, Python, JVM, .NET Core.
3. **Thư viện hệ thống (*System Libraries*):** Các tệp `.so` hoặc `.dll` phụ thuộc của hệ điều hành nền.
4. **Công cụ hệ điều hành (*System Tools/Binaries*):** Các lệnh cơ bản như `sh`, `ls`, `curl` (tùy thuộc vào Base OS).
5. **Cấu hình và biến môi trường (*Metadata & Configs*):** Thư mục làm việc (`WORKDIR`), cổng mạng lắng nghe (`EXPOSE`), biến môi trường (`ENV`), lệnh khởi chạy mặc định (`CMD`/`ENTRYPOINT`).

```text
┌────────────────────────────────────────────────────────┐
│                      DOCKER IMAGE                      │
│               (Bất biến - Chỉ đọc - Read-Only)         │
├────────────────────────────────────────────────────────┤
│  Layer N:   Cấu hình ứng dụng & Metadata (ENV, CMD)    │
│  Layer 3:   Mã nguồn ứng dụng (Source code / Binaries) │
│  Layer 2:   Các gói phụ thuộc (Dependencies, Libraries)│
│  Layer 1:   Môi trường thực thi (Runtime: Node, Python)│
│  Layer 0:   Base OS Filesystem (Alpine / Debian-slim)  │
└────────────────────────────────────────────────────────┘
```

**Tính chất cốt lõi của Docker Image:**
- **Tính bất biến (*Immutability*):** Một khi Image đã được tạo ra, nội dung của các layer không bao giờ thay đổi. Nếu cần cập nhật mã nguồn hay thư viện, một Image mới với định danh mới phải được xây dựng.
- **Tính di động (*Portability*):** Triết lý *"Build Once, Run Anywhere"* đảm bảo cùng một Image sẽ chạy giống hệt nhau trên máy tính cá nhân của lập trình viên, máy chủ kiểm thử (Staging) hay cụm máy chủ phân tán Kubernetes trên đám mây (Production).
- **Tính độc lập (*Self-contained*):** Ứng dụng không phụ thuộc vào các thư viện hay phiên bản phần mềm được cài đặt sẵn trên Host OS.

---

## 13.2. Phân biệt Image và Container

Trong công nghệ phần mềm, mối quan hệ giữa Docker Image và Docker Container tương tự như mối quan hệ giữa **Lớp** và **Đối tượng** trong lập trình hướng đối tượng, hoặc giữa **Tệp chương trình trên đĩa** và **Tiến trình đang chạy trong bộ nhớ**.

### Bảng so sánh chi tiết giữa Docker Image và Docker Container

| Tiêu chí | Docker Image | Docker Container |
| :--- | :--- | :--- |
| **Bản chất kỹ thuật** | Mẫu tĩnh, tập hợp các lớp hệ thống tệp chỉ đọc (*Read-only layers*). | Thực thể động (*Runtime instance*), là tiến trình hệ thống chạy trong không gian cô lập. |
| **Quyền truy cập dữ liệu** | Hoàn toàn chỉ đọc (*Read-Only*). | Đọc và Ghi (*Read-Write*) thông qua một lớp chứa dữ liệu tạm mỏng (*Thin Container Layer*). |
| **Trạng thái tồn tại** | Tĩnh, lưu trữ cố định trên ổ đĩa hoặc trên Registry. | Động, có trạng thái vòng đời: `created`, `running`, `paused`, `stopped`, `exited`. |
| **Tài nguyên phần cứng** | Chỉ chiếm dung lượng lưu trữ trên đĩa cứng (*Disk space*). | Chiếm dụng CPU, RAM, Network I/O, Disk I/O được giới hạn bởi Linux `cgroups`. |
| **Khả năng nhân bản** | Có thể dùng 1 Image duy nhất để khởi tạo hàng ngàn Container cùng lúc. | Mỗi Container là một phiên bản cô lập độc lập với hệ thống mạng và PID riêng biệt. |
| **Thời gian khởi động** | Cần thời gian tải (*Pull*) hoặc xây dựng (*Build*). | Khởi động tức thì trong vài phần trăm giây (chỉ tương đương khởi tạo tiến trình OS). |

### Kiến trúc phân tầng lưu trữ của Container

Khi một Container được khởi chạy từ Image, Docker Storage Driver (phổ biến nhất hiện nay là **OverlayFS**) sẽ xếp chồng các thư mục lên nhau theo cơ chế:
1. **LowerDir (Các layer của Image):** Nằm ở phía dưới, hoàn toàn ở chế độ chỉ đọc (*read-only*).
2. **UpperDir (Container Layer):** Nằm ở trên cùng, hỗ trợ đọc/ghi (*read-write*).
3. **MergedDir (Hệ thống tệp hợp nhất):** Không gian thư mục ảo mà tiến trình bên trong container nhìn thấy.
4. **WorkDir:** Thư mục nội bộ của hệ thống Linux phục vụ việc xử lý chuyển đổi dữ liệu tầng dưới lên tầng trên.

```text
┌────────────────────────────────────────────────────────┐
│  MergedDir: Không gian tệp hiển thị cho Container      │
├────────────────────────────────────────────────────────┤
│  UpperDir: Writable Container Layer (R/W - Lưu tạm)    │  <-- Dữ liệu mới ghi / sửa đổi
├────────────────────────────────────────────────────────┤
│  LowerDir (Layer 3): Mã nguồn ứng dụng (Read-only)     │
│  LowerDir (Layer 2): Thư viện phụ thuộc (Read-only)    │  <-- Docker Image Layers
│  LowerDir (Layer 1): Base OS File system (Read-only)   │
└────────────────────────────────────────────────────────┘
```

---

## 13.3. Cấu trúc Image Layers và lệnh `docker history`

### 1. Cơ chế Layering (Xếp chồng các lớp)
Một Docker Image không phải là một khối tệp nguyên khối duy nhất, mà được cấu tạo từ nhiều **Lớp (*Layers*)** xếp chồng lên nhau:
- Mỗi dòng chỉ thị trong Dockerfile làm biến đổi hệ thống tệp (như `RUN`, `COPY`, `ADD`) sẽ sinh ra một layer mới chứa sự khác biệt (*delta/diff*) so với layer tiền nhiệm.
- Các layer được định danh bằng mã băm mật mã học SHA-256 (`Content-Addressable Storage`). Nhờ đó, nếu nhiều Image khác nhau cùng sử dụng chung một Base OS (ví dụ `ubuntu:22.04`), tầng nhân Docker chỉ lưu trữ layer đó **một lần duy nhất** trên ổ đĩa, giúp tiết kiệm đáng kể không gian lưu trữ và băng thông truyền tải.

### 2. Cơ chế Copy-on-Write (CoW)
- Nếu Container chỉ thực hiện đọc tệp, tệp sẽ được truy cập trực tiếp từ layer tương ứng trong Image ở tầng dưới.
- Khi Container thực hiện sửa đổi một tệp có sẵn trong Image, tệp đó sẽ được sao chép nguyên trạng từ **LowerDir (Read-only)** lên **UpperDir (Read-write)** trước khi sửa đổi. Layer gốc bên dưới vẫn giữ nguyên trạng thái ban đầu, bảo toàn tính bất biến tuyệt đối của Docker Image.

### 3. Khảo sát cấu trúc Layer bằng lệnh `docker history`

Lệnh `docker history` cho phép bóc tách toàn bộ lịch sử xây dựng của một Image, hiển thị chi tiết chỉ thị nào đã tạo ra layer nào cùng kích thước tương ứng.

**Cú pháp:**
```bash
docker history [OPTIONS] IMAGE
```

**Các tùy chọn quan trọng:**
- `--no-trunc`: Không cắt ngắn câu lệnh tạo layer, hiển thị toàn văn lệnh Dockerfile.
- `--human`, `-H`: Định dạng kích thước dung lượng dễ đọc cho con người (B, KB, MB, GB).
- `-q`, `--quiet`: Chỉ hiển thị danh sách các mã ID của các layer.

**Ví dụ thực tế và phân tích đầu ra:**
```bash
docker history node:20.18.0-alpine3.20
```

*Đầu ra minh họa:*
```text
IMAGE          CREATED        CREATED BY                                      SIZE      COMMENT
17b9b1e9c20a   2 days ago     CMD ["node"]                                    0B        
<missing>      2 days ago     ENTRYPOINT ["docker-entrypoint.sh"]             0B        
<missing>      2 days ago     COPY docker-entrypoint.sh /usr/local/bin/       388B      
<missing>      2 days ago     RUN /bin/sh -c apk add --no-cache --virtual …   7.84MB    
<missing>      2 days ago     ENV YARN_VERSION=1.22.22                        0B        
<missing>      2 days ago     RUN /bin/sh -c apk add --no-cache curl make …   128MB     
<missing>      2 days ago     ENV NODE_VERSION=20.18.0                        0B        
<missing>      2 days ago     /bin/sh -c #(nop) ADD file:... in /             7.79MB    
```

**Phân tích:**
- Các chỉ thị như `ENV`, `CMD`, `ENTRYPOINT`, `WORKDIR` chỉ cập nhật siêu dữ liệu (*metadata/configuration JSON*) nên kích thước layer là **0B**.
- Các chỉ thị làm thay đổi tệp trên đĩa như `RUN` (cài đặt gói phần mềm qua `apk`) hoặc `COPY`/`ADD` sinh ra dung lượng cụ thể (ví dụ `128MB`, `7.79MB`).
- Ký hiệu `<missing>` xuất hiện trong kiến trúc Docker hiện đại (BuildKit) đối với các tầng trung gian không gắn nhãn trực tiếp trên local host nhưng vẫn liên kết chặt chẽ thông qua chuỗi mã băm `ChainID`.

---

## 13.4. Image Tag và Image Digest

### 1. Image Tag
- **Bản chất:** Tag là một nhãn văn bản thân thiện với con người, có vai trò tương tự như tên một nhánh hoặc một thẻ trong Git.
- **Tính khả biến:** Tag có thể bị ghi đè để trỏ tới một Image ID khác bất kỳ lúc nào. Ví dụ, hôm nay tag `node:20` trỏ tới bản vá 20.18.0, nhưng tuần sau có thể bị nhà phát triển chuyển sang trỏ tới bản 20.18.1.
- **Cú pháp định danh:** `repository:tag` (ví dụ: `nginx:1.27`, `python:3.12-slim`).

### 2. Image Digest
- **Bản chất:** Digest là một mã băm mật mã học duy nhất xác thực nội dung của Image Manifest theo chuẩn SHA-256 (`sha256:hash`).
- **Tính bất biến tuyệt đối (*Immutable*):** Nếu nội dung của bất kỳ byte nào trong bất kỳ layer nào bị thay đổi, mã Digest sẽ thay đổi hoàn toàn. Digest không bao giờ có thể bị ghi đè hoặc tráo đổi nội dung.
- **Cú pháp định danh:** `repository@sha256:<hash>`

### So sánh rủi ro trong môi trường Production

| Tiêu chuẩn | Sử dụng Tag (ví dụ `my-app:v1.0`) | Sử dụng Digest (`my-app@sha256:...`) |
| :--- | :--- | :--- |
| **Độ tin cậy** | Có nguy cơ bị ghi đè ngoài ý muốn khi có ai đó push đè image cùng tag. | Đảm bảo 100% tất cả các node máy chủ luôn chạy chính xác cùng một phiên bản mã máy. |
| **Chống tấn công chuỗi cung ứng (*Supply Chain Security*)** | Kẻ tấn công có thể chiếm tài khoản Registry và đẩy mã độc vào tag có sẵn. | Ngăn chặn hoàn toàn việc tráo đổi mã độc, vì mã Digest sẽ không khớp. |
| **Khả năng tái lập (*Reproducibility*)** | Kém hơn, vì các dependency hệ thống có thể bị cập nhật ngầm. | Tuyệt đối, phù hợp với các hệ thống tài chính, ngân hàng và CI/CD nghiêm ngặt. |

**Ví dụ lệnh tải Image bằng Digest:**
```bash
docker pull nginx@sha256:e0b73e83a0d24cb1f379c6a084a3419962f15b879acfad05eb09498b52fa0f6d
```

---

## 13.5. Docker Hub và Private Registry

Registry là một dịch vụ máy chủ chuyên dụng chịu trách nhiệm lưu trữ, quản lý và phân phối các Docker Image. Bên trong một Registry có thể chứa nhiều **Kho lưu trữ**, và mỗi Repository lại chứa nhiều phiên bản Image được phân biệt bởi các Tag.

```text
┌────────────────────────────────────────────────────────────────────────┐
│                          DOCKER REGISTRY                               │
│  ┌────────────────────────┐  ┌──────────────────────────────────────┐  │
│  │ Repository: my-web-app │  │ Repository: auth-service             │  │
│  │  ├── Tag: 1.0.0        │  │  ├── Tag: 2.1.0                      │  │
│  │  ├── Tag: 1.0.1        │  │  ├── Tag: 2.1.1                      │  │
│  │  └── Tag: latest       │  │  └── Tag: sha256:abcd...             │  │
│  └────────────────────────┘  └──────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────────┘
```

### 1. Docker Hub (Public Registry mặc định)
- Là trung tâm chia sẻ Image lớn nhất thế giới do tập đoàn Docker Inc quản lý.
- **Phân loại Repository:**
  - *Official Images:* Các Image được kiểm định chất lượng nghiêm ngặt (như `ubuntu`, `nginx`, `redis`, `node`). Được gọi trực tiếp không cần tiền tố namespace (ví dụ: `docker pull redis`).
  - *Community / User Images:* Các Image do người dùng hoặc tổ chức tải lên, bắt buộc có định dạng `username/repository` (ví dụ: `vinh tung/my-web:1.0`).
- **Hạn chế:** Người dùng không trả phí bị giới hạn số lượt kéo Image (thường là 100-200 lượt kéo trong mỗi chu kỳ 6 giờ).

### 2. Private Registry (Kho lưu trữ nội bộ doanh nghiệp)
Trong môi trường sản xuất thực tế, các doanh nghiệp bắt buộc phải sử dụng Private Registry nhằm:
- **Bảo mật tuyệt đối sở hữu trí tuệ:** Không để lộ mã nguồn phần mềm ra môi trường công cộng.
- **Tối ưu băng thông nội bộ:** Tốc độ kéo Image giữa các máy chủ trong cùng mạng nội bộ (LAN) hoặc cùng trung tâm dữ liệu đám mây (Cloud VPC) có thể đạt tốc độ 10Gbps–25Gbps, vượt trội so với kéo qua Internet.
- **Kiểm soát tuân thủ và bảo mật:** Tích hợp kiểm định lỗ hổng bảo mật tự động, chữ ký số chứng thực tính toàn vẹn của Image.

### Các giải pháp Private Registry phổ biến
1. **Docker Registry v2 (Distribution):** Mã nguồn mở cơ bản, gọn nhẹ, phù hợp cho môi trường thử nghiệm nội bộ cục bộ.
2. **Harbor:** Nền tảng Registry chuẩn doanh nghiệp của CNCF (Cloud Native Computing Foundation), hỗ trợ phân quyền vai trò (RBAC), quét mã độc và lỗ hổng (Trivy), sao chép giữa các datacenter (Replication) và ký số xác thực (Cosign/Notary).
3. **Các dịch vụ Cloud Managed Registry:**
   - **AWS ECR** (*Elastic Container Registry*).
   - **GCP Artifact Registry** (thế hệ mới thay thế Container Registry).
   - **Azure ACR** (*Azure Container Registry*).
   - **GitHub Container Registry (ghcr.io)**.

---

  ## 13.6. Các lệnh `docker pull`, `docker tag`, `docker push`

  ### 1. Lệnh `docker pull`
  - Tải Image từ Registry về máy chủ cục bộ.
  - Cơ chế thực hiện: Docker phân tích Image Manifest, kiểm tra trong kho đệm máy chủ xem layer nào đã tồn tại. Nếu đã có sẵn thì bỏ qua, nếu chưa có thì tải song song các layer nén về và tự động giải nén.

  ```bash
  # Cú pháp đầy đủ:
  docker pull [OPTIONS] [REGISTRY_HOST[:PORT]/][NAMESPACE/]REPOSITORY[:TAG|@DIGEST]

  # Ví dụ kéo image chính thức từ Docker Hub:
  docker pull python:3.11-slim

  # Ví dụ kéo từ Private Registry công ty:
  docker pull harbor.mycompany.vn/core/payment-service:2.4.1
  ```

  ### 2. Lệnh `docker tag`
  - Gán nhãn cho một Image có sẵn để chuẩn bị đưa lên Registry mục tiêu.
  - **Bản chất kỹ thuật:** Lệnh `docker tag` **không nhân bản dữ liệu**, không tạo ra một tệp tin hay layer mới nào trên ổ cứng. Nó hoạt động như một con trỏ hoặc một liên kết mềm trong bảng chỉ mục của Docker Engine, trỏ tới cùng một Image ID.

  ```bash
  # Cú pháp:
  docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]

  # Ví dụ: Gán nhãn image cục bộ sang định dạng chuẩn của Docker Hub cá nhân
  docker tag local-web:1.0 vinhtung/cloud-training-app:1.0.0
  ```

  ### 3. Lệnh `docker push`
  - Tải Image từ máy tính cục bộ lên kho chứa từ xa.
  - Trước khi thực hiện lệnh push, bắt buộc phải đăng nhập thành công vào Registry qua lệnh `docker login`.
  - **Cơ chế Deduplication:** Docker chỉ tải lên những layer mà trên Registry chưa có. Nếu layer nền (ví dụ Base OS) đã được một ứng dụng khác tải lên trước đó, Docker sẽ ghi nhận và tái sử dụng ngay lập tức.

  ```bash
  docker push vinhtung/cloud-training-app:1.0.0
  ```

---

## 13.7. Quy tắc đặt tên và quản lý phiên bản Image

### 1. Chuẩn đặt tên đầy đủ của Docker Image
Một định danh Image chuẩn quốc tế bao gồm 4 phần:

$$\text{[Registry URL]} / \text{[Namespace/Tổ chức]} / \text{[Tên Repository]} : \text{[Phiên bản Tag]}$$

```text
harbor.enterprise.com /   devops-team    /      api-gateway    :      v1.4.2
└─────────┬─────────┘   └───────┬──────┘      └──────┬──────┘       └───┬──┘
    Registry Host           Namespace            Repository             Tag
```
*Nếu bỏ qua `Registry Host`, Docker mặc định trỏ về `docker.io` (Docker Hub).*  
*Nếu bỏ qua `Namespace`, Docker mặc định hiểu là `library` (dành cho Official Images).*  
*Nếu bỏ qua `Tag`, Docker mặc định gán là `:latest`.*

### 2. Quản lý phiên bản theo chuẩn Semantic Versioning (SemVer)
Chuẩn phiên bản kinh điển gồm 3 chữ số: `MAJOR.MINOR.PATCH` (ví dụ `2.4.12`):
- **MAJOR (Số 2):** Khi có những thay đổi lớn gây phá vỡ tính tương thích ngược (*Breaking Changes*).
- **MINOR (Số 4):** Bổ sung thêm tính năng mới nhưng vẫn đảm bảo tương thích ngược với phiên bản cũ.
- **PATCH (Số 12):** Các bản sửa lỗi (*Bug fixes*), vá lỗ hổng bảo mật nhỏ.

### 3. Chiến lược gán nhãn đa tầng (*Multi-tier Tagging Strategy*)
Trong quy trình CI/CD chuyên nghiệp, mỗi khi một bản dựng hoàn tất, người ta thường gán nhiều tag song song cho cùng một Image ID:
- Gán phiên bản cụ thể: `app:1.2.3`
- Gán phiên bản gom cụm: `app:1.2` và `app:1`
- Gán mã băm commit của Git: `app:git-a1c8f3e` (giúp truy vết chính xác nguồn gốc mã nguồn)
- Gán mã số định danh bản dựng: `app:build-421`

### 4. Tại sao KHÔNG ĐƯỢC dùng `:latest` trong môi trường Production?
Những rủi ro chí mạng bao gồm:
1. **Tính không tất định (*Non-deterministic*):** `:latest` không có nghĩa là "phiên bản ổn định nhất", mà chỉ là tag mặc định mà Docker tự gán khi lập trình viên quên không điền tag. Hôm nay `latest` có thể là bản 1.0, nhưng ngày mai ai đó vô tình push bản thử nghiệm 2.0 đè lên thì `latest` bị biến đổi.
2. **Khó khăn khi khôi phục sự cố (*Rollback Failure*):** Nếu phiên bản mới triển khai gặp lỗi nghiêm trọng, đội ngũ vận hành không thể ra lệnh rollback về bản `latest` trước đó vì cả hai đều mang cùng một cái tên.
3. **Hiện tượng bất đồng bộ giữa các Node (Node Inconsistency):** Trong cụm Kubernetes có 5 máy chủ worker, Node A đã tải `latest` từ sáng hôm qua (chạy bản v1), Node B bị mất mạng đến chiều mới tải `latest` (chạy bản v2). Kết quả là cùng một hệ thống nhưng các máy chủ lại chạy mã nguồn khác nhau, gây ra lỗi ngẫu nhiên cực kỳ khó gỡ lỗi.

---

## 13.8. Lưu và nạp Image offline: `docker save` và `docker load`

Trong môi trường thực tế, không phải hệ thống nào cũng có kết nối Internet để kéo Image từ Docker Hub. Ví dụ các hệ thống mạng quân sự, ngân hàng, viễn thông lõi thường vận hành trong mô hình **Air-gapped (Mạng cô lập vật lý)**. Bộ đôi lệnh `docker save` và `docker load` chính là giải pháp để luân chuyển Image qua các thiết bị lưu trữ gắn ngoài (như USB hoặc đĩa quang).

```text
[Máy phát triển (Có Internet)]                  [Máy chủ Air-Gapped (Mạng biệt lập)]
        │                                                         │
   docker save                                               docker load
        │                                                         │
        ▼                                                         ▼
[my-app.tar.gz]  ──────── (Chép qua USB / Ổ cứng) ───────>  [my-app.tar.gz]
```

### 1. Lệnh `docker save`
Đóng gói một hoặc nhiều Docker Image (kèm theo toàn bộ các layer lịch sử, thông tin commit, metadata và tag) thành một tệp tin lưu trữ chuẩn nén `.tar`.

```bash
# Lưu 1 image ra file tar:
docker save -o my-web-app.tar my-web-app:1.0.0

# Lưu đồng thời nhiều image và kết hợp nén gzip để giảm dung lượng tệp:
docker save nginx:alpine redis:alpine | gzip > production-infra.tar.gz
```

### 2. Lệnh `docker load`
Đọc tệp tin nén `.tar` và nạp toàn bộ các Image cùng các layer và tag tương ứng trở lại vào Docker Engine của máy chủ đích.

```bash
# Nạp từ file tar thông thường:
docker load -i my-web-app.tar

# Nạp từ file tar đã được nén gzip:
docker load < production-infra.tar.gz
```

### Bảng đối chiếu bản chất giữa `docker save/load` và `docker export/import`

Đây là câu hỏi thường xuyên xuất hiện trong các bài thi chứng chỉ và phỏng vấn kỹ sư DevOps/Cloud:

| Tiêu chí | `docker save` / `docker load` | `docker export` / `docker import` |
| :--- | :--- | :--- |
| **Đối tượng áp dụng** | Thao tác trên **Docker Image**. | Thao tác trên **Docker Container**. |
| **Cấu trúc Layer** | **Bảo toàn nguyên vẹn** tất cả các layer lịch sử cấu thành nên Image. | **Làm phẳng hoàn toàn (*Flatten*)**; gộp toàn bộ thành một layer duy nhất, làm mất lịch sử các tầng. |
| **Lưu trữ Metadata** | Giữ nguyên các metadata khai báo trong Dockerfile ban đầu (`ENV`, `WORKDIR`, `CMD`, `ENTRYPOINT`, `EXPOSE`). | **Mất sạch metadata**. Khi import trở lại, bắt buộc phải khai báo lại lệnh chạy thủ công bằng cờ `--change`. |
| **Mục đích sử dụng chính** | Sao lưu, phân phối Image đầy đủ giữa các máy chủ không có mạng Internet. | Xuất nhanh toàn bộ cây thư mục tệp tin hiện tại của một container đang chạy để làm việc độc lập. |

---

# 14. Mục 14: Xây dựng Docker Image bằng Dockerfile

## 14.1. Dockerfile là gì?

Dockerfile là một **tệp tin văn bản thuần** chứa một tập hợp có thứ tự các chỉ thị và tham số hướng dẫn Docker Engine tự động hóa việc biên dịch, lắp ghép và xây dựng một Docker Image hoàn chỉnh từ mã nguồn.

**Vai trò trong Cloud:**
- **Triết lý Cơ sở hạ tầng dưới dạng mã:** Môi trường thực thi ứng dụng được định nghĩa bằng mã nguồn, lưu trữ trong hệ thống quản lý mã nguồn Git, cho phép kiểm tra lịch sử thay đổi (*version control*), bình duyệt mã nguồn (*code review*), và tự động kích hoạt tiến trình kiểm thử/triển khai liên tục (CI/CD).
- **Loại bỏ hiện tượng "Chạy trên máy tôi nhưng lỗi trên máy anh":** Mọi thành phần phụ thuộc đều được chuẩn hóa chính xác từng phiên bản.

---

## 14.2. Phân tích chi tiết các chỉ thị cơ bản trong Dockerfile

### 1. `FROM` - Chỉ thị mở đầu bắt buộc
- Khai báo **Base Image** nền tảng để xây dựng Image mới. Một Dockerfile hợp lệ luôn bắt đầu bằng chỉ thị `FROM` (ngoại trừ lệnh `ARG` nếu được dùng để truyền tên version cho `FROM`).
- **Phân loại Base Image:**
  - `scratch`: Image rỗng hoàn toàn, 0 byte. Dùng cho các ứng dụng biên dịch nhị phân độc lập không cần thư viện C runtime (như Go, Rust).
  - `alpine`: Hệ điều hành siêu nhẹ (~5MB), sử dụng thư viện `musl libc` và trình quản lý gói `apk`. Tối ưu kích thước nhưng cần chú ý tính tương thích với các gói biên dịch C cần `glibc`.
  - `debian-slim` / `ubuntu`: Cung cấp đầy đủ thư viện `glibc` chuẩn, loại bỏ các tài liệu man page và ứng dụng đồ họa thừa, cân bằng giữa tương thích và kích thước (~50–80MB).

```dockerfile
# Sử dụng base image có ghim phiên bản cụ thể
FROM node:20.18.0-alpine3.20
```

### 2. `RUN` - Thực thi lệnh khi Build Image
- Thực thi các câu lệnh trên một layer mới trong quá trình build và ghi lại kết quả thành một layer bất biến tiếp theo.
- Thường dùng để cập nhật gói hệ thống, biên dịch mã nguồn, cài đặt phần mềm phụ trợ.

```dockerfile
# Xấu: Tạo nhiều layer thừa, làm phình to kích thước image
RUN apt-get update
RUN apt-get install -y curl
RUN rm -rf /var/lib/apt/lists/*

# Tốt: Gộp thành một lệnh duy nhất bằng toán tử && và xóa ngay bộ nhớ đệm trong cùng một layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*
```

### 3. `COPY` vs `ADD` - Sao chép tệp vào Image

| Tiêu chí | Chỉ thị `COPY` | Chỉ thị `ADD` |
| :--- | :--- | :--- |
| **Bản chất** | Chỉ đơn thuần sao chép tệp hoặc thư mục từ máy chủ Host vào hệ thống tệp của Image. | Có đầy đủ chức năng của `COPY`, cộng thêm 2 tính năng phụ nâng cao. |
| **Tính năng tự giải nén** | Không tự động giải nén. | **Tự động giải nén** các tệp nén dạng `.tar`, `.tar.gz`, `.tar.bz2` vào thư mục đích. |
| **Tải từ URL từ xa** | Không hỗ trợ tải từ Internet. | Cho phép chỉ định nguồn là một đường link URL HTTP/HTTPS. |
| **Khuyến nghị sử dụng** | **Được khuyến nghị 99% trường hợp** do tính rõ ràng, minh bạch và an toàn. | **Hạn chế dùng**. Để tải từ xa nên dùng `RUN curl/wget` kết hợp xóa tệp nén ngay để tránh lưu tệp thừa vào layer. |

```dockerfile
# Sử dụng COPY (Khuyên dùng)
COPY package.json package-lock.json ./

# Sử dụng ADD khi cần giải nén trực tiếp một file lưu trữ tarball
ADD configs.tar.gz /etc/app/configs/
```

### 4. `WORKDIR` - Thiết lập thư mục làm việc
- Định nghĩa thư mục làm việc hiện hành cho bất kỳ chỉ thị nào nằm phía sau nó như `RUN`, `CMD`, `ENTRYPOINT`, `COPY`, `ADD`.
- Nếu thư mục này chưa tồn tại trong Image, Docker sẽ **tự động tạo mới**.
- **Tuyệt đối tránh** dùng chuỗi `RUN cd /app` vì mỗi lệnh `RUN` chạy trong một subshell độc lập, lệnh `cd` sẽ không có hiệu lực cho các dòng tiếp theo.

```dockerfile
WORKDIR /usr/src/app
```

### 5. `ENV` vs `ARG` - Quản lý biến cấu hình

| Tiêu chí | Chỉ thị `ARG` | Chỉ thị `ENV` |
| :--- | :--- | :--- |
| **Vòng đời tồn tại** | **Chỉ tồn tại trong quá trình Build**. Biến mất hoàn toàn khi Image đã tạo xong. | **Tồn tại vĩnh viễn** trong cả quá trình Build và trong Container khi chạy thực tế. |
| **Ghi đè giá trị** | Truyền qua cờ: `docker build --build-arg KEY=VAL`. | Truyền qua cờ: `docker run -e KEY=VAL` hoặc file `.env`. |
| **Trường hợp áp dụng** | Chỉ định phiên bản thư viện build, cờ biên dịch nội bộ. | Thiết lập cấu hình hệ thống: `NODE_ENV`, `PORT`, `DATABASE_URL`. |

### 6. `EXPOSE` - Tài liệu hóa cổng mạng
- Khai báo cho Docker và người dùng biết rằng Container dự kiến sẽ lắng nghe kết nối tại cổng mạng nào khi chạy.
- **Lưu ý:** Chỉ thị `EXPOSE` **không hề tự động mở hoặc map port** ra ngoài máy chủ Host. Nó chỉ đóng vai trò như một nhãn tài liệu thông tin. Để máy ngoài truy cập được vào cổng này, bắt buộc phải dùng cờ `-p <host_port>:<container_port>` khi gõ lệnh `docker run`.

```dockerfile
EXPOSE 3000/tcp
```

### 7. `USER` - Nguyên tắc an toàn Non-Root
- Theo mặc định, Docker chạy mọi tiến trình bên trong container dưới tài khoản siêu người dùng `root` (UID = 0).
- Nếu mã nguồn có lỗ hổng hoặc container bị tấn công thoát quyền (*Container Breakout*), kẻ tấn công có thể kiểm soát toàn bộ máy chủ Host.
- Chỉ thị `USER` chuyển đổi ngữ cảnh thực thi sang một người dùng thông thường không có đặc quyền quản trị.

```dockerfile
# Tạo nhóm và tài khoản người dùng appuser, sau đó chuyển đổi quyền
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
```

### 8. `HEALTHCHECK` - Giám sát sức khỏe dịch vụ
- Giúp Docker Engine chủ động kiểm tra xem ứng dụng bên trong có thực sự hoạt động tốt hay không, thay vì chỉ kiểm tra tiến trình có còn sống hay không.
- Các tham số:
  - `--interval`: Khoảng thời gian định kỳ giữa các lần kiểm tra (mặc định: `30s`).
  - `--timeout`: Thời gian tối đa chờ phản hồi trước khi coi lần kiểm tra đó là thất bại (mặc định: `30s`).
  - `--start-period`: Thời gian chờ ứng dụng khởi động xong trước khi bắt đầu tính lỗi (mặc định: `0s`).
  - `--retries`: Số lần thất bại liên tiếp để chuyển trạng thái Container sang `unhealthy` (mặc định: `3`).

```dockerfile
HEALTHCHECK --interval=20s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/healthz || exit 1
```

### 9. `LABEL` và `VOLUME`
- **`LABEL`:** Thêm thông tin mô tả metadata dạng khóa-giá trị (*key-value*) cho Image (ví dụ tác giả, phiên bản, giấy phép, commit SHA).
- **`VOLUME`:** Khai báo một điểm gắn kết dữ liệu (*mount point*), hướng dẫn Docker rằng thư mục này cần lưu dữ liệu độc lập với vòng đời của container nhằm duy trì tính bền vững.

---

## 14.3. Phân biệt `CMD` và `ENTRYPOINT`; Exec form và Shell form

### 1. Phân biệt hai dạng cú pháp (Exec form vs Shell form)

Đây là một trong những kiến thức quan trọng nhất về quản trị tiến trình hệ thống trong Docker:

```dockerfile
# Dạng 1: Shell form (KHÔNG KHUYẾN NGHỊ)
CMD node index.js

# Dạng 2: Exec form (CHUẨN BẮT BUỘC TRONG PRODUCTION)
CMD ["node", "index.js"]
```

#### Bản chất tầng hệ điều hành:
- **Khi dùng Shell form (`CMD node index.js`):**
  Docker Engine sẽ khởi chạy ứng dụng thông qua lệnh bọc của Shell: `/bin/sh -c "node index.js"`.
  Khi đó, tiến trình **PID 1** của container là `/bin/sh`, còn ứng dụng Node.js của chúng ta chỉ là một tiến trình con. Hầu hết các shell mặc định **không chuyển tiếp (*forward*) tín hiệu Unix Signals** (như `SIGTERM`) cho tiến trình con.
  Hệ quả: Khi gõ `docker stop`, tín hiệu dừng an toàn không tới được ứng dụng; Docker Engine phải chờ hết 10 giây timeout và sau đó gửi tín hiệu hủy diệt cứng `SIGKILL`, khiến ứng dụng bị ngắt đột ngột, làm hỏng dữ liệu đang ghi dở hoặc ngắt kết nối cơ sở dữ liệu bất thường.
- **Khi dùng Exec form (`CMD ["node", "index.js"]`):**
  Lệnh `node` được gọi trực tiếp bằng lời gọi hệ thống `execve()`. Tiến trình của ứng dụng sẽ trở thành **PID 1** thực thụ bên trong Container.
  Hệ quả: Ứng dụng đón nhận trực tiếp tín hiệu `SIGTERM`, cho phép thực hiện quy trình **Dừng an toàn (*Graceful Shutdown*)**, đóng hết kết nối mạng và lưu trạng thái trước khi thoát.

### 2. Sự phối hợp giữa `ENTRYPOINT` và `CMD`
- **`ENTRYPOINT`:** Xác định chương trình cố định chắc chắn sẽ chạy khi Container khởi động (đóng vai trò như tên tệp thực thi).
- **`CMD`:** Cung cấp các tham số đối số mặc định cho `ENTRYPOINT`. Các tham số này có thể dễ dàng bị ghi đè khi truyền thêm đối số từ dòng lệnh lúc chạy `docker run`.

```dockerfile
# Định nghĩa khung thực thi cố định
ENTRYPOINT ["node"]

# Định nghĩa đối số mặc định
CMD ["src/index.js"]
```

**Bảng kết hợp các tình huống thực thi:**

| Câu lệnh `docker run` | Tiến trình thực tế được khởi chạy trong Container |
| :--- | :--- |
| `docker run my-app` | `node src/index.js` *(Sử dụng đối số mặc định của CMD)* |
| `docker run my-app --version` | `node --version` *(Đối số `--version` đã ghi đè lên `src/index.js`)* |
| `docker run --entrypoint python my-app test.py` | `python test.py` *(Ghi đè hoàn toàn cả ENTRYPOINT và CMD)* |

---

## 14.4. Xây dựng Image bằng `docker build` và cấu hình `.dockerignore`

### 1. Bản chất của Build Context
Khi chúng ta gõ lệnh:
```bash
docker build -t my-app:1.0 .
```
Dấu chấm `.` ở cuối đại diện cho **Build Context**. 
Trước khi tiến hành build, Docker Client sẽ quét toàn bộ thư mục tại dấu chấm này, đóng gói toàn bộ các tệp tin và thư mục con thành một tệp nén tarball và gửi qua socket tới Docker Daemon (`dockerd`).
Nếu thư mục chứa các thư mục rác hoặc dung lượng lớn như `node_modules` (500MB) hay `.git` (1GB), tốc độ bắt đầu build sẽ bị nghẽn nghiêm trọng, làm chậm tiến trình phát triển và CI/CD.

### 2. Tác dụng cốt lõi của `.dockerignore`
Tương tự như `.gitignore`, tệp `.dockerignore` giúp ngăn chặn Docker Client gửi các tệp không liên quan vào Build Context:
- **Tăng tốc độ build:** Giảm thời gian truyền dữ liệu giữa Client và Daemon từ vài chục giây xuống vài phần trăm giây.
- **Bảo mật tối đa:** Ngăn chặn tuyệt đối việc vô tình đưa các tệp nhạy cảm (như `.env`, `id_rsa`, `.git`, chứng chỉ SSL) vào bên trong Image, nơi bất kỳ ai kéo image về cũng có thể trích xuất ra được.
- **Tránh xung đột môi trường:** Ngăn chặn việc sao chép thư mục `node_modules` biên dịch trên máy Host (Windows/macOS) vào trong môi trường Linux Container.

---

## 14.5. Cơ chế Docker Build Cache và nguyên lý tối ưu tốc độ

Mỗi khi thực thi một dòng chỉ thị trong Dockerfile, Docker kiểm tra xem trong bộ nhớ đệm (*Cache*) đã có layer nào được tạo ra từ cùng một câu lệnh với dữ liệu đầu vào giống hệt trước đó hay chưa. Nếu có, Docker sẽ tái sử dụng lại layer đó (`Using cache` hoặc `CACHED`) mà không phải thực thi lại.

### Nguyên lý Vô hiệu hóa Cache (Cache Invalidation)
> Nếu bộ nhớ đệm của một layer bất kỳ bị mất hiệu lực (*busted*), thì **toàn bộ các layer nằm phía sau nó bắt buộc phải chạy lại từ đầu**, bất kể nội dung của các layer phía sau có thay đổi hay không!

### Chiến lược sắp xếp thứ tự các chỉ thị chuẩn công nghiệp
**Đặt những thành phần ít thay đổi nhất lên đầu, đặt những thành phần thường xuyên thay đổi nhất xuống cuối cùng.**

```dockerfile
# CÁCH SẮP XẾP SAI LẦM:
FROM node:20-alpine
WORKDIR /app
COPY . .                  <-- Copy toàn bộ code (thay đổi liên tục mỗi phút)
RUN npm install           <-- Bị vô hiệu hóa cache liên tục! Lần nào sửa code cũng phải tải lại thư viện

#  CÁCH SẮP XẾP TỐI ƯU KHOA HỌC:
FROM node:20-alpine
WORKDIR /app
# 1. Chỉ copy tệp khai báo thư viện trước
COPY package*.json ./
# 2. Cài đặt thư viện (Chỉ chạy lại khi ta cài thêm gói mới)
RUN npm ci --only=production
# 3. Copy mã nguồn ứng dụng sau cùng
COPY . .
CMD ["node", "src/index.js"]
```

---

## 14.6. Kỹ thuật Multi-stage Build

Trước khi tính năng Multi-stage Build ra đời (Docker 17.05), các kỹ sư phải duy trì hai file Dockerfile riêng biệt: một file chứa đầy đủ công cụ để biên dịch mã nguồn (SDK, Compiler, Test tools) và một file tối giản để chạy sản phẩm, sau đó dùng các bash script phức tạp để chép file nhị phân qua lại.

Multi-stage Build cho phép khai báo **nhiều chỉ thị `FROM`** trong cùng một tệp Dockerfile duy nhất. Mỗi chỉ thị `FROM` mở ra một chặng (*Stage*) mới với một hệ điều hành cơ sở hoàn toàn độc lập.

### Lợi ích vượt trội của Multi-stage Build
1. **Giảm kích thước Image triệt để:** Loại bỏ toàn bộ trình biên dịch (GCC, Go SDK, Maven, devDependencies), giảm kích thước Image từ 1.2GB xuống chỉ còn dưới 80MB.
2. **Thu hẹp bề mặt tấn công (*Attack Surface Reduction*):** Container trên môi trường Production không chứa trình biên dịch, công cụ gỡ lỗi hay shell không cần thiết. Kẻ tấn công nếu có khai thác được ứng dụng cũng không có sẵn các công cụ trong container để tải và biên dịch mã độc tầng sâu.
3. **Tiết kiệm tài nguyên hạ tầng:** Rút ngắn thời gian truyền tải Image trong quy trình CI/CD và giảm dung lượng lưu trữ trên Registry.

---

# PHẦN 6: KIẾN TRÚC VÀ QUẢN LÝ DOCKER

# 16. Mục 16: Kiến trúc Docker Engine

## 16.1. Mô hình Docker Client – Server

Docker Engine không phải là một chương trình nguyên khối mà được xây dựng hoàn toàn theo mô hình máy khách – máy chủ phân tán (Client – Server Architecture). Kiến trúc này tách bạch rõ ràng giữa giao diện tương tác người dùng và bộ máy điều hành xử lý tác vụ ngầm.

```text
┌────────────────────────────────────────────────────────────────────────┐
│                             DOCKER CLIENT                              │
│         Docker CLI (docker run, build, ps) / SDK / Third-party Tools   │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    │ REST API qua:
                                    │  1. UNIX Domain Socket (/var/run/docker.sock)
                                    │  2. TCP Socket (tcp://host:2375 hoặc :2376 TLS)
                                    │  3. SSH Tunnel (ssh://user@host)
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                              DOCKER HOST                               │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │                     Docker Daemon (dockerd)                      │  │
│  │   - Quản trị API Endpoint & Xác thực                             │  │
│  │   - Quản lý Docker Images, Volumes, Networks                     │  │
│  │   - Điều phối tài nguyên hệ thống                                │  │
│  └────────────────────────────────┬─────────────────────────────────┘  │
│                                   │ gRPC                               │
│                                   ▼                                    │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │                     containerd (High-level Runtime)              │  │
│  │   - Quản lý vòng đời Container, tải & giải nén Image             │  │
│  └─────────────────┬───────────────────────────────┬────────────────┘  │
│                    │ Fork                          │ Fork              │
│                    ▼                               ▼                   │
│         ┌─────────────────────┐         ┌─────────────────────┐        │
│         │   containerd-shim   │         │   containerd-shim   │        │
│         └──────────┬──────────┘         └──────────┬──────────┘        │
│                    │ Gọi & Thoát                   │ Gọi & Thoát       │
│                    ▼                               ▼                   │
│         ┌─────────────────────┐         ┌─────────────────────┐        │
│         │  runc (OCI Runtime) │         │  runc (OCI Runtime) │        │
│         └──────────┬──────────┘         └──────────┬──────────┘        │
│                    │ Khởi tạo                      │ Khởi tạo          │
│                    ▼                               ▼                   │
│         ┌─────────────────────┐         ┌─────────────────────┐        │
│         │   Container Process │         │   Container Process │        │
│         │ (Namespaces, cgroups│         │ (Namespaces, cgroups│        │
│         └─────────────────────┘         └─────────────────────┘        │
└────────────────────────────────────────────────────────────────────────┘
```

### Các kênh truyền thông giữa Client và Daemon

Docker Client và Docker Daemon có thể chạy trên cùng một máy chủ hoặc nằm trên hai máy chủ hoàn toàn khác nhau qua mạng. Giao tiếp giữa chúng được thực hiện qua Docker Engine REST API thông qua ba phương thức kết nối chính:

1. **UNIX Domain Socket (`unix:///var/run/docker.sock`):**
   - Đây là kênh giao tiếp mặc định trên các hệ điều hành Linux khi Docker Client và Daemon cùng nằm trên một máy chủ cục bộ.
   - Socket UNIX là cơ chế giao tiếp liên tiến trình (IPC) của nhân hệ điều hành, cho tốc độ truyền tải cao nhất và độ trễ thấp nhất vì dữ liệu không cần đi qua ngăn xếp mạng TCP/IP.
   - Quyền truy cập tệp socket này được quản lý thông qua quyền của tệp tin trên Linux. Mặc định socket thuộc quyền sở hữu của người dùng `root` và nhóm `docker`.

2. **TCP Socket không mã hóa (`tcp://0.0.0.0:2375`):**
   - Mở cổng mạng TCP để Docker Client từ xa có thể kết nối đến Daemon qua địa chỉ IP.
   - Cổng 2375 là cổng tiêu chuẩn dành cho kết nối HTTP không mã hóa.
   - Phương thức này không an toàn và tuyệt đối không được sử dụng trên môi trường sản xuất do lưu lượng truyền tải dưới dạng văn bản thuần và không có cơ chế xác thực danh tính.

3. **TCP Socket bảo mật với TLS (`tcp://0.0.0.0:2376`):**
   - Cổng 2376 là cổng tiêu chuẩn sử dụng giao thức HTTPS kết hợp mã hóa TLS hai chiều (Mutual TLS Authentication).
   - Cả Client và Daemon đều phải xuất trình chứng chỉ số hợp lệ được ký bởi cơ quan chứng thực (CA). Kênh này đảm bảo mã hóa dữ liệu truyền tải trên đường truyền và xác thực nghiêm ngặt danh tính của người quản trị từ xa.

4. **Kênh bảo mật SSH (`ssh://user@remote-host`):**
   - Kể từ Docker phiên bản 18.09, Docker CLI hỗ trợ kết nối trực tiếp đến Daemon từ xa thông qua giao thức SSH có sẵn của hệ điều hành mà không cần mở thêm bất kỳ cổng TCP chuyên dụng nào của Docker.

### Rủi ro bảo mật nghiêm trọng của Docker Socket

Tệp tin `/var/run/docker.sock` là điểm truy cập quyền lực nhất trên hệ thống Docker. Bất kỳ tiến trình hoặc người dùng nào có quyền ghi vào socket này đều có khả năng điều khiển toàn bộ Docker Daemon.

Một rủi ro kinh điển trong bảo mật container là hành vi gắn socket của máy chủ vào bên trong container:

```bash
# Hành vi tiềm ẩn nguy cơ bảo mật nghiêm trọng:
docker run -it -v /var/run/docker.sock:/var/run/docker.sock alpine sh
```

Khi được gắn socket này, tiến trình bên trong container hoàn toàn có thể cài đặt Docker CLI và gửi lệnh yêu cầu Docker Daemon trên máy chủ host khởi tạo một container mới với cờ đặc quyền `--privileged` và gắn toàn bộ thư mục gốc `/` của máy chủ vật lý vào container mới đó. Kẻ tấn công từ bên trong container có thể dễ dàng chiếm quyền điều khiển tài khoản `root` của toàn bộ máy chủ vật lý bên ngoài (Container Escape).

---

## 16.2. Docker CLI và Docker API

### Bản chất kỹ thuật của Docker CLI

Docker CLI là một chương trình dòng lệnh độc lập được viết bằng ngôn ngữ Go. Bản chất của Docker CLI không chứa logic quản trị container, không trực tiếp tương tác với nhân Linux, cũng không quản lý tài nguyên phần cứng. 

Khi người quản trị nhập một lệnh bất kỳ trên terminal, Docker CLI thực hiện:
- Phân tích cú pháp câu lệnh và các cờ tham số đầu vào.
- Chuyển đổi yêu cầu thành một cuộc gọi HTTP REST API tương ứng (chuẩn phương thức GET, POST, DELETE).
- Đóng gói dữ liệu dưới dạng JSON (nếu có payload) và gửi yêu cầu tới Docker Daemon qua socket.
- Tiếp nhận phản hồi JSON hoặc luồng dữ liệu nhị phân từ Daemon, định dạng lại thành bảng biểu hoặc chuỗi ký tự thân thiện với người dùng và in ra màn hình console.

### Tương tác trực tiếp với Docker REST API qua cURL

Để minh chứng Docker CLI chỉ là một HTTP Client, người quản trị hoàn toàn có thể bỏ qua Docker CLI và sử dụng tiện ích dòng lệnh `curl` để điều khiển Docker Daemon trực tiếp qua UNIX domain socket:

```bash
# 1. Kiểm tra thông tin phiên bản Docker Engine API
curl --silent --unix-socket /var/run/docker.sock http://localhost/version | jq .

# 2. Liệt kê danh sách các container đang chạy (tương đương docker ps)
curl --silent --unix-socket /var/run/docker.sock http://localhost/v1.45/containers/json | jq .

# 3. Lấy thông tin thống kê tài nguyên thời gian thực của container
curl --silent --unix-socket /var/run/docker.sock http://localhost/v1.45/containers/web-app/stats?stream=false | jq .
```

Người quản trị cũng có thể tạo và khởi chạy một container mới hoàn toàn bằng cách gửi yêu cầu HTTP POST kèm theo cấu hình JSON:

```bash
# Tạo một container Nginx thông qua HTTP POST API
curl --silent -X POST \
  -H "Content-Type: application/json" \
  --unix-socket /var/run/docker.sock \
  -d '{"Image": "nginx:alpine", "Cmd": ["nginx", "-g", "daemon off;"]}' \
  http://localhost/v1.45/containers/create?name=api-nginx | jq .
```

### Quản lý đa môi trường với Docker Context

Docker cung cấp tính năng Docker Context, cho phép người dùng chuyển đổi linh hoạt điểm kết nối của Docker CLI tới nhiều máy chủ Docker Engine khác nhau (máy cá nhân, máy chủ kiểm thử nội bộ, máy chủ đám mây AWS):

```bash
# Khởi tạo một context mới kết nối tới máy chủ từ xa qua SSH
docker context create remote-server --docker "host=ssh://deployer@192.168.1.50"

# Liệt kê danh sách các context hiện có
docker context ls

# Chuyển đổi ngữ cảnh làm việc hiện tại sang máy chủ từ xa
docker context use remote-server

# Mọi lệnh thực thi tiếp theo sẽ được gửi trực tiếp tới máy chủ 192.168.1.50
docker ps
```

---

## 16.3. Docker Daemon và file cấu hình daemon.json

### Vai trò trung tâm của tiến trình dockerd

Tiến trình `dockerd` là dịch vụ nền thường trực chạy trên máy chủ host dưới quyền quản trị hệ thống cao nhất. Nhiệm vụ của `dockerd` bao gồm:
- Mở và lắng nghe các yêu cầu từ Docker Engine REST API.
- Điều phối và quản lý toàn bộ đối tượng cấp cao của Docker bao gồm Images, Containers, Networks, Volumes và Plugins.
- Cấu hình các quy tắc mạng và tường lửa trên máy chủ host thông qua `iptables`.
- Giao tiếp với runtime bậc cao `containerd` thông qua giao thức gRPC để ủy quyền việc thực thi container.

### Cấu hình chi tiết file /etc/docker/daemon.json

Toàn bộ hành vi vận hành của Docker Daemon được kiểm soát tập trung thông qua tệp tin cấu hình định dạng JSON tại đường dẫn `/etc/docker/daemon.json`. Dưới đây là tệp cấu hình mẫu chuẩn dành cho môi trường sản xuất kèm phân tích chuyên sâu từng thông số kỹ thuật:

```json
{
  "storage-driver": "overlay2",
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "50m",
    "max-file": "3"
  },
  "live-restore": true,
  "default-ulimits": {
    "nofile": {
      "Name": "nofile",
      "Hard": 65536,
      "Soft": 65536
    },
    "nproc": {
      "Name": "nproc",
      "Hard": 4096,
      "Soft": 4096
    }
  },
  "insecure-registries": [
    "registry.internal.company.com:5000"
  ],
  "registry-mirrors": [
    "https://mirror.gcr.io"
  ],
  "metrics-addr": "127.0.0.1:9323",
  "experimental": true
}
```

### Phân tích ý nghĩa các thông số quan trọng

1. **`storage-driver`: "overlay2"**
   - Chỉ định trình điều khiển hệ thống tệp lưu trữ. `overlay2` là chuẩn mực tối ưu nhất trên các nhân Linux hiện đại, mang lại hiệu năng đọc ghi cao và tốc độ phân lớp vượt trội so với các driver cũ như `devicemapper` hay `aufs`.

2. **`log-driver` và `log-opts`:**
   - Mặc định Docker ghi toàn bộ luồng stdout và stderr của container vào các tệp JSON trên ổ cứng máy chủ.
   - Nếu không giới hạn dung lượng, container có lưu lượng ghi log lớn sẽ nhanh chóng làm đầy phân vùng ổ đĩa gốc của máy chủ, dẫn đến sự cố sập toàn bộ hệ điều hành.
   - Cấu hình `"max-size": "50m"` và `"max-file": "3"` áp dụng cơ chế tự động xoay vòng log (Log Rotation): mỗi tệp log tối đa 50MB và chỉ lưu giữ tối đa 3 tệp cũ nhất. Khi vượt quá ngưỡng, dữ liệu cũ nhất sẽ tự động bị xóa đè.

3. **`live-restore`: true**
   - Thông số sống còn trên môi trường sản xuất.
   - Mặc định, khi tiến trình `dockerd` bị tắt hoặc khởi động lại (khi nâng cấp gói phần mềm hệ thống hoặc chỉnh sửa cấu hình), toàn bộ các container đang chạy sẽ bị dừng đột ngột.
   - Khi kích hoạt `"live-restore": true`, các container vẫn tiếp tục hoạt động bình thường và duy trì kết nối mạng ổn định ngay cả trong lúc `dockerd` tạm thời ngừng hoạt động.

4. **`default-ulimits`:**
   - Thiết lập hạn mức tài nguyên cấp tiến trình cho toàn bộ container được khởi tạo.
   - `nofile` (Number of Open Files): Nâng giới hạn số lượng tệp tin và socket mạng mở đồng thời lên 65536, ngăn ngừa triệt để lỗi kinh điển `Too many open files` khi chạy các ứng dụng có lượng truy cập đồng thời lớn như Nginx, Redis, Netty.
   - `nproc` (Number of Processes): Giới hạn số lượng tiến trình con tối đa mà một container có thể sinh ra, ngăn ngừa các cuộc tấn công dạng bom tiến trình (Fork Bomb) làm cạn kiệt bảng quản lý tiến trình của nhân Linux.

5. **`insecure-registries` và `registry-mirrors`:**
   - `insecure-registries`: Cho phép Docker Client kéo và đẩy Image tới các Registry nội bộ chưa có chứng chỉ bảo mật SSL/TLS hợp lệ hoặc sử dụng chứng chỉ tự ký.
   - `registry-mirrors`: Khai báo máy chủ bộ nhớ đệm trung gian để tăng tốc độ tải Image từ Docker Hub và giảm thiểu băng thông ra cổng Internet quốc tế.

6. **`metrics-addr`:**
   - Mở endpoint xuất dữ liệu đo lường hiệu năng của Docker Engine theo định dạng chuẩn Prometheus để tích hợp vào hệ thống giám sát tập trung Grafana.

### Quy trình áp dụng cấu hình

Sau khi chỉnh sửa tệp `daemon.json`, người quản trị cần nạp lại cấu hình dịch vụ và khởi động lại Docker Daemon:

```bash
# Kiểm tra tính hợp lệ của cú pháp JSON trước khi khởi động lại
sudo dockerd --validate --config-file /etc/docker/daemon.json

# Nạp lại cấu hình dịch vụ của systemd
sudo systemctl daemon-reload

# Khởi động lại dịch vụ Docker Engine
sudo systemctl restart docker

# Kiểm tra trạng thái hoạt động của dịch vụ
sudo systemctl status docker
```

---

## 16.4. Vai trò của containerd, containerd-shim và runc

### Quá trình phân tách kiến trúc Docker

Trong các phiên bản đầu tiên, Docker là một ứng dụng nguyên khối duy nhất: `docker` daemon chịu trách nhiệm từ việc nhận lệnh CLI, build image, quản lý volume, thiết lập mạng, đến việc trực tiếp gọi các lệnh hệ thống của Linux để tạo container. Kiến trúc này bộc lộ nhiều yếu điểm:
- Một lỗi nhỏ trong việc quản lý mạng hay xử lý log có thể làm sập toàn bộ daemon, kéo theo việc tất cả container trên máy chủ đều bị dừng hoạt động.
- Không thể tích hợp hoặc tái sử dụng các thành phần của Docker vào các nền tảng điều phối khác như Kubernetes.

Nhằm tiêu chuẩn hóa công nghệ, Docker đã chủ động khởi xướng và chuyển giao công nghệ cho Open Container Initiative (OCI), đồng thời tách kiến trúc Docker Engine thành các tầng thành phần độc lập:

```text
┌────────────────────────────────────────────────────────┐
│                     Docker Daemon                      │  <-- Tầng ứng dụng cấp cao
│  (Quản lý Image, Dockerfile Build, Volume, Network)    │      (Docker Ecosystem)
└───────────────────────────┬────────────────────────────┘
                            │ gRPC
                            ▼
┌────────────────────────────────────────────────────────┐
│                       containerd                       │  <-- Tầng quản lý Container cấp cao
│  (Quản lý vòng đời Container, Image Distribution)      │      (Container Supervisor)
└─────────────┬────────────────────────────┬─────────────┘
              │ Fork                       │ Fork
              ▼                            ▼
   ┌────────────────────┐       ┌────────────────────┐
   │  containerd-shim   │       │  containerd-shim   │      <-- Tầng duy trì tiến trình
   └──────────┬─────────┘       └──────────┬─────────┘          (Process Reaping & I/O)
              │ Thực thi & Thoát           │ Thực thi & Thoát
              ▼                            ▼
   ┌────────────────────┐       ┌────────────────────┐
   │        runc        │       │        runc        │      <-- Tầng thực thi cấp thấp (OCI Runtime)
   └──────────┬─────────┘       └──────────┬─────────┘          (Linux Namespaces & cgroups)
              │ Sinh ra tiến trình         │ Sinh ra tiến trình
              ▼                            ▼
      [Tiến trình Nginx]           [Tiến trình MySQL]
```

### runc - OCI Low-level Runtime

`runc` là một công cụ dòng lệnh nhẹ, độc lập, thực thi theo đặc tả OCI Runtime Specification. Nhiệm vụ duy nhất của `runc` là tương tác trực tiếp với nhân Linux để khai sinh container:
- Đọc tệp cấu hình chuẩn OCI `config.json` và hệ thống tệp gốc (rootfs).
- Thực hiện các lệnh gọi hệ thống (system calls) của nhân Linux như `clone()` và `unshare()` với các cờ đặc thù để tạo các Linux Namespaces mới (PID, NET, MNT, IPC, UTS).
- Tạo và gắn tiến trình vào các nhóm cgroups tương ứng trên hệ thống tệp ảo `/sys/fs/cgroup` để giới hạn CPU và RAM.
- Cấu hình tường lửa bảo mật cấp lời gọi hàm Seccomp và hồ sơ AppArmor.
- Thực thi lệnh gọi hệ thống `pivot_root` để biến thư mục của container thành thư mục gốc `/` mới.
- Khởi động tiến trình chính của ứng dụng và ngay lập tức thoát (`exit 0`).

`runc` không tồn tại thường trực trong bộ nhớ; nó chỉ xuất hiện trong vài phần trăm giây tại thời điểm tạo container rồi tự giải phóng.

### containerd-shim - Tiến trình đệm duy trì trạng thái

Bởi vì `runc` lập tức thoát sau khi khởi tạo tiến trình container, một tiến trình khác phải đứng ra nhận quyền làm tiến trình cha để quản lý ứng dụng. Đó chính là vai trò của `containerd-shim`:

1. **Duy trì các luồng vào ra chuẩn (I/O Handling):**
   - Giữ mở các đường ống nhập xuất chuẩn (stdin, stdout, stderr) của container ngay cả khi `containerd` hoặc `dockerd` bị tạm dừng hoặc khởi động lại.
   - Chuyển tiếp các luồng log này về cho bộ máy ghi log của hệ thống mà không làm gián đoạn luồng dữ liệu của ứng dụng bên trong container.

2. **Hỗ trợ cơ chế Daemonless Containers:**
   - Nhờ có shim làm tiến trình cha trực tiếp của container, `containerd` và `dockerd` có thể được khởi động lại, nâng cấp phiên bản hoặc gặp sự cố sập nguồn phần mềm mà tiến trình bên trong container hoàn toàn không bị ảnh hưởng.

3. **Thu dọn tiến trình mồ côi (Zombie Process Reaping):**
   - Trong Linux, nếu một tiến trình con kết thúc nhưng tiến trình cha không gọi lệnh `wait()` để đọc mã thoát (exit code), tiến trình con sẽ trở thành một tiến trình thây ma (Zombie Process) chiếm dụng bảng quản lý PID của nhân.
   - `containerd-shim` được thiết lập cờ `subreaper` của Linux. Nếu tiến trình chính bên trong container sinh ra các tiến trình cháu rồi đột ngột thoát, các tiến trình cháu đó sẽ được chuyển giao về làm con trực tiếp của shim, giúp shim tự động dọn dẹp sạch sẽ các zombie process này.

### containerd - High-level Container Runtime

`containerd` là một dịch vụ hệ thống mã nguồn mở độc lập (hiện là dự án tốt nghiệp cấp cao nhất của CNCF). `containerd` quản lý toàn bộ vòng đời của container từ đầu đến cuối:
- Tải các Image từ Registry, xác minh chữ ký điện tử và giải nén các lớp dữ liệu thành hệ thống tệp hoàn chỉnh.
- Quản trị việc gắn và tháo các điểm lưu trữ dữ liệu của container.
- Điều phối mạng cấp thấp cho container.
- Quản lý các tiến trình `containerd-shim` và giám sát trạng thái sức khỏe của các container đang hoạt động.
- Cung cấp giao diện gRPC chuẩn hóa cho cả Docker Daemon lẫn Kubernetes CRI (Container Runtime Interface).

Khảo sát cây tiến trình thực tế trên máy chủ Linux bằng lệnh `pstree`:

```bash
systemd───dockerd───containerd─┬─containerd-shim───nginx───2*[nginx]
                               └─containerd-shim───mysqld───28*[{mysqld}]
```

Sơ đồ trên cho thấy rõ ràng: mỗi container đang chạy đều có riêng một tiến trình `containerd-shim` làm cha trực tiếp.

---

## 16.5. Quy trình từ docker run đến khi Container hoạt động

Khi người dùng thực thi một câu lệnh khởi chạy container tiêu chuẩn:

```bash
docker run -d -p 8080:80 --name web-nginx nginx:alpine
```

Dưới đây là chuỗi hành động tuần tự gồm 8 giai đoạn diễn ra bên trong hệ thống:

```text
  CLI               dockerd            containerd        containerd-shim        runc             Kernel
   │                   │                   │                    │                │                 │
1. │── POST /create ──>│                   │                    │                │                 │
   │                   │── 2. Pull Image ──│                    │                │                 │
   │                   │── 3. OverlayFS ───│                    │                │                 │
   │                   │── 4. IP & NAT ────│                    │                │                 │
   │                   │── 5. CreateTask ─>│                    │                │                 │
   │                   │                   │── 6. Fork shim ───>│                │                 │
   │                   │                   │                    │── 7. runc run >│                 │
   │                   │                   │                    │                │── Namespaces ──>│
   │                   │                   │                    │                │── cgroups ─────>│
   │                   │                   │                    │                │── pivot_root ──>│
   │                   │                   │                    │<── Exit 0 ─────│ (Tự hủy)        │
   │                   │                   │<── Task Started ───│ (Làm cha Nginx)                  │
8. │<── Container ID ──│                   │                    │                                  │
```

1. **Phân tích lệnh và gửi yêu cầu API:**
   - Docker CLI dịch lệnh người dùng thành yêu cầu HTTP POST gửi tới endpoint `/v1.45/containers/create` của Docker Daemon qua socket `/var/run/docker.sock`.

2. **Kiểm tra và chuẩn bị Docker Image:**
   - Docker Daemon kiểm tra xem Image `nginx:alpine` đã có sẵn trong bộ nhớ cục bộ hay chưa.
   - Nếu chưa có, Daemon tự động kết nối tới Docker Hub để tải từng layer của Image về máy chủ, xác minh mã băm bảo mật SHA-256 và lưu trữ vào thư mục dữ liệu của Docker.

3. **Khởi tạo hệ thống tệp lưu trữ (Storage Layer):**
   - Docker Daemon yêu cầu Storage Driver (OverlayFS) thiết lập hệ thống tệp cho container:
   - Các layer của Image được xếp ở chế độ chỉ đọc (LowerDir).
   - Một layer mới hoàn toàn rỗng ở chế độ đọc/ghi (UpperDir) được tạo riêng cho container này.
   - Hợp nhất hai tầng này lại thành một không gian thư mục thống nhất (MergedDir).

4. **Cấu hình mạng và phân bổ tài nguyên:**
   - Docker Daemon phân bổ một địa chỉ IP nội bộ duy nhất từ dải mạng của cầu nối `docker0` (ví dụ `172.17.0.2`).
   - Tạo một cặp card mạng ảo `veth`, một đầu cắm vào bridge `docker0`, đầu kia chuẩn bị đưa vào container.
   - Thêm quy tắc chuyển tiếp cổng vào bảng `iptables` của máy chủ để ánh xạ lưu lượng từ cổng `8080` của host tới cổng `80` của địa chỉ IP `172.17.0.2`.

5. **Chuyển giao yêu cầu qua gRPC sang containerd:**
   - Docker Daemon tạo tệp đặc tả cấu hình OCI bundle (chứa tệp cấu hình chi tiết `config.json` bao gồm các biến môi trường, đường dẫn mount, hạn mức tài nguyên) và gọi dịch vụ `TaskService.Create` của `containerd` thông qua giao thức gRPC.

6. **Khởi tạo containerd-shim:**
   - `containerd` tiếp nhận cấu hình, tạo một tiến trình con `containerd-shim` mới dành riêng cho container này.
   - Tiến trình shim chuẩn bị sẵn các đường ống kết nối vào ra tiêu chuẩn cho container.

7. **Kích hoạt runc để tạo môi trường cô lập:**
   - `containerd-shim` thực thi tiện ích `runc` với tham số trỏ tới thư mục OCI bundle.
   - `runc` tương tác trực tiếp với nhân Linux:
     - Gọi `clone()` với các cờ `CLONE_NEWPID`, `CLONE_NEWNET`, `CLONE_NEWNS`, `CLONE_NEWIPC`, `CLONE_NEWUTS` để sinh ra các Namespaces cô lập hoàn toàn.
     - Tạo các nhóm con trong `/sys/fs/cgroup` và ghi định danh tiến trình vào đó để áp đặt giới hạn phần cứng.
     - Thiết lập card mạng ảo `veth` làm card mạng `eth0` bên trong Network Namespace của container.
     - Thực thi `pivot_root` để cô lập hệ thống tệp vào thư mục MergedDir.
     - Khởi động tiến trình chính của Nginx (`nginx -g 'daemon off;'`).
   - Sau khi tiến trình Nginx bắt đầu chạy, `runc` bàn giao quyền điều khiển tiến trình cho `containerd-shim` rồi lập tức tự kết thúc.

8. **Xác nhận trạng thái và hoàn tất:**
   - `containerd-shim` thông báo lại cho `containerd` rằng tiến trình đã hoạt động ổn định.
   - `containerd` phát sự kiện cho `dockerd`.
   - `dockerd` cập nhật trạng thái container là `running` vào cơ sở dữ liệu nội bộ và gửi phản hồi chứa chuỗi định danh Container ID dài 64 ký tự về cho Docker CLI để in ra màn hình người dùng.

---

## 16.6. Mối quan hệ giữa Docker Engine và Container Runtime

### 1. Phân biệt bản chất giữa Docker Engine và Container Runtime

Nhiều người thường nhầm lẫn Docker Engine chính là Container Runtime, hoặc coi hai khái niệm này là một. Trên thực tế, chúng thuộc hai cấp độ kiến trúc hoàn toàn khác nhau:

- **Docker Engine (Nền tảng container hoàn chỉnh):**
  Docker Engine là một bộ công cụ cấp cao toàn diện phục vụ toàn bộ chu trình phát triển và vận hành ứng dụng (Build - Ship - Run). Docker Engine chịu trách nhiệm cung cấp giao diện dòng lệnh (Docker CLI), máy chủ API (Docker API), hệ thống quản lý mạng ảo (Docker Network), cơ chế lưu trữ phân vùng (Docker Volume), bộ máy xây dựng hình ảnh tối ưu (BuildKit), và quản lý xác thực kho chứa hình ảnh (Registry Authentication). Docker Engine tự nó **không trực tiếp thao tác với nhân hệ điều hành Linux để tạo ra tiến trình container**.

- **Container Runtime (Bộ máy thực thi container):**
  Là thành phần phần mềm chuyên trách duy nhất nhiệm vụ tiếp nhận cấu hình, nạp tài nguyên và điều khiển trực tiếp hệ điều hành để khởi chạy, theo dõi và tiêu hủy container. Docker Engine sử dụng Container Runtime như một bộ máy thực thi bên dưới (Execution Engine).

### 2. Hai cấp độ của Container Runtime: High-level và Low-level

Kiến trúc container hiện đại phân tách Container Runtime thành hai phân tầng rõ rệt:

```text
┌────────────────────────────────────────────────────────────────────────┐
│                             DOCKER ENGINE                              │
│         (Docker CLI, REST API, BuildKit, Network, Volume, Auth)        │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │ gRPC
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                   HIGH-LEVEL CONTAINER RUNTIME                         │
│                           (containerd)                                 │
│  - Quản lý vòng đời Container (Create, Start, Stop, Delete)            │
│  - Kéo, xác thực và giải nén Image từ Registry                         │
│  - Quản lý bộ nhớ đệm và tầng lưu trữ (Storage Snapshot)               │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │ containerd-shim
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                    LOW-LEVEL CONTAINER RUNTIME                         │
│              (Tuân thủ OCI Runtime Specification)                      │
│                                                                        │
│    ┌──────────────┐      ┌──────────────┐      ┌────────────────┐      │
│    │     runc     │      │     crun     │      │ Kata Containers│      │
│    │  (Chuẩn Go)  │      │  (C siêu nhẹ)│      │ (MicroVM cô lập│      │
│    └──────┬───────┘      └──────┬───────┘      └────────┬───────┘      │
└───────────┼─────────────────────┼───────────────────────┼──────────────┘
            ▼                     ▼                       ▼
┌────────────────────────────────────────────────────────────────────────┐
│                           NHÂN HỆ ĐIỀU HÀNH                            │
│           Linux Namespaces, Control Groups (cgroups), Seccomp          │
└────────────────────────────────────────────────────────────────────────┘
```

#### High-level Container Runtime (Runtime bậc cao)
- Đại diện tiêu biểu trong hệ sinh thái Docker là **`containerd`**.
- Nhiệm vụ:
  - Tiếp nhận lệnh từ Docker Daemon qua giao thức gRPC.
  - Quản lý việc truyền tải hình ảnh: kết nối đến Image Registry, kéo các lớp dữ liệu về máy, kiểm tra mã băm SHA-256 và giải nén thành hệ thống tệp rootfs hoàn chỉnh.
  - Quản lý các điểm gắn kết lưu trữ (Storage Snapshots và Mount points).
  - Quản lý siêu dữ liệu (Metadata) và trạng thái vòng đời của toàn bộ các container trên máy chủ.
  - Chuyển giao gói cấu hình OCI bundle (thư mục rootfs kèm tệp `config.json`) xuống cho runtime bậc thấp thực thi.

#### Low-level Container Runtime (Runtime bậc thấp)
- Đại diện mặc định là **`runc`**, cùng với các runtime thay thế khác như **`crun`**, **`youki`**, **`Kata Containers`**, **`gVisor`**.
- Nhiệm vụ:
  - Chỉ tập trung vào một nhiệm vụ duy nhất: đọc cấu hình OCI `config.json`, thực hiện các lời gọi hệ thống của nhân Linux (`clone`, `unshare`, `setns`, `pivot_root`).
  - Thiết lập các không gian tên cô lập (Linux Namespaces) và áp đặt hạn mức tài nguyên bằng Control Groups (cgroups).
  - Khởi động tiến trình ứng dụng bên trong môi trường đã cô lập, sau đó lập tức thoát để bàn giao quyền giám sát lại cho hệ thống qua `containerd-shim`.

### 3. Chuẩn OCI và khả năng hoán đổi Runtime linh hoạt

Nhờ việc chuẩn hóa theo tiêu chuẩn **OCI Runtime Specification**, Docker Engine không bị ràng buộc cứng vào bất kỳ một runtime cụ thể nào. Docker có thể dễ dàng chuyển đổi hoặc tích hợp đồng thời nhiều runtime khác nhau tùy theo nhu cầu chuyên biệt:

| Tên Runtime | Ngôn ngữ | Đặc điểm kỹ thuật | Trường hợp sử dụng tối ưu |
| :--- | :--- | :--- | :--- |
| **runc** | Go | Runtime tiêu chuẩn mặc định của OCI và Docker. Ổn định, tương thích tuyệt đối. | Môi trường thông dụng, ứng dụng tiêu chuẩn hàng ngày. |
| **crun** | C | Được viết hoàn toàn bằng C, dung lượng nhị phân siêu nhỏ (~500KB so với ~15MB của runc), tốc độ khởi động nhanh hơn gấp 2-3 lần và tiêu thụ ít bộ nhớ RAM hơn. | Hệ thống yêu cầu khởi động hàng trăm container trong vài phần trăm giây, ứng dụng nhạy cảm về độ trễ. |
| **Kata Containers** | Go / Rust | Khởi tạo mỗi container bên trong một máy ảo siêu nhẹ (MicroVM) sử dụng QEMU hoặc Cloud Hypervisor. Cách ly hoàn toàn bằng nhân OS riêng. | Môi trường chạy đa người dùng (Multi-tenant) không tin cậy, yêu cầu bảo mật cấp phần cứng cao nhất. |
| **gVisor (runsc)** | Go | Bộ nhân ảo do Google phát triển (Application Kernel) can thiệp và bọc lấy các lời gọi hệ thống của container, ngăn container gọi trực tiếp xuống nhân Linux của host. | Chạy mã nguồn tùy biến từ người dùng bên ngoài mà không sợ tấn công vượt quyền nhân hệ điều hành. |
| **nvidia-container-runtime** | Go / C | Runtime mở rộng của NVIDIA, tự động cấu hình driver GPU và nạp các thư viện CUDA vào trong container. | Huấn luyện mô hình học máy (Machine Learning), trí tuệ nhân tạo (AI) và tính toán khoa học trên GPU. |

### 4. Cấu hình và chỉ định Runtime trong Docker Engine

Người quản trị có thể khai báo các runtime tùy chỉnh trực tiếp bên trong tệp tin `/etc/docker/daemon.json` của Docker Host.

Ví dụ: Cấu hình bổ sung runtime siêu nhẹ `crun` và runtime tăng cường bảo mật `kata-containers`:

```json
{
  "default-runtime": "runc",
  "runtimes": {
    "crun": {
      "path": "/usr/bin/crun"
    },
    "kata": {
      "path": "/usr/bin/kata-runtime"
    }
  }
}
```

Sau khi nạp lại cấu hình bằng lệnh `sudo systemctl restart docker`, người dùng có thể linh hoạt lựa chọn runtime mong muốn khi khởi chạy từng container thông qua cờ `--runtime`:

```bash
# Khởi chạy container sử dụng crun để đạt tốc độ tối đa
docker run -d --runtime=crun --name high-speed-app alpine sh

# Khởi chạy container với Kata Containers để cách ly an toàn tuyệt đối
docker run -d --runtime=kata --name secure-sandbox untrusted-code:latest

# Kiểm tra runtime đang phục vụ container
docker inspect high-speed-app --format '{{.HostConfig.Runtime}}'
# Kết quả: crun
```

---

# 17. Mục 17: Docker Networking

## 17.1. Tổng quan về mạng trong Docker (veth, docker0, iptables)

Mạng trong Docker được xây dựng hoàn toàn dựa trên các công nghệ ảo hóa mạng có sẵn trong nhân hệ điều hành Linux. Khi Docker Daemon khởi động, nó tự động cấu hình ba thành phần cốt lõi:

```text
┌────────────────────────────────────────────────────────────────────────┐
│                              DOCKER HOST                               │
│                                                                        │
│   Card mạng vật lý eth0: 192.168.1.100                                 │
│   Bảng iptables NAT: PREROUTING (DNAT) & POSTROUTING (MASQUERADE)      │
│                                                                        │
│   Cầu nối mạng ảo docker0 (Linux Bridge): 172.17.0.1/16                │
│             ▲                                    ▲                     │
│             │                                    │                     │
│      veth4a1b2c (Host end)                veth8f9e0d (Host end)        │
│             ▲                                    ▲                     │
│═════════════╪════════════════════════════════════╪═════════════════════│
│             │ (Cáp mạng ảo veth pair)            │                     │
│             ▼                                    ▼                     │
│   Container 1 (Network Namespace)      Container 2 (Network Namespace) │
│   eth0: 172.17.0.2                     eth0: 172.17.0.3                │
│   Default Gateway: 172.17.0.1          Default Gateway: 172.17.0.1     │
└────────────────────────────────────────────────────────────────────────┘
```

### 1. Network Namespace - Không gian mạng cô lập

Mỗi container khi khởi chạy được gán một Network Namespace riêng biệt. Bên trong không gian này, container sở hữu:
- Một bảng định tuyến (Routing Table) hoàn toàn độc lập.
- Một danh sách giao diện mạng (Network Interfaces) riêng.
- Bảng lọc gói và quy tắc tường lửa (Firewall Rules) độc lập.
- Một không gian các cổng mạng (Port Space) từ 1 đến 65535 độc lập. Ứng dụng trong hai container khác nhau đều có thể mở cổng 80 mà không hề xung đột với nhau.

### 2. Cặp giao diện mạng ảo Virtual Ethernet (veth pair)

Vì Network Namespace của container bị cô lập hoàn toàn với bên ngoài, nhân Linux sử dụng công nghệ `veth pair` để thiết lập kênh kết nối vật lý ảo:
- `veth pair` hoạt động chính xác như một sợi dây cáp mạng ảo có hai đầu cắm.
- Một đầu được đưa vào bên trong Network Namespace của container và đổi tên thành giao diện mạng `eth0`.
- Đầu còn lại được giữ ở Network Namespace của máy chủ host, mang tên định danh ngẫu nhiên do Docker sinh ra (ví dụ `veth4a1b2c`), và được cắm trực tiếp vào cầu nối mạng ảo của host.
- Mọi gói tin truyền vào đầu này của sợi dây sẽ lập tức xuất hiện ở đầu kia mà không bị suy hao dữ liệu.

### 3. Cầu nối mạng Linux Bridge (docker0)

Giao diện mạng `docker0` là một cầu nối phần mềm (Linux Bridge) hoạt động như một thiết bị chuyển mạch ảo lớp 2 (Virtual Layer 2 Switch) ngay bên trong máy chủ host:
- Cầu nối này được gán một địa chỉ IP riêng (mặc định thường là `172.17.0.1/16`), đóng vai trò là Cổng mặc định (Default Gateway) cho toàn bộ các container kết nối vào nó.
- Khi các container gửi gói tin cho nhau trong cùng dải mạng con `172.17.0.0/16`, switch ảo `docker0` sẽ chuyển tiếp khung dữ liệu Ethernet trực tiếp dựa trên địa chỉ MAC của từng container mà không cần chuyển tiếp qua card mạng vật lý của host.

### 4. Cơ chế chuyển dịch địa chỉ mạng (iptables NAT)

Để container có thể truy cập mạng Internet bên ngoài và ngược lại cho phép người dùng bên ngoài truy cập vào dịch vụ bên trong container, Docker cấu hình hai quy tắc cốt lõi trên bảng NAT của `iptables`:

- **SNAT / MASQUERADE (Ra ngoài Internet):**
  Khi container có IP nội bộ `172.17.0.2` gửi gói tin ra Internet (ví dụ tải dữ liệu từ Google), gói tin đi qua máy chủ host sẽ được iptables thay thế địa chỉ IP nguồn thành địa chỉ IP thật của card mạng vật lý `eth0` trên host (ví dụ `192.168.1.100`). Khi nhận phản hồi từ Internet, host tự động chuyển tiếp ngược lại vào đúng container ban đầu.

- **DNAT (Ánh xạ cổng từ ngoài vào):**
  Khi người dùng từ chối truy cập gửi yêu cầu tới cổng `8080` trên máy host, chuỗi quy tắc `PREROUTING` của iptables sẽ can thiệp và thay đổi địa chỉ IP đích của gói tin từ IP của host thành `172.17.0.2:80`, cho phép gói tin đi xuyên qua `docker0` vào đúng cổng dịch vụ của container.

---

## 17.2. Các loại mạng trong Docker (Bridge, Host, None, Overlay, Macvlan)

Docker cung cấp hệ thống mạng có khả năng mở rộng thông qua các trình điều khiển mạng (Network Drivers) phục vụ các kịch bản triển khai đa dạng:

### 1. Bridge Network

Bridge là driver mạng mặc định và phổ biến nhất trên môi trường đơn máy chủ. Docker phân chia mạng Bridge thành hai loại có tính chất khác biệt rõ rệt:

- **Default Bridge (Mạng cầu nối mặc định mang tên `bridge`):**
  - Mọi container khi khởi tạo bằng lệnh `docker run` mà không chỉ định cờ `--network` sẽ tự động được gán vào mạng này.
  - **Nhược điểm lớn:** Không hỗ trợ cơ chế tự động phân giải tên miền (Automatic DNS Resolution). Hai container trong mạng này muốn nói chuyện với nhau bắt buộc phải biết chính xác địa chỉ IP của nhau hoặc phải sử dụng cờ tham số cũ và lỗi thời `--link`.
  - Mọi container đều nằm chung một không gian mạng rộng lớn, tiềm ẩn rủi ro lộ lọt thông tin nếu một container bị tấn công.

- **User-defined Bridge (Mạng cầu nối do người dùng tự tạo):**
  - Được tạo chủ động thông qua lệnh `docker network create --driver bridge <network_name>`.
  - **Ưu điểm vượt trội:** Tự động kích hoạt máy chủ DNS nhúng nội bộ của Docker. Các container kết nối vào cùng mạng có thể gọi nhau trực tiếp thông qua tên định danh của container (ví dụ `backend-api` kết nối tới `database-server`) thay vì phụ thuộc vào địa chỉ IP động.
  - Hỗ trợ cô lập ứng dụng tốt hơn: Có thể phân chia hệ thống thành các mạng riêng biệt (ví dụ `frontend-net`, `backend-net`, `payment-net`).
  - Cho phép gắn và tháo mạng nóng (Hot attach/detach) đối với các container đang chạy mà không cần khởi động lại.

### 2. Host Network (`--network host`)

Khi khởi chạy với tùy chọn `--network host`, Docker hoàn toàn không tạo Network Namespace riêng cho container:
- Container dùng chung trực tiếp ngăn xếp mạng, địa chỉ IP và bảng định tuyến của máy chủ host.
- Giao diện mạng bên trong container chính là `eth0`, `lo` của máy chủ vật lý.
- **Ưu điểm:** Cho hiệu năng mạng cao nhất có thể (tương đương với ứng dụng chạy trực tiếp trên bare-metal) do loại bỏ hoàn toàn chi phí đóng gói gói tin của Linux bridge và cơ chế NAT của iptables.
- **Hạn chế:** Tiềm ẩn rủi ro xung đột cổng: Nếu container lắng nghe cổng 80, không dịch vụ nào khác trên host được phép mở cổng 80 nữa. Mức độ cô lập bảo mật bị suy giảm đáng kể.

### 3. None Network (`--network none`)

Tùy chọn cô lập triệt để:
- Container chỉ sở hữu duy nhất một giao diện mạng vòng lặp cục bộ `lo` (127.0.0.1).
- Hoàn toàn không có card mạng bên ngoài, không có địa chỉ IP và không có cổng mặc định để kết nối ra ngoài.
- **Ứng dụng:** Dành riêng cho các tác vụ đòi hỏi mức độ bảo mật thông tin tuyệt đối: xử lý các lô tính toán mã hóa, ký số dữ liệu tài chính, phân tích mã độc trong môi trường hộp cát (sandbox) hoặc chạy các batch job ngoại tuyến.

### 4. Overlay Network (`--network overlay`)

Giải pháp mạng cho cụm phân tán nhiều máy chủ (Multi-host Networking):
- Thường được sử dụng trong Docker Swarm hoặc các hệ thống điều phối cụm.
- Sử dụng giao thức đóng gói VXLAN (Virtual Extensible LAN) qua cổng UDP 4789 để tạo một mạng ảo lớp 2 phủ lên trên hạ tầng định tuyến lớp 3 hiện hữu của trung tâm dữ liệu.
- Các container nằm ở các máy chủ vật lý khác nhau trong cụm có thể giao tiếp trực tiếp với nhau thông qua địa chỉ IP riêng của mạng Overlay mà không cần thực hiện port mapping phức tạp trên từng máy host.
- Hỗ trợ mã hóa toàn bộ dữ liệu trên đường truyền giữa các node thông qua giao thức bảo mật IPSec tích hợp sẵn.

### 5. Macvlan Network (`--network macvlan`)

Tùy chọn mạng tích hợp trực tiếp hạ tầng vật lý:
- Gán một địa chỉ MAC vật lý thực sự cho giao diện mạng ảo của mỗi container.
- Biến mỗi container thành một thiết bị phần cứng độc lập cắm trực tiếp vào switch mạng vật lý của doanh nghiệp.
- Container có thể nhận địa chỉ IP tĩnh hoặc nhận IP động trực tiếp từ máy chủ DHCP chung của mạng nội bộ công ty.
- **Ứng dụng:** Thích hợp khi di chuyển các hệ thống ứng dụng cũ (legacy applications) từ máy vật lý hoặc máy ảo sang container mà ứng dụng đó yêu cầu phải giữ nguyên cấu hình dải IP nội bộ của công ty, hoặc các công cụ phân tích giám sát mạng cần bắt trực tiếp lưu lượng mạng vật lý.

### Bảng so sánh tổng hợp các loại mạng trong Docker

| Loại mạng (Driver) | Phạm vi hoạt động | Mức độ cô lập | Hiệu năng mạng | Hỗ trợ DNS nội bộ | Trường hợp sử dụng tối ưu |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Default Bridge** | Đơn máy chủ | Trung bình | Khá tốt (có NAT) | Không (chỉ dùng IP) | Chạy thử nghiệm các container đơn lẻ cơ bản. |
| **User-defined Bridge** | Đơn máy chủ | Cao | Tốt (có NAT) | Có (phân giải theo tên) | **Tiêu chuẩn bắt buộc** cho ứng dụng microservice trên một host. |
| **Host** | Đơn máy chủ | Thấp | Tối đa (bằng host) | Không | Ứng dụng yêu cầu độ trễ cực thấp hoặc thông lượng siêu lớn. |
| **None** | Đơn máy chủ | Tuyệt đối | Không áp dụng | Không | Xử lý dữ liệu nhạy cảm, mã hóa offline, batch processing. |
| **Overlay** | Cụm đa máy chủ | Cao | Khá tốt (tốn chi phí VXLAN) | Có | Cụm máy chủ Docker Swarm, hệ thống microservices phân tán. |
| **Macvlan** | Mạng vật lý LAN | Cao | Rất cao (bỏ qua NAT) | Theo mạng LAN ngoài | Ứng dụng legacy đòi hỏi IP thật cùng dải mạng của doanh nghiệp. |

---

## 17.3. Ánh xạ cổng với Port Mapping -p

### Cơ chế hoạt động của Port Mapping

Do các container trong mạng Bridge chỉ sở hữu địa chỉ IP nội bộ (thuộc các dải mạng không định tuyến ra Internet như `172.17.0.0/16`), các thiết bị từ bên ngoài máy chủ không thể truy cập trực tiếp vào các container này. Để mở dịch vụ ra bên ngoài, Docker sử dụng cơ chế Ánh xạ cổng (Port Mapping hoặc Port Forwarding).

Khi người quản trị khai báo tham số `-p 8080:80`:
- Docker Daemon thêm một quy tắc DNAT vào chuỗi `DOCKER` trong bảng `nat` của `iptables`.
- Đồng thời Docker Daemon khởi động một tiến trình phụ trợ siêu nhẹ mang tên `docker-proxy` trên máy chủ host để lắng nghe trên cổng 8080 (phục vụ xử lý các kết nối cục bộ loopback).
- Khi gói tin từ bên ngoài gửi tới cổng 8080 của máy chủ host, hạt nhân Linux tự động chuyển hướng gói tin vào cổng 80 của container.

```bash
# Kiểm tra chuỗi quy tắc iptables NAT do Docker tự động tạo ra
sudo iptables -t nat -L DOCKER -n -v --line-numbers
```

Kết quả xuất ra có dạng:
```text
Chain DOCKER (2 references)
num  pkts bytes target     prot opt in     out     source      destination
1       0     0 DNAT       tcp  --  !docker0 *     0.0.0.0/0   0.0.0.0/0   tcp dpt:8080 to:172.17.0.2:80
```

### Các biến thể cú pháp thường dùng của tham số -p

```bash
# 1. Cú pháp cơ bản: Ánh xạ cổng host vào cổng container (lắng nghe trên mọi IP của host 0.0.0.0)
docker run -d -p 8080:80 --name web-1 nginx:alpine

# 2. Cú pháp bảo mật: Chỉ cho phép truy cập cục bộ từ chính máy host (Localhost Binding)
# Rất hữu ích khi chạy Database hoặc Backend đứng sau một Reverse Proxy như Nginx
docker run -d -p 127.0.0.1:3306:3306 --name db-mysql mysql:8.0

# 3. Cú pháp ánh xạ cổng ngẫu nhiên: Docker tự động chọn một cổng khả dụng trên host (từ 32768 đến 60999)
docker run -d -p 80 --name web-random nginx:alpine

# 4. Ánh xạ toàn bộ các cổng được khai báo trong Dockerfile (cờ -P viết hoa)
docker run -d -P --name web-auto nginx:alpine

# 5. Ánh xạ giao thức UDP thay vì TCP mặc định
docker run -d -p 53:53/udp --name dns-server coredns
```

Sau khi chạy, lệnh `docker port <container_name>` cho phép kiểm tra nhanh chóng bảng ánh xạ cổng của container:

```bash
docker port web-1
# Kết quả:
# 80/tcp -> 0.0.0.0:8080
# 80/tcp -> :::8080
```

---

## 17.4. Phân giải tên miền DNS và giao tiếp giữa các Container

### Máy chủ DNS nhúng nội bộ của Docker (Embedded DNS Server)

Trong môi trường container hóa, các container thường xuyên được tạo mới, khởi động lại hoặc nâng cấp, dẫn đến việc địa chỉ IP của chúng thay đổi liên tục. Nếu các dịch vụ liên kết với nhau bằng địa chỉ IP tĩnh thì hệ thống sẽ rất dễ bị gián đoạn.

Để giải quyết triệt để vấn đề này, Docker tích hợp sẵn một máy chủ DNS nội bộ tại địa chỉ IP loopback đặc biệt `127.0.0.11`:

```text
Container: frontend-service
┌────────────────────────────────────────────────────────┐
│  /etc/resolv.conf                                      │
│  nameserver 127.0.0.11                                 │
└───────────────────────────┬────────────────────────────┘
                            │ Truy vấn DNS: "backend-api"
                            ▼
┌────────────────────────────────────────────────────────┐
│         Docker Embedded DNS Server (127.0.0.11)        │
│                                                        │
│  1. Kiểm tra bảng dịch vụ cùng Network:                │
│     "backend-api" ───────► Trả về IP: 10.10.0.5        │
│                                                        │
│  2. Nếu là tên miền Internet (google.com):             │
│     Chuyển tiếp ra Upstream DNS của Host OS (8.8.8.8)  │
└────────────────────────────────────────────────────────┘
```

- Khi một container được khởi chạy trong một mạng User-defined Bridge, Docker tự động chỉnh sửa tệp `/etc/resolv.conf` bên trong container để trỏ dòng `nameserver` về địa chỉ `127.0.0.11`.
- Khi ứng dụng gửi yêu cầu phân giải tên miền:
  - Nếu tên miền là tên của một container hoặc một alias trong cùng mạng, Docker DNS lập tức trả về IP nội bộ của container đó.
  - Nếu tên miền nằm ngoài phạm vi nội bộ (ví dụ `api.stripe.com` hay `github.com`), Docker DNS sẽ tự động chuyển tiếp truy vấn lên máy chủ DNS ngoài của máy host.

### Sử dụng Network Alias để cân bằng tải nội bộ

Docker cho phép một hoặc nhiều container cùng đăng ký một tên bí danh mạng chung (Network Alias). Khi có truy vấn DNS đến tên alias này, Docker DNS sẽ trả về danh sách các địa chỉ IP của các container theo cơ chế luân phiên Round-Robin, tạo thành một hệ thống cân bằng tải nội bộ cấp mạng đơn giản nhưng hiệu quả:

```bash
# Khởi chạy 2 container backend cùng chia sẻ bí danh api-endpoint
docker run -d --network app-net --network-alias api-endpoint --name api-1 my-api:v1
docker run -d --network app-net --network-alias api-endpoint --name api-2 my-api:v1

# Khi một container khác trong app-net gọi tới "api-endpoint", 
# Docker DNS sẽ luân phiên điều hướng lưu lượng giữa api-1 và api-2
```

---

# 18. Mục 18: Docker Storage và Volume

## 18.1. Cơ chế lưu trữ dữ liệu bên trong Container và Ephemeral Storage

### Bản chất của Ephemeral Storage (Lưu trữ tạm thời)

Theo nguyên lý thiết kế của kiến trúc Container, một container được sinh ra để hoạt động theo trạng thái vô trạng thái (Stateless) và có tính chất tạm thời (Ephemeral):
- Khi một container được khởi chạy từ Docker Image, Docker Storage Driver (phổ biến nhất là `overlay2`) xếp chồng một lớp mỏng hỗ trợ đọc/ghi (Writable Container Layer) lên trên các lớp chỉ đọc (Read-only Image Layers).
- Mọi thao tác tạo mới tệp, chỉnh sửa cấu hình hay xóa dữ liệu phát sinh trong suốt vòng đời của container đều chỉ tồn tại độc quyền trên lớp Writable Layer này.
- Khi container dừng lại (`docker stop`), dữ liệu trên Writable Layer vẫn tạm thời còn đó.
- Tuy nhiên, ngay thời điểm người quản trị thực thi lệnh xóa container (`docker rm -f <container_id>`), toàn bộ lớp Writable Layer này sẽ bị hủy bỏ vĩnh viễn khỏi ổ cứng máy chủ. Toàn bộ dữ liệu phát sinh trong container biến mất không thể khôi phục.

```text
┌────────────────────────────────────────────────────────┐
│  Writable Container Layer (UpperDir)                   │  <-- DỮ LIỆU TẠM THỜI (EPHEMERAL)
│  (Mọi thay đổi dữ liệu bị xóa sạch khi docker rm)      │      Tốc độ I/O bị suy giảm bởi CoW
├────────────────────────────────────────────────────────┤
│  Image Layers (LowerDir - Read Only)                   │
│  (Các lớp tệp tĩnh bất biến của Docker Image)          │
└────────────────────────────────────────────────────────┘
```

### Vấn đề hiệu năng đọc ghi I/O của Storage Driver

Ngoài nguy cơ mất dữ liệu, việc ghi dữ liệu trực tiếp vào hệ thống tệp của container còn gặp phải nhược điểm nghiêm trọng về hiệu năng:
- Mỗi khi container cần sửa đổi một tệp có sẵn từ Image, cơ chế Copy-on-Write (CoW) buộc nhân hệ điều hành phải dò tìm tệp qua từng layer bên dưới, sao chép toàn bộ tệp đó lên tầng Writable Layer rồi mới bắt đầu ghi.
- Cơ chế này tạo ra độ trễ cao, gây suy giảm nghiêm trọng tốc độ đọc ghi ngẫu nhiên (Random I/O) và làm tăng tải cho CPU máy chủ.
- Do đó, việc lưu trữ cơ sở dữ liệu lớn (MySQL, PostgreSQL, MongoDB, Elasticsearch) trực tiếp trong Writable Layer là điều tuyệt đối cấm kỵ trong môi trường sản xuất.

---

## 18.2. Phân biệt Docker Volume, Bind Mount và tmpfs Mount

Để giải quyết bài toán bảo toàn dữ liệu bền vững (Data Persistence) và tối ưu hóa tốc độ I/O, Docker cung cấp ba cơ chế gắn kết lưu trữ riêng biệt:

```text
┌────────────────────────────────────────────────────────────────────────┐
│                              DOCKER HOST                               │
│                                                                        │
│   1. DOCKER VOLUME (Khuyến nghị cho Production)                        │
│      Nằm tại: /var/lib/docker/volumes/<volume_name>/_data              │
│      Do Docker toàn quyền quản lý, độc lập với OS host                 │
│                                                                        │
│   2. BIND MOUNT (Thích hợp cho Lập trình / Cấu hình)                   │
│      Nằm tại: Bất kỳ thư mục nào trên Host (/home/user/app, /etc/conf) │
│      Phụ thuộc vào cấu trúc tệp và quyền hạn của Host OS               │
│                                                                        │
│   3. TMPFS MOUNT (Bảo mật tối đa / Tốc độ cực nhanh)                   │
│      Nằm tại: Bộ nhớ RAM của máy chủ Host                              │
│      Không bao giờ ghi xuống đĩa cứng, mất khi container tắt           │
└────────────────────────────────────────────────────────────────────────┘
```

### 1. Docker Volume

- **Vị trí lưu trữ:** Nằm tập trung trong thư mục hệ thống do Docker quản trị tại `/var/lib/docker/volumes/<volume_name>/_data` trên máy chủ Linux.
- **Quyền quản lý:** Hoàn toàn do Docker Daemon kiểm soát thông qua các lệnh `docker volume`. Các tiến trình ngoài của hệ điều hành host không nên can thiệp trực tiếp vào thư mục này.
- **Ưu điểm vượt trội:**
  - Hoàn toàn độc lập với cấu trúc thư mục của máy chủ host. Container có thể di chuyển giữa máy tính Windows, macOS hoặc Linux mà không cần thay đổi đường dẫn mount.
  - Hỗ trợ Volume Driver: Cho phép lưu trữ dữ liệu lên các hệ thống lưu trữ phân tán hoặc điện toán đám mây (AWS EBS, Google Cloud Persistent Disk, Azure Files, NFS, Ceph) mà ứng dụng bên trong container không cần thay đổi mã nguồn.
  - Hiệu năng I/O tối ưu ngang bằng với việc đọc ghi trực tiếp lên ổ cứng máy chủ vật lý, bỏ qua hoàn toàn cơ chế Copy-on-Write của Storage Driver.
  - Dễ dàng thực hiện sao lưu (backup), di chuyển (migration) và phục hồi (restore).
- **Trường hợp sử dụng:** Cơ sở dữ liệu sản xuất, dữ liệu người dùng tải lên, hàng đợi thông điệp cần lưu giữ lâu dài.

### 2. Bind Mount

- **Vị trí lưu trữ:** Ánh xạ trực tiếp một đường dẫn tệp tin hoặc thư mục bất kỳ từ máy chủ host vào bên trong container (ví dụ ánh xạ `/home/deployer/project/src` vào `/var/www/html`).
- **Quyền quản lý:** Do người dùng và hệ điều hành máy host quản lý trực tiếp.
- **Ưu điểm:** Cho phép chia sẻ tệp tức thời giữa máy host và container. Bất kỳ thay đổi nào trên máy host đều phản ánh ngay lập tức vào trong container và ngược lại.
- **Hạn chế:**
  - Phụ thuộc chặt chẽ vào cấu trúc đường dẫn của máy host. Nếu di chuyển sang máy chủ khác không có đường dẫn tương tự, container sẽ bị lỗi không khởi động được.
  - Vấn đề phân quyền (Permissions): Quyền đọc/ghi của container bị ảnh hưởng trực tiếp bởi quyền sở hữu User ID (UID) và Group ID (GID) của tệp tin trên máy host.
- **Trường hợp sử dụng:**
  - Môi trường phát triển ứng dụng: Gắn mã nguồn từ máy cá nhân vào container để lập trình với tính năng tự động tải lại (Hot-reloading).
  - Đưa tệp cấu hình từ bên ngoài vào: Gắn tệp `nginx.conf` hoặc chứng chỉ SSL từ máy host vào container.

### 3. tmpfs Mount

- **Vị trí lưu trữ:** Dữ liệu được ghi trực tiếp vào bộ nhớ RAM của máy chủ host (hoặc không gian bộ nhớ hoán đổi swap).
- **Đặc điểm:** Không bao giờ được ghi xuống đĩa cứng vật lý. Dữ liệu sẽ tự động bị xóa sạch hoàn toàn ngay khi container dừng hoạt động.
- **Ưu điểm:** Tốc độ truy xuất nhanh nhất vì hoạt động trên tốc độ của bộ nhớ RAM; tính bảo mật tuyệt đối.
- **Trường hợp sử dụng:**
  - Lưu trữ các thông tin cực kỳ nhạy cảm cần bảo mật tối đa: khóa bí mật SSH, khóa giải mã JWT, chứng chỉ số tạm thời.
  - Xử lý các tệp trung gian có kích thước lớn nhưng chỉ dùng một lần trong chốc lát mà không muốn gây hao mòn tuổi thọ ổ cứng thể rắn SSD.

### Bảng phân tích so sánh chi tiết

| Tiêu chí | Docker Volume | Bind Mount | tmpfs Mount |
| :--- | :--- | :--- | :--- |
| **Vị trí trên Host** | `/var/lib/docker/volumes/...` | Bất kỳ thư mục nào trên Host | Bộ nhớ RAM máy chủ |
| **Quản lý bởi** | Docker Daemon CLI | Người dùng hệ điều hành Host | Hệ điều hành / Bộ nhớ RAM |
| **Tính di động (Portability)** | Rất cao (Độc lập với Host OS) | Thấp (Phụ thuộc cấu trúc Host) | Cao |
| **Hỗ trợ Volume Drivers** | Có (Lưu trữ Cloud/NFS) | Không | Không |
| **Tác động quyền file (UID/GID)** | Docker tự xử lý đồng bộ | Dễ phát sinh lỗi Permission denied | Không bị ảnh hưởng |
| **Hiệu năng I/O** | Tương đương Native Host Disk | Tương đương Native Host Disk | Nhanh nhất (Tốc độ RAM) |
| **Tính bền vững dữ liệu** | Bền vững vĩnh viễn | Bền vững vĩnh viễn | Mất ngay khi container dừng |

---

## 18.3. Các lệnh quản lý Docker Volume

Docker cung cấp bộ lệnh hoàn chỉnh để quản lý vòng đời của các Docker Volume:

### 1. Tạo Volume (`docker volume create`)

```bash
# Tạo một Named Volume cơ bản
docker volume create app_data

# Tạo Volume kèm theo nhãn dán (Label) để phục vụ quản lý và phân loại
docker volume create \
  --label environment=production \
  --label project=ecommerce \
  db_storage
```

### 2. Liệt kê danh sách Volume (`docker volume ls`)

```bash
# Liệt kê toàn bộ volume hiện có
docker volume ls

# Lọc danh sách: Tìm kiếm các Volume mồ côi (Dangling Volumes - volume không gắn vào container nào)
docker volume ls --filter dangling=true
```

### 3. Kiểm tra chi tiết Volume (`docker volume inspect`)

```bash
docker volume inspect db_storage
```

Kết quả phản hồi JSON:
```json
[
    {
        "CreatedAt": "2026-10-20T08:30:00Z",
        "Driver": "local",
        "Labels": {
            "environment": "production",
            "project": "ecommerce"
        },
        "Mountpoint": "/var/lib/docker/volumes/db_storage/_data",
        "Name": "db_storage",
        "Options": null,
        "Scope": "local"
    }
]
```
Thuộc tính `Mountpoint` chính là vị trí thư mục thật trên ổ cứng của máy chủ Linux nơi toàn bộ dữ liệu của volume đang được lưu trữ.

### 4. Xóa Volume (`docker volume rm`)

```bash
# Xóa một volume cụ thể (Lưu ý: Volume chỉ có thể bị xóa khi không có container nào đang gắn nó)
docker volume rm app_data
```

### 5. Dọn dẹp hàng loạt Volume mồ côi (`docker volume prune`)

Trong quá trình vận hành, khi người dùng xóa container mà quên không thêm cờ `-v`, các volume cũ vẫn tiếp tục nằm lại trên đĩa cứng máy chủ, gây lãng phí dung lượng lưu trữ theo thời gian. Lệnh prune giúp quét và dọn sạch toàn bộ các volume không sử dụng này:

```bash
# Xóa toàn bộ volume mồ côi và in ra dung lượng đĩa được giải phóng
docker volume prune -f
```

---

## 18.4. Gắn thư mục từ Host vào Container (Bind Mount)

### So sánh hai cú pháp: Cờ `-v` và Cờ `--mount`

Docker hỗ trợ hai cách khai báo mount thư mục:

1. **Cú pháp cổ điển với `-v` hoặc `--volume`:**
   - Cú pháp: `-v <host_path>:<container_path>:<options>`
   - Ví dụ: `-v /var/log/nginx:/var/log/nginx:ro`
   - **Đặc điểm rủi ro:** Nếu thư mục `<host_path>` trên máy host chưa hề tồn tại, Docker sẽ **tự ý tạo một thư mục rỗng** tại đường dẫn đó với quyền sở hữu của người dùng `root`. Điều này thường dẫn đến các lỗi khó phát hiện khi người dùng gõ sai chính tả đường dẫn.

2. **Cú pháp hiện đại và rõ ràng với `--mount` (Khuyến nghị sử dụng):**
   - Cú pháp: `--mount type=bind,source=<host_path>,target=<container_path>[,readonly]`
   - Ví dụ: `--mount type=bind,source=/var/log/nginx,target=/var/log/nginx,readonly`
   - **Ưu điểm an toàn:** Nếu đường dẫn `source` trên host không tồn tại, Docker sẽ lập tức báo lỗi và dừng lệnh thay vì tự ý tạo thư mục rác.

### Tầm quan trọng của chế độ chỉ đọc (Read-only)

Khi gắn các tệp cấu hình hoặc mã nguồn từ host vào container, việc áp đặt chế độ chỉ đọc (`readonly` hoặc `:ro`) là nguyên tắc thực hành bảo mật tối quan trọng:
- Ngăn chặn triệt để nguy cơ ứng dụng bên trong container bị khai thác lỗ hổng rồi sửa đổi hoặc ghi đè mã độc vào các tệp cấu hình trên máy chủ host.
- Bảo vệ tính toàn vẹn của hệ thống máy chủ vật lý.

### Minh họa thực tế: Cấu hình Nginx Web Server bằng Bind Mount chỉ đọc

Giả sử trên máy chủ host có thư mục dự án tại `/home/user/my-web`:
- `/home/user/my-web/conf/nginx.conf`: Tệp cấu hình máy chủ web tùy chỉnh.
- `/home/user/my-web/public`: Thư mục chứa mã nguồn giao diện HTML/CSS.

Khởi chạy container Nginx gắn kết các thư mục trên ở chế độ chỉ đọc:

```bash
docker run -d \
  --name web-production \
  -p 80:80 \
  --mount type=bind,source=/home/user/my-web/conf/nginx.conf,target=/etc/nginx/nginx.conf,readonly \
  --mount type=bind,source=/home/user/my-web/public,target=/usr/share/nginx/html,readonly \
  nginx:alpine
```

Trong cấu hình trên:
- Ứng dụng Nginx đọc cấu hình và phục vụ trang web trực tiếp từ máy host.
- Mọi chỉnh sửa mã nguồn HTML trên máy host có tác dụng ngay lập tức mà không cần build lại image.
- Container hoàn toàn không có quyền ghi đè hay thay đổi bất kỳ tệp nào trong các thư mục được mount.

---

## 18.5. Sao lưu (Backup) và Phục hồi (Restore) Docker Volume

### Nguyên lý sử dụng Container phụ trợ (Helper / Utility Container)

Vì thư mục `/var/lib/docker/volumes` thuộc quyền quản lý khắt khe của Docker Daemon và người dùng không nên trực tiếp sao chép tệp từ đây, kỹ thuật chuẩn mực được các kỹ sư DevOps áp dụng là sử dụng một **Container phụ trợ siêu nhẹ** (chạy hệ điều hành Alpine). 

Container phụ trợ này được gắn kết đồng thời:
1. Volume cần thao tác (ở chế độ chỉ đọc để tránh làm sai lệch dữ liệu).
2. Một thư mục lưu trữ trên máy chủ host (Bind mount).

Sau khi container phụ trợ hoàn tất việc đóng gói hoặc giải nén, nó sẽ tự động bị xóa bỏ khỏi hệ thống bằng cờ `--rm`.

```text
┌────────────────────────────────────────────────────────────────────────┐
│                        QUY TRÌNH BACKUP VOLUME                         │
│                                                                        │
│   ┌─────────────────────┐   Đọc dữ liệu   ┌────────────────────────┐   │
│   │ Docker Volume:      │────────────────>│ Container phụ trợ      │   │
│   │   mysql_prod_data   │   (Chỉ đọc :ro) │   Image: alpine        │   │
│   └─────────────────────┘                 │   Lệnh: tar -czf       │   │
│                                           └───────────┬────────────┘   │
│                                                       │ Xuất tệp nén   │
│                                                       ▼                │
│   ┌────────────────────────────────────────────────────────────────┐   │
│   │ Thư mục Host: /home/user/backups/mysql_backup_20261020.tar.gz  │   │
│   └────────────────────────────────────────────────────────────────┘   │
└────────────────────────────────────────────────────────────────────────┘
```

### 1. Quy trình sao lưu Volume (Backup)

Thực hiện sao lưu toàn bộ dữ liệu của volume `mysql_prod_data` thành một tệp nén `.tar.gz` lưu trữ an toàn tại thư mục `/home/user/backups` trên máy chủ host:

```bash
# 1. Tạo thư mục lưu trữ bản sao lưu trên máy host
mkdir -p /home/user/backups

# 2. Khởi chạy container phụ trợ để đóng gói nén dữ liệu
docker run --rm \
  --mount type=volume,source=mysql_prod_data,target=/volume_data,readonly \
  --mount type=bind,source=/home/user/backups,target=/backup_dest \
  alpine:3.19 \
  tar -czvf /backup_dest/mysql_backup_$(date +%Y%m%d_%H%M%S).tar.gz -C /volume_data .
```

Giải thích chi tiết các tham số:
- `--rm`: Tự động xóa sạch container phụ trợ ngay sau khi tiến trình sao lưu kết thúc.
- `target=/volume_data,readonly`: Gắn volume cần sao lưu vào thư mục `/volume_data` bên trong container với chế độ chỉ đọc tuyệt đối an toàn.
- `target=/backup_dest`: Gắn thư mục chứa bản backup của host vào `/backup_dest`.
- `tar -czvf ... -C /volume_data .`: Nén toàn bộ dữ liệu bên trong thư mục `/volume_data` thành tệp tin lưu vào `/backup_dest`.

Kiểm tra tệp sao lưu đã được tạo trên máy host:

```bash
ls -lh /home/user/backups
# mysql_backup_20261020_090000.tar.gz (Dung lượng: ~25MB)
```

### 2. Quy trình phục hồi Volume (Restore)

Khi cần phục hồi dữ liệu từ tệp sao lưu sang một máy chủ mới hoặc khôi phục sau sự cố mất dữ liệu:

```bash
# 1. Khởi tạo một Docker Volume hoàn toàn mới để nhận dữ liệu phục hồi
docker volume create mysql_restored_data

# 2. Khởi chạy container phụ trợ để giải nén tệp sao lưu vào volume mới
docker run --rm \
  --mount type=volume,source=mysql_restored_data,target=/restore_target \
  --mount type=bind,source=/home/user/backups,target=/backup_src,readonly \
  alpine:3.19 \
  tar -xzvf /backup_src/mysql_backup_20261020_090000.tar.gz -C /restore_target
```

Giải thích lệnh:
- Container phụ trợ đọc tệp nén từ `/backup_src` và giải nén toàn bộ nội dung nguyên trạng vào thư mục `/restore_target` (chính là volume `mysql_restored_data`).

Khởi chạy container cơ sở dữ liệu mới sử dụng volume vừa được phục hồi để xác nhận:

```bash
docker run -d \
  --name mysql-restored-server \
  -e MYSQL_ROOT_PASSWORD=SecurePassword2026 \
  --mount type=volume,source=mysql_restored_data,target=/var/lib/mysql \
  mysql:8.0

# Kiểm tra dữ liệu đã trở lại hoàn toàn
docker exec -i mysql-restored-server mysql -uroot -pSecurePassword2026 company_db -e "SELECT * FROM staff;"
```

### 3. Tự động hóa sao lưu định kỳ với Cron Job

Để tự động hóa việc sao lưu dữ liệu cơ sở dữ liệu hàng ngày, người quản trị có thể thiết lập một tác vụ định kỳ trong Linux Cron:

```bash
# Mở crontab để thêm lịch trình sao lưu tự động
sudo crontab -e

# Thêm dòng sau để tự động sao lưu vào lúc 02:00 sáng mỗi ngày:
0 2 * * * docker run --rm --mount type=volume,source=mysql_prod_data,target=/v,readonly --mount type=bind,source=/home/user/backups,target=/b alpine:3.19 tar -czf /b/mysql_daily_$(date +\%Y\%m\%d).tar.gz -C /v . > /dev/null 2>&1
```

Phương pháp này đảm bảo dữ liệu sản xuất luôn được sao lưu tự động, nhất quán và sẵn sàng ứng cứu khi xảy ra sự cố phần cứng hoặc thảm họa hệ thống.

---

# PHẦN 7: DOCKER COMPOSE

# 19. Mục 19: Tổng quan về Docker Compose

## 19.1. Docker Compose là gì và tại sao cần Docker Compose?

### 1. Docker Compose là gì?

Docker Compose là một công cụ mã nguồn mở chính thức của Docker dùng để định nghĩa và vận hành các ứng dụng đa container (Multi-container Docker Applications). 

Thay vì phải khởi chạy và quản lý từng container đơn lẻ một cách thủ công thông qua hàng loạt câu lệnh dòng lệnh phức tạp, Docker Compose cho phép người quản trị mô tả toàn bộ kiến trúc hệ thống (bao gồm các dịch vụ, cổng mạng, biến môi trường, ổ đĩa lưu trữ và phân vùng mạng) bên trong một tệp tin cấu hình khai báo duy nhất định dạng YAML (thường đặt tên là `compose.yaml`).

```text
                               ┌────────────────────────┐
                               │      compose.yaml      │
                               │ (Định nghĩa toàn bộ    │
                               │  hạ tầng ứng dụng)     │
                               └───────────┬────────────┘
                                           │
                                           │ docker compose up -d
                                           ▼
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                               DOCKER COMPOSE PROJECT                                   │
│                                                                                        │
│   ┌────────────────────┐    ┌────────────────────┐    ┌────────────────────────────┐   │
│   │  Service: frontend │    │  Service: backend  │    │  Service: database         │   │
│   │  (Nginx Reverse    │───>│  (Node.js / Python │───>│  (MySQL / PostgreSQL)      │   │
│   │   Proxy, Port 80)  │    │   API, Port 3000)  │    │   Port 3306 nội bộ)        │   │
│   └────────────────────┘    └────────────────────┘    └──────────────┬─────────────┘   │
│             │                         │                              │                 │
│   ══════════╪═════════════════════════╪══════════════════════════════╪══════════════   │
│             ▼                         ▼                              ▼                 │
│      [Network: app-net]        [Network: app-net]             [Volume: db-data]        │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

### 2. Tại sao cần Docker Compose?

Trong môi trường thực tế, một ứng dụng hiện đại hiếm khi chỉ tồn tại dưới dạng một container độc lập. Một hệ thống tiêu chuẩn thường bao gồm nhiều thành phần phối hợp chặt chẽ:
- Một máy chủ Web Frontend hoặc Reverse Proxy (Nginx).
- Một hoặc nhiều dịch vụ xử lý nghiệp vụ Backend (Node.js, Go, Python, Java).
- Một hệ quản trị cơ sở dữ liệu quan hệ (MySQL, PostgreSQL).
- Một dịch vụ lưu trữ bộ nhớ đệm tốc độ cao (Redis).
- Một hệ thống hàng đợi thông điệp (RabbitMQ, Kafka).

Nếu không có Docker Compose, kỹ sư phần mềm phải thực hiện hàng loạt thao tác thủ công:

```bash
# Nỗi đau khi sử dụng Docker CLI thuần:
docker network create my-app-net
docker volume create db-storage
docker run -d --name redis-cache --network my-app-net redis:alpine
docker run -d --name mysql-db --network my-app-net -v db-storage:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_DATABASE=app_db mysql:8.0
docker run -d --name backend-api --network my-app-net -e DB_HOST=mysql-db -e REDIS_HOST=redis-cache -p 3000:3000 my-backend:v1
docker run -d --name frontend-web --network my-app-net -p 80:80 my-frontend:v1
```

Hạn chế nghiêm trọng của phương pháp thủ công này:
1. **Dễ sai sót và khó ghi nhớ:** Người triển khai phải nhớ chính xác thứ tự khởi chạy của từng container (Database phải chạy trước Backend), nhớ tên mạng, tên volume và hàng chục cờ tham số cấu hình.
2. **Khó tái lập (Lack of Reproducibility):** Khi một thành viên mới gia nhập đội ngũ phát triển hoặc khi triển khai lên máy chủ kiểm thử, việc thiết lập lại toàn bộ chuỗi lệnh trên rất tốn thời gian và dễ phát sinh lỗi do sai khác tham số môi trường.
3. **Quản lý vòng đời phân mảnh:** Muốn dừng hệ thống, lập trình viên phải dừng từng container riêng lẻ. Muốn xem log, phải mở nhiều cửa sổ terminal để theo dõi log của từng container độc lập.

**Docker Compose giải quyết triệt để các vấn đề trên:**
- Toàn bộ hạ tầng được lưu trữ dưới dạng mã nguồn (Infrastructure as Code - IaC) trong tệp `compose.yaml`, được đưa vào hệ thống quản lý phiên bản Git cùng với mã nguồn ứng dụng.
- Toàn bộ hệ thống được khởi động, kiểm tra trạng thái và tắt bỏ chỉ bằng **một câu lệnh duy nhất**.
- Môi trường làm việc của toàn bộ đội ngũ lập trình và kiểm thử được đồng nhất 100%.

---

## 19.2. Phân biệt Docker CLI và Docker Compose

Mặc dù cùng thuộc hệ sinh thái Docker, Docker CLI và Docker Compose phục vụ hai phạm vi và mục đích quản trị khác nhau:

| Tiêu chí | Docker CLI (`docker run`, `docker ps`) | Docker Compose (`docker compose`) |
| :--- | :--- | :--- |
| **Phạm vi quản lý** | Container đơn lẻ (Single container management). | Cụm nhiều container phối hợp (Multi-container application stack). |
| **Phong cách cấu hình** | **Mệnh lệnh (Imperative):** Người dùng phải gõ từng lệnh, chỉ rõ từng cờ tham số khi thực thi. | **Khai báo (Declarative):** Người dùng mô tả trạng thái mong muốn của hệ thống trong tệp YAML, công cụ tự điều phối để đạt được trạng thái đó. |
| **Quản lý mạng (Network)** | Mặc định đưa vào `default bridge`. Muốn liên kết các container phải tự tạo network thủ công trước. | **Tự động hóa hoàn toàn:** Tự động tạo một mạng User-defined Bridge riêng cho dự án và kết nối toàn bộ các service vào đó. |
| **Quản lý thứ tự khởi động** | Người dùng phải tự chạy thủ công theo đúng thứ tự phụ thuộc. | Hỗ trợ cấu hình `depends_on` và `healthcheck` để tự động điều phối chuỗi khởi động. |
| **Quản lý vòng đời** | Bật/tắt/xóa từng container độc lập. | Bật/tắt/xóa toàn bộ hệ thống ứng dụng cùng lúc (`up`, `down`). |
| **Khả năng chia sẻ** | Khó chia sẻ; phải viết các kịch bản shell script phức tạp. | Cực kỳ dễ dàng; chỉ cần gửi tệp `compose.yaml` và `.env` cho đồng nghiệp. |
| **Trường hợp sử dụng** | Chạy thử nghiệm nhanh một image, kiểm tra công cụ đơn lẻ, debug sự cố. | Phát triển phần mềm cục bộ (Local Dev), môi trường kiểm thử (Testing/CI), ứng dụng đơn máy chủ. |

---

## 19.3. Docker Compose V2 và cú pháp docker compose

### 1. Quá trình tiến hóa từ V1 sang V2

- **Docker Compose V1 (`docker-compose` - có dấu gạch ngang):**
  - Ra đời từ năm 2014 (tiền thân là dự án Fig).
  - Được viết bằng ngôn ngữ **Python**.
  - Tồn tại dưới dạng một tiện ích nhị phân độc lập, phải cài đặt riêng biệt qua `pip` hoặc tải tệp script thực thi.
  - Nhược điểm: Tốc độ thực thi chậm, tốn nhiều tài nguyên, thường phát sinh lỗi xung đột phiên bản Python trên máy chủ, và cú pháp lệnh tách rời khỏi công cụ dòng lệnh Docker chính.
  - **Hiện trạng:** Docker đã chính thức khai tử (End of Life) Compose V1 vào tháng 7 năm 2023.

- **Docker Compose V2 (`docker compose` - không có dấu gạch ngang):**
  - Được viết lại hoàn toàn bằng ngôn ngữ **Go** (cùng ngôn ngữ với Docker Engine).
  - Tích hợp trực tiếp vào Docker CLI như một phần mở rộng chính thức (CLI Plugin).
  - **Ưu điểm vượt trội:**
    - Tốc độ khởi động và thực thi nhanh hơn gấp nhiều lần.
    - Đồng bộ hoàn toàn hệ thống cờ, context (chuyển đổi linh hoạt giữa các Docker Host từ xa) và cơ chế xác thực với Docker Engine.
    - Tuân thủ đầy đủ chuẩn mở **Compose Specification** do Linux Foundation và các tập đoàn công nghệ lớn bảo trợ.

```bash
# Cú pháp cũ (Compose V1 - Đã lỗi thời, không khuyến nghị):
docker-compose up -d

# Cú pháp hiện đại (Compose V2 - Tiêu chuẩn hiện nay):
docker compose up -d
```

### 2. Chuẩn tên tệp cấu hình mới

Trong các phiên bản cũ, Docker Compose mặc định tìm kiếm tệp tin mang tên `docker-compose.yml`. Theo chuẩn Compose Specification hiện đại, thứ tự ưu tiên tên tệp được khuyến nghị chuẩn hóa như sau:
1. `compose.yaml` (Ưu tiên số 1 - Khuyến nghị tiêu chuẩn)
2. `compose.yml`
3. `docker-compose.yaml`
4. `docker-compose.yml` (Hỗ trợ tương thích ngược)

---

## 19.4. Cấu trúc file compose.yaml

Tệp `compose.yaml` sử dụng định dạng YAML (YAML Ain't Markup Language) với cấu trúc thụt lề nghiêm ngặt bằng dấu khoảng trắng (tuyệt đối không dùng ký tự Tab).

Trong chuẩn Compose Specification mới, người dùng **không cần khai báo chỉ thị `version: '3.8'`** ở dòng đầu tiên như các phiên bản cũ; Docker Compose V2 tự động nhận diện và áp dụng các tính năng mới nhất của đặc tả Compose.

Một tệp `compose.yaml` tiêu chuẩn gồm 4 khối thành phần chính:

```yaml
# 1. Khối định nghĩa các dịch vụ / container (BẮT BUỘC)
services:
  web:
    image: nginx:alpine
    ports:
      - "80:80"

# 2. Khối định nghĩa các mạng ảo tùy chỉnh (TÙY CHỌN)
networks:
  custom-network:
    driver: bridge

# 3. Khối định nghĩa các ổ đĩa lưu trữ bền vững (TÙY CHỌN)
volumes:
  db-data:
    driver: local

# 4. Khối định nghĩa thông tin bí mật và tệp cấu hình (TÙY CHỌN)
secrets:
  db_password:
    file: ./secrets/db_password.txt
```

---

## 19.5. Các thành phần cốt lõi: Services, Networks, Volumes

### 1. Services (Dịch vụ)
- Mỗi `service` đại diện cho một mẫu cấu hình của một container (hoặc một nhóm các container nhân bản khi scale).
- Bên trong service, người dùng khai báo toàn bộ thông số kỹ thuật tương đương với một lệnh `docker run`: Image sử dụng, cổng ánh xạ, biến môi trường, điểm gắn volume, mạng tham gia và lệnh thực thi mặc định.

### 2. Networks (Mạng)
- Nếu người dùng không khai báo khối `networks`, Docker Compose sẽ **tự động tạo một mạng User-defined Bridge mặc định** có tên theo định dạng `<tên_thư_mục_chứa>_default`.
- Toàn bộ các service nằm trong cùng một tệp Compose đều tự động tham gia vào mạng mặc định này.
- **Tính năng phân giải DNS nội bộ:** Các service có thể giao tiếp với nhau bằng chính **tên của service** (ví dụ: service `backend` kết nối tới cơ sở dữ liệu qua chuỗi kết nối `mysql://database:3306`) mà hoàn toàn không cần quan tâm đến địa chỉ IP động của container.

### 3. Volumes (Ổ đĩa lưu trữ)
- Các Named Volume được khai báo ở khối `volumes` cấp cao nhất sẽ được Docker Compose quản lý tập trung theo vòng đời của dự án.
- Tên volume trên máy chủ host sẽ được gắn tiền tố tên dự án (ví dụ `<tên_dự_án>_db-data`), đảm bảo không bị xung đột với các dự án khác chạy trên cùng một máy chủ.
- Dữ liệu trong volume này hoàn toàn không bị xóa khi người dùng thực hiện lệnh `docker compose down` thông thường, đảm bảo an toàn tuyệt đối cho cơ sở dữ liệu sản xuất.

---

# 20. Mục 20: Viết và quản lý Docker Compose

## 20.1. Khai báo nhiều Service trong một file Compose

Dưới đây là một mô hình hệ thống thực tế hoàn chỉnh bao gồm 3 tầng: Tầng cân bằng tải Reverse Proxy (Nginx), Tầng xử lý nghiệp vụ Backend API (Node.js), và Tầng lưu trữ cơ sở dữ liệu (MySQL):

```yaml
services:
  proxy:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - backend

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    environment:
      PORT: 3000
      DB_HOST: database
      DB_NAME: production_db
    ports:
      - "3000:3000"
    depends_on:
      - database

  database:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: RootPassword2026
      MYSQL_DATABASE: production_db
    volumes:
      - db_storage:/var/lib/mysql

volumes:
  db_storage:
```

Trong kiến trúc trên:
- `proxy` lắng nghe cổng 80 ngoài máy chủ và chuyển tiếp yêu cầu vào `backend:3000`.
- `backend` thực hiện các truy vấn dữ liệu tới máy chủ cơ sở dữ liệu thông qua tên miền nội bộ `database:3306`.
- Dữ liệu của `database` được lưu trữ an toàn trên Named Volume `db_storage`.

---

## 20.2. Cấu hình Image, Build Context và Ports

### 1. Cấu hình Image vs Build Context

Trong mỗi service, người quản trị có thể chỉ định sử dụng một Image có sẵn hoặc yêu cầu Compose tự động biên dịch Image từ mã nguồn cục bộ:

```yaml
services:
  # Cách 1: Sử dụng Image có sẵn trên Docker Hub hoặc Private Registry
  cache-service:
    image: redis:7-alpine

  # Cách 2: Tự động build Image từ Dockerfile cục bộ
  api-service:
    build:
      context: ./backend            # Thư mục chứa mã nguồn làm ngữ cảnh build
      dockerfile: Dockerfile.prod    # Tên tệp Dockerfile (mặc định là Dockerfile)
      args:                          # Truyền biến Build Arguments vào Dockerfile
        APP_VERSION: "2.1.0"
      target: production             # Chỉ định chặng build trong Multi-stage Build
    image: my-company/api:2.1.0      # Gắn tag cho Image sau khi build xong
```

### 2. Phân biệt Ports (Ánh xạ cổng Host) và Expose (Cổng nội bộ)

Đây là điểm kỹ thuật rất quan trọng cần phân biệt rõ ràng:

- **`ports` (Host Port Mapping):**
  - Cú pháp: `"<Host_Port>:<Container_Port>"`
  - Mở cổng trên máy chủ host và thêm quy tắc chuyển tiếp NAT vào iptables.
  - Cho phép người dùng từ mạng Internet bên ngoài truy cập vào container.
  - Ví dụ: `ports: - "8080:80"` (Bên ngoài gọi `http://host-ip:8080`).

- **`expose` (Cổng nội bộ container):**
  - Cú pháp: `expose: - "3306"`
  - **Không hề mở cổng ra máy chủ host**. Người dùng bên ngoài máy host hoàn toàn không thể truy cập vào cổng này.
  - Cổng này chỉ phục vụ việc thông báo và cho phép các container khác nằm trong **cùng mạng Docker Compose** kết nối tới.
  - **Nguyên tắc bảo mật:** Các dịch vụ nhạy cảm như Database, Redis, ElasticSearch chỉ nên dùng `expose` hoặc không cần khai báo cổng, tuyệt đối không dùng `ports` để tránh nguy cơ bị quét cổng và tấn công từ Internet.

---

## 20.3. Quản lý biến môi trường với file .env

### 1. Cú pháp khai báo biến trong Compose

Docker Compose hỗ trợ hai cách cấu hình biến môi trường cho container:

```yaml
services:
  api:
    image: my-api:latest
    # Cách 1: Khai báo trực tiếp dạng danh sách hoặc cặp Key-Value
    environment:
      - NODE_ENV=production
      - LOG_LEVEL=info
      - DB_TIMEOUT=5000

    # Cách 2: Đọc trực tiếp từ một tệp chứa danh sách biến môi trường
    env_file:
      - .env.production
```

### 2. Cơ chế nội suy biến (Variable Interpolation) từ tệp .env

Docker Compose tự động tìm kiếm một tệp tin mang tên `.env` nằm trong cùng thư mục với `compose.yaml` để nội suy các giá trị cấu hình theo cú pháp `${VARIABLE_NAME}` hoặc kèm giá trị mặc định `${VARIABLE_NAME:-default_value}`:

Tệp `.env`:
```bash
# Thông tin cấu hình môi trường dự án
PROJECT_PORT=8080
DATABASE_USER=app_user
DATABASE_PASSWORD=SuperSecretPassword2026!
DATABASE_NAME=ecommerce_db
```

Tệp `compose.yaml`:
```yaml
services:
  web:
    image: nginx:alpine
    ports:
      - "${PROJECT_PORT:-80}:80"

  db:
    image: mysql:8.0
    environment:
      MYSQL_USER: ${DATABASE_USER}
      MYSQL_PASSWORD: ${DATABASE_PASSWORD}
      MYSQL_DATABASE: ${DATABASE_NAME}
      MYSQL_ROOT_PASSWORD: ${DATABASE_PASSWORD}
```

### 3. Quy tắc bảo mật chuẩn DevOps
- **Tuyệt đối không đưa tệp `.env` vào kho lưu trữ Git** (luôn thêm `.env` vào tệp `.gitignore`) vì nó chứa mật khẩu, token bí mật và khóa mã hóa.
- Luôn tạo một tệp tin mẫu mang tên `.env.example` chứa danh sách các tên biến kèm giá trị mẫu rỗng để các thành viên trong đội ngũ phát triển tham khảo và tự tạo tệp `.env` cho riêng mình.

---

## 20.4. Cấu hình Volume và Network trong Compose

### 1. Cấu hình Volume nâng cao

```yaml
services:
  web:
    image: nginx:alpine
    volumes:
      # Loại 1: Bind Mount - Gắn thư mục mã nguồn từ host vào container (chế độ chỉ đọc)
      - type: bind
        source: ./html
        target: /usr/share/nginx/html
        read_only: true

      # Loại 2: Named Volume - Lưu trữ dữ liệu log bền vững
      - type: volume
        source: nginx_logs
        target: /var/log/nginx

volumes:
  nginx_logs: # Khai báo Named Volume ở cấp cao nhất
```

### 2. Cấu hình kiến trúc mạng đa tầng (Multi-tier Network Isolation)

Để tối ưu hóa bảo mật, hệ thống cần được phân chia thành các vùng mạng cô lập:
- Tầng Web (Frontend) chỉ được phép kết nối với tầng API (Backend).
- Tầng Database chỉ được phép kết nối với tầng API (Backend).
- Tầng Web hoàn toàn bị chặn, không thể kết nối trực tiếp vào Tầng Database.

```yaml
services:
  frontend:
    image: nginx:alpine
    ports:
      - "80:80"
    networks:
      - public-net

  backend:
    image: my-backend-api:v1
    networks:
      - public-net
      - private-net

  database:
    image: postgres:16-alpine
    networks:
      - private-net # Database chỉ nằm trong mạng nội bộ, an toàn tuyệt đối

networks:
  public-net:
    driver: bridge
  private-net:
    driver: bridge
```

---

## 20.5. Quản lý phụ thuộc và kiểm tra sức khỏe với depends_on và healthcheck

### Bài toán cuộc đua tiến trình khi khởi động

Một lỗi kinh điển khi vận hành ứng dụng đa container:
- Trong tệp Compose, ta khai báo `backend` có `depends_on: - database`.
- Khi chạy `docker compose up`, Docker Compose sẽ khởi chạy container `database` trước, sau đó khởi chạy ngay container `backend`.
- Tuy nhiên, cờ `depends_on` thông thường **chỉ kiểm tra xem container database đã được khởi tạo ở trạng thái running hay chưa**, chứ không biết tiến trình MySQL bên trong đã hoàn tất việc nạp dữ liệu và mở cổng lắng nghe kết nối hay chưa (MySQL thường mất 15-30 giây để khởi động).
- Hậu quả: Container `backend` bật lên, cố gắng kết nối ngay vào MySQL, gặp lỗi từ chối kết nối (`Connection Refused`) và lập tức bị sập (Crash).

```text
Vấn đề Race Condition (depends_on thông thường):
[Database Container] ── Khởi tạo (Running) ─────────────────────────► Mới mở cổng 3306 (Sau 20s)
                               │ (Bật ngay sau 1s)                         ▲
                               ▼                                           │
[Backend Container]  ── Cố kết nối MySQL ────► BỊ LỖI KẾT NỐI & SẬP! ──────┘

Giải pháp triệt để (depends_on kết hợp healthcheck):
[Database Container] ── Khởi tạo ──> Đang kiểm tra sức khỏe (starting) ──> Đạt chuẩn (healthy)
                                                                                  │
                                                                                  ▼
[Backend Container]  ──────────────── Chờ đợi cho tới khi db healthy ────> Khởi động an toàn!
```

### Giải pháp cấu hình chuẩn xác

Sử dụng thuộc tính `healthcheck` trên service cơ sở dữ liệu và khai báo điều kiện `service_healthy` cho `depends_on` trên service backend:

```yaml
services:
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root_secret_pass
      MYSQL_DATABASE: app_db
    volumes:
      - db_data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-proot_secret_pass"]
      interval: 5s      # Khoảng thời gian kiểm tra lại giữa các lần
      timeout: 3s       # Thời gian chờ phản hồi tối đa của mỗi lần thử
      retries: 10       # Số lần thử lại tối đa trước khi đánh dấu là unhealthy
      start_period: 15s # Thời gian ân hạn ban đầu để MySQL khởi động các bảng

  backend:
    build: ./backend
    ports:
      - "3000:3000"
    depends_on:
      db:
        condition: service_healthy # Chỉ khởi động backend khi db đã thực sự sẵn sàng nhận kết nối!

volumes:
  db_data:
```

---

## 20.6. Bộ lệnh quản lý Docker Compose toàn diện

Bảng tổng hợp các lệnh điều hành Docker Compose thiết yếu nhất trong vận hành hàng ngày:

```bash
# 1. Khởi động toàn bộ hệ thống ứng dụng ở chế độ chạy ngầm (Detached mode)
docker compose up -d

# 2. Khởi động kèm theo việc tự động biên dịch lại các Image nếu có thay đổi mã nguồn
docker compose up -d --build

# 3. Liệt kê danh sách các container thuộc dự án cùng trạng thái sức khỏe và cổng kết nối
docker compose ps

# 4. Theo dõi luồng log thời gian thực của toàn bộ các service
docker compose logs -f

# 5. Theo dõi log riêng biệt của một service duy nhất (ví dụ chỉ xem log của backend)
docker compose logs -f backend

# 6. Thực thi một lệnh trực tiếp bên trong container đang chạy của một service
docker compose exec backend sh
docker compose exec db mysql -u root -p

# 7. Tạm dừng hoạt động các container mà không xóa bỏ tài nguyên
docker compose stop

# 8. Khởi động lại các container đang tạm dừng
docker compose start

# 9. Khởi động lại toàn bộ hoặc một service cụ thể
docker compose restart backend

# 10. Kiểm tra cú pháp tệp YAML và xem cấu hình hoàn chỉnh sau khi đã nội suy biến môi trường
docker compose config

# 11. Dừng và gỡ bỏ toàn bộ container cùng mạng mặc định của dự án
docker compose down

# 12. Dừng và xóa sạch toàn bộ container, mạng VÀ TOÀN BỘ NAMED VOLUMES (Cẩn trọng: Mất dữ liệu DB)
docker compose down -v

# 13. Dừng và dọn dẹp các container mồ côi không còn khai báo trong compose.yaml
docker compose down --remove-orphans
```

---

## 20.7. Mở rộng quy mô với scale và ghi đè cấu hình với compose.override.yaml

### 1. Mở rộng quy mô container (Scaling)

Docker Compose cho phép nhân bản một service thành nhiều container chạy song song để tăng tải xử lý:

```bash
# Tăng số lượng container của service worker lên 4 bản sao
docker compose up -d --scale worker=4
```

*Lưu ý kỹ thuật quan trọng:* Khi thực hiện scale một service có ánh xạ cổng tĩnh ra host (ví dụ `ports: - "3000:3000"`), lệnh scale sẽ gặp lỗi xung đột cổng mạng trên máy host (`port is already allocated`). Để scale thành công các Web/API service, ta phải ánh xạ dải cổng động (ví dụ `ports: - "3000"`) hoặc đặt các bản sao container này phía sau một bộ cân bằng tải như Nginx hay Traefik.

### 2. Quản lý đa môi trường bằng tệp ghi đè (compose.override.yaml)

Theo mặc định, khi người dùng thực thi `docker compose up`, Docker Compose sẽ tự động đọc và hợp nhất hai tệp tin:
1. `compose.yaml`: Chứa cấu hình nền tảng cốt lõi chung cho mọi môi trường.
2. `compose.override.yaml`: Chứa cấu hình riêng biệt dành riêng cho môi trường lập trình cục bộ (Local Development).

Ví dụ minh họa:
- Tệp `compose.yaml` (Cấu hình chung):
  ```yaml
  services:
    app:
      image: my-app:latest
      environment:
        NODE_ENV: production
  ```

- Tệp `compose.override.yaml` (Dành riêng cho máy lập trình viên, thêm tính năng bind mount mã nguồn và mở cổng debug):
  ```yaml
  services:
    app:
      build: .
      environment:
        NODE_ENV: development
      volumes:
        - .:/app # Gắn mã nguồn host vào để hỗ trợ Hot-Reloading
      ports:
        - "9229:9229" # Mở cổng debug cho VS Code
  ```

Khi triển khai lên môi trường sản xuất (Production), người quản trị chỉ định rõ tệp cấu hình production bằng cờ `-f`:

```bash
docker compose -f compose.yaml -f compose.prod.yaml up -d
```