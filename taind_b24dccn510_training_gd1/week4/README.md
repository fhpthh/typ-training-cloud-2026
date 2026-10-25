# Tuần 4: CI/CD, Ansible và DevSecOps

## Phần 1: Tổng quan về CI/CD

### 1. CI/CD là gì?
- **Khái niệm DevOps và CI/CD:**
  - **DevOps (Development + Operations):** Là sự kết hợp giữa văn hóa, quy trình và công cụ nhằm xóa bỏ rào cản giữa đội ngũ Phát triển (Dev - ưu tiên tốc độ tính năng mới) và Vận hành (Ops - ưu tiên sự ổn định hệ thống), tự động hóa xuyên suốt vòng đời phát triển phần mềm.
  - **CI/CD:** Là trụ cột kỹ thuật cốt lõi của DevOps, thiết lập dây chuyền tự động hóa từ khâu lập trình viên đẩy mã nguồn (`git push`) cho đến khi kiểm thử, đóng gói và triển khai ứng dụng lên môi trường thực tế.
- **Mục đích và vai trò của CI/CD trong quy trình phát triển phần mềm:**
  - **Phát hiện lỗi sớm (Fail Fast, Fix Fast):** Kiểm tra cú pháp, bảo mật và chạy Unit Test ngay sau mỗi lần commit.
  - **Loại bỏ thao tác thủ công:** Thay thế hoàn toàn việc tự build, copy file và chạy lệnh triển khai thủ công trên từng server, xóa bỏ rủi ro do sai sót con người (Human Error).
  - **Chuẩn hóa & Tăng tốc độ phát hành (Time-to-Market):** Đưa tính năng mới tới người dùng nhanh chóng với các bản cập nhật nhỏ, an toàn và liên tục.
- **Continuous Integration (CI), Continuous Delivery và Continuous Deployment:**
  - **Continuous Integration (CI - Tích hợp liên tục):** Lập trình viên thường xuyên merge code vào nhánh chung nhiều lần trong ngày. Mỗi lần đẩy code sẽ tự động kích hoạt quá trình Linting, Build và chạy Automated Test để tránh xung đột lớn (*Merge Hell*).
  - **Continuous Delivery (Chuyển giao liên tục):** Mở rộng từ CI; tự động đóng gói Artifact và triển khai lên môi trường thử nghiệm (**Staging**). Mã nguồn luôn sẵn sàng lên Production bất cứ lúc nào, nhưng bước đẩy lên **Production** cần **phê duyệt thủ công (Manual Approval)**.
  - **Continuous Deployment (Triển khai liên tục):** Mức tự động hóa cao nhất; mọi commit vượt qua toàn bộ các bước kiểm thử tự động sẽ được **triển khai thẳng lên Production hoàn toàn tự động** mà không cần con người can thiệp.
- **Phân biệt CI, Continuous Delivery và Continuous Deployment:**

  | Tiêu chí | Continuous Integration (CI) | Continuous Delivery (CD) | Continuous Deployment (CD) |
  | :--- | :--- | :--- | :--- |
  | **Mục tiêu chính** | Đảm bảo code gộp vào nhánh chung luôn build và pass test | Đảm bảo bản đóng gói luôn sẵn sàng phát hành bất cứ lúc nào | Tự động hóa 100% từ lúc commit đến khi lên thẳng Production |
  | **Điểm dừng tự động** | Tạo ra gói **Artifact / Docker Image** hợp lệ | Triển khai tự động lên **Staging**; chờ lệnh duyệt trước **Prod** | Triển khai tự động thẳng lên **Production** |
  | **Can thiệp thủ công** | Không (tự động chạy khi push/MR) | **Có** (Bấm nút Approve để lên Production) | **Không** (Zero human intervention) |
  | **Yêu cầu hệ thống** | Cần Unit Test & Linter cơ bản | Cần thêm Integration Test, Security Scan | Đòi hỏi bộ E2E Test, Monitoring & Auto-Rollback cực kỳ hoàn chỉnh |

- **Quy trình từ khi Developer viết code đến khi ứng dụng được triển khai:**
  ```text
  [1. Code & Commit] ──> [2. Push / Merge Request] ──> [3. CI: Lint, SAST & Unit Test]
                                                               │
  [7. Monitor & Verify] <── [6. CD: Deploy Staging/Prod] <── [4 & 5. Build, Scan & Push Image]
  ```
