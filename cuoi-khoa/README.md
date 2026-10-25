# Bài tập cuối khóa TYP-Training-Cloud-2026

---
### Câu 1: Cài đặt Kubernetes Cluster
- **Yêu cầu**:
    - Triển khai được Kubernetes (thông qua công cụ bất kỳ: kubeadm, kubespray,...)
    - Khuyến khích tìm hiểu và triển khai theo kiến trúc HA
    - Cài đặt sẵn một StorageClass (ví dụ: Local Path Provisioner, NFS, hoặc Longhorn) để cấp phát Persistent Volume tự động

- **Output**:
    - `kubectl get nodes` hiển thị node ready, pod hệ thống hoạt động
    - `kubectl get sc` hiển thị StorageClass hoạt động
    - Tài liệu các bước triển khai

---
### Câu 2: Gitops & Helm Chart
- **Yêu cầu**:
    - Cài đặt ArgoCD lên Kubernetes Cluster, expose được ArgoCD qua NodePort
    - Viết hoặc tìm mẫu Helm Chart cho app bất kỳ, để vào 1 folder riêng trong repo app
    - Triển khai app này bằng Helm Chart thông qua ArgoCD

- **Output**:
    - Các Helm Chart sử dụng để triển khai app lên K8S Cluster
    - Các file `values.yaml` trong config repo của app
    - Manifest của ArgoCD Application
    - Ảnh chụp giao diện màn hình hệ thống ArgoCD trên trình duyệt, đã sync thành công app (`Healthy` & `Synced`)
    - Ảnh chụp giao diện màn hình trình duyệt khi truy cập vào Web URL, API URL

---
### Câu 3: Triển khai Database HA với CloudNativePG (CNPG)
- **Yêu cầu**:
    - Cài đặt CloudNativePG Operator lên Kubernetes Cluster (khuyến khích quản lý qua ArgoCD)
    - Khởi tạo một cụm PostgreSQL Cluster (tối thiểu 2 hoặc 3 instances: 1 Primary và các Standby) sử dụng StorageClass đã cấu hình
    - Cấu hình kết nối ứng dụng ở Câu 2 vào cụm Database CNPG này thông qua Service đọc/ghi (`-rw`) và Secret do CNPG tự sinh hoặc tự định nghĩa

- **Output**:
    - File manifest khai báo `Cluster` của CNPG và các cấu hình liên quan
    - Kết quả lệnh `kubectl get cluster` và `kubectl get pods` hiển thị các instance Primary và Standby đang hoạt động
    - Ảnh chụp hoặc log chứng minh ứng dụng ở Câu 2 đã kết nối và ghi/đọc dữ liệu thành công từ Database

---
### Câu 4: Triển khai Private Container Registry (Harbor)
- **Yêu cầu**:
    - Triển khai Harbor làm Private Registry trên một VM riêng biệt
    - Tạo Project riêng trên Harbor, cấu hình tài khoản để phân quyền push/pull image
    - Cấu hình Kubernetes Cluster (Containerd / ImagePullSecrets) để các node có thể pull image hợp lệ từ Harbor

- **Output**:
    - File cấu hình triển khai Harbor (`values.yaml` hoặc `harbor.yml`)
    - Ảnh chụp giao diện quản trị Harbor cùng Project đã tạo
    - Log hoặc ảnh chụp chứng minh thực hiện `docker login`, `docker push` một image lên Harbor thành công
    - Ảnh chụp pod trên Kubernetes khởi chạy thành công với nguồn image kéo về từ Harbor

---
### Câu 5: Tự động hóa CI/CD với Jenkins
- **Yêu cầu**:
    - Triển khai Jenkins và cấu hình kết nối với Git repository của ứng dụng ở Câu 2
    - Viết `Jenkinsfile` xây dựng luồng CI/CD tự động:
        1. Checkout source code
        2. Build ứng dụng và đóng gói thành Container Image
        3. Push image vừa build lên Harbor
        4. Tự động cập nhật tag image mới vào file `values.yaml` trên Git config repo để ArgoCD tự động nhận diện và rollout phiên bản mới

- **Output**:
    - File `Jenkinsfile` hoàn chỉnh trong source repo của ứng dụng
    - Ảnh chụp giao diện Jenkins Pipeline chạy thành công qua toàn bộ các stage
    - Ảnh chụp lịch sử commit trên Git config repo ghi nhận commit tự động đổi image tag từ Jenkins
    - Ảnh chụp ArgoCD tự động đồng bộ bản cập nhật mới lên K8S Cluster

---
### Câu 6: Giám sát hệ thống với Prometheus & Grafana
- **Yêu cầu**:
    - Triển khai bộ `kube-prometheus-stack` lên Kubernetes Cluster thông qua Helm
    - Expose giao diện Grafana và cấu hình thu thập metrics từ hạ tầng K8S, các Pod ứng dụng và cụm Database CNPG (sử dụng `PodMonitor` / `ServiceMonitor`)
    - Thiết lập ít nhất 1 rule cảnh báo cơ bản (ví dụ: Pod bị crash loop, Node quá tải CPU/RAM) gửi thông báo về Discord, Telegram hoặc Slack

- **Output**:
    - File `values.yaml` của `kube-prometheus-stack` và các manifest `ServiceMonitor`/`PodMonitor`, `PrometheusRule`
    - Ảnh chụp giao diện Grafana Dashboard hiển thị thông số tài nguyên (CPU, Memory, Network) của Cluster và App
    - Ảnh chụp Grafana Dashboard hiển thị metrics của cụm PostgreSQL (CNPG)
    - Ảnh chụp tin nhắn cảnh báo thực tế nhận được trên kênh chat (Telegram/Discord/Slack) khi giả lập sự cố

---
### Câu 7: Quản lý Log tập trung (Loki Stack hoặc EFK Stack)
- **Yêu cầu**:
    - Triển khai hệ thống thu thập log tập trung lên Kubernetes Cluster (khuyến khích dùng bộ **Grafana Loki + Promtail** tích hợp thẳng vào Grafana trên
    - Thu thập toàn bộ logs của ứng dụng và Database CNPG
    - Thực hiện truy vấn, lọc log theo namespace, pod và từ khóa lỗi (ví dụ: `ERROR`, `Exception`)

- **Output**:
    - Các file manifest `values.yaml` dùng để triển khai hệ thống Logging
    - Ảnh chụp giao diện Grafana Explore hiển thị log thời gian thực của ứng dụng và database
    - Ảnh chụp kết quả thực hiện câu lệnh query lọc log theo điều kiện cụ thể

---
### Câu 8: Backup và Restore (Cluster & Database)
- **Yêu cầu**:
    - Chuẩn bị một dịch vụ Object Storage chuẩn S3 (có thể tự dựng **MinIO** trên VM hoặc dùng Cloud S3)
    - **Backup & Restore K8S Resources**: Cài đặt **Velero**, cấu hình kết nối tới S3/MinIO và thực hiện backup định kỳ (Schedule) toàn bộ namespace chứa ứng dụng
    - **Backup & Restore Database**: Cấu hình CNPG Barman Object Store để đẩy bản backup của PostgreSQL lên S3/MinIO

- **Output**:
    - File cấu hình triển khai MinIO, Velero (và cấu hình backup của CNPG nếu có)
    - Kết quả lệnh `velero backup get` hiển thị trạng thái `Completed` và ảnh chụp các file backup đã xuất hiện trên giao diện MinIO/S3
