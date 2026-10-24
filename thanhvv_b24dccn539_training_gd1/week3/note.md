# BÁO CÁO KỸ THUẬT TOÀN DIỆN — TUẦN 3: ẢO HÓA, CONTAINER, DOCKER VÀ DOCKER COMPOSE

---

## PHẦN 1: TỔNG QUAN VỀ ẢO HÓA (VIRTUALIZATION OVERVIEW)

### 1. Ảo hóa là gì?

#### Khái niệm ảo hóa
**Ảo hóa (Virtualization)** là công nghệ tạo ra một lớp trừu tượng hóa (abstraction layer) nằm giữa phần cứng vật lý (CPU, RAM, Storage, Network) và các hệ điều hành/ứng dụng chạy phía trên. Thông qua lớp phần mềm điều phối gọi là **Hypervisor (Virtual Machine Monitor - VMM)**, tài nguyên của một máy chủ vật lý duy nhất được phân tách logic thành nhiều môi trường thực thi độc lập gọi là **Máy ảo (Virtual Machines - VMs)**.

#### Mục đích và vai trò của ảo hóa trong hệ thống CNTT
* **Tối ưu hóa chi phí và hiệu suất phần cứng (Server Consolidation):** Giảm chi phí đầu tư ban đầu (CapEx) và chi phí vận hành (OpEx), nâng mức sử dụng tài nguyên máy chủ từ 10–15% lên 70–85%.
* **Giảm thiểu hoặc loại bỏ thời gian gián đoạn dịch vụ (Minimized/Eliminated Downtime):** Hỗ trợ di chuyển nóng máy ảo giữa các máy chủ vật lý mà không làm ngắt kết nối của người dùng.
* **Tăng năng suất, tính linh hoạt và tốc độ đáp ứng (Productivity & Agility):** Cấp phát nhanh chóng tài nguyên và triển khai ứng dụng chỉ trong vài phút thông qua Template/Clone.
* **Đảm bảo tính liên tục trong kinh doanh và phục hồi thảm họa (Business Continuity & Disaster Recovery):** Dễ dàng đóng gói, sao lưu (Backup) và khôi phục (Restore) toàn bộ hệ thống máy chủ.
* **Đơn giản hóa quản trị và hướng tới SDDC:** Chuẩn hóa việc vận hành trung tâm dữ liệu và tạo nền tảng cho Trung tâm dữ liệu định nghĩa bằng phần mềm (Software-Defined Data Center - SDDC).

#### Phân biệt Physical Machine và Virtual Machine

| Tiêu chí | Physical Machine (Máy chủ vật lý / Bare-metal) | Virtual Machine (Máy ảo - VM) |
| :--- | :--- | :--- |
| **Bản chất kiến trúc** | Phần cứng hữu hình (Bo mạch chủ, chip CPU, thanh RAM, ổ cứng vật lý). | Thực thể phần mềm mô phỏng kiến trúc máy tính; tồn tại dưới dạng tiến trình và các tệp tin. |
| **Tương tác phần cứng** | Hệ điều hành (OS) quản lý và giao tiếp trực tiếp với phần cứng qua Device Drivers. | Guest OS giao tiếp với phần cứng ảo hóa thông qua sự điều phối của Hypervisor. |
| **Cô lập và Chia sẻ** | Một OS chiếm dụng độc quyền toàn bộ tài nguyên máy vật lý. | Nhiều VM cùng chia sẻ tài nguyên một máy vật lý nhưng cô lập hoàn toàn không gian bộ nhớ. |
| **Khả năng mở rộng (Scaling)** | Phụ thuộc khe cắm vật lý; thường phải tắt máy (Downtime) để nâng cấp phần cứng. | Linh hoạt; hỗ trợ cấp phát động hoặc thêm nóng (Hot-add/Hot-plug) vCPU, RAM, Disk. |
| **Tính di động (Portability)** | Rất thấp; phụ thuộc chặt vào trình điều khiển (Driver) phần cứng cụ thể. | Rất cao; độc lập phần cứng nền tảng, dễ dàng di chuyển (Migrate) giữa các Host khác nhau. |

---

### 2. Các loại ảo hóa phổ biến

#### 4 loại hình ảo hóa hạ tầng cốt lõi
1. **Ảo hóa máy chủ (Server Virtualization):** Phân chia một máy chủ vật lý thành nhiều máy chủ ảo độc lập, mỗi VM chạy một hệ điều hành riêng biệt (Guest OS).
2. **Ảo hóa hệ điều hành (OS-level Virtualization / Containerization):** Ảo hóa ngay tại tầng nhân Hệ điều hành. Các thực thể (Containers) dùng chung Kernel của Host OS nhưng được cô lập không gian người dùng qua *Namespaces* và giới hạn tài nguyên qua *cgroups*.
3. **Ảo hóa lưu trữ (Storage Virtualization):** Gom cụm (pooling) nhiều thiết bị lưu trữ vật lý phân tán (ổ cứng cục bộ, SAN, NAS, iSCSI, Fibre Channel) thành một không gian lưu trữ logic thống nhất (Storage Pool / Datastore) như LVM, Ceph, VMware vSAN.
4. **Ảo hóa mạng (Network Virtualization - SDN):** Tách biệt các chức năng mạng (Switching, Routing, Firewall, Load Balancing) khỏi thiết bị phần cứng và tái tạo bằng phần mềm (Linux Bridge, Open vSwitch, mạng phủ VXLAN/Geneve/OVN).

#### Phân biệt Full Virtualization, Para-Virtualization và Hardware-Assisted Virtualization

| Mô hình ảo hóa | Cơ chế hoạt động tại tầng Kernel & CPU | Ưu điểm | Nhược điểm |
| :--- | :--- | :--- | :--- |
| **Full Virtualization (Ảo hóa hoàn toàn bằng phần mềm)** | Guest OS không biết mình đang bị ảo hóa. Hypervisor sử dụng kỹ thuật **Binary Translation (Dịch mã nhị phân động)** để bắt (trap) và dịch các tập lệnh đặc quyền của Guest OS sang lệnh an toàn trên phần cứng. | Không cần chỉnh sửa mã nguồn Guest OS (chạy được cả Windows và các OS đóng). | Hao hụt hiệu năng (CPU Overhead) lớn do quá trình dịch mã nhị phân thời gian thực. |
| **Para-Virtualization (Bán ảo hóa)** | Mã nguồn của Guest OS được **sửa đổi trực tiếp** để nhận thức sự tồn tại của Hypervisor. Thay vì phát lệnh nhạy cảm gây trap, Guest OS gọi trực tiếp **Hypercalls** xuống Hypervisor hoặc dùng driver `virtio`. | Hiệu năng rất cao, độ trễ thấp, đặc biệt tối ưu cho tác vụ I/O (Disk, Network). | Đòi hỏi phải sửa đổi nhân Guest OS hoặc cài đặt trình điều khiển chuyên biệt. |
| **Hardware-Assisted Virtualization (Ảo hóa hỗ trợ bởi phần cứng)** | Sử dụng tập lệnh mở rộng trên chip CPU (**Intel VT-x** / **AMD-V**), bổ sung 2 chế độ phần cứng: **VMX Root Mode** (cho Hypervisor) và **VMX Non-Root Mode** (cho Guest OS). Các lệnh nhạy cảm tự động kích hoạt chuyển ngữ cảnh phần cứng (**VM Exit**). | Không cần sửa Guest OS, loại bỏ gánh nặng Binary Translation, hiệu năng tiệm cận máy vật lý. | Yêu cầu CPU vật lý và BIOS/UEFI phải hỗ trợ và bật tính năng ảo hóa. |

#### Kiểm tra CPU hỗ trợ ảo hóa (Intel VT-x, AMD-V)
Trên Linux, cờ báo hiệu hỗ trợ ảo hóa phần cứng trong `/proc/cpuinfo` là **`vmx`** (Intel VT-x) hoặc **`svm`** (AMD-V):

```bash
# Kiểm tra số luồng CPU có cờ vmx hoặc svm (Kết quả > 0 là hỗ trợ)
egrep -c '(vmx|svm)' /proc/cpuinfo

# Kiểm tra thông tin ảo hóa qua lscpu
lscpu | grep -i virtualization

# Kiểm tra thiết bị /dev/kvm bằng công cụ cpu-checker
sudo apt update && sudo apt install -y cpu-checker
kvm-ok
```

---

### 3. Hypervisor và các công nghệ ảo hóa

#### Hypervisor là gì? Vai trò của Hypervisor
**Hypervisor (Virtual Machine Monitor - VMM)** là lớp phần mềm, firmware hoặc phần cứng chuyên trách việc khởi tạo, điều phối và giám sát các máy ảo.
* **Vai trò:** Trừu tượng hóa phần cứng; lập lịch vCPU, ánh xạ bộ nhớ vRAM và định tuyến I/O; đảm bảo ranh giới cô lập bảo mật tuyệt đối giữa các VM; quản lý vòng đời máy ảo (Start, Stop, Snapshot, Live Migration).

#### Phân biệt Hypervisor Type 1 và Type 2

| Tiêu chí | Hypervisor Type 1 (Bare-metal / Native) | Hypervisor Type 2 (Hosted) |
| :--- | :--- | :--- |
| **Vị trí cài đặt** | Cài đặt trực tiếp lên phần cứng máy chủ vật lý, không qua hệ điều hành trung gian. | Chạy như một ứng dụng phần mềm bên trên một hệ điều hành chủ (Host OS: Windows, macOS, Desktop Linux). |
| **Hiệu năng & Độ trễ** | **Tối đa**; truy cập trực tiếp phần cứng và lập lịch tài nguyên sát nhân. | **Thấp hơn**; mọi yêu cầu I/O và lập lịch phải đi qua tầng quản lý của Host OS. |
| **Độ ổn định & Bảo mật** | Rất cao; bề mặt tấn công nhỏ, không phụ thuộc tiến trình người dùng ngoại lai. | Phụ thuộc trực tiếp vào độ ổn định và bảo mật của Host OS nền tảng. |
| **Môi trường sử dụng** | Trung tâm dữ liệu (Data Center), Cloud Computing, Enterprise Production. | Máy tính cá nhân, môi trường học tập, nghiên cứu, kiểm thử (Dev/Test). |
| **Đại diện tiêu biểu** | VMware ESXi, KVM, Microsoft Hyper-V, Xen, Proxmox VE. | Oracle VirtualBox, VMware Workstation / Player, Parallels Desktop. |

