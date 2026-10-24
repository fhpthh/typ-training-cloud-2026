# Báo cáo Tuần 4 — CI/CD

> **Môi trường thực hành:**
> - GitLab.com (SaaS), project `solar-system`
> - GitLab Shared Runner — Docker executor
> - Docker `24.0.5`, Docker-in-Docker `24.0.5-dind`
> - Node.js `17-alpine3.14` (test) và `18-alpine3.17` (runtime image)
> - MongoDB service `siddharth67/mongo-db:non-prod`
>

---

## Mục lục

- [Phần 1: Tổng quan về CI/CD](#phần-1-tổng-quan-về-cicd)
  - [1. CI/CD là gì?](#1-cicd-là-gì)
  - [2. CI/CD Pipeline](#2-cicd-pipeline)
  - [3. Tổng quan về các nền tảng CI/CD](#3-tổng-quan-về-các-nền-tảng-cicd)
  - [4. Thực hành CI/CD với GitLab](#4-thực-hành-cicd-với-gitlab)
  - [5. Kết luận phần CI/CD](#5-kết-luận-phần-cicd)
- [Tài liệu tham khảo](#tài-liệu-tham-khảo)

---

# Phần 1: Tổng quan về CI/CD

## 1. CI/CD là gì?

### 1.1. DevOps và vị trí của CI/CD

**DevOps** là một văn hóa và tập hợp thực hành nhằm rút ngắn khoảng cách giữa đội **Development** (phát triển) và **Operations** (vận hành). Mục tiêu là đưa phần mềm đến người dùng **nhanh hơn, ổn định hơn và an toàn hơn**.

DevOps dựa trên bốn trụ cột:

| Trụ cột | Nội dung |
| --- | --- |
| **Culture** | Chia sẻ trách nhiệm, giao tiếp mở, học từ lỗi |
| **Automation** | Tự động hóa build, test, deploy, hạ tầng |
| **Measurement** | Đo lường bằng metrics: lead time, deployment frequency, MTTR, change failure rate |
| **Sharing** | Chia sẻ kiến thức, công cụ, quy trình giữa các đội |

**CI/CD** là "xương sống" tự động hóa của DevOps: nó biến các bước build – test – release – deploy thủ công thành một pipeline có thể lặp lại, có kiểm soát và có bằng chứng.

---

### 1.2. Continuous Integration (CI)

**Continuous Integration** là thực hành **tích hợp code thường xuyên** vào nhánh chính (thường là `main`), mỗi lần tích hợp đều được **build và test tự động**.

Các thực hành chính:

- Dùng **một repository chung** cho cả đội.
- Commit thường xuyên, chia nhỏ thay đổi.
- Mỗi lần push/MR đều chạy **pipeline tự động**: lint, build, unit test, kiểm tra chất lượng.
- Phát hiện lỗi sớm, trước khi merge.
- Giữ nhánh chính luôn ở trạng thái "có thể release".

**Mục tiêu:**

- Giảm **merge conflict** và lỗi tích hợp.
- Rút ngắn **feedback loop** cho developer.
- Tăng độ tin cậy của nhánh chính.
- Giảm chi phí sửa lỗi (lỗi phát hiện càng muộn càng đắt).

**Luồng CI điển hình:**

```text
Developer tạo feature branch
        │
        ▼
Commit + push lên GitLab
        │
        ▼
Pipeline tự động: lint → build → unit test → security scan
        │
        ├── Fail → sửa code, push lại
        │
        ▼
Tạo Merge Request → review → pipeline chạy lại
        │
        ▼
Merge vào main → pipeline trên main chạy lại để xác nhận
```

---

### 1.3. Continuous Delivery (CD)

**Continuous Delivery** là phần mở rộng của CI: sau khi code đã build và test thành công, hệ thống **luôn sẵn sàng release** lên production, nhưng bước deploy production **cần con người phê duyệt**.

Đặc điểm:

- Tự động deploy lên môi trường **dev/staging**.
- Chạy **integration test**, **smoke test** trên môi trường gần giống production.
- Production deploy là **manual approval** (bấm nút hoặc qua change request).
- Mỗi commit đều có thể trở thành một bản release.

**Mục tiêu:** giảm rủi ro release, cho phép release thường xuyên nhưng vẫn có "cửa chặn" kiểm soát.

---

### 1.4. Continuous Deployment (CD)

**Continuous Deployment** là mức cao nhất: **mọi thay đổi vượt qua tất cả các bước kiểm tra sẽ tự động được deploy lên production**, không cần phê duyệt thủ công.

Điều kiện để áp dụng:

- Bộ test tự động rất mạnh: unit, integration, E2E, security.
- Có **monitoring**, **alerting**, **feature flag**.
- Có khả năng **rollback nhanh**.
- Văn hóa chấp nhận release nhỏ, thường xuyên.

**Phân biệt CI, Continuous Delivery và Continuous Deployment:**

| Tiêu chí | CI | Continuous Delivery | Continuous Deployment |
| --- | --- | --- | --- |
| Tự động build + test | ✅ | ✅ | ✅ |
| Tự động deploy lên dev/staging | ❌ (thường chỉ build/test) | ✅ | ✅ |
| Deploy production | ❌ | **Manual approval** | **Tự động 100%** |
| Mức độ tự động hóa | Thấp nhất | Trung bình | Cao nhất |
| Rủi ro | Thấp (chưa deploy) | Có kiểm soát | Cần test/monitoring mạnh |
| Phù hợp | Mọi dự án | Phần lớn doanh nghiệp | SaaS, sản phẩm release liên tục |

> **Tóm lại:** CI trả lời câu hỏi *"Code có tích hợp và chạy đúng không?"*. Continuous Delivery trả lời *"Có thể release bất cứ lúc nào không?"*. Continuous Deployment trả lời *"Có thể release tự động ngay bây giờ không?"*.

---

### 1.5. Quy trình từ khi developer viết code đến khi ứng dụng được triển khai

```text
┌─────────────┐
│ Developer   │
│ viết code   │
└──────┬──────┘
       ▼
┌─────────────┐
│ Commit      │
│ + Push      │
└──────┬──────┘
       ▼
┌─────────────────────────────────────────────┐
│ CI Pipeline                                 │
│  1. Checkout source                         │
│  2. Cài dependencies                        │
│  3. Lint / static analysis                  │
│  4. Build                                   │
│  5. Unit test + coverage                    │
│  6. Security scan (SAST/Dependency/Image)   │
│  7. Đóng gói artifact / Docker image        │
└──────┬──────────────────────────────────────┘
       ▼
┌─────────────┐
│ Push image  │
│ lên registry│
└──────┬──────┘
       ▼
┌─────────────────────────────┐
│ Deploy Dev + Integration Test│
└──────┬──────────────────────┘
       ▼
┌─────────────────────────────┐
│ Manual Approval (Delivery)  │
│ hoặc tự động (Deployment)   │
└──────┬──────────────────────┘
       ▼
┌─────────────────────────────┐
│ Deploy Staging/Production   │
│ + Smoke Test                │
└──────┬──────────────────────┘
       ▼
┌─────────────────────────────┐
│ Monitoring + Feedback       │
│ (logs, metrics, alerts)     │
└─────────────────────────────┘
```

Trong quy trình này:

- **Developer** chịu trách nhiệm code, test, review.
- **Pipeline** chịu trách nhiệm build/test/scan/package nhất quán.
- **Registry** lưu image/artifact theo version.
- **Môi trường** (dev/staging/prod) được tách biệt về cấu hình, secret, dữ liệu.
- **Con người** chỉ can thiệp ở các cửa chặn quan trọng (review, approval).

---

### 1.6. Lợi ích và hạn chế của CI/CD

**Lợi ích:**

| Lợi ích | Giải thích |
| --- | --- |
| **Feedback nhanh** | Developer biết code lỗi trong vài phút thay vì vài ngày |
| **Giảm lỗi thủ công** | Build/test/deploy do máy làm, không phụ thuộc "làm đúng theo trí nhớ" |
| **Tính lặp lại** | Cùng một quy trình cho mọi commit, mọi môi trường |
| **Tăng tốc release** | Release nhỏ, thường xuyên, ít rủi ro |
| **Truy vết** | Biết commit nào tạo ra image nào, ai approve, deploy lúc nào |
| **Chất lượng code** | Test tự động, lint, coverage, security scan |
| **Giảm MTTR** | Rollback nhanh về version ổn định |

**Hạn chế / thách thức:**

| Hạn chế | Giải thích |
| --- | --- |
| **Chi phí thiết lập ban đầu** | Viết pipeline, test, hạ tầng, runner |
| **Phụ thuộc vào test** | Test kém → pipeline không đáng tin |
| **Flaky test** | Test chập chờn làm pipeline fail không đúng |
| **Quản lý secret** | Nếu làm sai, secret có thể lộ trong log/image |
| **Bảo trì pipeline** | Pipeline cũng là code, cần review và cập nhật |
| **Thay đổi văn hóa** | Cần đội ngũ chấp nhận commit nhỏ, review, tự động hóa |
| **Rủi ro bảo mật** | CI/CD có quyền deploy, registry, cloud → cần bảo vệ |
| **Vendor lock-in** | Gắn chặt với một nền tảng có thể khó chuyển đổi |

---

## 2. CI/CD Pipeline

### 2.1. Khái niệm CI/CD Pipeline

**Pipeline** là một chuỗi các bước tự động, được định nghĩa bằng code, thực hiện từ khi có thay đổi source code đến khi ứng dụng được build, test và deploy.

Trong GitLab, pipeline được định nghĩa trong file `.gitlab-ci.yml` đặt ở root repository. Pipeline gồm nhiều **stage**, mỗi stage gồm nhiều **job**, mỗi job chạy một **script** trên **runner**.

```text
Pipeline
├── Stage: build
│   ├── Job: compile
│   └── Job: docker_build
├── Stage: test
│   ├── Job: unit_test
│   └── Job: code_coverage
└── Stage: deploy
    ├── Job: deploy_dev
    └── Job: deploy_prod (manual)
```

---

### 2.2. Các thành phần của Pipeline

| Thành phần | Vai trò | Ví dụ |
| --- | --- | --- |
| **Trigger** | Sự kiện kích hoạt pipeline | Push, merge request, schedule, manual |
| **Stage** | Nhóm logic các job, chạy theo thứ tự | `build`, `test`, `deploy` |
| **Job** | Đơn vị công việc, chạy trên một runner | `unit_testing`, `docker_build` |
| **Script** | Các lệnh job thực thi | `npm test`, `docker build` |
| **Runner** | Máy/agent thực thi job | Shared runner, self-hosted runner |
| **Executor** | Cách runner chạy job | Docker, shell, Kubernetes, SSH |
| **Artifact** | File job tạo ra và lưu lại | `test-results.xml`, image `.tar` |
| **Cache** | Dữ liệu tái sử dụng giữa các job | `node_modules` |
| **Variable** | Biến cấu hình | `MONGO_URI`, `IMAGE_VERSION` |

Ví dụ tối giản:

```yaml
stages:
  - build
  - test

build_job:
  stage: build
  script:
    - echo "Building..."
    - mkdir -p dist
    - echo "artifact" > dist/app.txt
  artifacts:
    paths:
      - dist/

test_job:
  stage: test
  script:
    - echo "Testing..."
    - cat dist/app.txt
```

---

### 2.3. Pipeline Trigger

Pipeline có thể được kích hoạt bởi nhiều sự kiện:

| Trigger | Mô tả | Dùng khi nào |
| --- | --- | --- |
| **Push** | Có commit mới lên branch/tag | CI cho branch, tag release |
| **Merge Request** | MR được tạo/cập nhật | Chạy test trước khi merge |
| **Manual** | Người dùng bấm "Run pipeline" | Deploy production, hotfix |
| **Schedule** | Chạy theo cron | Backup, báo cáo, kiểm tra định kỳ |
| **API / Trigger token** | Hệ thống bên ngoài gọi API | Tích hợp với hệ thống khác |
| **Web** | Bấm "New pipeline" trên UI | Chạy thủ công |
| **Tag** | Push tag mới | Release version |

Trong GitLab, dùng `rules` để điều khiển job nào chạy ở trigger nào:

```yaml
job:
  script: echo "Chỉ chạy trên main"
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
```

Và `workflow: rules` để điều khiển **pipeline nào được tạo**:

```yaml
workflow:
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH && $CI_OPEN_MERGE_REQUESTS
      when: never
    - if: $CI_COMMIT_BRANCH
```

**Vấn đề duplicate pipeline:** khi một branch vừa có push vừa có MR, GitLab có thể tạo **2 pipeline** (branch pipeline + MR pipeline). Cách xử lý chuẩn là dùng `workflow: rules` với `$CI_OPEN_MERGE_REQUESTS` để chặn branch pipeline khi MR đang mở.

---

### 2.4. Source Code Management và vai trò của Git

**Source Code Management (SCM)** là hệ thống quản lý phiên bản và cộng tác trên source code. Git là công cụ phổ biến nhất; GitLab/GitHub/Bitbucket là nền tảng lưu trữ và cộng tác.

Vai trò của Git trong CI/CD:

- **Single source of truth**: mọi thay đổi đều có commit, branch, history.
- **Trigger**: push/MR/tag là sự kiện kích hoạt pipeline.
- **Review**: merge request/pull request là cửa chặn chất lượng.
- **Traceability**: pipeline gắn với commit SHA, biết image nào được build từ code nào.
- **Rollback**: có thể checkout/tag lại version cũ.
- **Branching strategy**: GitFlow, trunk-based, GitHub Flow...

Trong bài thực hành, GitLab repository chứa:

- Source code Node.js (`app.js`, `app-test.js`, `package.json`).
- `Dockerfile`, `.dockerignore`.
- `.gitlab-ci.yml`.
- Manifest Kubernetes (cho phần CD sau này).

---

### 2.5. Build Automation và Automated Testing

**Build Automation** là tự động hóa việc:

- Cài dependencies.
- Compile/biên dịch (nếu có).
- Đóng gói artifact (jar, binary, Docker image).
- Tạo version/tag.

**Automated Testing** là tự động chạy:

| Loại test | Mục đích | Ví dụ |
| --- | --- | --- |
| **Unit test** | Kiểm tra từng hàm/module | Mocha, Jest, JUnit |
| **Integration test** | Kiểm tra nhiều thành phần với nhau | API + DB, service + service |
| **E2E test** | Kiểm tra luồng người dùng | Playwright, Cypress, Selenium |
| **Lint/static analysis** | Kiểm tra style, lỗi tĩnh | ESLint, SonarQube |
| **Security scan** | Tìm lỗ hổng, secret, CVE | SAST, Trivy, Gitleaks |
| **Coverage** | Đo phần code được test | NYC, JaCoCo |

**Quality gate** là điều kiện để pipeline tiếp tục, ví dụ:

- Unit test phải pass 100%.
- Coverage tối thiểu 80%.
- Không có lỗi critical/high từ security scan.
- Không có secret bị commit.

Trong bài thực hành:

- `npm test` chạy Mocha, xuất `test-results.xml` (JUnit).
- `npm run coverage` chạy NYC, xuất `coverage/cobertura-coverage.xml`.
- GitLab parse các report này để hiển thị trong pipeline/MR.

---

### 2.6. Artifact và Artifact Management

**Artifact** là file/directory do job tạo ra và được lưu lại sau khi job kết thúc. Artifact có thể được job ở stage sau tải về.

Ví dụ:

```yaml
unit_testing:
  script:
    - npm test
  artifacts:
    when: always
    expire_in: 3 days
    paths:
      - test-results.xml
    reports:
      junit: test-results.xml
```

**Artifact vs Cache:**

| Tiêu chí | Artifact | Cache |
| --- | --- | --- |
| Mục đích | Lưu kết quả job (report, binary, image) | Tái sử dụng dependency giữa các job |
| Tải về job sau | Có (theo `needs`/`dependencies`) | Có (nếu key khớp) |
| Thời gian sống | Theo `expire_in` | Có thể bị xóa/không đảm bảo |
| Ví dụ | `test-results.xml`, `coverage/`, `image.tar` | `node_modules`, `.m2`, pip cache |

**Artifact Management** gồm:

- Lưu trữ tập trung (GitLab artifacts, S3, MinIO, Nexus, Artifactory).
- Version hóa artifact/image.
- Retention policy (xóa sau N ngày).
- Phân quyền truy cập.
- Kiểm tra tính toàn vẹn (checksum, digest).

Trong bài thực hành:

- `test-results.xml` và `coverage/` là artifact dạng report.
- Docker image được `docker save` thành file `.tar` để job `docker_test` dùng.
- Image cuối cùng được push lên Docker Hub/GitLab Container Registry để lưu trữ lâu dài.

> **Lưu ý:** artifact không tự động "chảy" qua job trung gian. Nếu job C cần artifact của job A, C phải `needs`/`dependencies` trực tiếp A — hoặc B phải upload lại artifact đó.

---

### 2.7. Environment Variables

**Environment Variables** là biến cấu hình được inject vào môi trường chạy job.

Các cấp khai báo trong GitLab:

| Cấp | Phạm vi | Ví dụ |
| --- | --- | --- |
| **Instance** | Toàn bộ GitLab instance | Ít dùng |
| **Group** | Tất cả project trong group | `DOCKER_USERNAME` |
| **Project** | Một project | `M_DB_PASSWORD` |
| **Pipeline** | Một lần chạy pipeline | Truyền qua API/UI |
| **Job** | Một job | `MONGO_URI` |
| **Global** (`variables:`) | Tất cả job trong file | `IMAGE_VERSION` |

**Predefined variables** do GitLab cung cấp:

- `CI_COMMIT_SHA`, `CI_COMMIT_BRANCH`, `CI_COMMIT_TAG`
- `CI_PIPELINE_ID`, `CI_PIPELINE_SOURCE`
- `CI_MERGE_REQUEST_*`
- `CI_REGISTRY`, `CI_REGISTRY_IMAGE`, `CI_REGISTRY_USER`, `CI_REGISTRY_PASSWORD`
- `CI_JOB_TOKEN`

**Biến nhạy cảm:**

- **Masked**: không hiển thị giá trị trong job log.
- **Protected**: chỉ có giá trị trên branch/tag protected.
- Nên dùng cả hai cho password/token.

Ví dụ:

```yaml
variables:
  MONGO_PASSWORD: $M_DB_PASSWORD   # M_DB_PASSWORD là masked variable
```

> Không bao giờ hardcode password/token trong `.gitlab-ci.yml`.

---

### 2.8. Quản lý các môi trường Development, Staging và Production

Mỗi môi trường cần được **cô lập** về:

- Cấu hình (URL, endpoint, feature flag).
- Secret (DB password, API key).
- Dữ liệu (DB riêng, bucket riêng).
- Tài nguyên (namespace, VM, cluster riêng).
- Quyền truy cập (ai được deploy).

| Môi trường | Mục đích | Đặc điểm |
| --- | --- | --- |
| **Development** | Dev tự test, tích hợp sớm | Deploy tự động mỗi commit; dữ liệu test; ít người dùng |
| **Staging** | Kiểm thử gần giống production | Deploy tự động hoặc bán tự động; dữ liệu giả lập; QA test |
| **Production** | Người dùng thật | Deploy có approval; monitoring đầy đủ; rollback nhanh |

Trong GitLab, dùng `environment:` để gắn job với môi trường:

```yaml
deploy_dev:
  stage: deploy
  script:
    - ./deploy.sh dev
  environment:
    name: development
    url: https://dev.example.com

deploy_prod:
  stage: deploy
  script:
    - ./deploy.sh prod
  environment:
    name: production
    url: https://example.com
  when: manual
```

GitLab sẽ theo dõi deployment, hiển thị lịch sử và cho phép redeploy/rollback.

---

### 2.9. Deployment Strategies

#### a) Rolling Deployment

Thay thế từng instance/bản sao cũ bằng bản mới, lần lượt, cho đến khi tất cả đều là version mới.

```text
Ban đầu:  [v1] [v1] [v1] [v1]
Bước 1:   [v2] [v1] [v1] [v1]
Bước 2:   [v2] [v2] [v1] [v1]
Bước 3:   [v2] [v2] [v2] [v1]
Kết thúc: [v2] [v2] [v2] [v2]
```

- **Ưu điểm:** không downtime (nếu health check tốt), ít tài nguyên, đơn giản.
- **Nhược điểm:** trong thời gian rollout, hệ thống chạy **nhiều version** cùng lúc; rollback có thể chậm; cần tương thích API/DB.
- **Dùng khi:** deployment thông thường, Kubernetes Deployment mặc định.

#### b) Blue-Green Deployment

Duy trì hai môi trường giống hệt nhau:

- **Blue**: version hiện tại đang nhận traffic.
- **Green**: version mới, chưa nhận traffic.

Sau khi green ổn định, chuyển toàn bộ traffic từ blue sang green.

```text
Trước:  Traffic → Blue (v1)
        Green (v2) — idle

Sau:    Traffic → Green (v2)
        Blue (v1) — giữ để rollback
```

- **Ưu điểm:** chuyển đổi tức thì; rollback tức thì (chuyển traffic lại blue); test green trước khi mở traffic.
- **Nhược điểm:** tốn gấp đôi tài nguyên; cần quản lý DB/migration cẩn thận; không phải lúc nào cũng dễ clone môi trường.
- **Dùng khi:** ứng dụng quan trọng, cần rollback nhanh, release ít nhưng lớn.

#### c) Canary Deployment

Đưa version mới cho **một phần nhỏ traffic** (ví dụ 5–10%), theo dõi metrics, rồi tăng dần nếu ổn.

```text
Traffic: 90% → v1
          10% → v2 (canary)

Nếu metrics ổn: tăng 25% → 50% → 100%
Nếu lỗi: rút traffic khỏi v2, rollback
```

- **Ưu điểm:** giảm rủi ro; phát hiện lỗi sớm với ít người dùng; rollback nhanh.
- **Nhược điểm:** cần hạ tầng routing/metrics phức tạp; cần quan sát tốt; thời gian rollout lâu.
- **Dùng khi:** traffic lớn, cần thử nghiệm an toàn, có monitoring mạnh.

**So sánh:**

| Tiêu chí | Rolling | Blue-Green | Canary |
| --- | --- | --- | --- |
| Downtime | Không (nếu health check) | Không | Không |
| Tài nguyên | Thấp | Cao (2 môi trường) | Trung bình |
| Rollback | Chậm hơn | Tức thì | Nhanh |
| Độ phức tạp | Thấp | Trung bình | Cao |
| Phù hợp | Đa số ứng dụng | Ứng dụng critical | Traffic lớn, cần thử nghiệm |

---

### 2.10. Rollback và Release Management

**Rollback** là quay về version ổn định trước đó khi version mới gặp sự cố.

Các cách rollback:

- **Redeploy image cũ**: deploy lại tag/image trước đó.
- **Blue-Green**: chuyển traffic về môi trường blue.
- **Kubernetes**: `kubectl rollout undo deployment/<name>`.
- **GitLab Environments**: redeploy một deployment trước đó.
- **Database**: cẩn thận với migration; cần chiến lược backward-compatible.

**Release Management** gồm:

- **Versioning**: Semantic Versioning (`MAJOR.MINOR.PATCH`), tag Git.
- **Changelog**: ghi lại thay đổi giữa các version.
- **Approval**: ai được duyệt release, điều kiện gì.
- **Audit trail**: pipeline nào, commit nào, ai deploy, lúc nào.
- **Feature flag**: bật/tắt tính năng không cần deploy lại.
- **Rollback plan**: chuẩn bị trước, không đợi sự cố mới nghĩ.

---

## 3. Tổng quan về các nền tảng CI/CD

### 3.1. GitLab CI/CD

#### Kiến trúc và thành phần chính

GitLab CI/CD gồm 3 thành phần cốt lõi:

```text
┌─────────────────────┐
│   GitLab Server     │  ← quản lý repo, pipeline, job queue, UI, API
└──────────┬──────────┘
           │  runner_token / job_token
           ▼
┌─────────────────────┐
│      Runner         │  ← agent nhận job, chạy job
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│      Executor       │  ← Docker / Shell / Kubernetes / SSH / VM
└─────────────────────┘
```

- **GitLab Server**: quản lý source code, pipeline, job queue, user, permission, registry, environment.
- **Runner**: tiến trình/agent đăng ký với GitLab, poll job, thực thi job.
- **Executor**: backend mà runner dùng để chạy job (Docker container, shell trên host, Kubernetes pod, SSH tới máy khác...).

#### Runner types

| Loại | Phạm vi | Ai quản lý |
| --- | --- | --- |
| **Shared runner** | Toàn bộ GitLab instance | GitLab (SaaS) hoặc admin |
| **Group runner** | Một group | Group owner |
| **Project runner** | Một project | Project maintainer |
| **Hosted runner** | GitLab.com quản lý | GitLab |
| **Self-hosted runner** | Cài trên hạ tầng của bạn | Bạn |

#### Executor types

| Executor | Cách chạy | Phù hợp |
| --- | --- | --- |
| **Shell** | Chạy trực tiếp trên host | Đơn giản, debug, nhưng không cô lập; **không hỗ trợ `services`** |
| **Docker** | Mỗi job một container | Phổ biến nhất, cô lập, reproducible |
| **Kubernetes** | Mỗi job một Pod | Cloud-native, scale tốt |
| **SSH** | Chạy trên máy remote qua SSH | Tận dụng máy có sẵn |
| **VM** | Tạo VM cho mỗi job | Cô lập cao, chậm hơn |

#### Luồng runner đăng ký và nhận job

```text
1. Runner → GitLab: registration_token
2. GitLab → Runner: runner_token
3. Runner → GitLab: request job (runner_token)
4. GitLab → Runner: job payload + job_token
5. Runner → Executor: giao job
6. Executor → GitLab: clone source/artifacts (job_token)
7. Executor → Runner: output + status
8. Runner → GitLab: cập nhật output/status (job_token)
```

> GitLab **không** chủ động kết nối tới runner. Runner là client, poll job từ GitLab. Mô hình này hoạt động sau NAT/firewall, bảo mật hơn và hỗ trợ runner tạm thời/autoscaling.

#### Các tính năng mạnh

- Tích hợp Git + CI/CD + registry + security scanning.
- `.gitlab-ci.yml` khai báo, dễ version hóa.
- Environments, deployments, rollback.
- Auto DevOps.
- Container Registry, Package Registry.
- SAST, Secret Detection, Container Scanning, Dependency Scanning.

---

### 3.2. Jenkins

**Kiến trúc:**

```text
┌─────────────────────┐
│ Jenkins Controller  │  ← quản lý job, cấu hình, plugin, UI
└──────────┬──────────┘
           │
     ┌─────┴─────┐
     ▼           ▼
┌─────────┐ ┌─────────┐
│ Agent 1 │ │ Agent 2 │  ← thực thi build
└─────────┘ └─────────┘
```

- **Controller (master)**: quản lý job, lịch sử, plugin, cấu hình.
- **Agent (slave)**: máy thực thi build; có thể là VM, container, Kubernetes pod.
- **Plugin**: hệ sinh thái rất lớn, gần như mọi thứ đều là plugin.
- **Jenkinsfile**: pipeline as code, viết bằng Groovy (Declarative hoặc Scripted).

**Ưu điểm:**

- Cực kỳ linh hoạt, plugin phong phú.
- Chạy on-premise, kiểm soát hoàn toàn.
- Cộng đồng lớn, tài liệu nhiều.
- Hỗ trợ mọi ngôn ngữ/công cụ.

**Nhược điểm:**

- Cài đặt, bảo trì, nâng cấp phức tạp.
- Plugin xung đột, lỗi sau nâng cấp.
- UI cũ, trải nghiệm không đồng nhất.
- Cần tự quản lý agent, scaling, security.
- Pipeline Groovy khó học hơn YAML.

---

### 3.3. GitHub Actions

**Thành phần:**

- **Workflow**: file YAML trong `.github/workflows/`.
- **Event**: sự kiện kích hoạt (push, pull_request, schedule, workflow_dispatch...).
- **Job**: tập hợp step chạy trên cùng runner.
- **Step**: một bước, có thể là `run` hoặc `uses` một action.
- **Action**: đơn vị tái sử dụng (từ Marketplace hoặc tự viết).
- **Runner**: GitHub-hosted hoặc self-hosted.

Ví dụ:

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci
      - run: npm test
```

**Ưu điểm:**

- Tích hợp chặt với GitHub.
- Marketplace nhiều action.
- Hosted runner miễn phí cho open source.
- Cú pháp YAML dễ học.

**Nhược điểm:**

- Gắn chặt với GitHub.
- Giới hạn phút chạy miễn phí.
- Debug phức tạp hơn so với chạy local.
- Self-hosted runner cần tự quản lý.

---

### 3.4. Runner, Agent và Execution Environment

| Khái niệm | Định nghĩa |
| --- | --- |
| **Runner/Agent** | Tiến trình nhận job từ CI/CD server và thực thi |
| **Executor** | Cách runner chạy job (Docker, shell, K8s...) |
| **Execution environment** | Môi trường cụ thể: OS, image, tool, biến, quyền |
| **Hosted runner** | Do nền tảng quản lý (GitLab.com, GitHub-hosted) |
| **Self-hosted runner** | Do bạn cài và quản lý |

**Hosted vs Self-hosted:**

| Tiêu chí | Hosted | Self-hosted |
| --- | --- | --- |
| Cài đặt | Không cần | Cần cài, cấu hình |
| Bảo trì | Nhà cung cấp | Bạn |
| Chi phí | Theo phút/usage | Phần cứng + vận hành |
| Kiểm soát | Hạn chế | Toàn quyền |
| Bảo mật | Phụ thuộc nhà cung cấp | Bạn chịu trách nhiệm |
| Phù hợp | Dự án nhỏ/vừa | Dự án lớn, on-premise, bảo mật cao |

---

### 3.5. Quản lý Credentials, Variables và Secrets

**Nguyên tắc:**

1. **Không hardcode** secret trong code/YAML/image.
2. Dùng **masked + protected** variables.
3. Phân quyền tối thiểu (least privilege).
4. Xoay vòng (rotate) token định kỳ.
5. Không log secret; cẩn thận với `set -x`, `docker inspect`, `env`.
6. Dùng **secret manager** cho production: HashiCorp Vault, AWS Secrets Manager, GCP Secret Manager, Azure Key Vault.
7. Với cloud: dùng **OIDC** thay vì lưu access key dài hạn.
8. Tách secret theo môi trường (dev/staging/prod).

**Trong GitLab:**

- **Settings → CI/CD → Variables**.
- Masked: che trong log.
- Protected: chỉ branch/tag protected.
- Environment scope: chỉ môi trường cụ thể.
- File type: cho kubeconfig, certificate.

**Trong Jenkins:**

- Credentials plugin, Secret file, Secret text.
- HashiCorp Vault plugin.
- Không dùng plaintext trong Jenkinsfile.

**Trong GitHub Actions:**

- Repository/Environment secrets.
- `GITHUB_TOKEN` tự động, ngắn hạn.
- OIDC cho cloud.

---

### 3.6. So sánh GitLab CI/CD và Jenkins

| Tiêu chí | GitLab CI/CD | Jenkins |
| --- | --- | --- |
| **Mô hình** | SaaS hoặc self-managed, tích hợp Git | Self-hosted, plugin-based |
| **Cấu hình** | `.gitlab-ci.yml` (YAML) | Jenkinsfile (Groovy) + UI |
| **Cài đặt** | Đơn giản (SaaS) hoặc theo hướng dẫn | Phức tạp hơn: Java, plugin, agent |
| **Bảo trì** | Nhà cung cấp (SaaS) hoặc tự quản lý | Tự quản lý hoàn toàn |
| **Plugin** | Tích hợp sẵn nhiều tính năng | Hệ sinh thái plugin khổng lồ |
| **Runner/Agent** | Shared/self-hosted, executor đa dạng | Controller/agent, agent đa dạng |
| **Scalability** | Tốt (SaaS, runner autoscale) | Phụ thuộc hạ tầng/agent |
| **Security** | Tích hợp SAST/secret scanning | Phụ thuộc plugin/cấu hình |
| **Learning curve** | Thấp–trung bình | Trung bình–cao |
| **Chi phí** | Theo tier/usage | Hạ tầng + vận hành |
| **Phù hợp** | Team dùng GitLab, muốn tích hợp | Team cũ dùng Jenkins, cần tùy biến sâu |

**Kết luận:**

- **GitLab CI/CD** phù hợp khi đã dùng GitLab, muốn một nền tảng tích hợp, ít bảo trì, YAML dễ đọc.
- **Jenkins** phù hợp khi cần tùy biến cực sâu, tích hợp hệ thống cũ, hoặc đã có hạ tầng/plugin đầu tư.

---

## 4. Thực hành CI/CD với GitLab

### 4.1. Bài toán và kiến trúc

**Ứng dụng:** Solar System — Node.js + Express + MongoDB, hiển thị thông tin các hành tinh.

**Repository:** `https://gitlab.com/demos-group8624043/solar-system`

**Mục tiêu của phần CI/CD:**

- Chạy unit test và code coverage.
- Build Docker image.
- Kiểm tra image chạy được.
- Push image lên registry.
- Sẵn sàng cho bước deploy bằng Ansible ở phần sau.

**Kiến trúc pipeline:**

```text
Developer push/MR
        │
        ▼
┌─────────────────────────────────────────────┐
│ Stage: test                                 │
│  ├── unit_testing (Node + MongoDB service)  │
│  └── code_coverage (Node + MongoDB service) │
└──────────────────┬──────────────────────────┘
                   ▼
┌─────────────────────────────────────────────┐
│ Stage: containerization                     │
│  ├── docker_build (DinD, save artifact)     │
│  ├── docker_test (load, run, test /live)    │
│  └── docker_push / publish registry         │
└─────────────────────────────────────────────┘
```

**Môi trường:**

- GitLab.com Shared Runner (Docker executor).
- Docker-in-Docker cho job build/test/push.
- MongoDB service container cho job test.

---

### 4.2. Cấu hình pipeline

Dưới đây là cấu hình rút gọn, đã chuẩn hóa theo best practice (secret dùng biến masked):

```yaml
workflow:
  name: Solar System NodeJS Pipeline
  rules:
    - if: $CI_MERGE_REQUEST_SOURCE_BRANCH_NAME =~ /^feature/ && $CI_PIPELINE_SOURCE == "merge_request_event"
      when: always
    - if: $CI_COMMIT_BRANCH && $CI_OPEN_MERGE_REQUESTS
      when: never
    - if: $CI_COMMIT_BRANCH == "main" || $CI_COMMIT_BRANCH =~ /^feature/
      when: always

stages:
  - test
  - containerization

variables:
  DOCKER_USERNAME: tienbibug
  IMAGE_VERSION: $CI_PIPELINE_ID
```

#### Job `unit_testing`

```yaml
unit_testing:
  stage: test
  image: node:17-alpine3.14
  services:
    - name: siddharth67/mongo-db:non-prod
      alias: mongo
      pull_policy: always
  variables:
    MONGO_URI: 'mongodb://mongo:27017/superData'
    MONGO_USERNAME: non-prod-user
    MONGO_PASSWORD: $M_DB_PASSWORD
  cache:
    key:
      files:
        - package-lock.json
      prefix: node_modules
    policy: pull-push
    when: on_success
    paths:
      - node_modules
  before_script:
    - npm install
  script:
    - npm test
  artifacts:
    when: always
    expire_in: 3 days
    name: Mocha-Test-Result
    paths:
      - test-results.xml
    reports:
      junit: test-results.xml
```

**Giải thích:**

- `image: node:17-alpine3.14`: môi trường chạy test.
- `services: mongo`: MongoDB chạy cùng job, alias `mongo`.
- `MONGO_URI`: trỏ tới service `mongo:27017`, database `superData`.
- `MONGO_PASSWORD: $M_DB_PASSWORD`: lấy từ masked variable.
- `cache`: cache `node_modules` theo `package-lock.json`.
- `artifacts.reports.junit`: GitLab hiển thị kết quả test.
- `when: always`: vẫn lưu report khi test fail.

#### Job `code_coverage`

```yaml
code_coverage:
  stage: test
  image: node:17-alpine3.14
  services:
    - name: siddharth67/mongo-db:non-prod
      alias: mongo
      pull_policy: always
  variables:
    MONGO_URI: 'mongodb://mongo:27017/superData'
    MONGO_USERNAME: non-prod-user
    MONGO_PASSWORD: $M_DB_PASSWORD
  cache:
    key:
      files:
        - package-lock.json
      prefix: node_modules
    policy: pull
    when: on_success
    paths:
      - node_modules
  before_script:
    - npm install
  script:
    - npm run coverage
  artifacts:
    name: Code-Coverage-Result
    when: always
    expire_in: 3 days
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml
  coverage: /All files[^|]*\|[^|]*\s+([0-9.]+)/
  allow_failure: true
```

**Giải thích:**

- Chạy song song với `unit_testing` trong stage `test`.
- `coverage_report`: GitLab parse Cobertura XML.
- `coverage` regex: trích xuất % coverage từ log NYC.
- `allow_failure: true`: coverage thấp không chặn pipeline (có thể đổi thành `false` nếu muốn quality gate).

#### Job `docker_build`

```yaml
docker_build:
  stage: containerization
  image: docker:24.0.5
  services:
    - docker:24.0.5-dind
  dependencies: []
  script:
    - docker build -t $DOCKER_USERNAME/solar-system:$IMAGE_VERSION .
    - docker images $DOCKER_USERNAME/solar-system:$IMAGE_VERSION
    - mkdir -p image
    - docker save $DOCKER_USERNAME/solar-system:$IMAGE_VERSION -o image/solar-system-image-$IMAGE_VERSION.tar
  artifacts:
    paths:
      - image
    when: on_success
    expire_in: 3 days
```

**Giải thích:**

- `image: docker:24.0.5`: Docker CLI.
- `services: docker:24.0.5-dind`: Docker daemon (DinD).
- `docker build`: build từ `Dockerfile`.
- `docker save`: lưu image thành `.tar` để job sau dùng.
- `dependencies: []`: không tải artifact từ stage test (không cần).
- `artifacts`: upload thư mục `image/`.

#### Job `docker_test`

```yaml
docker_test:
  stage: containerization
  image: docker:24.0.5
  services:
    - docker:24.0.5-dind
  needs:
    - docker_build
  dependencies:
    - docker_build
  script:
    - docker load -i image/solar-system-image-$IMAGE_VERSION.tar
    - docker run --name solar-system-app -d -p 3000:3000 $DOCKER_USERNAME/solar-system:$IMAGE_VERSION
    - export IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' solar-system-app)
    - echo "App IP: $IP"
    - docker run --rm alpine:3.19 wget -qO- http://$IP:3000/live | grep -q '"live"'
```

**Giải thích:**

- `needs: docker_build`: chờ build xong và tải artifact.
- `docker load`: nạp image vào DinD của job này.
- `docker run`: chạy container.
- `docker inspect`: lấy IP container.
- `wget /live`: kiểm tra endpoint liveness.
- `grep -q`: chỉ kiểm tra exit code, không in JSON.

> Vì sao không dùng `localhost:3000`? Vì container app nằm trong DinD network, không phải trong job container. Phải dùng IP container hoặc chạy client trong cùng DinD network.

#### Job `docker_push` (Docker Hub)

```yaml
docker_push:
  stage: containerization
  image: docker:24.0.5
  services:
    - docker:24.0.5-dind
  needs:
    - docker_build
    - docker_test
  script:
    - docker load -i image/solar-system-image-$IMAGE_VERSION.tar
    - echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin
    - docker push $DOCKER_USERNAME/solar-system:$IMAGE_VERSION
```

**Giải thích:**

- `needs` gồm **cả** `docker_build` và `docker_test`:
  - `docker_build` cung cấp artifact `image/`.
  - `docker_test` đảm bảo image đã test pass.
- `docker login --password-stdin`: tránh password lộ trong command line.
- `docker push`: đẩy image lên Docker Hub.

#### Job `publish_gitlab_container_registry` (GitLab Registry)

```yaml
publish_gitlab_container_registry:
  stage: containerization
  image: docker:24.0.5
  services:
    - docker:24.0.5-dind
  needs:
    - docker_build
    - docker_test
  script:
    - docker load -i image/solar-system-image-$IMAGE_VERSION.tar
    - echo "$CI_REGISTRY_PASSWORD" | docker login "$CI_REGISTRY" -u "$CI_REGISTRY_USER" --password-stdin
    - docker tag $DOCKER_USERNAME/solar-system:$IMAGE_VERSION $CI_REGISTRY_IMAGE/ss-image:$IMAGE_VERSION
    - docker push $CI_REGISTRY_IMAGE/ss-image:$IMAGE_VERSION
```

**Giải thích:**

- `CI_REGISTRY`, `CI_REGISTRY_USER`, `CI_REGISTRY_PASSWORD`, `CI_REGISTRY_IMAGE` do GitLab cung cấp.
- `docker tag`: đổi tên image sang đường dẫn registry GitLab.
- `docker push`: push lên registry tích hợp.

---

### 4.3. Kết quả thực hành

| Hạng mục | Kết quả |
| --- | --- |
| Pipeline trigger | Push lên `main`/`feature/*`, merge request |
| Unit test | Chạy Mocha với MongoDB service; xuất JUnit report |
| Code coverage | Chạy NYC; xuất Cobertura report; hiển thị % trên GitLab |
| Docker build | Build image từ `Dockerfile`; tag theo `$CI_PIPELINE_ID` |
| Docker test | Load image, chạy container, kiểm tra `/live` thành công |
| Docker push | Push image lên Docker Hub |
| GitLab Registry | Push image lên `$CI_REGISTRY_IMAGE/ss-image` |
| Artifact | `test-results.xml`, `coverage/`, `image/*.tar` |
| Cache | `node_modules` được cache theo `package-lock.json` |

**Minh chứng:**

- Repository: `https://gitlab.com/demos-group8624043/solar-system`
- Pipeline: `CI/CD → Pipelines` — các job `unit_testing`, `code_coverage`, `docker_build`, `docker_test`, `docker_push` đã chạy thành công.
- Registry: `Deploy → Container Registry` — image `ss-image` với tag theo pipeline ID.

> Ghi chú: báo cáo sẽ bổ sung screenshot pipeline/registry khi hoàn thiện video demo.

---

### 4.4. Vấn đề gặp phải và cách khắc phục

| # | Vấn đề | Nguyên nhân | Cách khắc phục |
| --- | --- | --- | --- |
| 1 | `This GitLab CI configuration is invalid: mapping values are not allowed in this context at line 21 column 45` | Dòng `echo "Runner: $RUNNER_MACHINE, Node.js: $NODE_VERSION"` là **plain scalar**; dấu `: ` bị YAML hiểu là mapping | Quote toàn bộ lệnh: `'echo "Runner: ..."'` hoặc dùng block scalar `\|` |
| 2 | Log `docker_test` không thấy JSON `{"status":"live"}` | `grep -q` chỉ trả exit code, không in output | Bỏ `-q` của grep, hoặc dùng `echo`/`tee` để xem response |
| 3 | `docker_push` báo không thấy thư mục `image/` | `needs` chỉ có `docker_test`; artifact `image/` do `docker_build` tạo, không được truyền qua job trung gian | Thêm `docker_build` vào `needs` của `docker_push` |
| 4 | Job dùng shell executor không chạy được `services` | Shell executor chạy trực tiếp trên host, không có container/network/DNS | Dùng Docker executor (hoặc Kubernetes/Docker Autoscaler) |
| 5 | Pipeline bị duplicate (branch + MR) | Có job chạy ở cả push và MR, không có `workflow: rules` | Dùng `workflow: rules` với `$CI_OPEN_MERGE_REQUESTS` để chặn branch pipeline khi MR mở |
| 6 | Mongo service không cần khai báo `MONGO_INITDB_*` | Image `siddharth67/mongo-db:non-prod` đã bake sẵn user/password/database/seed data | Chỉ cần `alias` + `MONGO_URI` trỏ tới `mongo:27017`; password khớp `$M_DB_PASSWORD` |
| 7 | Push Docker Hub bị `denied` | Dùng `DOCKER_USERNAME: siddharth67` (không sở hữu namespace) | Đổi sang username Docker Hub của mình (`tienbibug`) và dùng access token |
| 8 | `kubectl version` fail ở job setup kubectl | Thiếu kubeconfig, không kết nối được API server | Thêm biến `KUBE_CONFIG`, ghi ra `~/.kube/config` (phần CD sau) |

**Bài học rút ra:**

- YAML rất nhạy với `: ` trong plain scalar; nên quote toàn bộ command hoặc dùng block scalar.
- Artifact không tự động truyền qua job trung gian; phải `needs` trực tiếp job sản xuất.
- `needs` và `dependencies` khác nhau: `needs` điều khiển thứ tự + tải artifact; `dependencies` giới hạn artifact.
- `grep -q` hữu ích để kiểm tra exit code nhưng không hiển thị output.
- Docker-in-Docker cần runner privileged; shell executor không hỗ trợ `services`.
- Không hardcode secret; dùng masked/protected variables.
- Docker image cần tag duy nhất (`$CI_PIPELINE_ID`) để trace/rollback.

---

### 4.5. Đánh giá phần CI/CD

**Đã hoàn thành:**

- Nắm được khái niệm CI, Continuous Delivery, Continuous Deployment.
- Hiểu và viết được `.gitlab-ci.yml` với stage/job/script.
- Sử dụng GitLab Shared Runner (Docker executor), DinD.
- Chạy unit test + coverage với MongoDB service.
- Cache `node_modules`, artifact JUnit/coverage.
- Build, test, push Docker image.
- Xử lý các lỗi thực tế: YAML syntax, artifact, duplicate pipeline, executor, registry.

**Chưa thực hiện (sẽ bổ sung):**

- Deploy ứng dụng lên VM bằng **Ansible**.
- Tích hợp **DevSecOps**: SAST, Secret Detection, Container Scanning, security gate.
- Quay video demo và chèn screenshot pipeline.
- Phần lý thuyết Ansible (Phần 2 của đề).

---

## 5. Kết luận phần CI/CD

CI/CD là quy trình tự động hóa từ commit đến deploy, giúp:

- Phát hiện lỗi sớm.
- Giảm thao tác thủ công.
- Tăng tốc độ release.
- Đảm bảo mọi thay đổi đều đi qua cùng một quy trình kiểm tra.

Trong bài thực hành, pipeline GitLab CI/CD đã:

- Chạy test và coverage với MongoDB service.
- Build Docker image.
- Kiểm tra image chạy được.
- Push image lên registry.

Đây là nền tảng để bước sang phần **Ansible** — dùng pipeline để tự động deploy image lên VM, hoàn thiện yêu cầu lab tuần 4.

> **Ghi chú:** Phần 2 (Ansible) và Phần 3 (DevSecOps) sẽ được bổ sung trong lần cập nhật tiếp theo.

