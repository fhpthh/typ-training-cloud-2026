# Báo cáo Lab Tuần 4: Hệ thống CI/CD tự động với GitLab CI/CD, Docker và Ansible


---

## 1. Mục tiêu và yêu cầu

Xây dựng hệ thống CI/CD tự động: đóng gói ứng dụng thành Docker image, đánh giá bảo mật, và triển khai lên máy ảo Linux bằng Ansible.

| Yêu cầu đề bài | Thành phần trong bài lab |
|---|---|
| Git Repository | GitLab (self-hosted), project `hello-gitlab` |
| Docker đóng gói image | Dockerfile + Docker-in-Docker trong job |
| CI/CD Platform và Runner | GitLab CI/CD, GitLab Runner (Docker executor) trên VM `lab-runner` |
| Container Registry | GitLab Container Registry của project |
| Ansible Control Node | Job container trong pipeline (cài `ansible-core` khi chạy) |
| Target Linux VM | `lab-staging`, `lab-prod` |
| Secrets Management | CI/CD Variables (masked, protected, file-type) |
| Đánh giá bảo mật (khuyến khích) | Gitleaks (quét secret), Trivy (quét image) + Security Gate |

---

## 2. Kiến trúc hạ tầng

Toàn bộ môi trường chạy trên một máy chủ vật lý dùng KVM/libvirt. Ba máy ảo nằm trong mạng NAT mặc định của libvirt (`192.168.122.0/24`). Máy ảo ra Internet và truy cập GitLab thông qua một HTTP proxy nội bộ.

```
                    +-------------------------------+
                    |  GitLab                       |
                    |  Repo + CI/CD + Registry      |
                    +---------------+---------------+
                                    ^  HTTPS (qua proxy)
                                    |
+-----------------------------------+----------------------------------+
|  Máy chủ vật lý (KVM / libvirt) - mạng NAT 192.168.122.0/24          |
|                                                                      |
|  +-----------------------+    SSH (Ansible)   +------------------+   |
|  | lab-runner            | -----------------> | lab-staging      |   |
|  | GitLab Runner         |                    | Docker + app     |   |
|  | Docker (dind)         |    SSH (Ansible)   +------------------+   |
|  | Job container:        | -----------------> +------------------+   |
|  |  ansible-core         |                    | lab-prod         |   |
|  +-----------------------+                    | Docker + app     |   |
|                                               +------------------+   |
+----------------------------------------------------------------------+
```

| VM | Vai trò | vCPU | RAM | Disk | IP (cố định bằng DHCP reservation) |
|---|---|---|---|---|---|
| lab-runner | GitLab Runner, Docker | 2 | 4 GB | 30 GB | 192.168.122.37 |
| lab-staging | Môi trường staging | 2 | 2 GB | 20 GB | 192.168.122.253 |
| lab-prod | Môi trường production | 2 | 2 GB | 20 GB | 192.168.122.133 |

Hệ điều hành các VM: Ubuntu 24.04 (Noble), tạo từ một base image dùng chung.

---

## 3. Công nghệ sử dụng

| Nhóm | Công cụ | Lý do chọn |
|---|---|---|
| Ảo hoá | KVM, libvirt, cloud-init | Tạo nhiều VM giống nhau nhanh bằng script |
| CI/CD | GitLab CI/CD, GitLab Runner 19.5.1 | Tích hợp sẵn repo, registry, biến bí mật |
| Container | Docker, docker:dind | Build image trong job mà không dùng Docker của máy chủ |
| Cấu hình/triển khai | Ansible (ansible-core) | Agentless, chỉ cần SSH, idempotent |
| Bảo mật | Gitleaks, Trivy | Quét secret trong code và lỗ hổng trong image |

---

## 4. Triển khai hạ tầng

### 4.1. Tạo 3 máy ảo bằng script

Script `create-lab-vms.sh` tạo song song 3 VM:

