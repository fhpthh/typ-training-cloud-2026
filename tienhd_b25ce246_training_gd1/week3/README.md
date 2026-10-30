# Báo cáo Tuần 3 — Ảo hóa, Container, Docker và Docker Compose

---

## Phần 1: Tổng quan về ảo hóa

### 1. Ảo hóa là gì?

**Ảo hóa (Virtualization)** là công nghệ tạo ra phiên bản **ảo** của tài nguyên máy tính (CPU, RAM, ổ đĩa, mạng) từ tài nguyên **vật lý** bên dưới. Nhờ đó có thể chạy **nhiều máy ảo (Virtual Machine — VM) độc lập trên cùng một máy vật lý**, mỗi VM có hệ điều hành riêng và không ảnh hưởng lẫn nhau.

**Mục đích và vai trò:**

- **Tận dụng tài nguyên:** một server vật lý khỏe thay vì chạy 1 dịch vụ nhỏ nay chạy được nhiều VM → tiết kiệm chi phí mua thiết bị, điện, làm mát.
- **Cô lập (isolation):** sự cố/bảo mật của VM này không lan sang VM khác.
- **Linh hoạt:** tạo/xóa/snapshot/clone VM trong vài phút thay vì mua và lắp đặt máy thật.
- **Di động (portability):** VM là các file (qcow2/vmdk...) nên có thể copy, backup, di chuyển sang host khác (migration).
- **Nền tảng của cloud:** AWS EC2, Google Compute Engine, Azure VM đều dựa trên ảo hóa; KVM là công nghệ lõi của nhiều nhà cung cấp.

**Phân biệt Physical Machine và Virtual Machine:**

| Tiêu chí | Physical Machine (máy vật lý) | Virtual Machine (máy ảo) |
| --- | --- | --- |
| Phần cứng | CPU, RAM, đĩa thật | Tài nguyên ảo do hypervisor cấp phát từ host |
| Hệ điều hành | Chạy trực tiếp trên phần cứng | Chạy trên lớp hypervisor |
| Chi phí | Cao, mua sắm chậm | Thấp, tạo trong vài phút |
| Mở rộng | Lắp thêm RAM/ổ cứng vật lý | Cấu hình lại bằng phần mềm |
| Snapshot/Clone | Không (phải dùng giải pháp backup riêng) | Có sẵn |
| Hiệu năng | 100% phần cứng | Gần bằng (mất vài % cho lớp ảo hóa) |

### 2. Các loại ảo hóa phổ biến

- **Ảo hóa máy chủ (server virtualization):** chia một server vật lý thành nhiều VM — loại phổ biến nhất, là nội dung chính của tuần này.
- **Ảo hóa hệ điều hành (OS-level virtualization):** chia sẻ **chung kernel** của host để tạo nhiều môi trường cô lập — chính là **container** (Docker, LXC). Nhẹ hơn VM nhưng không chạy được kernel khác host.
- **Ảo hóa lưu trữ (storage virtualization):** gom nhiều ổ đĩa vật lý thành một kho logic (LVM, SAN, RAID) rồi chia cho các VM — ví dụ đĩa ảo `qcow2`, `vmdk` của VM là ảo hóa lưu trữ.
- **Ảo hóa mạng (network virtualization):** tạo mạng ảo trên hạ tầng vật lý — VLAN, **bridge ảo** (`virbr0` của libvirt, `docker0` của Docker), SDN, overlay network.

**Phân biệt Full Virtualization, Para-Virtualization và Hardware-Assisted Virtualization:**

| Tiêu chí | Full Virtualization | Para-Virtualization | Hardware-Assisted |
| --- | --- | --- | --- |
| Cách hoạt động | Hypervisor **giả lập toàn bộ phần cứng**, guest OS không cần sửa | Guest OS **được sửa để biết** mình đang chạy ảo, gọi trực tiếp API của hypervisor | CPU hỗ trợ ảo hóa phần cứng: guest chạy ở **non-root mode**, lệnh nhạy cảm tự động chuyển cho hypervisor |
| Guest OS | Không cần sửa đổi | Phải có kernel hỗ trợ (Xen PV) | Không cần sửa đổi |
| Hiệu năng | Chậm hơn (binary translation) | Khá tốt | Tốt nhất, gần native |
| Ví dụ | QEMU thuần, VMware cũ | Xen PV, virtio (một phần) | **KVM**, VMware VT-x/AMD-V, Hyper-V |

---

#### Kiểm tra CPU hỗ trợ ảo hóa (Intel VT-x / AMD-V) — minh chứng thật

```text
$ lscpu | grep -Ei "model name|virtualization"
Model name:                              12th Gen Intel(R) Core(TM) i5-12450H
Virtualization:                          VT-x

$ grep -c -E "vmx|svm" /proc/cpuinfo
24

$ lsmod | grep kvm
kvm_intel             552960  4
kvm                  1527808  3 kvm_intel
irqbypass              16384  1 kvm

$ systemd-detect-virt
none
```

- `Virtualization: VT-x` và **24 cờ `vmx`** (12 nhân × 2 luồng) → CPU hỗ trợ ảo hóa phần cứng Intel;
- module **`kvm_intel`** đã nạp → host là máy thật (`systemd-detect-virt` = `none`), sẵn sàng làm hypervisor.

### 3. Hypervisor và các công nghệ ảo hóa

**Hypervisor (Virtual Machine Monitor)** là lớp phần mềm **quản lý và cấp phát tài nguyên phần cứng cho các VM**, đồng thời cô lập các VM với nhau. Hypervisor chịu trách nhiệm: tạo/điều khiển vòng đời VM, lập lịch vCPU lên CPU vật lý, quản lý bộ nhớ (EPT/NPT), ảo hóa thiết bị I/O.

| Tiêu chí | Hypervisor Type 1 (bare-metal) | Hypervisor Type 2 (hosted) |
| --- | --- | --- |
| Chạy trên | Trực tiếp trên phần cứng | Trên một hệ điều hành host |
| Hiệu năng | Cao (không qua OS trung gian) | Thấp hơn |
| Dùng ở đâu | Server, datacenter, cloud | Máy cá nhân để học/thử nghiệm |
| Ví dụ | VMware ESXi, **KVM**, Hyper-V, Xen, Proxmox | VirtualBox, VMware Workstation, QEMU thuần |

**Một số công nghệ ảo hóa phổ biến:**

- **VMware ESXi** — Type 1, thương mại, phổ biến trong doanh nghiệp.
- **KVM (Kernel-based Virtual Machine)** — Type 1, là module trong nhân Linux, mã nguồn mở, được dùng bởi hầu hết nhà cung cấp cloud; kết hợp **QEMU** (giả lập thiết bị) + **libvirt** (`virsh`, `virt-manager`) để quản lý.
- **Microsoft Hyper-V** — Type 1, chuẩn trong Windows Server.
- **Xen** — mã nguồn mở, nền tảng của nhiều nền tảng cloud (AWS dùng Xen từng thời kỳ).
- **Proxmox VE** — bản phân phối quản trị KVM + LXC có giao diện web.
- **VirtualBox** — Type 2, miễn phí của Oracle, phù hợp học tập trên máy cá nhân.

```text
$ virsh version
Compiled against library: libvirt 12.0.0
Using library: libvirt 12.0.0
Using API: QEMU 12.0.0
Running hypervisor: QEMU 10.2.1
```

Máy thực hành dùng **KVM + QEMU + libvirt**: KVM làm hypervisor (trong nhân Linux), QEMU giả lập thiết bị, libvirt là lớp quản lý thống nhất với công cụ dòng lệnh `virsh`.

---

## Phần 2: Virtual Machine

### 4. Tổng quan về Virtual Machine

**Virtual Machine (máy ảo)** là một máy tính phần mềm mô phỏng đầy đủ một máy tính thật: có CPU ảo (vCPU), RAM ảo, đĩa ảo, card mạng ảo... do hypervisor cấp phát từ tài nguyên của máy vật lý.

**Kiến trúc một máy ảo:**

```text
+-------------------------------+-------------------------------+
|            VM 1               |            VM 2               |
|  +-------------------------+  |  +-------------------------+  |
|  |  Application            |  |  |  Application            |  |
|  |  Guest OS (Ubuntu...)   |  |  |  Guest OS (Windows...)  |  |
|  +-------------------------+  |  +-------------------------+  |
|  vCPU | vRAM | vDisk | vNIC  |  |  vCPU | vRAM | vDisk | vNIC  |
+-------|------|-------|-------+--+-------|------|-------|-------+
        |      |       |                 |      |       |
+-------v------v-------v-----------------v------v-------v-------+
|                        HYPERVISOR (KVM)                       |
+---------------------------------------------------------------+
|              Host OS (Ubuntu) — Host Hardware                  |
+---------------------------------------------------------------+
```

**Host OS và Guest OS:**

| Khái niệm | Vai trò |
| --- | --- |
| **Host OS** | Hệ điều hành của máy vật lý, chạy hypervisor và trực tiếp quản lý phần cứng |
| **Guest OS** | Hệ điều hành chạy **bên trong máy ảo**, chỉ nhìn thấy tài nguyên ảo |

**Các thành phần được ảo hóa:**

- **CPU (vCPU):** mỗi vCPU là một thread lập lịch trên nhân CPU vật lý; host `i5-12450H` có 12 CPU (8P + 4E) nhưng có thể cấp nhiều vCPU hơn cho các VM nhờ **overcommit**.
- **Memory (RAM):** bộ nhớ ảo có thể là **overcommit** (tổng RAM các VM > RAM thật, dùng swap/ballooning) hoặc cấp phát cứng; hỗ trợ hot-plug tăng/giảm khi VM chạy (tới giới hạn `maxmem`).
- **Disk (Virtual Disk):** file trên host chứa toàn bộ ổ đĩa của guest; định dạng phổ biến:
  - `qcow2` (**KVM/QEMU**, hỗ trợ snapshot, sparse — dùng trong bài này),
  - `vmdk` (VMware), `vdi` (VirtualBox), `vhd/vhdx` (Hyper-V).
  - **Thin provisioning:** dung lượng file tăng dần theo dữ liệu thật (`qcow2` sparse — VM 30 GiB chỉ chiếm ~3.8 GiB host); **Thick provisioning:** cấp phát đủ ngay từ đầu, hiệu năng ổn định hơn.
- **Network Interface (vNIC):** card mạng ảo với các chế độ:
  - **NAT** (mạng `default` của libvirt — dải `192.168.122.0/24`): VM ra Internet được nhưng bên ngoài khó truy cập vào VM — chế độ đang dùng;
  - **Bridged:** VM nối trực tiếp vào mạng vật lý, có IP cùng dải LAN với host;
  - **Host-only:** VM chỉ nói chuyện được với host.

**Chia sẻ tài nguyên giữa các VM (cơ chế của hypervisor):**

| Cơ chế | Ý nghĩa |
| --- | --- |
| **Overcommit** | Cấp phát tổng tài nguyên (vCPU/RAM) lớn hơn tài nguyên thật cho các VM — tận dụng việc hiếm khi mọi VM dùng hết tài nguyên cùng lúc |
| **Reservation** | Mức tài nguyên **tối thiểu được đảm bảo** cho VM |
| **Limit** | Mức **tối đa** VM được dùng |
| **Shares** | Trọng số chia tài nguyên khi các VM **tranh nhau** (VM shares cao được ưu tiên hơn khi host quá tải) |

### 5. Cơ chế hoạt động của máy ảo

**Nguyên lý:** Guest OS không chạy trực tiếp các lệnh "nhạy cảm" (thao tác phần cứng, quản lý bộ nhớ...). Khi gặp lệnh như vậy:

1. Nếu là **lệnh không nhạy cảm** (tính toán thông thường) → vCPU chạy thẳng trên nhân vật lý.
2. Nếu là **lệnh nhạy cảm** → CPU (nhờ VT-x/AMD-V) tự động **trap** sang hypervisor xử lý hộ → quay lại guest.

Nhờ đó "máy ảo" vẫn là **một tiến trình bình thường trên host** (`qemu-system-x86_64` / `qemu-kvm`) do libvirt quản lý.

**Hardware-Assisted Virtualization — root mode / non-root mode:**

| Khái niệm | Mô tả |
| --- | --- |
| **Root mode** | Chế độ của hypervisor/KVM (đặc quyền) |
| **Non-root mode** | Chế độ guest OS và ứng dụng đang chạy (bị giới hạn quyền) |
| **VM Exit** | Guest gặp lệnh nhạy cảm → CPU chuyển từ non-root sang root mode để hypervisor xử lý |
| **VM Entry** | Hypervisor xử lý xong → chuyển quyền trở lại guest |

