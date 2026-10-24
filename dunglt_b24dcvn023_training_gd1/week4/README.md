# Báo cáo Tuần 4: CI/CD, Ansible và DevSecOps

## 1. Bản chất CI/CD

### 1.1. Vấn đề CI/CD giải quyết

Hãy tưởng tượng một nhóm 5 developer, mỗi người làm một tuần rồi mới gộp code (merge) vào một nhánh chung. Khi merge, hàng trăm xung đột và lỗi xuất hiện cùng lúc, rất khó tìm nguyên nhân. Đây là lý do cần **tích hợp liên tục** (Continuous Integration): merge nhỏ và thường xuyên, mỗi lần merge đều được build và test tự động.

**Nguyên lý cốt lõi:** lỗi càng được phát hiện sớm thì càng rẻ để sửa. Một lỗi bị phát hiện trong vài phút sau khi commit chỉ mất vài phút để sửa; cùng lỗi đó phát hiện sau khi lên production có thể mất nhiều ngày.

### 1.2. Ba khái niệm cần phân biệt

| Thuật ngữ | Làm gì tự động | Con người cần làm gì | Lên production? |
|---|---|---|---|
| **Continuous Integration (CI)** | Build + test mỗi lần push/merge | Sửa lỗi khi pipeline đỏ | Không |
| **Continuous Delivery (CD)** | CI + chuẩn bị artifact sẵn sàng deploy bất kỳ lúc nào | Bấm nút duyệt để deploy | Có, nhưng cần duyệt |
| **Continuous Deployment (CD)** | Toàn bộ, kể cả deploy lên production | Không cần duyệt | Có, tự động |

Điểm khác nhau nằm ở **bước cuối cùng**: có người duyệt hay không. Các công ty lớn thường dùng Continuous Deployment cho web service, còn ngành tài chính hay y tế thường dùng Continuous Delivery vì cần kiểm soát thủ công.

### 1.3. Quy trình end-to-end

```text
Developer commit & push
        │
        ▼
   [Git Repository] ──trigger──▶ [CI/CD Platform]
                                      │
                    ┌─────────────────┼─────────────────┐
                    ▼                 ▼                 ▼
                 Build            Test            Security scan
                    │
                    ▼
            Artifact (Docker image)  ──▶  Registry (lưu phiên bản)
                                              │
                                              ▼
                                  Deploy Staging ──(duyệt)──▶ Deploy Production
```

### 1.4. Ví dụ tư duy: "Build once, deploy many"

Nguyên tắc quan trọng: **build artifact một lần, rồi dùng đúng artifact đó cho mọi môi trường**. Không build lại cho staging và production riêng, vì có thể khác nhau về phiên bản thư viện và gây ra lỗi "chạy được trên staging nhưng lỗi trên production".

```text
Commit abc123 ──build──▶ myapp:abc123 ──deploy──▶ Staging
                                      └──deploy──▶ Production   (cùng một image)
```

Vì vậy, trong pipeline, image thường được gắn tag theo commit (ví dụ `myapp:abc123`) để truy vết chính xác.

### 1.5. Lợi ích và hạn chế

**Lợi ích:** phát hiện lỗi sớm, giảm công việc thủ công, triển khai nhanh và lặp lại được, dễ rollback.

**Hạn chế:**
- Tốn công xây dựng pipeline ban đầu.
- Pipeline chỉ tốt khi test đủ tốt. Nếu không có test, CI chỉ "build cho vui".
- Nếu pipeline chậm (chạy 1 giờ), developer sẽ ngại push thường xuyên và mất lợi ích của CI.
- Secret và quyền truy cập nếu quản lý sai sẽ trở thành lỗ hổng bảo mật.

---

## 2. CI/CD Pipeline

### 2.1. Các thành phần

- **Trigger:** điều kiện khởi chạy pipeline.
  - `push`: chạy khi có commit mới lên nhánh.
  - `Pull Request / Merge Request`: chạy khi mở yêu cầu gộp code, giúp review code có kết quả test đi kèm.
  - `Manual`: người dùng bấm nút chạy, thường dùng cho bước deploy production.
  - `Schedule`: chạy theo lịch, ví dụ quét bảo mật hằng đêm.
- **Stage:** một giai đoạn lớn, các stage chạy tuần tự. Nếu một stage fail, các stage sau không chạy.
- **Job:** công việc cụ thể trong một stage. Các job trong cùng một stage chạy song song.

```text
Stage build:   [build_app]
Stage test:    [unit_test] [lint]        ← hai job chạy song song
Stage deploy:  [deploy_staging] → [deploy_production (manual)]
```

### 2.2. Ví dụ pipeline tối giản (GitLab CI)

File `.gitlab-ci.yml` nằm ở thư mục gốc của repository:

```yaml
stages:
  - build
  - test
  - deploy

build_app:
  stage: build
  script:
    - echo "Build ứng dụng"
    - docker build -t myapp:$CI_COMMIT_SHORT_SHA .

unit_test:
  stage: test
  script:
    - echo "Chạy unit test"
    - pytest

deploy_staging:
  stage: deploy
  script:
    - echo "Deploy lên staging"
  environment: staging
  rules:
    - if: $CI_COMMIT_BRANCH == "main"

deploy_production:
  stage: deploy
  script:
    - echo "Deploy lên production"
  environment: production
  when: manual
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
```

**Giải thích các từ khóa:**
- `script`: danh sách lệnh chạy trong job.
- `rules`: điều kiện để job có chạy hay không.
- `when: manual`: job chỉ chạy khi người dùng bấm nút.
- `$CI_COMMIT_SHORT_SHA`: biến tự động do GitLab cung cấp, chứa mã commit rút gọn.

