# Kịch bản thuyết trình và demo: Hệ thống CI/CD tự động

> Thời lượng dự kiến: **12 phút** (8 phút trình bày + demo, 4 phút hỏi đáp). Điều chỉnh theo thời gian được cấp.
> Nguyên tắc: **quay video demo sẵn** (đề bài yêu cầu) và phát video khi trình bày. Chạy live chỉ khi mọi thứ đã ổn định.
> Mục có **[ĐIỀN SAU]** cần bổ sung sau khi pipeline chạy thật.

---

## 0. Chuẩn bị trước buổi trình bày (checklist)

- [ ] 3 VM (`lab-runner`, `lab-staging`, `lab-prod`) đang `running`: `virsh list --all`
- [ ] Runner online (chấm xanh) trong Settings → CI/CD → Runners
- [ ] Pipeline đã chạy xanh ít nhất một lần; có sẵn một lần chạy xanh để mở nếu live bị lỗi
- [ ] Video demo đã quay, mở sẵn trong tab riêng
- [ ] Hai tab trình duyệt: `http://192.168.122.253` (staging), `http://192.168.122.133` (prod)
- [ ] Terminal mở sẵn trên `lab-runner` với `journalctl -u gitlab-runner -f`
- [ ] Đã **che/ẩn** token, địa chỉ nội bộ nhạy cảm, tên miền thật khi quay màn hình
- [ ] Một commit nhỏ chuẩn bị sẵn để đẩy lên khi demo (đổi chữ trong `app/index.html`)

---

## 1. Mở đầu và mục tiêu (1 phút)

**Nói:**
> "Em xây dựng một hệ thống CI/CD tự động: khi developer đẩy code, hệ thống tự đóng gói ứng dụng thành Docker image, quét bảo mật, rồi triển khai lên máy ảo bằng Ansible: staging tự động, production cần xác nhận."

**Hiển thị:** sơ đồ luồng (từ báo cáo, mục 5.1).

```
push -> build -> scan -> deploy-staging (tự động) -> deploy-prod (bấm tay)
```

---

## 2. Kiến trúc hạ tầng (1,5 phút)

**Nói:**
> "Toàn bộ chạy trên một máy chủ KVM với 3 máy ảo trong mạng NAT: `lab-runner` chạy GitLab Runner và Docker; `lab-staging` và `lab-prod` là môi trường đích. Các VM ra ngoài qua HTTP proxy, nên em phải cấu hình proxy riêng cho Docker daemon và GitLab Runner."

**Hiển thị:**
- Sơ đồ kiến trúc (báo cáo, mục 2).
- Lệnh (nhanh, 10 giây): `virsh list --all` cho thấy 3 VM running.

**Điểm nhấn:** 3 VM được tạo bằng **một script** (cloud-init, chạy song song, chạy lại không tạo trùng).

---

## 3. Demo: đẩy code và pipeline chạy (4 phút)

### 3.1. Thay đổi code (30 giây)

**Làm:** sửa `app/index.html` (ví dụ `Hello CI/CD v2`), commit vào `main`.

**Nói:**
> "Em sửa một dòng và commit. Từ lúc này mọi việc là tự động."

### 3.2. Theo dõi pipeline (2 phút)

**Mở:** Build → Pipelines → pipeline mới nhất.

**Chỉ lần lượt từng stage và giải thích ngắn:**

| Stage | Nói gì |
|---|---|
| `build` | "Build image trong Docker-in-Docker, gắn tag bằng mã commit, đẩy lên Container Registry." |
| `scan` | "Gitleaks quét xem có bí mật bị commit vào code không; Trivy quét lỗ hổng trong image. Có lỗ hổng mức CRITICAL thì pipeline dừng, đó là Security Gate." |
| `deploy-staging` | "Ansible tự động cài Docker (nếu chưa có), kéo image mới và chạy container trên VM staging." |
| `deploy-prod` | "Production cần người bấm xác nhận (manual), tương ứng Continuous Delivery." |

**Mở log job `deploy-staging`:** chỉ vào các task `ok`/`changed` của Ansible.

### 3.3. Kiểm chứng kết quả (1,5 phút)

**Làm:**
1. Mở tab `http://192.168.122.253`: thấy trang hiển thị **phiên bản bằng mã commit mới**.
2. Quay lại GitLab, bấm **Play** ở `deploy-prod`.
3. Mở tab `http://192.168.122.133`: thấy cùng phiên bản.

**Nói:**
> "Mã phiên bản hiển thị trên trang khớp với commit vừa đẩy, chứng minh bản mới đã được triển khai tự động."