- **Ảo hóa CPU:** vCPU là các thread của tiến trình QEMU, được **lập lịch bởi nhân host** như mọi tiến trình khác; khi host tải cao, nhân host quyết định vCPU nào được chạy trước.
- **Ảo hóa bộ nhớ:** địa chỉ được dịch **hai tầng** — Guest Virtual → Guest Physical (do guest quản lý) → Host Physical (do hypervisor quản lý). CPU hỗ trợ **EPT (Intel)** / **NPT (AMD)** để việc dịch tầng hai diễn ra bằng phần cứng, giảm VM Exit.
- **Ảo hóa I/O:**
  - **Emulation:** QEMU giả lập thiết bị (card e1000, IDE...) — tương thích cao nhưng chậm;
  - **Para-virtualization — `virtio`:** driver đặc biệt trong guest nói chuyện trực tiếp với hypervisor qua ring buffer — hiệu năng cao hơn; máy ảo `lab-ubuntu-01` dùng virtio (đĩa `vda`, NIC `enp1s0`);
  - **PCI Passthrough:** gán nguyên một thiết bị PCI (VD: GPU) cho VM — gần như native;
  - **SR-IOV:** một card mạng vật lý tạo ra nhiều "function" ảo gán trực tiếp cho nhiều VM.

**Mô hình KVM + QEMU + libvirt (máy thực hành đang dùng):**

```text
virsh / virt-manager / virt-install         <-- công cụ quản lý
        |  (libvirt API)
        v
   libvirtd (daemon quản lý VM, storage, network)
        |  (gọi QEMU)
        v
qemu-system-x86_64 -enable-kvm ...          <-- tiến trình máy ảo
        |  (ioctl)
        v
      /dev/kvm  ->  module kvm_intel  ->  VT-x trên CPU vật lý
```

### 6. Vòng đời và quản lý VM

**Các trạng thái của VM (libvirt):**

| Trạng thái | Ý nghĩa |
| --- | --- |
| **Created / shut off** | Đã định nghĩa nhưng chưa chạy |
| **Running** | Đang chạy |
| **Paused** | Tạm dừng (giữ nguyên trong RAM) |
| **Stopped / shut off** | Đã tắt (khác "Paused") |

**Các thao tác quản lý chính:**

- **Tạo VM:** `virt-install` (từ ISO/cloud image), hoặc định nghĩa từ XML (`virsh define`); **khởi động:** `virsh start` / `virsh create`; **tắt "mềm" (ACPI):** `virsh shutdown`; **tắt "cứng" (rút điện):** `virsh destroy`; **xóa định nghĩa:** `virsh undefine --remove-all-storage` (kèm `--nvram` với VM UEFI).
- **Cấp phát / điều chỉnh tài nguyên:** `virsh setvcpus`, `virsh setmem` (`--config` = áp dụng lần khởi động sau, `--live` = áp dụng ngay nếu CPU/RAM hot-plug được hỗ trợ), `virsh blockresize` + `growpart`/`lvextend`/`resize2fs` bên trong guest để nới ổ đĩa.
- **Snapshot:** "ảnh chụp" toàn bộ trạng thái VM (đĩa + tùy chọn cả RAM) tại một thời điểm → `virsh snapshot-create-as`; quay lại bằng `virsh snapshot-revert`.
- **Clone:** tạo VM mới từ VM có sẵn (`virt-clone`), có thể dùng làm template.
- **Template:** VM "chuẩn" (thường đã cấu hình sẵn, sysprep/cloud-init) dùng để nhân bản nhanh hàng loạt.
- **Backup / Restore:** backup = file đĩa ảo + file XML định nghĩa (`virsh dumpxml`); restore = tạo volume mới từ file đĩa + `virsh define` XML.
- **Live Migration:** chuyển VM đang chạy sang host khác gần như không gián đoạn (cùng storage chung hoặc `--live` copy RAM).
- **High Availability (HA):** khi host lỗi, cụm tự động khởi động lại VM trên host khác (cần shared storage + cluster).

### 7. Thực hành quản lý VM (KVM/libvirt)

> Toàn bộ minh chứng dưới đây chạy thật trên host `victus` với máy ảo **`lab-ubuntu-01`** (đã cài Ubuntu 26.04 LTS Server từ ISO trong ổ `~/Downloads`; VM dùng firmware UEFI, đĩa `qcow2` 25 GiB trên LVM).

#### 7.1 Kiểm tra CPU hỗ trợ ảo hóa, cài KVM

Đã trình bày ở mục 2: VT-x có sẵn, module `kvm_intel` đã nạp, bộ công cụ **KVM + QEMU + libvirt** đã cài (`virsh version` in ra libvirt 12.0.0 / QEMU 10.2.1). Không dùng VirtualBox vì đề bài cho phép chọn **VirtualBox hoặc KVM**, và máy đã có sẵn KVM.

#### 7.2 Quan sát tài nguyên ảo bên trong VM

Kết nối vào VM qua SSH (đã cấu hình key để không cần mật khẩu), sau đó chạy các lệnh kiểm tra:

```text
$ ssh student@192.168.122.40 'lscpu; free -h; lsblk; ip -br addr'
CPU(s):                                  2
Model name:                              12th Gen Intel(R) Core(TM) i5-12450H
Virtualization:                          VT-x
Hypervisor vendor:                       KVM
Virtualization type:                     full

               total        used        free      shared  buff/cache   available
Mem:           2.5Gi       412Mi       1.9Gi       5.0Mi       374Mi       2.1Gi
Swap:          1.9Gi          0B       1.9Gi

NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sr0                        11:0    1 1024M  1 rom
vda                       253:0    0   25G  0 disk
├─vda1                    253:1    0    1G  0 part /boot/efi
├─vda2                    253:2    0    2G  0 part /boot
└─vda3                    253:3    0 21.9G  0 part
  └─ubuntu--vg-ubuntu--lv 252:0    0   11G  0 lvm  /

lo               UNKNOWN        127.0.0.1/8 ::1/128
enp1s0           UP             192.168.122.40/24 metric 100 fe80::5054:ff:fe68:30b6/64
```

**Nhận xét:** VM thấy **đúng tài nguyên ảo được cấp** (2 vCPU, ~2.5 GiB RAM khả dụng, đĩa 25 GiB); `Hypervisor vendor: KVM`, `Virtualization type: full` → guest nhận biết mình chạy dưới KVM. Phần RAM chênh lệch so với 3 GiB cấu hình là do kernel guest **giữ riêng cho crashkernel** (tham số `crashkernel=2G-4G:320M`) và một phần được nhân giữ cho chính nó.

#### 7.3 Tạo — Khởi động — Tắt — Xóa VM

Tình trạng ban đầu: VM đã được tạo từ trước và đang tắt.

```text
$ virsh list --all
 Id   Name            State
--------------------------------
 -    lab-ubuntu-01   shut off

$ virsh start lab-ubuntu-01
Domain 'lab-ubuntu-01' started

$ virsh list --all
 Id   Name            State
-------------------------------
 1    lab-ubuntu-01   running

$ virsh shutdown lab-ubuntu-01        # tắt "mềm" qua ACPI
Domain 'lab-ubuntu-01' is being shutdown
$ virsh domstate lab-ubuntu-01
shut off
```

Tạo VM mới bằng **clone** (xem 7.5) và xóa bằng `virsh destroy` + `virsh undefine --nvram --remove-all-storage` (xem 7.6) — đây là 2 thao tác "tạo/xóa" thực tế trong bài.

#### 7.4 Điều chỉnh CPU, RAM (khi VM tắt) và ổ đĩa (khi VM đang chạy)

**a) vCPU/RAM — thử live trước, thấy bị giới hạn nên đổi qua `--config`:**

```text
$ virsh setvcpus lab-ubuntu-01 1 --live     # thử giảm CPU khi VM đang chạy
error: unsupported configuration: failed to find appropriate hotpluggable vcpus
to reach the desired target vcpu count

$ virsh shutdown lab-ubuntu-01
$ virsh setvcpus lab-ubuntu-01 1 --config   # 2 -> 1 vCPU cho lần boot sau
$ virsh setmem  lab-ubuntu-01 2G --config   # 3G -> 2G RAM
$ virsh dominfo lab-ubuntu-01 | grep -E 'CPU\(s\)|memory'
CPU(s):         1
Max memory:     3145728 KiB
Used memory:    2097152 KiB
```

Sau khi khởi động lại, **bên trong VM xác nhận cấu hình mới có hiệu lực**:

```text
$ nproc
1
$ free -h
               total        used        free      shared  buff/cache   available
Mem:           1.5Gi       370Mi       988Mi       5.0Mi       294Mi       1.1Gi
```

> **Bài học:** vCPU hot-unplug yêu cầu vCPU phải được đánh dấu *hotpluggable* (cấu hình topology có slot trống). Với VM nhỏ này không có slot → phải đổi khi VM tắt. Đây chính là mặt hạn chế của thao tác "nóng" so với "nguội".

Sau khi thực hành xong, đổi lại **2 vCPU / 3G RAM** tương tự và khởi động lại — VM hiển thị `nproc = 2`, `free -h` tổng ~2.5Gi như ban đầu.

**b) Mở rộng ổ đĩa khi VM đang chạy (25 GiB → 30 GiB):**

```text
$ virsh blockresize lab-ubuntu-01 vda 30G      # nới "vỏ" đĩa ảo trên host
Block device 'vda' is resized

$ ssh student@192.168.122.40 'lsblk /dev/vda'  # VM đã thấy đĩa to hơn...
vda    253:0    0   30G  0 disk
├─vda1 253:1    0    1G  0 part /boot/efi
├─vda2 253:2    0    2G  0 part /boot
└─vda3 253:3    0 21.9G  0 part            <-- nhưng phân vùng chưa giãn
```

Muốn dùng được phần dung lượng mới phải giãn **từ trong guest** (partition → LVM → filesystem). Guest đang dùng LVM nên thao tác theo đúng thứ tự:

```text
# growpart /dev/vda 3        # giãn phân vùng 3 lên hết đĩa
CHANGED: partition=3 start=6397952 old: size=46028800 end=52426751 new: size=56516575 end=62914526
# pvresize /dev/vda3         # báo LVM biết physical volume lớn hơn
  Physical volume "/dev/vda3" changed
# lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
  Size of logical volume ubuntu-vg/ubuntu-lv changed from 10.97 GiB (2809 extents) to <26.95 GiB (6898 extents).
# resize2fs /dev/ubuntu-vg/ubuntu-lv
The filesystem on /dev/ubuntu-vg/ubuntu-lv is now 7063552 (4k) blocks long.

$ lsblk; df -h /
vda                   253:0    0   30G  0 disk
└─vda3                253:3    0 26.9G  0 part
  └─ubuntu--vg-ubuntu--lv 252:0    0 26.9G  0 lvm  /
/dev/mapper/ubuntu--vg-ubuntu--lv   27G  4.9G   21G  20% /
```

→ Ổ đĩa gốc của VM từ **11 GiB (đầy 48%)** thành **27 GiB (dùng 20%)**, thực hiện **không cần tắt VM**.

#### 7.5 Snapshot — Revert

**Quy trình:** tạo file mốc → tạo snapshot → tạo thêm file mới → revert → kiểm tra file mới biến mất.

```text
$ ssh student@... 'echo "File nay tao TRUOC khi snapshot" > ~/truoc-snapshot.txt; ls -l ~/truoc-snapshot.txt'
-rw-rw-r-- 1 student student 32 Oct 13 08:45 /home/student/truoc-snapshot.txt

$ virsh shutdown lab-ubuntu-01                 # snapshot an toàn nhất khi VM tắt
$ virsh snapshot-create-as lab-ubuntu-01 base-clean "Trang thai sach truoc khi thuc hanh"
Domain snapshot base-clean created

$ virsh snapshot-list lab-ubuntu-01
 Name         Creation Time               State
---------------------------------------------------
 base-clean   2026-10-13 15:45:59 +0700   shutoff

$ virsh start lab-ubuntu-01
$ ssh student@... 'echo "File nay tao SAU khi snapshot" > ~/sau-snapshot.txt; ls -l ~/*snapshot.txt'
-rw-rw-r-- 1 student student 30 ... /home/student/sau-snapshot.txt
-rw-rw-r-- 1 student student 32 ... /home/student/truoc-snapshot.txt

$ virsh shutdown lab-ubuntu-01
$ virsh snapshot-revert lab-ubuntu-01 base-clean      # quay lại thời điểm snapshot
Domain snapshot base-clean reverted

$ virsh start lab-ubuntu-01
$ ssh student@... 'ls -l ~/*snapshot.txt'
-rw-rw-r-- 1 student student 32 ... /home/student/truoc-snapshot.txt
```

**Kết quả:** file `sau-snapshot.txt` (tạo sau snapshot) **đã biến mất**, file `truoc-snapshot.txt` vẫn còn → revert trả VM về đúng trạng thái tại thời điểm chụp.

#### 7.6 Clone VM

