# Tuần 3: Ảo hóa, Container, Docker và Docker Compose

## Phần 1: Tổng quan về ảo hóa

### 1. Ảo hóa là gì?
- **Khái niệm ảo hóa (Virtualization):**
  - Ảo hóa là kỹ thuật tạo ra một phiên bản ảo (phần mềm đại diện) của các tài nguyên điện toán vật lý, bao gồm phần cứng máy tính, bộ vi xử lý (CPU), bộ nhớ (RAM), thiết bị lưu trữ (Storage) và hạ tầng mạng (Network).
- **Mục đích và vai trò của ảo hóa trong hệ thống CNTT:**
  - **Tối ưu hóa tài nguyên:** Thay vì một máy chủ vật lý chỉ chạy một ứng dụng hoặc hệ điều hành (hiệu suất CPU/RAM chỉ đạt 10% - 15%), ảo hóa cho phép hợp nhất nhiều hệ thống lên cùng một máy vật lý, nâng hiệu suất sử dụng lên 70% - 85%.
  - **Cô lập lỗi (Fault Isolation):** Sự cố hoặc phần mềm độc hại trên một máy ảo không thể gây ảnh hưởng hay làm sập các máy ảo khác cùng chạy trên một máy chủ vật lý.
  - **Tiết kiệm chi phí (TCO):** Giảm thiểu chi phí mua sắm thiết bị phần cứng, mặt bằng trung tâm dữ liệu, làm mát và điện năng tiêu thụ.
  - **Linh hoạt và tự động hóa:** Khởi tạo, sao lưu, di trú (migration) và khôi phục sau thảm họa (Disaster Recovery) nhanh chóng trong vài phút thay vì nhiều ngày.
- **Phân biệt Physical Machine (Bare-metal) và Virtual Machine (VM):**

  | Tiêu chí | Physical Machine (Máy vật lý / Bare-metal) | Virtual Machine (Máy ảo) |
  | :--- | :--- | :--- |
  | **Bản chất** | Thiết bị phần cứng vật lý hoàn chỉnh (bo mạch, CPU, RAM, ổ đĩa thực) | Phiên bản phần mềm mô phỏng phần cứng do Hypervisor cấp phát |
  | **Hệ điều hành** | Cài đặt trực tiếp lên phần cứng (Native OS) | Chạy bên trong môi trường ảo hóa (Guest OS) |
  | **Thời gian khởi tạo** | Tốn nhiều ngày để mua sắm, lắp ráp linh kiện, cắm cáp và cài OS | Khởi tạo tức thì trong vài giây đến vài phút từ Image/Template |
  | **Khả năng co giãn (Scaling)** | Khó khăn, phụ thuộc vào việc gắn thêm thanh RAM, ổ cứng vật lý | Linh hoạt, tăng giảm vCPU, vRAM bằng thao tác cấu hình |
  | **Hiệu năng (Performance)** | Đạt 100% hiệu năng tối đa của phần cứng, độ trễ thấp nhất | Chịu độ trễ nhỏ do lớp trung gian ảo hóa (Hypervisor Overhead 1% - 5%) |
  | **Khôi phục sự cố** | Phức tạp, phụ thuộc vào phần cứng thay thế tương đương | Dễ dàng khôi phục từ file Snapshot hoặc bản backup định dạng file ảo |

### 2. Các loại ảo hóa phổ biến
- **Phân loại theo đối tượng ảo hóa:**
  - **Ảo hóa máy chủ (Server Virtualization):** Phổ biến nhất; chia nhỏ một máy chủ vật lý thành nhiều máy ảo độc lập, mỗi máy chạy hệ điều hành riêng (Guest OS).
  - **Ảo hóa hệ điều hành (OS-level Virtualization / Containerization):** Nhân hệ điều hành (Kernel) được chia sẻ giữa các môi trường cô lập gọi là Container (ví dụ: Docker, LXC).
  - **Ảo hóa lưu trữ (Storage Virtualization):** Tập hợp nhiều thiết bị lưu trữ vật lý từ các mảng đĩa (SAN/NAS) thành một vùng lưu trữ tập trung duy nhất (Storage Pool).
  - **Ảo hóa mạng (Network Virtualization / SDN):** Tách lớp điều khiển (Control Plane) khỏi lớp chuyển tiếp dữ liệu (Data Plane), tạo ra các mạng ảo độc lập (VLAN, VXLAN, Virtual Switch, Virtual Router).
- **Phân biệt Full Virtualization, Para-Virtualization và Hardware-Assisted Virtualization:**
  - **Full Virtualization (Ảo hóa toàn phần):**
    - Hypervisor mô phỏng toàn bộ phần cứng mà không yêu cầu chỉnh sửa hệ điều hành khách (Guest OS).
    - Trước khi có hỗ trợ phần cứng, Hypervisor phải dùng kỹ thuật **Binary Translation** để bắt và sửa các lệnh đặc quyền (Sensitive Privileged Instructions), khiến hiệu năng bị giảm sút.
  - **Para-Virtualization (Ảo hóa bán phần):**
    - Guest OS được chỉnh sửa mã nguồn để "biết" rằng nó đang chạy trên môi trường ảo hóa.
    - Thay vì thực thi trực tiếp các lệnh can thiệp phần cứng, Guest OS gửi các cuộc gọi đặc biệt gọi là **Hypercalls** tới Hypervisor (ví dụ: Xen, driver `virtio` trong Linux). Hiệu năng cao hơn Binary Translation nhưng hạn chế với các hệ điều hành đóng nếu không có driver thích hợp.
  - **Hardware-Assisted Virtualization (Ảo hóa có sự hỗ trợ phần cứng):**
    - Các nhà sản xuất vi xử lý bổ sung tập lệnh ảo hóa trực tiếp vào CPU: **Intel VT-x** (Intel Virtualization Technology) và **AMD-V** (AMD Virtualization).
    - CPU chia làm hai chế độ hoạt động: **Root Mode** (cho Hypervisor) và **Non-Root Mode** (cho Guest OS). Các lệnh đặc quyền tự động kích hoạt sự kiện **VM Exit** chuyển quyền kiểm soát về Hypervisor mà không cần sửa đổi Guest OS hay Binary Translation.
- **Kiểm tra CPU hỗ trợ ảo hóa (Intel VT-x, AMD-V) trên Linux:**
  ```bash
  # Kiểm tra số lượng core hỗ trợ Intel VT-x (vmx) hoặc AMD-V (svm)
  egrep -c '(vmx|svm)' /proc/cpuinfo
  # Nếu kết quả > 0: CPU hỗ trợ ảo hóa phần cứng

  # Sử dụng lệnh lscpu để xem chi tiết
  lscpu | grep -i virtualization
  # Output mẫu: Virtualization: VT-x (hoặc AMD-V)
  ```

### 3. Hypervisor và các công nghệ ảo hóa
- **Hypervisor là gì? Vai trò của Hypervisor:**
  - Hypervisor (còn gọi là **Virtual Machine Monitor - VMM**) là lớp phần mềm, firmware hoặc phần cứng có nhiệm vụ tạo lập, phân phối tài nguyên phần cứng vật lý và quản lý vòng đời, sự cô lập của các máy ảo.
- **Phân biệt Hypervisor Type 1 và Type 2:**

  | Đặc điểm | Hypervisor Type 1 (Bare-metal / Native) | Hypervisor Type 2 (Hosted) |
  | :--- | :--- | :--- |
  | **Vị trí cài đặt** | Cài đặt trực tiếp lên phần cứng vật lý, không cần Host OS trung gian | Cài đặt như một phần mềm ứng dụng trên nền Host OS có sẵn |
  | **Hiệu năng & Độ trễ** | Hiệu năng cực cao, độ trễ tối thiểu (gần tương đương Bare-metal) | Hiệu năng thấp hơn do phải đi qua 2 tầng trung gian (Hypervisor + Host OS) |
  | **Độ ổn định & Bảo mật** | Rất cao, diện tích tấn công nhỏ vì không có OS dư thừa | Phụ thuộc vào độ ổn định và lỗ hổng của Host OS nền bên dưới |
  | **Mục đích sử dụng** | Data Center, Hạ tầng đám mây Cloud (AWS, Azure), Doanh nghiệp lớn | Máy tính cá nhân, môi trường học tập, kiểm thử phần mềm nhanh |
  | **Công nghệ tiêu biểu** | VMware ESXi, KVM (Linux Kernel), Proxmox VE, Microsoft Hyper-V, Xen Server | Oracle VirtualBox, VMware Workstation, VMware Fusion, Parallels Desktop |