**Bài test nhỏ:** nếu `unit_test` fail, `deploy_staging` có chạy không? Đáp án: không, vì stage `test` fail thì stage `deploy` không được bắt đầu.

### 2.3. Source Code Management và Git

Git là nguồn sự thật (source of truth). Pipeline chỉ chạy trên code đã được commit, không chạy trên máy cá nhân. Điều này đảm bảo kết quả có thể tái lập: cùng commit thì cùng kết quả build.

Quy ước nhánh thường gặp:
- `main`: code ổn định, có thể deploy.
- `feature/*`: nhánh làm tính năng mới, merge vào `main` qua Merge Request.

### 2.4. Artifact và Artifact Management

**Artifact** là sản phẩm đầu ra của build, ví dụ file JAR, file ZIP, Docker image, package npm.

- **Artifact Repository:** nơi lưu artifact (ví dụ Nexus, JFrog Artifactory, GitLab Package Registry).
- **Container Registry:** kho lưu Docker image (ví dụ Docker Hub, GitLab Container Registry, AWS ECR).

Mục tiêu: lưu được lịch sử phiên bản, tải lại được bất kỳ phiên bản nào khi cần rollback.

### 2.5. Environment Variables và tách cấu hình theo môi trường

Ứng dụng giống nhau nhưng cấu hình khác nhau giữa các môi trường. Ví dụ địa chỉ database:

```text
Staging:     DB_HOST=db.staging.local
Production:  DB_HOST=db.prod.local
```

**Sai lầm thường gặp:** hard-code địa chỉ database trong source code. Cách đúng là đưa cấu hình ra ngoài dưới dạng biến môi trường.

```bash

docker run -e DB_HOST=db.staging.local myapp:abc123
docker run -e DB_HOST=db.prod.local    myapp:abc123
```

Chạy thử: `docker run -e DB_HOST=test myapp` rồi trong code in ra `os.environ["DB_HOST"]` sẽ thấy giá trị `test`.

### 2.6. Ba môi trường Development, Staging, Production

| Môi trường | Mục đích | Dữ liệu | Ai dùng |
|---|---|---|---|
| Development | Lập trình, thử nghiệm nhanh | Dữ liệu giả | Developer |
| Staging | Giống production nhất có thể, để kiểm thử trước khi release | Dữ liệu giả hoặc bản sao ẩn danh | QA, tester |
| Production | Phục vụ người dùng thật | Dữ liệu thật | Người dùng cuối |

### 2.7. Deployment Strategies

Giả sử có 4 server, phiên bản cũ là v1, phiên bản mới là v2.

**Rolling update:** cập nhật lần lượt từng server.

```text
Bước 1: [v1] [v1] [v1] [v1]
Bước 2: [v2] [v1] [v1] [v1]    ← nâng 1 server, kiểm tra
Bước 3: [v2] [v2] [v1] [v1]
Bước 4: [v2] [v2] [v2] [v2]
```
Ưu điểm: không tốn thêm tài nguyên. Nhược điểm: trong lúc chuyển, hai phiên bản chạy song song, cần tương thích ngược.

**Blue-Green:** có hai môi trường y hệt nhau. Blue đang chạy v1, Green được deploy v2, kiểm tra xong thì chuyển traffic từ Blue sang Green.

```text
Load Balancer ──▶ Blue (v1)     trước khi chuyển
Load Balancer ──▶ Green (v2)    sau khi chuyển; Blue vẫn giữ để rollback nhanh
```
Ưu điểm: rollback tức thì bằng cách đổi lại traffic. Nhược điểm: tốn gấp đôi tài nguyên.

**Canary:** đưa v2 cho một phần nhỏ người dùng trước, ví dụ 5%, theo dõi lỗi, rồi tăng dần.

```text
Traffic: 95% ──▶ v1 (4 server)
          5% ──▶ v2 (1 server)     ← theo dõi lỗi, tỷ lệ 500, độ trễ
Nếu ổn: tăng dần 25% → 50% → 100%
Nếu lỗi: đưa 100% về v1
```

**Bài test nhỏ:** muốn rollback trong vài giây và không muốn tốn thêm tài nguyên lâu dài, nên chọn chiến lược nào? Gợi ý: Blue-Green thì rollback nhanh nhưng tốn tài nguyên, Rolling tiết kiệm nhưng rollback chậm hơn. Cần cân nhắc theo ngân sách và yêu cầu thời gian phục hồi.

### 2.8. Rollback và Release Management

- **Rollback:** quay về phiên bản ổn định trước đó. Dễ làm nếu artifact được lưu theo tag (`myapp:abc123`) và cấu hình deploy là khai báo.
- **Release Management:** quản lý phiên bản phát hành, thường dùng Semantic Versioning `MAJOR.MINOR.PATCH`:
  - `MAJOR`: thay đổi không tương thích ngược (`2.0.0`).
  - `MINOR`: thêm tính năng mới tương thích ngược (`1.3.0`).
  - `PATCH`: sửa lỗi (`1.3.1`).

---

## 3. Nền tảng CI/CD

### 3.1. Kiến trúc chung

```text
┌──────────────┐   trigger    ┌──────────────────┐   giao job   ┌─────────────┐
│ Git Repo     │ ───────────▶ │ CI/CD Server     │ ───────────▶ │ Runner/Agent│
│ .gitlab-ci   │              │ (quản lý pipeline│              │ (thực thi)  │
│ Jenkinsfile  │              │  và lịch sử)     │ ◀─── log ─── │ Docker, SSH │
└──────────────┘              └──────────────────┘              └─────────────┘
```