#### Các công nghệ ảo hóa phổ biến
* **VMware ESXi:** Hypervisor Type 1 thương mại hàng đầu thuộc bộ giải pháp VMware vSphere, sử dụng nhân *VMkernel* độc quyền, mạnh mẽ với vCenter, vMotion, DRS và vSphere HA.
* **KVM (Kernel-based Virtual Machine):** Mô-đun tích hợp sẵn trong nhân Linux chính thống (Mainline Kernel), biến Linux thành Hypervisor Type 1; là trái tim của OpenStack, AWS Nitro, Google Cloud.
* **Microsoft Hyper-V:** Hypervisor Type 1 kiến trúc Microkernel tích hợp trong Windows Server và Windows Pro/Enterprise.
* **Xen Project:** Hypervisor Type 1 mã nguồn mở kiến trúc Microkernel, nổi tiếng với khả năng Para-Virtualization.
* **Proxmox VE:** Nền tảng quản trị ảo hóa mã nguồn mở dựa trên Debian, tích hợp đồng thời **KVM** (VM) và **LXC** (Linux Containers) cùng Web GUI, Ceph và HA.
* **Oracle VirtualBox:** Hypervisor Type 2 mã nguồn mở đa nền tảng phổ biến nhất cho máy trạm cá nhân.

---

## PHẦN 2: VIRTUAL MACHINE (MÁY ẢO)

### 4. Tổng quan về Virtual Machine

#### Khái niệm và Kiến trúc của một máy ảo
**Virtual Machine (VM)** là một môi trường máy tính hoàn chỉnh được định nghĩa bằng phần mềm, sở hữu BIOS/UEFI ảo, vCPU, vRAM, ổ đĩa ảo và card mạng ảo riêng.
* **Cấu trúc lưu trữ:** Gồm tệp cấu hình định nghĩa phần cứng (`.xml` trong libvirt, `.vmx` trong VMware) và các tệp ảnh đĩa chứa hệ điều hành/dữ liệu (`.qcow2`, `.vmdk`, `.vdi`).
* **Cấu trúc thực thi (trên KVM/QEMU):** Mỗi VM đang chạy là một tiến trình User-space (`qemu-system-x86_64`), trong đó mỗi vCPU là một luồng thực thi (POSIX Thread).

#### Phân biệt Host OS và Guest OS
* **Host OS (Hệ điều hành chủ):** Hệ điều hành cài đặt trực tiếp trên máy chủ vật lý, quản lý trình điều khiển phần cứng gốc và cung cấp nền tảng cho Hypervisor.
* **Guest OS (Hệ điều hành khách):** Hệ điều hành chạy bên trong không gian của một máy ảo, hoàn toàn độc lập với Host OS.

#### Các thành phần được ảo hóa
* **CPU (vCPU):** Đơn vị xử lý ảo được Hypervisor lập lịch thực thi trên các nhân/luồng CPU vật lý (pCPU).
* **Memory (vRAM):** Không gian bộ nhớ RAM liên tục mà Guest OS nhìn thấy, được ánh xạ từ RAM vật lý của Host.
* **Disk (Virtual Disk):**
  * **Định dạng đĩa ảo:**
    * **`qcow2` (QEMU Copy-On-Write v2):** Định dạng chuẩn của KVM/QEMU; hỗ trợ Thin Provisioning, Snapshot nội tại đa tầng, nén và mã hóa.
    * **`vmdk` (Virtual Machine Disk):** Định dạng chuẩn của VMware ESXi / Workstation.
    * **`vdi` (Virtual Disk Image):** Định dạng chuẩn của Oracle VirtualBox.
  * **Thin Provisioning vs. Thick Provisioning:**
    * **Thick Provisioning:** Cấp phát và chiếm giữ ngay 100% dung lượng vật lý trên ổ cứng ngay khi khởi tạo (VD: tạo đĩa 50GB lập tức tốn 50GB thật). Cho hiệu năng I/O ổn định, không bị phân mảnh.
    * **Thin Provisioning:** Cấp phát động theo nhu cầu. Khai báo 50GB nhưng chỉ chiếm dụng dung lượng thật đúng bằng lượng dữ liệu thực tế đang ghi trong VM. Tiết kiệm ổ cứng nhưng cần giám sát để tránh tràn ổ đĩa vật lý.
* **Network Interface (vNIC):**
  * **NAT (Network Address Translation):** VM nằm trong mạng nội bộ riêng (VD: `192.168.122.0/24` trên `virbr0`). Ra được Internet nhờ cơ chế SNAT qua IP của Host, nhưng các máy ngoài mạng LAN không thể kết nối trực tiếp vào VM (trừ khi mở Port Forwarding).
  * **Bridged:** Đấu nối trực tiếp vNIC của VM vào Switch ảo (Linux Bridge `br0`) gắn với card mạng vật lý của Host. VM nhận IP cùng dải mạng LAN vật lý và giao tiếp ngang hàng như một máy tính độc lập trên mạng.
  * **Host-only:** Mạng cô lập hoàn toàn với bên ngoài; chỉ cho phép các VM giao tiếp với nhau và giao tiếp với máy Host.

#### Cơ chế chia sẻ tài nguyên giữa các VM trên cùng máy vật lý
* **Overcommit:** Cấp phát tổng lượng vCPU hoặc vRAM của các VM vượt quá dung lượng phần cứng vật lý thực tế của Host, tận dụng việc các VM hiếm khi đạt đỉnh tải (Peak load) cùng lúc. Hỗ trợ bởi *Memory Ballooning*, *Kernel Same-page Merging (KSM)* và *Swap*.
* **Reservation (Mức cam kết tối thiểu):** Lượng tài nguyên vật lý (CPU MHz hoặc RAM MB) được giữ chỗ độc quyền cho VM, đảm bảo VM luôn có đủ lượng tài nguyên này ngay cả khi Host bị quá tải.
* **Limit (Ngưỡng trần tối đa):** Mức tài nguyên vật lý tối đa mà VM không bao giờ được phép vượt qua, kể cả khi Host đang rảnh rỗi.
* **Shares (Trọng số ưu tiên tương đối):** Tỷ lệ chia sẻ tài nguyên (VD: High:Normal:Low = 4:2:1) chỉ có tác dụng khi máy chủ vật lý xảy ra **tranh chấp tài nguyên (Resource Contention)**.

---

### 5. Cơ chế hoạt động của máy ảo

#### Nguyên lý hoạt động và Hardware-Assisted Virtualization (Root Mode, Non-Root Mode, VM Exit, VM Entry)
Nhờ tập lệnh phần cứng **Intel VT-x / AMD-V**, CPU duy trì một cấu trúc dữ liệu điều khiển trong bộ nhớ gọi là **VMCS (Virtual Machine Control Structure)** và hoạt động ở hai chế độ:
* **VMX Root Mode:** Chế độ đặc quyền tối đa nơi Hypervisor (KVM) vận hành và có toàn quyền truy cập phần cứng.
* **VMX Non-Root Mode:** Chế độ giới hạn nơi Guest OS hoạt động (vẫn có đầy đủ Ring 0–3 bên trong Non-Root Mode để chạy OS nguyên bản).
* **VM Entry (`VMLAUNCH` / `VMRESUME`):** Quá trình Hypervisor nạp trạng thái Guest từ VMCS và chuyển CPU từ *Root Mode* sang *Non-Root Mode* để thực thi trực tiếp mã lệnh của VM trên nhân CPU vật lý.
* **VM Exit:** Khi Guest OS thực thi một lệnh nhạy cảm (I/O, truy cập thanh ghi điều khiển, ngắt phần cứng, hoặc lỗi trang nhớ EPT Violation), CPU tự động đình chỉ Guest, lưu trạng thái vào VMCS và chuyển quyền điều khiển về *Root Mode* cho Hypervisor xử lý. Sau khi xử lý xong, Hypervisor gọi lại *VM Entry*.

#### Ảo hóa CPU: Lập lịch vCPU lên core vật lý
Mỗi vCPU của máy ảo tương ứng với một luồng thực thi (**POSIX Thread**) trong không gian tiến trình Host. Bộ lập lịch của nhân Linux (**CFS / EEVDF**) chia thời gian thực thi (Time-slicing) của các luồng vCPU này lên các nhân CPU vật lý (pCPU), hoặc gắn cố định từng vCPU vào từng pCPU riêng biệt thông qua kỹ thuật **CPU Pinning (vCPU Affinity)**.

#### Ảo hóa bộ nhớ: Dịch địa chỉ đa tầng và EPT/NPT
Truy xuất bộ nhớ trong máy ảo đi qua chuỗi dịch địa chỉ 2 chiều (Two-Dimensional Page Walk):

$$\text{Guest Virtual Address (GVA)} \xrightarrow{\text{Guest Page Tables}} \text{Guest Physical Address (GPA)} \xrightarrow{\text{EPT / NPT}} \text{Host Physical Address (HPA)}$$

* **GVA -> GPA:** Do bảng phân trang bên trong Guest OS quản lý.
* **GPA -> HPA:** Thay vì dùng *Shadow Page Tables* bằng phần mềm gây tốn kém *VM Exit*, công nghệ phần cứng **SLAT (Second Level Address Translation)** gồm **Intel EPT (Extended Page Tables)** và **AMD NPT (Nested Page Tables)** cho phép bộ quản lý bộ nhớ (MMU) trên chip CPU tự động dịch thẳng từ GPA sang HPA ngay ở tầng phần cứng.