- **Các công nghệ ảo hóa phổ biến:**
  - **VMware ESXi:** Hypervisor Type 1 thương mại hàng đầu cho doanh nghiệp.
  - **KVM (Kernel-based Virtual Machine):** Module tích hợp sẵn trong nhân Linux giúp biến Linux thành Hypervisor Type 1.
  - **Microsoft Hyper-V:** Công nghệ ảo hóa Type 1 tích hợp trên Windows Server và Windows Pro/Enterprise.
  - **Xen Project:** Hypervisor Type 1 mã nguồn mở được sử dụng rộng rãi trên các nền tảng Cloud đời đầu.
  - **Proxmox VE:** Nền tảng quản trị ảo hóa mã nguồn mở tích hợp cả KVM (cho VM) và LXC (cho Container).
  - **Oracle VirtualBox / VMware Workstation:** Các Hypervisor Type 2 phổ biến nhất cho máy tính cá nhân.

---

## Phần 2: Virtual Machine

### 4. Tổng quan về Virtual Machine
- **Khái niệm Virtual Machine & Kiến trúc máy ảo:**
  - Máy ảo (VM) là một môi trường máy tính được định nghĩa bằng phần mềm, hoạt động như một hệ thống máy tính vật lý độc lập với CPU, RAM, ổ cứng và card mạng riêng.
- **Phân biệt Host OS và Guest OS:**
  - **Host OS (Hệ điều hành máy chủ):** Hệ điều hành chạy trực tiếp trên máy vật lý (trong mô hình Type 2 hoặc KVM).
  - **Guest OS (Hệ điều hành máy khách):** Hệ điều hành được cài đặt và vận hành hoàn toàn bên trong máy ảo, tách biệt với Host OS và các VM khác.
- **Các thành phần được ảo hóa:**
  - **CPU (vCPU):** Đơn vị thực thi ảo do Hypervisor lập lịch lên các luồng/nhân vật lý (Logical/Physical Cores) của CPU thật.
  - **Memory (vRAM):** Không gian bộ nhớ ảo cấp phát cho VM từ tổng dung lượng RAM vật lý của host.
  - **Disk (Virtual Disk):** Một file duy nhất trên host đóng vai trò là toàn bộ ổ cứng của máy ảo:
    - **Các định dạng phổ biến:**
      - `.qcow2` (QEMU Copy-On-Write): Định dạng chuẩn của KVM/Proxmox, hỗ trợ snapshot, nén và cấp phát động.
      - `.vmdk`: Định dạng ổ đĩa ảo của hệ sinh thái VMware.
      - `.vdi`: Định dạng mặc định của Oracle VirtualBox.
    - **Cơ chế cấp phát đĩa (Disk Provisioning):**
      - **Thin Provisioning (Cấp phát động):** Ban đầu file ổ đĩa ảo chỉ chiếm dung lượng nhỏ, tăng dần kích thước khi Guest OS thực sự ghi dữ liệu cho đến khi đạt giới hạn khai báo. Giúp tiết kiệm dung lượng đĩa.
      - **Thick Provisioning (Cấp phát cố định):** Chiếm trọn vẹn dung lượng ổ đĩa ngay khi khởi tạo (ví dụ khai báo 100GB sẽ chiếm ngay 100GB trên host). Cho hiệu năng ghi I/O ổn định hơn.
  - **Network Interface (vNIC):** Card mạng ảo kết nối vào các chế độ mạng:
    - **NAT (Network Address Translation):** VM đi ra ngoài Internet thông qua IP của Host, máy ngoài mạng không truy cập trực tiếp vào VM được (nếu không cấu hình Port Forwarding).
    - **Bridged Adapter (Mạng cầu nối):** VM trở thành một thiết bị độc lập trên mạng LAN vật lý, nhận IP cùng dải với Host từ DHCP Router ngoài.
    - **Host-only:** Chỉ giao tiếp nội bộ giữa Host và các VM, cách ly hoàn toàn khỏi mạng bên ngoài và Internet.
- **Cơ chế chia sẻ tài nguyên giữa các VM trên cùng máy vật lý:**
  - **Overcommit (Cấp phát vượt mức):** Cho phép tổng tài nguyên khai báo cho các VM lớn hơn tài nguyên vật lý thực tế (nhờ cơ chế Memory Ballooning và KSM - Kernel Samepage Merging khi các VM không dùng hết 100% tài nguyên cùng lúc).
  - **Reservation (Dành riêng):** Đảm bảo mức tài nguyên tối thiểu mà host luôn phải bảo lưu riêng cho VM đó.
  - **Limit (Giới hạn trần):** Ngăn không cho một VM sử dụng vượt quá ngưỡng tài nguyên chỉ định.
  - **Share (Tỷ trọng ưu tiên):** Xác định quyền ưu tiên nhận tài nguyên giữa các VM khi hệ thống vật lý xảy ra tranh chấp (Congestion).

### 5. Cơ chế hoạt động của máy ảo
- **Nguyên lý hoạt động & Hardware-Assisted Virtualization:**
  - Guest OS chạy ở chế độ **Non-Root Mode**, thực thi các chỉ lệnh thông thường trực tiếp trên CPU vật lý với tốc độ tối đa.
  - Khi Guest OS yêu cầu thực hiện một lệnh đặc quyền (như thay đổi bảng trang bộ nhớ, can thiệp ngắt phần cứng):
    1. **VM Exit:** CPU phần cứng lập tức dừng việc thực thi của Guest OS, lưu trạng thái thanh ghi và trao quyền điều khiển về Hypervisor (chạy ở **Root Mode**).
    2. **Xử lý:** Hypervisor kiểm tra và mô phỏng hành vi an toàn.
    3. **VM Entry:** Hypervisor nạp lại ngữ cảnh và trả quyền điều khiển cho Guest OS tiếp tục chạy.
- **Ảo hóa CPU:**
  - Hypervisor đóng vai trò bộ lập lịch (Scheduler), ánh xạ các vCPU của máy ảo lên các Physical/Logical Core của CPU vật lý theo các lát cắt thời gian (time slices).
- **Ảo hóa bộ nhớ (Memory Virtualization):**
  - Quản lý chuyển đổi qua 3 tầng địa chỉ:
    `Guest Virtual Address (GVA)` $\rightarrow$ `Guest Physical Address (GPA)` $\rightarrow$ `Host Physical Address (HPA)`
  - Công nghệ **EPT (Extended Page Tables - Intel)** và **NPT (Nested Page Tables - AMD)** hỗ trợ dịch địa chỉ phần cứng hai tầng trực tiếp trên MMU của vi xử lý, giảm thiểu tối đa chi phí hiệu năng so với kỹ thuật Shadow Page Tables cũ.
- **Ảo hóa I/O:**
  - **Emulation (Mô phỏng):** Hypervisor mô phỏng hoàn toàn phần cứng truyền thống (như card mạng Intel e1000, ổ đĩa IDE). Tốc độ chậm do phát sinh nhiều sự kiện VM Exit.
  - **Para-virtualization (`virtio`):** Chuẩn driver tối ưu hóa cho ảo hóa (KVM/QEMU). Guest OS sử dụng hàng đợi vòng chia sẻ bộ nhớ (`virtqueue`) để trao đổi dữ liệu trực tiếp với Hypervisor, giúp tăng tốc độ I/O mạng và đĩa vượt trội.
  - **PCI Passthrough & SR-IOV:** Gán trực tiếp thiết bị phần cứng vật lý (như GPU, card mạng tốc độ cao) vào thẳng máy ảo thông qua IOMMU (Intel VT-d / AMD-Vi), đạt hiệu năng gần như 100% bare-metal.
- **Mô hình KVM + QEMU + libvirt:**
  - **KVM (Kernel-based Virtual Machine):** Module nhân Linux (`kvm.ko`), biến nhân Linux thành Hypervisor Type 1 thông qua giao diện `/dev/kvm`, chịu trách nhiệm ảo hóa CPU và bộ nhớ.
  - **QEMU:** Chương trình không gian người dùng (user-space) chịu trách nhiệm mô phỏng các thiết bị ngoại vi (bo mạch, ổ đĩa, card mạng, VGA) và phối hợp với KVM để thực thi mã máy với tốc độ phần cứng.
  - **libvirt:** Thư viện và dịch vụ daemon (`libvirtd`) cung cấp bộ API thống nhất cùng các công cụ quản trị như `virsh` (CLI) và `virt-manager` (GUI) để quản lý máy ảo KVM/QEMU dễ dàng.

### 6. Vòng đời và quản lý VM
- **Các trạng thái của VM:**
  - **Created (Defined):** Máy ảo đã được định nghĩa cấu hình phần cứng nhưng chưa chạy.
  - **Running:** Máy ảo đang hoạt động và tiêu thụ tài nguyên CPU/RAM trên host.
  - **Paused (Suspended):** Tạm dừng thực thi vCPU nhưng vẫn giữ nguyên trạng thái trong bộ nhớ RAM (hoặc lưu xuống đĩa).
  - **Stopped (Shutoff):** Máy ảo đã tắt hoàn toàn, giải phóng CPU và RAM.