```text
$ virsh shutdown lab-ubuntu-01
$ virt-clone --original lab-ubuntu-01 --name lab-ubuntu-02 --auto-clone
WARNING  The requested volume capacity will exceed the available pool space when
the volume is fully allocated. (30720 M requested capacity > 17099 M available)
ERROR    The requested volume capacity will exceed the available pool space ...

$ virt-clone --original lab-ubuntu-01 --name lab-ubuntu-02 --auto-clone --check disk_size=off
Clone 'lab-ubuntu-02' created successfully.
```

> **Lỗi gặp phải và cách xử lý:** mặc định `virt-clone` kiểm tra theo kiểu *thick* (cần đủ 30 GiB trống dù đĩa thực chỉ chiếm ~3.8 GiB). Vì pool `default` không đủ chỗ *fully allocated*, thêm `--check disk_size=off` để chấp nhận đĩa **sparse**.

Kiểm tra VM clone **hoạt động độc lập** (MAC, UUID, IP mới — nội dung đĩa giống bản gốc):

```text
$ virsh start lab-ubuntu-02
$ ssh student@192.168.122.15 'hostname; cat /etc/machine-id; ip -br addr | grep -v LOOPBACK'
lab-ubuntu-01
f6be597d34cc40c49ed0e2b229a21483
enp1s0           UP             192.168.122.15/24 ...

$ virsh dumpxml lab-ubuntu-01 | grep -E "mac address|<uuid>"
  <uuid>f6be597d-34cc-40c4-9ed0-e2b229a21483</uuid>
      <mac address='52:54:00:68:30:b6'/>
$ virsh dumpxml lab-ubuntu-02 | grep -E "mac address|<uuid>"
  <uuid>37cf2081-447f-4ee0-aa25-133bbdf949ca</uuid>
      <mac address='52:54:00:f4:3a:f8'/>
```

**Lưu ý thực tế:** clone là **bản sao đĩa**, nên **hostname và machine-id giữ nguyên** → nên đổi hostname/`/etc/machine-id` (hoặc dùng `cloud-init`/`sysprep`) trước khi dùng VM clone trong môi trường thật; nếu không sẽ trùng IP/hostname dịch vụ.

Xóa VM clone (đúng cách, vì VM dùng UEFI nên phải kèm `--nvram`):

```text
$ virsh destroy lab-ubuntu-02
Domain 'lab-ubuntu-02' destroyed
$ virsh undefine lab-ubuntu-02 --nvram --remove-all-storage
Domain 'lab-ubuntu-02' has been undefined
Volume 'vda'(/var/lib/libvirt/images/lab-ubuntu-02.qcow2) removed.
```

#### 7.7 Export / Backup — Restore VM

**a) Backup:**

- Backup **định nghĩa** VM — file XML nhỏ (~8 KB):
  ```text
  $ virsh dumpxml lab-ubuntu-01 > docker-lab/week3/lab-ubuntu-01-backup.xml
  ```
- Backup **đĩa** VM — "export" toàn bộ nội dung đĩa ảo ra file để cất giữ (`--sparse` giữ nguyên các vùng trống, không phình thành 30 GiB):
  ```text
  $ virsh vol-download --pool default --vol lab-ubuntu-01.qcow2 --sparse ./lab-ubuntu-01-backup.qcow2
  $ ls -lh
  -rw-rw-r-- 1 tien tien 26G ... lab-ubuntu-01-backup.qcow2      # "26G" là kích thước biểu kiến (sparse)

  $ qemu-img info ./lab-ubuntu-01-backup.qcow2
  file format: qcow2
  virtual size: 30 GiB (32212254720 bytes)
  disk size: 3.81 GiB                                           # thực chiếm chỉ 3.81 GiB
  Snapshot list:
  ID      TAG               VM_SIZE                DATE
  1       base-clean            0 B 2026-10-13 15:45:59        # snapshot cũng nằm trong backup
  ```
- Với VM quan trọng có thể backup ở mức **guest** thêm: snapshot rồi copy, hoặc dùng giải pháp chuyên dụng (Borg, Veeam...). Một bản backup đầy đủ gồm **XML + file đĩa**.

**b) Restore (thực hành thật):** kịch bản: dữ liệu trong VM bị "hỏng" → khôi phục từ backup.

```text
# 1) Gây hư hỏng trên VM
$ ssh student@192.168.122.40 'rm ~/truoc-snapshot.txt; echo "du lieu hong" > ~/hong.txt; ls ~'
hong.txt

$ virsh shutdown lab-ubuntu-01

# 2) Restore đĩa từ bản backup (VM phải đang tắt)
$ virsh vol-upload --pool default --vol lab-ubuntu-01.qcow2 --sparse ./lab-ubuntu-01-backup.qcow2

# 3) Khởi động lại và kiểm tra
$ virsh start lab-ubuntu-01
$ ssh student@192.168.122.40 'ls ~; cat ~/truoc-snapshot.txt'
truoc-snapshot.txt
File nay tao TRUOC khi snapshot
```

**Kết quả:** file "hỏng" `hong.txt` đã biến mất, file `truoc-snapshot.txt` được khôi phục nguyên vẹn → quy trình backup/restore hoạt động đúng.

> **Chú ý khi backup VM đang chạy:** file đĩa có thể ở trạng thái "không nhất quán" (như rút điện). Cách an toàn: tắt VM, hoặc snapshot/`fsfreeze` trước, hoặc backup mức guest (dump DB, tar dữ liệu) kết hợp.

---

## Phần 3: Tổng quan về Container

### 8. Container là gì?

**Container** là một cách **đóng gói ứng dụng cùng toàn bộ thư viện, phụ thuộc và cấu hình** cần thiết để chạy, đảm bảo ứng dụng chạy giống hệt nhau trên mọi môi trường (máy dev, CI, server, cloud).

**Containerization** là phương pháp **ảo hóa ở mức hệ điều hành (OS-level virtualization)**: các container **dùng chung nhân (kernel) của host**, nhưng được **cô lập** với nhau bằng các tính năng của nhân Linux (namespace, cgroup).

**Mục đích sử dụng trong phát triển và triển khai:**

- **"Build once, run anywhere"** — hết cảnh "chạy được trên máy em" do khác phiên bản thư viện.
- **Triển khai nhanh, nhẹ:** container khởi động trong **vài giây**, image có thể chứa đúng những gì cần thiết.
- **Cô lập** các dịch vụ (web, DB, cache) trên cùng một máy mà không xung đột.
- **Nhất quán giữa các môi trường**: phát triển, test, production dùng cùng một image.
- **Nền tảng của microservices, CI/CD, Kubernetes**: mỗi service là 1 container, dễ scale/rollback.

**Phân biệt Container và Virtual Machine:**

| Tiêu chí | **Container** | **Virtual Machine** |
| --- | --- | --- |
| Lớp ảo hóa | OS-level (dùng chung kernel host) | Hardware-level (hypervisor giả lập phần cứng) |
| Hệ điều hành | Chỉ chứa app + thư viện; dùng kernel host | Có **kernel riêng** (guest OS đầy đủ) |
| Kích thước | Vài MB → vài trăm MB | Vài GB |
| Thời gian khởi động | Vài giây | Vài chục giây → vài phút |
| Mức cô lập | Thấp hơn (chung kernel) | Cao hơn (ranh giới phần cứng + hypervisor) |
| Chạy OS khác host | Không (Linux container cần kernel Linux) | Có (Linux host chạy được Windows guest...) |
| Hiệu năng | Gần như native | Gần native, mất vài % |
| Mật độ trên 1 host | Rất cao (hàng trăm) | Thấp hơn (vài chục) |

**Hạn chế của Container và khi nào nên dùng VM:**

- **Bảo mật/kernel dùng chung:** thoát được khỏi container có thể ảnh hưởng host — dùng VM khi cần ranh giới bảo mật mạnh (multi-tenant, chạy code không tin cậy).
- **Cần hệ điều hành khác:** Windows guest trên Linux host, các distro khác hẳn... → dùng VM.
- **Cần kernel tùy chỉnh / module nhân:** container không cài được module cho kernel host → dùng VM.
- **Ứng dụng legacy cần cấu hình máy "đầy đủ" / license theo máy:** VM phù hợp hơn.
- Thực tế hiện đại thường **kết hợp**: VM để cô lập tenant, container để đóng gói dịch vụ — ví dụ các cloud chạy container trong VM.

### 9. Cơ chế hoạt động của Container trên Linux

**Container dùng chung Linux Kernel như thế nào?** Container **không** giả lập phần cứng và **không** có kernel riêng. Nó là một **tiến trình bình thường trên host**, nhưng:

1. Bị **cô lập** khỏi phần còn lại của hệ thống bằng **namespace** (nhìn thấy "thế giới" riêng: PID, mạng, mount...);
2. Bị **giới hạn tài nguyên** bằng **cgroup** (được dùng bao nhiêu CPU/RAM...);
3. Chạy trên một **root filesystem riêng** lắp ghép từ các layer của image (Union Filesystem/OverlayFS).

#### a) Linux Namespace — cô lập tiến trình

**Namespace** giới hạn "tầm nhìn" của tiến trình: mỗi loại namespace cô lập một tài nguyên hệ thống.

| Namespace | Cô lập cái gì | Ý nghĩa trong container |
| --- | --- | --- |
| `pid` | Danh sách tiến trình | Tiến trình trong container thấy mình là **PID 1**, không thấy tiến trình host |
| `net` | Card mạng, bảng định tuyến, cổng | Container có `eth0`, IP, route riêng |
| `mnt` | Điểm mount | Container có cây thư mục ` / ` riêng từ image |
| `uts` | Hostname, domain name | Container có hostname riêng (mặc định = ID container) |
| `ipc` | Shared memory, semaphore | Không "thấy" IPC của host/các container khác |
| `user` | UID/GID | Có thể map root trong container ≠ root trên host |


#### b) Control Groups (cgroups) — giới hạn tài nguyên

**cgroup** không cô lập mà **đo và giới hạn** tài nguyên: CPU, RAM, I/O, số tiến trình... Trên hệ thống hiện đại là **cgroup v2** (`/sys/fs/cgroup`, driver `systemd` — xem `docker info`: `Cgroup Version: 2, Cgroup Driver: systemd`). Docker tạo cho mỗi container một cgroup riêng và ghi các giới hạn (`memory.max`, `cpu.max`...) khi bạn truyền `--memory`, `--cpus`...

```text
$ docker run -d --name cg-demo --memory 128m --cpus 0.5 alpine sleep 300
833394f35d6b4753b7afb2c6a5cc0a958eccb5a8f4c66e27ff7ef28e5914fd98

$ docker inspect cg-demo --format '{{.HostConfig.Memory}} bytes | {{.HostConfig.NanoCpus}} nano CPUs'
134217728 bytes | 500000000 nano CPUs          # 128 MiB RAM | 0.5 CPU

$ docker exec cg-demo cat /sys/fs/cgroup/memory.max /sys/fs/cgroup/cpu.max   # nhìn từ trong container
134217728
50000 100000                                    # cpu.max = 50ms/100ms => 0.5 CPU

$ cat /sys/fs/cgroup/system.slice/docker-$(docker inspect -f '{{.Id}}' cg-demo).scope/memory.max
134217728                                       # phía host cũng thấy đúng giới hạn

$ docker stats --no-stream cg-demo
CONTAINER ID   NAME      CPU %     MEM USAGE / LIMIT     MEM %     NET I/O         BLOCK I/O      PIDS
833394f35d6b   cg-demo   0.00%     712KiB / 128MiB       0.54%     650B / 84B      8.19kB / 0B    1
```

→ Container bị "khóa" đúng **128 MiB RAM / 0.5 CPU**; nếu vượt RAM, tiến trình bị OOM-kill bên trong container chứ không ăn hết RAM host.

#### c) Union Filesystem — OverlayFS và Copy-on-Write

Image Docker được cấu tạo từ nhiều **layer chỉ đọc**. Khi chạy container, Docker lắp thêm **một layer ghi được (upper)** lên trên các layer gốc (lower) bằng **OverlayFS**:

```text
   [ Upper layer — ghi được ]   <-- mọi thay đổi của container ghi vào đây
   [ Layer 3 (read-only)   ]
   [ Layer 2 (read-only)   ]    <-- image layers, dùng chung cho mọi container
   [ Layer 1 (read-only)   ]
   ==========================
   Merged view: "/" của container
```

- **Khi container đọc file:** lấy từ layer gốc (rất nhanh).
- **Khi container sửa/xóa file:** nhờ **Copy-on-Write**, OverlayFS copy file đó lên upper layer rồi sửa bản copy — **layer gốc không đổi**.
- **Hệ quả:** nhiều container cùng image **chia sẻ các layer gốc**; xóa container là xóa upper layer, "tắt" luôn mọi thay đổi (dữ liệu không bền — vì vậy cần **volume**, xem mục 18).

#### d) Container Image vs Container Runtime

| | **Container Image** | **Container Runtime** |
| --- | --- | --- |
| Là gì | "Bản thiết kế" **chỉ đọc**: các layer + metadata (ENV, CMD...) | Phần mềm **tạo và chạy** container từ image |
| Ví dụ | `nginx:1.27-alpine`, `mysql:8.0` | **runc** (low-level), **containerd** (high-level), Docker Engine |
| Vòng đời | Build → push → pull → lưu registry | Chạy: tạo namespace, cgroup, mount rootfs → chạy tiến trình |

