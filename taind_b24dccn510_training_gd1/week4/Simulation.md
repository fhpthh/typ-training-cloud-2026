# Phần 4: Kịch bản Thực hành Lab End-to-End (CI/CD + DevSecOps + Ansible)

Tài liệu này hướng dẫn chi tiết cách thiết lập kết nối giữa **Container Quản lý Ansible (`192.168.1.150` — Control Node)** và **Container chứa Docker từ Tuần 3 (`192.168.1.200` — Managed Node / Target VM)**, kết hợp kiểm thử **CI/CD Pipeline tích hợp DevSecOps** để triển khai tự động ứng dụng **Cloud Note App (3-Tier)**, kèm kịch bản quay Video Demo thuyết trình trong 5 - 7 phút.

---

## 0. Thiết lập Môi trường Mô phỏng (Kế thừa từ Tuần 2 & Tuần 3)

Hệ thống mô phỏng tận dụng trực tiếp 2 Container LXC đã sử dụng ở các tuần trước với vai trò tách biệt chuẩn kiến trúc **Control Node — Managed Node**:

1. **Ansible Control Node (`192.168.1.150` — Container Quản lý từ Tuần 2):**
   - Đã được cấu hình SSH hoàn chỉnh ở Tuần 2 (kết nối từ máy Windows qua `ssh lxc-ubuntu` với user `skyboy12`).
   - Đóng vai trò **Máy trạm điều khiển trung tâm (Control Node)**: cài đặt **Ansible**, lưu trữ bộ Playbook/Roles (`lab-cicd-ansible/`) và phát lệnh triển khai tự động.
2. **Target VM / Managed Node (`192.168.1.200` — Container chứa Docker từ Tuần 3):**
   - Là Container đã cài đặt sẵn **Docker Engine + Docker Compose V2** và chạy ứng dụng 3-Tier (`notes_frontend_service`, `notes_backend_service`, `notes_db_service`) cùng `week3_mysql_notes_volume` ở Tuần 3.
   - **Thư mục ứng dụng hiện có:** `/home/skyboy12/app` (`~/app`).
   - **Trạng thái ban đầu:** Chưa thiết lập dịch vụ SSH Server và chưa kết nối khóa SSH với Control Node (`192.168.1.150`).

---

## 1. Sơ đồ Kiến trúc & Luồng Hoạt động End-to-End

```text
+----------------------------------------------------------------------------------------------------------------+
|                                   HỆ THỐNG LAB CI/CD + DEVSECOPS + ANSIBLE                                     |
+----------------------------------------------------------------------------------------------------------------+

  [Máy Windows (Workstation)]
       │
       │ 1. ssh lxc-ubuntu (hoặc GitLab CI / Jenkins Webhook)
       ▼
+---------------------------------------------------------------------------------------------------+
| ANSIBLE CONTROL NODE / CONTAINER QUẢN LÝ (192.168.1.150)                                          |
|  - User: skyboy12 | SSH Key đi Managed Node: ~/.ssh/id_ed25519_ansible                            |
|                                                                                                   |
|  [Stage 1: Secret & SAST]  ──>  [Stage 2: Build Image]  ──>  [Stage 3: Container Scan]            |
|   - Gitleaks (Quét Secret)       - Build Frontend Image       - Trivy Scan (Security Gate)        |
|   - Bandit (SAST) & API Test     - Build Backend Image        - Push lên Container Registry       |
|                                                                        │                          |
|                                                                        ▼                          |
|                                                        [Stage 4: Ansible Automated Deploy]        |
|                                                         - Chạy ansible-playbook deploy.yml        |
+---------------------------------------------------------------------------------------------------+
                                                                         │
                                            3. Pull Image                │ 4. SSH (Port 22 - Agentless)
                                               từ Registry               │    192.168.1.150 ──> 192.168.1.200
                                                                         ▼    (skyboy12@192.168.1.200)
+-----------------------------------+                     +---------------------------------------------------+
| CONTAINER REGISTRY                | <================== | TARGET VM: CONTAINER DOCKER TUẦN 3 (192.168.1.200)|
| (Docker Hub / GitLab Registry)    |                     |  - Cài đặt OpenSSH Server + Python3 cho Ansible   |
|  - cloud-note-frontend:2.0.x      |                     |  - Role 1 (docker_setup): Kiểm tra Docker đã có   |
|  - cloud-note-backend:2.0.x       |                     |    từ Tuần 3 -> Báo [ok / skipped] (Idempotent!)  |
+-----------------------------------+                     |  - Role 2 (cloud_note_deploy): Render .env (0600) |
                                                          |    & compose.yaml -> Kéo Image mới -> Tái sử dụng |
                                                          |    [week3_mysql_notes_volume] & Verify /health    |
                                                          +---------------------------------------------------+
```