- **Lợi ích và hạn chế của CI/CD:**
  - **Lợi ích:** Nâng cao chất lượng code, giảm áp lực ngày phát hành, dễ dàng khoanh vùng lỗi và khôi phục (Rollback) nhanh, minh bạch hóa trạng thái hệ thống.
  - **Hạn chế/Thách thức:** Chi phí thời gian đầu tư dựng Pipeline và viết Automated Test ban đầu lớn; phải duy trì, cập nhật bộ test thường xuyên (tránh *Flaky Tests*); máy chủ CI/CD nắm giữ nhiều khóa bí mật nên cần bảo mật nghiêm ngặt.

### 2. CI/CD Pipeline
- **Khái niệm CI/CD Pipeline & Các thành phần:**
  - **Pipeline:** Luồng công việc tự động hóa được định nghĩa bằng mã nguồn (**Pipeline as Code** như `.gitlab-ci.yml`, `Jenkinsfile`).
  - **Trigger:** Sự kiện đánh thức Pipeline chạy.
  - **Stage:** Nhóm các công việc chạy **tuần tự** (ví dụ: `test` $\rightarrow$ `build` $\rightarrow$ `security_scan` $\rightarrow$ `deploy`). Stage trước thành công thì Stage sau mới chạy.
  - **Job:** Đơn vị công việc cụ thể bên trong một Stage. Các Job trong cùng một Stage mặc định chạy **song song** để tiết kiệm thời gian.
  - **Step / Script:** Từng câu lệnh shell được thực thi tuần tự trong một Job.
- **Pipeline Trigger:**
  - **Push Trigger:** Tự động chạy khi có commit mới đẩy lên nhánh hoặc khi tạo Git Tag (`v1.0.0`).
  - **Pull Request (PR) / Merge Request (MR):** Chạy kiểm tra nhánh tính năng trước khi cho phép gộp vào nhánh chính.
  - **Manual Trigger (`when: manual`):** Đợi người có thẩm quyền bấm nút xác nhận trên giao diện (thường dùng cho Deploy Production hoặc Rollback).
  - **Scheduled / Webhook Trigger:** Chạy định kỳ theo lịch Cron (ví dụ quét bảo mật hàng đêm) hoặc gọi qua API từ hệ thống khác.
- **Source Code Management (SCM) và vai trò của Git trong CI/CD:**
  - Git đóng vai trò là **Single Source of Truth** lưu trữ cả mã nguồn ứng dụng, `Dockerfile`, cấu hình Pipeline và kịch bản hạ tầng Ansible.
- **Build Automation và Automated Testing:**
  - **Build Automation:** Tự động biên dịch và đóng gói ứng dụng (`docker build`, `mvn package`, `npm run build`).
  - **Automated Testing:** Áp dụng kim tự tháp kiểm thử gồm **Unit Test** (kiểm thử hàm/module độc lập, nhanh nhất), **Integration Test** (kiểm thử kết nối DB/API) và **E2E Test** (kiểm thử luồng giao diện/hệ thống).
- **Artifact và Artifact Management:**
  - **Artifact:** Sản phẩm đầu ra của quá trình Build/Test (Docker Image, file `.jar`/`.whl`, báo cáo test/bảo mật).
  - **Nguyên tắc "Build Once, Deploy Anywhere":** Chỉ build Artifact **duy nhất một lần**, đẩy lên kho lưu trữ (**Docker Hub, Harbor, GitLab Container Registry, Nexus, JFrog Artifactory**), sau đó kéo chính gói đã kiểm chứng đó để triển khai xuyên suốt qua các môi trường.
- **Environment Variables và Quản lý các môi trường (Development, Staging, Production):**
  - Tách biệt hoàn toàn cấu hình khỏi mã nguồn thông qua biến môi trường.
  - **Development:** Môi trường cho lập trình viên tích hợp, bật debug, dùng dữ liệu giả lập.
  - **Staging (Pre-production):** Bản sao phản chiếu giống hệt cấu hình Production để kiểm thử E2E, kiểm thử tải và nghiệm thu.
  - **Production:** Môi trường phục vụ người dùng thực tế, bảo mật và tính sẵn sàng cao nhất.