Quan hệ trong máy thực hành:

```text
docker CLI  →  dockerd  →  containerd  →  containerd-shim-runc-v2  →  runc  →  tiến trình container
```

(`runc 1.3.5`, `containerd 2.2.4` — xem `docker version` ở mục 11; quy trình chi tiết ở mục 16.)

#### e) Chuẩn OCI (Open Container Initiative)

Docker và các sản phẩm khác đều tuân theo **chuẩn mở OCI** do Linux Foundation quản lý:

- **OCI Image Spec:** quy định định dạng image (manifest, config, layer tar) → image build bởi Docker chạy được trên Kubernetes/containerd/podman.
- **OCI Runtime Spec:** quy định cách chạy container (file `config.json`: namespace, cgroup, mount, tiến trình) → **runc** là runtime chuẩn tham chiếu.

---

## Phần 4: Docker cơ bản

### 10. Tổng quan về Docker

**Docker** là nền tảng **đóng gói, phân phối và chạy ứng dụng trong container**, ra đời năm 2013, đã phổ cập containerization bằng cách: đơn giản hóa trải nghiệm người dùng (CLI + image registry), đưa ra định dạng image chuẩn, và hệ sinh thái công cụ hoàn chỉnh.

**Tại sao cần Docker?**

- Giải quyết triệt để vấn đề "chạy được trên máy tôi nhưng không chạy được trên server" nhờ image **bất biến**.
- Tận dụng tài nguyên tốt hơn VM, khởi động nhanh, phù hợp **microservices** và **CI/CD**.
- Chuẩn hóa quy trình từ dev → test → production, hỗ trợ scale ngang dễ dàng.

**Các thành phần của Docker Platform:**

| Thành phần | Vai trò |
| --- | --- |
| **Docker Engine** | Client + Server: CLI, `dockerd`, API — phần lõi để build/run container |
| **Docker Registry / Docker Hub** | Kho chứa image (`docker pull`/`docker push`) |
| **Docker Compose** | Định nghĩa và chạy nhiều container bằng file YAML |
| **Docker Buildx / BuildKit** | Engine build hiện đại, cache thông minh, multi-platform, multi-stage |
| **Docker Desktop** | Bộ cài gọn cho Windows/macOS (kèm GUI, Kubernetes...) |

**Docker Engine và Docker Desktop:** Engine là **thành phần chạy nền trên Linux** (máy thực hành dùng bản này); Desktop là gói **dành cho máy cá nhân Windows/macOS** — bên trong vẫn đóng gói một Engine (thường chạy qua VM Linux) và thêm GUI.

**Docker CE và sản phẩm doanh nghiệp:** **Docker CE (Community Edition)** miễn phí, đủ cho hầu hết nhu cầu (máy thực hành dùng bản này); **Docker EE / sản phẩm thương mại** (Docker Business, Docker Desktop Enterprise...) thêm SSO, quản lý chính sách, hỗ trợ chuyên nghiệp, audit... dành cho doanh nghiệp lớn.

**Docker Image, Container, Registry:**

- **Image:** template chỉ đọc, gồm các layer + metadata.
- **Container:** phiên bản đang chạy (hoặc đã dừng) của image — chạy trên upper layer riêng.
- **Registry:** kho chứa image — **Docker Hub** là mặc định (`docker.io`), ngoài ra có GHCR, ECR, registry tự dựng...

**Quy trình Build → Ship → Run:**

```text
Dockerfile  --build-->  Image  --push-->  Registry  --pull-->  Image --run--> Container
 (mã nguồn)             (đóng gói)      (Docker Hub)          (máy đích)     (thực thi)
```

### 11. Cài đặt và cấu hình Docker trên Linux


> Các bước cài đặt chuẩn (tham khảo):
> ```bash
> sudo apt update && sudo apt install -y ca-certificates curl gnupg
> sudo install -m 0755 -d /etc/apt/keyrings
> curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
>   sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
> echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] \
>   https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
>   | sudo tee /etc/apt/sources.list.d/docker.list
> sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io \
>   docker-buildx-plugin docker-compose-plugin
> ```

**Chạy Docker không cần sudo và lưu ý bảo mật:**

```text
$ groups
tien sudo users libvirt docker kvm
```

User `tien` thuộc nhóm **`docker`** → gọi được `docker` không cần `sudo`.

> **Lưu ý bảo mật (quan trọng):** thêm user vào nhóm `docker` **tương đương cấp quyền root** — vì có thể chạy container mount `/` của host, sửa file hệ thống... Nếu máy có nhiều người dùng, nên dùng **rootless Docker** hoặc cấp qua sudo với giới hạn.

**Kiểm tra Docker:**

```text
$ docker version
Client: Docker Engine - Community
 Version:           29.5.3
 API version:       1.54
Server: Docker Engine - Community
 Engine:
  Version:          29.5.3
  API version:      1.54 (minimum version 1.40)
 containerd:
  Version:          v2.2.4
 runc:
  Version:          1.3.5
 docker-init:
  Version:          0.19.0

$ docker info                   # (trích)
 Containers: 12
  Running: 8
 Images: 20
 Server Version: 29.5.3
 Storage Driver: overlayfs
  driver-type: io.containerd.snapshotter.v1
 Logging Driver: json-file
 Cgroup Driver: systemd
 Cgroup Version: 2
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 runc
 Default Runtime: runc
 Kernel Version: 7.0.0-38-generic
 Operating System: Ubuntu 26.04 LTS
 CPUs: 12
 Total Memory: 14.78GiB
 Docker Root Dir: /var/lib/docker
 Insecure Registries:
  ::1/128
  127.0.0.0/8
```

**Quản lý dịch vụ Docker với systemd:**

```text
$ systemctl is-enabled docker; systemctl is-active docker
enabled
active

$ systemctl status docker --no-pager | head -6
● docker.service - Docker Application Container Engine
     Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; preset: enabled)
     Active: active (running) since Tue 2026-10-13 15:23:37 +07; 9h ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 1996 (dockerd)
```

```bash
sudo systemctl start|stop|restart|status docker   # điều khiển dịch vụ
sudo systemctl enable|disable docker              # bật/tắt tự khởi động cùng máy
```

**Cấu hình Docker Proxy** (dùng khi máy nằm sau proxy công ty — máy lab này đi Internet trực tiếp nên không cấu hình):

- **Proxy cho Docker Daemon** (dockerd cần proxy để pull image): tạo file `/etc/systemd/system/docker.service.d/http-proxy.conf`:
  ```ini
  [Service]
  Environment="HTTP_PROXY=http://proxy.company.com:3128"
  Environment="HTTPS_PROXY=http://proxy.company.com:3128"
  Environment="NO_PROXY=localhost,127.0.0.1,10.0.0.0/8"
  ```
  rồi `sudo systemctl daemon-reload && sudo systemctl restart docker`.
- **Proxy cho Docker Client** (CLI khi gọi API qua mạng): biến môi trường `HTTP_PROXY`/`HTTPS_PROXY` trong shell hoặc file `~/.docker/config.json`:
  ```json
  { "proxies": { "default": { "httpProxy": "http://proxy.company.com:3128",
                               "httpsProxy": "http://proxy.company.com:3128",
                               "noProxy": "localhost,127.0.0.1" } } }
  ```
- **Proxy cho Container** (tiến trình trong container cần ra ngoài): truyền qua `~/.docker/config.json` như trên (Docker tự inject biến proxy vào container) hoặc `docker run -e HTTP_PROXY=...`.

Kiểm tra proxy hiện tại của daemon:

```text
$ systemctl show docker --property=Environment
Environment=
```

**Cấu hình Docker Registry:**

- **Registry nội bộ:** doanh nghiệp tự dựng registry (ví dụ chạy image `registry:2`):
  ```bash
  docker run -d -p 5000:5000 --name registry registry:2
  docker tag typ-webapp:1.0 localhost:5000/typ-webapp:1.0
  docker push localhost:5000/typ-webapp:1.0
  ```
- **Chứng chỉ CA tin cậy:** registry nội bộ nên được ký bằng CA của công ty; daemon phải tin CA đó bằng cách đặt file `.crt` vào `/usr/local/share/ca-certificates/` (và `/etc/docker/certs.d/<registry>:<port>/ca.crt`), sau đó `sudo update-ca-certificates && sudo systemctl restart docker`.
- **`insecure-registries` cho môi trường thử nghiệm:** registry dùng HTTP không TLS → khai báo trong `/etc/docker/daemon.json`:
  ```json
  { "insecure-registries": ["192.168.1.50:5000"] }
  ```
  rồi `sudo systemctl restart docker`. **Không dùng cho production** (không mã hóa, dễ bị MITM).

### 12. Các câu lệnh Docker cơ bản

> **Lưu ý:** trên máy còn nhiều container của các dự án khác đang chạy (candy-flow, sql-typ-server...) — các output dưới đây đã **lược bớt** để chỉ hiển thị tài nguyên của bài lab.

**`docker pull` / `docker images` — tải và liệt kê image:**

```text
$ docker pull alpine
Using default tag: latest
latest: Pulling from library/alpine
Digest: sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6
Status: Image is up to date for alpine:latest
docker.io/library/alpine:latest

$ docker images
IMAGE                 ID             DISK USAGE   CONTENT SIZE   EXTRA
alpine:latest         294b683cb724         13MB         3.94MB   U
nginx:1.27-alpine     65645c7bb6a0       74.5MB         21.9MB   U
mysql:8.0             7dcddc01f13b        1.1GB          249MB
ubuntu:latest         da6fc2be5478        160MB         45.3MB   U
...
```

> Docker 29 hiển thị 2 cột dung lượng: `DISK USAGE` (chiếm thật trên ổ đĩa, đã tính chia sẻ layer) và `CONTENT SIZE` (kích thước chuyển/nén — dùng để so sánh image). Chữ `U` = đang được dùng bởi container.

**`docker run` — tạo và chạy container:**

```text
$ docker run -d --name web-demo -p 8888:80 nginx:1.27-alpine
a5b3b3e97ec0193ca537b8ce2bf196d91d7ca7b9140df6a23b48ff9c673b9112

$ docker ps
CONTAINER ID   IMAGE               COMMAND                  STATUS         PORTS                    NAMES
a5b3b3e97ec0   nginx:1.27-alpine   "/docker-entrypoint.…"   Up Less than.. 0.0.0.0:8888->80/tcp      web-demo
...

$ curl -sI http://localhost:8888 | head -4
HTTP/1.1 200 OK
Server: nginx/1.27.5
Date: Tue, 13 Oct 2026 18:05:27 GMT
Content-Type: text/html
```

Các option quan trọng của `docker run`:

| Option | Ý nghĩa |
| --- | --- |
| `-d` | Chạy nền (detached), không chiếm terminal |
| `-it` | Gắn terminal tương tác (dùng cho container cần gõ lệnh) |
| `--name` | Đặt tên container (thay vì tên ngẫu nhiên) |
| `-p host:container` | Map cổng: `8888:80` = host 8888 → container 80 |
| `-v src:dst` | Mount volume/bind (xem mục 18) |
| `-e KEY=VALUE` | Truyền biến môi trường |
| `--rm` | Tự xóa container khi dừng |
| `--restart` | Chính sách khởi động lại (`no`, `on-failure`, `always`, `unless-stopped`) |
| `--memory`, `--cpus` | Giới hạn RAM/CPU (cgroup) |

**`docker logs` — xem log:**

```text
$ docker logs web-demo
/docker-entrypoint.sh: Configuration complete; ready for start up
2026/10/13 18:05:27 [notice] 1#1: using the "epoll" event method
2026/10/13 18:05:27 [notice] 1#1: nginx/1.27.5
...
10.201.0.1 - - [13/Oct/2026:18:05:27 +0000] "HEAD / HTTP/1.1" 200 0 ...
```

**`docker exec` — thực thi lệnh trong container đang chạy:**

```text
$ docker exec web-demo sh -c 'echo "<h1>Xin chao tu docker exec</h1>" > /usr/share/nginx/html/hello.html'
$ curl -s http://localhost:8888/hello.html
<h1>Xin chao tu docker exec</h1>
```

**`docker inspect` — thông tin chi tiết (dạng JSON):**

```text
$ docker inspect web-demo | jq '.[0] | {Id, Image, State: .State.Status, RestartPolicy: .HostConfig.RestartPolicy, Ports: .NetworkSettings.Ports}'
{
  "Id": "a5b3b3e97ec0193ca537b8ce2bf196d91d7ca7b9140df6a23b48ff9c673b9112",
  "Image": "sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10",
  "State": "running",
  "RestartPolicy": { "Name": "no", "MaximumRetryCount": 0 },
  "Ports": { "80/tcp": [ { "HostIp": "0.0.0.0", "HostPort": "8888" }, ... ] }
}
```