1. Tạo disk overlay `qcow2` dựa trên một base image (nhanh, tiết kiệm dung lượng).
2. Sinh file `user-data` cho cloud-init: đặt hostname, tạo user `deploy` có sudo không mật khẩu, nạp SSH public key, tắt đăng nhập bằng mật khẩu, cấu hình proxy cho `apt` và `/etc/environment`, cài `qemu-guest-agent`, `curl`, `python3`.
3. Gói thành seed image bằng `cloud-localds`, rồi `virt-install --import`.

Script bỏ qua VM đã tồn tại nên chạy lại được an toàn (idempotent).

```bash
# tên:vCPU:RAM(MB):disk(GB)
VMS=(
  "lab-runner:2:4096:30"
  "lab-staging:2:2048:20"
  "lab-prod:2:2048:20"
)
```

Mã nguồn đầy đủ: xem `scripts/create-lab-vms.sh` trong repository.

### 4.2. Cố định IP cho VM

Mặc định libvirt cấp IP động nên IP có thể đổi sau khi khởi động lại. Ta gắn cố định theo MAC:

```bash
virsh net-update default add ip-dhcp-host \
  "<host mac='52:54:00:b8:db:71' name='lab-runner' ip='192.168.122.37'/>" --live --config
# tương tự cho lab-staging và lab-prod
virsh net-dumpxml default | grep '<host '
```

### 4.3. Kiểm tra VM sẵn sàng

Với mỗi VM, SSH bằng user `deploy` và kiểm tra: hostname, `cloud-init status`, file `/var/lib/cloud/lab-ready`, `sudo -n true`, và truy cập được GitLab qua proxy.

### 4.4. Cài Docker và GitLab Runner trên `lab-runner`

```bash
# Biến proxy cho phiên làm việc
export PROXY=http://<PROXY_HOST>:<PORT>
export http_proxy=$PROXY https_proxy=$PROXY HTTP_PROXY=$PROXY HTTPS_PROXY=$PROXY
export no_proxy=localhost,127.0.0.1,192.168.122.0/24

apt-get update && apt-get install -y docker.io
systemctl enable --now docker

curl -fsSL "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" -o /tmp/runner-repo.sh
bash /tmp/runner-repo.sh
apt-get install -y gitlab-runner
```

### 4.5. Cấu hình proxy cho dịch vụ chạy nền

Biến `export` chỉ có tác dụng trong một phiên shell. Docker daemon và gitlab-runner chạy dưới systemd nên cần drop-in riêng:

```ini
# /etc/systemd/system/docker.service.d/proxy.conf  (tương tự cho gitlab-runner)
[Service]
Environment="HTTP_PROXY=http://<PROXY_HOST>:<PORT>"
Environment="HTTPS_PROXY=http://<PROXY_HOST>:<PORT>"
Environment="NO_PROXY=localhost,127.0.0.1,docker,192.168.122.0/24"
```

```bash
systemctl daemon-reload && systemctl restart docker gitlab-runner
systemctl show docker --property=Environment --value   # kiểm tra đã nạp
```

### 4.6. Đăng ký runner

Runner được tạo trên giao diện GitLab (có tag `lab-docker`), sau đó đăng ký bằng token `glrt-...`:

```bash
gitlab-runner register --non-interactive \
  --url "https://gitlab.example.local" \
  --token "<RUNNER_TOKEN>" \
  --executor docker --docker-image alpine:3.20 \
  --docker-privileged --docker-volumes "/certs/client" \
  --name lab-docker-runner \
  --env "HTTP_PROXY=http://<PROXY_HOST>:<PORT>" \
  --env "HTTPS_PROXY=http://<PROXY_HOST>:<PORT>" \
  --env "NO_PROXY=localhost,127.0.0.1,docker,192.168.122.0/24"
```

Ghi chú:
- `--docker-privileged` và volume `/certs/client` bắt buộc cho Docker-in-Docker có TLS.
- Với token dạng `glrt-`, **tag phải đặt khi tạo runner trên GitLab**; tuỳ chọn `--tag-list` bị bỏ qua.
- Token là bí mật: không đưa vào repository, không dán vào log hay tài liệu.

---

## 5. Thiết kế pipeline CI/CD

### 5.1. Luồng tổng thể