- **Deployment Strategies (Chiến lược triển khai):**

  | Chiến lược | Cơ chế hoạt động | Ưu điểm | Hạn chế |
  | :--- | :--- | :--- | :--- |
  | **Rolling Update** | Thay thế dần từng instance bản cũ (`v1`) bằng bản mới (`v2`) theo đợt cuốn chiếu | Không tốn thêm tài nguyên máy chủ dự phòng; Zero-downtime | Tồn tại song song `v1` và `v2` trong lúc nâng cấp; Rollback chậm hơn |
  | **Blue-Green** | Duy trì 2 môi trường giống hệt nhau: **Blue** (`v1`) và **Green** (`v2`). Kiểm tra xong Green thì chuyển 100% lưu lượng sang Green | Chuyển mạch tức thì; **Rollback siêu tốc** trong 1 giây bằng cách trỏ lại về Blue | Chi phí hạ tầng tăng gấp đôi trong quá trình triển khai |
  | **Canary Release** | Điều hướng một tỷ lệ nhỏ người dùng (5% traffic) sang bản mới (`v2`) để thăm dò, nếu ổn định mới tăng dần lên 100% | Rủi ro thấp nhất; kiểm chứng được trên người dùng thật với phạm vi ảnh hưởng nhỏ | Cần bộ định tuyến/Load Balancer thông minh và hệ thống giám sát chặt chẽ |

- **Rollback và Release Management:**
  - Quản lý phiên bản theo chuẩn **Semantic Versioning (`vMAJOR.MINOR.PATCH`)**. Khi bản mới gặp sự cố trên Production, thực hiện **Rollback** tức thì bằng cách triển khai lại tag Docker Image ổn định liền trước.

### 3. Tổng quan về các nền tảng CI/CD
- **Các nền tảng CI/CD phổ biến và kiến trúc chính:**
  - **GitLab CI/CD:** Tích hợp All-in-one trong GitLab. Gồm **GitLab Server** (quản lý repo, giao diện, điều phối pipeline từ file `.gitlab-ci.yml`) và **GitLab Runner** (tác nhân nhẹ viết bằng Go nhận job về thực thi).
  - **Jenkins:** Máy chủ tự động hóa mã nguồn mở viết bằng Java theo kiến trúc **Jenkins Controller (Master)** điều phối và **Jenkins Agent (Node)** thực thi thông qua SSH/JNLP. Định nghĩa pipeline bằng ngôn ngữ Groovy trong file `Jenkinsfile`.
  - **GitHub Actions:** Tích hợp trực tiếp trong GitHub, hoạt động hướng sự kiện (Event-driven) thông qua các file YAML tại `.github/workflows/*.yml`, tận dụng kho Actions tái sử dụng phong phú.
- **Runner, Agent và Execution Environment (Executors):**
  - **Shell Executor:** Chạy lệnh trực tiếp trên OS của máy cài Runner (nhanh nhưng kém cô lập).
  - **Docker Executor (Khuyên dùng):** Mỗi Job được chạy trong một container mới tinh, sạch sẽ và cô lập hoàn toàn, xong việc tự xóa.
  - **Kubernetes Executor:** Khởi tạo mỗi Job như một Pod trên cụm Kubernetes, dễ dàng co giãn tự động (Auto-scaling).
- **Phân biệt Hosted Runner và Self-hosted Runner:**

  | Tiêu chí | Hosted Runner (Shared / Cloud Runner) | Self-hosted Runner (Máy chủ tự quản lý) |
  | :--- | :--- | :--- |
  | **Quản trị hạ tầng** | Do nền tảng Cloud (GitLab/GitHub) quản lý hoàn toàn | Do đội ngũ DevOps tự cài đặt và bảo trì trên VM/Server riêng |
  | **Kết nối mạng nội bộ** | **Không thể** truy cập trực tiếp vào các VM trong mạng LAN nội bộ | **Có thể** nằm trong mạng Private LAN để chạy Ansible/SSH tới các VM đích |
  | **Chi phí & Hiệu năng** | Giới hạn số phút chạy miễn phí; ít tận dụng được cache cục bộ | Không giới hạn số phút chạy; tùy chỉnh cấu hình phần cứng và giữ Docker Cache cục bộ |

- **Quản lý Credentials, Variables và Secrets:**
  - Sử dụng **Masked Variables** (che thành `[MASKED]` trên log), **Protected Variables** (chỉ mở khóa cho nhánh `main`/tag bảo vệ), **File Variables** (cho `SSH_PRIVATE_KEY`) hoặc tích hợp **HashiCorp Vault / Ansible Vault**.