**`docker stats`, `docker top`, `docker cp`, `docker diff`:**

```text
$ docker stats --no-stream web-demo
CONTAINER ID   NAME       CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O         PIDS
a5b3b3e97ec0   web-demo   0.00%     10.08MiB / 14.78GiB   0.07%     5.38kB / 1.33kB   1.17MB / 8.19kB   13

$ docker top web-demo
UID     PID      PPID     CMD
root    388583   388559   nginx: master process nginx -g daemon off;
_chrony 388679   388583   nginx: worker process
... (12 worker)

$ docker cp web-demo:/etc/nginx/nginx.conf ./backup/nginx.conf     # copy file ra ngoài
$ docker diff web-demo
A /usr/share/nginx/html/hello.html     # file ta vừa thêm qua docker exec
C /etc/nginx/conf.d/default.conf
A /var/cache/nginx/client_temp
...
```

**Vòng đời `stop` / `start` / `restart` / `rm`:**

```text
$ docker stop web-demo
web-demo
$ docker ps -a --filter name=web-demo
CONTAINER ID   IMAGE               STATUS                        NAMES
a5b3b3e97ec0   nginx:1.27-alpine   Exited (0) Less than a second ago   web-demo
$ docker start web-demo
web-demo
$ docker restart web-demo
web-demo
$ docker rm -f web-demo
web-demo
```

**`docker rm` / `docker rmi` — xóa container và image:**

```text
$ docker image rm alpine          # image đang có container (kể cả đã dừng) -> lỗi
Error response from daemon: conflict: unable to delete alpine:latest (must be forced)
- container 738bdfee1183 is using its referenced image 294b683cb724

$ docker build -f tiny.Dockerfile -t tiny-demo:1.0 .    # image mới toanh, không container nào dùng
$ docker image rm tiny-demo:1.0
Untagged: tiny-demo:1.0
Deleted: sha256:1ede499bf6984e6305702f1f23103d853fc2a9c6f9e3af6f646975f9c7a4f822
```

> **Kinh nghiệm:** muốn xóa image phải xóa/`-f` các container đang tham chiếu nó trước. Phân biệt `docker rm` (xóa **container**) và `docker rmi` (xóa **image**).

**`--rm` và Restart policy:**

```text
$ docker run --rm alpine echo "Container nay tu xoa sau khi chay xong"
Container nay tu xoa sau khi chay xong       # container biến mất ngay sau khi chạy

$ docker run -d --name policy-demo --restart unless-stopped nginx:1.27-alpine
$ docker inspect policy-demo --format '{{.HostConfig.RestartPolicy.Name}}'
unless-stopped
```

**Giới hạn tài nguyên (`--memory`, `--cpus`) — đã minh họa ở mục 9b:** container `cg-demo` bị giới hạn cứng `128 MiB RAM / 0.5 CPU` cả ở phía host lẫn trong container.

---

## Phần 5: Docker Image và Dockerfile

### 13. Docker Image là gì?

**Docker Image** là một **gói chỉ đọc (read-only)** chứa mọi thứ cần để chạy ứng dụng: hệ điều hành rút gọn + thư viện + mã nguồn + cấu hình khởi chạy. Image gồm **nhiều layer xếp chồng** và được định danh bằng **digest** (hash) bất biến.

**Phân biệt Image và Container:**

| | **Image** | **Container** |
| --- | --- | --- |
| Bản chất | Khuôn mẫu **chỉ đọc** (nhiều layer) | **Instance đang chạy** của image (thêm layer ghi được) |
| Vòng đời | Tạo bằng `docker build`, lưu ở registry | Tạo bằng `docker run/create`, có trạng thái/tiến trình |
| Có ghi được? | Không (bất biến) | Có (writable layer + volume) |
| Dung lượng | Vài MB → vài GB | Không tính layer dùng chung; thay đổi chỉ nằm ở upper layer |

**Cấu trúc Image Layers** — mỗi lệnh trong Dockerfile tạo một layer (trừ các lệnh "chỉ metadata" như `ENV`, `EXPOSE`, `CMD`...). Xem lịch sử layer:

```text
$ docker history typ-webapp:1.0
IMAGE          CREATED        CREATED BY                                      SIZE
2826b9b8c53f   13 seconds ago CMD ["python" "app.py"]                         0B
<missing>      13 seconds ago HEALTHCHECK {Test:[CMD-SHELL python -c ...   0B
<missing>      13 seconds ago USER appuser                                    0B
<missing>      13 seconds ago RUN /bin/sh -c useradd --create-home appuser   69.6kB
<missing>      13 seconds ago ENV APP_VERSION=1.0 PYTHONUNBUFFERED=1          0B
<missing>      13 seconds ago COPY app.py . # buildkit                        12.3kB
<missing>      13 seconds ago RUN /bin/sh -c pip install --no-cache-dir -r   16.1MB
<missing>      13 seconds ago COPY requirements.txt . # buildkit              12.3kB
<missing>      13 seconds ago WORKDIR /app                                    8.19kB
<missing>      13 seconds ago LABEL maintainer=...                            0B
<missing>      7 days ago     CMD ["python3"]                                 0B
<missing>      7 days ago     RUN /bin/sh -c set -eux; wget -O python.tgz...  75.9MB     # các layer
<missing>      7 days ago     RUN /bin/sh -c apt-get update; ...              696MB      # của base
<missing>      7 days ago     RUN ...                                         202MB      # image
<missing>      8 days ago     # debian.sh --arch 'amd64' out/ 'trixie'...     134MB
```

`<missing>` là do layer không có ID độc lập trong image hiện tại (các layer của base image) — nhưng vẫn đúng thứ tự, đúng kích thước. **Layer được dùng chung:** mọi image cùng base (ví dụ nhiều phiên bản dựng trên `python:3.13-slim`) **tái sử dụng** các layer gốc — trên đĩa chỉ lưu một bản, rất tiết kiệm dung lượng.

**Image Tag và Image Digest:**

- **Tag** là nhãn "có thể ghi đè", dùng để đánh phiên bản: `mysql:8.0`, `nginx:1.27-alpine`.
- **Digest** là hash **bất biến** của image, dùng khi cần ghim "đúng tuyệt đối":
  ```text
  $ docker image inspect alpine --format '{{index .RepoDigests 0}}'
  alpine@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6
  ```
  Trong CI/CD nên ghim **cả digest** để tránh "cùng tag nhưng nội dung đã thay đổi".

**Docker Hub và Private Registry:**

- **Docker Hub** — registry mặc định, ai cũng tải được image public; image `library/*` là official.
- **Private registry** — registry riêng trong doanh nghiệp (Harbor, GitLab Registry, ECR/GCR/ACR...) để lưu image nội bộ, có phân quyền.

**Các lệnh `docker pull`, `docker tag`, `docker push`:**

```text
$ docker pull alpine
Using default tag: latest
latest: Pulling from library/alpine
Digest: sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6
Status: Image is up to date for alpine:latest

$ docker tag typ-webapp:1.0-slim typ-webapp:latest      # local: thêm nhãn mới cho image
$ docker tag typ-webapp:1.0-slim hoangtien7/typ-webapp:1.0   # chuẩn bị push lên Docker Hub
```

```bash
# Quy trình push (khái niệm):
docker login                              # đăng nhập Docker Hub
docker tag typ-webapp:1.0 <user>/typ-webapp:1.0
docker push <user>/typ-webapp:1.0
# Quy trình pull về máy khác:
docker pull <user>/typ-webapp:1.0
docker run -d -p 8890:5000 <user>/typ-webapp:1.0
```

> **Ghi chú trung thực:** trong buổi thực hành này em **chưa đăng nhập tài khoản Docker Hub** nên chưa chạy `docker login`/`push` thật; phần pull đã được minh chứng ở các lệnh `docker pull alpine`/`hello-world`. Toàn bộ quy trình push được trình bày bằng lệnh mẫu ở trên.

**Quy tắc đặt tên và quản lý phiên bản:**

```text
[registry/][namespace/]repository[:tag][@digest]
ví dụ:   docker.io/hoangtien7/typ-webapp:1.0.0
```

- Dùng **Semantic Versioning** (`1.0.0`, `1.1.0`, `2.0.1`) cho tag phát hành;
- Có thể thêm tag phụ trợ: `1.0.0`, `1.0`, `latest` cùng trỏ một image — nhưng **tránh deploy bằng `latest`** vì không biết chính xác phiên bản; môi trường production nên dùng tag cụ thể hoặc digest;
- Tên repository viết thường, có thể dùng `-`/`_`/`.`.

**Lưu và nạp Image offline — `docker save` / `docker load`** (rất hữu ích khi máy không có mạng hoặc chuyển máy):

```text
$ docker save alpine -o backup/alpine.tar
$ ls -lh backup/alpine.tar
-rw------- 1 tien tien 3.8M ... backup/alpine.tar

$ docker image rm alpine          # giả lập máy mới chưa có image
Untagged: alpine:latest
...
$ docker load -i backup/alpine.tar
Loaded image: alpine:latest

$ docker run --rm alpine echo "alpine da quay lai sau khi load"
alpine da quay lai sau khi load
```

### 14. Xây dựng Docker Image bằng Dockerfile

**Dockerfile** là file văn bản chứa tuần tự các **chỉ thị (instruction)** để BuildKit dựng image layer-by-layer.

**Các chỉ thị cơ bản:**

| Chỉ thị | Công dụng |
| --- | --- |
| `FROM` | Chọn **base image** cho stage (bắt buộc, trừ `FROM scratch`) |
| `RUN` | Chạy lệnh trong quá trình **build** (tạo layer) |
| `COPY` / `ADD` | Copy file từ build context vào image (`ADD` thêm giải nén tar/URL) |
| `WORKDIR` | Đặt thư mục làm việc (các lệnh sau tính tương đối theo đó) |
| `ENV` / `ARG` | Biến môi trường **lúc chạy** (`ENV`) / biến **chỉ lúc build** (`ARG`) |
| `EXPOSE` | Ghi chú cổng service lắng nghe (metadata) |
| `CMD` / `ENTRYPOINT` | Lệnh mặc định khi container chạy |
| `USER` | Chuyển sang user khác (khuyến khích non-root) |
| `HEALTHCHECK` | Lệnh kiểm tra "còn khỏe" cho container (Docker/Compose gọi định kỳ) |
| `LABEL` | Metadata (author, version...) |
| `VOLUME` | Khai báo điểm mount dữ liệu bền |

**Ứng dụng web đơn giản của bài lab** (`docker-lab/week3/webapp/`): Flask app hiển thị hostname, thời gian, phiên bản và **đếm số lượt truy cập lưu trong MySQL** (dùng lại ở mục 21).

`app.py` (rút gọn):

```python
@app.get("/")
def index():
    total, err = count_visits()
    ...
    return f"""<h1>Xin chao tu Docker!</h1>
  <ul>
    <li>Container hostname: <b>{socket.gethostname()}</b></li>
    <li>Phien ban app: {APP_VERSION}</li>
  </ul>
  <p>So lan truy cap (MySQL): <b>{total}</b></p>"""

@app.get("/health")          # dùng cho HEALTHCHECK
def health():
    return "ok"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

`requirements.txt`: `flask==3.1.*`, `pymysql==1.1.*`

**Dockerfile bản đầu (single-stage, `Dockerfile`):**

```dockerfile
FROM python:3.13                        # base image đầy đủ (chưa tối ưu)

LABEL maintainer="TienHD.B25CE246" \
      org.opencontainers.image.title="typ-webapp"

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

ENV APP_VERSION=1.0 \
    PYTHONUNBUFFERED=1

EXPOSE 5000

RUN useradd --create-home appuser       # chạy non-root
USER appuser

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD python -c "import urllib.request;urllib.request.urlopen('http://127.0.0.1:5000/health')"