```
push/merge vào main
      |
      v
 build ──> scan ──> deploy-staging (tự động) ──> deploy-prod (bấm tay)
 (image)  (secret   (Ansible -> lab-staging)     (Ansible -> lab-prod)
          + image)
```

- `build`: đóng gói ứng dụng thành image, gắn tag theo commit, đẩy lên Container Registry.
- `scan`: Gitleaks quét secret trong mã nguồn; Trivy quét lỗ hổng của image. Có lỗ hổng mức CRITICAL thì **pipeline dừng** (Security Gate).
- `deploy-staging`: tự động chạy sau khi scan qua.
- `deploy-prod`: `when: manual`, người có quyền bấm xác nhận (Continuous Delivery). Đổi thành tự động nếu muốn Continuous Deployment.

### 5.2. Cấu trúc repository

```
hello-gitlab/
├── .gitlab-ci.yml
├── app/
│   ├── Dockerfile
│   └── index.html
├── ansible/
│   ├── ansible.cfg
│   ├── site.yml
│   ├── inventories/
│   │   ├── staging/hosts.ini
│   │   └── prod/hosts.ini
│   ├── group_vars/all.yml
│   └── roles/
│       ├── docker/tasks/main.yml
│       └── app/tasks/main.yml
└── scripts/create-lab-vms.sh
```

### 5.3. Ứng dụng mẫu

```dockerfile
# app/Dockerfile
FROM nginx:alpine
ARG APP_VERSION=dev
COPY index.html /usr/share/nginx/html/index.html
RUN sed -i "s/__VERSION__/${APP_VERSION}/" /usr/share/nginx/html/index.html
```

```html
<!-- app/index.html -->
<h1>Hello CI/CD</h1><p>Version: __VERSION__</p>
```

Trang hiển thị phiên bản (mã commit) giúp chứng minh khi demo rằng bản mới đã được triển khai.

### 5.4. `.gitlab-ci.yml`

```yaml
default:
  tags: [lab-docker]

stages: [build, scan, deploy-staging, deploy-prod]

variables:
  IMAGE: "$CI_REGISTRY_IMAGE/web"
  DOCKER_TLS_CERTDIR: "/certs"

build:
  stage: build
  image: docker:27
  services: [docker:27-dind]
  script:
    - echo "$CI_REGISTRY_PASSWORD" | docker login -u "$CI_REGISTRY_USER" --password-stdin "$CI_REGISTRY"
    - docker build --build-arg APP_VERSION="$CI_COMMIT_SHORT_SHA" -t "$IMAGE:$CI_COMMIT_SHORT_SHA" app/
    - docker push "$IMAGE:$CI_COMMIT_SHORT_SHA"

secret-scan:
  stage: scan
  image:
    name: zricethezav/gitleaks:latest
    entrypoint: [""]
  script:
    - gitleaks detect --source . --redact --no-banner

image-scan:            # Security Gate: có CRITICAL thì job đỏ, pipeline dừng
  stage: scan
  image:
    name: aquasec/trivy:latest
    entrypoint: [""]
  variables:
    TRIVY_USERNAME: "$CI_REGISTRY_USER"
    TRIVY_PASSWORD: "$CI_REGISTRY_PASSWORD"
  script:
    - trivy image --exit-code 1 --severity CRITICAL --no-progress "$IMAGE:$CI_COMMIT_SHORT_SHA"

.deploy:
  image: python:3.12-alpine
  before_script:
    - apk add --no-cache openssh-client
    - pip install --quiet ansible-core
    - mkdir -p ~/.ssh && cp "$SSH_PRIVATE_KEY" ~/.ssh/id_ed25519 && chmod 600 ~/.ssh/id_ed25519
  script:
    - cd ansible
    - ansible-playbook -i "inventories/$ENV/hosts.ini" site.yml
        -e "image=$IMAGE:$CI_COMMIT_SHORT_SHA"
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH

deploy-staging:
  extends: .deploy
  stage: deploy-staging
  variables: { ENV: staging }
  environment: { name: staging, url: "http://192.168.122.253" }

deploy-prod:
  extends: .deploy
  stage: deploy-prod
  variables: { ENV: prod }
  environment: { name: production, url: "http://192.168.122.133" }
  when: manual
```