- **Các thao tác quản lý vòng đời cơ bản (với `virsh`):**
  - Tạo và khởi động máy ảo: `virsh create <file.xml>` hoặc `virsh start <vm-name>`
  - Tạm dừng / Tiếp tục: `virsh suspend <vm-name>` / `virsh resume <vm-name>`
  - Tắt máy an toàn / Cưỡng chế tắt: `virsh shutdown <vm-name>` / `virsh destroy <vm-name>`
  - Xóa máy ảo: `virsh undefine <vm-name> --remove-all-storage`
- **Cấp phát và điều chỉnh CPU, RAM, Disk:**
  - Điều chỉnh cấu hình máy ảo qua `virsh edit <vm-name>`, `virsh setvcpus`, `virsh setmem`, hoặc mở rộng ổ đĩa ảo bằng `qemu-img resize <disk.qcow2> +10G`.
- **Snapshot, Clone và Template:**
  - **Snapshot:** Lưu lại trạng thái ổ đĩa và bộ nhớ của VM tại một thời điểm cụ thể. Khi tạo snapshot, đĩa gốc chuyển sang Read-Only và mọi thay đổi mới được ghi vào file vi sai (delta file), giúp dễ dàng quay lui (Revert) khi cập nhật hệ thống lỗi.
  - **Clone:**
    - *Full Clone:* Sao chép hoàn toàn độc lập một máy ảo mới từ máy ảo gốc, tách rời hoàn toàn về mặt lưu trữ.
    - *Linked Clone:* Máy ảo mới dùng chung đĩa gốc (base image) và chỉ ghi phần thay đổi vào đĩa riêng, giúp tạo cực nhanh và tiết kiệm dung lượng.
  - **Template:** Bản mẫu máy ảo đã được chuẩn hóa (đã xóa định danh riêng như SSH host keys, machine-id, MAC address qua `sysprep` hoặc `cloud-init`), dùng để nhân bản hàng loạt VM mới.
- **Backup và Restore máy ảo:**
  - Sao lưu toàn bộ file cấu hình (`.xml`) và file ổ đĩa ảo (`.qcow2`, `.vmdk`) hoặc xuất ra định dạng chuẩn hóa `.ova` / `.ovf` để khôi phục trên hệ thống khác.
- **Khái niệm Live Migration và High Availability (HA):**
  - **Live Migration:** Di chuyển một máy ảo đang chạy từ Host vật lý này sang Host vật lý khác qua mạng với thời gian gián đoạn dịch vụ gần bằng 0 (nhờ cơ chế truyền đồng bộ bộ nhớ RAM ở chế độ nền trước khi chuyển giao).
  - **High Availability (HA):** Cơ chế giám sát cụm máy chủ (Cluster); khi một Host vật lý gặp sự cố sập nguồn hoặc lỗi phần cứng, các máy ảo trên đó sẽ tự động được khởi động lại trên các Host còn sống trong cụm.

### 7. Thực hành quản lý VM
- **Kiểm tra hỗ trợ ảo hóa KVM và quản lý VM trên Linux:**
  ```bash
  # 1. Cài đặt công cụ và kiểm tra hỗ trợ KVM
  sudo apt update && sudo apt install -y cpu-checker
  kvm-ok
  # Kết quả: INFO: /dev/kvm exists - KVM acceleration can be used

  # 2. Xem danh sách máy ảo quản lý bởi libvirt/virsh
  virsh list --all

  # 3. Kiểm tra tài nguyên ảo hóa bên trong VM Ubuntu Server
  lscpu        # Quan sát số lượng vCPU và thông tin Hypervisor (KVM/VirtualBox)
  free -h      # Quan sát dung lượng vRAM và Swap
  lsblk        # Quan sát ổ đĩa ảo (vda hoặc sda) và các phân vùng

  # 4. Tạo Snapshot, xem danh sách và Revert bằng virsh
  virsh snapshot-create-as --domain ubuntu-vm --name "before-update" --description "Snapshot truoc khi cap nhat"
  virsh snapshot-list --domain ubuntu-vm
  virsh snapshot-revert --domain ubuntu-vm --snapshotname "before-update"

  # 5. Clone máy ảo
  virt-clone --original ubuntu-vm --name ubuntu-vm-clone --auto-clone
  ```

---

## Phần 3: Tổng quan về Container

### 8. Container là gì?
- **Khái niệm Container và Containerization:**
  - **Containerization:** Là phương pháp ảo hóa ở cấp độ hệ điều hành (OS-level Virtualization), cho phép đóng gói toàn bộ mã nguồn ứng dụng cùng tất cả các thư viện phụ thuộc (dependencies, runtime, biến môi trường, file cấu hình) vào một gói duy nhất.
  - **Bản chất của Container:** Container không phải là một máy ảo thu nhỏ. Container thực chất là **các tiến trình (Processes) thông thường trên Host OS**, nhưng được nhân hệ điều hành cô lập góc nhìn bằng **Namespaces** và giới hạn tài nguyên bằng **cgroups**.
- **Mục đích sử dụng Container trong phát triển và triển khai ứng dụng:**
  - Giải quyết triệt để vấn đề *"Chạy được trên máy tôi nhưng lỗi trên server"* nhờ tính nhất quán môi trường từ Development, Testing đến Production.
  - Khởi động tức thì (tính bằng mili-giây), tiêu tốn cực ít tài nguyên và hỗ trợ kiến trúc Microservices, CI/CD, Auto-scaling hiệu quả.
- **Phân biệt Container và Virtual Machine:**

  | Tiêu chí | Virtual Machine (Máy ảo) | Container |
  | :--- | :--- | :--- |
  | **Kiến trúc** | Mỗi VM có trọn vẹn một **Guest OS Kernel riêng biệt** | **Dùng chung (Share) Kernel của máy Host** |
  | **Dung lượng (Size)** | Rất lớn: từ vài GB đến vài chục GB mỗi VM (chứa cả OS) | Cực nhẹ: từ vài MB (Alpine ~5MB) đến vài trăm MB |
  | **Thời gian khởi động** | Chậm: tính bằng phút (phải qua toàn bộ Boot Process của OS) | Cực nhanh: **tính bằng mili-giây hoặc giây** (khởi chạy tiến trình) |
  | **Hiệu năng I/O & CPU** | Có độ trễ do lớp trừu tượng hóa phần cứng của Hypervisor | **Hiệu năng nguyên bản (Native performance)** như tiến trình trên host |
  | **Mức độ cô lập (Isolation)** | Cô lập phần cứng tuyệt đối (Hardware-level Isolation) | Cô lập logic ở tầng hệ điều hành (Process-level Isolation) |
  | **Mật độ ứng dụng (Density)** | Thấp: một máy chủ vật lý chỉ chạy được vài chục VM | Rất cao: một máy chủ có thể chạy hàng trăm đến hàng nghìn container |

- **Hạn chế của Container và các trường hợp nên sử dụng VM:**
  - **Hạn chế của Container:**
    - Dùng chung Kernel của Host nên nếu Kernel của Host gặp lỗ hổng bảo mật (Kernel Exploit / Container Escape) hoặc bị crash (Kernel Panic), toàn bộ container trên đó đều bị ảnh hưởng.
    - Phụ thuộc vào hệ điều hành Host (Container Linux cần Linux Kernel; không thể chạy trực tiếp ứng dụng yêu cầu nhân Windows nguyên bản trên Linux Kernel mà không có lớp ảo hóa).
  - **Khi nào nên sử dụng VM:**
    - Cần chạy các hệ điều hành có nhân khác nhau trên cùng phần cứng vật lý (ví dụ chạy Windows Server trên Linux Host).
    - Yêu cầu cô lập bảo mật phần cứng nghiêm ngặt (môi trường Multi-tenancy giữa các khách hàng khác nhau).
    - Chạy các hệ thống nguyên khối (Legacy Monolith) hoặc ứng dụng cần can thiệp sâu vào kernel module, driver phần cứng.

### 9. Cơ chế hoạt động của Container trên Linux
- **Container sử dụng chung Linux Kernel như thế nào?**
  - Mọi tiến trình chạy bên trong Container thực chất đều thực hiện các lời gọi hệ thống (System Calls - `syscalls`) trực tiếp tới duy nhất một Linux Kernel của máy Host, không hề có nhân hệ điều hành thứ hai nào được khởi chạy.
- **Linux Namespaces (Cô lập góc nhìn của tiến trình):**
  Namespaces quy định những gì một tiến trình bên trong container **được phép nhìn thấy**:
  1. **PID Namespace (Process ID):** Cô lập cây tiến trình. Tiến trình chính trong container luôn nhìn thấy nó có `PID 1`, dù ngoài máy Host nó có một PID thông thường khác.
  2. **NET Namespace (Network):** Cung cấp cho container giao diện mạng ảo riêng (`eth0`, `lo`), bảng định tuyến (routing table), địa chỉ IP và dải port độc lập.
  3. **MNT Namespace (Mount):** Cho phép container có cấu trúc cây thư mục gốc `/` riêng biệt, tách rời khỏi hệ thống tệp của host.
  4. **UTS Namespace (UNIX Timesharing System):** Cho phép mỗi container đặt tên máy chủ (`hostname`) và domain riêng.
  5. **IPC Namespace (Inter-Process Communication):** Cô lập các kênh giao tiếp liên tiến trình như bộ nhớ dùng chung (Shared Memory) và Semaphore.
  6. **USER Namespace:** Ánh xạ định danh người dùng; cho phép tiến trình chạy với quyền `UID 0` (root) bên trong container nhưng thực chất chỉ tương ứng với một user không đặc quyền ngoài Host, hạn chế rủi ro leo thang đặc quyền.