- **So sánh GitLab CI/CD và Jenkins:**

  | Tiêu chí | GitLab CI/CD | Jenkins |
  | :--- | :--- | :--- |
  | **Kiến trúc nền tảng** | Tích hợp đồng bộ (Git + CI/CD + Container Registry + Security) | Máy chủ CI/CD độc lập, phụ thuộc vào việc cài đặt >1.800 Plugins |
  | **Cú pháp cấu hình** | **YAML (`.gitlab-ci.yml`)** ngắn gọn, trực quan | **Groovy DSL (`Jenkinsfile`)** linh hoạt nhưng phức tạp hơn |
  | **Vận hành & Bảo trì** | Nhẹ nhàng, GitLab Runner hỗ trợ Docker Executor nguyên bản rất tốt | Tốn công bảo trì Java Controller và xử lý xung đột phiên bản Plugin |

---

## Phần 2: Tổng quan về Ansible

### 4. Giới thiệu về Ansible
- **Khái niệm Configuration Management & Tính lũy đẳng (Idempotency):**
  - **Configuration Management (Quản lý cấu hình):** Tự động hóa việc thiết lập và duy trì trạng thái nhất quán của hệ điều hành, gói phần mềm và tệp cấu hình trên nhiều máy chủ, chống lại sự sai lệch cấu hình theo thời gian (*Configuration Drift*).
  - **Idempotency (Tính lũy đẳng):** Đặc tính đảm bảo một kịch bản chạy **1 lần hay N lần** đều cho ra **cùng một trạng thái đích duy nhất**, không sinh ra thay đổi dư thừa nếu hệ thống đã đạt trạng thái mong muốn.
- **Ansible là gì và các trường hợp sử dụng:**
  - Ansible là công cụ tự động hóa CNTT mã nguồn mở theo hướng khai báo (**Declarative**) và không cần cài đặt agent trên máy đích (**Agentless**).
  - **Ứng dụng:** Quản lý cấu hình (Configuration Management), Triển khai ứng dụng (Application Deployment), Khởi tạo hạ tầng (Provisioning) và Tự động hóa vận hành (Operational Automation).
- **So sánh Ansible với Shell Script:**

  | Tiêu chí | Shell Script (Bash) | Ansible (Playbooks / Roles) |
  | :--- | :--- | :--- |
  | **Tư duy viết kịch bản** | **Imperative (Mệnh lệnh):** Chỉ định *cách làm từng bước* | **Declarative (Khai báo):** Mô tả *trạng thái đích mong muốn* (`state: present`) |
  | **Tính lũy đẳng (Idempotency)** | **Không có sẵn:** Chạy nhiều lần dễ gây ghi đè hoặc lặp dòng cấu hình | **Tích hợp nguyên bản:** Tự động kiểm tra trước khi thay đổi (`OK` vs `CHANGED`) |
  | **Thực thi đa máy chủ** | Phải tự viết vòng lặp SSH thủ công, khó xử lý lỗi | Kết nối song song (Forks) tới hàng trăm máy, báo cáo kết quả trực quan |
  | **Độ tương thích & Bảo trì** | Phụ thuộc lệnh của từng bản phân phối OS, script dài khó đọc | Định dạng **YAML** gọn gàng, chuẩn hóa tái sử dụng qua **Roles** |

- **Control Node, Managed Node và Cơ chế giao tiếp qua SSH:**
  - **Control Node:** Máy điều khiển cài đặt Ansible (`ansible`, `ansible-playbook`), chứa Inventory và Playbooks (chạy trên Linux/macOS/WSL2).
  - **Managed Node:** Các máy chủ đích được quản lý. Không cần cài agent, chỉ cần mở cổng **SSH** và có **Python**.
  - **Cơ chế SSH:** Control Node mở kết nối OpenSSH $\rightarrow$ đẩy script Python của Module vào `~/.ansible/tmp/` trên Managed Node $\rightarrow$ thực thi và nhận kết quả JSON trả về $\rightarrow$ xóa sạch file tạm.

### 5. Cài đặt và cấu hình Ansible
- **Phân biệt Ansible Core và Ansible Community Package:**
  - **`ansible-core`:** Phần nhân tối giản gồm CLI (`ansible`, `ansible-playbook`, `ansible-galaxy`, `ansible-vault`) và ~70 module cơ bản (`ansible.builtin.*`).
  - **`ansible` (Community Package):** Bao gồm `ansible-core` cộng với hàng chục **Ansible Collections** cộng đồng đóng gói sẵn (`community.docker`, `community.general`,...).