- **Server (control plane):** nhận trigger, quyết định job nào chạy, lưu log và lịch sử.
- **Runner / Agent (execution):** máy thực sự chạy các lệnh trong job.

### 3.2. Hosted Runner và Self-hosted Runner

| Loại | Ai quản lý | Ưu điểm | Nhược điểm |
|---|---|---|---|
| Hosted Runner | Nhà cung cấp (GitLab, GitHub) | Không cần cài đặt, sạch sẽ mỗi lần chạy | Tốn phí khi vượt hạn mức, không truy cập được mạng nội bộ mặc định |
| Self-hosted Runner | Bạn | Truy cập được mạng nội bộ, toàn quyền cấu hình | Phải tự cập nhật, bảo mật máy |

**Ví dụ thực tế:** nếu cần deploy vào VM nằm trong mạng nội bộ (ví dụ `192.168.56.10`), Hosted Runner ở ngoài internet không tới được. Lúc này phải dùng Self-hosted Runner đặt trong cùng mạng.

### 3.3. Quản lý Credentials, Variables và Secrets

- **Variables:** cấu hình không nhạy cảm, ví dụ `APP_ENV=staging`.
- **Secrets / Credentials:** thông tin nhạy cảm, ví dụ mật khẩu, token, SSH private key.

**Nguyên tắc:** không bao giờ commit secret vào Git. Lưu secret trong kho bảo mật của nền tảng CI (GitLab CI/CD Variables có tùy chọn `Masked` và `Protected`, Jenkins có Credentials Store, GitHub có Secrets).

```yaml
deploy:
  script:
    - echo "$SSH_PRIVATE_KEY" > key.pem   
    - chmod 600 key.pem
```

### 3.4. So sánh GitLab CI/CD và Jenkins

| Tiêu chí | GitLab CI/CD | Jenkins |
|---|---|---|
| Cấu hình | File `.gitlab-ci.yml` có sẵn trong repo | `Jenkinsfile` (Groovy) hoặc giao diện web |
| Cài đặt | Tích hợp sẵn nếu dùng GitLab | Phải tự cài server và plugin |
| Mở rộng | Đủ dùng cho đa số trường hợp | Có hàng nghìn plugin, rất linh hoạt |
| Bảo trì | Ít hơn | Nhiều hơn (cập nhật plugin, bảo mật server) |
| Phù hợp | Đội nhỏ đến vừa, muốn đơn giản | Hệ thống phức tạp, yêu cầu tùy biến cao |

---

## 4. Ansible: bản chất và cơ chế hoạt động

### 4.1. Configuration Management là gì?

Giả sử bạn có 20 server Ubuntu. Bạn cần cài nginx, đặt cùng một file cấu hình, tạo cùng một user, mở đúng các port. Làm bằng tay thì dễ sai và không đồng nhất. **Configuration Management** là cách mô tả trạng thái mong muốn của hệ thống bằng code, rồi để công cụ tự đưa các máy về trạng thái đó.

### 4.2. Ansible là gì?

Ansible là công cụ mã nguồn mở, viết bằng Python, dùng để cấu hình máy, triển khai ứng dụng và tự động hóa vận hành. Đặc điểm nổi bật:

- **Agentless:** không cần cài phần mềm trên máy được quản lý. Chỉ cần SSH và Python (có sẵn trên hầu hết Linux).
- **Khai báo (declarative):** bạn mô tả trạng thái mong muốn ("nginx phải được cài và đang chạy"), không phải các bước cụ thể.
- **Idempotent:** chạy nhiều lần vẫn cho cùng kết quả. Nếu nginx đã được cài, Ansible sẽ báo `ok` chứ không cài lại.

### 4.3. Control Node và Managed Node

```text
┌──────────────────────┐        SSH (port 22)        ┌──────────────────┐
│ Control Node         │ ──────────────────────────▶ │ Managed Node 1   │
│ (máy chạy ansible)   │ ──────────────────────────▶ │ Managed Node 2   │
│ ansible, playbook,   │ ──────────────────────────▶ │ Managed Node 3   │
│ inventory            │                             │ (không cần agent)│
└──────────────────────┘                             └──────────────────┘
```

Khi chạy một task, Ansible thường làm theo các bước:
1. Kết nối SSH đến Managed Node.
2. Copy một module nhỏ (viết bằng Python) lên máy đó và thực thi.
3. Module kiểm tra trạng thái hiện tại, so với trạng thái mong muốn.
4. Nếu khác thì thay đổi, nếu giống thì bỏ qua. Kết quả trả về: `ok`, `changed` hoặc `failed`.
5. Xóa module tạm.

### 4.4. So sánh với Shell Script

Đoạn shell script sau có vấn đề gì?

```bash
apt install nginx
echo "server {...}" > /etc/nginx/sites-available/default
systemctl restart nginx
```

- Chạy lần 2: `apt install` vẫn chạy, `restart` không cần thiết, `echo >` ghi đè file mỗi lần.
- Không biết trạng thái hiện tại, chỉ biết "đã làm các lệnh này".
- Khó chạy song song trên 20 máy và tổng hợp kết quả.

Cùng yêu cầu bằng Ansible:

```yaml
- name: Đảm bảo nginx được cài
  package:
    name: nginx
    state: present
```
Chạy lần đầu: `changed`. Chạy lần hai: `ok`, không làm gì thêm.

### 4.5. Cài đặt và kiểm tra

Trên máy Control Node (Ubuntu):