CMD ["python", "app.py"]
```

**Build bằng `docker build`:**

```text
$ docker build --progress=plain -t typ-webapp:1.0 .
#1 [internal] load build definition from Dockerfile
#2 [internal] load metadata for docker.io/library/python:3.13
#4 [1/6] FROM docker.io/library/python:3.13@sha256:1c92e572...
#6 [2/6] WORKDIR /app                CACHED        # <-- cache: không build lại
#7 [4/6] RUN pip install ...         CACHED
#8 [3/6] COPY requirements.txt .     CACHED
#9 [5/6] COPY app.py .               CACHED
#10 [6/6] RUN useradd --create-home appuser   CACHED
#11 exporting to image ... naming to docker.io/library/typ-webapp:1.0 done
```

**Docker Build Cache:** BuildKit lưu layer đã build; lần build lại thấy output `CACHED` → **build trong vài giây** thay vì tải lại/cài lại từ đầu. Cache chỉ bị "vô hiệu" từ layer thay đổi trở đi — vì vậy trong Dockerfile nên **copy `requirements.txt` cài dependency trước, copy source code sau** (như trên): sửa code không phải cài lại thư viện.

**`.dockerignore`** — loại file rác khỏi build context (nhanh hơn, image không chứa file thừa):

```text
__pycache__/
*.pyc
.git/
.env
evidence/
backup/
```

**`CMD` và `ENTRYPOINT`; exec form và shell form:**

| | `CMD` | `ENTRYPOINT` |
| --- | --- | --- |
| Vai trò | Lệnh **mặc định** (dễ bị ghi đè) | Lệnh **cố định** của container (khó bị ghi đè hơn) |
| `docker run <image> <args>` | `<args>` **ghi đè** CMD | `<args>` trở thành **tham số** cho ENTRYPOINT |
| `docker run --entrypoint` | — | **Ghi đè** ENTRYPOINT |

- **Exec form** `CMD ["python", "app.py"]` — chạy trực tiếp, không qua shell, tiến trình nhận tín hiệu đúng, **nên dùng**.
- **Shell form** `CMD python app.py` — chạy qua `/bin/sh -c`, dễ gây tiến trình không nhận `SIGTERM` đúng.

Minh chứng trên image `typ-webapp:1.0-slim` (định nghĩa `CMD ["python","app.py"]`, không có ENTRYPOINT):

```text
$ docker inspect typ-webapp:1.0-slim --format '{{json .Config}}' | jq '{Cmd, Entrypoint, User, ExposedPorts}'
{
  "Cmd": [ "python", "app.py" ],      # exec form
  "Entrypoint": null,
  "User": "appuser",                  # chạy non-root
  "ExposedPorts": { "5000/tcp": {} }
}

$ docker run --rm --entrypoint sh typ-webapp:1.0-slim -c 'echo "ENTRYPOINT bi ghi de thanh sh, CMD bi bo qua"'
ENTRYPOINT bi ghi de thanh sh, CMD bi bo qua

$ docker run --rm typ-webapp:1.0-slim python -c 'import sys; print("Tham so them vao ghi de CMD:", sys.argv)' hello
Tham so them vao ghi de CMD: ['-c', 'hello']
```

**Multi-stage Build** — dùng nhiều `FROM` trong cùng Dockerfile; stage sau **copy kết quả** từ stage trước, bỏ lại toàn bộ công cụ build:

```dockerfile
# ---------- Stage 1: builder ----------
FROM python:3.13-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN python -m venv /opt/venv && /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# ---------- Stage 2: runtime ----------
FROM python:3.13-slim
WORKDIR /app
COPY --from=builder /opt/venv /opt/venv     # chỉ mang "thành phẩm" sang
COPY app.py .
ENV PATH="/opt/venv/bin:$PATH" ...
CMD ["python", "app.py"]
```

**Thực hành tốt khi viết Dockerfile (đã áp dụng trong bài):**

1. **Chạy non-root:** `useradd` + `USER appuser` — hạn chế thiệt hại nếu container bị khai thác.
2. **Ghim phiên bản base image:** dùng `python:3.13`/`python:3.13-slim` thay vì `python:latest`.
3. **Tối ưu layer:** lệnh ít thay đổi xếp trước (dependency), lệnh hay thay đổi xếp sau (source) → tận dụng cache.
4. **`--no-cache-dir`** khi pip → image nhỏ hơn.
5. **`.dockerignore`** để build context sạch.
6. **HEALTHCHECK** để orchestrator biết trạng thái thật của container.
7. **Multi-stage** cho ứng dụng cần build (như trên) — xem mục 15 để thấy chênh lệch kích thước.

### 15. Thực hành Build và Push Docker Image

**a) Build image và chạy container:**

```text
$ docker build -t typ-webapp:1.0 .
$ docker images typ-webapp
IMAGE            ID             DISK USAGE   CONTENT SIZE
typ-webapp:1.0   2826b9b8c53f       1.63GB          419MB

$ docker run -d --name web-lab -p 8890:5000 typ-webapp:1.0
e71d9ca20f5b20b6d671d1e1e392559d42b1b3d778df2ed132fc6a1ae94a7204

$ curl -s http://localhost:8890/
<!doctype html>
<html><head><meta charset="utf-8"><title>TYP Web App</title></head>
<body>
  <h1>Xin chao tu Docker!</h1>
  <ul>
    <li>Container hostname: <b>e71d9ca20f5b</b></li>
    <li>Thoi gian: 2026-10-13 18:07:17</li>
    <li>Phien ban app: 1.0</li>
  </ul>
  <p>MySQL: khong ket noi duoc (Chua cau hinh DB_HOST)</p>
</body></html>

$ curl -s http://localhost:8890/health
ok
```

Ứng dụng chạy tốt với base image **đầy đủ** — nhưng image tới **1.63 GB**.

**b) Gắn tag:**

```text
$ docker tag typ-webapp:1.0-slim typ-webapp:latest
$ docker images typ-webapp
IMAGE                 ID             DISK USAGE   CONTENT SIZE
typ-webapp:1.0        2826b9b8c53f       1.63GB          419MB
typ-webapp:1.0-slim   17b58ae668f3        201MB         48.6MB
typ-webapp:latest     17b58ae668f3        201MB         48.6MB
```

**c) Đăng nhập registry và push** — *quy trình chuẩn* (bài lab chưa chạy push thật vì chưa đăng nhập Docker Hub):

```bash
docker login                                  # nhập username/PAT của Docker Hub
docker tag typ-webapp:1.0-slim <user>/typ-webapp:1.0
docker push <user>/typ-webapp:1.0
# => registry lưu: <user>/typ-webapp@sha256:<digest>
```

**d) Pull image về máy khác và chạy thử** — *quy trình chuẩn*:

```bash
docker pull <user>/typ-webapp:1.0
docker run -d -p 8890:5000 <user>/typ-webapp:1.0
curl http://localhost:8890/
```

(Minh chứng pull thật đã có ở `docker pull alpine` / `hello-world` — xem mục 11, 13.)

**e) Mở rộng — chuyển sang Multi-stage Build và so sánh kích thước:**

```text
$ docker build -f Dockerfile.multistage -t typ-webapp:1.0-slim .
#5 [builder 1/4] FROM docker.io/library/python:3.13-slim@sha256:70729b46...
#12 naming to docker.io/library/typ-webapp:1.0-slim done

$ docker images typ-webapp
IMAGE                 ID             DISK USAGE   CONTENT SIZE
typ-webapp:1.0        2826b9b8c53f       1.63GB          419MB
typ-webapp:1.0-slim   17b58ae668f3        201MB         48.6MB

$ docker run -d --name web-slim -p 8892:5000 typ-webapp:1.0-slim
$ curl -s http://localhost:8892/ | grep -E "hostname|Phien ban"
    <li>Container hostname: <b>d8090a05a221</b></li>
    <li>Phien ban app: 1.0-slim</li>