- **Cài đặt Ansible trên Ubuntu / RHEL và kiểm tra phiên bản:**
  ```bash
  # Trên Ubuntu / Debian
  sudo apt update && sudo apt install -y software-properties-common
  sudo add-apt-repository --yes --update ppa:ansible/ansible
  sudo apt install -y ansible

  # Trên RHEL / Rocky Linux / AlmaLinux
  sudo dnf install -y epel-release && sudo dnf install -y ansible

  # Kiểm tra phiên bản
  ansible --version
  ```
- **File cấu hình `ansible.cfg` (Thứ tự ưu tiên: `ANSIBLE_CONFIG` $\rightarrow$ `./ansible.cfg` $\rightarrow$ `~/.ansible.cfg` $\rightarrow$ `/etc/ansible/ansible.cfg`):**
  ```ini
  [defaults]
  inventory = ./inventory/hosts.ini
  remote_user = ubuntu
  private_key_file = ~/.ssh/id_ed25519
  host_key_checking = False
  forks = 10
  retry_files_enabled = False
  interpreter_python = auto_silent

  [privilege_escalation]
  become = True
  become_method = sudo
  become_user = root

  [ssh_connection]
  pipelining = True
  ```
- **Cấu hình SSH Key Authentication và Kiểm tra kết nối:**
  ```bash
  # Tạo SSH Keypair Ed25519 và copy sang Managed Node
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
  ssh-copy-id -i ~/.ssh/id_ed25519.pub ubuntu@192.168.56.101

  # Kiểm tra kết nối bằng module ping của Ansible
  ansible all -m ping
  ```

### 6. Inventory và Ad-hoc Commands
- **Khái niệm Inventory, Static vs Dynamic Inventory:**
  - **Static Inventory:** Khai báo danh sách IP/Host cố định trong file văn bản `.ini` hoặc `.yml`.
  - **Dynamic Inventory:** Tự động truy vấn API của Cloud (AWS EC2, GCP, Proxmox) để lấy danh sách VM động tại thời điểm chạy lệnh.
- **Host, Group, Variables và Inventory đa môi trường:**
  - Tổ chức máy chủ theo nhóm (`[webservers]`, `[dbservers]`), nhóm lồng nhau (`[prod:children]`) và tách biến ra thư mục `group_vars/` (cho nhóm) và `host_vars/` (cho từng máy). Tách riêng thư mục `inventories/staging/` và `inventories/prod/` để quản lý đa môi trường an toàn.
  ```ini
  [webservers]
  web01 ansible_host=192.168.56.101 http_port=80
  web02 ansible_host=192.168.56.102 http_port=8080

  [dbservers]
  db01  ansible_host=192.168.56.201

  [app_cluster:children]
  webservers
  dbservers
  ```
- **Host Patterns:**
  - `all` (tất cả), `webservers:dbservers` (hợp OR), `webservers:&staging` (giao AND), `webservers:!web02` (loại trừ NOT).
- **Ad-hoc Commands và các Module cơ bản (`ping`, `command`, `shell`, `copy`, `file`, `package`, `service`, `user`):**
  ```bash
  # 1. Kiểm tra kết nối tới toàn bộ VM
  ansible all -i inventory/hosts.ini -m ping

  # 2. Xem uptime và dung lượng bộ nhớ (module command mặc định)
  ansible all -m command -a "uptime"

  # 3. Dùng pipe với module shell
  ansible webservers -m shell -a "ss -tulpn | grep :80" -b

  # 4. Tạo thư mục và phân quyền bằng module file
  ansible webservers -m file -a "path=/opt/cloud_note state=directory mode=0755 owner=ubuntu" -b

  # 5. Sao chép file từ Control Node sang Managed Nodes bằng module copy
  ansible webservers -m copy -a "src=./app.conf dest=/etc/app.conf mode=0644" -b

  # 6. Cài đặt gói phần mềm bằng module package / apt
  ansible webservers -m package -a "name=nginx state=present" -b

  # 7. Khởi động và kích hoạt dịch vụ bằng module service
  ansible webservers -m service -a "name=nginx state=started enabled=yes" -b

  # 8. Tạo user quản trị bằng module user
  ansible all -m user -a "name=deployer groups=sudo append=yes state=present" -b
  ```