---

## 2. Cấu trúc Thư mục Thực hành (`week4/`)

```text
week4/
├── README.md                                          # Kiến thức trọng tâm Tuần 4 (CI/CD, Ansible, DevSecOps)
├── Simulation.md                                      # Hướng dẫn vận hành Lab & Kịch bản quay Video Demo
├── AI_Helper/
│   ├── README.md                                      # Phân rã yêu cầu & Lộ trình học tập
│   └── REPORT.md                                      # Báo cáo chuyên sâu toàn diện
└── lab-cicd-ansible/                                  # Mã nguồn thực hành Lab End-to-End
    ├── .gitlab-ci.yml                                 # Định nghĩa Pipeline cho GitLab CI/CD
    ├── Jenkinsfile                                    # Định nghĩa Declarative Pipeline cho Jenkins
    ├── .gitleaks.toml                                 # Cấu hình quy tắc quét lộ lọt Secret (Gitleaks)
    ├── .trivyignore                                   # Danh sách quản lý ngoại lệ CVE (Trivy)
    └── ansible/                                       # Đặt trên Container Quản lý (192.168.1.150)
        ├── ansible.cfg                                # Cấu hình user=skyboy12, key=id_ed25519_ansible
        ├── deploy.yml                                 # Master Playbook điều phối triển khai
        ├── inventory/
        │   └── hosts.ini                              # Khai báo docker_target_vm (192.168.1.200)
        └── roles/
            ├── docker_setup/                          # Role 1: Đảm bảo Docker Engine & Compose V2 sẵn sàng
            │   └── tasks/main.yml
            └── cloud_note_deploy/                     # Role 2: Triển khai 3-Tier App & Kiểm tra Healthcheck
                ├── defaults/main.yml                  # Biến mặc định (Image tag, Port, DB config)
                ├── handlers/main.yml                  # Handler khởi động lại stack khi cấu hình đổi
                ├── tasks/main.yml                     # Các bước tạo file, pull image, verify /health
                └── templates/
                    ├── .env.j2                        # Jinja2 Template cho file biến môi trường bảo mật
                    └── compose.yaml.j2                # Jinja2 Template kết nối week3_mysql_notes_volume
```

---

## 3. Các bước Thiết lập và Vận hành Thực tế

### Bước 1: Thiết lập SSH Server trên Container Docker (`192.168.1.200` — Managed Node)
Do Container chứa Docker tuần trước (`192.168.1.200`) **chưa được thiết lập SSH**, còn Ansible lại hoạt động theo kiến trúc **Agentless (giao tiếp qua SSH + Python3)**, trước tiên bạn mở **Console (`root`) của Container `192.168.1.200`** và thực hiện:

```bash
# 1. Cài đặt OpenSSH Server, sudo và Python 3 (môi trường thực thi module của Ansible)
apt update && apt install -y openssh-server sudo python3

# 2. Kích hoạt và khởi chạy dịch vụ SSH (Ubuntu 22.04 / 24.04)
systemctl enable --now ssh || systemctl enable --now ssh.socket

# 3. Tạo tài khoản vận hành skyboy12 (nếu chưa có) và thêm vào nhóm sudo + docker
id skyboy12 || adduser skyboy12
usermod -aG sudo,docker skyboy12

# 4. Cấp quyền sudo NOPASSWD để Ansible thực thi become: true tự động không bị treo hỏi mật khẩu
echo "skyboy12 ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/skyboy12_ansible
chmod 0440 /etc/sudoers.d/skyboy12_ansible

# 5. Kiểm tra IP và trạng thái cổng 22 cùng các container từ Tuần 3
ip -br a
ss -tlnp | grep :22
docker ps
```