```

**So sánh:**

| | Single-stage (`typ-webapp:1.0`) | Multi-stage (`typ-webapp:1.0-slim`) |
| --- | --- | --- |
| Base image | `python:3.13` (đầy đủ) | `python:3.13-slim` + venv copy sang |
| DISK USAGE | **1.63 GB** | **201 MB** (~8×) |
| CONTENT SIZE | 419 MB | 48.6 MB (~8.6×) |
| Chức năng | Giống hệt nhau | Giống hệt nhau |

Các layer "nặng" của base image đầy đủ (apt packages ~1 GB — xem `docker history` ở mục 13) **không còn** trong image runtime nhờ multi-stage + slim. Đây là lý do thực tế nhất để dùng multi-stage/slim base: **image nhỏ → push/pull nhanh, ít bề mặt tấn công**.

---

## Phần 6: Kiến trúc và quản lý Docker

### 16. Kiến trúc Docker Engine

**Mô hình Client – Server:**

```text
+----------------+         REST API (unix:///var/run/docker.sock)      +-------------------+
|  Docker CLI    | ------------------------------------------------> |  dockerd (daemon) |
|  (`docker ...`) | <------------------------------------------------ |  - images/networks|
+----------------+                                                  |  - volumes/...    |
                                                                    +---------+---------+
                                                                              | gRPC
                                                                    +---------v---------+
                                                                    |    containerd     |
                                                                    +---------+---------+
                                                                              | tạo task
                                                                    +---------v---------+
                                                                    | containerd-shim   |  (1 shim / container)
                                                                    +---------+---------+
                                                                              | chạy OCI bundle
                                                                    +---------v---------+
                                                                    |       runc        |  -> tạo container xong thì thoát
                                                                    +-------------------+
```

- **Docker CLI:** chỉ là client gửi lệnh qua API; `docker version` hiển thị cả Client và Server riêng biệt.
- **Docker API:** REST API — có thể gọi trực tiếp bằng `curl` qua unix socket:

  ```text
  $ curl -s --unix-socket /var/run/docker.sock http://localhost/version | jq '{Version, ApiVersion, MinAPIVersion, Os, Arch}'
  {
    "Version": "29.5.3",
    "ApiVersion": "1.54",
    "MinAPIVersion": "1.40",
    "Os": "linux",
    "Arch": "amd64"
  }

  $ curl -s --unix-socket /var/run/docker.sock http://localhost/containers/json | jq 'map(.Names)'
  [ [ "/typ-lab-web-1" ], [ "/typ-mysql" ], [ "/candy-flow-minio-1" ], ... ]
  ```

- **Docker Daemon (`dockerd`):** quản lý image, container, network, volume; nhận API request; đọc cấu hình từ `/etc/docker/daemon.json` (mục 11) — **mọi thay đổi file này cần `systemctl restart docker`**.
- **containerd:** container runtime "cấp cao" (hiện do CNCF quản lý): quản lý vòng đời container/snapshot (image store), độc lập với Docker.
- **containerd-shim:** tiến trình trung gian giữ container **sống độc lập với daemon** — nếu `dockerd` restart, container vẫn chạy.
- **runc:** runtime "cấp thấp", đọc cấu hình OCI và **tạo container thật** (namespace, cgroup...), sau đó thoát — `containerd-shim` là "phụ huynh" của tiến trình container.

**Minh chứng tiến trình thật trên máy (đúng theo sơ đồ):**

```text
$ ps -ef | grep -E "dockerd|containerd" | grep -v grep
/usr/bin/containerd                      <-- containerd chạy trước
/usr/bin/dockerd -H fd://                <-- daemon của Docker
/usr/bin/containerd-shim-runc-v2 -namespace moby ...   <-- 12 shim cho 12 container

$ runc --version
runc version 1.3.5
spec: 1.2.1

$ docker context show
default                                   <-- đang dùng daemon native tại /var/run/docker.sock
```

**Quy trình từ `docker run` đến khi container hoạt động:**

1. **CLI** gửi lệnh qua REST API tới `dockerd`.
2. `dockerd` chuẩn bị: chọn image (pull nếu chưa có), tạo/cấp network, volume, cấu hình.
3. `dockerd` gọi **containerd** tạo task.
4. **containerd** tạo **containerd-shim** cho container mới.
5. **shim** gọi **runc** → runc tạo namespace + cgroup + mount rootfs (overlay) rồi **khởi chạy tiến trình PID 1 trong container** và thoát.
6. **shim** giữ vai trò "quản gia": thu SIGCHLD, giữ stdout/stderr, cho phép `docker exec`/`logs`...

**Mối quan hệ Docker Engine và Container Runtime:** Engine = **bộ công cụ đầy đủ** (CLI + daemon + API + build/network/storage), bên trong **dùng containerd/runc** làm runtime theo chuẩn **OCI** (mục 9e). Nhờ tách lớp này, cùng một image chạy được trên Docker, Kubernetes (containerd/CRI-O + runc), podman...

### 17. Docker Networking

**Tổng quan mạng Docker:** Docker gắn mỗi container vào một **network** ảo:

- Mỗi network bridge được cấp một **bridge interface ảo** trên host — mặc định tên `docker0` (tùy chỉnh được):
  ```text
  $ ip -br addr show docker0
  docker0          UP             10.201.0.1/24 fe80::1821:ccff:fed7:ea32/64
  ```
  (Địa chỉ `10.201.0.1/24` đến từ tùy biến `"bip"` trong `/etc/docker/daemon.json`.)
- Mỗi container được nối vào bridge bằng một cặp **veth pair** (kiểu dây ảo 2 đầu): 1 đầu nằm trong namespace mạng của container (`eth0`), 1 đầu cắm vào bridge trên host:
  ```text
  $ ip -o link | grep -E "docker0|veth" | head -3
  10: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> ...     master ... state UP
  16: veth5c1846f@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> master br-bb1da65f5c86 ...
  17: veth0b4d96b@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> master br-bb1da65f5c86 ...
  ```
- **Port mapping `-p`** được Docker cài đặt bằng **iptables/nftables NAT**: cổng host `8888` → `DNAT` vào `container:80`; container đi ra Internet qua `MASQUERADE` (SNAT).

**Các loại Docker Network:**

| Loại | Đặc điểm | Dùng khi nào |
| --- | --- | --- |
| **bridge (default)** | Mọi container "không chỉ định network" đều vào đây; **không có DNS nội bộ theo tên** (phải `--link` — đã lỗi thời) | Hiếm dùng trực tiếp |
| **bridge (user-defined)** | Tự tạo bằng `docker network create`; **có DNS nội bộ**: container gọi nhau bằng tên; cô lập theo nhóm | Mặc định nên dùng cho app nhiều container |
| **host** | Container dùng **thẳng** network stack của host (không có eth0 riêng, không NAT) | Cần hiệu năng mạng cao / cổng cố định |
| **none** | Không có mạng, chỉ có `lo` | Container không cần mạng (batch, kiểm tra) |
| **overlay** | Mạng "phủ" nối container **giữa nhiều host** (Docker Swarm / multi-host) | Cluster nhiều máy |
| **macvlan** | Gán **MAC riêng**, container "hiện ra" như một máy trong LAN vật lý | Dịch vụ cần xuất hiện như thiết bị LAN thật |

**Minh chứng thật — user-defined bridge + DNS nội bộ:**

```text
$ docker network create lab-net
lab-net

$ docker run -d --name app1 --network lab-net alpine sleep 600
$ docker run -d --name app2 --network lab-net alpine sleep 600

$ docker inspect lab-net | jq '.[0].Containers'
{
  "4d4156...": { "Name": "app2", "IPv4Address": "10.202.1.3/24", "MacAddress": "76:fc:d8:77:d5:f7" },
  "f5e613...": { "Name": "app1", "IPv4Address": "10.202.1.2/24", "MacAddress": "12:8c:e9:2a:6b:f3" }
}
# -> dải 10.202.1.0/24 được cấp tự động từ "default-address-pools" trong daemon.json

$ docker exec app1 ping -c 3 app2            # gọi NHAU BẰNG TÊN
PING app2 (10.202.1.3): 56 data bytes
64 bytes from 10.202.1.3: seq=0 ttl=64 time=0.097 ms
64 bytes from 10.202.1.3: seq=1 ttl=64 time=0.190 ms
64 bytes from 10.202.1.3: seq=2 ttl=64 time=0.152 ms
--- app2 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss

$ docker exec app1 getent hosts app2
10.202.1.3        app2  app2

$ docker exec app1 cat /etc/resolv.conf
nameserver 127.0.0.11                     # DNS server nhúng của Docker
search taild088d8.ts.net
options edns0 trust-ad ndots:0
```

So sánh với **default bridge** — không có DNS theo tên:

```text
$ docker run --rm --network bridge alpine ping -c 1 app1
ping: bad address 'app1'                   # thất bại: default bridge không phân giải tên
```

**Nối/bỏ network khi container đang chạy; network `host` và `none`:**

```text
$ docker network connect lab-net web-demo      # gắn thêm network cho container đang chạy
$ docker exec app1 ping -c 2 web-demo
PING web-demo (10.202.1.4): 56 data bytes
64 bytes from 10.202.1.4: seq=0 ttl=64 time=0.089 ms
...
$ docker network disconnect lab-net web-demo

$ docker run --rm --network none alpine ip -o addr     # CHỈ có loopback
1: lo    inet 127.0.0.1/8 scope host lo ...

$ docker run --rm --network host alpine ip -o addr | head -4   # thấy đúng interface của HOST
1: lo    inet 127.0.0.1/8 ...
3: wlp4s0    inet 192.168.32.16/24 ...
4: tailscale0    inet 100.117.107.86/32 ...
```

**Port mapping:** minh chứng ở mục 12 với `-p 8888:80` (`docker ps` hiển thị `0.0.0.0:8888->80/tcp`, `curl localhost:8888` trả về nginx).

> **Ghi chú thực tế:** với `--network host`, container **không còn cô lập mạng** — cổng nó mở chính là cổng host; còn bridge + `-p` an toàn hơn (chỉ mở đúng cổng cần thiết).

### 18. Docker Storage và Volume

**Dữ liệu bên trong container được lưu thế nào?** Mọi thứ ghi vào filesystem của container nằm ở **writable layer (upper layer)** xếp trên các layer image (mục 9c). Layer này:

- **Đi theo container:**
  - `docker stop` → còn nguyên (container dừng, không xóa);
  - `docker rm` → **mất vĩnh viễn** (xóa upper layer).
- **Không dùng được cho dữ liệu bền** (database, upload, log...): container được tạo lại là "trắng như mới" — gọi là **ephemeral storage**.

**Minh chứng ephemeral storage:**

```text
$ docker run --name eph-demo alpine sh -c 'echo "du lieu tam thoi" > /root/eph.txt; cat /root/eph.txt'
du lieu tam thoi
$ docker rm eph-demo
eph-demo
# -> file /root/eph.txt biến mất cùng container, không cách nào lấy lại
```

**Ba cách gắn dữ liệu bền vào container:**

| | **Volume** | **Bind Mount** | **tmpfs Mount** |
| --- | --- | --- | --- |
| Dữ liệu nằm ở | Vùng do Docker quản lý (`/var/lib/docker/volumes/...`) | Thư mục **bất kỳ trên host** | **RAM** |
| Khai báo | `-v ten-volume:/path` | `-v /path/host:/path` | `--tmpfs /path` |
| Quản lý | `docker volume ls/inspect/rm` | Người dùng tự quản lý | Mất khi container dừng |
| Backup/portability | Dễ (tar qua container) | Tùy thư mục host | Không cần backup (tạm) |
| Dùng cho | **DB, dữ liệu bền** | Dev (source code), file cấu hình host | Cache, dữ liệu tạm, bảo mật (không ghi đĩa) |
| Ghi đè gì? | Không ghi đè nội dung sẵn có của image | **Ghi đè** nội dung tại điểm mount | — |

**Minh chứng Volume:**

```text
$ docker volume create lab-data
lab-data

$ docker volume inspect lab-data
[
    {
        "CreatedAt": "2026-10-14T01:07:33+07:00",
        "Driver": "local",
        "Mountpoint": "/var/lib/docker/volumes/lab-data/_data",
        "Name": "lab-data",
        "Scope": "local"
    }
]

$ docker run --rm -v lab-data:/data alpine sh -c 'echo "du lieu ben vung" > /data/hello.txt'
$ docker run --rm -v lab-data:/data alpine cat /data/hello.txt   # container KHÁC vẫn đọc được
du lieu ben vung
```

**Minh chứng Bind Mount:**

```text
$ mkdir -p bindmount
$ docker run --rm -v $PWD/bindmount:/data alpine sh -c 'echo "file tu container" > /data/from-container.txt'
$ ls -l bindmount/
-rw-r--r-- 1 root root 18 ... from-container.txt     # file xuất hiện ngay trên host (owner root)
$ cat bindmount/from-container.txt
file tu container
```

**Minh chứng tmpfs Mount:**

```text
$ docker run --rm --tmpfs /tmp:size=1m alpine sh -c 'df -h /tmp; echo "mat khi container dung" > /tmp/tmpfile; cat /tmp/tmpfile'
Filesystem                Size      Used Available Use% Mounted on
tmpfs                     1.0M         0      1.0M   0% /tmp
mat khi container dung
```

**Lưu trữ dữ liệu bền vững — backup và restore Volume bằng tar:**

```text
$ docker run --rm -v lab-data:/data -v $PWD/backup-volume:/backup alpine tar czf /backup/lab-data.tar.gz -C /data .
$ ls -lh backup-volume/
-rw-r--r-- 1 root root 150 ... lab-data.tar.gz

# Restore vào volume mới (kịch bản "máy mới"/phục hồi):
$ docker volume create lab-data-restore
$ docker run --rm -v lab-data-restore:/data -v $PWD/backup-volume:/backup \
    alpine sh -c 'tar xzf /backup/lab-data.tar.gz -C /data && cat /data/hello.txt'
du lieu ben vung
```

> Mẫu tổng quát: **backup** `docker run --rm -v <vol>:/data -v $(pwd):/backup alpine tar czf /backup/vol-backup.tar.gz -C /data .`; **restore** ngược lại với `tar xzf`. Với database nên `dump` (mysqldump) thay vì copy file đang mở.

**Thực hành: chạy MySQL Container với Docker Volume** — chứng minh dữ liệu **sống sót qua việc xóa/tạo lại container**:

```text
$ docker volume create mysql-lab-data
$ docker run -d --name mysql-lab -e MYSQL_ROOT_PASSWORD=... -e MYSQL_DATABASE=lab \
    -v mysql-lab-data:/var/lib/mysql -p 33070:3306 mysql:8.0
$ docker exec -e MYSQL_PWD=... mysql-lab mysql -uroot -e \
    "USE lab; CREATE TABLE notes(id INT AUTO_INCREMENT PRIMARY KEY, content VARCHAR(100));
     INSERT INTO notes(content) VALUES ('ban ghi thu 1 - truoc khi xoa container'),('ban ghi thu 2');
     SELECT * FROM notes;"
id  content
1   ban ghi thu 1 - truoc khi xoa container
2   ban ghi thu 2

$ docker rm -f mysql-lab                       # XÓA HẲN container (dữ liệu trong container sẽ mất)
mysql-lab

# Tạo container MỚI, mount lại đúng volume cũ:
$ docker run -d --name mysql-lab2 ... -v mysql-lab-data:/var/lib/mysql mysql:8.0
$ docker exec ... mysql -uroot -e "SELECT * FROM lab.notes;"
id  content
1   ban ghi thu 1 - truoc khi xoa container     <-- DỮ LIỆU VẪN CÒN NGUYÊN
2   ban ghi thu 2

$ docker volume inspect mysql-lab-data | jq '.[0] | {Name, Mountpoint}'
{ "Name": "mysql-lab-data", "Mountpoint": "/var/lib/docker/volumes/mysql-lab-data/_data" }
```

→ Nếu không có volume, toàn bộ database sẽ **mất sạch** khi xóa container. Với volume, dữ liệu nằm ở host, container chỉ là "người dùng" — đúng nguyên tắc **container là ephemeral, dữ liệu là persistent**.

---

## Phần 7: Docker Compose

### 19. Tổng quan về Docker Compose

**Docker Compose** là công cụ định nghĩa và chạy **ứng dụng nhiều container** bằng **một file YAML duy nhất** (`compose.yaml`). Một lệnh `docker compose up -d` có thể dựng cả web + database + cache... với network, volume, biến môi trường, thứ tự khởi động... thay vì gõ hàng chục lệnh `docker run`.

**Tại sao cần Docker Compose?**

- Ứng dụng thực tế gồm **nhiều service** — Compose mô tả toàn bộ "bản thiết kế" trong 1 file, có thể version-control.
- **Tái lập môi trường** dễ dàng: máy khác chỉ cần `docker compose up`.
- Quản lý **network/volume/mối quan hệ** giữa các service (`depends_on`, `healthcheck`...).
- Phù hợp dev, test, demo và cả triển khai nhỏ (một máy).

**Phân biệt Docker CLI và Docker Compose:**

| | Docker CLI (`docker run/...`) | Docker Compose (`docker compose ...`) |
| --- | --- | --- |
| Phạm vi | Từng **container đơn lẻ** | Cả **ứng dụng nhiều service** |
| Định nghĩa | Gõ lệnh dài, lặp lại | File `compose.yaml` khai báo một lần |
| Quan hệ giữa container | Tự gắn network/volume bằng tay | Compose tự tạo network chung, `depends_on`/`healthcheck` |
| Vòng đời | `run/stop/rm` từng cái | `up`/`down` cả cụm, tự đánh dấu tài nguyên thuộc project |

**Docker Compose V2 và cú pháp `docker compose`:** Compose V2 là **plugin** của Docker CLI (viết bằng Go, chạy `docker compose` — có dấu cách), thay thế binary Python `docker-compose` (dấu gạch ngang) đã ngừng hỗ trợ. File cấu hình Docker Compose V2 khuyến nghị đặt tên **`compose.yaml`** (vẫn hỗ trợ `docker-compose.yml`).

**Cấu trúc cơ bản của `compose.yaml`** gồm 3 nhóm chính:

- **`services`** — mỗi service = 1 container: ảnh/build, ports, environment, volumes, networks, depends_on...
- **`networks`** — mạng chung giữa các service (mặc định Compose tạo 1 network riêng cho project).
- **`volumes`** — volume dùng chung/lâu dài, được đặt tên theo project.

### 20. Viết và quản lý Docker Compose

**File `compose.yaml` của bài lab** (`docker-lab/week3/compose-app/`) — web app (build từ mục 14) + MySQL:

```yaml
name: typ-lab

services:
  mysql:
    image: mysql:8.0
    container_name: typ-mysql
    environment:
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}     # lấy từ .env
      MYSQL_DATABASE: ${MYSQL_DATABASE}
    volumes:
      - mysql-data:/var/lib/mysql                     # dữ liệu bền
    networks:
      - backend
    healthcheck:                                      # Docker định kỳ "hỏi thăm"
      test: ["CMD", "mysqladmin", "ping", "-h", "127.0.0.1", "-p${MYSQL_ROOT_PASSWORD}"]
      interval: 10s
      timeout: 5s
      retries: 10
      start_period: 30s
    restart: unless-stopped

  web:
    build:
      context: ../webapp
      dockerfile: Dockerfile.multistage               # dùng bản multi-stage đã tối ưu
    image: typ-webapp:1.0-slim
    environment:
      DB_HOST: mysql                                  # gọi MySQL bằng TÊN SERVICE (DNS nội bộ)
      DB_USER: root
      DB_PASSWORD: ${MYSQL_ROOT_PASSWORD}
      DB_NAME: ${MYSQL_DATABASE}
    ports:
      - "8890-8891:5000"                              # dải cổng: phục vụ scale 2 replica
    depends_on:
      mysql:
        condition: service_healthy                    # đợi MySQL healthy mới chạy web
    networks:
      - backend
    restart: unless-stopped