### 7. Ansible Playbooks
- **Khái niệm Playbook, cấu trúc Plays, Tasks, Modules và Handlers:**
  - Playbook là file định dạng **YAML** chứa một hoặc nhiều **Plays**. Mỗi Play ánh xạ một nhóm hosts với danh sách **Tasks** gọi tới các **Modules**. **Handlers** là các task đặc biệt (như `reload`/`restart` service) chỉ chạy một lần ở cuối Play khi được kích hoạt qua từ khóa `notify`.
- **Variables và Thứ tự ưu tiên của Biến (Variable Precedence - Từ thấp đến cao):**
  `Role defaults` (`defaults/main.yml`) $\rightarrow$ `Inventory group_vars` $\rightarrow$ `Inventory host_vars` $\rightarrow$ `Host facts` $\rightarrow$ `Playbook vars` $\rightarrow$ `Role vars` (`vars/main.yml`) $\rightarrow$ **`Extra vars (`-e` trên CLI - Cao nhất)`**.
- **Tags, Check Mode và Diff Mode:**
  ```bash
  # Chạy thử chế độ Dry-run (--check) và hiển thị chi tiết dòng thay đổi (--diff)
  ansible-playbook deploy_nginx.yml --check --diff

  # Chỉ thực thi các task được gắn nhãn 'config'
  ansible-playbook deploy_nginx.yml --tags "config"
  ```
- **Thực hành: Playbook cài đặt và cấu hình Nginx trên Linux VM:**
  ```yaml
  ---
  - name: Cài đặt và cấu hình Nginx Web Server
    hosts: webservers
    become: true
    vars:
      http_port: 80
      web_root: /var/www/html

    tasks:
      - name: Cài đặt gói Nginx
        ansible.builtin.apt:
          name: nginx
          state: present
          update_cache: true
        tags: [install]

      - name: Triển khai trang giao diện chuẩn
        ansible.builtin.copy:
          dest: "{{ web_root }}/index.html"
          content: "<h1>Deployed by Ansible on {{ ansible_facts['hostname'] }}</h1>\n"
          mode: "0644"
        notify: Reload Nginx
        tags: [config]

      - name: Đảm bảo dịch vụ Nginx đang chạy và bật cùng hệ thống
        ansible.builtin.service:
          name: nginx
          state: started
          enabled: true
        tags: [service]

    handlers:
      - name: Reload Nginx
        ansible.builtin.service:
          name: nginx
          state: reloaded
  ```

### 8. Ansible Roles và tổ chức Project
- **Khái niệm Role và cấu trúc thư mục chuẩn (`ansible-galaxy role init <role_name>`):**
  - Giúp chia nhỏ Playbook lớn thành các module độc lập theo chức năng (Role `docker`, Role `nginx`, Role `app_deploy`) để dễ dàng tái sử dụng và bảo trì.
  ```text
  roles/nginx/
  ├── defaults/main.yml    # Biến mặc định (Độ ưu tiên thấp nhất - dễ dàng ghi đè)
  ├── vars/main.yml        # Biến cố định nội bộ của Role (Độ ưu tiên rất cao)
  ├── tasks/main.yml       # Danh sách các Tasks chính của Role
  ├── handlers/main.yml    # Các Handlers (restart/reload service)
  ├── templates/           # Chứa các file cấu hình động Jinja2 (.j2)
  ├── files/               # Chứa các file tĩnh dùng cho module copy
  └── meta/main.yml        # Metadata và khai báo các Role phụ thuộc (dependencies)
  ```
- **Phân biệt `defaults` và `vars`:**
  - `defaults/main.yml` có độ ưu tiên thấp nhất, dành cho các tham số khuyến khích người dùng tùy chỉnh (như port, domain).
  - `vars/main.yml` có độ ưu tiên rất cao, chỉ đứng sau `-e`, dùng cho các hằng số nội bộ không muốn bị vô tình ghi đè từ Inventory.
- **Ansible Collections và Ansible Galaxy:**
  - Kho lưu trữ cộng đồng `galaxy.ansible.com` cung cấp các Roles và Collections đóng gói sẵn (cài đặt qua `ansible-galaxy collection install community.docker` hoặc `ansible-galaxy install -r requirements.yml`).

---

## Phần 3: Tìm hiểu thêm - DevSecOps & Tích hợp Security vào Pipeline