- **Control Groups (cgroups - Giới hạn và đo lường tài nguyên):**
  cgroups quy định lượng tài nguyên phần cứng mà container **được phép sử dụng**:
  - **CPU:** Giới hạn tỷ lệ % sử dụng CPU (`--cpus`) hoặc ghim cố định vào các nhân CPU cụ thể (`--cpuset-cpus`).
  - **Memory:** Giới hạn dung lượng RAM và Swap tối đa (`--memory`). Nếu container vượt ngưỡng cho phép, nhân Linux sẽ kích hoạt **OOM Killer (Out Of Memory)** để dừng tiến trình container, bảo vệ máy Host.
  - **Block I/O & PIDs:** Giới hạn băng thông đọc/ghi ổ đĩa và số lượng tiến trình tối đa được phép tạo ra (ngăn chặn tấn công Fork Bomb).
- **Union Filesystem, OverlayFS và cơ chế Copy-on-Write (CoW):**
  - Docker sử dụng **OverlayFS** để xếp chồng nhiều lớp thư mục lên nhau thành một góc nhìn thống nhất (`MergedDir`):
    - **Image Layers (`LowerDir` - Read-Only):** Các lớp tệp tin gốc của Image được khóa chỉ đọc và chia sẻ dùng chung cho mọi container khởi tạo từ cùng một image.
    - **Container Layer (`UpperDir` - Read-Write):** Một lớp mỏng khả ghi được tạo mới trên cùng khi container chạy.
  - **Cơ chế Copy-on-Write (CoW):** Khi container chỉ đọc file, nó đọc trực tiếp từ `LowerDir`. Khi container cần sửa một file ở `LowerDir`, OverlayFS mới sao chép file đó lên `UpperDir` và thực hiện ghi trên bản sao này. Giúp tiết kiệm tối đa dung lượng đĩa và tăng tốc độ khởi tạo container.
- **Phân biệt Container Image và Container Runtime:**
  - **Container Image:** Gói dữ liệu tĩnh (Read-Only) chứa filesystem, mã nguồn, thư viện và metadata cấu hình của ứng dụng.
  - **Container Runtime:** Thành phần phần mềm chịu trách nhiệm giải nén Image, thiết lập Namespaces/cgroups trên Kernel và thực sự khởi chạy tiến trình Container (ví dụ: `containerd`, `CRI-O`, `runc`).
- **Chuẩn OCI (Open Container Initiative):**
  - Tổ chức do Linux Foundation thành lập nhằm chuẩn hóa hệ sinh thái container thông qua 2 đặc tả cốt lõi:
    1. **OCI Image Specification:** Chuẩn hóa cấu trúc đóng gói Image (các layer nén `tar` và file `manifest.json`, `config.json`).
    2. **OCI Runtime Specification:** Chuẩn hóa cách thức cấu hình và khởi chạy một container từ filesystem bundle. Trình thực thi chuẩn mực phổ biến nhất hiện nay là **`runc`**.

---

## Phần 4: Docker cơ bản

### 10. Tổng quan về Docker
- **Docker là gì? Tại sao cần Docker?**
  - Docker là nền tảng mã nguồn mở giúp tự động hóa việc xây dựng (Build), phân phối (Ship) và khởi chạy (Run) ứng dụng bên trong các container.
  - Docker chuẩn hóa môi trường triển khai, loại bỏ xung đột thư viện trên máy chủ, rút ngắn thời gian bàn giao phần mềm và tối ưu hóa hạ tầng máy chủ.
- **Các thành phần của Docker Platform:**
  - **Docker Engine:** Phần mềm cốt lõi theo mô hình Client-Server chạy trên Linux/Windows Server, bao gồm Docker Daemon (`dockerd`), REST API và Docker CLI (`docker`).
  - **Docker Desktop:** Ứng dụng tích hợp GUI, Docker Engine và máy ảo Linux mỏng dành cho máy tính lập trình viên trên Windows và macOS.
  - **Docker CE (Community Edition) & Docker Enterprise (Mirantis):** Docker CE là phiên bản miễn phí mã nguồn mở dành cho cá nhân và đội ngũ phát triển; bản Enterprise cung cấp thêm các tính năng quản trị cụm, bảo mật quét lỗ hổng và hỗ trợ thương mại cho doanh nghiệp.
- **Khái niệm Docker Image, Container, Registry:**
  - **Docker Image:** Bản thiết kế (blueprint) tĩnh, ở chế độ Read-Only, chứa toàn bộ mã nguồn, runtime và thư viện cần thiết để chạy ứng dụng.
  - **Docker Container:** Một thực thể đang chạy (running instance) được khởi tạo từ Docker Image, có thêm một lớp Read-Write mỏng ở trên cùng.
  - **Docker Registry:** Kho lưu trữ tập trung dùng để lưu trữ, quản lý phiên bản và phân phối các Docker Image (ví dụ: Docker Hub, Harbor, GitHub Container Registry, AWS ECR).
- **Quy trình cơ bản: Build $\rightarrow$ Ship $\rightarrow$ Run:**
  1. **Build:** Đóng gói ứng dụng và môi trường thành Docker Image thông qua `Dockerfile`.
  2. **Ship:** Đẩy (`push`) Image lên Docker Registry để chia sẻ hoặc lưu trữ tập trung.
  3. **Run:** Tải (`pull`) Image từ Registry về bất kỳ máy chủ nào và khởi chạy thành các Container.

### 11. Cài đặt và cấu hình Docker trên Linux
- **Cài đặt Docker Engine trên Ubuntu:**
  ```bash
  # 1. Gỡ bỏ các gói cũ không chính thức (nếu có)
  sudo apt remove -y docker docker-engine docker.io containerd runc

  # 2. Cài đặt các gói phụ thuộc để tải qua HTTPS
  sudo apt update
  sudo apt install -y ca-certificates curl gnupg lsb-release

  # 3. Thêm GPG key chính thức của Docker
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg

  # 4. Thêm repository của Docker vào Apt sources
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  # 5. Cài đặt Docker Engine, CLI, containerd và Docker Compose plugin
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  ```
- **Chạy Docker không cần `sudo` (nhóm `docker`) và lưu ý bảo mật:**
  ```bash
  # Thêm user hiện tại vào group docker
  sudo usermod -aG docker $USER
  newgrp docker
  ```
  - **Lưu ý bảo mật:** Docker Daemon giao tiếp qua Unix socket `/var/run/docker.sock` với quyền `root`. Bất kỳ user nào nằm trong nhóm `docker` đều có quyền tương đương `root` trên máy Host (vì có thể chạy `docker run -v /:/host -it alpine chroot /host` để chiếm toàn quyền hệ thống). Chỉ thêm những tài khoản thực sự tin cậy vào nhóm này.
- **Kiểm tra Docker và quản lý dịch vụ với `systemctl`:**
  ```bash
  # Kiểm tra phiên bản và thông tin chi tiết hệ thống Docker
  docker version
  docker info

  # Quản lý dịch vụ Docker bằng systemctl
  sudo systemctl start docker
  sudo systemctl enable docker
  sudo systemctl status docker
  sudo systemctl restart docker
  ```
- **Cấu hình Docker Proxy:**
  - **Proxy cho Docker Daemon (dùng khi `docker pull` / `docker build` cần đi qua proxy):**
    Tạo file `/etc/systemd/system/docker.service.d/http-proxy.conf`:
    ```ini
    [Service]
    Environment="HTTP_PROXY=http://proxy.example.com:8080"
    Environment="HTTPS_PROXY=http://proxy.example.com:8080"
    Environment="NO_PROXY=localhost,127.0.0.1,.corp.local"
    ```
    Sau đó chạy `sudo systemctl daemon-reload && sudo systemctl restart docker`.
  - **Proxy cho Docker Client và Container (dùng cho tiến trình bên trong container):**
    Cấu hình trong `~/.docker/config.json`:
    ```json
    {
      "proxies": {
        "default": {
          "httpProxy": "http://proxy.example.com:8080",
          "httpsProxy": "http://proxy.example.com:8080",
          "noProxy": "localhost,127.0.0.1"
        }
      }
    }
    ```