```bash
sudo apt update
sudo apt install -y ansible
ansible --version
```

Hoặc dùng `pip install ansible` nếu cần phiên bản mới hơn.

**Phân biệt Ansible Core và Ansible Community Package:** Ansible Core là phần lõi (engine, ansible-playbook, ansible-galaxy) với ít module tích hợp. Ansible Community Package (`ansible`) bao gồm Core cùng bộ collection phổ biến.

### 4.6. Cấu hình SSH Key Authentication

Ansible dùng SSH, nên cần đăng nhập không mật khẩu để tự động hóa:

```bash
# Trên Control Node: tạo cặp khóa
ssh-keygen -t ed25519 -f ~/.ssh/ansible_key

# Đưa public key sang Managed Node
ssh-copy-id -i ~/.ssh/ansible_key.pub ubuntu@192.168.56.10

# Kiểm tra
ssh -i ~/.ssh/ansible_key ubuntu@192.168.56.10
```

### 4.7. File ansible.cfg

File này đặt các thiết lập mặc định để không phải gõ lại mỗi lần:

```ini
[defaults]
inventory = ./inventory.ini
remote_user = ubuntu
private_key_file = ~/.ssh/ansible_key
host_key_checking = False

[privilege_escalation]
become = True
become_method = sudo
become_ask_pass = False
```

Ansible tìm `ansible.cfg` theo thứ tự: biến `ANSIBLE_CONFIG`, file trong thư mục hiện tại, `~/.ansible.cfg`, `/etc/ansible/ansible.cfg`. Với lab nên đặt file trong thư mục project.

---

## 5. Inventory và Ad-hoc Commands

### 5.1. Inventory là gì?

Inventory là danh sách các máy mà Ansible quản lý, kèm cách nhóm chúng.

**Static Inventory (INI):**

```ini
[web]
web1 ansible_host=192.168.56.10
web2 ansible_host=192.168.56.11

[db]
db1 ansible_host=192.168.56.20

[web:vars]
http_port=80

[all:children]
web
db
```

- `web1`, `web2`, `db1`: tên logic của host.
- `ansible_host`: địa chỉ IP thật để kết nối.
- `[web:vars]`: biến áp dụng cho cả nhóm `web`.

**Static Inventory (YAML):** cùng nội dung nhưng viết dạng cây:

```yaml
all:
  children:
    web:
      hosts:
        web1:
          ansible_host: 192.168.56.10
        web2:
          ansible_host: 192.168.56.11
      vars:
        http_port: 80
    db:
      hosts:
        db1:
          ansible_host: 192.168.56.20
```

**Dynamic Inventory:** thay vì khai báo IP cố định, Ansible hỏi một nguồn bên ngoài như AWS EC2 để lấy danh sách máy đang chạy. Rất hữu ích khi máy được tạo và hủy liên tục, ví dụ trên cloud.

### 5.2. Host Variables, Group Variables, Inventory Variables

Biến có thể gắn vào từng host hoặc nhóm. Ví dụ tổ chức theo môi trường:

```text
inventory/
├── staging/
│   ├── hosts.ini
│   └── group_vars/
│       └── web.yml        # http_port: 8080, app_env: staging
└── production/
    ├── hosts.ini
    └── group_vars/
        └── web.yml        # http_port: 80,   app_env: production
```

Chạy với môi trường cụ thể: `ansible-playbook -i inventory/staging/hosts.ini deploy.yml`. Cùng một playbook, khác inventory thì ra cấu hình khác nhau. Đây là cách tái sử dụng code cho nhiều môi trường.

### 5.3. Host Patterns

Host pattern là cách chọn máy để chạy lệnh:

| Pattern | Ý nghĩa |
|---|---|
| `all` | Tất cả máy |
| `web` | Tất cả máy trong nhóm web |
| `web1` | Một máy cụ thể |
| `web1,db1` | Hai máy |
| `web:!web2` | Nhóm web trừ web2 |
| `web[0]` | Máy đầu tiên của nhóm web |

Kiểm tra danh sách máy sẽ được chọn trước khi chạy:

```bash
ansible web -i inventory.ini --list-hosts
```

### 5.4. Ad-hoc Commands

Ad-hoc là lệnh chạy một lần, không lưu lại thành file, dùng để kiểm tra nhanh hoặc xử lý khẩn.

Cú pháp chung:

```text
ansible <host-pattern> -i <inventory> -m <module> -a "<tham số>" [-b]
```

- `-m`: tên module.
- `-a`: tham số của module.
- `-b`: become, tức chạy với quyền sudo.

**Các module cơ bản và ví dụ:**

```bash
# ping: kiểm tra kết nối (không phải ping mạng, mà kiểm tra SSH và Python)
ansible all -i inventory.ini -m ping

# command: chạy lệnh đơn giản, không hiểu pipe, biến shell
ansible web -i inventory.ini -m command -a "uptime"

# shell: chạy lệnh qua shell, hỗ trợ pipe và biến
ansible web -i inventory.ini -m shell -a "df -h | grep /dev/sda"

# copy: đưa file từ máy điều khiển lên máy đích
ansible web -i inventory.ini -m copy -a "src=index.html dest=/var/www/html/index.html"

# file: tạo thư mục, đổi quyền, xóa file
ansible web -i inventory.ini -b -m file -a "path=/var/www/html/static state=directory mode=0755"

# package: cài hoặc gỡ gói phần mềm
ansible web -i inventory.ini -b -m package -a "name=nginx state=present"

# service: bật, tắt, khởi động lại dịch vụ
ansible web -i inventory.ini -b -m service -a "name=nginx state=restarted"

# user: tạo hoặc xóa user
ansible web -i inventory.ini -b -m user -a "name=deploy shell=/bin/bash state=present"
```