#### Ảo hóa I/O: Emulation, Para-virtualization (`virtio`), PCI Passthrough, SR-IOV
1. **Emulation (Mô phỏng phần mềm):** QEMU giả lập các thiết bị phần cứng truyền thống (card mạng Intel e1000, ổ cứng IDE/SATA). Tương thích mọi OS nhưng gây ra rất nhiều *VM Exit* (Trap-and-Emulate), tốc độ chậm.
2. **Para-virtualization (`virtio`):** Chuẩn ảo hóa I/O hiệu năng cao. Guest OS cài driver `virtio-net`, `virtio-blk` để truyền dữ liệu trực tiếp qua hàng đợi vòng trên bộ nhớ chia sẻ (**Virtqueues / Ring Buffers**) với backend trong Kernel (`vhost-net`), giảm thiểu tối đa *VM Exit*.
3. **PCI Passthrough:** Sử dụng **IOMMU (Intel VT-d / AMD-Vi)** để gán độc quyền và trực tiếp một thiết bị PCIe vật lý (GPU, NIC, NVMe) vào thẳng không gian địa chỉ của một VM, bỏ qua hoàn toàn Hypervisor.
4. **SR-IOV (Single Root I/O Virtualization):** Một thiết bị PCIe vật lý (**PF - Physical Function**) tự phân tách ở tầng phần cứng thành nhiều thiết bị PCIe ảo nhẹ (**VF - Virtual Functions**) để gán trực tiếp cho nhiều VM cùng chia sẻ tốc độ phần cứng gốc (Line-rate) với độ trễ cực thấp.

#### Mô hình KVM + QEMU + libvirt
* **KVM (`/dev/kvm` - Kernel Space):** Mô-đun nhân Linux chịu trách nhiệm ảo hóa CPU (VT-x/AMD-V) và Memory (EPT/NPT).
* **QEMU (User Space):** Tiến trình không gian người dùng cấp phát RAM cho VM, mô phỏng bo mạch chủ, BIOS/UEFI và các thiết bị I/O ngoại vi, đồng thời gọi `ioctl()` xuống `/dev/kvm`.
* **libvirt (`libvirtd` - Management Layer):** Thư viện và daemon quản trị chuẩn hóa cấu hình VM qua tệp XML, cung cấp API thống nhất cho `virsh`, `virt-manager`, Cockpit và OpenStack Nova.

---

### 6. Vòng đời và quản lý VM

* **Các trạng thái của VM:**
  * **Created / Defined (Stopped / Shut off):** Đã đăng ký file cấu hình XML và tạo ổ đĩa nhưng chưa khởi chạy; không tiêu tốn RAM/CPU.
  * **Running:** Máy ảo đang hoạt động, chiếm dụng RAM và lập lịch vCPU trên Host.
  * **Paused (Suspended):** Đóng băng tạm thời các luồng vCPU nhưng vẫn giữ nguyên dữ liệu của VM trên RAM vật lý.
  * **Saved:** Lưu toàn bộ trạng thái RAM xuống ổ đĩa cứng và tắt tiến trình VM để giải phóng RAM vật lý.
* **Tạo, khởi động, tắt và xóa máy ảo:** Khởi tạo bằng `virt-install`; bật bằng `virsh start`; tắt an toàn qua tín hiệu ACPI bằng `virsh shutdown`; ngắt nguồn cưỡng bức bằng `virsh destroy`; xóa bỏ bằng `virsh undefine --remove-all-storage`.
* **Cấp phát và điều chỉnh CPU, RAM, Disk:** Thay đổi thông số trong cấu hình XML hoặc dùng lệnh `virsh setvcpus`, `virsh setmem`, `qemu-img resize` (hỗ trợ cả Cold-resize khi tắt máy và Hot-plug khi đang chạy).
* **Snapshot, Clone và Template:**
  * **Snapshot:** Lưu trạng thái điểm thời gian (Point-in-time) theo cơ chế Copy-On-Write để Revert nhanh khi cập nhật lỗi.
  * **Clone:** Nhân bản ra máy ảo mới hoàn toàn độc lập về tên, UUID và địa chỉ MAC.
  * **Template:** Máy ảo mẫu đã cài đặt chuẩn và xóa sạch thông tin định danh riêng (`virt-sysprep`) để làm khuôn đúc hàng loạt VM mới.
* **Backup và Restore máy ảo:** Sao lưu độc lập toàn bộ file cấu hình XML và toàn bộ file ảnh đĩa (`.qcow2`) hoặc xuất ra gói `.ova` sang thiết bị lưu trữ ngoài để khôi phục khi thảm họa xảy ra.
* **Live Migration và High Availability (HA):**
  * **Live Migration:** Di chuyển máy ảo đang chạy từ Host vật lý này sang Host vật lý khác qua mạng (đồng bộ các trang nhớ RAM - Pre-copy memory migration) mà không gây gián đoạn dịch vụ (Zero Downtime).
  * **High Availability (HA):** Cơ chế giám sát nhịp tim (Heartbeat) giữa các máy chủ trong Cluster. Khi một Host bị sập nguồn đột ngột, cơ chế **Fencing** sẽ cô lập Host lỗi và tự động khởi động lại các VM của nó sang các Host vật lý còn hoạt động.

---

### 7. Thực hành quản lý VM (Với KVM/QEMU/libvirt trên Ubuntu)

```bash
#!/usr/bin/env bash
set -e
export LIBVIRT_DEFAULT_URI=qemu:///system
IMG=/var/lib/libvirt/images
VM=cirros-srv


# ========== 0. Cài KVM/libvirt và bật daemon ==========
grep -Ec '(vmx|svm)' /proc/cpuinfo                 # phải > 0
apt update
apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst
systemctl enable --now libvirtd
virsh net-start default 2>/dev/null || true         # mạng NAT mặc định
virsh net-autostart default
virsh list --all                                    # không lỗi là OK

# ========== 1. Tải CirrOS, nới ổ lên 20G ==========
cd $IMG
[ -f $VM.qcow2 ] || wget -O $VM.qcow2 https://download.cirros-cloud.net/0.6.3/cirros-0.6.3-x86_64-disk.img
qemu-img resize $VM.qcow2 20G

# ========== 2. Tạo VM (2 vCPU, 2GB RAM) ==========
virt-install \
  --name $VM --ram 2048 --vcpus 2 \
  --disk path=$IMG/$VM.qcow2,format=qcow2,bus=virtio \
  --os-variant generic --network network=default,model=virtio \
  --graphics none --import --noautoconsole

virsh console $VM        # thoát: Ctrl + ]   | login: cirros / gocubsgo
# Quan sát trong guest:
#   nproc ; grep -m1 'model name' /proc/cpuinfo   -> 2 vCPU
#   free -m                                        -> ~2GB RAM
#   lsblk (hoặc fdisk -l) ; df -h /                -> /dev/vda ~20G
virsh domifaddr $VM      # xem IP của VM (chạy ở host)

# ========== 3. Snapshot / revert ==========
virsh snapshot-create-as $VM snap-initial --description "Clean OS"
virsh snapshot-list $VM
virsh snapshot-revert $VM snap-initial

# ========== 4. Clone ==========
virsh shutdown $VM || true; wait_off $VM
virt-clone --original $VM --name $VM-clone --file $IMG/$VM-clone.qcow2
virsh list --all

# ========== 5. Scale: 4 vCPU, 4GB RAM, +10G disk (VM đang tắt) ==========
virsh snapshot-delete $VM snap-initial               # bắt buộc, còn snapshot thì không resize được
virsh setvcpus $VM 4 --config --maximum
virsh setvcpus $VM 4 --config
virsh setmaxmem $VM 4194304 --config                 # đơn vị KiB = 4GiB
virsh setmem $VM 4194304 --config
qemu-img resize $IMG/$VM.qcow2 +10G
virsh start $VM
virsh console $VM
# Kiểm tra trong guest: nproc ; free -m ; df -h /   (CirrOS tự giãn partition lúc boot, ~30G)

# ========== 6. Backup, xóa, restore ==========
mkdir -p ~/vm-backup
virsh shutdown $VM || true; wait_off $VM
virsh dumpxml $VM > ~/vm-backup/$VM.xml
cp --sparse=always $IMG/$VM.qcow2 ~/vm-backup/

virsh undefine $VM --remove-all-storage --snapshots-metadata   # xóa hoàn toàn
virsh list --all; ls $IMG                                      # xác nhận đã mất

cp --sparse=always ~/vm-backup/$VM.qcow2 $IMG/                 # restore
virsh define ~/vm-backup/$VM.xml
virsh start $VM
virsh list --all
```


## PHẦN 3: TỔNG QUAN VỀ CONTAINER

### 8. Container là gì?

#### Khái niệm Container và Containerization
* **Containerization (Container hóa):** Là phương thức ảo hóa ở tầng Hệ điều hành (OS-level Virtualization), đóng gói mã nguồn ứng dụng cùng toàn bộ các thư viện, tệp nhị phân phụ thuộc (Binaries/Libraries) và tệp cấu hình vào một gói phần mềm tiêu chuẩn.
* **Container:** Là một thực thể đang chạy (Runnable instance) được khởi tạo từ gói đóng gói đó, hoạt động như một nhóm tiến trình được cô lập trên cùng một nhân hệ điều hành chủ (Shared Host Kernel).

#### Mục đích sử dụng Container trong phát triển và triển khai ứng dụng
* **Tính nhất quán môi trường ("Build once, run anywhere"):** Xóa bỏ hoàn toàn tình trạng *"Chạy được trên máy Dev nhưng lỗi trên máy Production"* do lệch phiên bản thư viện hoặc hệ điều hành.
* **Tối ưu kiến trúc Microservices & CI/CD:** Khởi động trong vài chục mili-giây, cho phép mở rộng quy mô tự động (Auto-scaling) tức thời và tích hợp mượt mà vào đường ống kiểm thử/triển khai tự động.
* **Mật độ triển khai cao (High Density):** Tiết kiệm RAM và CPU tối đa do không phải gánh hàng chục bản sao Guest OS Kernel như máy ảo.

#### Phân biệt Container và Virtual Machine