- **Cấu hình Docker Registry:**
  - **Cấu hình chứng chỉ CA tin cậy cho Registry nội bộ:** Copy file chứng chỉ `ca.crt` của Private Registry vào thư mục `/etc/docker/certs.d/<registry-domain>:<port>/ca.crt`.
  - **Cấu hình `insecure-registries` trong `/etc/docker/daemon.json` (cho môi trường thử nghiệm dùng HTTP hoặc self-signed cert):**
    ```json
    {
      "insecure-registries": ["192.168.1.200:5000", "registry.local:5000"],
      "log-driver": "json-file",
      "log-opts": {
        "max-size": "50m",
        "max-file": "3"
      }
    }
    ```
    Khởi động lại dịch vụ sau khi sửa: `sudo systemctl restart docker`.
- **Chạy Container đầu tiên:**
  ```bash
  docker run --rm hello-world
  ```

### 12. Các câu lệnh Docker cơ bản
- **Quản lý Image:**
  - `docker pull <image>:<tag>`: Tải một Image từ Registry về máy local.
  - `docker images` (hoặc `docker image ls`): Liệt kê danh sách các Image đang có trên máy.
  - `docker rmi <image_id/name>`: Xóa một hoặc nhiều Image khỏi máy local.
  - `docker image prune -f`: Xóa các dangling images (image không có tag và không được sử dụng).
- **Khởi tạo và chạy Container (`docker run`):**
  ```bash
  docker run -d \
    --name my-web \
    -p 8080:80 \
    -v /var/www/html:/usr/share/nginx/html:ro \
    -e TZ=Asia/Ho_Chi_Minh \
    --restart unless-stopped \
    --memory="256m" \
    --cpus="0.5" \
    nginx:alpine
  ```
  - **Giải thích các tùy chọn quan trọng:**
    - `-d` (Detached): Chạy container ngầm trong background.
    - `-it` (Interactive + TTY): Cấp phát terminal tương tác (thường kết hợp với `sh`/`bash`).
    - `--name <name>`: Đặt tên định danh cho container.
    - `-p <host_port>:<container_port>`: Ánh xạ cổng (Port Mapping) từ máy Host vào Container.
    - `-v <host_path/vol>:<container_path>`: Gắn kết Volume hoặc Bind Mount vào Container.
    - `-e KEY=VALUE`: Truyền biến môi trường vào bên trong Container.
    - `--rm`: Tự động xóa container ngay khi tiến trình bên trong kết thúc.
    - `--restart <policy>`: Chính sách tự động khởi động lại (`no`, `on-failure[:max-retries]`, `always`, `unless-stopped`).
    - `--memory`, `--cpus`: Giới hạn dung lượng RAM và số nhân CPU tối đa container được phép dùng.
- **Quản lý vòng đời và giám sát Container:**
  - `docker ps`: Xem danh sách các container đang chạy (`docker ps -a` để xem tất cả container kể cả đã dừng).
  - `docker stop <container>`: Gửi tín hiệu `SIGTERM` để dừng container an toàn (sau timeout sẽ gửi `SIGKILL`).
  - `docker start <container>`: Khởi động lại một container đã dừng.
  - `docker restart <container>`: Khởi động lại container.
  - `docker rm <container>`: Xóa container đã dừng (`docker rm -f` để cưỡng chế xóa container đang chạy).
  - `docker logs -f --tail 100 <container>`: Xem và theo dõi log thời gian thực của container.
  - `docker exec -it <container> sh`: Thực thi lệnh hoặc truy cập vào shell bên trong container đang chạy.
  - `docker inspect <container/image>`: Xem toàn bộ thông tin cấu hình chi tiết (IP, Mounts, Env, State) dưới dạng JSON.
  - `docker stats`: Theo dõi mức tiêu thụ tài nguyên (CPU, RAM, Net I/O, Block I/O) theo thời gian thực.
  - `docker cp <src> <dest>`: Sao chép file/thư mục qua lại giữa máy Host và Container.
  - `docker top <container>`: Xem danh sách các tiến trình đang chạy bên trong một container.
  - `docker diff <container>`: Kiểm tra các file/thư mục đã bị thêm (`A`), sửa (`C`), hoặc xóa (`D`) trên lớp Read-Write của container so với Image gốc.

---

## Phần 5: Docker Image và Dockerfile

### 13. Docker Image là gì?
- **Khái niệm Docker Image & Phân biệt với Container:**
  - **Docker Image** là một mẫu (template) bất biến ở chế độ Read-Only chứa các tập tin hệ thống, thư viện, mã nguồn ứng dụng và thông số cấu hình.
  - **Container** là một phiên bản thực thi sống (runtime instance) của Image. Một Image có thể khởi tạo ra hàng trăm Container độc lập cùng lúc.
- **Cấu trúc Image Layers (`docker history`):**
  - Image được cấu tạo từ nhiều lớp (layers) Read-Only xếp chồng lên nhau. Mỗi chỉ thị trong Dockerfile tạo ra một layer mới chỉ lưu phần thay đổi so với layer trước đó.
  - Kiểm tra lịch sử và kích thước từng layer của một Image:
    ```bash
    docker history nginx:alpine
    ```
- **Image Tag và Image Digest:**
  - **Image Tag:** Nhãn định danh phiên bản thân thiện với người dùng (ví dụ: `nginx:1.25.3-alpine`). Một tag có thể bị ghi đè để trỏ sang bản build mới.
  - **Image Digest:** Mã băm mật mã học `sha256` bất biến tính trên nội dung của Image (`nginx@sha256:4c0fda...`). Đảm bảo tính toàn vẹn tuyệt đối, không bao giờ thay đổi.
- **Docker Hub và Private Registry & Các lệnh thao tác:**
  - **Docker Hub:** Public Registry mặc định lớn nhất chứa các Official Images.
  - **Private Registry:** Kho lưu trữ nội bộ cho dự án riêng của doanh nghiệp (Harbor, Nexus, GitLab Registry, AWS ECR).
  - Các lệnh thao tác:
    - `docker pull <registry>/<user>/<repo>:<tag>`: Tải image về máy.
    - `docker tag <source_image>:<tag> <target_image>:<tag>`: Gắn nhãn mới cho một image.
    - `docker push <registry>/<user>/<repo>:<tag>`: Đẩy image lên Registry.
- **Quy tắc đặt tên và quản lý phiên bản Image:**
  - Áp dụng **Semantic Versioning (`MAJOR.MINOR.PATCH`**, ví dụ: `1.2.0`, `1.2.1-alpine`).
  - **Tránh dùng tag `:latest` trong môi trường Production:** Vì `:latest` không cố định phiên bản, gây khó khăn khi cần rollback và dễ làm môi trường giữa các lần deploy bị lệch nhau.
- **Lưu và nạp Image offline (`docker save`, `docker load`):**
  ```bash
  # Xuất Docker Image ra file nén .tar để chuyển sang máy không có Internet (Air-gapped)
  docker save -o my-app-v1.0.0.tar skyboy12/my-app:1.0.0

  # Nạp lại Docker Image từ file .tar
  docker load -i my-app-v1.0.0.tar
  ```

### 14. Xây dựng Docker Image bằng Dockerfile
- **Dockerfile là gì?**
  - Là một tập tin văn bản thuần chứa tập hợp các chỉ thị (instructions) theo thứ tự từ trên xuống dưới để Docker tự động hóa quá trình lắp ráp và xây dựng nên một Docker Image.
- **Các chỉ thị cơ bản trong Dockerfile:**

  | Chỉ thị | Chức năng | Lưu ý & Thực hành tốt |
  | :--- | :--- | :--- |
  | `FROM` | Khai báo Base Image nền tảng bắt đầu quá trình build | Luôn ghim phiên bản cụ thể (ví dụ `python:3.11-alpine`) |
  | `LABEL` | Thêm metadata (tác giả, phiên bản, mô tả) cho Image | Ví dụ: `LABEL maintainer="taind@example.com"` |
  | `ARG` | Khai báo biến chỉ tồn tại trong lúc `docker build` | Truyền qua `--build-arg VERSION=1.0` |
  | `ENV` | Khai báo biến môi trường tồn tại cả lúc build và khi container chạy | Dùng cho cấu hình runtime của ứng dụng |
  | `WORKDIR` | Thiết lập thư mục làm việc hiện tại cho các lệnh kế tiếp | Luôn dùng đường dẫn tuyệt đối (ví dụ `WORKDIR /app`) |
  | `COPY` | Sao chép file/thư mục từ Build Context vào trong Image | Ưu tiên dùng `COPY` thay vì `ADD` cho các file cục bộ |
  | `ADD` | Tương tự `COPY` nhưng hỗ trợ tự giải nén `.tar.*` và tải từ URL | Chỉ dùng khi cần tự động giải nén file lưu trữ `.tar.gz` |
  | `RUN` | Thực thi lệnh shell để cài đặt gói, biên dịch code và tạo layer mới | Gộp các lệnh liên quan bằng `&&` và xóa cache ngay trong cùng 1 lệnh `RUN` |
  | `VOLUME` | Tạo điểm gắn kết (mount point) cho dữ liệu bền vững | Đánh dấu thư mục chứa dữ liệu cần tách khỏi lớp OverlayFS |
  | `EXPOSE` | Khai báo cổng mạng mà container lắng nghe (mang tính tài liệu) | Không tự mở port trên host, vẫn cần `-p` khi chạy `docker run` |
  | `USER` | Chuyển đổi user/group thực thi các lệnh tiếp theo và khi chạy container | Luôn chuyển sang non-root user để bảo mật |
  | `HEALTHCHECK` | Định nghĩa lệnh kiểm tra sức khỏe định kỳ của container | Giúp Docker nhận biết ứng dụng bên trong còn phản hồi tốt không |
  | `ENTRYPOINT` | Định nghĩa chương trình thực thi chính cố định của container | Không bị ghi đè bởi các đối số truyền vào cuối lệnh `docker run` |
  | `CMD` | Cung cấp lệnh thực thi mặc định hoặc tham số mặc định cho `ENTRYPOINT` | Dễ dàng bị ghi đè khi truyền lệnh mới ở cuối `docker run` |