**Khác biệt command và shell:** `command` không chạy qua shell nên `|`, `>`, `$HOME` không hoạt động. Ưu tiên dùng `command` khi không cần shell, vì an toàn và dễ đoán hơn.

**Bài test nhỏ:** chạy `ansible web -m command -a "echo $HOME"` có ra đường dẫn home không? Đáp án: không, vì `command` không qua shell nên `$HOME` không được mở rộng. Đổi thành `-m shell` thì sẽ ra.

### 5.5. Thực hành: nhiều Linux VM

Chuẩn bị 3 VM Ubuntu trên VMware (ví dụ `192.168.56.10`, `.11`, `.12`), mỗi máy đã có SSH key. Sau đó:

```bash
ansible all -i inventory.ini -m ping
# Kết quả mong đợi: mỗi máy trả về "pong"
```

Nếu một máy báo `UNREACHABLE`, kiểm tra theo thứ tự: máy có bật không, IP có đúng không (`ip a`), SSH có chạy không (`systemctl status ssh`), key đã copy chưa.

---

## 6. Ansible Playbooks

### 6.1. Playbook là gì?

Playbook là file YAML mô tả chuỗi cấu hình sẽ áp dụng lên các máy. Nó là bản "công thức" có thể lưu vào Git, review và chạy lại bất cứ lúc nào.

### 6.2. Cấu trúc

```text
Playbook (file .yml)
└── Play 1: hosts, biến, quyền
    ├── Task 1: dùng module package
    ├── Task 2: dùng module template
    └── Task 3: dùng module service
        └── notify: handler nào
└── Play 2 ...
```

- **Play:** một khối gắn với nhóm host và cấu hình chung.
- **Task:** một hành động, dùng một module.
- **Handler:** task đặc biệt chỉ chạy một lần cuối play, và chỉ khi có task khác `notify` nó.

### 6.3. Ví dụ playbook cài và cấu hình Nginx đầy đủ

Playbook này cài nginx, đặt file cấu hình từ template, và chỉ restart khi cấu hình thực sự thay đổi.

```yaml
# nginx.yml
- name: Cài đặt và cấu hình Nginx
  hosts: web
  become: true
  vars:
    http_port: 80
    site_name: "Hello from {{ inventory_hostname }}"

  tasks:
    - name: Cài nginx
      package:
        name: nginx
        state: present

    - name: Tạo file cấu hình từ template
      template:
        src: templates/default.conf.j2
        dest: /etc/nginx/sites-available/default
      notify: Restart nginx

    - name: Tạo trang index
      copy:
        content: "{{ site_name }}\n"
        dest: /var/www/html/index.html

    - name: Bật nginx khi khởi động
      service:
        name: nginx
        state: started
        enabled: true

  handlers:
    - name: Restart nginx
      service:
        name: nginx
        state: restarted
```

File template `templates/default.conf.j2`:

```nginx
server {
    listen {{ http_port }} default_server;
    root /var/www/html;
    index index.html;
    server_name _;
}
```

**Giải thích:**
- `{{ inventory_hostname }}`: biến Jinja2, Ansible thay bằng tên host của từng máy.
- `template`: render file `.j2` thành file thật, thay biến bằng giá trị thực.
- `notify` và `handlers`: nếu file config không đổi (`ok`), handler không chạy, nginx không bị restart không cần thiết.

**Chạy:**

```bash
# Lần 1: thấy changed
ansible-playbook -i inventory.ini nginx.yml

# Lần 2: toàn bộ là ok, không restart
ansible-playbook -i inventory.ini nginx.yml
```

**Bài test nhỏ:** đổi `http_port` thành `8080` rồi chạy lại. Task nào báo `changed`? Đáp án: task tạo file cấu hình và handler restart nginx. Các task khác vẫn `ok`.

### 6.4. Variables và Variable Precedence

Biến có thể khai báo ở nhiều nơi. Khi trùng tên, nơi có độ ưu tiên cao hơn sẽ thắng. Một số mức thường gặp, từ thấp đến cao:

```text
role defaults  <  inventory group_vars  <  inventory host_vars  <  playbook vars  <  role vars  <  extra vars (-e)
```

Ví dụ:

```bash
# Ghi đè http_port mà không sửa file nào
ansible-playbook -i inventory.ini nginx.yml -e "http_port=8080"
```

Biến `-e` (extra vars) luôn thắng.

### 6.5. Tags và Task Selection

Tag gắn nhãn cho task để chạy có chọn lọc:

```yaml
    - name: Cài nginx
      package:
        name: nginx
        state: present
      tags: [install]

    - name: Đặt cấu hình
      template:
        src: templates/default.conf.j2
        dest: /etc/nginx/sites-available/default
      tags: [config]
```

```bash
ansible-playbook -i inventory.ini nginx.yml --tags config     # chỉ chạy task config
ansible-playbook -i inventory.ini nginx.yml --skip-tags config
ansible-playbook -i inventory.ini nginx.yml --list-tasks      # liệt kê task
```

### 6.6. Check Mode và Diff Mode

- **Check mode (`--check`):** chạy thử, không thay đổi gì, chỉ cho biết task nào sẽ `changed`.
- **Diff mode (`--diff`):** hiển thị khác biệt nội dung file.

```bash
ansible-playbook -i inventory.ini nginx.yml --check --diff
```