| Tiêu chí | Virtual Machine (Máy ảo - VM) | Container |
| :--- | :--- | :--- |
| **Tầng ảo hóa** | Ảo hóa phần cứng vật lý (Hardware-level Virtualization). | Ảo hóa hệ điều hành (OS-level Virtualization). |
| **Nhân hệ điều hành (Kernel)** | Mỗi VM sở hữu một **Guest OS Kernel riêng biệt**. | Tất cả Container **chia sẻ chung Host OS Kernel**. |
| **Kích thước đóng gói** | Nặng (Từ vài GB đến hàng chục GB vì chứa cả OS). | Rất nhẹ (Từ vài MB đến vài trăm MB). |
| **Thời gian khởi động** | Chậm (Từ vài chục giây đến vài phút để boot OS). | Tức thời (Mili-giây đến vài giây). |
| **Hiệu năng thực thi** | Hao hụt (Overhead) qua lớp giả lập phần cứng và dịch địa chỉ 2 tầng. | Tương đương tiến trình chạy trực tiếp trên máy thật (Native performance). |
| **Mức độ cô lập bảo mật** | Cô lập ở tầng phần cứng CPU/MMU (VT-x, EPT) — **An toàn rất cao**. | Cô lập ở tầng tiến trình Kernel (Namespaces/cgroups) — **Kém hơn VM**. |

#### Hạn chế của Container và các trường hợp nên sử dụng VM
* **Hạn chế của Container:**
  1. **Rủi ro bảo mật dùng chung Kernel:** Nếu một Container khai thác thành công lỗ hổng leo thang đặc quyền trong Linux Kernel (Kernel Exploit / Container Escape), toàn bộ Host và các Container khác đều bị xâm nhập.
  2. **Phụ thuộc kiến trúc OS Kernel:** Container Linux không thể chạy trực tiếp trên nhân Windows gốc (Docker Desktop trên Windows/macOS thực chất phải tạo một máy ảo Linux ẩn bên dưới như WSL2/HyperKit để chạy Container).
  3. **Không thể tinh chỉnh Kernel riêng biệt:** Các ứng dụng đòi hỏi nạp Kernel Module riêng (như `kpatch`, driver phần cứng đặc thù) hoặc cấu hình `sysctl` cấp nhân sâu không thể tách biệt hoàn toàn trên Container.
* **Khi nào nên chọn VM thay vì Container?**
  * Cần chạy hệ điều hành khác họ với Host (VD: Chạy Windows Server hoặc FreeBSD trên máy chủ Linux).
  * Môi trường hạ tầng đa khách hàng (Multi-tenant Public Cloud) yêu cầu cô lập bảo mật phần cứng tuyệt đối để tuân thủ quy định an toàn thông tin (PCI-DSS, HIPAA).
  * Vận hành các hệ thống Legacy/Monolithic lớn gắn chặt với cấu hình khởi động systemd và nhân hệ điều hành cố định.

---

### 9. Cơ chế hoạt động của Container trên Linux

#### Container sử dụng chung Linux Kernel như thế nào?
Container không hề có bước khởi động BIOS hay nạp Kernel (`vmlinuz`). Khi bạn khởi chạy một Container (ví dụ chạy Image `ubuntu:24.04` trên máy chủ `Rocky Linux 9`), Container chỉ sử dụng các tệp thư viện không gian người dùng (`glibc`, `apt`, `/bin/bash`) của Ubuntu, nhưng mọi lời gọi hệ thống (**System Calls** như `open()`, `read()`, `socket()`, `fork()`) đều được gửi trực tiếp xuống **Linux Kernel của máy chủ Rocky Linux**.

#### Linux Namespaces và vai trò cô lập tiến trình (*"Container được nhìn thấy gì?"*)
Namespaces bọc các tài nguyên hệ thống toàn cục sao cho tiến trình bên trong mỗi Namespace tưởng rằng nó đang sở hữu một hệ thống độc lập:
1. **`pid` (Process ID):** Cô lập cây tiến trình. Tiến trình chính của Container luôn có `PID 1` bên trong Container dù có PID khác trên Host, và không nhìn thấy tiến trình của Host hay Container khác.
2. **`net` (Network):** Cô lập giao diện mạng (`lo`, `eth0` nối qua cặp cáp ảo `veth`), địa chỉ IP, bảng định tuyến (Routing table), quy tắc tường lửa `iptables` và danh sách cổng lắng nghe.
3. **`mnt` (Mount):** Cô lập hệ thống tệp tin gốc (`rootfs`) và danh sách các điểm gắn kết (Mount points) thông qua `pivot_root`.
4. **`uts` (UNIX Time-sharing System):** Cho phép mỗi Container có `hostname` và `domainname` riêng biệt.
5. **`ipc` (Inter-Process Communication):** Cô lập bộ nhớ dùng chung (Shared Memory - `/dev/shm`), Semaphores và Message Queues.
6. **`user` (User Namespace):** Ánh xạ định danh `UID/GID` giữa Container và Host (cho phép UID 0 - `root` trong Container ánh xạ thành một UID người dùng thường không có đặc quyền trên Host).

#### Control Groups (`cgroups`): Giới hạn CPU và RAM (*"Container được dùng bao nhiêu?"*)
Cơ chế `cgroups` (v1 và v2) của Linux Kernel theo dõi và áp đặt giới hạn định lượng tài nguyên phần cứng cho từng nhóm tiến trình Container:
* **Giới hạn CPU:** Kiểm soát thời gian sử dụng CPU qua `cpu.max` / `cfs_quota_us` và `cfs_period_us` (giới hạn số core tối đa), trọng số ưu tiên `cpu.weight` (`--cpu-shares`), và gắn cứng nhân CPU qua `cpuset.cpus` (`--cpuset-cpus`).
* **Giới hạn RAM:** Kiểm soát mức trần bộ nhớ qua `memory.max` (`--memory`). Nếu tiến trình trong Container tiêu thụ vượt ngưỡng giới hạn này, trình **OOM Killer (Out-Of-Memory Killer)** của Linux Kernel sẽ lập tức tiêu diệt tiến trình đó (trả về mã thoát **Exit Code 137** = 128 + 9 [SIGKILL]).

#### Union Filesystem, OverlayFS và cơ chế Copy-on-Write (CoW)
Docker sử dụng trình điều khiển lưu trữ **`overlay2`** (triển khai trên **OverlayFS** của Linux Kernel) để hợp nhất nhiều tầng thư mục thành một điểm truy cập duy nhất (`merged`):

```text
+-------------------------------------------------------------------+
|  Merged View (Điểm gắn kết "/" mà Container nhìn thấy)            |
+-------------------------------------------------------------------+
                                  ^
                                  | (Hợp nhất)
+-------------------------------------------------------------------+
|  UpperDir (Container Layer): Lớp Đọc-Ghi (Read-Write) mỏng        |
+-------------------------------------------------------------------+
|  LowerDir (Image Layers): Các lớp Chỉ-Đọc (Read-Only) bất biến    |
|    - Layer 3: COPY mã nguồn ứng dụng                              |
|    - Layer 2: RUN apt install nginx                               |
|    - Layer 1: Base Image (Ubuntu rootfs)                          |
+-------------------------------------------------------------------+
```

* **Cơ chế Copy-on-Write (CoW):** Các lớp của Image (`LowerDir`) hoàn toàn ở chế độ **Read-Only** và được dùng chung bởi hàng chục Container. Khi Container chỉ đọc dữ liệu, nó đọc thẳng từ `LowerDir`. Chỉ khi Container cần **chỉnh sửa** một tệp tin có sẵn ở tầng dưới, `OverlayFS` mới sao chép tệp đó lên tầng `UpperDir` (Read-Write) rồi thực hiện ghi trên bản sao đó. Khi xóa tệp, nó tạo một tệp đánh dấu ẩn (*whiteout file*) ở `UpperDir` mà không làm hỏng Image gốc.

#### Phân biệt Container Image và Container Runtime & Chuẩn OCI
* **Container Image:** Gói tệp tin tĩnh gồm các lớp hệ thống tệp (Filesystem layers) và tệp cấu hình Metadata (JSON).
* **Container Runtime:** Phần mềm chịu trách nhiệm giải nén Image, thiết lập Namespaces/cgroups và khởi chạy tiến trình Container. Chia làm *High-level Runtime* (quản lý Image, mạng, API như `containerd`, `CRI-O`) và *Low-level Runtime* (giao tiếp trực tiếp với Kernel như `runc`, `crun`).
* **Chuẩn OCI (Open Container Initiative):** Tổ chức thuộc Linux Foundation định nghĩa 3 tiêu chuẩn mở để đảm bảo mọi công cụ Container tương thích chéo với nhau:
  1. **OCI Image Specification:** Quy định định dạng chuẩn của một Container Image (Layers `.tar.gz`, `manifest.json`, `config.json`). Nhờ đó Image build bằng Docker có thể chạy trên Podman, Kubernetes (CRI-O/containerd) mà không cần chuyển đổi.
  2. **OCI Runtime Specification:** Quy định cách thức giải nén Image thành một *Filesystem Bundle* (thư mục `rootfs` kèm tệp cấu hình `config.json`) và quản lý trạng thái vòng đời thực thi thông qua `runc`.
  3. **OCI Distribution Specification:** Chuẩn hóa giao thức API để đẩy (Push) và kéo (Pull) Image qua các Registry.

---

## PHẦN 4: DOCKER CƠ BẢN

### 10. Tổng quan về Docker

* **Docker là gì? Tại sao cần Docker?**
  Trước khi có Docker, việc tạo Container trên Linux đòi hỏi cấu hình thủ công rất phức tạp với `LXC`, `chroot`, `cgroups` và `namespaces`. **Docker** ra đời cung cấp một nền tảng hoàn chỉnh với giao diện CLI thân thiện, chuẩn hóa định dạng đóng gói (**Dockerfile / Docker Image**) và kho phân phối tập trung (**Registry**), biến việc đóng gói và vận hành ứng dụng trở nên đơn giản, tự động hóa hoàn toàn.
* **Các thành phần của Docker Platform:**
  * **Docker Engine:** Phần mềm cốt lõi theo kiến trúc Client-Server gồm Docker CLI (`docker`), REST API và Docker Daemon (`dockerd`).
  * **Docker Desktop:** Ứng dụng tích hợp GUI dành cho Windows, macOS và Linux Desktop; bên dưới tự động khởi tạo một máy ảo Linux nhẹ (WSL2 hoặc Hypervisor framework) kèm Docker Engine, Docker Compose và Kubernetes.