- **Xây dựng Image bằng `docker build` và sử dụng `.dockerignore`:**
  - Lệnh build: `docker build -t <image-name>:<tag> <build-context-path>`
  - File **`.dockerignore`**: Hoạt động tương tự `.gitignore`, giúp loại bỏ các thư mục nặng hoặc nhạy cảm (`.git`, `node_modules`, `__pycache__`, `.env`, `*.log`) khỏi quá trình gửi Build Context tới Docker Daemon, giúp tăng tốc độ build và bảo mật thông tin.
- **Phân biệt `CMD` và `ENTRYPOINT`; Exec form và Shell form:**
  - **`ENTRYPOINT` vs `CMD`:** `ENTRYPOINT` cố định chương trình chạy của container, còn `CMD` đóng vai trò cung cấp các tham số mặc định cho `ENTRYPOINT` (hoặc làm lệnh mặc định nếu không khai báo `ENTRYPOINT`).
  - **Exec form (`["executable", "param1", "param2"]` - Khuyến nghị):** Chạy trực tiếp chương trình thành `PID 1` bên trong container mà không qua shell trung gian, giúp ứng dụng nhận được tín hiệu dừng `SIGTERM` từ lệnh `docker stop`.
  - **Shell form (`executable param1 param2`):** Docker tự động bọc lệnh trong `/bin/sh -c "..."`, khiến `/bin/sh` chiếm `PID 1` và có thể không chuyển tiếp tín hiệu `SIGTERM` tới tiến trình con.
- **Multi-stage Build & Tối ưu kích thước Image / Build Cache:**
  - **Docker Build Cache:** Docker lưu cache cho từng layer. Cần đặt các chỉ thị ít thay đổi (như cài đặt thư viện từ `requirements.txt` hoặc `package.json`) lên trước, và đặt chỉ thị hay thay đổi (như `COPY . .` mã nguồn) xuống dưới để tận dụng tối đa cache.
  - **Multi-stage Build:** Sử dụng nhiều câu lệnh `FROM` trong cùng một Dockerfile. Stage đầu tiên (`builder`) dùng image đầy đủ bộ biên dịch (SDK, GCC, Maven, Node) để build ra artifact; Stage cuối cùng (`runner`) dùng image siêu nhẹ (Alpine, Distroless, Scratch) và chỉ dùng `COPY --from=builder` để lấy đúng file kết quả sang chạy, giảm kích thước image từ hàng trăm MB xuống chỉ còn vài chục MB.

### 15. Thực hành Build và Push Docker Image
- **Bước 1: Tạo ứng dụng Web đơn giản (`app.py` và `requirements.txt`):**
  ```python
  # File: app.py
  from http.server import HTTPServer, BaseHTTPRequestHandler
  import os

  class SimpleHandler(BaseHTTPRequestHandler):
      def do_GET(self):
          self.send_response(200)
          self.send_header('Content-type', 'text/html; charset=utf-8')
          self.end_headers()
          app_name = os.getenv("APP_NAME", "TYP Cloud Week 3")
          msg = f"<h1>Hello from Docker Container!</h1><p>Application: <b>{app_name}</b></p>"
          self.wfile.write(msg.encode('utf-8'))

  if __name__ == '__main__':
      server = HTTPServer(('0.0.0.0', 8080), SimpleHandler)
      print("Server listening on port 8080...")
      server.serve_forever()
  ```
- **Bước 2: Tạo file `.dockerignore`:**
  ```text
  .git
  __pycache__
  *.pyc
  *.md
  .env
  ```
- **Bước 3: Viết `Dockerfile` áp dụng Multi-stage Build và Non-root User:**
  ```dockerfile
  # Stage 1: Builder kiểm tra cú pháp và chuẩn bị mã nguồn
  FROM python:3.11-slim AS builder
  WORKDIR /build
  COPY app.py .
  RUN python -m py_compile app.py

  # Stage 2: Production Runtime siêu nhẹ với Alpine
  FROM python:3.11-alpine AS runner
  LABEL maintainer="Nguyen Duc Tai - B24DCCN510"

  # Tạo group và user không đặc quyền
  RUN addgroup -S appgroup && adduser -S appuser -G appgroup

  WORKDIR /app
  COPY --from=builder --chown=appuser:appgroup /build/app.py /app/app.py

  USER appuser
  ENV APP_NAME="Cloud-Training-Week3"
  EXPOSE 8080

  HEALTHCHECK --interval=30s --timeout=3s \
    CMD wget -qO- http://localhost:8080/ > /dev/null || exit 1

  CMD ["python", "app.py"]
  ```
- **Bước 4: Build, Chạy thử, Gắn Tag và Push lên Docker Hub:**
  ```bash
  # 1. Build Image
  docker build -t my-python-web:1.0.0 .

  # 2. Chạy thử Container và kiểm tra
  docker run -d --name web-test -p 8080:8080 my-python-web:1.0.0
  curl http://localhost:8080

  # 3. Gắn Tag theo tài khoản Docker Hub và Push lên Registry
  docker tag my-python-web:1.0.0 skyboy12/my-python-web:1.0.0
  docker login -u skyboy12
  docker push skyboy12/my-python-web:1.0.0

  # 4. Pull về và chạy thử
  docker pull skyboy12/my-python-web:1.0.0
  ```

---

## Phần 6: Kiến trúc và quản lý Docker

### 16. Kiến trúc Docker Engine
- **Mô hình Docker Client – Server:**
  ```text
  [Docker CLI] ---> (REST API qua /var/run/docker.sock) ---> [dockerd (Docker Daemon)]
                                                                     |
                                                                (gRPC API)
                                                                     v
                                                               [containerd]
                                                                     |
                                                          [containerd-shim]
                                                                     |
                                                                  [runc] ---> [Container (Namespaces + cgroups)]
  ```
- **Vai trò của từng thành phần:**
  1. **Docker CLI (`docker`) & Docker API:** Giao diện dòng lệnh tiếp nhận yêu cầu từ người dùng và gửi các HTTP REST API request tới Docker Daemon qua Unix socket (`/var/run/docker.sock`) hoặc qua mạng TCP.
  2. **Docker Daemon (`dockerd`):** Dịch vụ nền quản lý các đối tượng cấp cao như Images, Volumes, Networks, Build process và cấu hình chung thông qua file `/etc/docker/daemon.json`.
  3. **`containerd`:** High-level Container Runtime đạt chuẩn CNCF, được tách ra từ `dockerd` để chuyên trách quản lý toàn bộ vòng đời của container (tải image, quản lý storage snapshot, điều phối tạo/dừng container).
  4. **`containerd-shim`:** Tiến trình nhẹ đứng giữa `containerd` và mỗi container đang chạy. Nhờ có `shim` giữ các luồng `stdin/stdout` và báo cáo exit status, khi ta khởi động lại hoặc nâng cấp `dockerd`/`containerd`, các container đang chạy **không bị dừng theo** (Daemonless Containers).
  5. **`runc`:** Low-level OCI Container Runtime. `runc` trực tiếp giao tiếp với Linux Kernel để khởi tạo Namespaces, thiết lập cgroups và bật tiến trình ứng dụng bên trong container. Ngay sau khi container khởi chạy thành công, tiến trình `runc` sẽ tự thoát.
- **Quy trình từ khi gõ `docker run` đến khi Container hoạt động:**
  1. Người dùng gõ lệnh `docker run` trên **Docker CLI**.
  2. CLI chuyển lệnh thành REST API payload gửi tới **`dockerd`**.
  3. `dockerd` kiểm tra xem Image đã có trên local chưa (nếu chưa sẽ tải từ Registry về), sau đó gọi sang **`containerd`** qua gRPC.
  4. `containerd` chuẩn bị OCI runtime bundle từ các lớp của Image và khởi tạo một tiến trình **`containerd-shim`**.
  5. `containerd-shim` gọi **`runc`** để tạo lập môi trường cô lập (Namespaces, cgroups, Mounts) trên Linux Kernel và khởi chạy tiến trình chính của container.
  6. `runc` kết thúc, `containerd-shim` ở lại làm tiến trình cha giám sát container cho đến khi container dừng hẳn.