Dùng hai cờ này trước khi chạy lên production là thói quen tốt. Lưu ý: một số module không hỗ trợ check mode đầy đủ, nên kết quả chỉ là ước lượng.

### 6.7. Thực hành lab: Nginx trên Linux VM

1. Tạo inventory có ít nhất 2 VM.
2. Viết `nginx.yml` như trên, tạo thư mục `templates/`.
3. Chạy `--check --diff`, sau đó chạy thật.
4. Truy cập `http://192.168.56.10` từ trình duyệt của máy host, kiểm tra thấy chữ "Hello from web1".
5. Chạy lại playbook, xác nhận các task báo `ok`.

---

## 7. Ansible Roles và tổ chức project

### 7.1. Vì sao cần Role?

Khi playbook lớn dần, một file `.yml` dài hàng trăm dòng rất khó đọc và khó tái sử dụng. **Role** chia playbook thành các phần theo chức năng: nginx, mysql, docker... Mỗi role có cấu trúc thư mục chuẩn, có thể dùng lại ở nhiều project.

### 7.2. Cấu trúc thư mục của Role

```text
roles/
└── nginx/
    ├── tasks/main.yml        # Điểm vào: các task chính
    ├── handlers/main.yml     # Handler, ví dụ restart nginx
    ├── templates/            # File Jinja2 (.j2)
    ├── files/                # File tĩnh, copy nguyên bản
    ├── defaults/main.yml     # Biến mặc định, ưu tiên thấp nhất
    ├── vars/main.yml         # Biến cố định, ưu tiên cao
    └── meta/main.yml         # Thông tin role và phụ thuộc
```

Ansible tự động tìm `main.yml` trong mỗi thư mục, không cần import thủ công.

### 7.3. Phân biệt defaults và vars

| | `defaults/` | `vars/` |
|---|---|---|
| Độ ưu tiên | Thấp nhất | Cao |
| Mục đích | Giá trị gợi ý, người dùng có thể ghi đè dễ dàng | Giá trị cố định, nội bộ role |
| Ví dụ | `http_port: 80` | `nginx_user: www-data` |

**Quy tắc thực tế:** đặt mọi biến người dùng có thể cần đổi vào `defaults/`. Chỉ đặt vào `vars/` những gì không nên đổi.

### 7.4. Viết role Nginx hoàn chỉnh

`roles/nginx/defaults/main.yml`:

```yaml
http_port: 80
site_name: "Hello from {{ inventory_hostname }}"
```

`roles/nginx/tasks/main.yml`:

```yaml
- name: Cài nginx
  package:
    name: nginx
    state: present

- name: Tạo file cấu hình
  template:
    src: default.conf.j2
    dest: /etc/nginx/sites-available/default
  notify: Restart nginx

- name: Tạo trang index
  copy:
    content: "{{ site_name }}\n"
    dest: /var/www/html/index.html

- name: Bật nginx
  service:
    name: nginx
    state: started
    enabled: true
```

`roles/nginx/handlers/main.yml`:

```yaml
- name: Restart nginx
  service:
    name: nginx
    state: restarted
```

`roles/nginx/templates/default.conf.j2`: giống ví dụ ở mục 6.3.

**Sử dụng role trong playbook:**

```yaml
# site.yml
- name: Triển khai web
  hosts: web
  become: true
  roles:
    - role: nginx
      vars:
        http_port: 8080      # ghi đè giá trị mặc định của role
```

### 7.5. Ansible Collections và Ansible Galaxy

- **Ansible Galaxy:** kho chia sẻ role và collection công cộng.
- **Collection:** gói đóng gói module, plugin và role theo namespace, ví dụ `community.docker`, `amazon.aws`.

```bash
ansible-galaxy collection install community.docker
ansible-galaxy role install geerlingguy.docker
```

Dùng `requirements.yml` để khai báo phụ thuộc, giúp máy khác cài đúng các thành phần:

```yaml
collections:
  - name: community.docker
roles:
  - name: geerlingguy.docker
```

```bash
ansible-galaxy install -r requirements.yml
```

### 7.6. Cấu trúc repository đề xuất

```text
ansible-project/
├── ansible.cfg
├── inventory/
│   ├── staging/
│   │   ├── hosts.ini
│   │   └── group_vars/web.yml
│   └── production/
│       ├── hosts.ini
│       └── group_vars/web.yml
├── roles/
│   └── nginx/
├── site.yml
└── requirements.yml
```

**Lợi ích:** cùng một role và playbook, đổi inventory là đổi môi trường. Mọi thứ nằm trong Git, có lịch sử và review được.

### 7.7. Quản lý biến cho nhiều môi trường

Thay vì sửa code khi lên production, ta đặt giá trị khác nhau trong `group_vars`:

```yaml
# inventory/staging/group_vars/web.yml
http_port: 8080
site_name: "Staging - {{ inventory_hostname }}"

# inventory/production/group_vars/web.yml
http_port: 80
site_name: "Production - {{ inventory_hostname }}"
```

Chạy: `ansible-playbook -i inventory/staging/hosts.ini site.yml`.

---

## 8. DevSecOps

### 8.1. Bản chất

Truyền thống, bảo mật được kiểm tra ở cuối, gần lúc release. Khi phát hiện lỗ hổng lúc đó, sửa rất tốn kém và dễ trễ lịch.

**DevSecOps** đưa bảo mật vào mọi giai đoạn, từ lúc viết code đến lúc vận hành. Ý tưởng then chốt là **Shift Left**: dịch chuyển kiểm tra bảo mật về phía bên trái của quy trình (sớm hơn).

