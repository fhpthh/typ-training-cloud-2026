# BÁO CÁO TỔNG HỢP VÀ THỰC HÀNH GIT/GITHUB
---

## 1. KHÁI NIỆM GIT VÀ LỊCH SỬ RA ĐỜI

### 1.1 GIT LÀ GÌ?
- **Định nghĩa** Git là một hệ thống quản lý phiên bản mã nguồn mở 
- **Công dụng:**
    - Theo dõi và lưu lại lịch sử thay đổi của source code
    - Cho phép các menber cùng làm việc nhóm hiệu quả, phân ('branch') để phát triển tính năng độc lập mà không ảnh hướng branch chính
    - **Mô hình phân tán:** Mỗi local đều sở hữu một repo riêng có đầy đủ lịch sử, không phụ thuộc vào máy trung tâm
### 1.2 LÝ DO GIT ĐƯỢC TẠO RA?
- **Lịch sử:** Do linux torvard khởi xướng phát triển năm 2005 phục vụ việc quản lí mã nguồn nhân sau khi mất quyền truy cập vào tay bitkeeper
- **Các tiêu chuẩn thiết kế cốt lõi:**
    -**Tốc độ là ưu tiên hàng đầu** viết bằng ngôn ngữ c,tối ưu hóa hiệu năng phần cứng
    -**Thiết kế phấn tán** mỗi dev đều có bản sao đầy đủ của dự án để làm việc off
    -**Chuyển nhánh nhẹ và dễ dàng** nhánh trong git là một con trỏ dung lượng 41byte trỏ tới 1 commit. Việc chuyển nhánh diễn ra tức thì
    -**Tính bảo mật và toàn vẹn** sử dụng mã hóa sha1 để đảm bảo dữ liệu không bị hỏng, chỉnh sửa lén lút mà bị phát hiện

---
## 2. SO SÁNH GIT VÀ GITHUB/GITLAB/BITBUCKET

| Tiêu chí | Git | Github / Gitlab / Bitbucket |
| :--- | :--- | :--- |
| **Bản chất** | Phần mềm/ Công cụ quản lí phiên bản mã nguồn | Dịch vụ điện toán đám mây lưu trữ kho chưa Git |
| **Nơi hoạt động** | Cài đặt và chạy trực tiếp trên máy local của dev | Chạy trên máy chủ đám mây thông qua giao diện Web |
| **Chức năng chính** | Theo dõi lịch sử thay đổi, tạo nhánh,khôi phục phiên bản | Lưu trữ code online, chia sẻ code, Phân quyền|
| **Kết nối mạng** | Hoạt động offline, Không cần internet | Cần có kết nối internet để push hoặc pull |

**Tóm lại** Git là động cơ xe còn github là bãi đỗ xe

___
## 3. CÀI ĐẶT GIT VÀ CẤU HÌNH BAN ĐẦU
Sử dụng SSH key giúp xác thực an toàn và không cần nhập lại mật khẩu mỗi khi push hoặc pull code
```bash
git --version
Output: git version 2.54.0.windows.1
```

### 3.2 CẤU HÌNH THÔNG TIN NGƯỜI DÙNG
Khi tạo một commit, Git sẽ gắn thông tin tác giả vào commit đó, chạy các lệnh để gán nhãn thông tin cá nhân
```bash
git config --global user.name "LÊ TIẾN DŨNG"
git config --global user.email "ledung85499@gmail.com"
```

### 3.3 Cấu hình SSSH KEY
Sử dụng SSH KEY để xác thực an toàn và không cần nhập lại mật khẩu mỗi khi đẩy hoặc kéo code về

-**Public Key đã khởi tạo**
```bash
AAAAC3NzaC1lZDI1NTE5AAAAIH0PYQ7AXUrYo1xoWUuz7WTYoNjV8YtigR3/ghm+tC02 ledung85499@gmail.com
```

-**