* **Docker CE và các sản phẩm dành cho doanh nghiệp:**
  * **Docker CE (Community Edition / Docker Engine):** Phiên bản mã nguồn mở, miễn phí hoàn toàn khi cài đặt trực tiếp trên máy chủ Linux (`docker-ce`).
  * **Docker Subscription (Pro, Team, Business):** Các gói thương mại dành cho doanh nghiệp sử dụng Docker Desktop quy mô lớn, bổ sung tính năng bảo mật nâng cao (*Hardened Desktop*, *Image Access Management*, *Docker Scout* quét lỗ hổng CVE, *Docker Build Cloud*).
* **Khái niệm Docker Image, Container, Registry & Quy trình Build -> Ship -> Run:**
  1. **Build (Xây dựng):** Lập trình viên viết `Dockerfile` và đóng gói ứng dụng thành **Docker Image** (khuôn mẫu bất biến).
  2. **Ship (Phân phối):** Đẩy (`docker push`) Image lên **Docker Registry** (như Docker Hub, Harbor, GitLab Registry) để lưu trữ và chia sẻ.
  3. **Run (Triển khai):** Máy chủ Production kéo (`docker pull`) Image từ Registry về và khởi chạy thành các **Docker Containers** đang hoạt động.

---

### 11. Cài đặt và cấu hình Docker trên Linux

#### 1. Cài đặt Docker Engine chính thức trên Ubuntu
```bash
# Gỡ bỏ các gói cũ không chính thức (nếu có)
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg; done

# Cài đặt các gói phụ thuộc và thêm GPG Key chính thức của Docker
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL [https://download.docker.com/linux/ubuntu/gpg](https://download.docker.com/linux/ubuntu/gpg) -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Thêm kho lưu trữ (Repository) chính thức của Docker vào Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] [https://download.docker.com/linux/ubuntu](https://download.docker.com/linux/ubuntu) \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Cài đặt Docker Engine, CLI, containerd và plugin Docker Compose V2
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

#### 2. Chạy Docker không cần `sudo` và Lưu ý bảo mật quan trọng
```bash
# Thêm user hiện tại vào nhóm "docker" để có quyền giao tiếp với /var/run/docker.sock
sudo usermod -aG docker $USER
newgrp docker
```

> **Lưu ý bảo mật (Security Warning):** Nhóm `docker` có quyền ngang hàng với quyền **`root`** trên máy chủ Host. Bất kỳ người dùng nào thuộc nhóm `docker` đều có thể chạy lệnh `docker run -v /:/host -it alpine chroot /host` để gắn toàn bộ hệ thống tệp gốc `/` của máy chủ vào Container và chỉnh sửa `/etc/shadow` hoặc chiếm quyền điều khiển toàn bộ Host. Chỉ cấp nhóm `docker` cho quản trị viên tin cậy, hoặc sử dụng chế độ **Rootless Docker** trong môi trường yêu cầu bảo mật cao.

#### 3. Kiểm tra và Quản lý dịch vụ Docker với `systemctl`
```bash
# Kiểm tra phiên bản Client & Server và thông tin chi tiết hệ thống Docker
docker version
docker info

# Quản lý dịch vụ bằng systemd
sudo systemctl enable --now docker
sudo systemctl status docker
sudo systemctl restart docker
```

#### 4. Cấu hình Docker Proxy (Trong môi trường mạng doanh nghiệp)
Có **2 tầng cấu hình Proxy khác nhau** không được nhầm lẫn:
* **A. Proxy cho Docker Daemon (`dockerd`):** Dùng khi máy chủ thực hiện `docker pull` hoặc `docker push` ra Internet qua Proxy. Cấu hình qua systemd drop-in file:

```bash
sudo mkdir -p /etc/systemd/system/docker.service.d
cat <<EOF "default": "[http://proxy.corp.local:8080](http://proxy.corp.local:8080)", "httpProxy": "httpsProxy": "insecure-registries": "localhost,127.0.0.1,.corp.local" "noProxy": "proxies": "registry.lab.local:5000"] ### #### & (Chứng (Lab/Test) (Options) (Production) (Self-signed): (VD: (`ca.crt`) (hoặc (không * **B. **Phương **Tải --- --rm -p /etc/docker/certs.d/registry.lab.local:5000 /etc/docker/certs.d/registry.lab.local:5000/ca.crt /etc/docker/daemon.json /etc/systemd/system/docker.service.d/http-proxy.conf 12. 5. 6. :--- <<EOF CA Cho Chạy Client Container Container:** Các Câu Cấu Daemon): Docker Dùng EOF Environment="NO_PROXY=localhost,127.0.0.1,.corp.local,10.0.0.0/8" Giải HTTP Image** Internet Khai Khi Không Nhóm Private Proxy Proxy. Registry TLS; Tạo Xem ["192.168.1.100:5000", [Service] `/etc/docker/daemon.json`:** ``` ```bash ```json `docker `insecure-registries` `insecure-registries`) `registry.lab.local:5000`): `~/.docker/config.json`: build`) báo bên bản bảo bỏ bộ ca.crt cat cho chuẩn chép chạy chỉ chọn chức chứng cp các câu cơ cần cập cậy cậy:** của daemon-reload docker dụng file gốc hello-world hoặc hình khi khởi ký kết làm lúc lại lệnh minh mkdir mẫu mật mục nghiệm nginx:1.27-alpine`<br năng nối nội phép pull qua quan restart run sudo systemctl tee thuần thích thư thử thực tin tiên trong truy trọng tác tùy tắt tự việc và vào với vụ xác { | } án đầu để động ứng —>`docker images` (hoặc `docker image ls`) | Tải Image từ Registry về máy và liệt kê danh sách các Image hiện có. |
| **Khởi chạy Container (`docker run`)** | `docker run -d --name web -p 8080:80 -v /data:/usr/share/nginx/html -e TZ=Asia/Ho_Chi_Minh nginx:1.27-alpine` | • `-d` (Detached): Chạy ngầm dưới nền.<br>• `-it`: Mở giao diện tương tác dòng lệnh (TTY + STDIN).<br>• `--name`: Đặt tên định danh cho Container.<br>• `-p <Host_Port>:<Container_Port>`: Ánh xạ cổng mạng.<br>• `-v <Host_Path/Vol>:<Container_Path>`: Gắn ổ đĩa lưu trữ.<br>• `-e KEY=VAL`: Truyền biến môi trường.<br>• `--rm`: Tự động xóa Container ngay khi tiến trình dừng. |
| **Kiểm tra trạng thái** | `docker ps` (Đang chạy)<br>`docker ps -a` (Tất cả, gồm cả đã tắt) | Xem danh sách Container, ID, tên, cổng ánh xạ và trạng thái hiện tại. |
| **Điều khiển vòng đời** | `docker stop web`<br>`docker start web`<br>`docker restart web` | `stop` gửi tín hiệu `SIGTERM` (chờ tối đa 10s rồi gửi `SIGKILL`); `start` bật lại Container đã tắt; `restart` khởi động lại. |
| **Xóa tài nguyên** | `docker rm web` (`docker rm -f web`)<br>`docker rmi nginx:1.27-alpine` | `rm` xóa Container (thêm `-f` để buộc xóa khi đang chạy); `rmi` xóa Image khỏi ổ cứng. |
| **Theo dõi & Gỡ lỗi** | `docker logs -f --tail 100 web`<br>`docker exec -it web sh`<br>`docker inspect web` | • `logs -f`: Theo dõi luồng STDOUT/STDERR thời gian thực.<br>• `exec -it`: Mở thêm tiến trình shell bên trong Container đang chạy.<br>• `inspect`: Xuất toàn bộ cấu hình chi tiết (IP, Mounts, Env) dạng JSON. |
| **Giám sát & Tiện ích** | `docker stats`<br>`docker top web`<br>`docker cp file.txt web:/tmp/`<br>`docker diff web` | • `stats`: Xem % CPU, RAM, Net I/O, Block I/O thời gian thực.<br>• `top`: Xem các tiến trình đang chạy bên trong Container.<br>• `cp`: Sao chép tệp hai chiều giữa Host và Container.<br>• `diff`: Liệt kê các file đã bị thêm (`A`), sửa (`C`), xóa (`D`) trên lớp Read-Write. |

#### Chính sách tự khởi động lại (`--restart`) và Giới hạn tài nguyên (`--memory`, `--cpus`)
```bash
# Khởi chạy Container với chính sách tự bật lại và giới hạn tối đa 512MB RAM, 1.5 CPU cores
docker run -d \
  --name api-prod \
  --restart unless-stopped \
  --memory="512m" \
  --cpus="1.5" \
  nginx:1.27-alpine
```
* **4 giá trị của `--restart`:**
  * `no` (Mặc định): Không tự khởi động lại.
  * `on-failure[:max-retries]`: Chỉ tự khởi động lại nếu Container thoát với mã lỗi khác 0 (Exit code != 0).
  * `always`: Luôn tự khởi động lại khi bị sập hoặc khi khởi động lại dịch vụ `dockerd`.
  * `unless-stopped`: Tương tự `always`, nhưng nếu quản trị viên đã chủ động gõ lệnh `docker stop`, nó sẽ không tự bật lại khi khởi động lại máy chủ.

---

## PHẦN 5: DOCKER IMAGE VÀ DOCKERFILE

### 13. Docker Image là gì?

* **Khái niệm & Phân biệt với Container:** **Docker Image** là một khuôn mẫu bất biến chỉ đọc (Read-only template) chứa hệ thống tệp và thông số cấu hình ứng dụng. **Container** là thực thể động được khởi tạo từ Image bằng cách chồng thêm một lớp Read-Write mỏng lên trên cùng (1 Image có thể sinh ra hàng trăm Container chạy đồng thời).
* **Cấu trúc Image Layers (`docker history`):** Mỗi chỉ thị trong Dockerfile tạo ra một lớp thay đổi hệ thống tệp (Layer) được định danh bằng mã băm SHA256. Lệnh `docker history <image>` giúp kiểm tra kích thước và câu lệnh tạo nên từng Layer.
* **Phân biệt Image Tag và Image Digest:**
  * **Image Tag** (VD: `nginx:1.27` hoặc `nginx:latest`): Là nhãn định danh dạng chuỗi do con người đặt, **có thể bị ghi đè (Mutable)** khi nhà phát triển đẩy một bản cập nhật mới trùng tên Tag.
  * **Image Digest** (VD: `nginx@sha256:4a9c95...`): Là mã băm mật mã học SHA-256 tính toán từ nội dung của Image Manifest, **hoàn toàn bất biến (Immutable)**. Dùng Digest đảm bảo kéo chính xác tuyệt đối 100% cùng một bản build trên mọi máy chủ.