```text
Truyền thống:  Code ──▶ Build ──▶ Test ──▶ Deploy ──▶ [Security check] ✗ tốn kém
DevSecOps:     [Security] ─ Code ─ [Security] ─ Build ─ [Security] ─ Test ─ [Security] ─ Deploy
```

### 8.2. Các loại kiểm tra bảo mật

| Loại | Viết tắt | Kiểm tra cái gì | Thời điểm | Ví dụ công cụ |
|---|---|---|---|---|
| Static Application Security Testing | SAST | Mã nguồn tĩnh, tìm lỗi như SQL injection | Trước khi chạy | SonarQube, Semgrep |
| Dynamic Application Security Testing | DAST | Ứng dụng đang chạy, gửi request thử nghiệm | Sau khi deploy lên môi trường test | OWASP ZAP |
| Software Composition Analysis | SCA | Thư viện bên thứ ba có lỗ hổng đã biết | Khi build | Trivy, Dependency-Check |
| Container Image Scanning | — | Lỗ hổng trong OS và package của image | Sau khi build image | Trivy |
| Secret Scanning | — | Mật khẩu, token bị commit nhầm | Khi commit/push | Gitleaks |

### 8.3. Security as Code và Security Gate

- **Security as Code:** quy tắc bảo mật được viết thành file cấu hình và chạy tự động, giống như code.
- **Security Gate:** điều kiện chặn pipeline. Ví dụ: có lỗ hổng mức `CRITICAL` thì pipeline fail, không được deploy.

**Ví dụ security gate:**

```bash
# Trivy: chỉ fail khi có lỗ hổng HIGH hoặc CRITICAL
trivy image --severity HIGH,CRITICAL --exit-code 1 myapp:abc123
echo $?    # 0 = pass, 1 = fail
```

Cờ `--exit-code 1` khiến lệnh trả về mã lỗi, và CI sẽ coi job là fail.

**Bài test nhỏ:** nếu muốn cảnh báo nhưng không chặn pipeline thì sửa lệnh thế nào? Đáp án: bỏ `--exit-code 1` hoặc đặt `--exit-code 0`.

### 8.4. Các rủi ro trong CI/CD

- **Lộ secret:** commit nhầm mật khẩu vào Git. Gitleaks giúp phát hiện.
- **Image có lỗ hổng:** dùng base image cũ có CVE. Trivy giúp phát hiện.
- **Software Supply Chain:** thư viện phụ thuộc bị đầu độc hoặc giả mạo.
- **Quyền quá rộng:** runner hoặc tài khoản CI có quyền admin không cần thiết. Nguyên tắc **least privilege** (đặc quyền tối thiểu) khắc phục điều này.
- **Pipeline bị chiếm quyền:** kẻ tấn công sửa file pipeline để đánh cắp secret.

### 8.5. OWASP Top 10

OWASP Top 10 là danh sách 10 nhóm rủi ro bảo mật web phổ biến nhất, cập nhật định kỳ. Ví dụ các mục thường gặp: Injection (SQL injection), Broken Access Control, Security Misconfiguration, Vulnerable and Outdated Components. Đây là tài liệu tham khảo để viết test bảo mật và cấu hình kiểm tra SAST/DAST.

### 8.6. Tích hợp công cụ bảo mật vào pipeline

**Gitleaks** phát hiện secret:

```bash
gitleaks detect --source . --verbose
```

**Trivy** quét image:

```bash
trivy image --severity HIGH,CRITICAL --exit-code 1 myapp:abc123
```

**SonarQube** phân tích code: chạy qua `sonar-scanner`, kết quả hiển thị trên web dashboard, có thể đặt Quality Gate để chặn pipeline.

### 8.7. Quản lý kết quả quét: False Positive

- **True Positive:** cảnh báo đúng, lỗi thật, cần sửa.
- **False Positive:** cảnh báo sai, ví dụ công cụ báo một chuỗi là secret nhưng thực ra là dữ liệu mẫu.

Cách xử lý: xác minh từng cảnh báo, với false positive thì ghi chú lại và bỏ qua có kiểm soát (ví dụ file `.gitleaksignore`, `.trivyignore`), kèm lý do. Tuyệt đối không tắt công cụ chỉ vì nhiều cảnh báo.

---

## 9. Thực hành Lab: pipeline hoàn chỉnh

### 9.1. Yêu cầu

Xây dựng hệ thống CI/CD tự động: đóng gói ứng dụng, đánh giá bảo mật (khuyến khích) và triển khai lên VM bằng Ansible. Chọn GitLab CI/CD hoặc Jenkins.

### 9.2. Các thành phần

| Thành phần | Vai trò | Gợi ý triển khai |
|---|---|---|
| Git Repository | Mã nguồn app, Dockerfile, pipeline, playbook | GitHub hoặc GitLab |
| Docker | Đóng gói ứng dụng thành image | Docker Desktop trên máy host |
| CI/CD Platform | Điều phối pipeline | GitLab CI/CD (hoặc Jenkins) |
| Runner | Thực thi job | Self-hosted Runner trong VMware, cùng mạng với target VM |
| Container Registry | Lưu image theo phiên bản | GitLab Container Registry hoặc Docker Hub |
| Ansible Control Node | Chạy playbook deploy | Một VM Ubuntu |
| Target VM | Chạy ứng dụng | 1 hoặc 2 VM Ubuntu |
| Secrets | Lưu SSH key, token registry | CI/CD Variables (Masked, Protected) |

### 9.3. Luồng hoạt động

