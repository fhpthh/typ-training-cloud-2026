# Seminar Cloud-Native: Nền Tảng Kiến Trúc và Vận Hành Hệ Thống Hiện Đại

> **Lưu ý**:
    - **Tập trung vào kiến trúc và tư tưởng cốt lõi**: Giải thích rõ bài toán thực tế, luồng hoạt động và lý do công nghệ xuất hiện.
    - **Khuyến khích có demo kết quả trực quan**: Nên chuẩn bị hình ảnh, video ngắn hoặc thao tác thực tế để minh họa cách hệ thống vận hành.
    - **Sẵn sàng phản biện**: Thành viên trình bày phải hiểu rõ bản chất để trả lời với các câu hỏi từ các thành viên khác.

---
## Topic 1: Kubernetes Foundation
- Kubernetes là gì và mục đích chính của nó
- Các bài toán Kubernetes giải quyết trong môi trường container hóa
- Các tính năng cốt lõi:
    - Automated deployment
    - Self-healing
    - Horizontal scaling
- Kiến trúc tổng quan của Kubernetes:
    - Các thành phần của Control Plane
    - Các thành phần của Worker Node
- Vai trò trung tâm của Kubernetes API Server
- Các đối tượng cơ bản trong Kubernetes:
    - Workload: Pod, Deployment, StatefulSets, DeamonSets, ...
    - ConfigMaps, Secrect
    - Networking: Service, Ingress, ...
    - Storage: StorageClasses, PV, PVC, ...

---
## Topic 2: CI/CD & GitOps
- Khái niệm Tích hợp liên tục (CI) và Triển khai liên tục (CD)
- Vai trò của CI/CD trong các hệ thống Kubernetes
- Workflow CI/CD tiêu chuẩn
- Các chiến lược triển khai trong Kubernetes:
    - Rolling updates
    - Rollbacks
- Các công cụ CI phổ biến kết hợp với Kubernetes:
    - Jenkins
    - GitLab CI
- Các công cụ và phương pháp CD:
    - kubectl-based deployments
    - Helm charts
    - GitOps với ArgoCD

---
## Topic 3: Monitoring & Alerting
- Mục đích của việc giám sát trong hệ thống cloud-native
- Các loại metrics trong Kubernetes:
    - Node metrics
    - Pod metrics
    - Application metrics
- Kiến trúc và các khái niệm cốt lõi của Prometheus:
    - Cơ chế Pull / Scraping
    - Time-series DB và PromQL
- Trực quan hóa dữ liệu với Grafana Dashboards
- Khái niệm cảnh báo và Alertmanager
- Cơ chế kiểm tra sức khỏe ứng dụng:
    - Liveness probes
    - Readiness probes

---
## Topic 4: Logging
- Mục đích của logging trong các hệ thống phân tán
- Sự khác biệt giữa logging truyền thống và Kubernetes logging
- Cách Kubernetes xử lý log của ứng dụng: Standard output (stdout) và standard error (stderr)
- Khái niệm về hệ thống log tập trung (Centralized logging)
- Các kiến trúc logging phổ biến
- Các công cụ thu thập log (Log collectors):
    - Fluentd / Fluent Bit
    - Promtail / Grafana Alloy
- Các công cụ lưu trữ và trực quan hóa log:
    - Elasticsearch / Kibana
    - Grafana Loki
- Các nguyên tắc Best practices:
    - Structured logging (định dạng JSON)
    - Metadata và labels
    - Log retention policies

---
## Topic 5:: Distributed Tracing
- Mục đích của distributed tracing trong kiến trúc microservices
- Phân biệt 3 trụ cột của Observability: Metrics, Logs và Traces
- Các khái niệm cốt lõi trong Tracing:
    - Trace
    - Span
    - Trace Context & Context Propagation
- Tiêu chuẩn mở OpenTelemetry (OTel): OTel SDK và OTel Collector
- Các công cụ lưu trữ và hiển thị trace:
    - Grafana Tempo
    - JaGrar
- Các chiến lược lấy mẫu dữ liệu (Sampling strategies):
    - Head-based sampling
    - Tail-based sampling