* **Quy tắc đặt tên và quản lý phiên bản Image:**
  * Cấu trúc tên chuẩn đầy đủ: `[REGISTRY_HOST[:PORT]/][NAMESPACE/]REPOSITORY[:TAG]` (VD: `ghcr.io/vuvietthanh/core-api:1.2.0`).
  * **Tuân thủ Semantic Versioning (`MAJOR.MINOR.PATCH` - VD: `1.4.2`) và tránh dùng `:latest` trên Production:** Nhãn `:latest` không đảm bảo tính tái lập (Reproducibility); nếu hệ thống tự động kéo lại `:latest` khi có bản cập nhật Breaking Changes, ứng dụng Production có thể bị sập hoặc khó Rollback.
* **Các lệnh thao tác với Registry và Lưu/Nạp Image Offline (`save` / `load`):**

```bash
# Gắn nhãn mới và đẩy lên Registry
docker tag myapp:1.0.0 docker.io/username/myapp:1.0.0
docker push docker.io/username/myapp:1.0.0

# Xuất Image ra file nén .tar.gz để chuyển sang máy chủ không có Internet (Air-gapped)
docker save myapp:1.0.0 | gzip > myapp_1.0.0.tar.gz

# Nạp lại Image từ file nén trên máy chủ đích
docker load -i myapp_1.0.0.tar.gz
```

---

### 14. Xây dựng Docker Image bằng Dockerfile

#### Tổng hợp các chỉ thị (Instructions) trong Dockerfile

| Chỉ thị | Vai trò & Lưu ý kỹ thuật quan trọng |
| :--- | :--- |
| **`FROM`** | Khai báo Base Image nền tảng mở đầu cho một Stage (VD: `FROM python:3.12-slim`). |
| **`WORKDIR`** | Thiết lập thư mục làm việc hiện hành cho các lệnh `RUN`, `CMD`, `ENTRYPOINT`, `COPY` kế tiếp (tự động tạo thư mục nếu chưa tồn tại). |
| **`COPY` vs `ADD`** | Cả hai đều chép file từ Host vào Image. **Ưu tiên dùng `COPY`** vì tính minh bạch. Chỉ dùng `ADD` khi cần tự động giải nén file `.tar.gz` cục bộ. |
| **`RUN`** | Thực thi câu lệnh trong quá trình **Build Image** để cài đặt gói phần mềm và tạo thành một Layer mới. |
| **`ARG` vs `ENV`** | • **`ARG`**: Biến chỉ tồn tại trong **lúc Build Image** (`docker build --build-arg`), biến mất khi Container chạy.<br>• **`ENV`**: Biến môi trường tồn tại cả lúc Build và **bền vững khi Container đang chạy (Runtime)**. |
| **`EXPOSE`** | Khai báo cổng mạng tài liệu hóa mà ứng dụng lắng nghe (VD: `EXPOSE 8080`), không tự động mở cổng ra Host nếu không dùng `-p` lúc chạy. |
| **`USER`** | Chuyển đổi định danh người dùng thực thi tiến trình (VD: `USER appuser`) thay vì chạy quyền `root` mặc định. |
| **`HEALTHCHECK`** | Định nghĩa lệnh kiểm tra sức khỏe định kỳ để Docker biết ứng dụng bên trong Container có thực sự hoạt động tốt (`healthy` hay `unhealthy`). |
| **`LABEL`, `VOLUME`** | `LABEL` gắn metadata (tác giả, phiên bản); `VOLUME` đánh dấu điểm gắn kết dữ liệu bền vững ngoài lớp UnionFS. |

#### Phân biệt `CMD` và `ENTRYPOINT`; `Exec form` và `Shell form`
* **`ENTRYPOINT` vs `CMD`:**
  * **`ENTRYPOINT`** định nghĩa chương trình thực thi cố định của Container.
  * **`CMD`** định nghĩa lệnh mặc định hoặc cung cấp **các tham số mặc định (Default arguments)** truyền vào cho `ENTRYPOINT`. Các tham số truyền ở cuối câu lệnh `docker run <image> <args>` sẽ ghi đè lên `CMD`, nhưng không ghi đè `ENTRYPOINT`.
* **`Exec form` (`["executable", "param1"]`) vs `Shell form` (`command param1`):**
  * **Luôn ưu tiên dùng `Exec form`:** Khởi chạy trực tiếp tiến trình ứng dụng làm **`PID 1`** bên trong Container, giúp ứng dụng nhận được trực tiếp các tín hiệu hệ thống như **`SIGTERM`** khi gọi `docker stop` để đóng kết nối an toàn (Graceful Shutdown).
  * **`Shell form`:** Tự động bọc lệnh trong `/bin/sh -c "..."`, khiến `/bin/sh` chiếm `PID 1` và không chuyển tiếp tín hiệu `SIGTERM` xuống tiến trình con, làm Container bị treo 10 giây rồi bị giết cưỡng bức bằng `SIGKILL`.

#### Tối ưu hóa với `.dockerignore`, Build Cache và Multi-stage Build
* **Tệp `.dockerignore`:** Loại trừ các thư mục rác hoặc nhạy cảm (`.git`, `node_modules`, `__pycache__`, `.env`, `*.log`) không bị gửi vào *Build Context* tới Docker Daemon, giúp tăng tốc độ build và tránh lộ mật khẩu.
* **Tối ưu Docker Build Cache:** Sắp xếp các chỉ thị **ít thay đổi ở trên, hay thay đổi ở dưới**. Ví dụ: `COPY requirements.txt` và `RUN pip install` trước khi `COPY . .` (mã nguồn) để không phải tải lại thư viện mỗi khi sửa 1 dòng code.
* **Multi-stage Build:** Sử dụng nhiều câu lệnh `FROM` trong cùng một Dockerfile. Stage 1 (`builder`) dùng Image đầy đủ công cụ biên dịch (Maven/JDK, Go, GCC) để biên dịch ra file thực thi; Stage 2 (`runtime`) dùng Image cực nhẹ (`alpine`, `distroless`, `jre-slim`) và chỉ dùng `COPY --from=builder` để lấy đúng file thành phẩm sang, giúp giảm kích thước Image từ hàng trăm MB xuống còn vài chục MB.

---

### 15. Thực hành Build và Push Docker Image (So sánh Single-stage vs. Multi-stage)

#### Bước 1: Tạo ứng dụng Web đơn giản và `.dockerignore`
```bash
mkdir -p ~/docker-lab && cd ~/docker-lab

cat << 'EOF' > main.go
package main
import (
    "fmt"
    "net/http"
    "os"
)
func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        host, _ := os.Hostname()
        fmt.Fprintf(w, "Hello from Container ID: %s\n", host)
    })
    fmt.Println("Server starting on port 8080...")
    http.ListenAndServe(":8080", nil)
}
EOF

cat << 'EOF' > .dockerignore
.git
*.md
*.tar.gz
EOF
```

#### Bước 2: Viết Dockerfile thường (Single-stage) và Dockerfile tối ưu (Multi-stage)
```dockerfile
# --- FILE 1: Dockerfile.single (Chưa tối ưu) ---
FROM golang:1.23-bookworm
WORKDIR /app
COPY main.go .
RUN go build -o server main.go
EXPOSE 8080
CMD ["./server"]
```

```dockerfile
# --- FILE 2: Dockerfile (Multi-stage chuẩn Production + Non-root User) ---
# Stage 1: Build stage
FROM golang:1.23-alpine AS builder
WORKDIR /build
COPY main.go .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o server main.go

# Stage 2: Runtime stage siêu nhẹ
FROM alpine:3.20
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
COPY --from=builder /build/server /app/server
USER appuser
EXPOSE 8080
HEALTHCHECK --interval=10s --timeout=3s CMD wget -qO- http://localhost:8080/ || exit 1
ENTRYPOINT ["/app/server"]
```

#### Bước 3: Build, So sánh kích thước, Gắn Tag và Push lên Registry
```bash
# 1. Build cả 2 phiên bản và so sánh kích thước
docker build -f Dockerfile.single -t web-demo:single .
docker build -f Dockerfile -t web-demo:1.0.0 .
docker images | grep web-demo
# Kết quả:
# web-demo:single   ~850 MB (Chứa cả trình biên dịch Go và hệ điều hành Debian)
# web-demo:1.0.0    ~14 MB  (Giảm hơn 98% dung lượng!)

# 2. Chạy thử nghiệm Container từ Image tối ưu
docker run -d --name test-web -p 8080:8080 web-demo:1.0.0
curl http://localhost:8080

# 3. Gắn Tag theo chuẩn Docker Hub / Private Registry và Push
docker login
docker tag web-demo:1.0.0 <dockerhub_username>/web-demo:1.0.0
docker push <dockerhub_username>/web-demo:1.0.0

# 4. Xóa Image cục bộ, Pull lại và kiểm thử
docker rm -f test-web && docker rmi <dockerhub_username>/web-demo:1.0.0
docker run -d -p 8080:8080 <dockerhub_username>/web-demo:1.0.0
```

---

## PHẦN 6: KIẾN TRÚC VÀ QUẢN LÝ DOCKER

### 16. Kiến trúc Docker Engine

#### Mô hình Client – Server và Chuỗi thành phần thực thi
```text
+--------------+    REST API (UNIX Socket)   +-------------------+
|  Docker CLI  | --------------------------> |   Docker Daemon   |
|  (`docker`)  |   /var/run/docker.sock      |    (`dockerd`)    |
+--------------+                             +-------------------+
                                                       | (gRPC)
                                                       v
                                             +-------------------+
                                             |   `containerd`    |
                                             +-------------------+
                                                       | (Khởi tạo)
                                                       v
                                             +-------------------+      +--------+
                                             | `containerd-shim` | ---> | `runc` |
                                             +-------------------+      +--------+
                                                       | (Giám sát trực tiếp)
                                                       v
                                             [ Container Process ]
```

