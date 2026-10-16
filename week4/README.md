# Tuần 4: CI/CD, Ansible và DevSecOps

## Phần 1: Tổng quan về CI/CD

1. **CI/CD là gì?**
    - Khái niệm DevOps và CI/CD.
    - Mục đích và vai trò của CI/CD trong quy trình phát triển phần mềm.
    - Continuous Integration (CI).
    - Continuous Delivery và Continuous Deployment.
    - Phân biệt CI, Continuous Delivery và Continuous Deployment.
    - Quy trình từ khi developer viết code đến khi ứng dụng được triển khai.
    - Lợi ích và hạn chế của CI/CD.

2. **CI/CD Pipeline**
    - Khái niệm CI/CD Pipeline.
    - Các thành phần của Pipeline: Trigger, Stage, Job,...
    - Pipeline Trigger: Push, Pull Request/Merge Request, Manual Trigger.
    - Source Code Management và vai trò của Git trong CI/CD.
    - Build Automation và Automated Testing.
    - Artifact và Artifact Management.
    - Environment Variables.
    - Quản lý các môi trường Development, Staging và Production.
    - Deployment Strategies: Rolling, Blue-Green, Canary.
    - Rollback và Release Management.

3. **Tổng quan về các nền tảng CI/CD**
    - Các nền tảng CI/CD phổ biến: GitLab CI/CD, Jenkins, GitHub Actions.
    - Kiến trúc và các thành phần chính của từng nền tảng.
    - Runner, Agent và Execution Environment.
    - Hosted Runner và Self-hosted Runner.
    - Quản lý Credentials, Variables và Secrets.
    - So sánh GitLab CI/CD và Jenkins.

---
## Phần 2: Tổng quan về Ansible

1. **Giới thiệu**
    - Khái niệm Configuration Management.
    - Ansible là gì? Vai trò của Ansible.
    - Các trường hợp sử dụng Ansible: Configuration Management, Application Deployment, Provisioning và Operational Automation.
    - So sánh Ansible với Shell Script.
    - Control Node và Managed Node.
    - Cơ chế giao tiếp qua SSH.

2. **Cài đặt và cấu hình Ansible**
    - Các phương pháp cài đặt Ansible trên Linux.
    - Ansible Core và Ansible Community Package.
    - Cài đặt Ansible trên Ubuntu hoặc RHEL.
    - Kiểm tra phiên bản bằng ansible --version.
    - File cấu hình ansible.cfg.
    - Cấu hình SSH Key Authentication.
    - Kiểm tra kết nối đến Managed Node bằng Ansible.

3. **Inventory và Ad-hoc Commands**
    - Khái niệm Inventory.
    - Static Inventory và Dynamic Inventory.
    - Host, Group và Group Variables.
    - Host Variables và Inventory Variables.
    - Host Patterns và cách lựa chọn Managed Nodes.
    - Inventory cho nhiều môi trường.
    - Ad-hoc Commands.
    - Các module cơ bản: ping, command, shell, copy, file, package, service, user.
    - Thực hành: tạo Inventory và kiểm tra kết nối đến nhiều Linux VM.
    - Thực hành: quản lý file, package và service bằng Ad-hoc Commands.

4. **Ansible Playbooks**
    - Khái niệm Playbook và YAML.
    - Cấu trúc Playbook: Plays, Tasks và Modules.
    - Variables và Variable Precedence.
    - Tags và Task Selection.
    - Check Mode và Diff Mode.
    - Thực hành: viết Playbook cài đặt và cấu hình Nginx trên Linux VM.

5. **Ansible Roles và tổ chức Project**
    - Khái niệm Role và mục đích tái sử dụng.
    - Cấu trúc thư mục của một Ansible Role.
    - Các thành phần: tasks, handlers, templates, files, defaults, vars, meta.
    - Phân biệt defaults và vars.
    - Sử dụng Role trong Playbook.
    - Ansible Collections và Ansible Galaxy.
    - Tách Playbook thành các Role theo chức năng.
    - Quản lý Variables cho nhiều môi trường.
    - Tổ chức Repository theo hướng dễ bảo trì và tái sử dụng.
    - Thực hành: xây dựng Role triển khai và cấu hình Nginx.

---
## Phần 3: Tìm hiểu thêm (nếu có nhu cầu)
1. **Tổng quan về DevSecOps**
    - Khái niệm DevSecOps và Shift Left Security.
    - Security as Code và Security Gate.
    - Các rủi ro bảo mật trong quy trình CI/CD.
    - OWASP Top 10 và Software Supply Chain Security.
2. **Tích hợp Security vào CI/CD Pipeline**
    - Security Testing (SAST, DAST).
    - Container Image Scanning.
    - Tích hợp công cụ bảo mật vào Pipeline: SonarQube, Trivy, Gitleaks.
    - Security Gate: điều kiện cho phép hoặc chặn Pipeline.
    - Quản lý kết quả Security Scan, Vulnerability và False Positive.

---
## Phần 4: Thực hành Lab
> **Các bạn cần có source code trong báo cáo và quay Video demo để khi thuyết trình show ra cho kiểm soát được thời gian**

**Yêu cầu**: 
- Xây dựng một hệ thống CI/CD tự động: đóng gói ứng dụng, đánh giá bảo mật (khuyến khích) và triển khai ứng dụng lên VM bằng Ansible. 
- Lựa chọn một trong hai nền tảng: GitLab CI/CD hoặc Jenkins.
    - Git Repository: quản lý mã nguồn ứng dụng và cấu hình Pipeline.
    - Docker: đóng gói ứng dụng thành images
    - CI/CD Platform và Runner/Agent: điều phối, thực thi Pipeline.
    - Artifact Repository hoặc Container Registry: lưu trữ phiên bản Artifact.
    - Ansible Control Node: tự động cấu hình và triển khai ứng dụng.
    - Target Linux VM: môi trường triển khai ứng dụng.
    - Secrets Management: quản lý thông tin xác thực và quyền truy cập.