---

## 6. Ansible

### 6.1. Cấu hình và inventory

```ini
# ansible/ansible.cfg
[defaults]
remote_user = deploy
host_key_checking = False      # chỉ dùng cho lab; production nên dùng known_hosts
interpreter_python = /usr/bin/python3

[privilege_escalation]
become = True
```

```ini
# ansible/inventories/staging/hosts.ini
[web]
lab-staging ansible_host=192.168.122.253
```

```ini
# ansible/inventories/prod/hosts.ini
[web]
lab-prod ansible_host=192.168.122.133
```

```yaml
# ansible/group_vars/all.yml
proxy_url: "http://<PROXY_HOST>:<PORT>"
no_proxy: "localhost,127.0.0.1,192.168.122.0/24"
app_name: web
app_port: 80
```

### 6.2. Playbook và role

```yaml
# ansible/site.yml
- hosts: web
  roles:
    - docker
    - app
```

```yaml
# ansible/roles/docker/tasks/main.yml
- name: Cài Docker
  ansible.builtin.apt:
    name: docker.io
    state: present
    update_cache: true

- name: Thư mục drop-in proxy cho Docker
  ansible.builtin.file:
    path: /etc/systemd/system/docker.service.d
    state: directory

- name: Cấu hình proxy cho Docker daemon
  ansible.builtin.copy:
    dest: /etc/systemd/system/docker.service.d/proxy.conf
    content: |
      [Service]
      Environment="HTTP_PROXY={{ proxy_url }}"
      Environment="HTTPS_PROXY={{ proxy_url }}"
      Environment="NO_PROXY={{ no_proxy }}"
  notify: restart docker

- name: Bật Docker
  ansible.builtin.service:
    name: docker
    state: started
    enabled: true
```

```yaml
# ansible/roles/docker/handlers/main.yml
- name: restart docker
  ansible.builtin.systemd:
    name: docker
    state: restarted
    daemon_reload: true
```

```yaml
# ansible/roles/app/tasks/main.yml
- name: Đăng nhập Container Registry
  ansible.builtin.command: >
    docker login -u {{ lookup('env', 'CI_REGISTRY_USER') }}
    --password-stdin {{ lookup('env', 'CI_REGISTRY') }}
  args:
    stdin: "{{ lookup('env', 'CI_REGISTRY_PASSWORD') }}"
  no_log: true
  changed_when: false

- name: Chạy container ứng dụng
  community.docker.docker_container:
    name: "{{ app_name }}"
    image: "{{ image }}"
    state: started
    restart_policy: unless-stopped
    pull: true
    published_ports: ["{{ app_port }}:80"]
```

Lưu ý: module `community.docker.*` cần collection `community.docker` và thư viện Python `docker` trên máy đích. Có thể thay bằng `ansible.builtin.command: docker run ...` nếu muốn đơn giản; khi đó cần xử lý idempotency thủ công.

### 6.3. Kiểm tra bằng Ad-hoc trước khi chạy playbook

```bash
ansible -i inventories/staging/hosts.ini web -m ping
ansible -i inventories/staging/hosts.ini web -m command -a "docker ps"
```

---

## 7. Quản lý Secrets

| Bí mật | Nơi lưu | Cách bảo vệ |
|---|---|---|
| SSH private key cho Ansible | CI/CD Variable, kiểu **File** | Protected, chỉ nhánh được bảo vệ đọc được; dùng khoá riêng cho CI, không dùng lại khoá cá nhân |
| Mật khẩu Container Registry | Biến có sẵn `CI_REGISTRY_PASSWORD` (token job, ngắn hạn) | Tự cấp, tự hết hạn |
| Runner token `glrt-...` | Chỉ nằm trong `/etc/gitlab-runner/config.toml` trên VM | Quyền file 600; không đưa vào repo hay tài liệu; nếu lộ thì xoá/reset runner trên GitLab |