* **Docker CLI (`docker`) & Docker API:** Client tiếp nhận lệnh từ người dùng và gửi yêu cầu HTTP REST API tới Daemon qua socket `/var/run/docker.sock` hoặc cổng TCP.
* **Docker Daemon (`dockerd`) & `/etc/docker/daemon.json`:** Quản lý vòng đời cấp cao gồm Images, Volumes, Networks, Build Engine. Tệp `/etc/docker/daemon.json` dùng để cấu hình toàn cục cho `dockerd` (log driver, storage driver `overlay2`, DNS, registry mirrors, dải mạng `bip`).
* **Vai trò của `containerd`, `containerd-shim` và `runc`:**
  * **`containerd`:** Daemon tách biệt chuyên quản lý vòng đời thực thi Container (nhận yêu cầu từ `dockerd` qua gRPC).
  * **`runc`:** OCI Runtime cấp thấp trực tiếp gọi xuống Linux Kernel để thiết lập Namespaces, `cgroups` và khởi chạy tiến trình Container. Ngay khi tiến trình Container bắt đầu chạy, **`runc` lập tức thoát**.
  * **`containerd-shim`:** Đóng vai trò là tiến trình cha (Parent process) gắn trực tiếp với mỗi Container đang chạy: giữ mở các luồng I/O (`STDIN/STDOUT`), báo cáo mã thoát (Exit status) về `containerd`, và quan trọng nhất là **cho phép nâng cấp hoặc khởi động lại `dockerd` mà không làm tắt các Container đang chạy (Live Restore)**.

#### Quy trình 6 bước từ khi gõ `docker run` đến khi Container hoạt động
1. Người dùng gõ `docker run`, **Docker CLI** chuyển đổi lệnh thành gói tin REST API gửi tới **`dockerd`**.
2. **`dockerd`** kiểm tra xem Image đã có trên ổ đĩa cục bộ chưa; nếu chưa, nó tải Image từ Registry về và giải nén các lớp qua `overlay2`.
3. **`dockerd`** gọi xuống **`containerd`** thông qua gRPC để yêu cầu tạo và chạy Container.
4. **`containerd`** tạo một *OCI Filesystem Bundle* và khởi chạy một tiến trình **`containerd-shim`** mới.
5. **`containerd-shim`** gọi **`runc`**. `runc` tương tác với Linux Kernel để tạo các Namespaces (`pid`, `net`, `mnt`...), gắn giới hạn `cgroups` và khởi chạy tiến trình ứng dụng bên trong Container.
6. **`runc`** hoàn thành nhiệm vụ và tự kết thúc; **`containerd-shim`** tiếp quản việc giám sát tiến trình Container cho đến khi Container dừng.

---

### 17. Docker Networking

#### Cơ chế mạng bên dưới nhân Linux (`veth`, `docker0`, `iptables`)
Khi cài đặt Docker, một Linux Bridge ảo tên là **`docker0`** (mặc định mang IP `172.17.0.1/16`) được tạo trên Host. Mỗi khi một Container khởi chạy ở chế độ Bridge, Docker tạo một cặp cáp mạng ảo **Virtual Ethernet Pair (`veth pair`)** hoạt động như một đường ống nối hai đầu: một đầu gắn vào bên trong Network Namespace của Container dưới tên **`eth0`**, đầu còn lại cắm trực tiếp vào Switch ảo **`docker0`** trên Host (hiển thị dưới tên `vethxxxx` khi gõ `ip link`). Việc đi ra Internet (SNAT/Masquerade) và mở cổng vào Container (DNAT/Port Forwarding) được xử lý bởi các quy tắc **`iptables` / `nftables`** trên Host.

#### Phân biệt 5 loại Docker Network

| Loại Network | Cơ chế hoạt động | Trường hợp sử dụng |
| :--- | :--- | :--- |
| **1. Bridge (`bridge`)** | Mạng nội bộ mặc định trên một máy chủ Host thông qua Linux Bridge. | Các Container chạy trên cùng một Host cần giao tiếp với nhau và cô lập với mạng ngoài. |
| **2. Host (`host`)** | Bỏ qua Network Namespace riêng; Container dùng chung trực tiếp card mạng và IP của máy chủ vật lý. | Cần hiệu năng mạng tối đa, độ trễ cực thấp, không muốn qua NAT. |
| **3. None (`none`)** | Tắt hoàn toàn kết nối mạng (chỉ có giao diện `lo` loopback bên trong Container). | Các tác vụ xử lý dữ liệu (Batch jobs) nhạy cảm cần cô lập mạng 100%. |
| **4. Overlay (`overlay`)** | Tạo mạng phủ (sử dụng đóng gói **VXLAN**) xuyên qua nhiều máy chủ Docker vật lý khác nhau. | Kết nối các Container nằm trên nhiều Node khác nhau (Docker Swarm / Multi-host). |
| **5. Macvlan (`macvlan`)** | Gán cho mỗi Container một địa chỉ MAC ảo riêng và nhận IP trực tiếp từ Router mạng LAN vật lý. | Các ứng dụng kế thừa (Legacy) cần xuất hiện như một thiết bị vật lý thực thụ trên mạng LAN. |

> **Phân biệt Default Bridge (`docker0`) và User-defined Bridge:**
> Trên mạng `bridge` mặc định, các Container chỉ có thể gọi nhau bằng **địa chỉ IP** (không có phân giải tên miền tự động). Ngược lại, khi tạo mạng **User-defined Bridge** (`docker network create`), Docker kích hoạt **Embedded DNS Server (`127.0.0.11`)** giúp các Container gọi nhau trực tiếp bằng **Tên Container (`--name`)** hoặc Network Alias, đồng thời cô lập mạng tốt hơn.

#### Thực hành tạo mạng và kết nối hai Container qua DNS nội bộ
```bash
# 1. Tạo một User-defined Bridge Network
docker network create --driver bridge app-net

# 2. Chạy Container thứ nhất (Web server) gắn vào mạng app-net
docker run -d --name backend-svc --network app-net nginx:1.27-alpine

# 3. Chạy Container thứ hai và ping/curl trực tiếp tới tên "backend-svc"
docker run --rm --network app-net alpine sh -c "ping -c 2 backend-svc && wget -qO- http://backend-svc"
```

---

### 18. Docker Storage và Volume

#### Ephemeral Storage và 3 cơ chế gắn lưu trữ trong Docker
* **Ephemeral Storage (Lưu trữ tạm thời):** Dữ liệu ghi vào lớp Read-Write (`UpperDir`) của Container gắn chặt với vòng đời của Container đó; khi chạy `docker rm`, toàn bộ dữ liệu trên lớp này bị xóa vĩnh viễn.
* **Phân biệt Docker Volume, Bind Mount và `tmpfs` Mount:**

| Tiêu chí | Docker Volume (Khuyên dùng) | Bind Mount | `tmpfs` Mount |
| :--- | :--- | :--- | :--- |
| **Vị trí trên Host** | Do Docker quản lý độc quyền tại `/var/lib/docker/volumes/<tên>/_data`. | Bất kỳ đường dẫn thư mục/file nào trên hệ thống tệp của Host. | Lưu trữ trực tiếp trên **bộ nhớ RAM** của Host, không bao giờ ghi xuống ổ cứng. |
| **Tính di động & Bảo mật** | Cao; độc lập cấu trúc thư mục Host, hỗ trợ Volume Drivers (NFS, AWS EBS, Ceph). | Phụ thuộc đường dẫn tuyệt đối của Host; có nguy cơ sửa nhầm file hệ thống Host. | Dữ liệu biến mất ngay khi dừng Container. |
| **Ứng dụng chính** | Lưu trữ dữ liệu bền vững cho Database (MySQL, PostgreSQL, Redis) trên Production. | Truyền mã nguồn trực tiếp từ máy Dev vào Container (Live-reload) hoặc gắn file cấu hình. | Lưu trữ dữ liệu nhạy cảm tạm thời (Token, khóa mật mã) hoặc bộ đệm tốc độ cao. |

#### Thực hành quản lý Volume, chạy MySQL bền vững và Backup/Restore Volume
```bash
# 1. Tạo và kiểm tra Docker Volume
docker volume create mysql-data
docker volume ls
docker volume inspect mysql-data

# 2. Khởi chạy MySQL Container gắn với Volume "mysql-data"
docker run -d \
  --name mysql-db \
  -e MYSQL_ROOT_PASSWORD=rootpass \
  -e MYSQL_DATABASE=shop_db \
  -v mysql-data:/var/lib/mysql \
  mysql:8.4

# 3. Tạo bảng dữ liệu mẫu bên trong MySQL
docker exec -it mysql-db mysql -uroot -prootpass -e \
  "USE shop_db; CREATE TABLE users (id INT, name VARCHAR(50)); INSERT INTO users VALUES (1, 'Thanh');"

# 4. Kiểm chứng tính bền vững: Xóa hẳn Container mysql-db rồi tạo Container mới gắn lại Volume cũ
docker rm -f mysql-db
docker run -d --name mysql-db-new -e MYSQL_ROOT_PASSWORD=rootpass -v mysql-data:/var/lib/mysql mysql:8.4
docker exec -it mysql-db-new mysql -uroot -prootpass -e "SELECT * FROM shop_db.users;"
# Dữ liệu (1, 'Thanh') vẫn còn nguyên vẹn!

# 5. BACKUP Volume ra file nén .tar.gz trên Host (Dùng một Container alpine trung gian)
docker run --rm \
  -v mysql-data:/volume_src:ro \
  -v $(pwd):/backup \
  alpine tar czf /backup/mysql-data-backup.tar.gz -C /volume_src .

# 6. RESTORE dữ liệu từ file .tar.gz vào một Volume mới
docker volume create mysql-data-restored
docker run --rm \
  -v mysql-data-restored:/volume_dest \
  -v $(pwd):/backup \
  alpine tar xzf /backup/mysql-data-backup.tar.gz -C /volume_dest
```

---

## PHẦN 7: DOCKER COMPOSE

