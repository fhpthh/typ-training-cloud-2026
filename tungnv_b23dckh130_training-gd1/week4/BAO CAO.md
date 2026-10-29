# BÁO CÁO TỔNG HỢP KIẾN THỨC VÀ THỰC HÀNH TUẦN 4: CI/CD, ANSIBLE VÀ DEVSECOPS

---

## MỤC LỤC TỔNG QUAN

- [**PHẦN 1: TỔNG QUAN VỀ CI/CD**](#phần-1-tổng-quan-về-cicd)
- [**PHẦN 2: TỔNG QUAN VỀ ANSIBLE**](#phần-2-tổng-quan-về-ansible)
- [**PHẦN 3: TỔNG QUAN VỀ DEVSECOPS VÀ BẢO MẬT CI/CD PIPELINE**](#phần-3-tổng-quan-về-devsecops-và-bảo-mật-cicd-pipeline)

---

# PHẦN 1: TỔNG QUAN VỀ CI/CD

# 1. Mục 1: CI/CD là gì?

## 1.1. Khái niệm DevOps và văn hóa CI/CD

Trong mô hình phát triển phần mềm truyền thống (mô hình Thác nước - Waterfall hoặc giai đoạn đầu của Agile), tổ chức công nghệ thường bị chia tách thành hai phòng ban độc lập với mục tiêu trái ngược nhau:
- **Đội ngũ Phát triển (Development - Dev):** Tập trung vào việc tạo ra tính năng mới nhanh nhất có thể để đáp ứng yêu cầu kinh doanh. Thước đo thành công của họ là số lượng tính năng được bàn giao.
- **Đội ngũ Vận hành (Operations - Ops):** Tập trung vào việc duy trì tính ổn định, độ tin cậy và hiệu năng của hệ thống sản xuất. Mọi sự thay đổi về mã nguồn đều bị xem là rủi ro tiềm ẩn có thể gây sập hệ thống.

Sự xung đột về mục tiêu này tạo ra bức tường ngăn cách vô hình: Mã nguồn chạy hoàn hảo trên máy tính của lập trình viên nhưng khi chuyển giao sang máy chủ của đội vận hành thì liên tục phát sinh lỗi môi trường, xung đột thư viện và sập dịch vụ.

```text
┌───────────────────────────┐                      ┌────────────────────────────┐
│     DEVELOPMENT (DEV)     │                      │      OPERATIONS (OPS)      │
│  - Yêu cầu thay đổi nhanh │      BỨC TƯỜNG       │  - Yêu cầu hệ thống ổn định│
│  - Thêm tính năng mới     │     NGĂN CÁCH VÔ HÌNH│  - Hạn chế tối đa rủi ro   │
│  - Chạy tốt trên máy Local│ ════════════════════ │  - Lỗi môi trường, sập app │
└─────────────┬─────────────┘                      └─────────────▲──────────────┘
              │                                                  │
              └─────────────── Ném code qua tường ───────────────┘
                                 (Đùn đẩy trách nhiệm)
```

**DevOps ra đời như một cuộc cách mạng văn hóa và phương pháp luận:**
DevOps (kết hợp giữa Development và Operations) xóa bỏ rào cản này bằng cách hợp nhất hai đội ngũ thành một thể thống nhất, cùng chia sẻ trách nhiệm từ khâu lập kế hoạch, viết mã, kiểm thử đến đóng gói, triển khai và giám sát hệ thống trên môi trường thực tế.

Trong văn hóa DevOps, **CI/CD chính là xương sống kỹ thuật**. Nếu DevOps là tư tưởng và triết lý làm việc thì CI/CD chính là công cụ và phương tiện cụ thể hóa tư tưởng đó, biến các quy trình thủ công chậm chạp thành các chuỗi tự động hóa khép kín và liên tục.

---

## 1.2. Mục đích và vai trò của CI/CD trong phát triển phần mềm hiện đại

Mục đích cốt lõi của CI/CD là rút ngắn tối đa vòng đời phát triển phần mềm, chuyển đổi từ các chu kỳ phát hành định kỳ theo quý hoặc theo năm sang mô hình phát hành hàng ngày, thậm chí hàng giờ.

```text
               ┌────────────────────────────────────────────────────────┐
               │              VÒNG LẶP VÔ CỰC CỦA DEVOPS                │
               │                                                        │
               │   [Plan] ──> [Code] ──> [Build] ──> [Test]             │
               │     ▲                                  │               │
               │     │         CONTINUOUS INTEGRATION   │               │
               │     │         CONTINUOUS DELIVERY      │               │
               │     │         CONTINUOUS DEPLOYMENT    ▼               │
               │   [Monitor] <── [Operate] <── [Deploy] <── [Release]   │
               └────────────────────────────────────────────────────────┘
```

### Vai trò chiến lược của CI/CD:
1. **Loại bỏ quy trình thủ công dễ sai sót:** Mọi thao tác biên dịch mã nguồn, chạy kiểm thử, đóng gói container và triển khai lên máy chủ đều do máy móc tự động thực hiện theo các kịch bản chuẩn hóa, loại bỏ hoàn toàn yếu tố sai sót do con người.
2. **Phát hiện lỗi cực sớm (Fail Fast, Fix Fast):** Bất kỳ đoạn mã nguồn nào bị lỗi cú pháp, vi phạm tiêu chuẩn bảo mật hoặc làm gãy các luồng nghiệp vụ hiện tại đều bị hệ thống tự động phát hiện và chặn lại chỉ trong vòng vài phút sau khi lập trình viên đẩy mã lên kho lưu trữ.
3. **Giải phóng năng suất kỹ sư:** Lập trình viên không còn phải mất hàng giờ đồng hồ mỗi ngày để tự đóng gói tệp cài đặt, gửi email thông báo hay đăng nhập SSH vào máy chủ để chạy lệnh triển khai.
4. **Tăng tốc độ phản hồi từ thị trường:** Các tính năng mới, bản vá bảo mật hoặc sửa lỗi khẩn cấp có thể đến tay người dùng cuối gần như ngay lập tức sau khi hoàn thành kiểm thử.

---

## 1.3. Continuous Integration - Tích hợp liên tục

**Continuous Integration (CI)** là phương pháp phát triển phần mềm đòi hỏi các thành viên trong đội ngũ lập trình phải tích hợp mã nguồn của mình vào nhánh chính của kho lưu trữ chung một cách thường xuyên.

### Cơ chế hoạt động của CI:
1. Lập trình viên hoàn thành một tác vụ nhỏ trên nhánh tính năng cá nhân và tạo yêu cầu hợp nhất mã nguồn (Pull Request hoặc Merge Request).
2. Hệ thống CI Server tự động phát hiện sự kiện và kích hoạt một tiến trình làm việc độc lập:
   - Kéo mã nguồn mới nhất về môi trường máy chủ tạm thời.
   - Biên dịch mã nguồn (Build) và tải các thư viện phụ thuộc.
   - Chạy các công cụ kiểm tra chất lượng mã nguồn tĩnh (Linter, SonarQube) để đảm bảo tuân thủ tiêu chuẩn lập trình.
   - Thực thi toàn bộ bộ kiểm thử tự động cấp độ đơn vị (Unit Tests) và kiểm thử tích hợp (Integration Tests).
3. Nếu **bất kỳ bước nào thất bại**, Pipeline lập tức dừng lại, đánh dấu trạng thái đỏ (Failed) và gửi thông báo cảnh báo ngay lập tức qua Slack, Email hoặc thông báo trên Git cho lập trình viên.
4. Nếu **toàn bộ các bước thành công**, mã nguồn mới được phép hợp nhất vào nhánh chính.

```text
Developer Push Code ──► CI Server Kích hoạt ──► Biên dịch (Build) ──► Chạy Lint & Test
                                                                           │
               ┌───────────────────────────────────────────────────────────┴────────────────┐
               ▼                                                                            ▼
        [Kiểm thử THẤT BẠI]                                                         [Kiểm thử THÀNH CÔNG]
   - Chặn hợp nhất nhánh (Block PR)                                            - Cho phép hợp nhất vào main
   - Báo động ngay cho lập trình viên                                          - Đóng gói Artifact / Image
```

Trọng tâm của CI là ngăn ngừa hội chứng ác mộng hợp nhất (Merge Hell) – tình trạng các lập trình viên làm việc độc lập trên các nhánh riêng biệt trong nhiều tuần, để rồi khi gom lại thì phát sinh hàng trăm xung đột mã nguồn phức tạp mất nhiều ngày để giải quyết.

---

## 1.4. Continuous Delivery - Chuyển giao liên tục

**Continuous Delivery (CD)** là bước mở rộng tự nhiên của Continuous Integration. Mục tiêu của Chuyển giao liên tục là đảm bảo rằng mọi phiên bản mã nguồn đã vượt qua tầng CI đều nằm ở trạng thái **luôn luôn sẵn sàng để triển khai lên môi trường sản xuất bất cứ lúc nào**.

### Bản chất kỹ thuật của Continuous Delivery:
- Sau khi mã nguồn được tích hợp thành công, hệ thống tự động đóng gói ứng dụng thành các gói thành phẩm hoàn chỉnh (Artifacts) như Docker Image, tệp nhị phân `.jar`, `.tar.gz`, gói `.deb`/`.rpm`.
- Tự động triển khai gói thành phẩm này lên các môi trường kiểm thử trung gian: môi trường phát triển (Development), môi trường kiểm thử kiểm chứng (Staging / UAT).
- Chạy tự động các bài kiểm thử hồi quy nâng cao (Regression Testing), kiểm thử giao diện người dùng (E2E Testing) và kiểm tra tải hiệu năng (Load Testing).
- **Điểm chốt chặn quan trọng:** Mặc dù ứng dụng đã được kiểm thử toàn diện và sẵn sàng phát hành, việc quyết định đưa phiên bản đó lên môi trường Production thực tế vẫn cần **một bước phê duyệt thủ công** từ con người.

Continuous Delivery trao quyền chủ động cho doanh nghiệp quyết định thời điểm phát hành tính năng phù hợp với chiến dịch tiếp thị và kinh doanh.

---

## 1.5. Continuous Deployment - Triển khai liên tục

**Continuous Deployment (cũng viết tắt là CD)** là cấp độ tự động hóa cao nhất và triệt để nhất trong toàn bộ chuỗi DevOps.

Trong mô hình Triển khai liên tục, ranh giới can thiệp thủ công của con người bị xóa bỏ hoàn toàn:
- Mọi thay đổi mã nguồn sau khi được lập trình viên hợp nhất vào nhánh chính, nếu vượt qua toàn bộ các cổng kiểm tra của CI và các vòng kiểm thử tự động của Staging, sẽ được hệ thống tự động đẩy thẳng lên môi trường sản xuất (Production) mà **không cần bất kỳ sự phê duyệt hay nút bấm xác nhận nào của con người**.
- Toàn bộ quá trình từ lúc lập trình viên gõ lệnh đẩy code lên kho lưu trữ đến khi người dùng cuối trải nghiệm tính năng mới trên Production chỉ diễn ra trong vòng vài phút đến nửa giờ.

Mô hình này đòi hỏi tổ chức phải có mức độ trưởng thành công nghệ cực kỳ cao: Bộ kiểm thử tự động phải đạt độ bao phủ toàn diện, hệ thống giám sát thời gian thực phải đủ nhạy bén và bắt buộc phải có cơ chế tự động khôi phục (Auto-rollback) ngay tức thì nếu phát hiện lỗi phát sinh sau khi triển khai.

---

## 1.6. Phân biệt chuyên sâu: CI, Continuous Delivery và Continuous Deployment

Dưới đây là sơ đồ dòng chảy và bảng đối chiếu chi tiết ba khái niệm nền tảng này:

```text
                      CI / CD PIPELINE COMPARISON
┌─────────────────────────────────────────────────────────────────────────────────────────┐
│ Phase / Step           │ CI          │ Continuous Delivery       │ Continuous Deployment│
├────────────────────────┼─────────────┼───────────────────────────┼──────────────────────┤
│ 1. Viết mã nguồn       │ Tự động     │ Tự động                   │ Tự động              │
│ 2. Biên dịch (Build)   │ Tự động     │ Tự động                   │ Tự động              │
│ 3. Chạy Unit/Lint Test │ Tự động     │ Tự động                   │ Tự động              │
│ 4. Đóng gói Artifact   │   -         │ Tự động                   │ Tự động              │
│ 5. Triển khai Staging  │   -         │ Tự động                   │ Tự động              │
│ 6. Phê duyệt phát hành │   -         │ THỦ CÔNG (Human Decision) │ TỰ ĐỘNG (Bỏ qua)     │
│ 7. Triển khai PROD     │   -         │ Tự động sau khi duyệt     │ TỰ ĐỘNG HOÀN TOÀN    │
└─────────────────────────────────────────────────────────────────────────────────────────┘
```

### Bảng phân tích chi tiết

| Tiêu chí | Continuous Integration (CI) | Continuous Delivery (CD) | Continuous Deployment (CD) |
| :--- | :--- | :--- | :--- |
| **Trọng tâm cốt lõi** | Kiểm tra tính đúng đắn và tương thích của mã nguồn khi tích hợp. | Đảm bảo phần mềm luôn ở trạng thái sẵn sàng phát hành lên Production. | Đưa trực tiếp giá trị mới đến tay người dùng cuối một cách tự động và liên tục. |
| **Phạm vi tác động** | Từ khâu Code đến khi chạy xong bộ kiểm thử đơn vị và tích hợp. | Từ khâu Code, Test, đóng gói Artifact đến triển khai lên Staging. | Xuyên suốt từ khâu Code đến khi chạy thực tế trên hạ tầng Production. |
| **Can thiệp của con người** | Không (hoàn toàn tự động khi kích hoạt). | **Có:** Cần con người phê duyệt thủ công trước khi đẩy lên Production. | **Không:** Hoàn toàn tự động hóa 100% không qua can thiệp thủ công. |
| **Sản phẩm đầu ra** | Mã nguồn hợp nhất sạch lỗi và kết quả báo cáo kiểm thử. | Gói cài đặt (Artifact/Image) hoàn chỉnh đã qua kiểm nghiệm. | Ứng dụng phiên bản mới đang chạy thực tế trên hệ thống sản xuất. |
| **Yêu cầu độ tin cậy kiểm thử** | Mức độ trung bình (chủ yếu Unit Test, Integration Test). | Mức độ cao (thêm E2E, Regression, Security, Load Testing). | **Mức độ tuyệt đối:** Kiểm thử phải tin cậy 100% vì không có con người giám sát duyệt code. |

---

## 1.7. Quy trình chuẩn từ khi Developer viết code đến khi ứng dụng được triển khai

Chu trình phát triển và vận hành một tính năng mới trong mô hình CI/CD tiêu chuẩn trải qua 6 chặng liên kết chặt chẽ:

```text
┌──────────────┐     git push      ┌──────────────┐     Trigger      ┌──────────────┐
│  Developer   │ ────────────────> │ Git Repo     │ ───────────────> │ CI/CD Server │
│  (Viết code) │                   │ (GitHub/Lab) │                  │ (Runner)     │
└──────────────┘                   └──────────────┘                  └──────┬───────┘
                                                                            │
      ┌─────────────────────────────────────────────────────────────────────┘
      │
      ▼
┌──────────────┐     Thành công    ┌──────────────┐    Thành công     ┌──────────────┐
│ Chặng 1:     │ ────────────────> │ Chặng 2:     │ ────────────────> │ Chặng 3:     │
│ Code Quality │                   │ Build App    │                   │ Package &    │
│ & Unit Test  │                   │ & Compile    │                   │ Artifact     │
└──────────────┘                   └──────────────┘                   └──────┬───────┘
                                                                             │
      ┌──────────────────────────────────────────────────────────────────────┘
      │
      ▼
┌──────────────┐     Kiểm thử tốt  ┌──────────────┐    Phê duyệt/Auto ┌──────────────┐
│ Chặng 4:     │ ────────────────> │ Chặng 5:     │ ────────────────> │ Chặng 6:     │
│ Deploy       │                   │ Integration  │                   │ Deploy       │
│ Staging      │                   │ & E2E Test   │                   │ Production   │
└──────────────┘                   └──────────────┘                   └──────────────┘
```

1. **Giai đoạn 1 - Phát triển cục bộ (Local Development):**
   Lập trình viên tạo nhánh mới từ nhánh chính, viết mã nguồn, thực thi kiểm thử đơn vị cục bộ và cam kết mã nguồn lên Git.

2. **Giai đoạn 2 - Kích hoạt và Kiểm tra tĩnh (Trigger & Linting):**
   Khi tạo Pull Request, webhook tự động báo động cho CI Runner khởi tạo môi trường container cô lập. Hệ thống chạy linter kiểm tra chuẩn mã, phân tích cú pháp tĩnh và quét lỗ hổng bảo mật bí mật (Secret Scanning).

3. **Giai đoạn 3 - Biên dịch và Đóng gói (Build & Package):**
   Biên dịch mã nguồn thành tệp thực thi, kéo các lớp Dockerfile và đóng gói thành Docker Image. Gắn tag định danh duy nhất (Semantic Version kết hợp mã băm Git Commit SHA) và đẩy lên Container Registry (Docker Hub, Harbor, AWS ECR).

4. **Giai đoạn 4 - Triển khai môi trường thử nghiệm (Deploy Staging):**
   Hệ thống tự động kích hoạt kịch bản điều phối (Ansible hoặc Helm/Kubernetes) để cập nhật phiên bản mới lên cụm máy chủ Staging – môi trường có cấu hình tương đồng 99% với Production.

5. **Giai đoạn 5 - Kiểm thử chấp nhận (Acceptance & E2E Testing):**
   Thực thi bộ kịch bản tự động mô phỏng hành vi người dùng cuối (Selenium, Cypress, Playwright), kiểm tra hiệu năng chịu tải và quét bảo mật động (DAST).

6. **Giai đoạn 6 - Triển khai môi trường sản xuất (Deploy Production) và Giám sát:**
   Sau khi vượt qua cổng phê duyệt, ứng dụng được phát hành lên Production theo các chiến lược không gián đoạn dịch vụ (Zero-downtime). Hệ thống giám sát (Prometheus, Grafana, ELK) thu thập log và độ trễ để tự động cảnh báo nếu tỷ lệ lỗi tăng cao.

---

## 1.8. Lợi ích vượt trội và các thách thức, hạn chế của CI/CD

### 1. Lợi ích vượt trội

- **Tần suất phát hành tăng vọt:** Rút ngắn thời gian đưa sản phẩm ra thị trường từ hàng tháng xuống còn hàng ngày hoặc hàng giờ.
- **Giảm thiểu rủi ro phát hành:** Thay vì gom một gói cập nhật khổng lồ chứa hàng trăm thay đổi gây mất kiểm soát, CI/CD khuyến khích phát hành các gói cập nhật siêu nhỏ (Micro-releases). Khi gói cập nhật nhỏ, việc xác định nguyên nhân gây lỗi và xử lý trở nên cực kỳ đơn giản.
- **Phục hồi sự cố tức thì (Fast Mean Time to Recovery - MTTR):** Nếu phát sinh lỗi trên môi trường sản xuất, cơ chế Rollback tự động hoặc quy trình phát hành bản vá nóng (Hotfix) chỉ mất vài phút để đưa hệ thống về trạng thái ổn định.
- **Nâng cao chất lượng mã nguồn:** Các tiêu chuẩn kỹ thuật, quy tắc format, độ phủ kiểm thử (Test Coverage) và tiêu chuẩn bảo mật được kiểm tra tự động và đồng bộ cho toàn bộ thành viên trong tổ chức.

### 2. Thách thức và hạn chế

- **Chi phí đầu tư ban đầu lớn:** Đòi hỏi thời gian và nguồn lực kỹ sư chuyên môn cao để thiết kế kiến trúc hạ tầng, viết kịch bản pipeline và cấu hình hệ thống máy chủ Runner.
- **Phụ thuộc tuyệt đối vào chất lượng kiểm thử:** Nếu đội ngũ phát triển viết bộ kiểm thử qua loa, không bao quát được các trường hợp biên (Edge cases), hệ thống CI/CD sẽ tự động triển khai mã lỗi lên Production với tốc độ nhanh hơn bao giờ hết ("Automating chaos").
- **Gánh nặng bảo trì hạ tầng:** Hạ tầng CI/CD Runner cần được bảo trì liên tục, quản lý bộ nhớ đệm (Cache), dọn dẹp các Docker Image cũ và giám sát tài nguyên để tránh nghẽn hàng đợi thực thi khi có nhiều kỹ sư cùng đẩy mã nguồn.
- **Nguy cơ bảo mật chuỗi cung ứng phần mềm:** Nếu máy chủ CI/CD hoặc các tài khoản truy cập bí mật (Secrets, SSH Keys) bị kẻ tấn công chiếm đoạt, chúng có thể cấy mã độc trực tiếp vào sản phẩm đóng gói và tự động triển khai mã độc lên toàn bộ hệ thống sản xuất.

---

# 2. Mục 2: CI/CD Pipeline

## 2.1. Khái niệm và kiến trúc tổng thể của CI/CD Pipeline

**CI/CD Pipeline** là một quy trình kỹ thuật được mô tả dưới dạng mã nguồn, bao gồm một chuỗi các bước tuần tự hoặc song song mà mã nguồn phần mềm bắt buộc phải đi qua để chuyển đổi từ trạng thái văn bản thuần sang sản phẩm hoàn chỉnh đang vận hành thực tế.

```text
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                                   CI/CD PIPELINE                                       │
│                                                                                        │
│   STAGE 1: BUILD       STAGE 2: TEST         STAGE 3: PACKAGE      STAGE 4: DEPLOY     │
│  ┌──────────────┐     ┌──────────────┐      ┌──────────────┐      ┌──────────────┐     │
│  │ Job: Compile │     │ Job: Unit    │      │ Job: Build   │      │ Job: Deploy  │     │
│  │     Source   │────>│     Test     │─────>│     Docker   │─────>│     Staging  │     │
│  └──────────────┘     ├──────────────┤      │     Image    │      ├──────────────┤     │
│                       │ Job: Lint    │      └──────────────┘      │ Job: Deploy  │     │
│                       │     Code     │                            │     Prod     │     │
│                       └──────────────┘                            └──────────────┘     │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 2.2. Các thành phần cốt lõi của Pipeline: Trigger, Stage, Job, Step

Mọi nền tảng CI/CD hiện đại (GitLab CI, GitHub Actions, Jenkins) đều được xây dựng dựa trên cấu trúc phân cấp 4 tầng cơ bản:

```text
PIPELINE
  └── STAGE 1 (Chặng: Build)
        ├── JOB A (Nhiệm vụ: Build Backend)
        │     ├── Step 1: Clone repo
        │     ├── Step 2: Cài đặt dependencies
        │     └── Step 3: Biên dịch nhị phân
        └── JOB B (Nhiệm vụ: Build Frontend)
              ├── Step 1: npm install
              └── Step 2: npm run build
  └── STAGE 2 (Chặng: Test)
        └── JOB C (Nhiệm vụ: Unit Test)
              └── Step 1: Chạy test runner
```

1. **Trigger (Bộ kích hoạt):** Sự kiện khởi tạo, đóng vai trò như phát súng lệnh yêu cầu Pipeline bắt đầu thực thi.
2. **Stage (Giai đoạn / Chặng):** Khối phân chia theo logic tiến trình thời gian. Các Stage thường chạy tuần tự (ví dụ: Stage `Build` chạy trước, thành công thì Stage `Test` mới được chạy).
3. **Job (Nhiệm vụ cụ thể):** Đơn vị công việc độc lập bên trong một Stage. Một Stage có thể chứa nhiều Job. Các Job trong cùng một Stage có thể được phân phối để **chạy song song** trên các Runner khác nhau nhằm rút ngắn thời gian.
4. **Step (Bước thực hiện):** Chuỗi các lệnh dòng lệnh (Shell Commands) hoặc các hành động được cấu hình tuần tự bên trong một Job duy nhất, cùng chia sẻ chung một hệ thống tệp và một môi trường thực thi.

---

## 2.3. Cơ chế kích hoạt Pipeline Trigger

Hệ thống CI/CD lắng nghe và phản ứng với nhiều loại sự kiện khác nhau:

- **Push Trigger:**
  Pipeline tự động chạy mỗi khi lập trình viên thực hiện `git push` lên một nhánh nhất định (thường là `main`, `master`, `develop` hoặc các nhánh `feature/*`).
- **Pull Request / Merge Request Trigger:**
  Pipeline kích hoạt khi có yêu cầu hợp nhất nhánh mới được mở hoặc cập nhật. Đây là chốt chặn quan trọng nhất để chạy kiểm thử trước khi quyết định gộp mã nguồn vào nhánh chính.
- **Manual Trigger (Kích hoạt thủ công):**
  Pipeline tạm dừng ở một công đoạn cụ thể và chờ người có thẩm quyền bấm nút xác nhận trên giao diện web (thường áp dụng cho thao tác Deploy Production).
- **Scheduled Trigger (Kích hoạt theo lịch trình định kỳ):**
  Sử dụng cú pháp định thời Cron (ví dụ `0 2 * * *` - chạy vào lúc 02:00 sáng hàng ngày) để thực hiện các bài kiểm tra toàn diện tốn nhiều thời gian như kiểm thử bảo mật tầng sâu, kiểm thử chịu tải hoặc sao lưu dữ liệu.
- **Tag Trigger:**
  Chỉ kích hoạt khi lập trình viên phát hành một thẻ phiên bản Git Tag mới (ví dụ `v1.0.0`, `v2.1.3`), thường dùng để kích hoạt luồng phát hành và đẩy Image chính thức lên Production Registry.
- **Webhook / API Trigger:**
  Được kích hoạt bởi một hệ thống bên thứ ba thông qua việc gửi yêu cầu HTTP POST tới URL Webhook của máy chủ CI/CD.

---

## 2.4. Source Code Management và vai trò trung tâm của Git

Hệ thống quản lý phiên bản mã nguồn phân tán (Distributed Version Control System) – tiêu biểu là **Git** – đóng vai trò là "Nguồn chân lý duy nhất" trong kiến trúc CI/CD:

```text
┌────────────────────────────────────────────────────────┐
│                     GIT REPOSITORY                     │
│  - Mã nguồn ứng dụng (Source Code)                     │
│  - Kịch bản Pipeline (compose.yaml, .gitlab-ci.yml)    │
│  - Kịch bản hạ tầng (Dockerfile, Ansible Playbooks)    │
│  - Mã băm phiên bản (Git Commit SHA, Tags)             │
└───────────────────────────┬────────────────────────────┘
                            │
                            │ Webhook Notification
                            ▼
┌────────────────────────────────────────────────────────┐
│                     CI/CD RUNNER                       │
│  - Kéo chính xác mã nguồn tại Git Commit SHA đó        │
│  - Đảm bảo tính nhất quán và khả năng tái lập 100%     │
└────────────────────────────────────────────────────────┘
```

### Vai trò cốt lõi của Git trong CI/CD:
1. **Định danh phiên bản bất biến:** Mỗi lần chạy Pipeline đều gắn liền với một mã băm duy nhất (Git Commit SHA 40 ký tự). Điều này đảm bảo tính tái lập: Ta có thể dễ dàng kiểm tra lại chính xác phiên bản mã nguồn nào đã tạo ra bản cài đặt đang chạy trên Production vào bất kỳ thời điểm nào trong quá khứ.
2. **Khai báo hạ tầng thành mã:** Bản thân tệp cấu hình Pipeline (như `.gitlab-ci.yml`, `Jenkinsfile`, `.github/workflows/main.yml`) được lưu trữ và theo dõi phiên bản ngay bên trong kho mã nguồn Git cùng với mã ứng dụng. Mọi chỉnh sửa về quy trình triển khai đều phải qua quy trình xét duyệt mã (Code Review) như mã nguồn bình thường.
3. **Mô hình phân nhánh:** Các mô hình như GitFlow hay Trunk-Based Development định hình trực tiếp hành vi của Pipeline: Nhánh `feature` chỉ chạy kiểm tra và build; nhánh `main` tự động triển khai lên Staging; gắn `tag` sẽ phát hành lên Production.

---

## 2.5. Tự động hóa biên dịch và Kiểm thử tự động

### 1. Tự động hóa biên dịch (Build Automation)
- Tự động phát hiện và tải về các gói thư viện phụ thuộc từ các kho chứa công cộng hoặc nội bộ (npm, Maven, Gradle, PyPI, Go Modules).
- Biên dịch mã nguồn bậc cao thành mã nhị phân thực thi, bytecode hoặc tối ưu hóa đóng gói các tệp giao diện (minification, uglify JavaScript/CSS, bundling Webpack/Vite).
- Sử dụng cơ chế lưu trữ đệm (Caching) thông minh giữa các lần chạy Pipeline để không phải tải lại các thư viện chưa có sự thay đổi, giúp rút ngắn thời gian build từ hàng chục phút xuống còn vài chục giây.

### 2. Kim tự tháp kiểm thử tự động (Automated Test Pyramid)
Một hệ thống CI/CD chuẩn mực áp dụng mô hình kim tự tháp kiểm thử để cân đối giữa tốc độ thực thi và mức độ tin cậy:

```text
                  /\
                 /  \      E2E Tests (Giao diện, chậm nhất, chi phí cao, số lượng ít)
                /────\
               /      \    Integration Tests (Kiểm thử tích hợp DB, API, Service)
              /────────\
             /          \  Unit Tests (Kiểm thử đơn vị, siêu nhanh, chạy mọi lúc, số lượng lớn)
            /────────────\
```

- **Unit Testing (Kiểm thử đơn vị):** Kiểm tra tính đúng đắn của từng hàm, phương thức độc lập. Được thực thi đầu tiên trong Pipeline vì tốc độ tính bằng mili-giây.
- **Integration Testing (Kiểm thử tích hợp):** Kiểm tra sự tương tác giữa các module với nhau hoặc giữa ứng dụng với cơ sở dữ liệu thật (thường sử dụng Docker container tạm thời để làm mock database).
- **End-to-End Testing (Kiểm thử đầu cuối):** Mô phỏng toàn bộ luồng trải nghiệm của người dùng thực tế từ giao diện trình duyệt web đến cơ sở dữ liệu backend.

---

## 2.6. Quản lý sản phẩm đóng gói: Artifact và Artifact Management

### 1. Artifact là gì?
**Artifact** là sản phẩm đầu ra hoàn chỉnh được tạo ra sau giai đoạn biên dịch và đóng gói thành công của một Pipeline. Artifact có thể là:
- Các tệp nhị phân nén: `.jar`, `.war`, `.zip`, `.tar.gz`.
- Các gói phần mềm cài đặt: `.deb`, `.rpm`, `.exe`.
- Các gói thư viện mã nguồn nội bộ: gói npm, gói Python wheel, gói thư viện NuGet.
- **Đặc biệt phổ biến nhất hiện nay:** **Docker Image** chứa toàn bộ môi trường và mã nguồn sẵn sàng chạy.

### 2. Nguyên tắc vàng của Artifact: "Build Once, Deploy Anywhere"
Một trong những nguyên tắc cốt lõi của CI/CD là: **Một Artifact chỉ được biên dịch một lần duy nhất ở đầu Pipeline**.
Tuyệt đối không thực hiện hành vi biên dịch lại mã nguồn khi chuyển từ môi trường Staging sang Production. Cùng một Docker Image hoặc tệp nhị phân duy nhất đó phải được sử dụng xuyên suốt để triển khai lên Dev, Staging và Production; sự khác biệt duy nhất giữa các môi trường chỉ là việc nạp các **Biến môi trường cấu hình khác nhau**.

### 3. Hệ thống quản lý kho lưu trữ Artifact (Artifact Repository)
Các hệ thống chuyên dụng được thiết lập để lưu trữ và quản lý phiên bản của các Artifact:
- Kho chứa Docker Image: Docker Hub, Harbor (mã nguồn mở tự triển khai), AWS ECR, Google Artifact Registry.
- Kho chứa tệp nhị phân tổng hợp: JFrog Artifactory, Sonatype Nexus.

---

## 2.7. Quản lý biến môi trường và cấu hình hệ thống

Theo nguyên lý kiến trúc ứng dụng hiện đại **The Twelve-Factor App**, toàn bộ cấu hình hệ thống có khả năng thay đổi giữa các môi trường triển khai bắt buộc phải được tách rời khỏi mã nguồn và nạp thông qua **Biến môi trường (Environment Variables)**:

- **Biến môi trường thông thường:** Cổng dịch vụ lắng nghe (`PORT=8080`), tên dịch vụ (`APP_NAME=ecommerce`), chế độ log (`LOG_LEVEL=debug`), tên cơ sở dữ liệu (`DB_NAME=app_db`).
- **Thông tin cấu hình nhạy cảm (Secrets):** Mật khẩu cơ sở dữ liệu, mã khóa bảo mật JWT Secret, khóa API thanh toán, chứng chỉ bảo mật SSL/TLS, khóa bí mật SSH Private Key.

### Quản lý Secrets trong CI/CD:
- Tuyệt đối không lưu trữ khóa bí mật trong mã nguồn hoặc tệp cấu hình Pipeline được đẩy lên Git.
- Các nền tảng CI/CD cung cấp tính năng **CI/CD Variables / Secret Management** cho phép mã hóa dữ liệu bí mật trong cơ sở dữ liệu của máy chủ CI, tự động ẩn nội dung bí mật trên màn hình hiển thị log (Masked Variables), và chỉ truyền vào môi trường thực thi của Runner tại thời điểm chạy job.
- Trong các hệ sinh thái lớn, CI/CD được tích hợp với các máy chủ quản lý khóa chuyên nghiệp như HashiCorp Vault hoặc AWS Secrets Manager.

---

## 2.8. Quản lý các môi trường Development, Staging và Production

Một hệ thống ứng dụng chuyên nghiệp phân tách hạ tầng thành ít nhất ba tầng môi trường độc lập:

```text
┌──────────────────┐        ┌──────────────────┐        ┌──────────────────┐
│   DEVELOPMENT    │ ─────> │     STAGING      │ ─────> │    PRODUCTION    │
│  (Môi trường Dev)│        │ (Môi trường Test)│        │ (Môi trường Thật)│
├──────────────────┤        ├──────────────────┤        ├──────────────────┤
│ - Dành cho dev   │        │ - Bản sao Prod   │        │ - Phục vụ khách  │
│ - Tự do thử ngiệm│        │ - Dữ liệu ẩn danh│        │ - Ổn định tối đa │
│ - Cho phép lỗi   │        │ - Kiểm thử E2E   │        │ - Không downtime │
└──────────────────┘        └──────────────────┘        └──────────────────┘
```

1. **Môi trường Development (Dev):**
   - Nơi các lập trình viên triển khai liên tục các nhánh tính năng để kiểm tra tích hợp sơ bộ.
   - Cho phép hệ thống có thể gặp lỗi và khởi động lại thường xuyên.
2. **Môi trường Staging (Pre-production):**
   - Là bản sao giống hệt 99% với môi trường Production thật về cấu hình máy chủ, phiên bản cơ sở dữ liệu và kiến trúc mạng.
   - Sử dụng bộ dữ liệu giả lập được ẩn danh hóa từ Production.
   - Nơi đội ngũ đảm bảo chất lượng (QA) thực hiện các vòng kiểm thử cuối cùng và khách hàng nghiệm thu sản phẩm (User Acceptance Testing - UAT).
3. **Môi trường Production (Prod):**
   - Môi trường phục vụ trực tiếp người dùng cuối thật và trực tiếp mang lại giá trị kinh doanh cho doanh nghiệp.
   - Đòi hỏi tính ổn định tối đa (99.99% Uptime), cơ chế giám sát 24/7 và mọi hoạt động cập nhật phải đảm bảo không gây gián đoạn dịch vụ (Zero-downtime).

---

## 2.9. Các chiến lược triển khai: Rolling Update, Blue-Green, Canary

Khi đưa phiên bản mới lên môi trường Production, việc tắt toàn bộ hệ thống cũ đi rồi mới bật hệ thống mới lên sẽ gây ra thời gian chết (Downtime) làm gián đoạn người dùng. CI/CD hiện đại áp dụng ba chiến lược triển khai không gián đoạn dịch vụ tiêu chuẩn:

### 1. Rolling Update (Cập nhật cuốn chiếu)
- **Cơ chế:** Thay thế dần dần từng máy chủ hoặc từng container từ phiên bản cũ (v1) sang phiên bản mới (v2) theo từng nhóm nhỏ.
- **Quy trình:**
  - Hệ thống đang chạy 4 container v1.
  - Tắt 1 container v1, khởi tạo 1 container v2. Đợi v2 khỏe mạnh thì chuyển tiếp lưu lượng vào v2.
  - Tiếp tục lặp lại tuần tự cho các container còn lại cho đến khi toàn bộ 4 container đều chạy bản v2.
- **Ưu điểm:** Tiết kiệm tài nguyên hạ tầng, không cần chuẩn bị máy chủ phụ.
- **Nhược điểm:** Trong quá trình cập nhật, cả hai phiên bản v1 và v2 cùng tồn tại song song, đòi hỏi cơ sở dữ liệu phải tương thích ngược (Backward Compatibility).

```text
Trạng thái 1: [v1] [v1] [v1] [v1]
Trạng thái 2: [v2] [v1] [v1] [v1]  <-- Đang thay thế 1 máy
Trạng thái 3: [v2] [v2] [v1] [v1]  <-- Cả 2 bản cùng chạy
Trạng thái 4: [v2] [v2] [v2] [v2]  <-- Hoàn tất cập nhật
```

### 2. Blue-Green Deployment (Triển khai Xanh - Lam)
- **Cơ chế:** Thiết lập hai môi trường sản xuất độc lập có quy mô phần cứng giống hệt nhau:
  - Môi trường Blue: Đang chạy phiên bản hiện tại (v1) và tiếp nhận 100% lưu lượng người dùng thật.
  - Môi trường Green: Môi trường nhàn rỗi, dùng để triển khai phiên bản mới (v2).
- **Quy trình:**
  - Kỹ sư triển khai bản v2 lên môi trường Green và thực hiện mọi bài kiểm thử nội bộ an toàn.
  - Khi đã đảm bảo mọi thứ hoàn hảo, điều chỉnh bộ cân bằng tải (Router / Load Balancer) để **chuyển hướng 100% lưu lượng người dùng từ Blue sang Green ngay lập tức**.
  - Môi trường Blue bây giờ trở thành môi trường dự phòng.
- **Ưu điểm:** Chuyển đổi trạng thái tức thì không có downtime; nếu phát sinh sự cố, có thể gạt công tắc chuyển lưu lượng ngược lại về Blue trong vòng vài giây.
- **Nhược điểm:** Tốn kém gấp đôi chi phí tài nguyên phần cứng máy chủ.

```text
              ┌──────────────┐
              │ BỘ CÂN BẰNG  │
              │   TẢI (LB)   │
              └──────┬───────┘
                     │ (Gạt công tắc chuyển hướng 100% lưu lượng)
       ┌─────────────┴─────────────┐
       ▼                           ▼
┌──────────────┐            ┌──────────────┐
│     BLUE     │            │    GREEN     │
│ (Bản cũ: v1) │            │ (Bản mới: v2)│
└──────────────┘            └──────────────┘
```

### 3. Canary Deployment (Triển khai chim báo bão)
- **Cơ chế:** Lấy cảm hứng từ phương pháp xưa của thợ mỏ mang theo chim hoàng yến vào hầm lò để phát hiện khí độc trước. Phiên bản mới (v2) ban đầu chỉ được phát hành cho một **tỷ lệ phần trăm người dùng cực nhỏ** (ví dụ 5% hoặc 10%) để thăm dò.
- **Quy trình:**
  - 95% người dùng vẫn truy cập phiên bản cũ v1; 5% người dùng được điều hướng sang bản v2.
  - Hệ thống giám sát theo dõi sát sao tỷ lệ lỗi, độ trễ và mức độ tiêu thụ tài nguyên của bản v2 trong vài giờ.
  - Nếu bản v2 hoạt động ổn định và không phát sinh lỗi, tỷ lệ lưu lượng sẽ được nâng dần lên 25%, 50%, 75% và cuối cùng là 100%.
  - Nếu phát hiện lỗi gia tăng, 5% lưu lượng đó lập tức bị ngắt bỏ, hạn chế phạm vi ảnh hưởng chỉ xảy ra với một nhóm rất nhỏ người dùng.
- **Ưu điểm:** Mức độ an toàn rủi ro cao nhất đối với các hệ thống quy mô hàng triệu người dùng.
- **Nhược điểm:** Kiến trúc định tuyến phân luồng mạng phức tạp.

```text
Lưu lượng khách hàng: 100%
         │
         ├─── 95% lưu lượng ───► [ Cụm máy chủ v1 (Ổn định) ]
         │
         └───  5% lưu lượng ───► [ Máy chủ Canary v2 (Thử nghiệm) ]
```

---

## 2.10. Cơ chế Rollback và Quản lý phát hành

### 1. Cơ chế Rollback (Khôi phục trạng thái cũ)
Trong kỹ thuật phần mềm, việc phát sinh sự cố là điều không thể tránh khỏi hoàn toàn. Một Pipeline CI/CD đạt chuẩn bắt buộc phải có giải pháp **Rollback tự động hoặc chỉ với một cú nhấp chuột**:
- **Rollback cấp độ Code (Git Revert):** Tạo một commit mới đảo ngược lại toàn bộ thay đổi của commit lỗi và đẩy vào nhánh chính để kích hoạt lại pipeline triển khai bản vá.
- **Rollback cấp độ Artifact / Image:** Chỉ định trực tiếp bộ điều phối (Kubernetes / Docker Compose) kéo và khởi chạy lại thẻ Image ổn định liền kề trước đó.
- **Rollback cấp độ Network:** Chuyển hướng lưu lượng của Load Balancer về lại cụm máy chủ cũ (như trong mô hình Blue-Green).

### 2. Quản lý phát hành (Release Management)
- **Đánh số phiên bản theo ngữ nghĩa (Semantic Versioning - SemVer):**
  Quy chuẩn đặt tên phiên bản theo định dạng `MAJOR.MINOR.PATCH` (Ví dụ `v2.4.1`):
  - `MAJOR`: Thay đổi lớn phá vỡ tính tương thích ngược với phiên bản trước.
  - `MINOR`: Thêm tính năng mới nhưng vẫn bảo đảm tương thích ngược.
  - `PATCH`: Bản sửa lỗi nhỏ và vá bảo mật.
- **Nhật ký thay đổi (Changelog):** Tự động tạo danh sách tóm tắt các tính năng mới và danh sách bug đã xử lý dựa trên thông điệp các commit Git giữa hai phiên bản phát hành.

---

# 3. Mục 3: Tổng quan về các nền tảng CI/CD

## 3.1. Các nền tảng CI/CD phổ biến: GitLab CI/CD, Jenkins, GitHub Actions

Trên thị trường công nghệ hiện nay, có ba nền tảng CI/CD thống trị và được ứng dụng rộng rãi nhất trong các doanh nghiệp:

```text
┌────────────────────────────────────────────────────────────────────────┐
│                      BA NỀN TẢNG CI/CD PHỔ BIẾN NHẤT                   │
├─────────────────────┬──────────────────────┬───────────────────────────┤
│    JENKINS          │    GITLAB CI/CD      │     GITHUB ACTIONS        │
│ (Kỳ cựu, Linh hoạt, │ (Hợp nhất toàn diện, │ (Tích hợp sâu đám mây,    │
│  Hệ sinh thái rộng) │  Chuẩn mực DevOps)   │  Chợ Marketplace khổng lồ)│
└─────────────────────┴──────────────────────┴───────────────────────────┘
```

1. **Jenkins:**
   - Ra đời sớm nhất (từ năm 2011, tiền thân là Hudson), được viết bằng ngôn ngữ Java.
   - Là một công cụ tự động hóa mã nguồn mở hoàn toàn miễn phí, tự quản lý và cài đặt trên hạ tầng riêng của doanh nghiệp.
   - Điểm mạnh nhất: Hệ sinh thái hơn 1,800 plugin mở rộng, cho phép kết nối với hầu như mọi công cụ công nghệ từng tồn tại trong ngành IT.
2. **GitLab CI/CD:**
   - Thành phần CI/CD được tích hợp sẵn hoàn toàn bên trong nền tảng GitLab (GitLab là giải pháp tất-cả-trong-một bao gồm Git repository, Issue tracking, CI/CD, Container Registry, Security scanning).
   - Sử dụng cú pháp khai báo bằng tệp `.gitlab-ci.yml` cực kỳ trực quan, mạch lạc và hiện đại.
   - Rất phổ biến trong các doanh nghiệp vừa và lớn muốn tự vận hành hệ thống máy chủ mã nguồn nội bộ (On-premises Self-managed).
3. **GitHub Actions:**
   - Nền tảng tự động hóa mạnh mẽ được tích hợp trực tiếp vào dịch vụ lưu trữ mã nguồn lớn nhất hành tinh GitHub (thuộc sở hữu của Microsoft).
   - Sử dụng cú pháp tệp YAML đặt trong thư mục `.github/workflows/`.
   - Sở hữu chợ ứng dụng GitHub Marketplace với hàng chục ngàn hành động (Actions) được cộng đồng toàn cầu viết sẵn, giúp việc thiết lập Pipeline diễn ra cực kỳ nhanh chóng chỉ bằng cách ghép nối các khối có sẵn.

---

## 3.2. Kiến trúc và cơ chế vận hành nội bộ của từng nền tảng

Mặc dù có giao diện và cách cấu hình khác nhau, cả ba nền tảng đều hoạt động theo mô hình kiến trúc phân tán **Điều phối trung tâm - Công nhân thực thi (Master - Worker / Server - Agent Architecture)**:

```text
┌────────────────────────────────────────────────────────────────────────┐
│                   BỘ ĐIỀU PHỐI TRUNG TÂM (CONTROLLER / SERVER)         │
│  - Jenkins Controller / GitLab Server / GitHub Webhooks                │
│  - Quản lý giao diện, tài khoản, lịch trình, cấu hình Pipeline         │
│  - Phân bổ các Job cần chạy vào hàng đợi (Queue)                       │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                   Kết nối thông qua: SSH / gRPC / HTTPS Poll
                                    │
         ┌──────────────────────────┴──────────────────────────┐
         ▼                                                     ▼
┌─────────────────────────────────┐   ┌─────────────────────────────────┐
│     RUNNER / AGENT 1 (Node A)   │   │     RUNNER / AGENT 2 (Node B)   │
│  - Kéo Job từ Controller        │   │  - Kéo Job từ Controller        │
│  - Chạy lệnh trong Container    │   │  - Biên dịch và chạy kiểm thử   │
│  - Trả kết quả và log về Server │   │  - Trả kết quả và log về Server │
└─────────────────────────────────┘   └─────────────────────────────────┘
```

### 1. Kiến trúc của Jenkins: Controller - Agent
- **Jenkins Controller (Master):** Lưu trữ cấu hình toàn hệ thống, cài đặt plugin, hiển thị bảng điều khiển web và điều phối việc giao việc. Controller **không nên chạy các tác vụ build nặng** để tránh làm treo giao diện.
- **Jenkins Agent (Node):** Các máy chủ Linux, Windows hoặc cụm Kubernetes chạy dịch vụ Java Agent kết nối về Controller. Agent nhận lệnh, tải mã nguồn, thực thi các bước trong `Jenkinsfile` và truyền luồng log trực tiếp về Controller hiển thị cho người dùng.

### 2. Kiến trúc của GitLab CI/CD: GitLab Server - GitLab Runner
- **GitLab Server:** Quản lý kho Git, theo dõi tệp `.gitlab-ci.yml`, quản lý việc phân quyền và lưu trữ trạng thái Pipeline.
- **GitLab Runner:** Một chương trình độc lập được viết bằng ngôn ngữ Go siêu nhẹ. Runner có thể được cài đặt trên bất kỳ máy chủ nào và đăng ký kết nối về GitLab Server thông qua một mã xác thực (Registration Token). Runner liên tục thăm dò (Poll) Server qua giao thức HTTPS để lấy Job mới về thực thi.

### 3. Kiến trúc của GitHub Actions: Orchestrator - Runner
- **GitHub Orchestrator:** Dịch vụ đám mây toàn cầu của GitHub tiếp nhận sự kiện Webhook, đọc tệp workflow YAML và điều phối việc sinh ra các phiên máy ảo thực thi.
- **GitHub Runner:** Ứng dụng mã nguồn mở lắng nghe các nhiệm vụ được chỉ định và thực thi từng bước công việc.

---

## 3.3. Runner, Agent và Môi trường thực thi

**Runner (hoặc Agent)** là môi trường máy tính vật lý, máy ảo hoặc container thực tế nơi các dòng lệnh trong kịch bản CI/CD được thực thi.

### Các loại môi trường thực thi (Executors) của Runner:
1. **Shell Executor (Chạy trực tiếp trên Host):**
   - Runner thực thi các câu lệnh shell trực tiếp trên hệ điều hành của máy chủ cài Runner.
   - **Ưu điểm:** Tốc độ nhanh nhất vì không tốn chi phí khởi tạo ảo hóa.
   - **Nhược điểm nghiêm trọng:** Rác môi trường và xung đột phiên bản. Nếu Job A cài đặt Node.js 16 và Job B yêu cầu Node.js 20, hai Job sẽ xung đột nhau. Kém an toàn vì lệnh có quyền truy cập trực tiếp vào hệ thống tệp của máy chủ Runner.
2. **Docker Executor (Chuẩn mực phổ biến nhất):**
   - Mỗi Job khi bắt đầu chạy sẽ được Runner khởi tạo một container hoàn toàn mới và sạch sẽ từ Docker Image được chỉ định trong cấu hình (ví dụ: `image: maven:3.9-eclipse-temurin-17`).
   - Mọi thao tác biên dịch, kiểm thử đều diễn ra hoàn toàn bên trong container này.
   - Sau khi Job kết thúc, container lập tức bị tiêu hủy sạch sẽ.
   - **Ưu điểm:** Cách ly môi trường tuyệt đối, tính tái lập 100%, không bao giờ lo xung đột phiên bản giữa các dự án khác nhau.
3. **Kubernetes Executor (Tối ưu cho quy mô lớn):**
   - Khi có Job mới, Runner kết nối tới API của cụm Kubernetes để sinh ra một Pod tạm thời làm nhiệm vụ thực thi Job.
   - Cực kỳ mạnh mẽ cho các doanh nghiệp lớn vì khả năng co giãn đàn hồi tài nguyên tự động (Auto-scaling): Ban ngày có thể mở rộng lên hàng trăm Pod để phục vụ đội ngũ phát triển, ban đêm tự động hạ xuống về 0 để tiết kiệm chi phí.

---

## 3.4. Phân biệt Hosted Runner và Self-hosted Runner

Khi triển khai CI/CD trên nền tảng đám mây (GitLab.com, GitHub.com), doanh nghiệp có hai lựa chọn triển khai hệ thống Runner:

```text
┌─────────────────────────────────────────────────────────────────────────┐
│              HOSTED RUNNER VS SELF-HOSTED RUNNER                        │
├────────────────────────────────────┬────────────────────────────────────┤
│ HOSTED RUNNER (Cloud-managed)      │ SELF-HOSTED RUNNER (On-premises)   │
│ - Máy chủ do GitHub/GitLab cấp sẵn │ - Máy chủ do doanh nghiệp tự mua   │
│ - Hoàn toàn không cần bảo trì      │ - Tự cài đặt, quản trị, bảo mật    │
│ - Môi trường tạm thời, dùng xong bỏ│ - Tận dụng phần cứng mạnh có sẵn   │
│ - Trả tiền theo số phút sử dụng    │ - Truy cập trực tiếp mạng nội bộ   │
└────────────────────────────────────┴────────────────────────────────────┘
```

### Bảng đối chiếu so sánh chi tiết

| Tiêu chí | Hosted Runner (Cloud-managed) | Self-hosted Runner (Doanh nghiệp tự quản) |
| :--- | :--- | :--- |
| **Bản chất hạ tầng** | Máy ảo được cấp phát tức thời trên đám mây của nhà cung cấp (AWS/Azure/GCP). | Máy chủ vật lý, máy ảo hoặc cụm Kubernetes đặt tại Data Center của công ty. |
| **Công sức quản trị** | **Bằng 0:** Nhà cung cấp tự động cập nhật hệ điều hành, bảo mật và dọn dẹp đĩa. | **Cao:** Doanh nghiệp phải tự lo cập nhật hệ thống, giám sát tài nguyên và bảo mật. |
| **Khả năng truy cập mạng** | Không thể truy cập trực tiếp vào mạng nội bộ Private LAN của doanh nghiệp (phải mở VPN). | **Tuyệt vời:** Nằm sẵn trong mạng nội bộ, dễ dàng triển khai vào cơ sở dữ liệu và máy chủ nội bộ. |
| **Hiệu năng & Tài nguyên** | Bị giới hạn cấu hình phần cứng mặc định (thường là 2 vCPU, 7GB RAM). | **Không giới hạn:** Doanh nghiệp có thể tự trang bị máy chủ 64 vCPU, 256GB RAM, card đồ họa GPU. |
| **Chi phí vận hành** | Miễn phí định mức cơ bản, tính phí theo từng phút sử dụng vượt mức. | Chi phí cố định cho phần cứng và tiền điện mạng, không tính tiền theo phút chạy. |
| **Tính an toàn bảo mật** | Dữ liệu mã nguồn phải chuyển ra máy chủ của nhà cung cấp đám mây. | Mã nguồn và dữ liệu kiểm thử được giữ an toàn 100% bên trong bức tường lửa của doanh nghiệp. |

---

## 3.5. Quản lý thông tin xác thực, Biến số và Bí mật an toàn

Một trong những nguyên nhân hàng đầu dẫn đến các vụ rò rỉ dữ liệu nghiêm trọng trong doanh nghiệp là việc lập trình viên để lộ thông tin tài khoản quản trị (Credentials) hoặc khóa bảo mật (API Keys, SSH Keys) trực tiếp bên trong mã nguồn Git.

### Các nguyên tắc quản trị bảo mật thông tin xác thực trong CI/CD:
1. **Nguyên tắc phân quyền tối thiểu (Principle of Least Privilege):**
   Mỗi Token hoặc SSH Key được cấp cho CI/CD Runner chỉ nên có quyền thực hiện đúng các thao tác cần thiết (ví dụ: chỉ cấp quyền đẩy ảnh vào thư mục repository cụ thể, không cấp quyền quản trị toàn bộ hệ thống Registry).
2. **Ẩn dữ liệu nhạy cảm trong luồng Log (Log Masking):**
   Các hệ thống CI/CD có cơ chế tự động quét luồng dữ liệu xuất ra màn hình console; nếu phát hiện giá trị trùng khớp với các biến Secret đã khai báo, hệ thống sẽ tự động thay thế bằng chuỗi ký tự `[MASKED]` hoặc `***` để ngăn ngừa việc vô tình in mật khẩu ra log công khai.
3. **Phân vùng phạm vi biến bảo mật (Scoped Variables):**
   - Chỉ truyền các biến bảo mật môi trường Production (như SSH Key máy chủ thật) vào các Pipeline chạy trên các nhánh được bảo vệ nghiêm ngặt (Protected Branches như `main`) hoặc các thẻ được bảo vệ (Protected Tags).
   - Ngăn chặn triệt để tình trạng một lập trình viên tạo một nhánh phụ tùy tiện rồi viết lệnh in các biến mật khẩu của Production ra màn hình.
4. **Vòng đời ngắn hạn của Token (Short-lived Tokens và OIDC):**
   Thay vì dùng các khóa bí mật tĩnh có hạn sử dụng vĩnh viễn, xu hướng hiện đại sử dụng giao thức OpenID Connect (OIDC) để máy chủ CI/CD tự động thỏa thuận lấy các Token tạm thời có hạn dùng chỉ trong vài phút từ các nhà cung cấp đám mây (AWS, GCP, Azure).

---

## 3.6. So sánh đối đầu toàn diện: GitLab CI/CD vs Jenkins vs GitHub Actions

### Bảng phân tích đa chiều

| Tiêu chí so sánh | Jenkins | GitLab CI/CD | GitHub Actions |
| :--- | :--- | :--- | :--- |
| **Năm ra đời** | 2011 (Kỳ cựu nhất) | 2015 | 2019 (Hiện đại nhất) |
| **Ngôn ngữ phát triển** | Java | Ruby và Go | Go và TypeScript |
| **Cú pháp định nghĩa Pipeline** | Groovy Script (`Jenkinsfile` Declarative hoặc Scripted) | YAML (`.gitlab-ci.yml`) | YAML (`.github/workflows/*.yml`) |
| **Mức độ tích hợp Git** | Tách rời hoàn toàn, phải kết nối qua Plugin và Webhook. | Tích hợp sâu sẵn có, nằm chung trong một giao diện duy nhất với Git. | Tích hợp sâu sẵn có, nằm chung trong một giao diện duy nhất với GitHub. |
| **Cài đặt và thiết lập ban đầu** | Phức tạp, tốn nhiều thời gian cấu hình máy chủ, Java, Plugin. | Rất nhanh chóng, có sẵn ngay khi cài đặt GitLab Server. | Cực nhanh, kích hoạt và sử dụng ngay lập tức trên nền tảng đám mây. |
| **Hệ sinh thái mở rộng** | Rất đồ sộ với hơn 1,800 Plugins bên thứ ba. | Tích hợp sẵn gần như mọi tính năng, ít phụ thuộc plugin ngoài. | Khổng lồ với hàng chục ngàn Actions trên GitHub Marketplace. |
| **Môi trường Runner mặc định** | Cần tự dựng và cấu hình Agent thủ công. | Hỗ trợ cả Shared Runner đám mây và Self-hosted Runner. | Miễn phí định mức hàng tháng máy ảo GitHub-hosted Runner. |
| **Giao diện người dùng (UI/UX)** | Cổ điển, phân mảnh, cần cài theme Blue Ocean để cải thiện. | Hiện đại, trực quan, sơ đồ đường ống Pipeline rất đẹp và rõ ràng. | Rất hiện đại, giao diện trực quan gắn liền với từng commit và Pull Request. |
| **Bảo trì và nâng cấp** | Rất vất vả vì thường xuyên xảy ra xung đột tương thích giữa các phiên bản plugin. | Đơn giản vì nâng cấp gói phần mềm GitLab duy nhất là cập nhật toàn bộ hệ thống. | Không cần bận tâm vì nhà cung cấp Microsoft tự vận hành hạ tầng. |
| **Trường hợp sử dụng tối ưu** | Các hệ thống cũ, hệ thống có quy trình logic tùy biến kỳ dị, doanh nghiệp tự chủ 100% hạ tầng nội bộ. | Doanh nghiệp muốn sở hữu nền tảng DevOps trọn gói, bảo mật nội bộ và quản trị tập trung. | Các dự án mã nguồn mở, startup, doanh nghiệp lưu trữ mã nguồn trực tiếp trên GitHub. |

---

# PHẦN 2: TỔNG QUAN VỀ ANSIBLE

# 4. Mục 4: Giới thiệu về Ansible

## 4.1. Khái niệm Quản trị cấu hình (Configuration Management)

Trong kỷ nguyên điện toán đám mây và hạ tầng quy mô lớn, một hệ thống doanh nghiệp thường bao gồm hàng chục, hàng trăm, thậm chí hàng ngàn máy chủ ảo hóa (VM) hoặc máy chủ vật lý. Mỗi máy chủ cần phải được cài đặt hệ điều hành, phân quyền người dùng, mở cổng tường lửa, cập nhật bản vá bảo mật và cài đặt các phần mềm dịch vụ (Nginx, MySQL, Redis, Docker).

### Thách thức khi quản trị thủ công:
- **Sai lệch cấu hình (Configuration Drift):** Theo thời gian, việc các kỹ sư hệ thống đăng nhập SSH trực tiếp vào từng máy chủ để gõ lệnh sửa lỗi đột xuất làm cho trạng thái thực tế của các máy chủ không còn giống nhau, gây khó khăn cho việc gỡ lỗi.
- **Tốn kém thời gian và dễ sai sót:** Việc lặp đi lặp lại thao tác cấu hình thủ công trên 50 máy chủ mất nhiều ngày làm việc và chỉ cần một dòng cấu hình sai lệch có thể dẫn đến sự cố sập toàn bộ cụm dịch vụ.
- **Không có khả năng lưu vết phiên bản:** Không thể biết ai đã thay đổi tệp tin cấu hình nào, vào thời điểm nào và với mục đích gì.

**Quản trị cấu hình (Configuration Management - CM)** là phương pháp luận và kỹ thuật tự động hóa nhằm duy trì trạng thái mong muốn của hệ thống máy tính một cách nhất quán, có thể kiểm toán và có khả năng tái lập trong suốt vòng đời của hệ thống. 

Quản trị cấu hình biến cơ sở hạ tầng thành mã (Infrastructure as Code - IaC), cho phép lưu trữ toàn bộ trạng thái cấu hình của hệ thống vào các tệp tin văn bản thuần và quản lý lịch sử thay đổi thông qua Git.

```text
┌────────────────────────────────────────────────────────┐
│              TRẠNG THÁI MONG MUỐN (DESIRED STATE)      │
│  - Nginx phiên bản 1.24 đang chạy và bật tự khởi động  │
│  - Tệp cấu hình /etc/nginx/nginx.conf có nội dung X    │
│  - Cổng tường lửa 80 và 443 đang mở                    │
└───────────────────────────┬────────────────────────────┘
                            │
                            │ Ansible thực thi tự động
                            ▼
┌────────────────────────────────────────────────────────┐
│              TRẠNG THÁI THỰC TẾ (ACTUAL STATE)         │
│  Tất cả 100 máy chủ đích đều đạt chính xác trạng thái  │
│  mong muốn mà không cần kỹ sư đăng nhập thủ công       │
└────────────────────────────────────────────────────────┘
```

---

## 4.2. Ansible là gì và Vai trò cốt lõi trong DevOps

**Ansible** là một nền tảng mã nguồn mở hàng đầu thế giới được phát triển ban đầu bởi Michael DeHaan vào năm 2012 và được Red Hat mua lại vào năm 2015. Ansible được viết bằng ngôn ngữ **Python** và sử dụng cú pháp **YAML** để mô tả các kịch bản tự động hóa.

### Đặc tính cốt lõi của Ansible:
1. **Kiến trúc không cần Agent (Agentless):**
   Khác với các công cụ quản trị cấu hình truyền thống như Puppet, Chef hay SaltStack vốn yêu cầu phải cài đặt một phần mềm dịch vụ ngầm (Agent) trên từng máy chủ đích và mở cổng giao tiếp riêng, Ansible **hoàn toàn không yêu cầu bất kỳ phần mềm nào trên máy đích ngoại trừ dịch vụ SSH tiêu chuẩn và trình thông dịch Python**.
2. **Tính lũy thừa / Bất biến trạng thái (Idempotency):**
   Đây là tính chất kỹ thuật quan trọng nhất của Ansible. Một kịch bản Ansible khi chạy một lần hay chạy lặp lại 1,000 lần trên cùng một máy chủ đều cho ra **chính xác cùng một kết quả duy nhất**. Nếu tài nguyên đã nằm ở trạng thái mong muốn (ví dụ gói phần mềm đã được cài đặt đúng phiên bản), Ansible sẽ tự động bỏ qua (trạng thái `ok`) và không thực hiện bất kỳ hành động thừa thãi nào, đảm bảo không làm gián đoạn dịch vụ đang chạy.
3. **Ngôn ngữ dễ đọc hiểu (Human-readable):**
   Toàn bộ kịch bản tự động hóa của Ansible được viết bằng cú pháp YAML mạch lạc, tự giải thích như văn bản tiếng Anh thông thường, giúp cả lập trình viên (Dev), kỹ sư vận hành (Ops) và chuyên gia an toàn thông tin (Sec) đều có thể đọc hiểu và đóng góp mã nguồn dễ dàng.

---

## 4.3. Các trường hợp sử dụng Ansible: Configuration Management, Application Deployment, Provisioning, Operational Automation

Ansible là một công cụ đa năng bao quát toàn bộ các khía cạnh tự động hóa hạ tầng công nghệ:

```text
┌────────────────────────────────────────────────────────────────────────┐
│                     CÁC ỨNG DỤNG CỐT LÕI CỦA ANSIBLE                   │
├─────────────────────┬──────────────────────┬───────────────────────────┤
│ 1. CONFIGURATION    │ 2. APPLICATION       │ 3. INFRASTRUCTURE         │
│    MANAGEMENT       │    DEPLOYMENT        │    PROVISIONING           │
│ - Chuẩn hóa OS      │ - Kéo mã nguồn Git   │ - Khởi tạo VM trên AWS,   │
│ - Quản lý user/file │ - Build & Restart app│   OpenStack, Proxmox      │
│ - Cấu hình Network  │ - Phối hợp Zero-down │ - Cấu hình Storage/VLAN   │
├─────────────────────┴──────────────────────┴───────────────────────────┤
│ 4. OPERATIONAL AUTOMATION (Tự động hóa vận hành)                       │
│ - Vá lỗi bảo mật hàng loạt (Security Patching OS)                      │
│ - Sao lưu cơ sở dữ liệu định kỳ, xoay vòng chứng chỉ SSL               │
│ - Thu thập thông tin kiểm toán hệ thống (System Auditing)              │
└────────────────────────────────────────────────────────────────────────┘
```

1. **Quản trị cấu hình (Configuration Management):**
   Cài đặt và đồng bộ hóa các tệp cấu hình cho Web Server, Database, Load Balancer trên hàng trăm máy chủ chỉ trong một lần bấm nút.
2. **Triển khai ứng dụng (Application Deployment):**
   Tích hợp vào đường ống CI/CD để tự động hóa việc đưa các gói phần mềm, mã nguồn hoặc Docker Container lên cụm máy chủ phân tán theo các chiến lược Rolling Update hoặc Blue-Green.
3. **Khởi tạo tài nguyên hạ tầng (Provisioning):**
   Sử dụng các module tích hợp sẵn để tự động yêu cầu khởi tạo máy ảo, mạng ảo, đĩa lưu trữ trên các nền tảng đám mây công cộng (AWS, GCP, Azure) hoặc đám mây riêng (VMware, OpenStack, Proxmox).
4. **Tự động hóa vận hành và Bảo mật (Security & Compliance):**
   Tự động quét và cập nhật các bản vá lỗi bảo mật hạt nhân Linux cho toàn bộ hệ thống máy chủ, cấu hình tường lửa iptables/ufw và vô hiệu hóa các cổng truy cập không an toàn.

---

## 4.4. So sánh Ansible với Shell Script truyền thống

Bảng phân tích dưới đây chỉ ra sự khác biệt bản chất giữa kịch bản lệnh Shell truyền thống và nền tảng tự động hóa Ansible:

| Tiêu chí | Shell Script (Bash / PowerShell) | Ansible |
| :--- | :--- | :--- |
| **Mô hình lập trình** | **Mệnh lệnh (Imperative):** Chỉ định chính xác từng bước máy tính phải làm thế nào (`how to do`). | **Khai báo (Declarative):** Mô tả trạng thái cuối cùng mong muốn là gì (`what to achieve`). |
| **Tính lũy thừa (Idempotency)** | **Không có sẵn:** Phải tự viết hàng loạt câu lệnh điều kiện `if-else` phức tạp để kiểm tra trạng thái trước khi làm (ví dụ: kiểm tra xem gói đã cài chưa, file đã có dòng đó chưa). | **Tích hợp sẵn 100%:** Mọi module cốt lõi của Ansible tự động kiểm tra trạng thái hệ thống trước khi áp dụng thay đổi. |
| **Quản lý đa máy chủ** | Rất khó khăn: Phải tự viết vòng lặp `for host in hosts; do ssh ...; done`, khó xử lý lỗi khi có một máy bị mất kết nối mạng. | **Tuyệt vời:** Tích hợp sẵn cơ chế xử lý song song đa luồng (Forks) trên hàng ngàn máy chủ và tự động lập báo cáo kết quả chi tiết. |
| **Xử lý lỗi (Error Handling)** | Rất mong manh: Dễ bị dừng đột ngột hoặc tiếp tục chạy sai lệch nếu thiếu cờ `set -e`. | Mạnh mẽ: Quản lý mã thoát chặt chẽ, hỗ trợ các khối `block - rescue - always` tương tự ngôn ngữ lập trình hiện đại. |
| **Tính di động đa nền tảng** | Kém: Lệnh của Ubuntu (`apt`) không chạy được trên CentOS (`yum/dnf`). | **Độc lập nền tảng:** Module `package` của Ansible tự động nhận diện hệ điều hành để gọi công cụ cài đặt tương ứng. |
| **Bảo trì và chuyển giao** | Khó đọc hiểu khi kịch bản dài hàng trăm dòng, phụ thuộc vào phong cách viết của từng cá nhân. | Rất dễ bảo trì nhờ cấu trúc chuẩn hóa, rõ ràng và cú pháp YAML mạch lạc. |

---

## 4.5. Kiến trúc Control Node và Managed Node

Kiến trúc vận hành của Ansible cực kỳ tinh giản, chỉ bao gồm hai thực thể chính:

```text
┌────────────────────────────────────────────────────────────────────────┐
│                        ANSIBLE CONTROL NODE                            │
│  - Máy chủ Linux / macOS (Chạy Ansible, Python, OpenSSH Client)        │
│  - Lưu trữ: Inventory, Playbooks, Roles, Tệp cấu hình ansible.cfg      │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                       Giao thức mạng: SSH (Linux) / WinRM (Windows)
                                    │ Không cần Agent trung gian!
         ┌──────────────────────────┼──────────────────────────┐
         ▼                          ▼                          ▼
┌──────────────────┐       ┌──────────────────┐       ┌──────────────────┐
│  MANAGED NODE 1  │       │  MANAGED NODE 2  │       │  MANAGED NODE 3  │
│  Ubuntu 22.04 VM │       │  RHEL 9 VM       │       │  Debian 12 VM    │
│  - Python 3.x    │       │  - Python 3.x    │       │  - Python 3.x    │
│  - OpenSSH Server│       │  - OpenSSH Server│       │  - OpenSSH Server│
└──────────────────┘       └──────────────────┘       └──────────────────┘
```

### 1. Control Node (Nút điều khiển)
- Là máy tính hoặc máy chủ nơi Ansible được cài đặt và trực tiếp thực thi các câu lệnh.
- **Yêu cầu hệ điều hành:** Bắt buộc phải là hệ điều hành họ Unix (Linux như Ubuntu, RHEL, Debian hoặc macOS). **Windows không thể làm Control Node** (nhưng có thể chạy thông qua môi trường ảo hóa WSL2 trên Windows).
- Yêu cầu cài đặt sẵn Python (phiên bản 3.9 trở lên) và phần mềm OpenSSH client.
- Nơi lưu trữ mã nguồn tự động hóa: tệp danh sách máy chủ (Inventory), các tệp kịch bản thực thi (Playbooks), các mẫu cấu hình Jinja2 và tệp cấu hình trung tâm `ansible.cfg`.

### 2. Managed Node (Nút được quản lý / Target Hosts)
- Là các máy tính, máy ảo, container hoặc thiết bị mạng chịu sự điều khiển của Control Node.
- **Yêu cầu trên Managed Node cực kỳ tối giản:**
  - Không cần cài đặt bất kỳ phần mềm dịch vụ Ansible Agent nào.
  - Đối với hệ điều hành Linux/Unix: Chỉ cần cài sẵn dịch vụ OpenSSH server và trình thông dịch Python 3.
  - Đối với hệ điều hành Windows: Kích hoạt dịch vụ quản trị từ xa Windows Remote Management (WinRM) hoặc OpenSSH for Windows kèm theo PowerShell 5.1 trở lên.

---

## 4.6. Cơ chế giao tiếp qua giao thức SSH

Ansible hoạt động hoàn toàn dựa trên cơ sở hạ tầng mạng và giao thức truyền thông an toàn có sẵn của hệ điều hành:

```text
Control Node                                                 Managed Node
┌──────────────┐                                            ┌──────────────┐
│ Playbook Task│                                            │              │
└──────┬───────┘                                            │              │
       │                                                    │              │
       ▼                                                    │              │
1. Sinh mã Python ──► 2. Mở kết nối SSH an toàn ───────────►│              │
   tạm thời           3. Copy mã Python vào /tmp/           │              │
                      4. Thực thi mã Python trên máy đích ──► Xử lý Task   │
                                                            │              │
                      5. Thu thập kết quả JSON <────────────┤              │
                      6. Xóa sạch file tạm trong /tmp/      │              │
                      7. Đóng phiên SSH                     │              │
       │                                                    │              │
       ▼                                                    └──────────────┘
In kết quả (ok / changed / failed)
```

### Quy trình 7 bước thực thi một Task của Ansible qua SSH:
1. **Biên dịch mã module cục bộ:** Dựa trên khai báo trong Playbook, Control Node tự động kết hợp các tham số đầu vào và sinh ra một đoạn mã kịch bản Python độc lập tạm thời.
2. **Thiết lập kết nối an toàn:** Control Node sử dụng OpenSSH để mở phiên kết nối mã hóa tới Managed Node thông qua tài khoản và khóa SSH Key đã cấu hình.
3. **Chuyển giao mã thực thi:** Kịch bản Python tạm thời được nén và sao chép an toàn vào thư mục tạm trên máy đích (mặc định tại đường dẫn `~/.ansible/tmp/...`).
4. **Thực thi trên máy đích:** Ansible gọi trình thông dịch Python trên Managed Node để thực thi đoạn mã kịch bản đó dưới quyền hạn người dùng được chỉ định (hoặc leo quyền qua `sudo`).
5. **Tiếp nhận kết quả dạng JSON:** Đoạn mã kịch bản sau khi hoàn tất sẽ xuất kết quả ra luồng chuẩn dưới định dạng chuẩn JSON (chứa thông tin trạng thái: `changed: true/false`, thông báo lỗi, dữ liệu đầu ra) và gửi ngược về cho Control Node.
6. **Dọn dẹp môi trường sạch sẽ:** Control Node gửi lệnh xóa bỏ toàn bộ các tệp tin Python tạm thời vừa tạo trong thư mục `/tmp` của máy đích để không để lại bất kỳ dấu vết rác nào trên hệ thống.
7. **Đóng phiên kết nối:** Phiên SSH kết thúc và Control Node in kết quả tổng kết lên màn hình console cho người quản trị.

---

# 5. Mục 5: Cài đặt và cấu hình Ansible

## 5.1. Các phương pháp cài đặt Ansible trên Linux

Có hai phương pháp chính để cài đặt Ansible trên máy chủ điều khiển Control Node:

### 1. Cài đặt qua trình quản lý gói của hệ điều hành (OS Package Manager)
- Trên Ubuntu / Debian: Sử dụng kho lưu trữ PPA chính thức thông qua công cụ `apt`.
- Trên RHEL / CentOS / Rocky Linux: Kích hoạt kho EPEL và cài đặt qua `dnf` hoặc `yum`.
- **Ưu điểm:** Cài đặt nhanh chóng, tự động cấu hình các gói phụ thuộc hệ thống và tự động cập nhật qua quy trình vá lỗi của hệ điều hành.

### 2. Cài đặt qua trình quản lý gói Python (Python Pip)
- Sử dụng lệnh `pip install ansible` hoặc cài đặt bên trong một môi trường ảo hóa độc lập (Python Virtual Environment - `venv`).
- **Ưu điểm:** Cho phép lựa chọn chính xác phiên bản Ansible mong muốn, không làm ảnh hưởng đến các thư viện Python mặc định của hệ điều hành, rất phù hợp cho môi trường kiểm thử CI/CD Runner.

---

## 5.2. Phân biệt Ansible Core và Ansible Community Package

Kể từ phiên bản 2.10, dự án Ansible được tái cấu trúc thành hai gói phát hành riêng biệt:

| Tiêu chí phân biệt | Ansible Core (`ansible-core`) | Ansible Community Package (`ansible`) |
| :--- | :--- | :--- |
| **Bản chất** | Bộ khung động cơ cốt lõi siêu nhẹ của Ansible. | Gói phát hành đầy đủ do cộng đồng nguồn mở đóng gói. |
| **Thành phần bên trong** | Chỉ bao gồm các công cụ dòng lệnh cơ bản (`ansible`, `ansible-playbook`, `ansible-galaxy`) và một số ít module hệ thống thiết yếu (`ansible.builtin`). | Bao gồm toàn bộ `ansible-core` cộng thêm hàng trăm bộ sưu tập (Collections) do cộng đồng và các hãng công nghệ lớn (AWS, Azure, Cisco, VMware) phát triển. |
| **Dung lượng cài đặt** | Cực kỳ nhỏ gọn và nhẹ (~20MB). | Khá nặng, chứa hàng ngàn module sẵn có (~500MB). |
| **Chu kỳ phát hành** | Phát hành theo chu kỳ nghiêm ngặt của Red Hat. | Cập nhật thường xuyên 6 tháng một lần theo bản phát hành cộng đồng. |
| **Khuyến nghị sử dụng** | Tối ưu cho môi trường CI/CD Runner, môi trường container hoặc hệ thống nhúng cần sự tinh gọn tối đa. | Tối ưu cho máy tính cá nhân của kỹ sư hệ thống hoặc máy chủ điều khiển trung tâm cần đầy đủ công cụ. |

---

## 5.3. Hướng dẫn cài đặt Ansible trên Ubuntu và RHEL

### Quy trình cài đặt chuẩn trên Ubuntu 22.04 / 24.04 LTS:

```bash
# 1. Cập nhật chỉ mục gói phần mềm hệ thống
sudo apt update && sudo apt install -y software-properties-common curl git

# 2. Thêm kho lưu trữ PPA chính thức của đội ngũ phát triển Ansible
sudo add-apt-repository --yes --update ppa:ansible/ansible

# 3. Tiến hành cài đặt gói Ansible hoàn chỉnh
sudo apt install -y ansible

# 4. Cài đặt thêm tiện ích mở rộng argcomplete để tự động hoàn thành lệnh bằng phím Tab
sudo apt install -y python3-argcomplete
sudo activate-global-python-argcomplete3
```

### Quy trình cài đặt chuẩn trên RHEL 9 / Rocky Linux 9:

```bash
# 1. Kích hoạt kho phần mềm mở rộng EPEL (Extra Packages for Enterprise Linux)
sudo dnf install -y epel-release

# 2. Cài đặt gói Ansible
sudo dnf install -y ansible
```

---

## 5.4. Kiểm tra phiên bản với ansible --version

Sau khi hoàn tất quá trình cài đặt, thực thi lệnh `ansible --version` để thẩm định môi trường hoạt động:

```bash
ansible --version
```

Kết quả xuất ra trên terminal:

```text
ansible [core 2.16.5]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/ubuntu/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/ubuntu/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.10.12 (main, Nov 20 2023, 15:14:05) [GCC 11.4.0] (/usr/bin/python3)
  jinja version = 3.0.3
  libyaml = True
```

### Phân tích các thông tin kỹ thuật quan trọng:
- `ansible [core 2.16.5]`: Phiên bản lõi Ansible đang vận hành.
- `config file`: Đường dẫn tệp tin cấu hình đang được ưu tiên nạp vào bộ nhớ.
- `python version`: Phiên bản trình thông dịch Python mà Control Node đang sử dụng để sinh mã thực thi.
- `jinja version`: Thư viện xử lý mẫu biểu Jinja2 dùng để nội suy biến số trong cấu hình.

---

## 5.5. Tệp tin cấu hình trung tâm ansible.cfg

Toàn bộ hành vi vận hành mặc định của Ansible được kiểm soát bởi tệp tin `ansible.cfg`.

### Thứ tự ưu tiên nạp tệp cấu hình (Từ cao xuống thấp):
1. **Biến môi trường:** Biến `$ANSIBLE_CONFIG` (nếu được thiết lập sẽ ghi đè toàn bộ).
2. **Thư mục làm việc hiện tại:** Tệp `./ansible.cfg` nằm ngay tại thư mục nơi kỹ sư thực thi lệnh (Khuyến nghị chuẩn mực cho từng dự án).
3. **Thư mục Home người dùng:** Tệp `~/.ansible.cfg` trong thư mục cá nhân.
4. **Cấu hình mặc định hệ thống:** Tệp `/etc/ansible/ansible.cfg` của hệ điều hành.

### Mẫu tệp tin ansible.cfg chuẩn sản xuất cho dự án:

Khởi tạo tệp tin `ansible.cfg` ngay tại thư mục gốc của dự án DevOps:

```ini
[defaults]
# Chỉ định đường dẫn tệp Inventory mặc định
inventory = ./inventory.ini

# Tài khoản người dùng mặc định khi SSH vào máy chủ đích
remote_user = devops

# Đường dẫn khóa bí mật SSH Private Key
private_key_file = ~/.ssh/id_rsa

# Tắt cơ chế kiểm tra Host Key của SSH (tránh bị dừng kịch bản khi gặp máy chủ mới)
host_key_checking = False

# Số lượng tiến trình chạy song song đồng thời (mặc định là 5, tăng lên 20 để tối ưu tốc độ)
forks = 20

# Bật tính năng đo thời gian thực thi của từng Task trong Playbook
callbacks_enabled = timer, profile_tasks

# Thời gian chờ phản hồi SSH tối đa trước khi báo lỗi timeout (giây)
timeout = 30

[privilege_escalation]
# Tự động chuyển quyền sang tài khoản root khi thực thi các tác vụ hệ thống
become = True

# Phương thức chuyển quyền (mặc định là sudo)
become_method = sudo

# Người dùng đích sau khi chuyển quyền
become_user = root

# Yêu cầu nhập mật khẩu sudo hay không (False nếu đã cấu hình NOPASSWD)
become_ask_pass = False
```

---

## 5.6. Cấu hình xác thực SSH Key không mật khẩu

Để Ansible có thể tự động hóa hoàn toàn mà không bị dừng lại hỏi mật khẩu đăng nhập, việc thiết lập xác thực bằng cặp khóa công khai - bí mật (SSH Key-based Authentication) là điều kiện tiên quyết.

```bash
# Bước 1: Khởi tạo cặp khóa SSH trên máy Control Node (nếu chưa có)
ssh-keygen -t ed25519 -C "ansible-control-node" -f ~/.ssh/id_ed25519 -N ""

# Bước 2: Phân phối khóa công khai (Public Key) tới toàn bộ các Managed Nodes
ssh-copy-id -i ~/.ssh/id_ed25519.pub devops@192.168.1.101
ssh-copy-id -i ~/.ssh/id_ed25519.pub devops@192.168.1.102
ssh-copy-id -i ~/.ssh/id_ed25519.pub devops@192.168.1.103

# Bước 3: Cấu hình quyền sudo không cần nhập mật khẩu trên Managed Nodes
# Đăng nhập vào từng máy đích và chạy lệnh cấu hình sudoers:
echo "devops ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/devops
sudo chmod 0440 /etc/sudoers.d/devops
```

---

## 5.7. Kiểm tra kết nối đến Managed Node bằng Ansible

Sau khi hoàn tất cấu hình, thực hiện bài kiểm tra liên lạc mạng đầu tiên bằng module `ping` của Ansible:

```bash
# Kiểm tra kết nối tới máy chủ cụ thể qua dòng lệnh Ad-hoc
ansible 192.168.1.101 -m ping -u devops --private-key=~/.ssh/id_ed25519
```

Kết quả phản hồi JSON chuẩn mực:

```json
192.168.1.101 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

*Lưu ý kỹ thuật quan trọng:* Module `ping` của Ansible **hoàn toàn không phải là lệnh ping ICMP thông thường** của mạng máy tính. Đây là một tác vụ kiểm tra toàn diện: Ansible thực sự đã mở một phiên kết nối SSH, xác thực tài khoản thành công, khởi động trình thông dịch Python trên máy đích và trả về chuỗi phản hồi `"pong"`.

---

# 6. Mục 6: Inventory và Ad-hoc Commands

## 6.1. Khái niệm Inventory: Static Inventory và Dynamic Inventory

**Inventory** là tệp tin hoặc nguồn dữ liệu chứa danh sách thông tin các máy chủ đích mà Ansible quản lý, bao gồm địa chỉ IP, tên miền, cổng kết nối và các biến số cấu hình riêng biệt.

Ansible hỗ trợ hai loại Inventory:

### 1. Static Inventory (Kho lưu trữ tĩnh)
- Danh sách máy chủ được định nghĩa cố định trong các tệp tin văn bản thuần theo định dạng **INI** hoặc **YAML**.
- Dễ đọc, dễ viết, phù hợp cho các hạ tầng ổn định, ít biến động (như máy chủ vật lý on-premises hoặc các cụm máy ảo cố định).

### 2. Dynamic Inventory (Kho lưu trữ động)
- Sử dụng các đoạn mã kịch bản (Script) hoặc Plugin để tự động truy vấn danh sách máy chủ theo thời gian thực từ các nhà cung cấp đám mây (AWS EC2, Google Cloud, Azure, OpenStack, Kubernetes).
- Khi hạ tầng tự động co giãn (Auto-scaling): Các máy ảo mới sinh ra hoặc bị tiêu hủy sẽ được cập nhật tức thời vào danh sách mà kỹ sư không cần chỉnh sửa tệp thủ công.

---

## 6.2. Cấu trúc Host, Group và Group Variables

### 1. Định dạng INI (Phổ biến và ngắn gọn nhất):

Tệp tin `inventory.ini`:

```ini
# Khai báo máy chủ đơn lẻ không thuộc nhóm
bastion.company.com ansible_host=192.168.1.5

# Định nghĩa nhóm máy chủ Web Server
[webservers]
web-node-01 ansible_host=192.168.1.11
web-node-02 ansible_host=192.168.1.12
web-node-03 ansible_host=192.168.1.13

# Định nghĩa nhóm máy chủ Cơ sở dữ liệu
[dbservers]
db-primary   ansible_host=192.168.1.21
db-replica   ansible_host=192.168.1.22

# Gom nhóm các nhóm con lại với nhau (Group of Groups / Metagroup)
[production:children]
webservers
dbservers

# Thiết lập biến dùng chung cho toàn bộ nhóm webservers (Group Variables)
[webservers:vars]
http_port=80
max_clients=500
app_env=production

# Thiết lập biến dùng chung cho toàn bộ dự án
[all:vars]
ansible_user=devops
ansible_ssh_private_key_file=~/.ssh/id_ed25519
ansible_python_interpreter=/usr/bin/python3
```

### 2. Định dạng YAML:

Tệp tin `inventory.yaml`:

```yaml
all:
  vars:
    ansible_user: devops
    ansible_ssh_private_key_file: ~/.ssh/id_ed25519
  children:
    webservers:
      vars:
        http_port: 80
      hosts:
        web-node-01:
          ansible_host: 192.168.1.11
        web-node-02:
          ansible_host: 192.168.1.12
    dbservers:
      hosts:
        db-primary:
          ansible_host: 192.168.1.21
```

---

## 6.3. Phân biệt Host Variables và Inventory Variables

- **Host Variables (Biến số cấp máy chủ):** Là biến được áp dụng độc quyền cho một máy chủ cụ thể, dùng để chỉ định các thông số mang tính cá biệt:
  ```ini
  web-node-01 ansible_host=192.168.1.11 server_id=1 disk_backup=/dev/sdb
  ```
- **Group Variables (Biến số cấp nhóm):** Là biến được áp dụng đồng loạt cho toàn bộ các máy chủ nằm bên trong nhóm đó:
  ```ini
  [dbservers:vars]
  db_engine=mysql
  db_port=3306
  ```

---

## 6.4. Host Patterns và cách lựa chọn Managed Nodes

Khi thực thi lệnh Ansible, ta sử dụng **Host Patterns** để lọc chính xác tập hợp các máy chủ mục tiêu cần tác động:

```bash
# 1. Tác động tới toàn bộ máy chủ có trong Inventory
ansible all -m ping

# 2. Tác động tới một nhóm cụ thể
ansible webservers -m ping

# 3. Tác động tới đúng một máy chủ duy nhất theo tên định danh
ansible web-node-01 -m ping

# 4. Phép giao (Intersection): Các máy vừa nằm trong nhóm webservers vừa nằm trong nhóm staging
ansible "webservers:&staging" -m ping

# 5. Phép loại trừ (Exclusion): Toàn bộ nhóm webservers nhưng trừ máy web-node-03
ansible "webservers:!web-node-03" -m ping

# 6. Sử dụng ký tự đại diện (Wildcard): Toàn bộ các máy có tiền tố web*
ansible "web*" -m ping

# 7. Lựa chọn theo vị trí chỉ mục (Index / Slice): Chỉ chạy trên máy đầu tiên của nhóm
ansible "webservers[0]" -m ping
ansible "webservers[0:2]" -m ping # Chạy trên máy số 0 và số 1
```

---

## 6.5. Quản lý Inventory cho nhiều môi trường

Trong các dự án thực tế, người quản trị phân tách các tệp Inventory theo từng môi trường độc lập bên trong thư mục `inventories/`:

```text
my-ansible-project/
├── inventories/
│   ├── development/
│   │   ├── hosts.ini
│   │   ├── group_vars/
│   │   └── host_vars/
│   ├── staging/
│   │   └── hosts.ini
│   └── production/
│       └── hosts.ini
```

Khi thực thi lệnh, chỉ định môi trường mong muốn bằng cờ `-i`:

```bash
ansible-playbook -i inventories/production/hosts.ini deploy.yml
```

---

## 6.6. Bản chất và cú pháp của lệnh Ad-hoc Commands

### Bản chất kỹ thuật:
**Ad-hoc Command** là câu lệnh thực thi nhanh một tác vụ duy nhất của Ansible ngay từ giao diện dòng lệnh terminal mà không cần viết tệp kịch bản Playbook.

Ad-hoc Commands cực kỳ hữu ích cho các tác vụ vận hành khẩn cấp: Khởi động lại dịch vụ web ngay lập tức, kiểm tra dung lượng ổ đĩa của 100 máy chủ, phân phối một tệp tin cấu hình nóng, hoặc kiểm toán người dùng hệ thống.

### Cú pháp tổng quát:

```bash
ansible <host-pattern> -m <module_name> -a "<module_arguments>" [options]
```

Giải thích các cờ tham số:
- `<host-pattern>`: Nhóm hoặc tên máy chủ cần thực thi (`all`, `webservers`).
- `-m <module_name>`: Tên module thực thi (ví dụ `shell`, `copy`, `apt`, `service`). Mặc định nếu không truyền `-m` thì Ansible sử dụng module `command`.
- `-a "<module_arguments>"`: Các tham số truyền vào module.
- `-b` (viết tắt của `--become`): Kích hoạt quyền quản trị cao nhất (root via sudo).
- `-K` (viết tắt của `--ask-become-pass`): Yêu cầu nhắc nhập mật khẩu sudo (nếu chưa cấu hình NOPASSWD).

---

## 6.7. Các module cơ bản trong Ansible

Dưới đây là bảng tổng hợp các module nền tảng được sử dụng nhiều nhất:

| Tên Module | Chức năng kỹ thuật | Tính lũy thừa (Idempotent) | Ví dụ ứng dụng tiêu biểu |
| :--- | :--- | :--- | :--- |
| **`ping`** | Kiểm tra kết nối SSH và môi trường Python máy đích. | Có | Kiểm tra xem cụm máy chủ còn sống hay không. |
| **`command`** | Thực thi lệnh nhị phân an toàn trên máy đích (không hỗ trợ pipe `\|`, redirect `>`). | Không | Chạy các lệnh đơn giản như `uptime`, `uname -r`. |
| **`shell`** | Thực thi lệnh thông qua trình shell `/bin/sh` (hỗ trợ đầy đủ pipe, biến môi trường, redirect). | Không | `cat /etc/os-release \| grep VERSION`. |
| **`copy`** | Sao chép tệp tin từ Control Node sang Managed Node kèm theo phân quyền. | Có (chỉ chép nếu tệp khác nội dung) | Phân phối tệp cấu hình `nginx.conf` xuống các máy chủ. |
| **`file`** | Quản lý thuộc tính tệp tin, tạo thư mục, xóa tệp, tạo symlink. | Có | Tạo thư mục `/var/www/html` với quyền sở hữu `www-data`. |
| **`apt` / `yum` / `package`** | Quản lý cài đặt, cập nhật, gỡ bỏ gói phần mềm trên hệ điều hành. | Có (nếu gói đã cài thì bỏ qua) | Cài đặt `nginx`, `git`, `curl` với trạng thái `state=present`. |
| **`service` / `systemd`** | Quản lý trạng thái khởi chạy, dừng, khởi động lại và bật tự khởi động của dịch vụ hệ thống. | Có | Đảm bảo Nginx luôn ở trạng thái `state=started` và `enabled=yes`. |
| **`user`** | Tạo mới, sửa đổi hoặc xóa bỏ tài khoản người dùng trên hệ thống Linux. | Có | Tạo tài khoản lập trình viên `deployer` thuộc nhóm `sudo`. |

---

## 6.8. Thực hành: Tạo Inventory và kiểm tra kết nối đến nhiều Linux VM

### Bước 1: Khởi tạo tệp Inventory

Tạo tệp tin `inventory-lab.ini` khai báo danh sách 3 máy ảo kiểm thử:

```ini
[webservers]
node01 ansible_host=192.168.56.11
node02 ansible_host=192.168.56.12

[dbservers]
node03 ansible_host=192.168.56.13

[all:vars]
ansible_user=vagrant
ansible_ssh_private_key_file=~/.vagrant.d/insecure_private_key
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

### Bước 2: Kiểm tra liên lạc đồng loạt toàn bộ hệ thống

```bash
ansible all -i inventory-lab.ini -m ping
```

Kết quả in ra màn hình xác nhận cả 3 máy chủ đều phản hồi `pong` thành công.

---

# 7. Mục 7: Ansible Playbooks

## 7.1. Khái niệm Playbook và định dạng cú pháp YAML

**Playbook** là một tệp kịch bản được viết bằng định dạng **YAML** mô tả một chuỗi các công việc (Plays) cần được thực thi theo thứ tự tuần tự logic trên các nhóm máy chủ cụ thể để đưa hệ thống vào đúng trạng thái mong muốn.

### Các quy tắc cú pháp YAML sống còn trong Playbook:
- Tệp tin luôn bắt đầu bằng ba dấu gạch ngang `---` ở dòng đầu tiên.
- **Thụt lề bắt buộc bằng khoảng trắng (Spaces):** Thường sử dụng thụt lề 2 dấu cách cho mỗi cấp bậc. Tuyệt đối không bao giờ dùng phím Tab (sẽ gây lỗi cú pháp parser).
- Cặp khóa - giá trị phân tách bằng dấu hai chấm kèm một khoảng trắng: `key: value`.
- Danh sách phần tử bắt đầu bằng dấu gạch ngang kèm khoảng trắng: `- item`.

---

## 7.2. Cấu trúc Playbook: Plays, Tasks và Modules

Cấu trúc phân cấp giải phẫu của một Playbook:

```text
PLAYBOOK (Tệp YAML tổng thể)
  │
  ├── PLAY 1: Cấu hình cho nhóm Web Server
  │     ├── Hosts mục tiêu: webservers
  │     ├── Quyền thực thi: become = yes
  │     └── Danh sách TASKS:
  │           ├── Task 1: Gọi module apt để cài đặt Nginx
  │           ├── Task 2: Gọi module template để tạo config
  │           └── Task 3: Gọi module service để khởi động Nginx
  │
  └── PLAY 2: Cấu hình cho nhóm Database Server
        ├── Hosts mục tiêu: dbservers
        └── Danh sách TASKS:
              ├── Task 1: Cài đặt MySQL Server
              └── Task 2: Khởi tạo database ban đầu
```

- **Play:** Là sự ánh xạ giữa một nhóm máy chủ mục tiêu (`hosts`) và các nhiệm vụ (`tasks`) cần thực hiện trên nhóm máy đó.
- **Task:** Một bước công việc cụ thể. Mỗi Task phải có một tiêu đề mô tả rõ ràng (`name: ...`) và gọi **duy nhất một module** cùng các tham số tương ứng.
- **Module:** Đơn vị thực thi chức năng bên dưới của Ansible.

---

## 7.3. Biến số và Thứ tự ưu tiên của biến (Variable Precedence)

Biến số (Variables) giúp Playbook trở nên linh hoạt, có khả năng tái sử dụng trên nhiều môi trường khác nhau mà không phải viết cứng các giá trị cấu hình.

### Khai báo biến trong Playbook:

```yaml
---
- name: Demo quan ly bien so
  hosts: webservers
  vars:
    app_port: 8080
    app_user: "nginx_user"
    package_list:
      - nginx
      - git
      - certbot
  tasks:
    - name: In ra gia tri bien port
      ansible.builtin.debug:
        msg: "Ung dung se lang nghe tren cong {{ app_port }}"
```

### Thứ tự ưu tiên của biến số (Variable Precedence):
Ansible hỗ trợ khai báo biến ở rất nhiều nơi (trong Inventory, trong Playbook, trong Role, truyền từ dòng lệnh). Khi có sự trùng lặp tên biến, Ansible áp dụng quy tắc ưu tiên khắt khe với 22 cấp bậc.

Quy tắc ghi nhớ nhanh cho các cấp bậc thực tế quan trọng nhất (Từ thấp đến cao):
1. `role defaults` (Mức thấp nhất, dễ bị ghi đè nhất).
2. `inventory group_vars` (Biến nhóm trong Inventory).
3. `inventory host_vars` (Biến từng máy trong Inventory).
4. `playbook vars` (Biến khai báo trong khối `vars` của Playbook).
5. `extra vars` thông qua cờ dòng lệnh `-e` hoặc `--extra-vars` (Mức ưu tiên cao nhất tuyệt đối, ghi đè toàn bộ mọi nơi khác):
   ```bash
   ansible-playbook site.yml -e "app_port=9000 env=staging"
   ```

---

## 7.4. Tags và kỹ thuật Task Selection

Khi Playbook có quy mô lớn chứa hàng chục tác vụ (cài đặt OS, cài đặt database, cấu hình Nginx, sao chép mã nguồn), việc chạy lại toàn bộ Playbook mỗi khi chỉ muốn cập nhật một tệp cấu hình nhỏ sẽ rất lãng phí thời gian.

**Tagsơ** cho phép gắn nhãn cho từng Task hoặc từng Play để có thể chủ động chọn lọc nhiệm vụ cần chạy:

```yaml
tasks:
  - name: Cai dat Nginx Web Server
    ansible.builtin.apt:
      name: nginx
      state: present
    tags:
      - install
      - packages

  - name: Cap nhat tap tin cau hinh Nginx
    ansible.builtin.template:
      src: nginx.conf.j2
      dest: /etc/nginx/nginx.conf
    tags:
      - config

  - name: Khoi dong lai dich vu Nginx
    ansible.builtin.service:
      name: nginx
      state: restarted
    tags:
      - service
```

### Kỹ thuật thực thi theo Tags:

```bash
# Chỉ chạy duy nhất các tác vụ có gắn tag config
ansible-playbook -i inventory.ini site.yml --tags "config"

# Chạy nhiều tags kết hợp
ansible-playbook -i inventory.ini site.yml --tags "packages,config"

# Chạy toàn bộ Playbook nhưng BỎ QUA các tác vụ gắn tag packages
ansible-playbook -i inventory.ini site.yml --skip-tags "packages"
```

---

## 7.5. Chế độ kiểm tra Check Mode và Diff Mode

Trước khi áp dụng các thay đổi cấu hình quan trọng lên cụm máy chủ sản xuất, Ansible cung cấp hai chế độ chạy thử nghiệm an toàn cực kỳ mạnh mẽ:

### 1. Check Mode (Chạy mô phỏng với cờ `--check` hoặc `-C`):
- Ansible thực hiện quét và mô phỏng việc chạy toàn bộ Playbook trên hệ thống máy đích nhưng **hoàn toàn không thực hiện bất kỳ sự thay đổi thực tế nào** lên ổ đĩa hay hệ điều hành của máy đích.
- Báo cáo kết quả sẽ hiển thị chính xác các tác vụ nào sẽ ở trạng thái `ok`, tác vụ nào sẽ làm thay đổi hệ thống (`changed`), hoặc tác vụ nào sẽ phát sinh lỗi (`failed`).
- Được xem như cơ chế "Dry-Run" bảo hiểm an toàn cho kỹ sư DevOps.

### 2. Diff Mode (Xem sự khác biệt nội dung với cờ `--diff` hoặc `-D`):
- Thường kết hợp cùng Check Mode: `ansible-playbook site.yml --check --diff`.
- Khi có một tệp cấu hình bị thay đổi nội dung, Diff Mode sẽ in trực tiếp bảng so sánh dòng trước và dòng sau (dạng `git diff` màu xanh và đỏ) lên màn hình console, giúp kỹ sư quan sát trực quan từng dòng chữ chuẩn bị được ghi đè lên máy chủ.

```bash
# Câu lệnh kiểm tra an toàn tối ưu trước khi triển khai thực tế:
ansible-playbook -i production.ini deploy.yml --check --diff
```

---

# 8. Mục 8: Ansible Roles và tổ chức Project chuyên nghiệp

## 8.1. Khái niệm Role và mục đích tái sử dụng

Khi quy mô dự án ngày càng mở rộng, việc viết toàn bộ biến số, tác vụ xử lý tệp, mã nguồn cấu hình và cơ chế kích hoạt vào trong một tệp tin `playbook.yml` duy nhất sẽ tạo ra một tệp kịch bản dài hàng ngàn dòng vô cùng rối rắm, khó đọc và hầu như không thể tái sử dụng cho các dự án khác.

**Ansible Role** là cơ chế đóng gói và mô-đun hóa các tài nguyên tự động hóa theo một cấu trúc thư mục chuẩn mực đã được định nghĩa trước. 

Một Role đại diện cho một vai trò chức năng độc lập hoàn chỉnh trong hệ thống (ví dụ: role `nginx`, role `mysql`, role `docker`, role `security_baseline`). Khi đã đóng gói thành Role, ta có thể dễ dàng tái sử dụng Role đó ở bất kỳ dự án nào, chia sẻ cho đồng nghiệp hoặc tải về sử dụng từ kho lưu trữ toàn cầu.

```text
PLAYBOOK NGUYÊN KHỐI (Khó bảo trì)           ANSIBLE ROLES (Chuẩn hóa & Tái sử dụng)
┌─────────────────────────────────┐           ┌─────────────────────────────────┐
│ site.yml                        │           │ site.yml                        │
│ - 50 dòng: Biến số cấu hình     │           │ hosts: webservers               │
│ - 100 dòng: Tasks cài đặt Nginx │  ──────►  │ roles:                          │
│ - 150 dòng: Tasks cài đặt MySQL │           │   - role: common_security       │
│ - 80 dòng: Handlers reload      │           │   - role: nginx_server          │
│ - 40 dòng: Template nội dung    │           │   - role: nodejs_runtime        │
└─────────────────────────────────┘           └─────────────────────────────────┘
```

---

## 8.2. Cấu trúc thư mục của một Ansible Role

Một Ansible Role tiêu chuẩn sở hữu cấu trúc thư mục phân nhánh chặt chẽ. Mỗi thư mục đảm nhận một chức năng kỹ thuật chuyên biệt và bắt buộc phải chứa một tệp tin chính mang tên `main.yml`:

```text
roles/
└── nginx/
    ├── defaults/
    │   └── main.yml        # Biến số mặc định (độ ưu tiên thấp nhất, dễ ghi đè)
    ├── vars/
    │   └── main.yml        # Biến số cố định của role (độ ưu tiên cao, ít thay đổi)
    ├── tasks/
    │   └── main.yml        # Danh sách tác vụ thực thi chính của Role
    ├── handlers/
    │   └── main.yml        # Các bộ lắng nghe sự kiện khởi động lại dịch vụ
    ├── templates/
    │   └── nginx.conf.j2   # Các tệp biểu mẫu động định dạng Jinja2
    ├── files/
    │   └── static.html     # Các tệp tĩnh chuyển giao nguyên bản (không nội suy)
    └── meta/
        └── main.yml        # Thông tin tác giả, giấy phép và các role phụ thuộc
```

### Ý nghĩa chức năng của từng thư mục:
- `tasks/main.yml`: chứa chuỗi các Task tuần tự cần thực hiện.
- `handlers/main.yml`: Chứa các Handler được gọi bởi chỉ thị `notify` (ví dụ: reload Nginx khi file cấu hình thay đổi).
- `templates/`: Chứa các tệp cấu hình động sử dụng ngôn ngữ biểu mẫu Jinja2 (`.j2`), cho phép chèn các biến số và vòng lặp logic.
- `files/`: Chứa các tệp tĩnh chuyển giao nguyên bản (ảnh, mã nguồn nén, script nhị phân) dùng qua module `copy`.
- `defaults/main.yml`: Chứa các biến mặc định có thể bị người dùng Playbook ghi đè một cách linh hoạt.
- `vars/main.yml`: Chứa các biến nội bộ cố định của Role (ví dụ tên gói cài đặt theo từng hệ điều hành), không khuyến khích người dùng ghi đè.
- `meta/main.yml`: Khai báo thông tin metadata và định nghĩa danh sách các Role khác bắt buộc phải chạy trước Role này (Role Dependencies).

Tạo khung thư mục cho Role mới cực kỳ nhanh chóng bằng công cụ `ansible-galaxy`:

```bash
ansible-galaxy role init roles/nginx
```

---

## 8.3. Phân biệt chuyên sâu: defaults và vars

Đây là điểm kỹ thuật mà nhiều kỹ sư thường nhầm lẫn khi thiết kế Role:

| Tiêu chí | `defaults/main.yml` (Default Variables) | `vars/main.yml` (Role Variables) |
| :--- | :--- | :--- |
| **Mục đích thiết kế** | Cung cấp các giá trị mặc định hợp lý để Role có thể chạy được ngay mà không cần cấu hình thêm. | Khai báo các hằng số nội bộ hoặc các thông số mang tính cố định chặt chẽ của Role. |
| **Mức độ ưu tiên** | **Mức ưu tiên thấp nhất** trong toàn bộ hệ thống phân cấp biến của Ansible. | **Mức ưu tiên rất cao**, xếp trên cả biến cấp máy chủ và biến cấp nhóm trong Inventory. |
| **Khả năng ghi đè** | Cực kỳ dễ dàng: Người dùng Playbook có thể ghi đè biến này thông qua Inventory, Playbook `vars` hoặc cờ `-e`. | Rất khó ghi đè: Chỉ có thể bị ghi đè bởi cờ dòng lệnh `--extra-vars`. |
| **Ví dụ áp dụng** | `http_port: 80`, `nginx_worker_processes: "auto"`, `keepalive_timeout: 65`. | Đường dẫn nhị phân `/usr/sbin/nginx`, tên dịch vụ hệ thống `nginx_service_name: nginx`. |

---

## 8.4. Sử dụng Role trong Playbook và cơ chế Handlers

### 1. Gọi Role từ Playbook

Có hai phong cách gọi Role chính:

**Cách 1: Khai báo qua khối `roles` kinh điển:**

```yaml
---
- name: Trien khai cum Web Application
  hosts: webservers
  become: true
  roles:
    - role: common_base
    - role: nginx
      vars:
        http_port: 8080 # Ghi đè biến mặc định của role nginx
```

**Cách 2: Gọi động thông qua module `include_role` hoặc `import_role` bên trong `tasks`:**

```yaml
---
- name: Trien khai linh hoat
  hosts: webservers
  tasks:
    - name: Chay khoi tao he thong
      ansible.builtin.include_role:
        name: common_base

    - name: Chay cai dat Nginx neu dieu kien thoa man
      ansible.builtin.include_role:
        name: nginx
      when: enable_web_server | default(true)
```

### 2. Cơ chế Handlers và thông báo sự kiện (Event Notification)
- Handlers là các Task đặc biệt chỉ được kích hoạt khi và chỉ khi có một Task thông thường tạo ra **sự thay đổi thực tế trên hệ thống (trạng thái `changed: true`)** và có phát thông báo qua chỉ thị `notify`.
- **Cơ chế hoãn thực thi (Delayed Execution):** Nếu trong Playbook có 5 Task khác nhau cùng gọi `notify: Restart Nginx`, Ansible sẽ gom lại và chỉ thực thi Handler khởi động lại Nginx **đúng một lần duy nhất vào cuối Play**, giúp ngăn chặn việc dịch vụ bị khởi động lại liên tục 5 lần gây gián đoạn mạng.

---

## 8.5. Ansible Collections và Ansible Galaxy

### 1. Ansible Galaxy là gì?
**Ansible Galaxy** (`galaxy.ansible.com`) là kho lưu trữ trung tâm công cộng chính thức của Red Hat dành cho cộng đồng toàn cầu chia sẻ các Ansible Roles và Collections chất lượng cao được kiểm chứng.

Tìm kiếm và tải về Role chất lượng từ Galaxy:

```bash
# Cài đặt Role cấu hình Docker chuẩn từ tác giả geerlingguy
ansible-galaxy install geerlingguy.docker
```

### 2. Ansible Collections là gì?
Trong các phiên bản trước đây, Ansible phân phối mọi thứ dưới dạng Role đơn lẻ. Kể từ kỷ nguyên Ansible Core hiện đại, **Collections** là định dạng đóng gói toàn diện thế hệ mới nhất của Ansible.
Một Collection không chỉ chứa các Roles mà còn đóng gói kèm theo các **Custom Modules**, **Plugins** (Action plugins, Lookup plugins, Filter plugins) và tài liệu hướng dẫn kỹ thuật.

Tải về Collection chuyên dụng:

```bash
# Cài đặt bộ sưu tập quản lý đám mây AWS
ansible-galaxy collection install amazon.aws

# Cài đặt bộ sưu tập quản lý container Docker
ansible-galaxy collection install community.docker
```

Quản lý phụ thuộc tự động qua tệp `requirements.yml`:

```yaml
---
roles:
  - name: geerlingguy.docker
    version: 7.4.0

collections:
  - name: community.general
    version: 8.5.0
```

Cài đặt tự động toàn bộ dependencies: `ansible-galaxy install -r requirements.yml`.

---

## 8.6. Tách Playbook thành các Role theo chức năng

Kỹ thuật chuẩn hóa cấu trúc dự án doanh nghiệp: Tách rời một hệ thống lớn thành các Role chuyên trách:

```text
my-enterprise-project/
├── site.yml                 # Playbook tổng điều phối toàn bộ hạ tầng
├── webservers.yml           # Playbook chỉ định cấu hình riêng cho tầng Web
├── dbservers.yml            # Playbook chỉ định cấu hình riêng cho tầng Database
└── roles/
    ├── common/              # Cài đặt SSH hardening, timezone, ntp, auditd
    ├── nginx/               # Cài đặt và cấu hình Reverse Proxy Nginx
    ├── nodejs/              # Cài đặt môi trường runtime Node.js và PM2
    └── mysql/               # Cài đặt MySQL 8.0, cấu hình buffer pool, backup cron
```

Tệp `site.yml` đóng vai trò nhạc trưởng điều phối:

```yaml
---
# 1. Cấu hình nền tảng cho toàn bộ máy chủ
- import_playbook: common.yml

# 2. Cấu hình máy chủ cơ sở dữ liệu
- import_playbook: dbservers.yml

# 3. Cấu hình máy chủ ứng dụng web
- import_playbook: webservers.yml
```

---

## 8.7. Quản lý Variables cho nhiều môi trường

Thay vì viết cứng biến số vào trong Playbook, phương pháp chuẩn mực của Ansible là sử dụng hai thư mục đặc biệt nằm cùng cấp với Inventory hoặc Playbook:
- `group_vars/`: Chứa các tệp biến áp dụng cho từng nhóm máy chủ.
- `host_vars/`: Chứa các tệp biến áp dụng cho từng máy chủ riêng lẻ.

```text
inventories/production/
├── hosts.ini
├── group_vars/
│   ├── all.yml              # Biến áp dụng cho toàn bộ máy chủ (DNS, NTP)
│   ├── webservers.yml       # Biến áp dụng riêng cho nhóm webservers
│   └── dbservers.yml        # Biến áp dụng riêng cho nhóm dbservers
└── host_vars/
    ├── web-node-01.yml      # Biến riêng cho máy web-node-01 (IP tĩnh đặc thù)
    └── db-primary.yml       # Biến riêng cho máy db-primary (Cấu hình RAM lớn)
```

Nội dung tệp `group_vars/webservers.yml`:
```yaml
---
nginx_http_port: 80
nginx_max_connections: 2048
nginx_ssl_enabled: true
app_environment: production
```

Ansible tự động nhận diện và nạp các tệp biến này một cách thông minh mà không cần khai báo bất kỳ dòng lệnh nạp biến thủ công nào trong Playbook.

---

## 8.8. Tổ chức Repository theo hướng dễ bảo trì và tái sử dụng

Dưới đây là sơ đồ cấu trúc thư mục hoàn chỉnh của một kho mã nguồn Ansible tiêu chuẩn sản xuất (Production-grade Directory Layout) được Red Hat khuyến nghị áp dụng cho các doanh nghiệp:

```text
ansible-infrastructure/
├── ansible.cfg              # Tệp cấu hình trung tâm dự án
├── site.yml                 # Playbook chính điều phối toàn bộ hệ thống
├── requirements.yml         # Danh sách các Role/Collection phụ thuộc từ Galaxy
├── .gitignore               # Loại bỏ tệp tạm, cache và file nhạy cảm
│
├── inventories/             # Quản lý đa môi trường
│   ├── staging/
│   │   ├── hosts.ini
│   │   └── group_vars/
│   │       ├── all.yml
│   │       └── webservers.yml
│   └── production/
│       ├── hosts.ini
│       └── group_vars/
│           ├── all.yml
│           └── webservers.yml
│
└── roles/                   # Các Role nội bộ tự phát triển
    ├── common/
    ├── nginx/
    └── mysql/
```

### Nguyên tắc bảo mật với Ansible Vault:
Để bảo vệ các biến mật khẩu cơ sở dữ liệu hoặc khóa API trong `group_vars/`, sử dụng tiện ích **Ansible Vault** để mã hóa đối xứng tệp tin bằng thuật toán AES-256:

```bash
# Mã hóa tệp chứa thông tin nhạy cảm
ansible-vault encrypt inventories/production/group_vars/db_passwords.yml

# Chỉnh sửa tệp đã mã hóa
ansible-vault edit inventories/production/group_vars/db_passwords.yml

# Thực thi Playbook kèm theo khóa giải mã
ansible-playbook -i inventories/production site.yml --ask-vault-pass
```

---

## 8.9. Thực hành: Xây dựng Role triển khai và cấu hình Nginx hoàn chỉnh

Bài thực hành này sẽ hướng dẫn xây dựng một Role hoàn chỉnh từ đầu, ứng dụng biểu mẫu Jinja2 động, các biến số cấu hình chuẩn mực và cơ chế Handlers thông báo sự kiện.

### Bước 1: Khởi tạo cấu trúc Role

```bash
mkdir -p roles/nginx_server/{defaults,vars,tasks,handlers,templates}
```

### Bước 2: Định nghĩa biến mặc định tại `roles/nginx_server/defaults/main.yml`

```yaml
---
# Cấu hình cổng và thông số mặc định của Nginx
nginx_listen_port: 80
nginx_server_name: localhost
nginx_worker_processes: auto
nginx_worker_connections: 1024
nginx_document_root: /var/www/html
nginx_index_files:
  - index.html
  - index.htm
```

### Bước 3: Tạo tệp biểu mẫu Jinja2 tại `roles/nginx_server/templates/nginx.conf.j2`

```jinja2
# Tệp tin được sinh ra tự động bởi Ansible - Không chỉnh sửa thủ công!
user www-data;
worker_processes {{ nginx_worker_processes }};
pid /run/nginx.pid;

events {
    worker_connections {{ nginx_worker_connections }};
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    sendfile on;
    keepalive_timeout 65;

    server {
        listen {{ nginx_listen_port }};
        server_name {{ nginx_server_name }};

        root {{ nginx_document_root }};
        index {{ nginx_index_files | join(' ') }};

        location / {
            try_files $uri $uri/ =404;
        }

        # Trang trạng thái kiểm tra sức khỏe
        location /health {
            access_log off;
            return 200 "OK - Nginx is healthy on {{ ansible_hostname }}\n";
        }
    }
}
```

### Bước 4: Định nghĩa Handlers tại `roles/nginx_server/handlers/main.yml`

```yaml
---
- name: Restart Nginx
  ansible.builtin.service:
    name: nginx
    state: restarted

- name: Reload Nginx
  ansible.builtin.service:
    name: nginx
    state: reloaded
```

### Bước 5: Viết danh sách Tasks tại `roles/nginx_server/tasks/main.yml`

```yaml
---
- name: 1. Cai dat goi phan mem Nginx Web Server
  ansible.builtin.package:
    name: nginx
    state: present

- name: 2. Tao thu muc Document Root neu chua ton tai
  ansible.builtin.file:
    path: "{{ nginx_document_root }}"
    state: directory
    owner: www-data
    group: www-data
    mode: '0755'

- name: 3. Sinh tap tin cau hinh chinh tu bieu mau Jinja2
  ansible.builtin.template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
    owner: root
    group: root
    mode: '0644'
    validate: nginx -t -c %s
  notify: Reload Nginx

- name: 4. Tao trang chu index.html mau
  ansible.builtin.copy:
    dest: "{{ nginx_document_root }}/index.html"
    content: |
      <!DOCTYPE html>
      <html>
      <head><title>Nginx Role Managed by Ansible</title></head>
      <body>
        <h1>Deploy Nginx qua Ansible Role thanh cong!</h1>
        <p>Managed Node: {{ ansible_nodename }}</p>
        <p>Operating System: {{ ansible_distribution }} {{ ansible_distribution_version }}</p>
      </body>
      </html>
    owner: www-data
    group: www-data
    mode: '0644'

- name: 5. Dam bao dich vu Nginx dang chay va bat khoi dong cung OS
  ansible.builtin.service:
    name: nginx
    state: started
    enabled: yes
```

### Bước 6: Khởi tạo Playbook điều phối `deploy-app.yml`

```yaml
---
- name: Kich hoat trien khai cum Web Servers bang Ansible Role
  hosts: webservers
  become: true
  roles:
    - role: roles/nginx_server
      vars:
        nginx_listen_port: 8080
        nginx_server_name: web.company.local
```

### Bước 7: Thực thi và kiểm tra kết quả

```bash
# Thực thi Playbook
ansible-playbook -i inventory.ini deploy-app.yml

# Kiểm tra kết quả truy vấn HTTP thực tế trên máy đích
curl -i http://192.168.1.11:8080/health
```

Kết quả phản hồi HTTP chuẩn mực:
```text
HTTP/1.1 200 OK
Server: nginx
Content-Type: text/plain
Connection: keep-alive

OK - Nginx is healthy on web-node-01
```

Toàn bộ hệ thống máy chủ đã được cài đặt, tinh chỉnh cấu hình và đưa vào vận hành tự động thông qua cấu trúc Ansible Role hoàn chỉnh, đạt chuẩn mực chuyên nghiệp của kỹ sư DevOps.

---

# PHẦN 3: TỔNG QUAN VỀ DEVSECOPS VÀ BẢO MẬT CI/CD PIPELINE

# 9. Mục 9: Tổng quan về DevSecOps

## 9.1. Khái niệm DevSecOps và Triết lý Shift Left Security

Trong mô hình DevOps truyền thống, mục tiêu trọng tâm thường là tối đa hóa tốc độ phát hành tính năng và tần suất triển khai. Tuy nhiên, yếu tố an toàn thông tin thường bị đẩy xuống giai đoạn cuối cùng của chu trình phát triển sản phẩm (SDLC - Software Development Life Cycle), ngay trước khi hệ thống chuẩn bị Go-live đưa lên môi trường Production.

### Rào cản của mô hình bảo mật truyền thống:
- **Nút thắt cổ chai ở cuối quy trình:** Đội ngũ chuyên gia bảo mật đóng vai trò như người gác cổng. Họ nhận bản phát hành hoàn chỉnh, tiến hành đánh giá xâm nhập hoặc rà quét lỗ hổng thủ công. Quá trình này mất từ vài tuần đến cả tháng, làm tê liệt toàn bộ tốc độ phát hành của DevOps.
- **Chi phí khắc phục khổng lồ:** Khi một lỗ hổng kiến trúc nghiêm trọng (ví dụ thiết kế sai mô hình xác thực hoặc thư viện cốt lõi có lỗ hổng thực thi mã từ xa) bị phát hiện ở môi trường Production, lập trình viên buộc phải đập đi xây lại mã nguồn từ đầu, dẫn đến chi phí khắc phục tăng theo cấp số nhân.
- **Sự đối đầu văn hóa:** Dev và Ops xem Security là rào cản ngăn chặn sự đổi mới, trong khi Security xem Dev và Ops là những người cẩu thả, tạo ra các hệ thống chứa đầy rủi ro.

```text
MÔ HÌNH TRUYỀN THỐNG (BẢO MẬT ĐẶT Ở CUỐI):
Plan ──► Code ──► Build ──► Test ──► Release ──► Deploy ──► [SECURITY AUDIT] ──► Production
                                                                    ▲
                                                  Nút thắt cổ chai, chặn release

MÔ HÌNH DEVSECOPS (SHIFT LEFT SECURITY):
  ┌────────────┐   ┌────────────┐   ┌────────────┐   ┌────────────┐   ┌────────────┐
  │    Plan    │   │    Code    │   │   Build    │   │    Test    │   │   Deploy   │
  └─────┬──────┘   └─────┬──────┘   └─────┬──────┘   └─────┬──────┘   └─────┬──────┘
        ▼                 ▼                 ▼                 ▼                 ▼
  Threat Modeling   IDE Linting /     SCA / SAST /     DAST / IAST /     Runtime Security
  Risk Assessment   Secret Scan       Image Scan       Security Gates    Cloud Compliance
```

### Triết lý Shift Left Security:
**Shift Left (Dịch chuyển về bên trái)** là nguyên lý cốt lõi của DevSecOps. Triết lý này yêu cầu tích hợp các biện pháp kiểm soát, đánh giá và thực thi an toàn thông tin ngay từ những bước đầu tiên của vòng đời phát triển phần mềm:
1. **Giai đoạn Lập kế hoạch (Plan):** Phân tích mô hình đe dọa (Threat Modeling), xác định các yêu cầu tuân thủ bảo mật và tiêu chuẩn an toàn cho kiến trúc hệ thống.
2. **Giai đoạn Viết mã (Code):** Sử dụng các plugin IDE để cảnh báo lỗi bảo mật ngay khi lập trình viên gõ code, thiết lập pre-commit hooks để ngăn chặn lập trình viên vô tình commit các thông tin nhạy cảm như mật khẩu, API key, token.
3. **Giai đoạn Đóng gói (Build):** Tự động phân tích mã nguồn tĩnh (SAST), kiểm tra các thành phần phụ thuộc của bên thứ ba (SCA) và quét lỗ hổng trong ảnh container.
4. **Giai đoạn Kiểm thử (Test):** Kiểm thử động (DAST), kiểm tra tương tác runtime (IAST) và xác thực tính toàn vẹn của cấu hình hạ tầng.
5. **Giai đoạn Vận hành (Operate):** Giám sát bảo mật thời gian thực, quản lý tuân thủ cấu hình trên môi trường đám mây và phản ứng sự cố tự động.

### Sơ đồ so sánh chi phí khắc phục lỗ hổng theo thời gian:
Nghiên cứu của Viện Tiêu chuẩn và Kỹ thuật Quốc gia Mỹ (NIST) và Viện Công nghệ Phần mềm IBM chỉ ra rằng chi phí để khắc phục một lỗi bảo mật tăng vọt theo cấp số nhân nếu phát hiện càng muộn:

```text
CHI PHÍ KHẮC PHỤC
  ▲
$ │                                                                [Giai đoạn Vận hành]
  │                                                                 Chi phí gấp 30-100x
  │                                                                       ▲
  │                                                                      ╱│
  │                                                [Giai đoạn Test]     ╱ │
  │                                                Chi phí gấp 15x     ╱  │
  │                                                      ▲            ╱   │
  │                                [Giai đoạn Build]    ╱│           ╱    │
  │                                Chi phí gấp 4-6x    ╱ │          ╱     │
  │        [Giai đoạn Code]              ▲            ╱  │         ╱      │
  │        Chi phí cơ sở (1x)           ╱│           ╱   │        ╱       │
  │              ▲                     ╱ │          ╱    │       ╱        │
0 └──────────────┴────────────────────┴──┴─────────┴─────┴──────┴─────────┴────────►
              Viết Code               Đóng gói          Kiểm thử        Production
```

---

## 9.2. Triết lý Bảo mật dưới dạng mã (Security as Code) và Cổng bảo mật (Security Gate)

### 1. Bảo mật dưới dạng mã (Security as Code - SaC)
Bảo mật dưới dạng mã là phương pháp định nghĩa các chính sách, quy tắc và kiểm soát an ninh mạng thông qua các tệp tin cấu hình văn bản thuần thay vì các tài liệu hướng dẫn bằng lời văn hay các thao tác kiểm tra thủ công.

#### Lợi ích vượt trội của Security as Code:
- **Tự động hóa hoàn toàn:** Các chính sách an ninh được nhúng trực tiếp vào CI/CD Pipeline để tự động thực thi trên mỗi lượt commit hoặc merge request.
- **Quản lý phiên bản qua Git:** Mọi sự thay đổi về chính sách bảo mật đều được ghi nhận bằng Git commit, có thể đối soát (Audit trail), phê duyệt qua Pull Request và phục hồi về phiên bản trước khi cần thiết.
- **Nhất quán trên mọi môi trường:** Đảm bảo chính sách bảo mật áp dụng cho môi trường Development, Staging và Production là hoàn toàn đồng nhất, loại bỏ sự sai lệch cấu hình an toàn.

### 2. Cổng bảo mật (Security Gate)
**Security Gate** là một cơ chế rào chắn kỹ thuật tự động được thiết lập tại các điểm chuyển tiếp quan trọng trong CI/CD Pipeline. 

Mục tiêu của Security Gate là đưa ra quyết định **Cho phép (Pass)** hoặc **Chặn đứng (Fail/Block)** luồng triển khai dựa trên các tiêu chí ngưỡng chấp nhận rủi ro đã được định nghĩa trước.

```text
                          LUỒNG HOẠT ĐỘNG CỦA SECURITY GATE
                          
               ┌──────────────────────────────────────────────┐
               │              MÃ NGUỒN / CONTAINER            │
               └──────────────────────┬───────────────────────┘
                                      │
                                      ▼
               ┌──────────────────────────────────────────────┐
               │    CÔNG CỤ QUÉT BẢO MẬT TỰ ĐỘNG (SCANNER)    │
               │   - Gitleaks (Secrets)                       │
               │   - SonarQube (SAST Code Quality)            │
               │   - Trivy (Vulnerabilities CVE & IaC)        │
               └──────────────────────┬───────────────────────┘
                                      │
                                      ▼
                        ┌───────────────────────────┐
                        │       SECURITY GATE       │
                        │ Tiêu chí:                 │
                        │ - 0 Lỗ hổng CRITICAL      │
                        │ - 0 Lỗ hổng HIGH          │
                        │ - 0 Bí mật bị rò rỉ       │
                        │ - Test Coverage >= 80%    │
                        └───────┬───────────┬───────┘
                                │           │
                        ĐẠT     │           │   KHÔNG ĐẠT
                   (PASS)       │           │   (FAIL)
                                ▼           ▼
           ┌──────────────────────┐       ┌─────────────────────────────────────┐
           │ TIẾP TỤC TRIỂN KHAI  │       │     CHẶN ĐỨNG PIPELINE TỰ ĐỘNG      │
           │ Đóng gói & Deploy VM │       │ Báo động đỏ, gửi thông báo Slack    │
           │                      │       │ Từ chối Merge Code vào main         │
           └──────────────────────┘       └─────────────────────────────────────┘
```

---

## 9.3. Các rủi ro an toàn thông tin tiềm ẩn trong quy trình CI/CD

Môi trường CI/CD sở hữu đặc quyền truy cập rất cao trong hạ tầng doanh nghiệp: Nó kết nối với kho mã nguồn nội bộ, máy chủ đăng ký container, máy chủ đám mây và cơ sở dữ liệu production. Do đó, hệ thống CI/CD là mục tiêu tấn công hàng đầu của tin tặc.

### 5 rủi ro an toàn thông tin nghiêm trọng nhất trong CI/CD:

1. **Rò rỉ thông tin nhạy cảm và bí mật hệ thống (Hardcoded Secrets Leakage):**
   - Lập trình viên vô tình ghi cứng các chuỗi nhạy cảm (API Keys, Passwords, Token truy cập AWS/GCP, SSH Private Keys) vào mã nguồn để kiểm thử cục bộ rồi đẩy lên kho mã.
   - Thậm chí khi lập trình viên xóa bí mật ở commit sau, thông tin nhạy cảm vẫn tồn tại vĩnh viễn trong lịch sử Git history của kho lưu trữ.
   - Các bí mật cũng có thể bị lộ thông qua tệp nhật ký thực thi của các tác vụ trong Pipeline.

2. **Máy chủ thực thi Pipeline bị thỏa hiệp (Compromised CI/CD Runner / Agent):**
   - Runner thường được cấu hình với đặc quyền rất lớn để build phần mềm. Rủi ro đặc biệt nghiêm trọng xảy ra khi Runner gắn kết trực tiếp tệp socket của Docker (`/var/run/docker.sock`) vào container thực thi tác vụ.
   - Kẻ tấn công có thể lợi dụng kịch bản kiểm thử độc hại để tương tác với Docker socket, thoát khỏi container và chiếm toàn quyền điều khiển trên máy chủ vật lý chứa Runner.

3. **Nhiễm độc Pipeline và thực thi mã tùy ý (Pipeline Poisoning / CI/CD Injection):**
   - Xảy ra khi tệp tin cấu hình pipeline (`.gitlab-ci.yml`, `.github/workflows/*.yml`) xử lý các dữ liệu đầu vào không an toàn (ví dụ tên nhánh git, nội dung commit message, hoặc tham số từ pull request bên ngoài).
   - Tin tặc có thể gửi một Pull Request với tiêu đề chứa các ký tự điều khiển shell để ép runner thực thi mã độc, trích xuất toàn bộ biến môi trường bí mật và gửi ra máy chủ điều khiển bên ngoài.

4. **Nhiễm độc chuỗi cung ứng qua các gói phụ thuộc (Dependency Poisoning / Typosquatting):**
   - Ứng dụng hiện đại nhập hàng trăm gói thư viện từ kho công cộng (npm, PyPI, Maven, Go proxy).
   - Tin tặc đăng ký các gói có tên gần giống với thư viện phổ biến (Typosquatting) hoặc chiếm quyền kiểm soát tài khoản của các lập trình viên mã nguồn mở để chèn mã độc vào các bản cập nhật mới.

5. **Phân quyền truy cập quá mức (Over-privileged Access & Permissions):**
   - Tài khoản dịch vụ cấp cho CI/CD Runner thường bị gán quyền Quản trị tối cao trên nền tảng Cloud hoặc máy chủ đích để thuận tiện cho việc triển khai.
   - Khi runner bị xâm nhập, kẻ tấn công nắm được quyền kiểm soát toàn bộ hạ tầng doanh nghiệp.

---

## 9.4. Tổng quan OWASP Top 10 và An toàn chuỗi cung ứng phần mềm (Software Supply Chain Security)

### 1. Tổng quan OWASP Top 10
Dự án Bảo mật Ứng dụng Web Mở (Open Web Application Security Project - OWASP) là tổ chức phi lợi nhuận uy tín hàng đầu thế giới về an ninh ứng dụng. Danh mục OWASP Top 10 tổng hợp 10 nhóm lỗ hổng bảo mật ứng dụng web phổ biến và nguy hiểm nhất:

| Mã số | Tên nhóm lỗ hổng | Mô tả bản chất | Hậu quả thực tế |
| :--- | :--- | :--- | :--- |
| **A01:2021** | **Broken Access Control** | Người dùng có thể truy cập các tài nguyên hoặc thực hiện các thao tác vượt quá quyền hạn của họ. | Người dùng bình thường xem được dữ liệu của tài khoản khác hoặc thao tác quyền quản trị viên. |
| **A02:2021** | **Cryptographic Failures** | Dữ liệu nhạy cảm không được mã hóa hoặc sử dụng các thuật toán mã hóa lỗi thời, yếu (MD5, SHA1). | Lộ lọt mật khẩu, số thẻ tín dụng, dữ liệu cá nhân khi đường truyền hoặc cơ sở dữ liệu bị nghe lén. |
| **A03:2021** | **Injection** | Dữ liệu không tin cậy từ người dùng được gửi trực tiếp tới trình thông dịch lệnh (SQL Injection, OS Command Injection). | Kẻ tấn công trích xuất toàn bộ cơ sở dữ liệu hoặc thực thi lệnh shell tùy ý trên máy chủ. |
| **A04:2021** | **Insecure Design** | Khiếm khuyết ngay từ khâu thiết kế kiến trúc hệ thống, thiếu sót mô hình đe dọa và kiểm soát nghiệp vụ. | Lỗ hổng logic cho phép người dùng lạm dụng tính năng hoàn tiền nhiều lần, vét sạch tài nguyên. |
| **A05:2021** | **Security Misconfiguration** | Bật các tính năng không cần thiết, để mật khẩu mặc định, mở cổng dịch vụ thừa, hiển thị chi tiết stack trace. | Tin tặc lợi dụng thông tin chi tiết hệ thống để khai thác sâu hoặc đăng nhập với tài khoản mặc định. |
| **A06:2021** | **Vulnerable and Outdated Components** | Sử dụng các thư viện, framework bên thứ ba đã phát hiện lỗ hổng nhưng không được cập nhật bản vá. | Khai thác lỗ hổng đã được công bố công khai (ví dụ lỗ hổng Log4j) để chiếm quyền điều khiển. |
| **A07:2021** | **Identification and Authentication Failures** | Cho phép tấn công vét cạn brute-force, quản lý phiên làm việc yếu kém, không hỗ trợ xác thực đa yếu tố. | Đánh cắp phiên đăng nhập hoặc chiếm đoạt tài khoản người dùng cấp cao. |
| **A08:2021** | **Software and Data Integrity Failures** | Ứng dụng tin cậy các plugin, thư viện hoặc bản cập nhật từ nguồn không được ký số xác thực. | Cài đặt phải các bản cập nhật độc hại từ kênh phân phối không chính thống. |
| **A09:2021** | **Security Logging and Monitoring Failures** | Không ghi log các sự kiện bảo mật quan trọng, không có cơ chế cảnh báo thời gian thực khi bị tấn công. | Kẻ tấn công nằm vùng trong hệ thống nhiều tháng liền mà không bị phát hiện và ngăn chặn. |
| **A10:2021** | **Server-Side Request Forgery (SSRF)** | Ứng dụng web tải tài nguyên từ xa theo URL do người dùng cung cấp mà không kiểm tra địa chỉ đích. | Kẻ tấn công ép máy chủ truy vấn dịch vụ metadata nội bộ của cloud (169.254.169.254) để lấy IAM token. |

### 2. An toàn chuỗi cung ứng phần mềm (Software Supply Chain Security)
Trong kỷ nguyên phát triển phần mềm hiện đại, lập trình viên không còn tự viết 100% mã nguồn từ con số không. Ước tính có tới **70% - 90% thành phần của một ứng dụng doanh nghiệp là mã nguồn mở và thư viện của bên thứ ba**.

```text
CHUỖI CUNG ỨNG PHẦN MỀM HIỆN ĐẠI:
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│  Mã nguồn gốc   │ ────► │  Kho phụ thuộc  │ ────► │ Hệ thống CI/CD  │ ────► │  Hạ tầng Đích   │
│  Lập trình viên │       │   npm / PyPI    │       │ Runner / Build  │       │  Production VM  │
└─────────────────┘       └─────────────────┘       └─────────────────┘       └─────────────────┘
         ▲                         ▲                         ▲                         ▲
         │                         │                         │                         │
    Rò rỉ Secret,            Gói phụ thuộc             Runner bị chiếm          Cấu hình sai,
    mã độc từ commit         chứa Trojan / CVE         quyền, rò rỉ token        lộ cổng dịch vụ
```

#### Các vụ tấn công chuỗi cung ứng điển hình trên thế giới:
- **Sự cố SolarWinds (2020):** Tin tặc thâm nhập vào hệ thống biên dịch mã nguồn của nhà cung cấp, chèn backdoor vào bản cập nhật phần mềm Orion chính thống được ký số hợp lệ, gây ảnh hưởng tới hơn 18.000 tổ chức trên toàn cầu bao gồm cả chính phủ Mỹ.
- **Lỗ hổng Log4j / Log4Shell (2021):** Một lỗ hổng thực thi mã từ xa mức nghiêm trọng 10.0 trong thư viện ghi log Java phổ biến hàng đầu thế giới khiến hàng triệu máy chủ toàn cầu bị đe dọa chỉ sau một đêm.
- **Sự cố công cụ Codecov (2021):** Tin tặc sửa đổi đoạn script bash tải công cụ kiểm tra độ bao phủ mã nguồn trong CI/CD pipeline để đánh cắp hàng triệu thông tin bí mật và khóa API của các doanh nghiệp sử dụng dịch vụ.

#### Các giải pháp phòng thủ chuỗi cung ứng:
1. **Quản lý danh mục thành phần phần mềm (SBOM - Software Bill of Materials):** Tạo danh mục kê khai toàn bộ thư viện, phiên bản và mã băm cấu thành nên ứng dụng (chuẩn SPDX hoặc CycloneDX).
2. **Ký số và xác thực hình ảnh (Image Signing & Verification):** Sử dụng công cụ mã nguồn mở như **Sigstore / Cosign** để ký số ảnh container ngay sau khi build trong Pipeline và chỉ cho phép máy chủ chạy những ảnh có chữ ký số hợp lệ.
3. **Sử dụng kho lưu trữ đại diện nội bộ (Private Mirror / Proxy Registry):** Khóa quyền tải trực tiếp từ internet công cộng, ép toàn bộ quá trình build phải thông qua kho lưu trữ proxy nội bộ (Nexus, Artifactory, Harbor) có tích hợp quét mã độc tự động.

---

# 10. Mục 10: Tích hợp Security vào CI/CD Pipeline

## 10.1. Các phương pháp kiểm thử bảo mật: SAST, DAST, SCA và IAST

Để xây dựng một quy trình kiểm thử bảo mật toàn diện trong CI/CD Pipeline, các kỹ sư DevSecOps kết hợp 4 phương pháp kiểm tra an toàn then chốt:

```text
┌──────────────────────────────────────────────────────────────────────────────────────────┐
│                   HỆ SINH THÁI KIỂM THỬ BẢO MẬT TOÀN DIỆN (DEVSECOPS)                     │
├──────────────────────────┬───────────────────────────┬───────────────────────────────────┤
│    GIAI ĐOẠN BIÊN DỊCH   │    GIAI ĐOẠN ĐÓNG GÓI     │       GIAI ĐOẠN VẬN HÀNH          │
│     (TRƯỚC RUNTIME)      │     (CONTAINER / ARTIFACT)│        (ĐANG CHẠY THỰC TẾ)        │
├──────────────────────────┼───────────────────────────┼───────────────────────────────────┤
│  ┌────────────────────┐  │   ┌────────────────────┐  │       ┌────────────────────┐      │
│  │     SAST           │  │   │     SCA & IMAGE    │  │       │     DAST & IAST    │      │
│  │ Quét mã nguồn tĩnh │  │   │ Quét thư viện phụ  │  │       │ Quét ứng dụng đang │      │
│  │ (SonarQube/Semgrep)│  │   │ thuộc & CVE Docker │  │       │ chạy qua HTTP API  │      │
│  │                    │  │   │ (Trivy / Snyk)     │  │       │ (OWASP ZAP)        │      │
│  └────────────────────┘  │   └────────────────────┘  │       └────────────────────┘      │
└──────────────────────────┴───────────────────────────┴───────────────────────────────────┘
```

### Bảng so sánh chuyên sâu 4 phương pháp kiểm thử:

| Tiêu chí so sánh | SAST (Static Testing) | DAST (Dynamic Testing) | SCA (Composition Analysis) | IAST (Interactive Testing) |
| :--- | :--- | :--- | :--- | :--- |
| **Đối tượng kiểm tra** | Mã nguồn gốc, mã bytecode hoặc nhị phân. | Ứng dụng hoàn chỉnh đang chạy trên môi trường test/staging. | Các tệp khai báo thư viện bên thứ ba (`package.json`, `pom.xml`). | Ứng dụng đang chạy có cài đặt Agent đo kiểm nội bộ. |
| **Phương thức tiếp cận** | Kiểm thử hộp trắng - Phân tích cấu trúc mã nguồn. | Kiểm thử hộp đen - Gửi payload thử nghiệm qua mạng. | Kiểm tra đối chiếu cơ sở dữ liệu lỗ hổng đã biết (CVE/NVD). | Kết hợp hộp trắng và hộp đen (Gray-box Testing). |
| **Thời điểm thực thi** | Giai đoạn sớm trước khi biên dịch mã. | Giai đoạn muộn khi đã có server test chạy thực tế. | Giai đoạn chuẩn bị phụ thuộc hoặc build image. | Giai đoạn chạy Automated Integration / E2E Tests. |
| **Phạm vi phát hiện** | Lỗi lập trình, tràn bộ đệm, SQL Injection, rò rỉ bộ nhớ. | Lỗi xác thực, cấu hình máy chủ sai, lỗi phân quyền runtime. | Lỗ hổng trong thư viện bên ngoài, vi phạm giấy phép phần mềm. | Phát hiện luồng dữ liệu độc hại chính xác tới từng dòng mã khi chạy. |
| **Tỷ lệ báo động giả** | Tương đối cao (thường cần cấu hình bộ lọc loại trừ). | Rất thấp (vì lỗ hổng phải khai thác thành công mới báo). | Rất thấp (dựa trên phiên bản chính xác của gói). | Cực thấp (phân tích trực tiếp luồng thực thi trong bộ nhớ). |
| **Công cụ phổ biến** | SonarQube, Semgrep, Checkmarx, Bandit. | OWASP ZAP, Burp Suite, Nuclei, Acunetix. | Trivy, Snyk, Dependabot, OWASP Dependency-Check. | Contrast Security, Synopsys Seeker, Veracode. |

---

## 10.2. Kỹ thuật quét lỗ hổng ảnh Docker (Container Image Scanning)

### 1. Bản chất cấu trúc nhiều lớp của Image và nguồn gốc lỗ hổng
Một ảnh Docker hoàn chỉnh được tạo thành từ nhiều lớp (Layers) xếp chồng lên nhau thông qua cấu trúc hệ thống tệp hợp nhất:
- **Lớp hệ điều hành cơ sở (Base OS Layer):** Chứa các gói nhị phân và thư viện lõi của Linux (như `glibc`, `openssl`, `curl`, `busybox`). Đây là nơi phát sinh phần lớn các lỗ hổng CVE nghiêm trọng nếu người dùng sử dụng các bản phân phối cũ hoặc không được cập nhật vá lỗi thường xuyên.
- **Lớp phần mềm trung gian (Runtime Layer):** Chứa Node.js, Python, OpenJDK,...
- **Lớp mã nguồn ứng dụng (Application Layer):** Chứa mã nghiệp vụ và các gói phụ thuộc do lập trình viên thêm vào.

```text
CẤU TRÚC LỚP ẢNH DOCKER VÀ ĐIỂM QUÉT AN TOÀN:
┌────────────────────────────────────────────────────────┐
│ Layer 4: Mã nguồn ứng dụng & cấu hình                  │ ◄── Quét Secret / Config misconfiguration
├────────────────────────────────────────────────────────┤
│ Layer 3: Thư viện bên thứ ba (npm/pip/maven)           │ ◄── Quét SCA (Lỗ hổng CVE thư viện)
├────────────────────────────────────────────────────────┤
│ Layer 2: Môi trường thực thi (Python 3.11 / Node 20)   │ ◄── Quét CVE Runtime
├────────────────────────────────────────────────────────┤
│ Layer 1: Hệ điều hành gốc (Debian / Ubuntu / Alpine)   │ ◄── Quét lỗ hổng hệ điều hành gốc (OS CVEs)
└────────────────────────────────────────────────────────┘
```

### 2. Cơ chế quét tự động của công cụ quét ảnh (Image Scanner)
1. **Giải nén các lớp ảnh:** Công cụ (như Trivy) trích xuất nội dung của từng layer trong image tarball.
2. **Thu thập danh mục phần mềm:** Quét các tệp quản lý gói hệ thống (như `/var/lib/dpkg/status` trên Debian, `/lib/apk/db/installed` trên Alpine, tệp RPM database trên RedHat) và các tệp định danh thư viện ngôn ngữ.
3. **Đối chiếu cơ sở dữ liệu lỗ hổng:** So sánh tên gói và phiên bản với cơ sở dữ liệu lỗ hổng bảo mật toàn cầu được cập nhật liên tục từ NVD (National Vulnerability Database), GitHub Security Advisory, Debian Security Tracker, Red Hat Security Data.
4. **Đánh giá mức độ rủi ro:** Xếp loại lỗ hổng theo chuẩn điểm định lượng rủi ro CVSS (Common Vulnerability Scoring System) thành 4 mức: `LOW`, `MEDIUM`, `HIGH`, `CRITICAL`.

### 3. Các thực hành tối ưu để giảm thiểu lỗ hổng ảnh Docker:
- **Sử dụng ảnh cơ sở tối giản (Minimal / Distroless Images):** Thay vì sử dụng `ubuntu:latest` (dung lượng lớn với hàng trăm tiện ích không cần thiết), hãy chuyển sang sử dụng `alpine` (dung lượng nhỏ) hoặc ảnh Google Distroless (chỉ chứa ứng dụng và thư viện runtime tối thiểu, không có shell `/bin/sh` hay trình quản lý gói `apt/apk`, khiến tin tặc không thể thực thi lệnh khi chiếm được container).
- **Áp dụng kỹ thuật Multi-stage Builds:** Sử dụng một container lớn có đầy đủ trình biên dịch (SDK, gcc, maven) để build ứng dụng ở stage 1, sau đó chỉ sao chép tệp nhị phân cuối cùng sang một container tối giản ở stage 2 để chạy thực tế.
- **Chạy ứng dụng với người dùng không có quyền quản trị (Non-root user):** Luôn khai báo chỉ thị `USER nonroot` hoặc `USER 10001` trong Dockerfile. Nếu container bị tấn công khai thác, kẻ tấn công cũng không có quyền root trên hệ thống tệp của container.

---

## 10.3. Tích hợp các công cụ bảo mật tiêu chuẩn vào Pipeline: SonarQube, Trivy, Gitleaks

### 1. Gitleaks - Phát hiện rò rỉ bí mật và thông tin nhạy cảm
**Gitleaks** là công cụ mã nguồn mở dựa trên ngôn ngữ Go, có tốc độ xử lý siêu nhanh, chuyên dụng để phát hiện mật khẩu, khóa API, token xác thực, private keys bị bỏ quên trong mã nguồn hoặc lịch sử commit của Git.

#### Cấu hình mẫu tệp luật `.gitleaks.toml`:
```toml
title = "Company Custom Gitleaks Rules"

[[rules]]
id = "generic-api-key"
description = "Phat hien API Key chung bi lo trong ma nguon"
regex = '''(?i)(api_key|apikey|secret_key|app_secret)\s*[:=]\s*['"][0-9a-zA-Z\-_]{16,}['"]'''
entropy = 3.5
secretGroup = 1

[[rules]]
id = "private-key"
description = "Phat hien khoa bi mat SSH / RSA Private Key"
regex = '''-----BEGIN (RSA|OPENSSH|DSA|EC|PGP) PRIVATE KEY-----'''

[whitelist]
description = "Bo qua cac thu muc kiem thu va tep tai lieu mau"
paths = [
  '''tests/.*''',
  '''docs/.*'''
]
```

#### Lệnh thực thi kiểm tra với Gitleaks CLI:
```bash
# Quét toàn bộ lịch sử commit trong kho mã hiện tại
gitleaks detect --source . --verbose --redact

# Quét bảo vệ trước khi commit mã nguồn (Pre-commit)
gitleaks protect --staged --verbose
```

---

### 2. SonarQube - Đánh giá chất lượng và kiểm thử bảo mật tĩnh (SAST)
**SonarQube** là nền tảng quản lý chất lượng và bảo mật mã nguồn toàn diện. SonarQube tự động phân tích mã nguồn để phát hiện:
- **Bugs:** Lỗi logic có thể làm sập ứng dụng.
- **Vulnerabilities:** Lỗ hổng bảo mật nghiêm trọng (SQLi, XSS, Path Traversal).
- **Security Hotspots:** Các đoạn mã nhạy cảm cần sự kiểm duyệt của chuyên gia bảo mật (ví dụ cấu hình mã hóa, tạo số ngẫu nhiên).
- **Code Smells:** Mã nguồn luộm thuộm, khó bảo trì.
- **Test Coverage:** Tỷ lệ bao phủ kiểm thử tự động.

#### Cấu hình tệp định danh dự án `sonar-project.properties`:
```properties
sonar.projectKey=ecommerce-web-service
sonar.projectName=E-Commerce Core API
sonar.projectVersion=1.0.0

# Duong dan toi thu muc ma nguon can quet
sonar.sources=src
sonar.tests=tests

# Loai bo cac tep sinh ra tu dong hoac thu vien ngoai
sonar.exclusions=**/node_modules/**,**/dist/**,**/build/**

# Khai bao duong dan bao cao kiem thu coverage
sonar.javascript.lcov.reportPaths=coverage/lcov.info

# Thiet lap ma hoa ky tu
sonar.sourceEncoding=UTF-8
```

---

### 3. Trivy - Nền tảng quét lỗ hổng toàn diện
**Trivy** (phát triển bởi Aqua Security) là công cụ quét an ninh toàn diện và phổ biến nhất hiện nay cho hạ tầng Cloud-Native. Trivy có khả năng quét:
- **Ảnh Container (Container Images):** Quét hệ điều hành gốc và các thư viện ngôn ngữ bên trong image.
- **Hệ thống tệp (Filesystem / Repository):** Quét thư mục dự án để tìm lỗ hổng phụ thuộc (SCA).
- **Hạ tầng dưới dạng mã (IaC Misconfiguration):** Quét tệp Dockerfile, Terraform, Kubernetes YAML để tìm cấu hình không an toàn (ví dụ mở cổng nhạy cảm, chạy container dưới quyền root).

#### Các lệnh thực thi tiêu chuẩn với Trivy CLI:
```bash
# 1. Quét lo hong trong anh Docker va xuat ket qua chi tiet
trivy image --severity HIGH,CRITICAL my-app:latest

# 2. Quet tap tin cau hinh Dockerfile tim loi cau hinh sai
trivy config ./Dockerfile

# 3. Quet thu muc du an va sinh bao cao chuan dinh dang JSON/HTML
trivy fs --format json --output trivy-report.json .
```

---

### 4. Kịch bản tích hợp hoàn chỉnh vào CI/CD Pipeline (GitLab CI & GitHub Actions)

#### A. Kịch bản mẫu cho GitLab CI (`.gitlab-ci.yml`):
```yaml
stages:
  - secret-scan
  - sast
  - build
  - container-scan
  - deploy

# Stage 1: Quét rò rỉ secret bằng Gitleaks
gitleaks-scan:
  stage: secret-scan
  image:
    name: zricethezav/gitleaks:latest
    entrypoint: [""]
  script:
    - gitleaks detect --source . --verbose --redact
  allow_failure: false

# Stage 2: Phân tích bảo mật tĩnh bằng SonarQube Scanner
sonarqube-sast:
  stage: sast
  image:
    name: sonarsource/sonar-scanner-cli:latest
    entrypoint: [""]
  variables:
    SONAR_USER_HOME: "${CI_PROJECT_DIR}/.sonar"
    GIT_DEPTH: "0"
  script:
    - sonar-scanner -Dsonar.host.url="${SONAR_HOST_URL}" -Dsonar.token="${SONAR_TOKEN}"
  allow_failure: false

# Stage 3: Đóng gói ảnh Docker ứng dụng
build-docker-image:
  stage: build
  image: docker:24.0.5
  services:
    - docker:24.0.5-dind
  script:
    - docker login -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD" $CI_REGISTRY
    - docker build -t "$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA" -t "$CI_REGISTRY_IMAGE:latest" .
    - docker push "$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA"
    - docker push "$CI_REGISTRY_IMAGE:latest"

# Stage 4: Quét lỗ hổng Container Image bằng Trivy (Security Gate)
trivy-image-scan:
  stage: container-scan
  image:
    name: aquasec/trivy:latest
    entrypoint: [""]
  variables:
    TRIVY_NO_PROGRESS: "true"
    TRIVY_CACHE_DIR: ".trivycache/"
  script:
    # Quét hiển thị toàn bộ cảnh báo
    - trivy image --exit-code 0 --severity UNKNOWN,LOW,MEDIUM,HIGH "$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA"
    # Cổng bảo mật: Chặn đứng Pipeline (exit code 1) nếu phát hiện lỗ hổng CRITICAL
    - trivy image --exit-code 1 --severity CRITICAL --ignore-unfixed "$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA"
  cache:
    paths:
      - .trivycache/
  allow_failure: false

# Stage 5: Triển khai ứng dụng lên máy chủ Production
deploy-to-production:
  stage: deploy
  image: alpine:3.18
  before_script:
    - apk add --no-cache openssh-client
  script:
    - echo "Tat ca cac cong kiem tra an ninh deu da PASS thanh cong!"
    - echo "Tien hanh kich hoat kich ban Ansible trien khai cap nhat VM Production..."
  only:
    - main
```

#### B. Kịch bản mẫu cho GitHub Actions (`.github/workflows/devsecops-pipeline.yml`):
```yaml
name: DevSecOps Automated Security Pipeline

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  secret-scan:
    name: Secret Leakage Detection
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Run Gitleaks Scanner
        uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  sast-analysis:
    name: SonarQube SAST Code Analysis
    runs-on: ubuntu-latest
    needs: secret-scan
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: SonarQube Scan
        uses: SonarSource/sonarqube-scan-action@master
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
          SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}

  build-and-scan-image:
    name: Build and Container Scan
    runs-on: ubuntu-latest
    needs: sast-analysis
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build Local Image
        run: |
          docker build -t my-company-app:${{ github.sha }} .

      - name: Run Trivy Security Gate
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'my-company-app:${{ github.sha }}'
          format: 'table'
          exit-code: '1'
          ignore-unfixed: true
          vuln-type: 'os,library'
          severity: 'CRITICAL'
```

---

## 10.4. Thiết lập Cổng bảo mật (Security Gate) cho phép hoặc chặn Pipeline tự động

### 1. Cơ chế hoạt động của Security Gate
Security Gate hoạt động dựa trên cơ chế bắt mã trạng thái thoát (Exit Code) của các tiến trình dòng lệnh trong runner:
- **Mã thoát `0` (Success):** Tương ứng với trạng thái an toàn, pipeline tiếp tục chuyển giao sang tác vụ kế tiếp.
- **Mã thoát khác `0` (Exit code `1`, `2`,...):** Báo hiệu lỗi hoặc vi phạm ngưỡng rủi ro, runner ngay lập tức ngừng thực thi toàn bộ pipeline, đánh dấu trạng thái `FAILED`.

### 2. Thiết lập quy chuẩn Security Gate đa lớp trong doanh nghiệp:

```text
CÁC CẤP ĐỘ CỔNG BẢO MẬT TRONG PIPELINE:
Gate 1: Pre-commit / Secret Check ──► Không có khóa bí mật, API key trong mã nguồn (Fail nếu phát hiện)
Gate 2: SAST Quality Gate        ──► Độ bao phủ kiểm thử >= 80%, không có lỗ hổng bảo mật cấp A/B
Gate 3: Dependency Check (SCA)   ──► 0 lỗ hổng CRITICAL đã có bản vá trong thư viện bên thứ ba
Gate 4: Container Security Gate  ──► 0 lỗ hổng CRITICAL trong OS Image, không chạy quyền root
```

### 3. Ví dụ thiết lập Quality Gate nâng cao trên giao diện SonarQube:
Trong SonarQube, quản trị viên có thể định nghĩa chính sách Quality Gate tùy chỉnh với các điều kiện khắt khe:
1. **Security Rating:** Phải đạt mức **A** (Không có bất kỳ lỗ hổng bảo mật Vulnerability nào đang mở).
2. **Security Hotspots Reviewed:** Phải đạt **100%** (Tất cả các đoạn mã nhạy cảm đều phải được kỹ sư bảo mật xem xét và xác nhận).
3. **Coverage on New Code:** Phải đạt tối thiểu **80.0%** trên phần mã mới được bổ sung.
4. **Duplicated Lines Density:** Tỷ lệ mã trùng lặp không được vượt quá **3.0%**.

Nếu bất kỳ điều kiện nào bị vi phạm, lệnh `sonar-scanner` trong Pipeline sẽ trả về mã lỗi và ngăn chặn hoàn toàn việc merge mã nguồn vào nhánh chính.

---

## 10.5. Quản lý kết quả quét an ninh, Lỗ hổng bảo mật và Xử lý báo động giả (False Positive)

### 1. Vấn đề nan giải: Báo động giả và Cơn bão cảnh báo (Alert Fatigue)
Khi tích hợp các công cụ quét bảo mật tự động vào CI/CD, một thách thức rất lớn nảy sinh là hiện tượng **Báo động giả (False Positive)**:
- **Định nghĩa:** Công cụ quét đưa ra cảnh báo về một lỗ hổng bảo mật, nhưng trên thực tế lỗ hổng đó **không thể bị khai thác** trong ngữ cảnh vận hành cụ thể của ứng dụng (ví dụ hàm bị lỗi nằm trong một module không bao giờ được gọi tới, hoặc đầu vào dữ liệu đã được lọc sạch bởi tường lửa WAF ở tầng ngoài).
- **Hệ quả của Cơn bão cảnh báo (Alert Fatigue):** Khi một lần quét sinh ra hàng trăm cảnh báo giả, các lập trình viên sẽ cảm thấy quá tải, mệt mỏi và bắt đầu tìm cách tắt bỏ công cụ quét hoặc phớt lờ toàn bộ kết quả, dẫn đến việc bỏ sót những lỗ hổng nguy hiểm thực sự.

### 2. Quy trình 5 bước quản lý vòng đời lỗ hổng chuẩn mực (Vulnerability Management Lifecycle):

```text
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│   1. SCAN &     │ ────► │  2. TRIAGE &    │ ────► │  3. REMEDIATION │
│   DISCOVERY     │       │  CONTEXTUALIZE  │       │     & PATCH     │
│ Quét & phát hiện│       │ Phân loại rủi ro│       │ Sửa code/Cập nhật│
└─────────────────┘       └─────────────────┘       └────────┬────────┘
                                                             │
                                                             ▼
┌─────────────────┐       ┌─────────────────┐       ┌─────────────────┐
│   5. CONTINUOUS │ ◄──── │  4. VERIFY &    │ ◄─────┤ EXCEPTION /     │
│   MONITORING    │       │     CLOSE       │       │ FALSE POSITIVE  │
│ Giám sát liên tục│      │ Xác thực lại    │       │ Xử lý ngoại lệ  │
└─────────────────┘       └─────────────────┘       └─────────────────┘
```

1. **Phát hiện (Discovery):** Thu thập toàn bộ kết quả quét từ Gitleaks, SonarQube, Trivy vào một bảng điều khiển tập trung (ví dụ DefectDojo).
2. **Phân loại theo ngữ cảnh (Triage & Contextual Analysis):** Đánh giá xem lỗ hổng có thể bị tấn công từ môi trường mạng bên ngoài hay không, ứng dụng có thực sự sử dụng đoạn mã bị lỗi hay không.
3. **Khắc phục (Remediation):** Ưu tiên nâng cấp phiên bản thư viện hoặc cập nhật ảnh base container lên phiên bản mới nhất đã được nhà phát hành vá lỗi.
4. **Xác thực lại (Verification):** Chạy lại Pipeline kiểm thử để bảo đảm việc sửa lỗi không gây ảnh hưởng tới tính tương thích ngược của ứng dụng.
5. **Giám sát liên tục (Monitoring):** Tiếp tục theo dõi cơ sở dữ liệu CVE vì các lỗ hổng mới có thể được công bố bất cứ lúc nào trên những thư viện cũ.

### 3. Kỹ thuật loại trừ Báo động giả an toàn và minh bạch
Khi một cảnh báo được xác định chắc chắn là False Positive hoặc là rủi ro đã được doanh nghiệp chấp nhận tạm thời (Accepted Risk), kỹ sư bảo mật phải cấu hình tài liệu hóa minh bạch:

#### A. Sử dụng tệp `.trivyignore`:
Tạo tệp `.trivyignore` nằm ở thư mục gốc của dự án để bỏ qua các mã CVE cụ thể kèm theo lý do giải trình và thời hạn hết hạn:
```text
# Bo qua lo hong CVE-2023-1234 do ung dung khong su dung tinh nang xu ly anh TIFF
# Nguoi phe duyet: SecTeam Lead (2026-10-24)
# Thoi han het han danh gia lai: 2026-12-31
CVE-2023-1234

# Bo qua CVE-2023-5678 vi da co WAF chan o tang ngoai
CVE-2023-5678 exp:2026-11-30
```

#### B. Đánh dấu trên giao diện SonarQube:
Trong giao diện quản trị SonarQube, người có thẩm quyền bảo mật có thể chuyển trạng thái của một cảnh báo sang:
- **False-Positive:** Đánh dấu cảnh báo không chính xác về mặt kỹ thuật, SonarQube sẽ không bao giờ hiển thị lại cảnh báo này ở các lần quét sau.
- **Won't Fix:** Thừa nhận rủi ro nhưng chấp nhận không sửa do tác động kinh doanh không đáng kể hoặc chi phí sửa đổi quá lớn.

Toàn bộ quy trình này biến bảo mật từ một rào cản hành chính trở thành một mắt xích tự động, minh bạch và gắn kết chặt chẽ trong chu trình DevOps hiện đại.