### 17. Docker Networking
- **Tổng quan về mạng trong Docker (`veth`, `docker0`, `iptables`):**
  - **`docker0`:** Khi cài đặt Docker, một Linux bridge ảo tên là `docker0` (mặc định dải `172.17.0.1/16`) được tạo ra trên máy Host, đóng vai trò như một Switch ảo nội bộ.
  - **`veth pair` (Virtual Ethernet Pair):** Mỗi khi một container khởi chạy ở chế độ Bridge, Docker tạo ra một cặp dây cáp mạng ảo nối liền hai không gian mạng: một đầu đặt trong Network Namespace của container (hiển thị là `eth0`), đầu kia gắn trực tiếp vào bridge `docker0` ngoài Host (hiển thị dạng `vethxxxx`).
  - **`iptables`:** Docker tự động thêm các quy tắc NAT (Network Address Translation / IP Masquerading) và Filter vào `iptables` của Host để cho phép container kết nối ra Internet và chuyển tiếp gói tin từ cổng của Host vào cổng của Container (Port Mapping `-p`).
- **Các loại Docker Network Driver:**

  | Network Driver | Cơ chế hoạt động | Trường hợp sử dụng |
  | :--- | :--- | :--- |
  | **Bridge** (Mặc định) | Tạo mạng ảo nội bộ trên một máy Host; các container cùng bridge có thể giao tiếp với nhau | Các ứng dụng chạy độc lập hoặc cụm dịch vụ trên cùng một máy chủ |
  | **Host** (`--network host`) | Xóa bỏ cách ly mạng; container dùng chung trực tiếp card mạng và IP của máy Host | Ứng dụng cần hiệu năng mạng tối đa, không muốn chịu độ trễ NAT |
  | **None** (`--network none`) | Tắt toàn bộ kết nối mạng của container (chỉ còn lại giao diện `lo` loopback) | Tác vụ xử lý dữ liệu offline, batch job yêu cầu cô lập mạng tuyệt đối |
  | **Overlay** | Tạo mạng ảo phủ xuyên qua nhiều máy chủ Docker vật lý khác nhau (dùng VXLAN) | Cụm phân tán nhiều node như Docker Swarm hoặc Kubernetes |
  | **Macvlan** | Gán trực tiếp một địa chỉ MAC riêng cho container; container xuất hiện như một thiết bị vật lý trên mạng LAN | Các ứng dụng hệ thống cần nhận IP trực tiếp từ Router vật lý của doanh nghiệp |

- **Phân biệt Default Bridge và User-defined Bridge (DNS & giao tiếp Container):**
  - **Default Bridge (`bridge`):** Các container chỉ có thể ping nhau qua địa chỉ IP (không tự phân giải tên container thành IP được).
  - **User-defined Bridge:** Cung cấp sẵn **Embedded DNS Server** (`127.0.0.11`) giúp tự động phân giải tên container (Service Discovery) thành địa chỉ IP nội bộ, đồng thời cô lập mạng tốt hơn và cho phép gắn/gỡ (`connect`/`disconnect`) mạng nóng khi container đang chạy.
- **Thực hành tạo Network và kết nối hai Container:**
  ```bash
  # 1. Tạo một User-defined Bridge Network
  docker network create --driver bridge app-net

  # 2. Kiểm tra danh sách và chi tiết network
  docker network ls
  docker network inspect app-net

  # 3. Chạy 2 container cùng gắn vào mạng app-net
  docker run -d --name redis-server --network app-net redis:alpine
  docker run -d --name client-box --network app-net alpine sleep 3600

  # 4. Kiểm tra phân giải DNS và kết nối trực tiếp bằng tên container
  docker exec -it client-box ping -c 3 redis-server
  ```

### 18. Docker Storage và Volume
- **Dữ liệu bên trong Container & Khái niệm Ephemeral Storage:**
  - Mặc định, mọi tệp tin được tạo ra hoặc chỉnh sửa bên trong container đều nằm trên lớp **Writable Layer (UpperDir)** gắn chặt với vòng đời của container đó.
  - Đây gọi là **Ephemeral Storage (Lưu trữ tạm thời)**: Khi container bị xóa (`docker rm`), toàn bộ dữ liệu trên lớp này sẽ bị xóa vĩnh viễn, và hiệu năng ghi qua UnionFS cũng chậm hơn ghi trực tiếp lên đĩa.
- **Phân biệt Docker Volume, Bind Mount và tmpfs Mount:**

  | Tiêu chí | Docker Volume | Bind Mount | tmpfs Mount |
  | :--- | :--- | :--- | :--- |
  | **Vị trí lưu trên Host** | Trong vùng do Docker quản lý (`/var/lib/docker/volumes/`) | Bất kỳ đường dẫn file/thư mục nào trên máy Host | Lưu trực tiếp trên bộ nhớ **RAM** của máy Host |
  | **Quyền quản lý** | Docker quản lý hoàn toàn, tách biệt khỏi cấu trúc thư mục Host | Phụ thuộc vào cấu trúc đường dẫn và phân quyền của OS Host | Tạm thời, mất ngay khi dừng container |
  | **Trường hợp sử dụng** | **Lưu dữ liệu bền vững cho Database (MySQL, PostgreSQL), Production** | **Mount mã nguồn khi phát triển (Live-reload), truyền file cấu hình từ Host** | Lưu dữ liệu nhạy cảm (secrets, token) hoặc cache tốc độ cao không muốn ghi xuống đĩa |

- **Các lệnh quản lý Docker Volume:**
  ```bash
  # Tạo mới, liệt kê, xem chi tiết và xóa Volume
  docker volume create mysql_data
  docker volume ls
  docker volume inspect mysql_data
  docker volume rm mysql_data
  docker volume prune -f
  ```
- **Backup và Restore Docker Volume:**
  ```bash
  # Backup dữ liệu trong volume mysql_data ra file nén backup.tar.gz ở thư mục hiện tại
  docker run --rm \
    -v mysql_data:/volume_data:ro \
    -v $(pwd):/backup \
    alpine tar -czvf /backup/mysql_backup.tar.gz -C /volume_data .

  # Restore dữ liệu từ file nén vào một volume mới
  docker run --rm \
    -v mysql_data_restored:/volume_data \
    -v $(pwd):/backup \
    alpine tar -xzvf /backup/mysql_backup.tar.gz -C /volume_data
  ```
- **Thực hành chạy MySQL Container với Docker Volume bền vững:**
  ```bash
  # 1. Tạo Volume lưu trữ dữ liệu cho MySQL
  docker volume create mysql_db_vol

  # 2. Khởi chạy MySQL Container gắn với Volume
  docker run -d \
    --name mysql-prod \
    -e MYSQL_ROOT_PASSWORD=RootPass123! \
    -e MYSQL_DATABASE=training_db \
    -v mysql_db_vol:/var/lib/mysql \
    -p 3306:3306 \
    mysql:8.0

  # 3. Tạo bảng và thêm dữ liệu mẫu
  docker exec -i mysql-prod mysql -uroot -pRootPass123! training_db << 'EOF'
  CREATE TABLE students (id INT AUTO_INCREMENT PRIMARY KEY, code VARCHAR(20), fullname VARCHAR(100));
  INSERT INTO students (code, fullname) VALUES ('B24DCCN510', 'Nguyen Duc Tai');
  EOF

  # 4. Xóa hẳn container mysql-prod và tạo container mới gắn lại Volume cũ
  docker rm -f mysql-prod
  docker run -d \
    --name mysql-recovered \
    -e MYSQL_ROOT_PASSWORD=RootPass123! \
    -v mysql_db_vol:/var/lib/mysql \
    mysql:8.0

  # 5. Kiểm tra dữ liệu vẫn còn nguyên vẹn
  docker exec -i mysql-recovered mysql -uroot -pRootPass123! training_db -e "SELECT * FROM students;"
  ```

---

## Phần 7: Docker Compose

### 19. Tổng quan về Docker Compose
- **Docker Compose là gì? Tại sao cần Docker Compose?**
  - **Docker Compose** là công cụ giúp định nghĩa, cấu hình và vận hành các ứng dụng Docker đa container (Multi-container Applications) thông qua một tập tin khai báo YAML duy nhất.
  - Thay vì phải chạy rời rạc hàng loạt câu lệnh `docker network create`, `docker volume create`, `docker run` dài dòng và dễ nhầm lẫn thứ tự, Docker Compose cho phép khởi tạo hoặc dọn dẹp toàn bộ kiến trúc hệ thống (Frontend, Backend, Database, Cache) chỉ bằng một lệnh duy nhất.
- **Phân biệt Docker CLI và Docker Compose:**
  - **Docker CLI (`docker run`, `docker build`):** Thao tác mệnh lệnh (Imperative) trên từng container đơn lẻ.
  - **Docker Compose (`docker compose`):** Quản lý theo hướng khai báo (Declarative) cho cả một cụm nhiều dịch vụ liên kết với nhau trong một dự án.