---

### Bước 2: Thiết lập Ansible trên Container Quản lý (`192.168.1.150`) & Kết nối SSH sang `192.168.1.200`
Từ máy Windows, đăng nhập vào **Container Quản lý (`192.168.1.150`)** qua alias `ssh lxc-ubuntu` đã tạo ở Tuần 2, sau đó cài đặt Ansible và trao đổi khóa SSH sang Container Docker (`192.168.1.200`):

```bash
# 1. Từ Windows PowerShell: Đăng nhập vào Container Quản lý (192.168.1.150)
ssh lxc-ubuntu

# 2. Trên Container Quản lý (192.168.1.150): Cài đặt Ansible và Git
sudo apt update && sudo apt install -y ansible git python3-pip
ansible --version

# 3. Tạo cặp khóa SSH Ed25519 chuyên dụng cho Ansible trên Control Node (192.168.1.150)
ssh-keygen -t ed25519 -C "ansible-control@192.168.1.150" -f ~/.ssh/id_ed25519_ansible -N ""

# 4. Đẩy Public Key từ Control Node (192.168.1.150) sang Container Docker (192.168.1.200)
ssh-copy-id -i ~/.ssh/id_ed25519_ansible.pub skyboy12@192.168.1.200

# 5. Kiểm tra kết nối SSH không mật khẩu và thư mục ~/app từ 192.168.1.150 sang 192.168.1.200
ssh -i ~/.ssh/id_ed25519_ansible skyboy12@192.168.1.200 "hostname && ls -la ~/app && docker --version && docker volume ls"
```

Output kỳ vọng:
```text
docker-lxc
total 28
drwxrwxr-x 4 skyboy12 skyboy12 4096 Oct 18 09:00 .
drwxr-x--- 5 skyboy12 skyboy12 4096 Oct 18 09:00 ..
-rw------- 1 skyboy12 skyboy12  245 Oct 18 09:00 .env
drwxrwxr-x 2 skyboy12 skyboy12 4096 Oct 18 09:00 backend
-rw-rw-r-- 1 skyboy12 skyboy12 1620 Oct 18 09:00 compose.yaml
drwxrwxr-x 2 skyboy12 skyboy12 4096 Oct 18 09:00 frontend
-rwxrwxr-x 1 skyboy12 skyboy12 1890 Oct 18 09:00 run_standalone.sh
Docker version 26.1.4, build 5650f9b
DRIVER    VOLUME NAME
local     week3_mysql_notes_volume
```

---

### Bước 3: Kiểm tra kết nối bằng Ansible Ad-hoc Command (`192.168.1.150` $\rightarrow$ `192.168.1.200`)
Trên **Container Quản lý (`192.168.1.150`)**, di chuyển vào thư mục `lab-cicd-ansible/ansible` và kiểm tra kết nối tới `docker_target_vm` (`192.168.1.200`):

```bash
cd lab-cicd-ansible/ansible

# 1. Kiểm tra kết nối SSH + Python bằng module ping
ansible all -i inventory/hosts.ini -m ping

# 2. Kiểm tra các container đang chạy trên Container Docker (192.168.1.200) từ xa
ansible all -i inventory/hosts.ini -a "docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}'"
```

Output mẫu:
```text
docker_target_vm | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}

docker_target_vm | CHANGED | rc=0 >>
NAMES                    IMAGE                                STATUS
notes_frontend_service   skyboy12/cloud-note-frontend:2.0.0   Up 2 days
notes_backend_service    skyboy12/cloud-note-backend:2.0.0    Up 2 days
notes_db_service         mysql:8.0                            Up 2 days (healthy)
```

---

### Bước 4: Chạy Kiểm tra Bảo mật (DevSecOps) trên Container Docker (`192.168.1.200`)
Vì **Container Docker (`192.168.1.200`)** là nơi có sẵn Docker Engine, chứa mã nguồn tại `/home/skyboy12/app` (`~/app`) và lưu trữ các Docker Image đã build, bạn thực hiện bước quét **DevSecOps (Security Gate)** trực tiếp trên **Container Docker (`192.168.1.200`)** (hoặc SSH từ `192.168.1.150` sang `192.168.1.200`):