```text
git push main
   │
   ▼
[build]   docker build -t registry/myapp:<commit>
   │
   ▼
[test]    unit test
   │
   ▼
[scan]    gitleaks + trivy (security gate)
   │
   ▼
[push]    docker push registry/myapp:<commit>
   │
   ▼
[deploy]  ansible-playbook: VM tự pull image và chạy container
          (bước deploy có thể bấm tay: when: manual)
```

### 9.4. Ví dụ `.gitlab-ci.yml` hoàn chỉnh

```yaml
stages:
  - build
  - test
  - scan
  - deploy

variables:
  IMAGE: $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA

# Build và push trong cùng job, vì image trong Docker-in-Docker không chia sẻ được sang job khác
build_and_push:
  stage: build
  image: docker:24
  services:
    - docker:24-dind
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $IMAGE .
    - docker push $IMAGE

unit_test:
  stage: test
  image: python:3.12-slim
  script:
    - pip install -r requirements.txt
    - pytest

secret_scan:
  stage: scan
  image:
    name: zricethezav/gitleaks:latest
    entrypoint: [""]
  script:
    - gitleaks detect --source . --verbose

# Trivy kéo image từ registry để quét; lỗi HIGH/CRITICAL sẽ chặn pipeline ở security gate
image_scan:
  stage: scan
  image:
    name: aquasec/trivy:latest
    entrypoint: [""]
  variables:
    TRIVY_USERNAME: $CI_REGISTRY_USER
    TRIVY_PASSWORD: $CI_REGISTRY_PASSWORD
  script:
    - trivy image --severity HIGH,CRITICAL --exit-code 1 $IMAGE

deploy_staging:
  stage: deploy
  image: alpine:latest
  before_script:
    - apk add --no-cache ansible openssh-client
    - echo "$SSH_PRIVATE_KEY" > key.pem && chmod 600 key.pem
  script:
    - ansible-playbook -i inventory/staging/hosts.ini site.yml --private-key key.pem -e "app_image=$IMAGE"
  environment: staging
  rules:
    - if: $CI_COMMIT_BRANCH == "main"

deploy_production:
  stage: deploy
  image: alpine:latest
  before_script:
    - apk add --no-cache ansible openssh-client
    - echo "$SSH_PRIVATE_KEY" > key.pem && chmod 600 key.pem
  script:
    - ansible-playbook -i inventory/production/hosts.ini site.yml --private-key key.pem -e "app_image=$IMAGE"
  environment: production
  when: manual
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
```

**Lưu ý khi dùng:**
- Biến `CI_REGISTRY_*` do GitLab tự cung cấp.
- `SSH_PRIVATE_KEY` và các secret khác phải tạo trong **Settings → CI/CD → Variables**, đánh dấu `Masked`, không ghi trong file.
- Image được push trước khi quét, nên nếu quét fail thì image đã nằm trong registry nhưng pipeline không deploy. Có thể xóa tag hoặc chỉ deploy sau khi quét đạt.
- Đây là khung tham khảo. Khi chạy, có thể cần điều chỉnh theo Dockerfile và cấu hình thực tế.

### 9.5. Playbook deploy container lên VM

```yaml
# site.yml
- name: Deploy ứng dụng
  hosts: web
  become: true
  tasks:
    - name: Cài Docker
      package:
        name: docker.io
        state: present

    - name: Đăng nhập registry
      command: docker login -u {{ registry_user }} -p {{ registry_password }} {{ registry_host }}
      no_log: true

    - name: Pull image phiên bản mới
      command: docker pull {{ app_image }}

    - name: Dừng container cũ nếu có
      command: docker rm -f myapp
      ignore_errors: true

    - name: Chạy container mới
      command: docker run -d --name myapp -p 80:8000 {{ app_image }}
```

**Chú ý:** cách dùng `command` ở trên là đơn giản hóa cho lab. Trong thực tế nên dùng module `community.docker.docker_container` để có tính idempotent tốt hơn.

**Bài test nhỏ:** nếu task "Dừng container cũ" có `ignore_errors: true`, điều gì xảy ra lần đầu deploy khi chưa có container nào? Đáp án: lệnh báo lỗi nhưng Ansible bỏ qua và tiếp tục, pipeline không bị dừng.

### 9.6. Kiểm tra sau khi deploy

```bash
curl -I http://192.168.56.10          
curl http://192.168.56.10             
```

### 9.7. Rollback trong lab

Vì image được gắn tag theo commit, rollback chỉ là deploy lại tag cũ:

```bash
ansible-playbook -i inventory/production/hosts.ini site.yml -e "app_image=registry/myapp:<commit_cũ>"
```

### 9.8. Gợi ý nội dung báo cáo và video demo

- Sơ đồ kiến trúc hệ thống (lấy từ mục 9.2 và 9.3).
- Ảnh chụp pipeline xanh, và một lần pipeline đỏ do security gate.
- Video demo: push code → pipeline chạy → bấm deploy production → mở trình duyệt xem kết quả. Chuẩn bị sẵn để kiểm soát thời gian thuyết trình.

---

## 10. Checklist

- [ ] Giải thích được khác biệt CI, Continuous Delivery và Continuous Deployment
- [ ] Viết được pipeline có ít nhất 3 stage
- [ ] Cài Ansible, `ansible --version` chạy được
- [ ] Ping thành công nhiều VM bằng SSH key
- [ ] Viết được playbook cài Nginx có handler và template
- [ ] Chuyển playbook thành role có `defaults` và `tasks`
- [ ] Tích hợp Gitleaks và Trivy với security gate
- [ ] Chạy pipeline end-to-end và deploy lên VM
- [ ] Thử rollback về tag cũ
- [ ] Quay video demo