---

## 4. Bảo mật và quản lý Secrets (1 phút)

**Nói:**
> "Khoá SSH để Ansible vào VM đích được lưu trong CI/CD Variable dạng File, bật Protected nên chỉ nhánh được bảo vệ đọc được. Mật khẩu registry là token tạm của job, tự hết hạn. Không có bí mật nào nằm trong repository, và Gitleaks sẽ phát hiện nếu có ai lỡ commit."

**Hiển thị:** Settings → CI/CD → Variables (che giá trị).

**Tuỳ chọn (nếu còn thời gian):** cố ý commit một chuỗi giống secret giả vào nhánh thử để cho thấy `secret-scan` làm pipeline đỏ.

---

## 5. Khó khăn gặp phải và cách xử lý (1 phút)

**Nói (rút gọn từ báo cáo mục 8.2):**
> "Khó khăn lớn nhất là mạng: các VM chỉ ra ngoài được qua proxy. Có một lần job chạy xong trong 5 giây nhưng trên GitLab lại treo. Em kiểm tra từng lớp: Docker kéo image tốt, job thực sự thành công trong log runner, nhưng lần gửi log cuối cùng nhận mã `200` thay vì `202` mà GitLab trả. Dựa vào định dạng mã `correlation_id`, em nhận ra phản hồi không đến từ GitLab mà từ thiết bị trung gian. [ĐIỀN SAU: cách đã khắc phục]"

**Điểm nhấn:** thể hiện cách tư duy debug theo từng lớp (Docker, runner, đường truyền, proxy).

---

## 6. Kết luận và hướng phát triển (30 giây)

**Nói:**
> "Hệ thống đáp ứng đủ các thành phần đề bài: repo, runner, registry, Ansible, VM đích, quản lý secrets và quét bảo mật. Hướng phát triển: Blue-Green deployment, rollback tự động, quản lý secrets bằng Vault."

---

## 7. Chuẩn bị câu hỏi thường gặp

| Câu hỏi | Gợi ý trả lời |
|---|---|
| Vì sao dùng Docker-in-Docker? | Build image trong job mà không cần quyền trực tiếp vào Docker của máy chủ; mỗi job có daemon riêng, sạch. Đổi lại cần `privileged`. |
| Khác gì Continuous Delivery và Deployment? | Delivery: sẵn sàng triển khai, production cần xác nhận. Deployment: tự động hoàn toàn. Em để `deploy-prod` là `when: manual`. |
| Vì sao Ansible mà không viết shell script? | Idempotent (chạy lại không phá), mô tả trạng thái mong muốn, agentless chỉ cần SSH, tái sử dụng bằng role. |
| Rollback thế nào? | Chạy lại pipeline với tag image cũ; image cũ vẫn nằm trong registry vì gắn tag theo commit. |
| Secrets có an toàn không? | Protected + masked/file-type, token registry tạm thời; không commit secret, Gitleaks làm gate. Hướng tốt hơn là Vault. |
| `host_key_checking = False` có an toàn không? | Chỉ dùng cho lab; production nên quản lý `known_hosts`. |
| Nếu Trivy báo lỗ hổng thì sao? | CRITICAL làm pipeline đỏ; xử lý bằng cách nâng base image, hoặc ghi nhận false positive vào `.trivyignore` có lý do. |

---

## 8. Phương án dự phòng khi demo lỗi

| Tình huống | Xử lý |
|---|---|
| Pipeline treo/chậm do mạng | Chuyển sang **video đã quay**; mở pipeline xanh cũ để chỉ từng stage |
| Runner offline | Trên `lab-runner`: `systemctl restart gitlab-runner`; nếu chưa kịp, dùng video |
| Trang staging/prod không mở | Trên VM: `docker ps`, `docker logs web`; hoặc mở ảnh chụp kết quả đã lưu |
| Log GitLab không cập nhật (lỗi gửi log) | Mở song song `journalctl -u gitlab-runner -f` để cho thấy job thực chạy xong |
| Hết giờ | Bỏ mục 4 (tuỳ chọn) và rút gọn mục 5 |

---

## 9. Phân bổ thời gian (tham khảo)

| Mục | Thời gian |
|---|---|
| 1. Mở đầu | 1 phút |
| 2. Kiến trúc | 1,5 phút |
| 3. Demo pipeline | 4 phút |
| 4. Bảo mật và secrets | 1 phút |
| 5. Khó khăn | 1 phút |
| 6. Kết luận | 0,5 phút |
| Hỏi đáp | 3–4 phút |
