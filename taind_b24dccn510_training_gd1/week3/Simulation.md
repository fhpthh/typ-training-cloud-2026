# Phần 7: Thực hành triển khai ứng dụng đa Container bằng Docker Compose

Tài liệu này hướng dẫn chi tiết quy trình xây dựng, cấu hình, vận hành và kiểm thử ứng dụng **Cloud Note App** theo kiến trúc chuẩn **3-Tier Container Architecture** (gồm 3 containers độc lập: **Frontend Nginx**, **Backend Python Flask REST API**, và **Database MySQL 8.0**) sử dụng **Docker Compose V2**, Docker Persistent Volume và mạng nội bộ cách ly theo chuẩn Production.

---

## 1. Kiến trúc ứng dụng (3-Tier Containers)

```text
                                +-------------------------------------------------------------------------+
                                |                         DOCKER HOST (Linux / PC)                        |
                                |                                                                         |
   Client / Web Browser         |   +-----------------------+     +-------------------+     +----------+  |
   http://localhost:8080 ------>|-->| notes_frontend_service|---->|notes_backend_service|-->| notes_db |  |
   (Host Port: 8080)            |   | (Nginx 1.25 Alpine)   |     | (Python Flask API)|     |(MySQL 8.0|  |
                                |   | [Reverse Proxy & SPA] |     | [Port: 5000 /api] |     | [3306]   |  |
                                |   +-----------+-----------+     +---------+---------+     +----+-----+  |
                                |               |                           |                    |        |
                                |               +-------------+-------------+                    |        |
                                |                             |                                  |        |
                                |              MẠNG NỘI BỘ DOCKER (Embedded DNS Engine)          |        |
                                |                       [week3_notes_network]                    |        |
                                |                                                                v        |
                                |                                                   +------------------+  |
                                |                                                   |PERSISTENT VOLUME |  |
                                |                                                   |[week3_mysql_vol] |  |
                                |                                                   +------------------+  |
                                +-------------------------------------------------------------------------+
```

### Thành phần 3 tầng hệ thống:
1. **Frontend Service (`notes_frontend_service`):**
   - Đóng gói bằng **Nginx 1.25 Alpine** siêu nhẹ (< 25MB).
   - Phục vụ giao diện người dùng Single Page Application (HTML5, Bootstrap 5, FontAwesome, JavaScript Fetch API).
   - Đóng vai trò **Reverse Proxy**: chuyển tiếp toàn bộ yêu cầu gọi `/api/*` và `/health` từ trình duyệt người dùng đến Backend container (`http://backend:5000/api/`) một cách an toàn, tránh lỗi CORS và không để lộ cổng backend ra ngoài host.
   - Lắng nghe tại cổng host `8080` (`8080:80`).
2. **Backend Service (`notes_backend_service`):**
   - Xây dựng bằng **Python 3.11 Flask RESTful API**.
   - Cung cấp các endpoint chuẩn:
     - `GET /api/info`: Thông tin kiến trúc, phiên bản database và storage.
     - `GET /api/notes`: Lấy danh sách toàn bộ ghi chú từ database.
     - `POST /api/notes`: Thêm mới ghi chú (tiêu đề, nội dung, danh mục).
     - `DELETE /api/notes/<id>`: Xóa ghi chú theo ID.
     - `GET /health`: Giám sát sức khỏe kết nối DB.
   - Đóng gói tối ưu bằng **Multi-stage build Dockerfile** và chạy dưới quyền **Non-root user (`appuser`)**.
   - Hoạt động trong mạng nội bộ, chỉ nhận yêu cầu từ container Frontend và giao tiếp với Database.
3. **Database Service (`notes_db_service`):**
   - Sử dụng **MySQL 8.0** chính thức.
   - Cấu hình kiểm tra sức khỏe tự động (`HEALTHCHECK`) qua `mysqladmin ping` trước khi cho phép Backend kết nối (`condition: service_healthy`).
   - Dữ liệu được lưu trữ độc lập trên **Docker Named Volume (`week3_mysql_notes_volume`)** để đảm bảo tính bền vững (không mất dữ liệu khi container bị tắt hoặc xóa).
4. **Cấu hình & Mạng:**
   - Mọi thông tin nhạy cảm (mật khẩu, user, cổng) được tách biệt trong file **`.env`**.
   - Mạng nội bộ **`week3_notes_network` (Bridge)**: Tự động phân giải tên service `frontend`, `backend`, `db` thông qua Embedded DNS Server của Docker (`127.0.0.11`).

---

## 2. Cấu trúc thư mục mã nguồn

```text
week3/
├── app/
│   ├── backend/
│   │   ├── app.py              # Mã nguồn Flask RESTful API & xử lý dữ liệu
│   │   ├── requirements.txt    # Danh sách thư viện Python (Flask, Flask-CORS, MySQL Connector)
│   │   ├── Dockerfile          # Multi-stage build tối ưu cho Backend API
│   │   └── .dockerignore       # Loại trừ cache, venv khỏi build context
│   ├── frontend/
│   │   ├── index.html          # Giao diện Single Page Application (HTML/CSS/JS)
│   │   ├── nginx.conf          # Cấu hình Nginx Web & Reverse Proxy cho /api/
│   │   └── Dockerfile          # Chỉ thị build cho Nginx Frontend container
│   ├── .env                    # Biến môi trường chứa cấu hình cổng & mật khẩu MySQL
│   ├── compose.yaml            # File điều phối Docker Compose V2 cho 3 Containers
│   ├── compose.override.yaml   # Cấu hình override cho môi trường Development (Live-reload)
│   └── run_standalone.sh       # Shell script chạy trực tiếp không qua Docker
├── Simulation.md               # Kịch bản thực hành và hướng dẫn vận hành chi tiết
└── README.md                   # Tài liệu lý thuyết và báo cáo tổng hợp tuần 3
```