### 9. Tổng quan về DevSecOps
- **Khái niệm DevSecOps và Shift Left Security:**
  - **DevSecOps:** Tích hợp bảo mật tự động xuyên suốt vào mọi giai đoạn của quy trình DevOps.
  - **Shift Left Security:** Đưa việc kiểm tra và phát hiện lỗ hổng bảo mật về phía đầu quy trình (ngay lúc lập trình viên viết code và mở Merge Request) thay vì đợi đến khi lên Production, giúp giảm chi phí khắc phục lỗ hổng xuống hàng chục lần.
- **Security as Code và Security Gate:**
  - **Security as Code:** Định nghĩa các quy tắc quét bảo mật bằng file cấu hình trong Git.
  - **Security Gate (Quality Gate):** Chốt chặn tự động trong Pipeline; nếu phát hiện lộ Secret hoặc có lỗ hổng mức `CRITICAL`, công cụ trả về `exit code != 0` để chặn đứng Pipeline ngay lập tức.
- **Các rủi ro bảo mật trong CI/CD, OWASP Top 10 & Software Supply Chain Security:**
  - Rủi ro: Lộ mật khẩu trong Git (*Hardcoded Secrets*), thư viện bên thứ 3 hoặc Docker Base Image chứa lỗ hổng CVE, tấn công thực thi mã độc trên Runner (*Poisoned Pipeline Execution*), Runner cấp quyền quá mức.
  - Đảm bảo an toàn chuỗi cung ứng phần mềm qua danh mục **SBOM** (*Software Bill of Materials*) và tuân thủ **OWASP Top 10**.

### 10. Tích hợp Security vào CI/CD Pipeline
- **Các tầng kiểm thử bảo mật trong Pipeline:**
  1. **Secret Scanning (`Gitleaks`):** Quét mã nguồn và lịch sử Git commit để chặn khóa bí mật, token, mật khẩu bị lộ.
  2. **SAST - Static Application Security Testing (`SonarQube`, `Bandit`, `Semgrep`):** Phân tích mã nguồn tĩnh (White-box) tìm lỗi SQL Injection, XSS, Hardcoded Password và Code Smell.
  3. **SCA & Container Image Scanning (`Trivy`):** Quét lỗ hổng CVE trong các thư viện (`requirements.txt`) và các layer của Docker Image vừa build.
  4. **DAST - Dynamic Application Security Testing (`OWASP ZAP`):** Kiểm thử hộp đen (Black-box) bằng cách giả lập tấn công vào ứng dụng đang chạy trên môi trường Staging.
- **Quản lý Vulnerability và False Positive:**
  - Phân loại ưu tiên xử lý dựa trên điểm **CVSS** (`CRITICAL` / `HIGH`), nâng cấp thư viện hoặc cập nhật Base Image (`alpine` / `slim`).
  - Với các cảnh báo giả (**False Positive**), quản lý minh bạch qua file `.trivyignore` hoặc `.gitleaksignore` có ghi chú lý do và thời hạn kiểm duyệt.

---

## Phần 4: Thực hành Lab End-to-End

> **Chi tiết mã nguồn và kịch bản thực hành:** Toàn bộ mã nguồn hệ thống CI/CD tự động hóa đóng gói ứng dụng **Cloud Note App (3-Tier: Frontend Nginx + Backend Flask + MySQL 8.0)**, quét bảo mật DevSecOps (**Gitleaks, Bandit, Trivy**) và triển khai tự động lên **Target Linux VM** bằng **Ansible Roles** được đặt tại thư mục **[`lab-cicd-ansible/`](lab-cicd-ansible/)** và hướng dẫn chi tiết tại **[`Simulation.md`](Simulation.md)**.

### Kiến trúc luồng thực thi Lab End-to-End:
```text
[Developer: git push]
        │
        ▼
[CI/CD Platform: GitLab CI / Jenkins]
        ├──> Stage 1 (Test & SAST)    : Quét Gitleaks + Bandit SAST + Automated API Unit Test
        ├──> Stage 2 (Build Images)   : Build Multi-stage Docker Images (Frontend & Backend)
        ├──> Stage 3 (Security Gate)  : Quét lỗ hổng Image bằng Trivy (--severity CRITICAL --exit-code 1) & Push lên Registry
        └──> Stage 4 (Ansible Deploy) : Ansible Control Node kết nối SSH tới Target Linux VM:
                                         ├─ Role 1 (docker_setup)     : Cài đặt Docker Engine & Compose V2
                                         └─ Role 2 (cloud_note_deploy): Render .env, compose.yaml, kéo Image & kiểm tra /health
```