```bash
# Di chuyển vào thư mục ứng dụng trên Container Docker (192.168.1.200)
cd ~/app

# 1. [Secret Scan] Quét lộ lọt Secret trong thư mục ~/app bằng Gitleaks (--no-git quét trực tiếp file)
docker run --rm -v "$(pwd):/path" zricethezav/gitleaks:latest \
  detect --source="/path" --no-git --verbose --redact

# 2. [SAST] Quét lỗ hổng mã nguồn tĩnh Python cho ~/app/backend bằng Bandit
docker run --rm -v "$(pwd)/backend:/code" python:3.11-slim \
  sh -c "pip install -q bandit && bandit -r /code -ll -ii"

# 3. [Container Image Scan] Quét lỗ hổng CVE trên 2 Docker Images bằng Trivy (Security Gate)
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy:latest image --severity CRITICAL --ignore-unfixed --exit-code 1 skyboy12/cloud-note-backend:2.0.0

docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy:latest image --severity CRITICAL --ignore-unfixed --exit-code 1 skyboy12/cloud-note-frontend:2.0.0
```

---

### Bước 5: Thực thi Ansible Playbook từ `192.168.1.150` Triển khai sang `192.168.1.200`
Trên **Container Quản lý (`192.168.1.150`)**, kiểm tra cú pháp, chạy chế độ Dry-run (`--check --diff`) và thực thi triển khai chính thức sang **Container Docker (`192.168.1.200`)**:

```bash
cd lab-cicd-ansible/ansible

# 1. Kiểm tra cú pháp YAML của Playbook và các Roles
ansible-playbook -i inventory/hosts.ini deploy.yml --syntax-check

# 2. Chạy thử chế độ Dry-run (--check) và xem sự thay đổi file (--diff)
ansible-playbook -i inventory/hosts.ini deploy.yml --check --diff

# 3. Thực thi triển khai chính thức từ 192.168.1.150 sang 192.168.1.200
ansible-playbook -i inventory/hosts.ini deploy.yml \
  -e "ansible_host=192.168.1.200" \
  -e "backend_image=skyboy12/cloud-note-backend:2.0.0" \
  -e "frontend_image=skyboy12/cloud-note-frontend:2.0.0"
```

**Quan sát kết quả thực thi trên `docker_target_vm` (`192.168.1.200`):**
- **Role 1 (`docker_setup`):**
  - Task `2. Kiểm tra xem Docker Engine đã được cài đặt trên VM chưa` trả về `ok: [docker_target_vm]`.
  - Task `3. Cài đặt Docker Engine & Docker Compose V2 chính thức nếu chưa có` tự động báo **`skipping: [docker_target_vm]`** nhờ điều kiện `when: docker_installed.rc != 0` — minh chứng trực quan nhất cho tính **Idempotency (Lũy đẳng)** khi chạy trên Container đã có sẵn Docker từ Tuần 3!
  - Task `4. Đảm bảo dịch vụ Docker luôn hoạt động` và `5. Thêm user vận hành vào group docker` đều báo `ok: [docker_target_vm]` (`changed=0`).
- **Role 2 (`cloud_note_deploy`):**
  - Thao tác trực tiếp trên thư mục `/home/skyboy12/app` của Container `192.168.1.200` (nơi lưu ứng dụng từ Tuần 3), đồng bộ lại file `.env` (quyền `0600`) và `compose.yaml` kết nối trực tiếp vào `week3_mysql_notes_volume` và `week3_notes_network`.
  - Vì giữ nguyên đường dẫn `/home/skyboy12/app` (tên project Compose vẫn là `app`), lệnh `docker compose up -d --pull always --remove-orphans` sẽ cập nhật trực tiếp 3 containers hiện hữu (`notes_frontend_service`, `notes_backend_service`, `notes_db_service`) mà **không tạo ra project trùng lặp và không làm mất dữ liệu ghi chú đã tạo ở Tuần 3**.
  - Task `5. Chờ và xác thực Healthcheck của ứng dụng` gọi `http://localhost:8080/health` trên `192.168.1.200` và nhận phản hồi `{"database": "connected", "status": "healthy"}` (`200 OK`).

---