---

## 3. Các bước vận hành thực tế

### Bước 1: Di chuyển vào thư mục ứng dụng & Kiểm tra cấu hình
Trước khi khởi động, di chuyển vào thư mục `app` và kiểm tra xem Docker Compose đã phân giải các biến môi trường từ file `.env` chính xác chưa:

```bash
cd app
docker compose config
```

### Bước 2: Xây dựng và khởi chạy 3 Containers ở chế độ nền
Lệnh sau sẽ tự động build image cho Frontend (Nginx), Backend (Flask API), tải image MySQL 8.0, tạo persistent volume, bridge network và khởi động hệ thống:

```bash
docker compose up -d --build
```

### Bước 3: Quan sát tiến trình khởi động & Trạng thái Healthcheck
Xem danh sách 3 containers và kiểm tra trạng thái hoạt động:

```bash
docker compose ps
```

*Nhận xét:*
- Container `notes_db_service` ban đầu ở trạng thái `health: starting`.
- Nhờ cấu hình `depends_on: { db: { condition: service_healthy } }`, container `notes_backend_service` sẽ kiên nhẫn chờ đến khi MySQL hoàn tất khởi tạo và chuyển sang `healthy` mới bắt đầu chạy, ngăn ngừa hoàn toàn lỗi `Can't connect to MySQL server`.
- Container `notes_frontend_service` khởi động sau khi backend sẵn sàng và public cổng `8080`.

### Bước 4: Kiểm tra Logs hệ thống
```bash
# Xem log toàn bộ 3 tầng hệ thống theo thời gian thực
docker compose logs -f

# Hoặc xem log riêng của từng service
docker compose logs -f frontend
docker compose logs -f backend
docker compose logs -f db
```

### Bước 5: Kiểm tra ứng dụng trên trình duyệt hoặc CLI
1. Mở trình duyệt và truy cập: **`http://localhost:8080`**
2. Hoặc kiểm tra nhanh qua dòng lệnh `curl`:
```bash
# Kiểm tra Frontend phục vụ HTML
curl -I http://localhost:8080

# Kiểm tra Backend API thông qua Reverse Proxy của Frontend
curl http://localhost:8080/api/info
curl http://localhost:8080/api/notes
```
3. Thử tạo vài ghi chú trên giao diện web (ví dụ: `Thực hành 3 Containers`, `Kiểm tra Nginx Reverse Proxy`).

---

## 4. Kiểm chứng tính bền vững của Docker Volume (Persistence Test)

Đây là bài kiểm tra quan trọng nhất để chứng minh dữ liệu cơ sở dữ liệu không bị mất mát khi vòng đời của container kết thúc:

### Bước 1: Dừng và XÓA HOÀN TOÀN cả 3 containers
```bash
docker compose down
```
Lệnh này sẽ dừng và xóa container `notes_frontend_service`, `notes_backend_service` và `notes_db_service`, nhưng **giữ nguyên Docker Volume**.

### Bước 2: Kiểm tra Volume vẫn tồn tại trên máy Host
```bash
docker volume ls | grep week3_mysql_notes_volume
```

### Bước 3: Khởi động lại hệ thống
```bash
docker compose up -d
```

### Bước 4: Kiểm tra lại dữ liệu
Truy cập lại `http://localhost:8080`: Toàn bộ các ghi chú đã tạo từ trước vẫn còn nguyên vẹn 100%!

---

## 5. Mẹo mở rộng trong thực tế

### 1. Xóa sạch toàn bộ hệ thống bao gồm cả Volume
Khi muốn làm sạch toàn bộ dữ liệu để cài đặt lại từ đầu:
```bash
docker compose down -v
```

### 2. Nhân bản (Scale) container Backend API
Khi lưu lượng gọi API tăng cao, bạn có thể tăng số lượng container backend:
```bash
docker compose up -d --scale backend=3
```
*(Nginx có thể cấu hình thêm upstream block để cân bằng tải round-robin giữa các replica backend).*

---

## 6. Khởi chạy ứng dụng Standalone (Không qua Docker & Không cần Database bên ngoài)

Dành cho các tình huống kiểm thử nhanh, demo logic ứng dụng trực tiếp trên máy chủ / máy ảo mà không muốn cài đặt Docker hay khởi chạy hệ quản trị MySQL bên ngoài:

### Cách thực hiện bằng Shell Script:
Tệp kịch bản `run_standalone.sh` đã được thiết kế sẵn:
1. Tự động kiểm tra phiên bản `python3` hoặc `python` trên hệ thống.
2. Tự khởi tạo môi trường ảo Python (`venv`) độc lập tại `app/backend/.venv`.
3. Cài đặt các dependencies từ `app/backend/requirements.txt`.
4. Kích hoạt chế độ `STANDALONE_MODE=1` (sử dụng SQLite lưu trữ cục bộ tại `app/backend/notes_local.db`).
5. Khởi chạy Backend API trên cổng mặc định `8080` (hoặc cổng được cấu hình qua biến môi trường `PORT`).

```bash
# Di chuyển vào thư mục app
cd app

# Cấp quyền thực thi và chạy script
chmod +x run_standalone.sh
./run_standalone.sh
```

- Mở trình duyệt hoặc gọi API: **`http://localhost:8080/api/info`**
- Hệ thống sẽ tự động hiển thị chế độ hoạt động: **`Standalone Mode (Host Direct / No-Docker)`** cùng cơ sở dữ liệu **`SQLite (Local Embedded)`**, hỗ trợ đầy đủ các thao tác Thêm, Xem và Xóa ghi chú mà hoàn toàn không phụ thuộc vào Docker hay MySQL daemon ngoài.