volumes:
  mysql-data:

networks:
  backend:
    driver: bridge
```

**Environment Variables và file `.env`** (Compose tự nạp file `.env` cùng thư mục):

```text
$ cat .env
# Bien moi truong cho Docker Compose (khong commit len git)
MYSQL_ROOT_PASSWORD=MatKhauLab123
MYSQL_DATABASE=lab
```

**`compose.override.yaml`** — file "ghi đè" chỉ dùng khi dev, được Compose **tự động gộp** khi chạy `docker compose up`:

```yaml
services:
  web:
    environment:
      APP_VERSION: 1.0-dev-override     # đổi phiên bản hiển thị
    volumes:
      - ../webapp/app.py:/app/app.py:ro # mount code để sửa không cần rebuild
```

**Các lệnh Compose chính — chạy thật:**

```text
$ docker compose -f compose.yaml config            # kiểm tra/ xem cấu hình sau khi gộp
name: typ-lab
services:
  mysql:
    ...
    healthcheck:
      test: [CMD, mysqladmin, ping, -h, 127.0.0.1, -pMatKhauLab123]
  web:
    ...
    ports:
      - mode: ingress
        target: 5000
        published: 8890-8891
volumes:
  mysql-data:
    name: typ-lab_mysql-data
networks:
  backend:
    name: typ-lab_backend
```

```text
$ docker compose -f compose.yaml up -d
 Network typ-lab_backend Created
 Volume typ-lab_mysql-data Created
 Container typ-mysql Created / Started / Waiting / Healthy
 Container typ-lab-web-1 Started

$ docker compose -f compose.yaml ps
NAME            IMAGE                 SERVICE   STATUS                   PORTS
typ-lab-web-1   typ-webapp:1.0-slim   web       Up (healthy)             0.0.0.0:8890->5000/tcp
typ-mysql       mysql:8.0             mysql     Up (healthy)             3306/tcp, 33060/tcp

$ docker compose -f compose.yaml logs web --tail 3
web-1  | 10.202.2.1 - - [13/Oct/2026 18:12:54] "GET / HTTP/1.1" 200 -

$ docker compose -f compose.yaml exec -e MYSQL_PWD=... mysql mysql -uroot -e "SELECT COUNT(*) FROM lab.visits"
so_lan_truy_cap
2

$ docker compose restart web
 Container typ-lab-web-1 Restarting / Started
```

| Lệnh | Công dụng |
| --- | --- |
| `docker compose up -d` | Tạo & chạy toàn bộ service (nền) |
| `docker compose down` | Dừng + xóa container/network của project (volume giữ nguyên) |
| `docker compose down -v` | Như trên + xóa cả volume (mất dữ liệu!) |
| `docker compose ps` | Trạng thái các service |
| `docker compose logs -f <svc>` | Xem log (theo dõi realtime) |
| `docker compose exec <svc> <cmd>` | Chạy lệnh trong service đang chạy |
| `docker compose build` | Build các service có `build:` |
| `docker compose config` | In cấu hình đã gộp (kiểm tra trước khi chạy) |
| `docker compose stop` / `start` / `restart` | Dừng/chạy lại theo cụm |
| `docker compose up -d --scale web=2` | Chạy nhiều bản sao 1 service (cần dải cổng) |

### 21. Thực hành triển khai ứng dụng bằng Docker Compose

**Mô hình triển khai:** Web Application (Flask, image `typ-webapp:1.0-slim`, port 8890/8891) + MySQL 8.0 (volume `mysql-data`, healthcheck) — nối với nhau qua network `typ-lab_backend`.

**Các bước đã thực hiện:**

**1) Tạo Dockerfile cho Web Application** — dùng lại bản multi-stage ở mục 14 (`webapp/Dockerfile.multistage`), build qua `docker compose build` (dùng cache, vài giây).

**2) Viết `compose.yaml`** — như mục 20: khai báo 2 service, biến môi trường từ `.env`, volume cho MySQL, network chung.

**3) Cấu hình Network cho các service** — Compose tự tạo `typ-lab_backend`; web gọi MySQL qua **tên service** `mysql` (DNS nội bộ của Compose) — không cần biết IP.

**4) Sử dụng Volume để lưu dữ liệu MySQL** — `mysql-data:/var/lib/mysql`; Compose đặt tên thật là `typ-lab_mysql-data` (tiền tố project).

**5) Cấu hình biến môi trường kết nối Database** — `DB_HOST=mysql`, `DB_USER/DB_PASSWORD/DB_NAME` lấy từ `.env`; MySQL dùng cùng bộ biến để khởi tạo database `lab`.

**6) Khởi động, kiểm tra Log và xử lý lỗi:**

```text
$ docker compose -f compose.yaml up -d
 Container typ-mysql Started / Waiting / Healthy          # nhờ healthcheck
 Container typ-lab-web-1 Started

$ curl -s http://localhost:8890/ | grep -E "hostname|Phien ban|truy cap"
    <li>Container hostname: <b>50ef0b45460e</b></li>
    <li>Phien ban app: 1.0-slim</li>
  <p>So lan truy cap (MySQL): <b>1</b></p>

$ curl -s http://localhost:8890/            # gọi lần 2 -> bộ đếm trong MySQL tăng
  <p>So lan truy cap (MySQL): <b>2</b></p>
```

**Xử lý lỗi thực tế — dừng MySQL xem ứng dụng phản ứng:**

```text
$ docker compose -f compose.yaml stop mysql
$ curl -s http://localhost:8890/ | grep MySQL
  <p>MySQL: khong ket noi duoc ((2003, "Can't connect to MySQL server on 'mysql'
  ([Errno -3] Temporary failure in name resolution)"))</p>

$ docker compose -f compose.yaml start mysql
$ curl -s http://localhost:8890/ | grep 'truy cap'
  <p>So lan truy cap (MySQL): <b>3</b></p>       # kết nối lại OK, dữ liệu không mất
```

**7) `compose.override.yaml` — môi trường dev:** khi chạy *không* chỉ định `-f`, Compose tự gộp file override:

```text
$ docker compose config | grep -B1 -A1 APP_VERSION
    environment:
      APP_VERSION: 1.0-dev-override

$ docker compose up -d
 Container typ-lab-web-1 Recreated
$ curl -s http://localhost:8890/ | grep "Phien ban"
    <li>Phien ban app: 1.0-dev-override</li>     # override có hiệu lực
```

**8) Scale ngang 2 replica web:**

```text
$ docker compose up -d --scale web=2
 Container typ-lab-web-2 Created / Started

$ docker compose ps
NAME            IMAGE                 SERVICE   STATUS
typ-lab-web-1   typ-webapp:1.0-slim   web       Up (healthy)   0.0.0.0:8891->5000/tcp
typ-lab-web-2   typ-webapp:1.0-slim   web       Up (healthy)   0.0.0.0:8890->5000/tcp
typ-mysql       mysql:8.0             mysql     Up (healthy)

$ curl -s http://localhost:8890/ | grep hostname
    <li>Container hostname: <b>cbad67212a20</b></li>
$ curl -s http://localhost:8891/ | grep hostname
    <li>Container hostname: <b>77568b993908</b></li>
```

→ Hai replica **cùng image** nhưng là 2 container khác nhau (hostname khác nhau), cùng nói chuyện với 1 MySQL và ghi chung dữ liệu `visits` — minh họa nền tảng của scale ngang.

**9) Dừng và triển khai lại toàn bộ ứng dụng:**

```text
$ docker compose -f compose.yaml down
 Container typ-lab-web-1 Stopping / Removed
 Container typ-lab-web-2 Stopped / Removed
 Container typ-mysql Stopped / Removed
 Network typ-lab_backend Removed              # volume mysql-data VẪN GIỮ LẠI

$ docker compose -f compose.yaml up -d        # triển khai lại
 Network typ-lab_backend Created
 Container typ-mysql Started / Healthy
 Container typ-lab-web-1 Started
```

> `down` chỉ xóa **container + network**; dữ liệu MySQL vẫn nằm trong volume — lần `up` sau dữ liệu còn nguyên (đúng mô hình immutable infrastructure: container là "đồ dùng một lần", dữ liệu nằm ở volume).

---

## Tổng kết

**Kết quả đạt được tuần 3:**

| Mảng | Đã thực hành |
| --- | --- |
| Ảo hóa / VM | Kiểm tra VT-x, KVM; quan sát tài nguyên trong VM; điều chỉnh CPU/RAM/đĩa (25→30 GiB) **khi VM đang chạy/tắt**; snapshot/revert; clone; backup/restore; xóa VM |
| Container internals | Chứng minh bằng lệnh thật: namespace (`/proc/1/ns`), cgroup v2 (`memory.max`, `cpu.max`), OverlayFS/Copy-on-Write (`docker diff`, mount info), runc/OCI |
| Docker cơ bản | Cài đặt/kiểm tra Engine, daemon.json, systemd, proxy & registry (lý thuyết + trạng thái), ~20 lệnh Docker thường dùng |
| Image/Dockerfile | Viết app Flask + Dockerfile (non-root, HEALTHCHECK, exec form), `.dockerignore`, build cache, CMD/ENTRYPOINT, **multi-stage: 1.63GB → 201MB** |
| Networking | bridge mặc định vs user-defined, DNS 127.0.0.11, host/none network, veth/docker0, port mapping |
| Storage | Volume vs bind mount vs tmpfs, ephemeral storage, backup/restore volume, MySQL bền dữ liệu qua xóa container |
| Compose | `compose.yaml` + `.env` + `compose.override.yaml`, healthcheck, depends_on, scale 2 replica, xử lý lỗi mất kết nối DB, down/up |

**Hạn chế / chưa thực hiện:**

- Mục 15: **chưa chạy `docker login`/`push` thật lên Docker Hub** (không đăng nhập tài khoản trong buổi lab) — quy trình đã trình bày đầy đủ; các thao tác pull đã có minh chứng.
- Phần Live Migration/HA (mục 6): chỉ trình bày khái niệm do lab chỉ có **một** host KVM.
- Docker Registry nội bộ + CA/insecure-registries (mục 11): trình bày cấu hình, chưa dựng registry thật.

**Bài học rút ra:**

- Cùng một VM/host có thể vừa chạy **VM** (KVM) vừa chạy **container** (Docker) — hai mô hình ảo hóa khác nhau **bổ sung** cho nhau.
- **Snapshot/backup VM** và **volume** đều là cơ chế "dữ liệu không phụ thuộc vào thứ có thể bị xóa" — nguyên tắc cốt lõi của vận hành.
- Compose giúp chuyển cả "kiến trúc ứng dụng" thành **file khai báo** — nền tảng trước khi học Kubernetes.

---

## Phụ lục: Cấu trúc thư mục thực hành

```text
~/Desktop/TYP_CLOUD_TRAINING/docker-lab/week3/
├── webapp/                          # Ứng dụng Flask + Dockerfile
│   ├── app.py                       #   (hostname, thời gian, đếm lượt truy cập MySQL)
│   ├── requirements.txt
│   ├── Dockerfile                   #   single-stage (python:3.13)
│   ├── Dockerfile.multistage        #   multi-stage (python:3.13-slim)
│   └── .dockerignore
├── compose-app/                     # Docker Compose (mục 19-21)
│   ├── compose.yaml
│   ├── .env
│   └── compose.override.yaml
├── backup/                          # backup/export trong bài
│   ├── nginx.conf                   #   docker cp từ container
│   └── alpine.tar                   #   docker save/load demo
├── bindmount/                       # bind mount sample (mục 18)
├── backup-volume/                   # volume backup tar (mục 18)
├── tools/vmexec.sh                  # chạy lệnh trong VM qua qemu-guest-agent
├── evidence/                        # output thô của các lệnh trong báo cáo
└── lab-ubuntu-01-backup.xml         # bản XML backup VM chính

# (file backup đĩa VM dung lượng lớn đã được xóa sau khi thực hành để giải phóng ổ cứng)
```