### Bước 6: Cấu hình Secrets trên GitLab CI/CD hoặc Jenkins
Vào mục **Settings $\rightarrow$ CI/CD $\rightarrow$ Variables** (trên GitLab) hoặc **Manage Jenkins $\rightarrow$ Credentials** (trên Jenkins) và khai báo các biến bảo mật sau:

| Tên Biến (Key) | Giá trị mẫu / Mô tả | Thuộc tính Bảo mật |
| :--- | :--- | :--- |
| `REGISTRY_USER` | `skyboy12` (Username Docker Hub / Registry) | Protected |
| `REGISTRY_PASSWORD` | Personal Access Token (PAT) của Docker Hub | **Masked** & Protected |
| `SSH_PRIVATE_KEY` | Nội dung file `~/.ssh/id_ed25519_ansible` (Khóa kết nối sang `192.168.1.200`) | **File / Masked** & Protected |
| `TARGET_VM_IP` | `192.168.1.200` (IP của Container Docker Tuần 3) | Protected |
| `DB_PASSWORD` | `SecurePassword2026@` | **Masked** |
| `DB_ROOT_PASSWORD` | `RootAdminSecret2026@` | **Masked** |

---

## 4. Kịch bản Quay Video Demo Thuyết trình (5 - 7 Phút)

Để bài thuyết trình mạch lạc và thể hiện rõ mô hình **Control Node (`192.168.1.150`) điều khiển Managed Node (`192.168.1.200`)**, bạn có thể quay video demo theo 4 phân cảnh sau:

1. **Phân cảnh 1 (1.5 phút) - Thiết lập kết nối SSH từ Container Quản lý (`192.168.1.150`) sang Container Docker (`192.168.1.200`):**
   - Giới thiệu nhanh 2 cửa sổ terminal:
     - Cửa sổ 1: **Control Node (`192.168.1.150`)** — Container quản lý từ Tuần 2 chứa Ansible và bộ code `lab-cicd-ansible/`.
     - Cửa sổ 2: **Managed Node (`192.168.1.200`)** — Container chứa Docker và ứng dụng 3-Tier từ Tuần 3.
   - Chạy lệnh `ansible all -i inventory/hosts.ini -m ping` từ `192.168.1.150` sang `192.168.1.200` nhận phản hồi `"ping": "pong"` màu xanh lá.
2. **Phân cảnh 2 (1.5 phút) - Kích hoạt CI/CD Pipeline & Quan sát Security Gate:**
   - Giải thích nhanh 4 Stages trong `.gitlab-ci.yml` / `Jenkinsfile`.
   - Show kết quả quét bảo mật của **Gitleaks** (Secret Scan), **Bandit** (SAST) và **Trivy** (quét 2 Docker Images `frontend` & `backend` với kết quả `0 CRITICAL vulnerabilities`).
3. **Phân cảnh 3 (1.5 phút) - Chạy `ansible-playbook` từ `192.168.1.150` Triển khai sang `192.168.1.200`:**
   - Trên `192.168.1.150`, chạy `ansible-playbook -i inventory/hosts.ini deploy.yml`.
   - Chỉ rõ tính **Idempotency (Lũy đẳng)**: Vì Container `192.168.1.200` đã có sẵn Docker từ Tuần 3, Role `docker_setup` tự động báo `ok` (màu xanh lá) và `skipping` bước cài đặt lại Docker; chỉ có Role `cloud_note_deploy` thực hiện render `.env`/`compose.yaml` và cập nhật containers.
   - Chỉ vào bước cuối của Playbook: Task `Chờ và xác thực Healthcheck của ứng dụng` trả về `status: 200` (`{"database": "connected", "status": "healthy"}`).
4. **Phân cảnh 4 (1 phút) - Kiểm chứng Ứng dụng & Dữ liệu Bền vững trên `192.168.1.200`:**
   - Mở trình duyệt truy cập `http://192.168.1.200:8080`.
   - Chỉ cho người xem thấy **các ghi chú từ Tuần 3 vẫn còn nguyên vẹn** (nhờ tái sử dụng `week3_mysql_notes_volume`) và thêm một ghi chú mới để chứng minh cả 3 tầng hoạt động trơn tru.