### 19. Tổng quan về Docker Compose

* **Docker Compose là gì? Tại sao cần Docker Compose?**
  **Docker Compose** là công cụ định nghĩa và vận hành các ứng dụng đa Container (Multi-container applications) thông qua một tệp cấu hình khai báo YAML duy nhất (`compose.yaml`). Thay vì phải viết các script Bash dài dòng chứa hàng loạt lệnh `docker network create`, `docker volume create` và `docker run` rời rạc, Docker Compose quản lý toàn bộ kiến trúc ứng dụng như một dự án thống nhất.
* **Phân biệt Docker CLI và Docker Compose:**
  * `docker` (Docker CLI): Quản lý từng Container đơn lẻ.
  * `docker compose`: Quản lý đồng thời cả một cụm dịch vụ liên kết với nhau (Frontend, Backend, Database, Message Queue) cùng mạng và ổ đĩa đi kèm.
* **Docker Compose V2 (`docker compose`):** Được viết lại hoàn toàn bằng ngôn ngữ **Go** và tích hợp trực tiếp làm plugin chuẩn của Docker CLI (gõ `docker compose` có dấu cách, thay thế công cụ `docker-compose` V1 viết bằng Python đã ngừng hỗ trợ). Trong đặc tả Compose Specification hiện đại, dòng khai báo `version: '3.8'` ở đầu file đã lỗi thời và không còn cần thiết.
* **3 thành phần cốt lõi trong `compose.yaml`:**
  1. **`services`:** Định nghĩa các nhóm Container ứng dụng.
  2. **`networks`:** Định nghĩa các dải mạng ảo kết nối giữa các Services.
  3. **`volumes`:** Định nghĩa các không gian lưu trữ dữ liệu bền vững.

---

### 20. Viết và quản lý Docker Compose

#### Giải pháp kiểm soát thứ tự khởi chạy thực sự với `depends_on` + `healthcheck`
Mặc định, `depends_on: [db]` chỉ chờ cho **Container `db` được khởi tạo (Started)** chứ không chờ cho **tiến trình MySQL bên trong khởi tạo xong Socket sẵn sàng nhận kết nối (Ready)**. Để tránh lỗi Web App bị sập ngay lúc mới bật vì kết nối vào Database quá sớm, ta kết hợp `healthcheck` với `condition: service_healthy`.

#### Bảng tổng hợp các câu lệnh quản lý Docker Compose V2

| Câu lệnh | Chức năng chi tiết |
| :--- | :--- |
| `docker compose config` | Kiểm tra cú pháp file `compose.yaml` và in ra cấu hình hoàn chỉnh sau khi đã ghép biến từ file `.env`. |
| `docker compose up -d --build` | Tự động build Image, tạo Network, Volume và khởi chạy toàn bộ Services ở chế độ chạy ngầm (`-d`). |
| `docker compose down` | Dừng và xóa toàn bộ Containers cùng Network của dự án (thêm cờ `-v` nếu muốn xóa luôn cả Named Volumes). |
| `docker compose ps` | Hiển thị trạng thái hoạt động, sức khỏe (`healthy`) và cổng ánh xạ của các Services trong dự án. |
| `docker compose logs -f [service]` | Theo dõi luồng log thời gian thực của toàn bộ dự án hoặc của một Service cụ thể. |
| `docker compose exec <service> <cmd>` | Thực thi lệnh bên trong Container của một Service đang chạy (VD: `docker compose exec db bash`). |
| `docker compose build [--no-cache]` | Chủ động build hoặc build lại các Services có khai báo mục `build:`. |
| `docker compose stop / start / restart` | Tạm dừng, bật lại hoặc khởi động lại các Services mà không xóa Container. |
| `docker compose up -d --scale web=3` | Mở rộng (Scale out) nhanh số lượng bản sao Container của dịch vụ `web` lên 3 instances (Lưu ý: không khai báo `container_name` cố định và không gắn cứng 1 cổng Host duy nhất khi dùng `--scale`). |

* **Cơ chế `compose.override.yaml`:** Khi chạy `docker compose up`, Docker tự động đọc `compose.yaml` (cấu hình gốc) và tự động trộn (merge) thêm file `compose.override.yaml` (nếu có trong cùng thư mục). Rất hữu ích để giữ `compose.yaml` sạch cho môi trường chung và dùng `compose.override.yaml` để gắn Bind Mount code trực tiếp hoặc mở cổng Debug trên máy Dev.

---

### 21. Thực hành triển khai ứng dụng hoàn chỉnh bằng Docker Compose (Web Application + MySQL)

#### Cấu trúc thư mục dự án
```text
webapp-compose/
├── .env
├── compose.yaml
└── app/
    ├── Dockerfile
    ├── requirements.txt
    └── app.py
```

#### Bước 1: Tạo mã nguồn Web Application (Python Flask kết nối MySQL) và `Dockerfile`
```bash
mkdir -p ~/webapp-compose/app && cd ~/webapp-compose
```

* **Tệp `app/requirements.txt`:**
```text
flask==3.0.3
mysql-connector-python==9.0.0
```

* **Tệp `app/app.py`:**
```python
import os
from flask import Flask
import mysql.connector

app = Flask(__name__)

@app.route("/")
def index():
    try:
        conn = mysql.connector.connect(
            host=os.environ.get("DB_HOST", "db"),
            user=os.environ.get("DB_USER", "appuser"),
            password=os.environ.get("DB_PASSWORD"),
            database=os.environ.get("DB_NAME", "appdb")
        )
        cursor = conn.cursor()
        cursor.execute("SELECT VERSION();")
        db_version = cursor.fetchone()[0]
        cursor.close()
        conn.close()
        return f"Connected to MySQL successfully! MySQL Version: {db_version}\n"
    except Exception as e:
        return f"Database connection failed: {str(e)}\n", 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

* **Tệp `app/Dockerfile`:**
```dockerfile
FROM python:3.12-slim
WORKDIR /usr/src/app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
RUN useradd -m webuser
USER webuser
EXPOSE 5000
CMD ["python", "app.py"]
```

#### Bước 2: Tạo tệp biến môi trường `.env` và tệp `compose.yaml`
* **Tệp `.env`:**
```env
MYSQL_ROOT_PASSWORD=root_secret_2026
MYSQL_DATABASE=production_db
MYSQL_USER=thanh_dev
MYSQL_PASSWORD=app_secret_2026
WEB_PORT=8000
```

* **Tệp `compose.yaml`:**
```yaml
services:
  db:
    image: mysql:8.4
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - backend_net
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost", "-u", "root", "-p${MYSQL_ROOT_PASSWORD}"]
      interval: 5s
      timeout: 5s
      retries: 10

  web:
    build:
      context: ./app
      dockerfile: Dockerfile
    restart: unless-stopped
    ports:
      - "${WEB_PORT}:5000"
    environment:
      DB_HOST: db
      DB_USER: ${MYSQL_USER}
      DB_PASSWORD: ${MYSQL_PASSWORD}
      DB_NAME: ${MYSQL_DATABASE}
    depends_on:
      db:
        condition: service_healthy
    networks:
      - backend_net

volumes:
  db_data:

networks:
  backend_net:
    driver: bridge
```

#### Bước 3: Khởi động, kiểm tra Log, xử lý lỗi và triển khai lại
```bash
# 1. Kiểm tra tính hợp lệ của file cấu hình sau khi nạp biến từ .env
docker compose config

# 2. Build Image và khởi chạy toàn bộ hệ thống
docker compose up -d --build

# 3. Kiểm tra trạng thái các Container (Quan sát cột STATUS của db chuyển sang "healthy")
docker compose ps

# 4. Theo dõi Log khởi tạo của Database và Web App để kiểm tra và xử lý lỗi
docker compose logs -f db
docker compose logs --tail 50 web

# 5. Kiểm thử kết nối thực tế từ Host vào Web App (Web App gọi sang MySQL)
curl http://localhost:8000
# Kết quả: Connected to MySQL successfully! MySQL Version: 8.4.x

# 6. Truy cập trực tiếp vào MySQL CLI qua Docker Compose để kiểm tra Database
docker compose exec db mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SHOW DATABASES;"

# 7. Dừng toàn bộ hệ thống và triển khai lại (Dữ liệu trong Volume db_data vẫn được bảo toàn)
docker compose down
docker compose up -d
```

---

## TÀI LIỆU THAM KHẢO (REFERENCES)

1. [Red Hat Official Documentation - Introduction to Virtualization](https://docs.redhat.com/en/documentation/red_hat_virtualization/4.4/html/product_guide/introduction)
2. [NetApp Technical Documentation - KVM Virtualization with QEMU and Libvirt](https://docs.netapp.com/us-en/netapp-solutions-virtualization/kvm/kvm-overview.html)
3. [Libvirt Official Documentation - KVM/QEMU Hypervisor Driver](https://docs.virtuozzo.com/libvirt-docs-5.6.0/html/drvqemu.html)
4. [Intel Virtualization Technology Specification for IA-32 Architecture](https://kib.kiev.ua/x86docs/Intel/VT-x/C97063-002.pdf)
5. [Oracle VirtualBox Manual - Details About Hardware Virtualization](https://docs.oracle.com/en/virtualization/virtualbox/6.0/admin/hwvirt-details.html)
6. [StarWind Technical Blog - Thick vs. Thin Provisioning in KVM](https://www.starwindsoftware.com/blog/thick-vs-thin-provisioning-kvm/)
7. [VMware Technical Whitepaper - DRS Cluster Management with Reservation and Shares](https://www.vmware.com/docs/drs-cluster-mgmt-perf)
8. [Red Hat OpenStack Platform - Deploying SR-IOV & PCI Passthrough](https://docs.redhat.com/en/documentation/red_hat_openstack_platform/16.1/html/network_functions_virtualization_planning_and_configuration_guide/part-sriov-nfv-configuration)
9. [Docker Official Documentation - Docker Engine Security (Kernel Namespaces & Control Groups)](https://docs.docker.com/engine/security/)
10. [Strapi Engineering Guide - Docker Compose Architecture & Best Practices](https://strapi.io/blog/what-is-docker-compose-all-you-need-to-know)