Nguyên tắc: không commit bí mật vào repository (Gitleaks trong pipeline giúp phát hiện), không in bí mật ra log (`no_log: true` trong Ansible, biến masked trong GitLab).

---

## 8. Kết quả và sự cố gặp phải

### 8.1. Kết quả

| Hạng mục | Trạng thái |
|---|---|
| Tạo 3 VM bằng script, cố định IP | Hoàn thành |
| Cài Docker, GitLab Runner, cấu hình proxy cho dịch vụ | Hoàn thành |
| Đăng ký runner, runner nhận và chạy job | Hoàn thành (job `runner-info` chạy xong trong ~5 giây) |
| Gửi log và trạng thái job về GitLab | **Đang xử lý**, xem mục 8.2 |
| Build, push image, scan, deploy bằng Ansible | **Chưa chạy thử** [ĐIỀN SAU] |

Ảnh chụp minh hoạ: [ĐIỀN SAU] runner online, pipeline xanh, trang web staging/prod hiển thị phiên bản.

### 8.2. Sự cố: log và trạng thái job không về tới GitLab

**Hiện tượng.** Trên giao diện GitLab, job dừng ở dòng `Pulling docker image ...` rất lâu rồi chuyển failed. Trên VM, log của runner cho thấy job đã `succeeded`.

**Phân tích.**

| Bước kiểm tra | Kết quả | Kết luận |
|---|---|---|
| `docker pull` thủ công trên runner | Thành công | Docker đi qua proxy tốt |
| Log runner | Job `succeeded` sau ~4,7 giây | Job chạy đúng; không phải Docker lỗi |
| Log runner | Lần gửi log đầu nhận `202 Accepted`, các lần sau nhận `200 OK` | Runner mong `202`, nhận `200` nên coi là lỗi và gửi lại mãi |
| `correlation_id` trong phản hồi | Phản hồi `202` có định dạng của GitLab; phản hồi `200` có định dạng khác | Gợi ý phản hồi `200` do thiết bị trung gian (proxy) trả về, chưa phải GitLab |
| Gọi `PATCH` thử qua proxy tới API trace | GitLab trả `403` đúng | Proxy chuyển được PATCH ở mức cơ bản |
| Gọi thẳng, không qua proxy | Không phân giải được tên miền GitLab | VM bắt buộc phải đi qua proxy |

**Hệ quả.** Lần gửi cuối (log còn lại và trạng thái `success`) không được GitLab nhận, nên GitLab không biết job đã xong và đánh failed sau khi hết thời gian chờ.

**Hướng xử lý (đang thực hiện).**
1. Chạy job tối thiểu chỉ ASCII (`echo hello`) để xem lỗi do nội dung log hay do mọi lần gửi thứ hai.
2. Nhờ quản trị proxy xem log truy cập đối với các request `PATCH .../trace` và kiểm tra proxy có kiểm tra/giải mã nội dung HTTPS không.

**Bài học.** Khi runner chạy qua proxy, cần kiểm tra không chỉ việc kéo image mà cả kênh runner báo cáo ngược về GitLab; lỗi ở kênh này khiến job "treo" dù thực tế đã chạy xong.

---

## 9. Hạn chế và hướng phát triển

- `host_key_checking = False` chỉ phù hợp lab; production nên quản lý `known_hosts`.
- Triển khai kiểu thay container (không có rolling/blue-green/canary). Có thể mở rộng thành Blue-Green bằng hai container và đổi cổng.
- Chưa có cơ chế rollback tự động; hiện có thể rollback bằng cách chạy lại pipeline với tag image cũ.
- Thêm DAST, quản lý false positive của Trivy bằng file `.trivyignore`.
- Dùng Ansible Vault hoặc Vault/OpenBao cho secrets thay vì chỉ CI/CD Variables.

---

## 10. Tài liệu tham khảo

- GitLab CI/CD: https://docs.gitlab.com/ci/
- GitLab Runner (Docker executor): https://docs.gitlab.com/runner/executors/docker/
- Ansible: https://docs.ansible.com/
- Trivy: https://trivy.dev/
- Gitleaks: https://github.com/gitleaks/gitleaks