- **Docker Compose V2 và cú pháp `docker compose`:**
  - **Compose V1 (`docker-compose` - có gạch ngang):** Công cụ độc lập viết bằng Python (hiện đã ngừng hỗ trợ).
  - **Compose V2 (`docker compose` - có dấu cách):** Được viết bằng Go, tích hợp trực tiếp làm plugin chuẩn của Docker CLI, tốc độ nhanh hơn và không còn bắt buộc khai báo trường `version:` ở đầu file cấu hình.
- **Cấu trúc file `compose.yaml` và 3 thành phần chính:**
  - Tên file chuẩn theo Compose Specification: `compose.yaml` (hoặc `docker-compose.yml`).
  - **3 khối thành phần chính:**
    1. **`services`:** Định nghĩa các container ứng dụng sẽ chạy (image, build, ports, environment, depends_on...).
    2. **`networks`:** Định nghĩa các mạng ảo nội bộ để các service giao tiếp với nhau.
    3. **`volumes`:** Định nghĩa các vùng lưu trữ bền vững dùng cho các service.

### 20. Viết và quản lý Docker Compose
- **Cấu trúc khai báo các thành phần trong `compose.yaml`:**
  - **`image` / `build`:** Chỉ định image có sẵn từ Registry hoặc đường dẫn chứa `Dockerfile` để tự build.
  - **`ports`:** Ánh xạ cổng `"<host_port>:<container_port>"`.
  - **`environment` & `env_file` (`.env`):** Truyền biến môi trường trực tiếp hoặc tự động đọc từ file `.env` nằm cùng thư mục để tách biệt thông tin nhạy cảm khỏi file cấu hình.
  - **`volumes` & `networks`:** Gắn kết thư mục/volume và kết nối service vào các mạng định sẵn.
  - **`depends_on` kết hợp `healthcheck`:**
    Mặc định `depends_on` chỉ đợi container phụ thuộc chuyển sang trạng thái `Running`, chứ chưa chắc ứng dụng bên trong (như MySQL) đã khởi tạo xong socket để nhận kết nối. Kết hợp `healthcheck` với `condition: service_healthy` giúp giải quyết triệt để vấn đề này:
    ```yaml
    services:
      db:
        image: mysql:8.0
        healthcheck:
          test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
          interval: 5s
          timeout: 3s
          retries: 10
      web:
        build: .
        depends_on:
          db:
            condition: service_healthy
    ```
- **Các lệnh quản lý Docker Compose thông dụng:**
  - `docker compose up -d`: Khởi tạo network, volume và chạy toàn bộ các service ở chế độ nền (thêm `--build` nếu muốn ép build lại image).
  - `docker compose down`: Dừng và xóa toàn bộ containers, networks của dự án (thêm `-v` nếu muốn xóa luôn cả các Named Volumes).
  - `docker compose ps`: Xem danh sách và trạng thái sức khỏe (Health) của các service trong dự án.
  - `docker compose logs -f [service]`: Theo dõi log thời gian thực của toàn bộ cụm hoặc một service cụ thể.
  - `docker compose exec <service> <cmd>`: Thực thi lệnh bên trong container của một service đang chạy (ví dụ: `docker compose exec web sh`).
  - `docker compose build`: Chỉ thực hiện build lại các image được khai báo mục `build:` trong file Compose.
  - `docker compose config`: Kiểm tra cú pháp YAML và in ra bản cấu hình hoàn chỉnh sau khi đã nội suy biến từ file `.env`.
  - `docker compose stop` / `start` / `restart`: Dừng, bật hoặc khởi động lại các service mà không xóa container.
- **Mở rộng với `--scale` và `compose.override.yaml`:**
  - **Nhân bản số lượng container của một service:**
    ```bash
    docker compose up -d --scale web=3
    ```
    *(Lưu ý: Không gắn cứng `container_name` và không cố định một port duy nhất trên Host cho service cần scale).*
  - **File `compose.override.yaml`:** Docker Compose tự động gộp `compose.yaml` (cấu hình gốc) với `compose.override.yaml` (cấu hình ghi đè dành riêng cho môi trường Dev như mở thêm port debug, gắn bind mount mã nguồn) mà không cần sửa file gốc.

### 21. Thực hành triển khai ứng dụng bằng Docker Compose
Triển khai hệ thống gồm **Web Application (Python Flask)** kết nối tới **MySQL Database** sử dụng Volume bền vững, mạng nội bộ riêng và kiểm tra sức khỏe tự động.

- **Cấu trúc thư mục dự án:**
  ```text
  webapp-compose/
  ├── app.py
  ├── requirements.txt
  ├── Dockerfile
  ├── .env
  └── compose.yaml
  ```
- **1. Mã nguồn Web Application (`app.py`) và `requirements.txt`:**
  ```text
  # File: requirements.txt
  flask==3.0.0
  mysql-connector-python==8.3.0
  ```
  ```python
  # File: app.py
  import os
  from flask import Flask
  import mysql.connector

  app = Flask(__name__)

  @app.route("/")
  def index():
      try:
          conn = mysql.connector.connect(
              host=os.getenv("DB_HOST", "db"),
              user=os.getenv("DB_USER", "appuser"),
              password=os.getenv("DB_PASSWORD", ""),
              database=os.getenv("DB_NAME", "appdb")
          )
          cursor = conn.cursor()
          cursor.execute("SELECT VERSION();")
          db_version = cursor.fetchone()[0]
          cursor.close()
          conn.close()
          return f"<h2>Ket noi MySQL thanh cong!</h2><p>MySQL Version: <b>{db_version}</b></p>"
      except Exception as e:
          return f"<h2>Loi ket noi Database:</h2><pre>{str(e)}</pre>", 500

  if __name__ == "__main__":
      app.run(host="0.0.0.0", port=5000)
  ```
- **2. Tạo `Dockerfile` cho Web Application:**
  ```dockerfile
  FROM python:3.11-alpine
  RUN addgroup -S appgroup && adduser -S appuser -G appgroup
  WORKDIR /app
  COPY requirements.txt .
  RUN pip install --no-cache-dir -r requirements.txt
  COPY --chown=appuser:appgroup app.py .
  USER appuser
  EXPOSE 5000
  CMD ["python", "app.py"]
  ```
- **3. Tạo file biến môi trường (`.env`):**
  ```env
  DB_ROOT_PASSWORD=RootSecretPassword2026!
  DB_NAME=training_app_db
  DB_USER=taind_user
  DB_PASSWORD=UserSecretPassword2026!
  WEB_HOST_PORT=8080
  ```
- **4. Viết file `compose.yaml`:**
  ```yaml
  services:
    db:
      image: mysql:8.0
      container_name: mysql_db_service
      restart: unless-stopped
      environment:
        MYSQL_ROOT_PASSWORD: ${DB_ROOT_PASSWORD}
        MYSQL_DATABASE: ${DB_NAME}
        MYSQL_USER: ${DB_USER}
        MYSQL_PASSWORD: ${DB_PASSWORD}
      volumes:
        - db_data:/var/lib/mysql
      networks:
        - app_backend_net
      healthcheck:
        test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${DB_ROOT_PASSWORD}"]
        interval: 5s
        timeout: 3s
        retries: 10

    web:
      build: .
      image: taind/flask-mysql-web:1.0.0
      container_name: flask_web_service
      restart: unless-stopped
      ports:
        - "${WEB_HOST_PORT}:5000"
      environment:
        DB_HOST: db
        DB_NAME: ${DB_NAME}
        DB_USER: ${DB_USER}
        DB_PASSWORD: ${DB_PASSWORD}
      networks:
        - app_backend_net
      depends_on:
        db:
          condition: service_healthy

  volumes:
    db_data:
      name: week3_mysql_data

  networks:
    app_backend_net:
      name: week3_backend_net
      driver: bridge
  ```
- **5. Khởi động, kiểm tra Log và vận hành ứng dụng:**
  ```bash
  # Kiểm tra cấu hình hợp lệ
  docker compose config

  # Build và khởi chạy toàn bộ hệ thống ở chế độ nền
  docker compose up -d --build

  # Kiểm tra trạng thái các container (db ở trạng thái healthy, web ở trạng thái running)
  docker compose ps

  # Xem log quá trình khởi tạo của Database và Web
  docker compose logs -f

  # Kiểm tra kết quả phản hồi từ Web Application (kết nối tới MySQL)
  curl http://localhost:8080

  # Dừng hệ thống và khởi chạy lại để kiểm tra tính bền vững của Volume
  docker compose down
  docker compose up -d
  ```

---

## Phần 8: Mô phỏng & Thực hành chi tiết

- Chi tiết các bước thực hành vận hành, kịch bản kiểm tra tính bền vững của Volume và câu lệnh chi tiết: **[Mô phỏng thực hành Docker Compose](Simulation.md)**

