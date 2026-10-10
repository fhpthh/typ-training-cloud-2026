# BÁO CÁO THỰC HÀNH TUẦN 1: TỔNG QUAN VÀ LÀM VIỆC VỚI GIT

- **Họ và tên:** Nguyễn Vĩnh Tùng
- **Mã sinh viên:** B23DCKH130
- **Chương trình:** TYP Cloud Training 2026
- **Giai đoạn:** Giai đoạn 1 (`training-gd1`)
- **Nội dung:** Báo cáo chi tiết và bài thực hành Tuần 1


---

## MỤC LỤC BÁO CÁO <a id="muc-luc"></a>

- [**PHẦN 1: GIỚI THIỆU TỔNG QUAN VỀ GIT**](#phần-1-giới-thiệu-tổng-quan-về-git)
  - [1. Git là gì?](#1-git-là-gì)
  - [2. Khác biệt giữa Git và GitHub / GitLab / Bitbucket](#2-khác-biệt-giữa-git-và-github--gitlab--bitbucket)
  - [3. Cài đặt Git & Cấu hình ban đầu](#3-cài-đặt-git--cấu-hình-ban-đầu)
- [**PHẦN 2: LÀM VIỆC VỚI REPOSITORY**](#phần-2-làm-việc-với-repository)
  - [4. Khởi tạo và Clone Repository](#4-khởi-tạo-và-clone-repository)
  - [5. Trạng thái tập tin trong Git](#5-trạng-thái-tập-tin-trong-git)
  - [6. Thêm và Commit thay đổi](#6-thêm-và-commit-thay-đổi)
- [**PHẦN 3: LÀM VIỆC VỚI LỊCH SỬ VÀ PHIÊN BẢN**](#phần-3-làm-việc-với-lịch-sử-và-phiên-bản)
  - [7. Xem lịch sử commit](#7-xem-lịch-sử-commit)
  - [8. Undo / Revert / Reset thay đổi](#8-undo--revert--reset-thay-đổi)
  - [9. Làm việc với `.gitignore`](#9-làm-việc-với-gitignore)
- [**Phần 4: Nhánh (Branching) & hợp nhất (Merging)**](#phần-4-nhánh-branching--hợp-nhất-merging)
  - [10. Branch là gì và tại sao cần Branch?](#10-branch-là-gì-và-tại-sao-cần-branch)
  - [11. Tạo và chuyển nhánh](#11-tạo-và-chuyển-nhánh)
  - [12. Merge Branch & Xử lý xung đột](#12-merge-branch--xử-lý-xung-đột)
  - [13. Chiến lược phân nhánh phổ biến trong công nghiệp](#13-chiến-lược-phân-nhánh-phổ-biến-trong-công-nghiệp)
- [**PHẦN 5: REMOTE REPOSITORY (GITHUB/GITLAB)**](#phần-5-remote-repository-githubgitlab)
  - [14. Thêm remote và đẩy code (Remote Operations)](#14-thêm-remote-và-đẩy-code-remote-operations)
  - [15. Làm việc nhóm: Fork, Clone, Pull Request (Collaborative Workflows)](#15-làm-việc-nhóm-fork-clone-pull-request-collaborative-workflows)
  - [16. Giải quyết Conflict khi làm việc nhóm (Team Conflict Resolution)](#16-giải-quyết-conflict-khi-làm-việc-nhóm-team-conflict-resolution)
- [**PHẦN 6: CÔNG CỤ & KỸ NĂNG NÂNG CAO**](#phần-6-công-cụ--kỹ-năng-nâng-cao)
  - [17. Gắn nhãn phiên bản và Semantic Versioning (Tag and Versioning)](#17-gắn-nhãn-phiên-bản-và-semantic-versioning-tag-and-versioning)
  - [18. Lưu tạm thay đổi chưa commit (`git stash`)](#18-lưu-tạm-thay-đổi-chưa-commit-git-stash)
  - [19. Tái cơ sở và gộp commit (`git rebase` và `squash`)](#19-tái-cơ-sở-và-gộp-commit-git-rebase-và-squash)
  - [20. Tùy biến viết tắt và định dạng nhật ký (Git Alias & Log Formatting)](#20-tùy-biến-viết-tắt-và-định-dạng-nhật-ký-git-alias--log-formatting)
  - [21. Nhật ký tham chiếu và Khôi phục commit bị mất (`git reflog`)](#21-nhật-ký-tham-chiếu-và-khôi-phục-commit-bị-mất-git-reflog)
- [**PHẦN 7: THỰC HÀNH DỰ ÁN THỰC TẾ**](#phần-7-thực-hành-dự-án-thực-tế)
  - [22. Các tình huống giả lập thực tế](#22-các-tình-huống-giả-lập-thực-tế)
  - [23. Bảng tổng kết và Ma trận ra quyết định kỹ thuật (Engineering Decision Matrix)](#23-bảng-tổng-kết-và-ma-trận-ra-quyết-định-kỹ-thuật-engineering-decision-matrix)

---

# PHẦN 1: GIỚI THIỆU TỔNG QUAN VỀ GIT

## 1. Git là gì?

### 1.1. Định nghĩa và Khái niệm Cốt lõi
**Git** là một **Hệ thống Quản lý Phiên bản Phân tán** mã nguồn mở và miễn phí, được thiết kế để theo dõi mọi sự thay đổi trong tập tin mã nguồn của một dự án phần mềm theo thời gian. 

Git cho phép:
- Lưu trữ lại toàn bộ lịch sử phát triển của dự án dưới dạng các mốc thời gian (*commits*).
- Cho phép nhiều lập trình viên làm việc song song trên cùng một dự án mà không bị ghi đè công việc của nhau.
- Dễ dàng quay lui, hoàn tác về bất kỳ phiên bản nào trong quá khứ khi xảy ra sự cố.
- Thử nghiệm các tính năng mới độc lập thông qua cơ chế phân nhánh cực nhẹ và linh hoạt.

### 1.2. Lịch sử hình thành và lý do Git ra đời

#### Bối cảnh lịch sử
- **1991 - 2002:** Dự án nhân hệ điều hành Linux phát triển với quy mô lớn nhưng không sử dụng bất kỳ hệ thống quản lý phiên bản tự động nào. Mã nguồn được chia sẻ qua các bản vá và kho lưu trữ nén.
- **2002:** Cộng đồng Linux bắt đầu sử dụng **BitKeeper** - một hệ thống quản lý phiên bản phân tán thương mại được cấp phép miễn phí cho dự án Linux.
- **2005 (Bước ngoặt):** Mối quan hệ giữa công ty phát triển BitKeeper và cộng đồng Linux bị rạn nứt nghiêm trọng.
#### Sự ra đời của Git
Đứng trước nguy cơ không có công cụ phù hợp để quản lý hàng nghìn đóng góp từ cộng đồng toàn cầu, **Linus Torvalds** (cha đẻ của Linux) đã quyết định tự viết một hệ thống quản lý phiên bản hoàn toàn mới vào **tháng 4 năm 2005**. Chỉ trong vòng chưa đầy 2 tuần, phiên bản đầu tiên của Git đã tự quản lý được chính mã nguồn của mình.

#### Các mục tiêu thiết kế then chốt của Git
1. **Tốc độ vượt trội:** Các thao tác thông thường (xem log, commit, diff, switch branch) phải thực hiện gần như tức thì ở cấp độ mili-giây trên máy cục bộ.
2. **Thiết kế phân tán hoàn chỉnh:** Mỗi máy trạm của lập trình viên là một bản sao hoàn chỉnh của toàn bộ kho lưu trữ, bao gồm đầy đủ lịch sử commit. Không phụ thuộc vào kết nối mạng tới máy chủ trung tâm để làm việc.
3. **Hỗ trợ phân nhánh phi tuyến tính mạnh mẽ:** Hỗ trợ tạo, xóa, và hợp nhất hàng nghìn nhánh song song mỗi ngày một cách an toàn và mượt mà.
4. **Bảo toàn tính toàn vẹn dữ liệu:** Mọi đối tượng (file, thư mục, commit) trong Git đều được gán nhãn và kiểm tra bằng mã băm SHA-1. Điều này đảm bảo không ai có thể can thiệp làm sai lệch dữ liệu mà không bị phát hiện.
5. **Cơ chế lưu trữ dạng ảnh chụp:**
   - Các VCS truyền thống quản lý thông tin dưới dạng danh sách các thay đổi dựa trên từng tập tin.
   - Git quản lý dữ liệu dưới dạng ảnh chụp của một hệ thống tệp nhỏ. Tại mỗi commit, Git ghi nhận một ảnh chụp trạng thái toàn bộ dự án. Nếu một tập tin không bị thay đổi, Git không lưu lại tập tin đó mà chỉ tạo một liên kết trỏ đến tập tin giống hệt đã lưu trước đó.

---

### 1.3. So sánh Git với các hệ thống VCS khác (SVN, Mercurial)

| Tiêu chí so sánh | Git | Apache Subversion (SVN) | Mercurial (Hg) |
| :--- | :--- | :--- | :--- |
| **Kiến trúc** | **Phân tán (DVCS)** | **Tập trung (CVCS)** | **Phân tán (DVCS)** |
| **Lịch sử cục bộ** | Đầy đủ toàn bộ lịch sử dự án trên máy trạm | Chỉ lưu working copy, lịch sử nằm tại Server | Đầy đủ toàn bộ lịch sử dự án trên máy trạm |
| **Khả năng làm việc Offline** | **100%** | **Rất hạn chế** | **100%** |
| **Tốc độ thao tác** | Cực kỳ nhanh (được viết bằng C/Assembly) | Phụ thuộc độ trễ mạng và tải của Server | Nhanh (viết bằng Python và một phần C) |
| **Cơ chế phân nhánh (Branching)** | Cực nhẹ | Nặng nề (tạo nhánh bản chất là copy thư mục trong repo) | Khá nhẹ, nhưng cơ chế bookmark/branch phức tạp hơn Git |
| **Mô hình lưu trữ** | Snapshots | Delta-based | Revlog |
| **Bảo mật & Toàn vẹn** | Mã băm mật mã học (SHA-1/SHA-256) cho mọi đối tượng | Kiểm tra tuần tự bằng số phiên bản tăng dần (Revision 1, 2, 3...) | Mã băm SHA-1 |
| **Mức độ phổ biến & Cộng đồng** | **Chiếm ưu thế tuyệt đối** | Giảm dần, chủ yếu trong các hệ thống legacy | Rất ít dự án mới dùng (trừ một số ít như Facebook/Meta fork) |

> **Kết luận:** Git vượt trội hơn hẳn SVN về tốc độ, sự linh hoạt và khả năng hoạt động độc lập không cần mạng. So với Mercurial, Git phổ biến hơn áp đảo nhờ hệ sinh thái GitHub/GitLab cực kỳ phát triển và hiệu năng tối ưu cho các dự án quy mô từ nhỏ đến cực lớn.

---

## 2. Khác biệt giữa Git và GitHub / GitLab / Bitbucket

Nhiều người mới bắt đầu thường nhầm lẫn giữa **Git** và **GitHub**. Trên thực tế, chúng là hai khái niệm hoàn toàn khác biệt nhưng bổ trợ cho nhau:

### 2.1. Phân biệt Bản chất Cốt lõi
* **Git** là **công cụ / phần mềm**: Chạy trên máy tính cá nhân để quản lý phiên bản mã nguồn cục bộ. Git không có giao diện web, không cần internet để hoạt động.
* **GitHub / GitLab / Bitbucket** là **dịch vụ điện toán đám mây (Cloud Hosting Services & DevOps Platforms)**: Cung cấp máy chủ để lưu trữ các Git repository từ xa (*remote repos*), kết hợp thêm các công cụ quản lý dự án, cộng tác nhóm, kiểm thử và triển khai tự động.

### 2.2. Bảng so sánh Git vs Các Nền tảng Dịch vụ

| Tiêu chí | Git | GitHub | GitLab | Bitbucket |
| :--- | :--- | :--- | :--- | :--- |
| **Bản chất** | Công cụ CLI / Version Control | Nền tảng Cloud Hosting + DevOps | Nền tảng DevOps hoàn chỉnh | Nền tảng Cloud Hosting mã nguồn |
| **Nơi cài đặt / hoạt động** | Máy của lập trình viên | Dịch vụ đám mây (SaaS) | Đám mây  hoặc Tự host (Self-hosted) | Đám mây (SaaS) hoặc Data Center |
| **Mục đích chính** | Theo dõi thay đổi của code | Lưu trữ remote repo & cộng tác xã hội | Tự động hóa toàn trình chu trình DevSecOps | Lưu trữ code cho doanh nghiệp dùng Jira |
| **Giao diện người dùng** | Dòng lệnh (CLI) | Web UI, GitHub Desktop, Mobile app | Web UI phong phú | Web UI, Sourcetree |
| **Tính năng cộng tác** | Gửi patch qua email (`git format-patch`) | Pull Request, Code Review, Discussions | Merge Request, Code Review, Wiki | Pull Request, Code Review |
| **CI/CD Tích hợp** | Không có (chỉ có Git Hooks) | GitHub Actions | GitLab CI/CD (Rất mạnh, chuẩn công nghiệp) | Bitbucket Pipelines |
| **Quản lý công việc** | Không có | GitHub Issues, Projects | GitLab Issues, Epic, Boards | Tích hợp gốc 100% với Atlassian Jira |

---

### 2.3. Khi nào nên sử dụng nền tảng nào?
1. **GitHub:**
   - Lựa chọn hàng đầu cho **dự án mã nguồn mở (Open Source)** nhờ sở hữu cộng đồng lập trình viên lớn nhất thế giới (>100 triệu lập trình viên).
   - Tuyệt vời cho portfolio cá nhân, chia sẻ code công khai và tích hợp sẵn kho ứng dụng GitHub Marketplace khổng lồ.
2. **GitLab:**
   - Lựa chọn ưu tiên cho các **doanh nghiệp muốn tự host (Self-hosted / On-Premise)** trên hạ tầng riêng để bảo mật dữ liệu tuyệt đối.
   - Nổi tiếng với hệ thống CI/CD mạnh mẽ, toàn diện từ kiểm thử, quét lỗ hổng bảo mật đến triển khai Kubernetes.
3. **Bitbucket:**
   - Lựa chọn tối ưu cho các **doanh nghiệp đang sử dụng toàn bộ hệ sinh thái của Atlassian** (Jira, Confluence, Trello, Bamboo).
   - Quản lý phân quyền người dùng và chi nhánh rất chặt chẽ, phù hợp cho quy trình Scrum/Agile của doanh nghiệp.

---

## 3. Cài đặt Git & Cấu hình ban đầu

### 3.1. Hướng dẫn Cài đặt trên các Hệ điều hành

#### Trên Windows
- Tải bộ cài đặt chính thức tại: [https://git-scm.com/download/win](https://git-scm.com/download/win)
- Chạy file cài đặt `.exe`, khuyến nghị giữ các thiết lập mặc định, đặc biệt là:
  - Chọn **Git Bash** làm terminal đi kèm.
  - Chọn cấu hình xử lý ngắt dòng: **Checkout Windows-style, commit Unix-style line endings** (`core.autocrlf = true`).
  - Sử dụng credential helper: **Git Credential Manager**.

#### Trên Linux (Ubuntu / Debian)
```bash
sudo apt update
sudo apt install -y git
```

---

### 3.2. Kiểm tra phiên bản Git đã cài đặt
Chạy lệnh sau trên terminal/PowerShell:
```bash
git --version
```
*Kết quả kiểm tra thực tế trên máy trạm thực hành:*
```text
git version 2.45.2.windows.1
```

---

### 3.3. Các cấp độ cấu hình trong Git (Configuration Scopes)
Git lưu trữ cấu hình tại 3 cấp độ khác nhau. Cấp độ cụ thể hơn sẽ ghi đè cấp độ chung:

1. **`--system`:** Áp dụng cho mọi tài khoản người dùng trên toàn bộ hệ điều hành.
   - Lưu tại file: `C:\Program Files\Git\etc\gitconfig` (Windows) hoặc `/etc/gitconfig` (Linux).
2. **`--global`:** Áp dụng cho người dùng hiện tại đang đăng nhập hệ thống (áp dụng cho tất cả repos của người này).
   - Lưu tại file: `~/.gitconfig` hoặc `C:\Users\<Username>\.gitconfig`.
3. **`--local`:** Áp dụng riêng cho duy nhất repository hiện tại đang đứng.
   - Lưu tại file: `.git/config` bên trong thư mục dự án.

> **Độ ưu tiên ghi đè:**  
> `Local` ➔ `Global` ➔ `System`

---

### 3.4. Cấu hình định danh ban đầu
Đây là bước bắt buộc đầu tiên sau khi cài Git, vì mọi commit bạn tạo ra đều sẽ gắn liền vĩnh viễn với thông tin này:

```bash
# 1. Cấu hình Họ tên hiển thị
git config --global user.name "Vinh Tung"

# 2. Cấu hình Email (nên khớp với email đăng ký tài khoản GitHub)
git config --global user.email "TUNGNV.B23KH130@stu.ptit.edu.vn"

# 3. Cấu hình nhánh mặc định khi khởi tạo repo mới là 'main'
git config --global init.defaultBranch main

# 4. Chuẩn hóa ký tự xuống dòng trên Windows để tránh lỗi CRLF/LF khi làm việc nhóm
git config --global core.autocrlf true
```

#### Kiểm tra toàn bộ danh sách cấu hình hiện hành
```bash
git config --list --show-origin
```
*Trích xuất cấu hình thực tế đã xác lập trên máy thực hành:*
```text
file:C:/Users/ADMIN/.gitconfig  user.name=VinhTungg
file:C:/Users/ADMIN/.gitconfig  user.email=TUNGNV.B23KH130@stu.ptit.edu.vn
file:C:/Users/ADMIN/.gitconfig  filter.lfs.clean=git-lfs clean -- %f
file:C:/Users/ADMIN/.gitconfig  filter.lfs.smudge=git-lfs smudge -- %f
```

---

### 3.5. Thiết lập Xác thực bảo mật với SSH Key (GitHub / GitLab)

#### Tại sao nên dùng SSH Key thay vì HTTPS?
- **Tiện lợi:** Sau khi cấu hình một lần, bạn có thể `push` / `pull` mã nguồn mà không cần nhập lại Username / Personal Access Token mỗi lần thao tác.
- **Bảo mật cao:** Sử dụng mã hóa bất đối xứng (khóa công khai `Public Key` lưu trên GitHub và khóa riêng tư `Private Key` lưu an toàn trên máy cục bộ).


---

# PHẦN 2: LÀM VIỆC VỚI REPOSITORY

## 4. Khởi tạo và Clone Repository

### 4.1. Khởi tạo kho chứa cục bộ (`git init`)
Lệnh `git init` được sử dụng để khởi tạo một Git repository mới hoặc tái khởi tạo một repository hiện có tại thư mục cục bộ. Thao tác này thiết lập toàn bộ cơ sở hạ tầng quản lý phiên bản ngầm định bên trong thư mục mục tiêu.

#### Cú pháp và các biến thể thực thi:
* **Khởi tạo tại thư mục hiện hành:**
  ```bash
  git init
  ```
  Lệnh này tạo một thư mục con ẩn có tên `.git` chứa toàn bộ siêu dữ liệu (*metadata*) và cấu trúc đối tượng ban đầu.
* **Khởi tạo kèm chỉ định tên thư mục dự án:**
  ```bash
  git init <project-directory>
  ```
  Tự động tạo mới thư mục `<project-directory>` (nếu chưa tồn tại) và thiết lập Git repository bên trong thư mục đó.
* **Khởi tạo kho chứa trần (Bare Repository):**
  ```bash
  git init --bare <repository-name>.git
  ```
  Kho chứa trần (*bare repository*) không chứa **Working Directory** (không có các tệp mã nguồn để lập trình viên chỉnh sửa trực tiếp), mà chỉ chứa phần lõi quản trị của thư mục `.git`. Dạng kho chứa này được dùng làm máy chủ trung tâm để các thành viên thực hiện `push` và `pull` mà không xảy ra xung đột trạng thái làm việc cục bộ.

---

### 4.2. Sao chép kho chứa từ xa (`git clone`)
Lệnh `git clone` tạo một bản sao cục bộ hoàn chỉnh của một Git repository từ xa về máy trạm. Quá trình sao chép bao gồm việc tải về toàn bộ các tệp, tất cả các commit trong lịch sử, và toàn bộ các nhánh.

#### Cơ chế vận hành tự động của `git clone`:
1. Tạo thư mục mục tiêu trên hệ thống tệp cục bộ.
2. Khởi tạo thư mục `.git` bên trong thư mục mục tiêu.
3. Tải toàn bộ cơ sở dữ liệu đối tượng (*object database*) từ remote server về máy.
4. Tự động thiết lập một kết nối từ xa mặc định có định danh là **`origin`** trỏ về URL nguồn.
5. Tạo các con trỏ theo dõi từ xa tương ứng (ví dụ: `origin/main`).
6. Tự động tạo nhánh cục bộ tương ứng và thực hiện `checkout` ảnh chụp của nhánh mặc định vào Working Directory.

#### Cú pháp và các tùy chọn nâng cao:
* **Sao chép chuẩn:**
  ```bash
  git clone <url-repository>
  ```
* **Sao chép và đổi tên thư mục đích:**
  ```bash
  git clone <url-repository> <custom-folder-name>
  ```
* **Sao chép nông (Shallow Clone - Tối ưu hóa hiệu năng trong CI/CD):**
  ```bash
  git clone --depth 1 <url-repository>
  ```
  Chỉ tải về commit mới nhất mà không tải toàn bộ lịch sử hàng nghìn commit trước đó, giúp giảm đáng kể thời gian tải và dung lượng ổ đĩa. Thường dùng trong các pipeline tự động hóa kiểm thử/triển khai.
* **Sao chép chỉ một nhánh cụ thể:**
  ```bash
  git clone --branch <branch-name> --single-branch <url-repository>
  ```

---

### 4.3. Bảng so sánh chuyên sâu `git init` vs `git clone`

| Tiêu chí | `git init` | `git clone` |
| :--- | :--- | :--- |
| **Mục đích sử dụng** | Bắt đầu một dự án mới hoàn toàn từ máy cục bộ, hoặc đưa mã nguồn có sẵn vào quản lý phiên bản. | Tham gia vào một dự án đã có sẵn trên máy chủ (GitHub, GitLab, nội bộ). |
| **Nguồn dữ liệu ban đầu** | Thư mục trống hoặc tập tin mã nguồn cục bộ hiện có. | Kho chứa từ xa (*Remote Repository*) trên máy chủ. |
| **Cấu hình Remote (`origin`)** | Chưa có remote nào được thiết lập; lập trình viên phải thêm thủ công bằng `git remote add`. | Đã được cấu hình tự động trỏ về URL kho chứa nguồn (`origin`). |
| **Lịch sử Commit** | Lịch sử trống rỗng (chưa có commit nào, chưa có nhánh thực thể cho tới commit đầu). | Chứa toàn bộ lịch sử commit, tag và branch từ xa. |
| **Môi trường sử dụng** | Khởi tạo dự án cá nhân mới, thiết lập Bare Repo trên máy chủ. | Lập trình viên mới onboard vào dự án, máy chủ CI/CD tải mã nguồn. |

---

### 4.4. Cấu trúc nội bộ thư mục `.git` (Internal Architecture)

Thư mục `.git` là thành phần cốt lõi chứa toàn bộ cơ sở dữ liệu và cấu hình của một repository. Mọi dữ liệu không nằm trong thư mục này chỉ được coi là bản sao làm việc tạm thời.

```text
.git/
├── HEAD               # Con trỏ tham chiếu đến nhánh hiện hành
├── config             # Tệp cấu hình cục bộ của repository
├── description        # Tệp mô tả repository (sử dụng cho GitWeb)
├── hooks/             # Thư mục chứa các kịch bản hook tự động hóa
│   ├── pre-commit.sample
│   ├── commit-msg.sample
│   └── pre-push.sample
├── info/
│   └── exclude        # Tệp định nghĩa quy tắc loại trừ cục bộ
├── objects/           # Cơ sở dữ liệu đối tượng hướng nội dung (Content-Addressable Database)
│   ├── info/
│   └── pack/
└── refs/              # Thư mục lưu trữ các con trỏ tham chiếu
    ├── heads/         # Các con trỏ nhánh cục bộ (local branches)
    ├── remotes/       # Các con trỏ nhánh theo dõi từ xa (remote tracking branches)
    └── tags/          # Các nhãn phiên bản phát hành (release tags)
```

#### Phân tích chi tiết chức năng từng thành phần:

1. **`HEAD` (Tệp tham chiếu đỉnh):**
   - Chứa thông tin về nhánh mà Working Directory đang tham chiếu đến.
   - Định dạng chuẩn: `ref: refs/heads/main`.
   - Trong trạng thái *Detached HEAD*, tệp này sẽ chứa trực tiếp mã băm SHA-1 của một commit cụ thể thay vì một nhánh.
2. **`config` (Tệp cấu hình cục bộ):**
   - Chứa các cài đặt dành riêng cho repository này, bao gồm URL remote, nhánh theo dõi, thiết lập định dạng tệp. Cấu hình tại đây có độ ưu tiên cao nhất, ghi đè lên cấu hình `--global` và `--system`.
3. **`hooks/` (Kịch bản kích hoạt tự động):**
   - Chứa các tệp thực thi (Shell script, Python, ...) được tự động kích hoạt trước hoặc sau các sự kiện Git (như kiểm tra lint mã nguồn trước khi commit với `pre-commit`, xác thực chuẩn định dạng message với `commit-msg`).
4. **`info/exclude` (Quy tắc bỏ qua cục bộ):**
   - Hoạt động với cú pháp hoàn toàn tương tự `.gitignore`, nhưng tệp này không được commit vào hệ thống để chia sẻ cho các lập trình viên khác. Dùng để bỏ qua các tệp đặc thù của riêng môi trường cá nhân.
5. **`objects/` (Cơ sở dữ liệu đối tượng bất biến):**
   - Toàn bộ nội dung tệp và lịch sử commit được nén bằng thư viện `zlib` và lưu trữ dưới dạng định danh mã băm SHA-1 (40 ký tự hexa).
   - Git quản lý 4 loại đối tượng cốt lõi:
     - **Blob (Binary Large Object):** Lưu trữ thuần túy nội dung của một tệp tin (không chứa tên tệp hay quyền truy cập).
     - **Tree:** Tương đương một thư mục, lưu danh sách các con trỏ tới Blob (kèm tên tệp, quyền tệp) hoặc các Tree con.
     - **Commit:** Lưu trữ siêu dữ liệu phiên bản (Tác giả, Người commit, Thời gian, Thông điệp, Con trỏ tới Tree gốc và Con trỏ tới Commit cha).
     - **Annotated Tag:** Lưu trữ nhãn phát hành phiên bản có chữ ký hoặc ghi chú.
6. **`refs/` (Hệ thống tham chiếu):**
   - `refs/heads/`: Chứa các tệp văn bản nhỏ mang tên các nhánh cục bộ. Mỗi tệp chứa chính xác một mã băm SHA-1 trỏ đến commit mới nhất của nhánh đó.
   - `refs/remotes/`: Chứa các con trỏ trỏ đến commit mới nhất của các nhánh trên máy chủ từ xa được đồng bộ về.
   - `refs/tags/`: Chứa các tham chiếu tới các mốc phiên bản phát hành cố định.
7. **`index` (Tệp nhị phân vùng chuẩn bị - Staging Area):**
   - Là một tệp nhị phân đóng vai trò cầu nối giữa Working Directory và Object Database, lưu danh sách toàn bộ các đường dẫn tệp, quyền hạn và SHA-1 hash đã được đưa vào vùng chuẩn bị.

---

## 5. Trạng thái tập tin trong Git

### 5.1. Kiến trúc Ba Vùng Làm Việc (Three Trees Architecture)

Cơ chế quản lý phiên bản của Git được xây dựng dựa trên việc luân chuyển dữ liệu qua ba khu vực kỹ thuật độc lập:

1. **Working Directory (Thư mục làm việc):** Không gian thư mục vật lý trên ổ đĩa nơi lập trình viên trực tiếp tạo mới, chỉnh sửa hoặc xóa các tệp mã nguồn.
2. **Staging Area / Index (Vùng đệm chuẩn bị):** Một tệp nhị phân chuyên dụng (thường nằm tại `.git/index`) ghi nhận ảnh chụp có tổ chức của các thay đổi dự kiến sẽ được đưa vào commit kế tiếp.
3. **Git Directory / Repository (Kho lưu trữ đối tượng):** Nơi Git lưu trữ an toàn cơ sở dữ liệu đối tượng và toàn bộ lịch sử phiên bản của dự án. Một khi dữ liệu đã được commit vào đây, nó sẽ được bảo toàn vĩnh viễn.

---

### 5.2. Vòng đời trạng thái của tập tin (File Lifecycle)

Mỗi tập tin bên trong thư mục làm việc của một Git repository luôn nằm ở một trong hai phân loại lớn: **Untracked** hoặc **Tracked**.

* **Untracked (Chưa được theo dõi):** Tập tin tồn tại trong Working Directory nhưng chưa từng được thêm vào Staging Area và không có trong snapshot của commit gần nhất. Git hoàn toàn không theo dõi sự biến đổi của tập tin này.
* **Tracked (Đang được theo dõi):** Tập tin đã nằm trong sự quản lý của Git từ commit trước hoặc vừa được đưa vào Staging Area. Tập tin Tracked tuần tự trải qua 3 trạng thái:
  1. **Unmodified (Chưa bị sửa đổi):** Nội dung tập tin trong Working Directory hoàn toàn trùng khớp với ảnh chụp trong commit hiện hành (`HEAD`).
  2. **Modified (Đã bị sửa đổi):** Tập tin đã có sự thay đổi nội dung trên đĩa so với commit gần nhất nhưng những thay đổi này chưa được đưa vào Staging Area.
  3. **Staged (Đã đưa vào vùng chuẩn bị):** Tập tin đã được đánh dấu thông qua lệnh `git add` để ghi nhận phiên bản hiện tại vào snapshot của commit tiếp theo.

---

### 5.3. Kiểm tra trạng thái với `git status`

Lệnh `git status` là công cụ trung tâm để quan sát trạng thái của cả ba khu vực làm việc tại bất kỳ thời điểm nào.

#### Phân tích kết quả đầu ra của `git status`:
```bash
git status
```
Đầu ra sẽ phân tách rõ ràng các nhóm tệp:
- **Changes to be committed (Màu xanh lục):** Các tệp đang ở trạng thái **Staged**, sẵn sàng được ghi vào commit mới.
- **Changes not staged for commit (Màu đỏ):** Các tệp đã theo dõi (**Tracked**) bị chỉnh sửa hoặc bị xóa nhưng chưa đưa vào Staging Area.
- **Untracked files (Màu đỏ):** Các tệp mới chưa từng được Git quản lý.

#### Chế độ hiển thị rút gọn (`git status -s` hoặc `git status --short`):
Chế độ này cung cấp báo cáo cô đọng gồm 2 cột ký tự biểu thị trạng thái:
* **Cột 1 (Bên trái):** Trạng thái của tập tin trong **Staging Area** (so với commit gần nhất).
* **Cột 2 (Bên phải):** Trạng thái của tập tin trong **Working Directory** (so với Staging Area).

```text
 XY PATH
```

| Ký hiệu | Ý nghĩa chi tiết |
| :---: | :--- |
| `??` | Tập tin **Untracked** (mới hoàn toàn, chưa theo dõi). |
| `A ` | Tập tin mới đã được đưa vào Staging Area (**Staged**), chưa có thay đổi mới ở Working Directory. |
| ` M` | Tập tin Tracked đã bị sửa đổi trong Working Directory nhưng **chưa được Stage**. |
| `M ` | Tập tin Tracked đã được sửa đổi và **đã đưa vào Staging Area**. |
| `MM` | Tập tin đã được Stage một phần, nhưng sau đó tiếp tục bị sửa đổi trong Working Directory mà chưa stage lại. |
| `D ` | Tập tin đã được đánh dấu xóa và đã đưa vào Staging Area. |
| ` D` | Tập tin đã bị xóa trong Working Directory nhưng chưa đưa thao tác xóa vào Staging Area. |
| `AM` | Tập tin mới được tạo, đã add vào Stage, sau đó tiếp tục có sửa đổi chưa stage. |

---

### 5.4. So sánh sự khác biệt chi tiết với `git diff`

Trong khi `git status` chỉ thông báo danh sách các tệp bị biến đổi, lệnh `git diff` đi sâu vào phân tích cú pháp chi tiết từng dòng mã nguồn bị thêm, xóa hoặc thay đổi.

#### Bảng tổng hợp các cú pháp so sánh trọng yếu:

| Cú pháp câu lệnh | Khu vực so sánh | Ý nghĩa thực tiễn |
| :--- | :--- | :--- |
| `git diff` | **Working Directory** vs **Staging Area** | Trả lời: *"Tôi đã thay đổi những dòng mã nào mà chưa thực hiện `git add`?"* |
| `git diff --staged`<br>*(hoặc `git diff --cached`)* | **Staging Area** vs **Commit gần nhất (`HEAD`)** | Trả lời: *"Những gì đã `git add` vào chuẩn bị commit khác gì so với phiên bản trước?"* |
| `git diff HEAD` | **Working Directory** vs **Commit gần nhất (`HEAD`)** | Trả lời: *"Toàn bộ thay đổi của tôi (cả đã stage và chưa stage) khác gì so với commit trước?"* |
| `git diff <commitA> <commitB>` | Giữa hai mốc lịch sử cụ thể | Phân tích sai khác giữa hai phiên bản bất kỳ trong quá khứ. |
| `git diff <branchA>..<branchB>` | Giữa hai nhánh phát triển | So sánh toàn bộ các biến đổi giữa đầu mút của nhánh A và nhánh B. |

#### Cấu trúc định dạng chuẩn Unified Diff:
Đầu ra của `git diff` tuân theo chuẩn Unified Diff Format:
```diff
diff --git a/app.py b/app.py
index e69de29..495f4f8 100644
--- a/app.py
+++ b/app.py
@@ -1,3 +1,4 @@
 def main():
-    print("Old Version")
+    print("New Version")
+    print("Feature Added")
```
- `--- a/app.py`: Phiên bản gốc (trước khi thay đổi).
- `+++ b/app.py`: Phiên bản mới (sau khi thay đổi).
- `@@ -1,3 +1,4 @@`: Vùng phân đoạn (*hunk header*). Cho biết từ dòng 1 hiển thị 3 dòng ở bản cũ, và từ dòng 1 hiển thị 4 dòng ở bản mới.
- `-`: Các dòng bị loại bỏ.
- `+`: Các dòng mới được thêm vào.

---

## 6. Thêm và Commit thay đổi

### 6.1. Thao tác đưa dữ liệu vào vùng chuẩn bị (`git add`)

Lệnh `git add` không chỉ đơn thuần là "thêm tệp", mà bản chất là **chụp lại trạng thái chính xác của nội dung tệp tại thời điểm đó** và nạp vào Staging Area (tạo ra một đối tượng Blob tương ứng trong Object Database).

#### Các phương thức thực thi lệnh `git add`:
* **Thêm từng tệp hoặc thư mục riêng lẻ:**
  ```bash
  git add src/main.py docs/
  ```
  Giúp kiểm soát chính xác những thay đổi liên quan chặt chẽ đến một tác vụ cụ thể, bảo đảm nguyên tắc commit nguyên tử (*atomic commit*).
* **Thêm tất cả các thay đổi trong thư mục hiện hành:**
  ```bash
  git add .
  ```
  Quét và đưa toàn bộ các tệp mới, sửa đổi hoặc bị xóa từ thư mục hiện hành trở xuống vào Stage (tôn trọng các quy tắc loại trừ trong `.gitignore`).
* **Thêm tất cả các thay đổi trên toàn bộ repository:**
  ```bash
  git add -A
  # hoặc: git add --all
  ```
  Đảm bảo mọi thay đổi ở mọi đường dẫn bên trong repository đều được stage, bất kể người dùng đang đứng ở thư mục con nào.
* **Chỉ cập nhật các tệp đang được theo dõi (Update tracked files only):**
  ```bash
  git add -u
  ```
  Chỉ ghi nhận thay đổi của các tệp đã có trong Git (sửa hoặc xóa), hoàn toàn bỏ qua các tệp mới tạo (*untracked*).
* **Kỹ thuật chọn lọc phân đoạn mã nguồn nâng cao (Interactive Patch Mode):**
  ```bash
  git add -p
  # hoặc: git add --patch
  ```
  Cho phép lập trình viên duyệt qua từng khối thay đổi (*hunk*) bên trong cùng một tệp và lựa chọn:
  - `y`: Stage khối thay đổi này.
  - `n`: Bỏ qua khối thay đổi này (để lại cho commit sau).
  - `s`: Chia nhỏ khối thay đổi hiện tại thành các khối nhỏ hơn.
  - `e`: Chỉnh sửa trực tiếp khối thay đổi thủ công.

---

### 6.2. Ghi nhận phiên bản vào kho chứa (`git commit`)

Lệnh `git commit` đóng băng nội dung hiện có trong Staging Area thành một mốc lịch sử phiên bản cố định và vĩnh viễn trong kho lưu trữ Git.

#### Cơ chế kỹ thuật bên dưới của một commit:
Khi thực thi `git commit`, Git thực hiện tuần tự các bước:
1. Tạo một đối tượng `tree` từ thông tin trong tệp `index` (đại diện cho cấu trúc thư mục toàn dự án tại thời điểm commit).
2. Tạo một đối tượng `commit` mới chứa:
   - Mã băm SHA-1 trỏ tới đối tượng `tree` vừa tạo.
   - Mã băm SHA-1 trỏ tới commit cha (*parent commit*) mà `HEAD` đang đứng.
   - Tên và email của Author (tác giả viết code) và Committer (người tạo commit).
   - Dấu thời gian (*timestamp*).
   - Nội dung thông điệp mô tả (*commit message*).
3. Cập nhật con trỏ của nhánh hiện tại (ví dụ `refs/heads/main`) trỏ trực tiếp tới commit mới vừa tạo.

#### Các tùy chọn câu lệnh commit phổ biến:
* **Commit kèm thông điệp trực tiếp:**
  ```bash
  git commit -m "feat(auth): add JWT token validation logic"
  ```
* **Bỏ qua bước `git add` đối với các tệp đã theo dõi:**
  ```bash
  git commit -am "fix(api): correct status code for not found error"
  ```
  *(Lưu ý: Cờ `-a` chỉ tự động stage các tệp đã Tracked, không tự động nhận diện các tệp Untracked mới tạo).*
* **Sửa đổi commit gần nhất (`--amend`):**
  ```bash
  git commit --amend -m "feat(auth): add JWT token validation with expiry check"
  ```
  Cho phép gộp thêm các tệp vừa quên vào commit gần nhất hoặc chỉnh sửa lại câu thông điệp của commit gần nhất mà không tạo ra một commit mới thừa thãi. *(Quy tắc an toàn: Tuyệt đối không dùng `--amend` cho các commit đã được `push` lên remote dùng chung).*

---

### 6.3. Tiêu chuẩn viết Commit Message chuyên nghiệp

Trong môi trường kỹ thuật chuyên nghiệp, thông điệp commit là tài liệu lịch sử quan trọng phục vụ rà soát lỗi (*debugging*), kiểm tra mã nguồn (*code review*) và tự động hóa xuất ghi chú phát hành (*Release Notes/Changelog*).

#### 1. Chuẩn Conventional Commits
Quy ước được sử dụng rộng rãi trong các dự án nguồn mở và doanh nghiệp hiện đại:
```text
<type>(<scope>): <subject>

[optional body: mô tả chi tiết nguyên nhân và giải pháp]

[optional footer: tham chiếu issue, Breaking Changes]
```

* **Các phân loại `<type>` chuẩn hóa:**
  - `feat`: Bổ sung một tính năng mới cho người dùng.
  - `fix`: Sửa chữa một lỗi phần mềm (*bug*).
  - `docs`: Cập nhật tài liệu kỹ thuật, README.
  - `style`: Định dạng mã nguồn (khoảng trắng, dấu chấm phẩy, không đổi logic code).
  - `refactor`: Tái cấu trúc mã nguồn (không sửa bug, không thêm tính năng mới).
  - `perf`: Cải tiến hiệu năng xử lý (*performance*).
  - `test`: Bổ sung hoặc chỉnh sửa các bộ kiểm thử (*unit test, integration test*).
  - `chore`: Các công việc bảo trì hệ thống, cấu hình build tool, cập nhật dependency.
  - `ci`: Cấu hình hệ thống tích hợp liên tục (GitHub Actions, GitLab CI).

#### 2. Bảy quy tắc viết Commit Message của Chris Beams:
1. **Ngăn cách tiêu đề và thân bài bằng một dòng trống.**
2. **Giới hạn độ dài dòng tiêu đề trong vòng 50 ký tự.**
3. **Viết hoa chữ cái đầu tiên của dòng tiêu đề.**
4. **Không kết thúc dòng tiêu đề bằng dấu chấm câu.**
5. **Sử dụng thể mệnh lệnh (*imperative mood*) trong dòng tiêu đề.**  
   *(Ví dụ: Dùng `Add feature`, `Fix bug`; không dùng `Added feature`, `Adds feature` hay `Fixing bug`).*
6. **Giới hạn độ dài các dòng trong phần thân bài tối đa 72 ký tự.**
7. **Sử dụng phần thân bài để giải thích "cái gì" và "tại sao", thay vì "như thế nào".**  
   *(Mã nguồn đã thể hiện "như thế nào", commit message cần làm rõ động lực nghiệp vụ và lý do chọn giải pháp).*

#### Ví dụ mẫu một Commit Message chuẩn mực:
```text
feat(storage): implement S3 bucket multipart upload

Add multipart upload capability for files larger than 100MB to prevent
network timeout failures during large asset ingestion. This utilizes the
AWS SDK chunking mechanism with a default part size of 10MB.

Closes #142
```

---

# PHẦN 3: LÀM VIỆC VỚI LỊCH SỬ VÀ PHIÊN BẢN

## 7. Xem lịch sử commit

### 7.1. Truy vấn lịch sử với `git log` và các kỹ thuật lọc nâng cao
Lịch sử commit trong Git không đơn thuần là một danh sách phẳng tuyến tính, mà là một **Đồ thị có hướng không chu trình**, trong đó mỗi commit trỏ ngược về một hoặc nhiều commit cha. Lệnh `git log` là công cụ chính để duyệt qua đồ thị này.

#### 1. Các tùy chọn hiển thị và định dạng định hình:
* **Hiển thị rút gọn trên một dòng:**
  ```bash
  git log --oneline
  ```
  Rút ngắn mã băm SHA thành 7 ký tự đầu và chỉ in ra dòng tiêu đề (*subject*) của commit.
* **Hiển thị chi tiết nội dung sai khác mã nguồn (*Patch format*):**
  ```bash
  git log -p
  # hoặc: git log -p -2 (chỉ xem 2 commit gần nhất)
  ```
  In kèm mã diff chi tiết của từng commit, hiển thị chính xác dòng nào bị xóa (`-`) hoặc thêm mới (`+`).
* **Hiển thị thống kê thay đổi (*Diffstat*):**
  ```bash
  git log --stat
  ```
  Cung cấp báo cáo tóm lược danh sách các tệp bị tác động, số dòng code được chèn thêm hoặc lược bỏ của từng commit.
* **Trực quan hóa nhánh và lịch sử rẽ nhánh / hợp nhất (*Graph view*):**
  ```bash
  git log --graph --oneline --decorate --all
  ```
  Vẽ biểu đồ ASCII minh họa luồng rẽ nhánh (*branching*) và hợp nhất (*merging*) giữa tất cả các nhánh cục bộ và nhánh từ xa (*remote*).

#### 2. Kỹ thuật lọc và tìm kiếm lịch sử chuyên sâu:

| Tùy chọn lọc | Cú pháp câu lệnh | Mục đích kỹ thuật |
| :--- | :--- | :--- |
| **Theo số lượng** | `git log -n 5` | Chỉ hiển thị 5 commit mới nhất |
| **Theo thời gian** | `git log --since="2 weeks ago"`<br>`git log --after="2026-01-01" --before="2026-09-01"` | Lọc commit trong một khoảng thời gian xác định |
| **Theo tác giả** | `git log --author="Nguyen Vinh Tung"` | Lọc các commit được viết bởi một tác giả cụ thể |
| **Theo thông điệp** | `git log --grep="fix(auth)"` | Tìm kiếm các commit có chứa từ khóa trong commit message |
| **Theo tệp cụ thể** | `git log --follow -- path/to/file.py` | Truy xuất toàn bộ lịch sử biến đổi của một tệp (kể cả khi tệp đã bị đổi tên) |
| **Lọc theo nội dung code (*Pickaxe*)** | `git log -S "SECRET_API_KEY"` | Tìm các commit mà tại đó chuỗi ký tự được chỉ định xuất hiện hoặc bị xóa bỏ |

---

### 7.2. Kiểm tra chi tiết một đối tượng cụ thể (`git show`)
Trong khi `git log` duyệt qua danh sách các mốc thời gian, `git show` được thiết kế để mở và kiểm tra chi tiết cấu trúc bên trong của một đối tượng Git cụ thể (Commit, Tag, Tree hoặc Blob).

#### Cú pháp thực thi thông dụng:
* **Xem commit gần nhất (`HEAD`):**
  ```bash
  git show HEAD
  ```
* **Xem một commit bất kỳ qua mã SHA:**
  ```bash
  git show a1b2c3d
  ```
* **Xem nội dung tệp tại một mốc lịch sử mà không cần checkout:**
  ```bash
  git show a1b2c3d:src/config.py
  ```
  Xuất trực tiếp nội dung tệp `src/config.py` ở thời điểm commit `a1b2c3d` ra màn hình mà không làm thay đổi thư mục làm việc hiện tại.

#### Cấu trúc đầu ra của `git show` cho một đối tượng commit:
1. **Commit Metadata:** Mã băm SHA-1 đầy đủ, con trỏ nhánh liên kết.
2. **Author:** Họ tên và email của người lập trình kèm nhãn thời gian tạo ban đầu.
3. **Commit Date:** Thời điểm commit được ghi nhận vào kho chứa.
4. **Commit Message:** Tiêu đề và thân bài mô tả lý do thay đổi.
5. **Unified Diff:** Chi tiết sai biệt của toàn bộ các tệp nằm trong snapshot của commit đó.

---

### 7.3. Truy vết tác giả từng dòng mã nguồn (`git blame`)
Lệnh `git blame` là công cụ phân tích pháp y mã nguồn, hiển thị chi tiết lịch sử chỉnh sửa trên từng dòng của một tập tin: ai là người sửa đổi cuối cùng, tại commit nào, và vào thời điểm nào.

#### Cú pháp và kỹ thuật sử dụng:
* **Truy vết toàn bộ tập tin:**
  ```bash
  git blame src/utils.py
  ```
* **Khoanh vùng dòng cụ thể để phân tích (tối ưu hiệu năng):**
  ```bash
  git blame -L 45,70 src/utils.py
  ```
  Chỉ phân tích từ dòng 45 đến dòng 70 của tệp `src/utils.py`.
* **Bỏ qua các thay đổi thuần về định dạng khoảng trắng:**
  ```bash
  git blame -w -L 10,25 src/utils.py
  ```

#### Cấu trúc một dòng đầu ra của `git blame`:
```text
f0be77ab (Nguyen Vinh Tung 2026-09-29 17:35:44 +0700 45) def calculate_tax(amount):
```
- `f0be77ab`: 8 ký tự đầu của mã SHA commit đã thực hiện thay đổi tại dòng này.
- `(Nguyen Vinh Tung ... 45)`: Tên tác giả, mốc thời gian thực hiện, và số thứ tự dòng trong tệp hiện tại.
- `def calculate_tax(amount):`: Nội dung mã nguồn tại dòng đó.

> `git blame` là công cụ cốt lõi trong quy trình phân tích nguyên nhân gốc rễ khi điều tra sự cố phần mềm trong môi trường Prod.

---

### 7.4. Bản chất của Commit ID (Mã băm SHA-1 / SHA-256)

Mỗi commit trong Git được định danh bằng một chuỗi ký tự hexa duy nhất gồm 40 ký tự (ví dụ: `f0be77ab23c4d5e6f708192a3b4c5d6e7f8091a2`). Chuỗi này không phải là số thứ tự tăng dần ngẫu nhiên (như Revision 1, 2, 3 của SVN), mà là kết quả của **hàm băm mật mã học SHA-1** (*Secure Hash Algorithm 1*).

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                       CẤU TRÚC DỮ LIỆU ĐƯỢC BĂM THÀNH COMMIT SHA            │
├─────────────────────────────────────────────────────────────────────────────┤
│  Header:  commit <độ dài nội dung tính theo byte>\0                         │
│  Tree:    tree 58a98442da2b7a3e7ef1f7053e1a8a25c17d4d39                     │
│  Parent:  parent 948d9f67a2f58e1781bcf704e6c92d5218d6bf9e                   │
│  Author:  Vinh Tung <TUNGNV.B23KH130@stu.ptit.edu.vn> 1727685000 +0700      │
│  Commit:  Vinh Tung <TUNGNV.B23KH130@stu.ptit.edu.vn> 1727685000 +0700      │
│                                                                             │
│  Message: feat(auth): add JWT token validation logic                        │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │
                                       ▼ Thuật toán băm SHA-1 (160 bits)
                 Chuỗi định danh duy nhất (Commit ID):
                 "f0be77ab23c4d5e6f708192a3b4c5d6e7f8091a2"
```

#### Các đặc tính kỹ thuật cốt lõi:
1. **Tính xác định (*Deterministic*):** Cùng một nội dung tệp, cùng tác giả, thời gian và commit cha sẽ luôn cho ra một chuỗi băm giống hệt nhau.
2. **Hiệu ứng tuyết lở (*Avalanche Effect*):** Chỉ cần thay đổi 1 ký tự trong mã nguồn, hoặc lệch 1 giây trong dấu thời gian, mã băm đầu ra sẽ biến đổi hoàn toàn không thể đoán trước.
3. **Tính toàn vẹn dữ liệu bất biến (*Cryptographic Immutability*):** Không thể thay đổi bất kỳ nội dung nào của một commit trong quá khứ mà không làm thay đổi commit SHA của nó và toàn bộ các commit con cháu phía sau.
4. **Mã băm rút gọn (*Short SHA*):** Git chỉ yêu cầu tối thiểu từ 7 ký tự đầu tiên để xác định một commit duy nhất trong phạm vi một repository (ví dụ `f0be77a`).
5. **Chuyển dịch sang SHA-256:** Để phòng ngừa nguy cơ va chạm mã băm, Git hiện đại đã hoàn thiện kiến trúc hỗ trợ thuật toán băm SHA-256 (cho ra chuỗi 64 ký tự hexa).

---

## 8. Undo / Revert / Reset thay đổi

Trong kỹ thuật Git, việc hoàn tác sai sót được phân cấp theo phạm vi tác động: từ mức độ tệp cục bộ chưa commit cho đến hoàn tác các commit đã được đẩy lên máy chủ dùng chung.

### 8.1. Các kỹ thuật khôi phục cục bộ (`git restore` và `git checkout`)
Kể từ phiên bản Git 2.23, lệnh `git restore` được giới thiệu nhằm tách biệt hoàn toàn chức năng khôi phục tệp ra khỏi lệnh đa nhiệm phức tạp `git checkout`.

#### 1. Khôi phục Working Directory (Hủy bỏ sửa đổi chưa stage):
```bash
git restore <file>
# Hoặc khôi phục toàn bộ thư mục hiện hành:
git restore .
```
- **Hành vi:** Lấy lại nội dung tệp từ **Staging Area** (hoặc commit gần nhất nếu chưa stage) để ghi đè vào Working Directory. Toàn bộ các dòng code sửa chưa stage sẽ bị hủy bỏ vĩnh viễn.

#### 2. Hủy bỏ tệp khỏi Staging Area (Un-stage):
```bash
git restore --staged <file>
```
- **Hành vi:** Đưa tệp từ trạng thái **Staged** quay trở về trạng thái **Modified** trong Working Directory. Mã nguồn đang sửa đổi của lập trình viên vẫn được bảo toàn nguyên vẹn.

#### 3. Khôi phục tệp về một mốc commit bất kỳ trong quá khứ:
```bash
git restore --source=<commit-sha> <file>
```

---

### 8.2. Cơ chế và ba chế độ của `git reset` (Soft, Mixed, Hard)
Lệnh `git reset` tác động trực tiếp lên lịch sử commit bằng cách **di chuyển con trỏ nhánh hiện hành và con trỏ `HEAD` lùi về một mốc commit trước đó**.

```text
Giả định lịch sử ban đầu:
(Commit A) ────► (Commit B) ────► (Commit C) ◄── HEAD, main

Thực thi lệnh: git reset [mode] Commit B
```

```text
┌─────────────┬──────────────────────────┬──────────────────────────┬──────────────────────────┐
│ Chế độ      │ Con trỏ HEAD & Branch    │ Staging Area (Index)     │ Working Directory        │
├─────────────┼──────────────────────────┼──────────────────────────┼──────────────────────────┤
│ --soft      │ Lùi về Commit B          │ GIỮ NGUYÊN thay đổi      │ GIỮ NGUYÊN thay đổi      │
│             │                          │ của Commit C (ở Staged)  │ trên đĩa                 │
├─────────────┼──────────────────────────┼──────────────────────────┼──────────────────────────┤
│ --mixed     │ Lùi về Commit B          │ ĐẶT LẠI theo Commit B    │ GIỮ NGUYÊN thay đổi      │
│ (Mặc định)  │                          │ (hủy Staged của C)       │ của C (chuyển Un-staged) │
├─────────────┼──────────────────────────┼──────────────────────────┼──────────────────────────┤
│ --hard      │ Lùi về Commit B          │ ĐẶT LẠI theo Commit B    │ ĐẶT LẠI theo Commit B    │
│ (Nguy hiểm) │                          │                          │ (XÓA BỎ toàn bộ code C)  │
└─────────────┴──────────────────────────┴──────────────────────────┴──────────────────────────┘
```

#### Phân tích chi tiết từng chế độ:

1. **`git reset --soft <commit-target>`:**
   - Chỉ di chuyển con trỏ `HEAD` và con trỏ nhánh về `<commit-target>`.
   - Giữ nguyên toàn bộ nội dung của các commit bị bỏ lại trong Staging Area.
   - **Kịch bản thực tế:** Dùng để gộp (*squash*) nhiều commit nhỏ lẻ, commit thử nghiệm chưa hoàn thiện thành một commit duy nhất trước khi tạo Pull Request.
2. **`git reset --mixed <commit-target>` (Chế độ mặc định khi không truyền cờ):**
   - Di chuyển con trỏ `HEAD` về `<commit-target>`.
   - Cập nhật lại Staging Area theo `<commit-target>`.
   - Toàn bộ thay đổi của các commit sau mốc target được đưa về trạng thái **Modified** trong Working Directory.
   - **Kịch bản thực tế:** Dùng khi muốn tổ chức và chia tách lại các nhóm tệp để commit lại theo các logic mạch lạc hơn.
3. **`git reset --hard <commit-target>`:**
   - Di chuyển `HEAD`, đặt lại Staging Area VÀ ghi đè toàn bộ Working Directory khớp hoàn toàn với `<commit-target>`.
   - Mọi thay đổi chưa commit và toàn bộ mã nguồn của các commit phía sau mốc target sẽ bị **xóa sạch khỏi ổ đĩa**.
   - **Cảnh báo an toàn:** Thao tác này có tính phá hủy dữ liệu, chỉ sử dụng khi chắc chắn muốn vứt bỏ toàn bộ những gì đã làm kể từ commit mục tiêu.

---

### 8.3. Hoàn tác an toàn với `git revert`
Ngược lại với `git reset` (thay đổi lịch sử bằng cách kéo lùi con trỏ), `git revert` hoạt động bằng cách **tạo ra một commit mới có nội dung đảo ngược chính xác những thay đổi đã diễn ra trong commit được chỉ định**.

```text
1. BAN ĐẦU:
   (Commit A) ───► (Commit B) ───► (Commit C - Gây lỗi) ◄── HEAD, main

2. SAU KHI THỰC THI: git revert Commit C
   (Commit A) ───► (Commit B) ───► (Commit C - Gây lỗi) ───► (Commit C' - Đảo ngược C) ◄── HEAD, main
```

#### Cú pháp thực thi:
* **Hoàn tác một commit đơn lẻ:**
  ```bash
  git revert <commit-id>
  ```
  Git sẽ tự động mở trình soạn thảo văn bản để xác nhận thông điệp commit hoàn tác (mặc định dạng `Revert "feat: add feature X"`).
* **Hoàn tác nhưng chưa tạo commit ngay (để kiểm tra trước):**
  ```bash
  git revert --no-commit <commit-id>
  ```

---

### 8.4. Bảng quyết định: Khi nào nên dùng `git revert` thay vì `git reset`?

| Tiêu chí | `git reset` | `git revert` |
| :--- | :--- | :--- |
| **Bản chất kỹ thuật** | Viết lại lịch sử (kéo lùi con trỏ commit). | Tiến về phía trước (sinh ra commit mới đảo ngược code). |
| **Lịch sử commit** | Các commit bị reset sẽ biến mất khỏi cây lịch sử chính. | Lịch sử commit được bảo toàn 100%, có vết tích minh bạch. |
| **Độ an toàn khi làm việc nhóm** | **Cực kỳ nguy hiểm nếu đã push** (gây xung đột cho người khác khi pull). | **Tuyệt đối an toàn** (tương thích hoàn toàn với remote dùng chung). |
| **Khả năng khôi phục sai sót** | Cần can thiệp sâu bằng `git reflog` mới cứu được. | Có thể revert lại chính commit revert đó nếu đổi ý. |
| **Kịch bản khuyến nghị** | Sửa sai các commit cá nhân **ở máy cục bộ (chưa `git push`)**. | Khắc phục sự cố trên **các nhánh dùng chung (`main`, `develop`) đã được `push`**. |

> Không bao giờ sử dụng `git reset` đối với các commit đã được đẩy lên nhánh công khai của Remote Repository. Trong môi trường làm việc nhóm, luôn ưu tiên sử dụng `git revert`.

---

## 9. Làm việc với `.gitignore`

### 9.1. Ý nghĩa và mục đích kỹ thuật của `.gitignore`
Tập tin `.gitignore` là một tệp cấu hình văn bản thuần túy đặt tại thư mục gốc (hoặc các thư mục con) của repository, chỉ định rõ những mẫu đường dẫn (*patterns*) mà Git phải **bỏ qua một cách có chủ đích**.

#### Mục đích cốt lõi:
1. **Bảo mật thông tin tuyệt mật:** Ngăn chặn việc vô tình đưa các tập tin chứa biến môi trường, khóa bí mật, thông tin tài khoản cơ sở dữ liệu (`.env`, `credentials.json`, `id_rsa`) lên kho chứa công khai.
2. **Tối ưu hóa dung lượng repository:** Loại bỏ các thư viện phụ thuộc của bên thứ ba được tải tự động (như `node_modules/`, `vendor/`), các tệp nhị phân đã build (`.exe`, `.dll`, `.class`, `.so`).
3. **Tránh xung đột môi trường (*OS Noise*):** Bỏ qua các tệp tạm do hệ điều hành và IDE sinh ra tự động (`.DS_Store` của macOS, `Thumbs.db` của Windows, thư mục cấu hình `.vscode/`, `.idea/`).
4. **Giữ sạch trạng thái làm việc:** Giúp `git status` luôn phản ánh chính xác các tệp mã nguồn nghiệp vụ thực sự mà không bị làm nhiễu bởi hàng trăm tệp sinh tự động.

---

### 9.2. Cú pháp và quy tắc khớp mẫu (*Pattern Matching Rules*)

Cú pháp trong `.gitignore` tuân theo chuẩn **Glob Pattern** (tương tự quy tắc mở rộng đường dẫn của Shell):

```gitignore
# 1. Dấu thăng (#) dùng để chú thích ghi chú
# Các dòng trống hoàn toàn được Git bỏ qua

# 2. Khớp theo phần mở rộng của tệp
*.log        # Bỏ qua tất cả các tệp có đuôi .log ở mọi thư mục
*.tmp        # Bỏ qua các tệp tạm thời

# 3. Dấu gạch chéo đầu (/) neo khớp chính xác từ thư mục chứa file .gitignore
/TODO.md     # Chỉ bỏ qua file TODO.md ở thư mục gốc, KHÔNG bỏ qua subdir/TODO.md

# 4. Dấu gạch chéo cuối (/) chỉ định rõ ràng mục tiêu là một thư mục
build/       # Bỏ qua toàn bộ thư mục build/ và tất cả nội dung bên trong nó
temp/        # Bỏ qua thư mục temp/

# 5. Dấu chấm hỏi (?) khớp đúng một ký tự bất kỳ
test?.js     # Bỏ qua test1.js, testA.js nhưng KHÔNG bỏ qua test12.js

# 6. Dấu sao kép (**) khớp qua nhiều cấp thư mục lồng nhau
logs/**/*.log    # Bỏ qua mọi file .log nằm trong logs/ hoặc bất kỳ thư mục con nào của nó
**/temp          # Bỏ qua bất kỳ thư mục temp nào ở mọi cấp độ

# 7. Dấu chấm than (!) dùng để phủ định (giữ lại không bỏ qua)
!important.log   # Vẫn theo dõi file important.log mặc dù ở trên đã đặt rule *.log
```

---

### 9.3. Các mẫu `.gitignore` chuẩn hóa theo từng hệ sinh thái công nghệ

#### 1. Hệ sinh thái Python & Trí tuệ nhân tạo (AI / Data Science):
```gitignore
# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# C/C++ extensions
*.so

# Môi trường ảo (Virtual Environments)
.venv/
env/
venv/
ENV/

# Tệp biến môi trường và bí mật
.env
.env.local

# Dữ liệu huấn luyện, checkpoint mô hình lớn
*.pt
*.pth
*.onnx
checkpoints/
runs/
data/raw/
```

#### 2. Hệ sinh thái Node.js / JavaScript / TypeScript:
```gitignore
# Dependencies
node_modules/
jspm_packages/

# Build outputs
dist/
build/
.next/
out/

# Logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Environment files
.env
.env*.local
```

#### 3. Hệ sinh thái Java / Cloud / IDEs & Hệ điều hành:
```gitignore
# Build targets
target/
*.class
*.jar
*.war

# IDE files
.idea/
*.iml
.vscode/
.project
.settings/

# OS specific files
.DS_Store
Thumbs.db
desktop.ini
```

---

### 9.4. Kỹ thuật gỡ bỏ tệp đã bị track trước khi thêm vào `.gitignore`

Một lỗi rất phổ biến trong thực tế: **Lập trình viên đã commit một tệp lên Git từ trước, sau đó mới bổ sung tên tệp đó vào `.gitignore`**. Khi đó, Git vẫn tiếp tục theo dõi tệp vì quy tắc trong `.gitignore` chỉ có tác dụng đối với các tệp **Untracked**.

#### Quy trình xử lý chuẩn kỹ thuật:
Để ngừng theo dõi một tệp (hoặc thư mục) mà vẫn **giữ nguyên tệp vật lý đó trên ổ đĩa**, sử dụng lệnh `git rm` kèm cờ `--cached`:

```bash
# Bước 1: Xóa tệp khỏi Staging Area và Git Index (vẫn giữ file trên máy)
git rm --cached path/to/file.env

# Hoặc nếu là một thư mục (ví dụ node_modules/ đã lỡ bị commit):
git rm -r --cached node_modules/

# Bước 2: Thêm lại toàn bộ thay đổi vào Staging Area (lúc này .gitignore sẽ phát huy tác dụng)
git add .

# Bước 3: Commit lại để hoàn tất việc loại bỏ tệp khỏi sự theo dõi của Git
git commit -m "chore: untrack cached files specified in .gitignore"
```

Sau thao tác này, tệp sẽ chuyển về trạng thái `Untracked` và lập tức bị `.gitignore` chặn lại, không bao giờ xuất hiện trong `git status` nữa.

---

# Phần 4: Nhánh (Branching) & hợp nhất (Merging)

## 10. Branch là gì và tại sao cần Branch?

### 10.1. Bản chất kỹ thuật của Branch trong Git
Khác biệt căn bản lớn nhất giữa Git và các hệ thống quản lý phiên bản tập trung truyền thống (như SVN, CVS) nằm ở cách thức hiện thực hóa khái niệm phân nhánh (*Branching*):
* **Trong SVN:** Tạo một nhánh đồng nghĩa với việc sao chép toàn bộ cây thư mục mã nguồn sang một thư mục mới trong kho lưu trữ, tiêu tốn dung lượng đĩa và thời gian tỷ lệ thuận với kích thước dự án.
* **Trong Git:** Một nhánh về bản chất chỉ là **một con trỏ 41 bytes** (chứa đúng 40 ký tự mã băm SHA-1 của commit đầu mút kèm một ký tự xuống dòng), được lưu trữ dưới dạng một tệp văn bản nhỏ nằm tại `.git/refs/heads/<tên-nhánh>`.

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                   CƠ CHẾ CON TRỎ NHÁNH VÀ CON TRỎ HEAD TRONG GIT            │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│                                           ┌──────────────┐                  │
│                                           │  HEAD Pointer│                  │
│                                           └──────┬───────┘                  │
│                                                  │ (tham chiếu)             │
│                                                  ▼                          │
│                                           ┌──────────────┐                  │
│                                           │  Branch: main│                  │
│                                           └──────┬───────┘                  │
│                                                  │                          │
│       ┌──────────────┐    ┌──────────────┐    ┌──▼───────────┐              │
│       │   Commit A   │◄───┤   Commit B   │◄───┤   Commit C   │              │
│       │  (sha: 948d) │    │  (sha: e033) │    │  (sha: f0be) │              │
│       └──────────────┘    └──────────────┘    └──────────────┘              │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### Các nguyên lý vận hành cốt lõi:
1. **Độ phức tạp $O(1)$:** Do chỉ thao tác ghi 41 bytes dữ liệu lên đĩa, chi phí thời gian và tài nguyên để tạo, chuyển đổi hoặc xóa bỏ một nhánh trong Git là tức thì ($O(1)$), hoàn toàn không phụ thuộc vào quy mô dự án lớn hay nhỏ.
2. **Vai trò của con trỏ `HEAD`:** `HEAD` là một con trỏ tượng trưng (*symbolic reference*) cho biết môi trường làm việc (*Working Directory*) hiện tại đang gắn với nhánh nào (mặc định lưu tại `.git/HEAD` với nội dung `ref: refs/heads/main`).
3. **Cơ chế tự động tịnh tiến:** Khi lập trình viên thực hiện một commit mới, Git tự động cập nhật con trỏ của nhánh hiện tại trỏ tới commit mới này, và con trỏ `HEAD` tự động di chuyển theo.

---

### 10.2. Tại sao cần sử dụng Branch trong phát triển phần mềm?
Trong quy trình kỹ thuật công nghiệp, phân nhánh là phương tiện bắt buộc nhằm đạt được các mục tiêu kiến trúc và vận hành:

1. **Cô lập không gian làm việc (*Workspace Isolation*):**
   - Cho phép phát triển các tính năng phức tạp hoặc thử nghiệm các giải pháp kiến trúc mới mà không làm xáo trộn nhánh chính đang hoạt động ổn định.
   - Nếu tính năng thử nghiệm thất bại, lập trình viên có thể xóa bỏ nhánh đó mà không để lại bất kỳ rác thải hay ảnh hưởng nào tới phần còn lại của hệ thống.
2. **Hỗ trợ phát triển song song quy mô lớn (*Concurrent Development*):**
   - Hàng chục lập trình viên có thể làm việc độc lập trên các nhánh riêng biệt cùng một lúc mà không bị phụ thuộc hay chặn đứng công việc của nhau (*non-blocking*).
3. **Bảo vệ tính toàn vẹn của nhánh sản xuất (*Production-Ready Baseline*):**
   - Nhánh chính (thường là `main` hoặc `master`) được thiết lập chính sách bảo vệ, chỉ tiếp nhận mã nguồn đã trải qua kiểm thử tự động (CI/CD) và quy trình bình duyệt mã nguồn.
4. **Xử lý sự cố khẩn cấp độc lập (*Hotfix Capability*):**
   - Khi phát hiện lỗi nghiêm trọng trên môi trường Production, lập trình viên có thể tạo ngay một nhánh nóng từ phiên bản đang chạy để sửa lỗi và phát hành ngay lập tức, mà không bị vướng các tính năng chưa hoàn thiện đang nằm trên các nhánh phát triển khác.

---

## 11. Tạo và chuyển nhánh (Branch Management)

### 11.1. Các câu lệnh quản trị nhánh (`git branch`)
Lệnh `git branch` chịu trách nhiệm tạo lập, liệt kê, đổi tên và xóa bỏ các con trỏ nhánh trong kho chứa cục bộ.

#### Bảng tổng hợp cú pháp quản trị nhánh:

| Cú pháp câu lệnh | Chức năng kỹ thuật |
| :--- | :--- |
| `git branch` | Liệt kê tất cả các nhánh cục bộ (nhánh hiện hành có dấu `*` và màu xanh) |
| `git branch -v`<br>*(hoặc `--verbose`)* | Liệt kê nhánh kèm theo mã SHA-1 rút gọn và tiêu đề commit mới nhất |
| `git branch -a`<br>*(hoặc `--all`)* | Liệt kê toàn bộ các nhánh cục bộ lẫn các nhánh theo dõi từ xa (*Remote Tracking Branches*) |
| `git branch <tên-nhánh>` | Tạo một con trỏ nhánh mới trỏ vào commit hiện tại (chưa chuyển sang nhánh mới) |
| `git branch -m <tên-cũ> <tên-mới>` | Đổi tên nhánh hiện có |
| `git branch -d <tên-nhánh>` | Xóa an toàn một nhánh (chỉ xóa được nếu nhánh đã được hợp nhất hoàn toàn) |
| `git branch -D <tên-nhánh>` | Cưỡng chế xóa nhánh (*Force Delete*) kể cả khi nhánh chứa commit chưa merge |

---

### 11.2. Chuyển đổi ngữ cảnh làm việc (`git checkout` vs `git switch`)
Trong các phiên bản Git cũ, lệnh `git checkout` kiêm nhiệm quá nhiều nhiệm vụ: vừa dùng để chuyển nhánh, vừa dùng để khôi phục tệp trên đĩa, vừa chuyển tới commit cụ thể. Để tách bạch chức năng, kể từ phiên bản **Git 2.23 (phát hành năm 2019)**, lệnh **`git switch`** được giới thiệu với vai trò chuyên biệt duy nhất: **quản lý và chuyển đổi nhánh**.

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                 BẢNG ĐỐI CHIẾU CÚ PHÁP: GIT CHECKOUT VS GIT SWITCH          │
├───────────────────────────────────┬─────────────────────────────────────────┤
│ Thao tác kỹ thuật                 │ Cú pháp hiện đại (Khuyến nghị)          │ Cú pháp truyền thống                    │
├───────────────────────────────────┼─────────────────────────────────────────┼─────────────────────────────────────────┤
│ Chuyển sang nhánh có sẵn          │ git switch <tên-nhánh>                  │ git checkout <tên-nhánh>                │
│ Tạo mới VÀ chuyển sang nhánh đó   │ git switch -c <tên-nhánh>               │ git checkout -b <tên-nhánh>             │
│ Chuyển về nhánh làm việc trước đó │ git switch -                            │ git checkout -                          │
│ Rút nhánh từ remote về máy        │ git switch --track origin/<tên-nhánh>   │ git checkout --track origin/<tên-nhánh> │
└───────────────────────────────────┴─────────────────────────────────────────┴─────────────────────────────────────────┘
```

> Trong môi trường lập trình hiện đại, khuyến nghị ưu tiên sử dụng `git switch` cho tác vụ chuyển nhánh và `git restore` cho tác vụ hoàn tác tệp để tránh nhầm lẫn rủi ro mất dữ liệu vốn có của `git checkout`.

---

### 11.3. Trạng thái con trỏ tách rời (*Detached HEAD State*)

#### 1. Định nghĩa kỹ thuật:
Trạng thái **Detached HEAD** xảy ra khi con trỏ `HEAD` trỏ trực tiếp vào một mốc commit cụ thể hoặc một tag trên cây lịch sử, thay vì trỏ vào một con trỏ nhánh đại diện.

```text
Trạng thái bình thường (Attached):
HEAD ────► refs/heads/main ────► [Commit C]

Trạng thái Detached HEAD (khi chạy: git checkout <Commit-B-SHA>):
HEAD ──────────────────────────► [Commit B]
refs/heads/main ───────────────► [Commit C]
```

#### 2. Nguy cơ tiềm ẩn:
Nếu lập trình viên tạo các commit mới trong khi đang ở trạng thái Detached HEAD, các commit này không gắn với bất kỳ nhánh nào. Khi người dùng chuyển sang một nhánh khác (`git switch main`), các commit mới này sẽ bị cô lập (*unreachable commits*). Sau một khoảng thời gian (mặc định 30 ngày), tiến trình dọn rác tự động của Git (**`git gc`**) sẽ xóa vĩnh viễn chúng khỏi Object Database.

#### 3. Cách cứu dữ liệu khi lỡ commit ở trạng thái Detached HEAD:
Để giữ lại các commit đã tạo, chỉ cần gắn một con trỏ nhánh mới cho commit hiện tại trước khi chuyển đi:
```bash
git switch -c feature/saved-work
```

---

## 12. Merge Branch & Xử lý xung đột

Hợp nhất nhánh là quá trình tích hợp lịch sử và các thay đổi từ một nhánh nguồn vào nhánh đích hiện tại.

### 12.1. Các kỹ thuật hợp nhất nhánh cốt lõi

#### 1. Fast-Forward Merge (Hợp nhất tịnh tiến nhanh)
Xảy ra khi con trỏ của nhánh hiện tại không có thêm bất kỳ commit mới nào kể từ thời điểm phân nhánh của nhánh được merge.

```text
BAN ĐẦU:
(main) ────► [Commit A] ────► [Commit B] ◄── main
                                  │
                                  └────► [Commit C] ────► [Commit D] ◄── feature

KHI THỰC HIỆN TRÊN MAIN: git merge feature
(main) ────► [Commit A] ────► [Commit B] ────► [Commit C] ────► [Commit D] ◄── main, feature
```
- **Đặc điểm:** Git chỉ đơn giản dời con trỏ `main` tiến thẳng tới vị trí của `feature`. Không có commit hợp nhất nào được sinh ra.
- **Tùy chọn vô hiệu hóa Fast-Forward (`--no-ff`):**
  ```bash
  git merge --no-ff feature
  ```
  Ép buộc Git luôn luôn tạo ra một Merge Commit thực thể, giúp lưu vết rõ ràng mốc thời gian một tính năng được tích hợp vào nhánh chính.

---

#### 2. Three-Way Merge (Hợp nhất ba bên)
Xảy ra khi cả nhánh đích và nhánh nguồn đều có những commit mới độc lập sau điểm rẽ nhánh chung.

```text
BAN ĐẦU:
                           ┌────► [Commit C] ────► [Commit D] ◄── main
                           │
(Ancestor) ──► [Commit A] ─┤
                           │
                           └────► [Commit E] ────► [Commit F] ◄── feature

KHI THỰC HIỆN TRÊN MAIN: git merge feature
                           ┌────► [Commit C] ────► [Commit D] ─────────┐
                           │                                           ▼
(Ancestor) ──► [Commit A] ─┤                                  ┌────────────────┐
                           │                                  │ [Merge Commit] │ ◄── main
                           └────► [Commit E] ────► [Commit F] ─────────▲ (2 parents)   │
                                                              └────────────────┘
```

- **Nguyên lý 3 bên (Three-Way):** Git sử dụng 3 ảnh chụp (*snapshots*) để tính toán kết quả:
  1. Commit tổ tiên chung gần nhất (*Common Ancestor* - Commit A).
  2. Commit đầu mút của nhánh hiện tại (*Target HEAD* - Commit D).
  3. Commit đầu mút của nhánh nguồn cần gộp (*Source HEAD* - Commit F).
- Git áp dụng thuật toán hợp nhất (mặc định là chiến lược `ort` - *Ostensibly Recursive's Twin*) để tự động ghép các thay đổi không trùng vị trí và tạo ra một **Merge Commit** mới có **hai commit cha**.

---

### 12.2. Xung đột hợp nhất (Merge Conflict)

#### 1. Nguyên nhân kỹ thuật:
Xung đột xảy ra khi cùng một dòng (hoặc một khối dòng liền kề) trong cùng một tệp bị sửa đổi khác nhau trên cả hai nhánh kể từ mốc tổ tiên chung, hoặc một nhánh sửa đổi tệp trong khi nhánh kia xóa bỏ tệp đó. Khi đó, thuật toán tự động của Git không thể quyết định phiên bản nào là đúng về mặt nghiệp vụ và bắt buộc lập trình viên phải can thiệp thủ công.

#### 2. Cấu trúc đánh dấu xung đột (*Conflict Markers*):
Khi xung đột xảy ra, Git tạm dừng quá trình merge và chèn các ký tự chỉ thị trực tiếp vào nội dung tệp:

```text
<<<<<<< HEAD
const API_BASE_URL = "https://api.production.internal/v1";
=======
const API_BASE_URL = "https://api-cloud.ptit.edu.vn/v2";
>>>>>>> feature/update-api-endpoint
```
- `<<<<<<< HEAD`: Bắt đầu khối mã nguồn thuộc về nhánh hiện tại đang đứng (Target branch).
- `=======`: Ranh giới phân chia giữa hai phiên bản xung đột.
- `>>>>>>> feature/...`: Kết thúc khối mã nguồn thuộc về nhánh được chỉ định merge vào (Source branch).

---

### 12.3. Quy trình 4 bước chuẩn giải quyết Conflict

```text
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│     BƯỚC 1      │     │     BƯỚC 2      │     │     BƯỚC 3      │     │     BƯỚC 4      │
│  Xác định tệp   │────►│  Xử lý thủ công │────►│  Đưa vào Stage  │────►│  Hoàn tất Merge │
│   bị xung đột   │     │    khối mã      │     │     git add     │     │   git commit    │
└─────────────────┘     └─────────────────┘     └─────────────────┘     └─────────────────┘
```

1. **Bước 1: Xác định danh sách tệp xung đột:**
   ```bash
   git status
   ```
   Các tệp có mâu thuẫn sẽ được nhóm riêng trong mục: `Unmerged paths: (both modified)`.
2. **Bước 2: Xử lý mâu thuẫn trong mã nguồn:**
   - Mở tệp bị xung đột bằng IDE (VS Code, IntelliJ).
   - Trao đổi với tác giả của nhánh đối phương để thống nhất logic đúng.
   - Xóa bỏ hoàn toàn các dòng chỉ thị `<<<<<<<`, `=======`, `>>>>>>>` và giữ lại mã nguồn hoàn thiện cuối cùng.
3. **Bước 3: Đánh dấu tệp đã giải quyết:**
   ```bash
   git add path/to/resolved-file.js
   ```
   Lệnh `git add` thông báo cho Git biết tệp này đã được giải quyết mâu thuẫn thành công và đưa vào Staging Area.
4. **Bước 4: Hoàn thành commit hợp nhất:**
   ```bash
   git commit -m "merge: resolve conflict between main and feature/update-api-endpoint"
   ```
   *(Hoặc gõ `git merge --continue`).*

> [!CAUTION]
> **Phương án hủy bỏ khẩn cấp:** Nếu xung đột quá phức tạp hoặc phát hiện merge nhầm nhánh, lập trình viên có thể khôi phục trạng thái ban đầu an toàn 100% trước khi bắt đầu merge bằng lệnh:
> ```bash
> git merge --abort
> ```

---

## 13. Chiến lược phân nhánh phổ biến trong công nghiệp (Branching Strategies)

Lựa chọn chiến lược phân nhánh phù hợp là yếu tố quyết định tốc độ phát hành, chất lượng mã nguồn và sự nhịp nhàng trong cộng tác nhóm.

### 13.1. Mô hình Git Flow

Được Vincent Driessen đề xuất năm 2010, **Git Flow** là mô hình phân nhánh nghiêm ngặt, có tính cấu trúc rất cao, lý tưởng cho các phần mềm đóng gói truyền thống hoặc các hệ thống có chu kỳ phát hành cố định (*scheduled release cycles*).

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                            MÔ HÌNH NHÁNH GIT FLOW                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  main      ────(v1.0.0)───────────────────────────(v1.1.0)──────(v1.1.1)──  │
│                   ▲                                  ▲              ▲       │
│                   │                                  │              │       │
│  hotfix           │                                  │      ┌───────┴───┐   │
│                   │                                  │      │hotfix/1.1.1│  │
│                   │                                  │      └───┬───────┘   │
│                   │                                  │          │           │
│  release          │                          ┌───────┴──────┐   │           │
│                   │                          │release/v1.1.0│   │           │
│                   │                          └───▲──────────┘   │           │
│                   │                              │              │           │
│  develop   ───────┴──────────────────────────────┴──────────────┴─────────  │
│                       ▲                      ▲                              │
│                       │                      │                              │
│  feature              └───────[feature/auth]─┘                              │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### Hệ thống 5 loại nhánh trong Git Flow:
1. **`main` (Nhánh vĩnh viễn):** Lưu trữ mã nguồn phiên bản sản xuất đang chạy thực tế, tuyệt đối ổn định. Mỗi commit tại đây luôn được đánh nhãn phiên bản (*release tag*).
2. **`develop` (Nhánh vĩnh viễn):** Nhánh tích hợp trung tâm, tập hợp toàn bộ các tính năng đã sẵn sàng cho kỳ phát hành kế tiếp.
3. **`feature/*` (Nhánh tạm thời):** Tách từ `develop` để xây dựng tính năng mới; sau khi hoàn tất được merge ngược lại vào `develop`.
4. **`release/*` (Nhánh tạm thời):** Tách từ `develop` khi chuẩn bị đóng gói phiên bản; chỉ dùng để sửa lỗi nhỏ, bổ sung tài liệu kỹ thuật; sau đó merge đồng thời vào cả `main` lẫn `develop`.
5. **`hotfix/*` (Nhánh tạm thời):** Tách trực tiếp từ `main` khi có lỗi khẩn cấp ở Production; sửa xong được merge đồng thời vào cả `main` và `develop`.

---

### 13.2. Mô hình GitHub Flow

**GitHub Flow** là mô hình phân nhánh cực kỳ tinh gọn và linh hoạt, được thiết kế chuyên biệt cho các hệ thống web hiện đại, dịch vụ Cloud/SaaS và các đội ngũ triển khai liên tục (*Continuous Deployment - CD*), nơi mã nguồn được đẩy lên Production nhiều lần mỗi ngày.

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                           MÔ HÌNH NHÁNH GITHUB FLOW                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│            Tạo nhánh          Commit & Push          Mở PR / Review         │
│          ┌───────────┐       ┌─────────────┐       ┌─────────────────┐      │
│  main ───┤           ├───────┤             ├───────┤                 ├───►  │
│          └─────┬─────┘       └─────────────┘       └────────┬────────┘      │
│                │                                            │               │
│                └──────────► [feature/cloud-api] ────────────┘               │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### Quy trình 5 bước tinh gọn của GitHub Flow:
1. Nhánh `main` là nhánh duy nhất có tính lâu dài và **luôn luôn ở trạng thái sẵn sàng triển khai** (*deployable*).
2. Khi bắt đầu tác vụ mới, tạo một nhánh có tên gợi nhớ mục đích từ `main` (ví dụ `feature/add-oauth2`).
3. Commit đều đặn và thường xuyên đẩy nhánh lên máy chủ từ xa (*push to remote*).
4. Mở một **Pull Request (PR)** để kích hoạt hệ thống kiểm thử tự động (CI Runner), thảo luận thiết kế và tiến hành bình duyệt mã (*Code Review*).
5. Sau khi PR được phê duyệt và vượt qua tất cả kiểm thử, merge trực tiếp vào `main` và kích hoạt tự động pipeline deploy lên môi trường Production.

---

### 13.3. Bảng so sánh và tiêu chí lựa chọn chiến lược phân nhánh

| Tiêu chí | Git Flow | GitHub Flow | GitLab Flow |
| :--- | :--- | :--- | :--- |
| **Độ phức tạp** | **Cao** (yêu cầu kỷ luật nghiêm ngặt) | **Rất thấp** (đơn giản, tinh gọn) | **Trung bình** |
| **Số nhánh dài hạn** | 2 nhánh (`main`, `develop`) | 1 nhánh duy nhất (`main`) | Thường từ 2-3 nhánh (theo môi trường) |
| **Chu kỳ phát hành** | Theo lịch trình cố định (vài tuần/tháng) | Liên tục nhiều lần trong ngày (CD) | Triển khai theo giai đoạn môi trường |
| **Áp dụng phù hợp cho** | Phần mềm đóng gói, Mobile App, hệ thống viễn thông/ngân hàng | Web SaaS, REST API, Cloud-Native Microservices | Dự án triển khai đa môi trường (*Dev ➔ Staging ➔ Prod*) |
| **Quản lý phiên bản** | Semantic Versioning chặt chẽ (`v1.2.0`) | Thường định danh theo Commit SHA | Gắn thẻ theo môi trường triển khai |

---

# PHẦN 5: REMOTE REPOSITORY (GITHUB/GITLAB)

## 14. Thêm remote và đẩy code (Remote Operations)

### 14.1. Khái niệm và bản chất của Remote Repository
Một **Remote Repository** (kho chứa từ xa) là phiên bản của dự án được lưu trữ trên một máy chủ được kết nối qua mạng Internet hoặc mạng nội bộ (như GitHub, GitLab, Bitbucket, hoặc một máy chủ Linux nội bộ). 

Khác với các hệ thống tập trung, một Git repository cục bộ có thể kết nối đồng thời với **nhiều remote khác nhau**. Mối liên kết này được lưu trữ trực tiếp trong tệp cấu hình `.git/config` dưới section `[remote "<tên-remote>"]`.

#### Quản trị Remote với lệnh `git remote`:
* **Kiểm tra danh sách các remote và đường dẫn URL:**
  ```bash
  git remote -v
  ```
  *Kết quả hiển thị trên môi trường thực tế của dự án:*
  ```text
  origin  git@github.com:VinhTungg/typ-training-cloud-2026.git (fetch)
  origin  git@github.com:VinhTungg/typ-training-cloud-2026.git (push)
  ```
  Trong đó:
  - `origin` là định danh quy ước mặc định mà Git gán cho máy chủ mà bạn đã clone về (hoặc remote đầu tiên được thêm).
  - `(fetch)`: Địa chỉ URL dùng để tải dữ liệu về máy trạm.
  - `(push)`: Địa chỉ URL dùng để tải dữ liệu từ máy trạm lên máy chủ.
* **Thêm một liên kết remote mới:**
  ```bash
  git remote add <tên-remote> <url-repository>
  ```
  *(Ví dụ thêm remote trỏ về repository gốc của giảng viên/nhóm trưởng: `git remote add upstream git@github.com:leader/typ-training-cloud-2026.git`)*.
* **Đổi tên hoặc xóa bỏ một remote:**
  ```bash
  git remote rename <tên-cũ> <tên-mới>
  git remote remove <tên-remote>
  ```
* **Kiểm tra thông tin chi tiết của một remote:**
  ```bash
  git remote show origin
  ```
  Lệnh này truy vấn máy chủ và in ra báo cáo tình trạng đồng bộ giữa các nhánh cục bộ với các nhánh trên remote (*Local branches configured for 'git pull'*, *Local refs configured for 'git push'*).

---

### 14.2. Đồng bộ dữ liệu từ máy chủ: `git fetch` vs `git pull`

Đây là cặp thao tác nền tảng thường bị nhầm lẫn trong quá trình làm việc nhóm. Cơ chế vận hành của chúng được mô tả qua kiến trúc các vùng tham chiếu sau:

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                 LUỒNG DỮ LIỆU ĐỒNG BỘ: GIT FETCH VS GIT PULL                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌────────────────────────────────┐       ┌────────────────────────────┐   │
│   │    REMOTE REPOSITORY (SERVER)  │       │    REMOTE REPOSITORY       │   │
│   │      (GitHub / GitLab)         │       │      (GitHub / GitLab)     │   │
│   └───────────────┬────────────────┘       └──────────────┬─────────────┘   │
│                   │                                       │                 │
│                   │ git fetch                             │                 │
│                   ▼                                       │                 │
│   ┌────────────────────────────────┐                      │                 │
│   │    REMOTE TRACKING BRANCH      │                      │ git pull        │
│   │        (origin/main)           │                      │ (fetch + merge) │
│   └───────────────┬────────────────┘                      │                 │
│                   │                                       │                 │
│                   │ git merge                             │                 │
│                   ▼                                       ▼                 │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                  LOCAL REPOSITORY (refs/heads/main)                 │   │
│   │                      & WORKING DIRECTORY TRÊN ĐĨA                   │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### 1. Lệnh `git fetch` (Tải dữ liệu an toàn, không can thiệp Working Directory):
* **Cơ chế:** Kết nối tới remote server, tải toàn bộ các commit, tệp đối tượng và các nhánh mới về máy trạm, rồi cập nhật vào con trỏ **Remote Tracking Branch** (ví dụ: `origin/main`).
* **Đặc tính:** Hoàn toàn **KHÔNG tác động** tới mã nguồn đang mở trong Working Directory và không làm thay đổi vị trí của con trỏ nhánh cục bộ hiện tại.
* **Mục đích:** Cho phép lập trình viên kiểm tra trước các thay đổi từ đồng nghiệp mà không sợ làm hỏng mã nguồn đang viết dở:
  ```bash
  git fetch origin
  git log main..origin/main --oneline    # Xem các commit mới trên remote mà local chưa có
  git diff main origin/main              # So sánh nội dung code giữa local và remote
  ```

#### 2. Lệnh `git pull` (Tải và tự động hợp nhất):
* **Cơ chế:** Là một lệnh tổng hợp tương đương với hai thao tác liên tiếp:
  $$\text{git pull} = \text{git fetch} + \text{git merge}$$
  Git tải dữ liệu về remote-tracking branch, sau đó lập tức tiến hành hợp nhất (*merge*) vào nhánh cục bộ đang checkout.
* **Đặc tính:** Có thể gây ra **Merge Conflict** ngay tại thời điểm chạy lệnh nếu mã nguồn cục bộ và mã nguồn trên remote có các dòng sửa đổi trái ngược nhau.
* **Biến thể Rebase (`git pull --rebase`):**
  $$\text{git pull --rebase} = \text{git fetch} + \text{git rebase}$$
  Thay vì tạo ra một Merge Commit rác, Git sẽ bốc toàn bộ các commit cục bộ của bạn đặt tạm sang một bên, cập nhật nhánh theo remote mới nhất, rồi đặt tuần tự các commit cục bộ lên trên đỉnh. Giúp lịch sử commit của nhánh thẳng và sạch đẹp.

---

### 14.3. Đẩy dữ liệu lên máy chủ từ xa (`git push`)

Lệnh `git push` thực hiện nhiệm vụ đẩy các đối tượng commit và cập nhật các con trỏ tham chiếu từ repository cục bộ lên máy chủ từ xa.

#### 1. Thiết lập nhánh theo dõi (*Upstream Tracking*):
Khi tạo một nhánh mới ở máy cục bộ và đẩy lên remote lần đầu tiên, cần sử dụng cờ **`-u`** (hoặc `--set-upstream`):
```bash
git push -u origin feature/cloud-storage
```
Thao tác này liên kết chặt chẽ nhánh cục bộ `feature/cloud-storage` với nhánh `origin/feature/cloud-storage` trên GitHub. Nhờ đó, trong tất cả các phiên làm việc tiếp theo tại nhánh này, bạn chỉ cần gõ vắn tắt:
```bash
git push
# hoặc: git pull
```

#### 2. Xử lý lỗi từ chối đẩy mã (*Non-Fast-Forward Push Rejection*):
Nếu một đồng nghiệp trong nhóm đã đẩy mã nguồn mới lên remote trước bạn, Git sẽ từ chối lệnh push với thông báo:
```text
! [rejected]        main -> main (fetch first)
error: failed to push some refs to 'git@github.com:...'
hint: Updates were rejected because the remote contains work that you do
hint: not have locally. This is usually caused by another repository pushing...
```
* **Nguyên tắc xử lý chuẩn:** Bạn **bắt buộc phải kéo mã nguồn mới về tích hợp trước** (`git pull` hoặc `git pull --rebase`), xử lý xung đột (nếu có), kiểm tra mã nguồn chạy ổn định, sau đó mới thực hiện lại lệnh `git push`.

#### 3. Phân tích rủi ro: `git push --force` vs `git push --force-with-lease`:
* **`git push --force` (`-f`):** Ép buộc máy chủ ghi đè lịch sử của bạn lên remote, xóa bỏ toàn bộ các commit mà người khác đã đẩy lên sau mốc của bạn. **Đây là thao tác tối kỵ trên các nhánh dùng chung (`main`, `develop`) vì sẽ phá hủy công sức của cả nhóm.**
* **`git push --force-with-lease` (Phương án an toàn):** Chỉ cho phép ép buộc cập nhật nếu và chỉ nếu không có ai khác đẩy thêm commit mới nào lên nhánh đó kể từ lần `git fetch` cuối cùng của bạn. Đây là chuẩn an toàn bắt buộc khi cần cập nhật nhánh cá nhân sau khi rebase.

---

## 15. Làm việc nhóm: Fork, Clone, Pull Request (Collaborative Workflows)

### 15.1. Hai mô hình cộng tác phổ biến trong công nghiệp phần mềm

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                       HAI MÔ HÌNH CỘNG TÁC PHỔ BIẾN                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│ 1. MÔ HÌNH SHARED REPOSITORY (TRỰC TIẾP TRONG DOANH NGHIỆP)                 │
│                                                                             │
│        Developer A ────(push branch)────► ┌──────────────────────┐          │
│                                           │  CENTRAL REPO        │          │
│        Developer B ────(push branch)────► │  (Company Project)   │          │
│                                           └──────────────────────┘          │
│                                                                             │
│ 2. MÔ HÌNH FORK AND PULL REQUEST (MÃ NGUỒN MỞ & ĐÀO TẠO)                    │
│                                                                             │
│    ┌─────────────────────────┐               ┌─────────────────────────┐    │
│    │   UPSTREAM REPOSITORY   │◄──(Pull Req)──┤    FORK REPOSITORY      │    │
│    │   (Repo gốc tổ chức)    │               │    (Tài khoản cá nhân)  │    │
│    └────────────┬────────────┘               └────────────▲────────────┘    │
│                 │                                         │                 │
│                 │ git fetch upstream                      │ git push origin │
│                 ▼                                         │                 │
│    ┌──────────────────────────────────────────────────────┴────────────┐    │
│    │                   MÁY TRẠM LẬP TRÌNH VIÊN (LOCAL)                 │    │
│    └───────────────────────────────────────────────────────────────────┘    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### Mô hình 1: Shared Repository Model (Doanh nghiệp nội bộ)
* Tất cả lập trình viên trong dự án được cấp quyền ghi trực tiếp (*Collaborator / Developer role*) vào cùng một repository.
* Để đảm bảo an toàn, nhánh chính (`main`, `develop`) được khóa (*Protected Branches*). Các thành viên tạo nhánh tính năng trực tiếp trong repo này (`feature/xyz`), sau đó mở Pull Request để xin merge vào nhánh chính.

#### Mô hình 2: Fork and Pull Model (Mã nguồn mở và Dự án Đào tạo)
* Lập trình viên bên ngoài không có quyền ghi trực tiếp vào repository gốc (*Upstream Repository*).
* **Quy trình chuẩn kỹ thuật:**
  1. **Fork:** Nhấn nút Fork trên giao diện GitHub để sao chép toàn bộ dự án gốc về tài khoản cá nhân của mình.
  2. **Clone:** Tải bản fork cá nhân về máy tính cục bộ:
     ```bash
     git clone git@github.com:<username>/typ-training-cloud-2026.git
     ```
  3. **Cấu hình Remote Upstream:** Thiết lập liên kết trỏ về kho chứa gốc để cập nhật các thay đổi mới nhất từ ban quản trị:
     ```bash
     git remote add upstream git@github.com:VinhTungg/typ-training-cloud-2026.git
     ```
  4. **Phát triển & Đẩy code:** Tạo nhánh tính năng, commit và push lên repository cá nhân (`origin`):
     ```bash
     git switch -c feature/week1-report
     git push -u origin feature/week1-report
     ```
  5. **Mở Pull Request (PR):** Truy cập giao diện GitHub, tạo yêu cầu kéo mã (*Pull Request*) từ nhánh `feature/week1-report` của bạn vào nhánh `main` của repository gốc `upstream`.

---

### 15.2. Vòng đời và Văn hóa Pull Request (PR Protocol)

Một Pull Request không chỉ là một công cụ trộn mã nguồn, mà là một **không gian đánh giá kỹ thuật và trao đổi chất lượng phần mềm**.

#### Các bước chuẩn mực của một Pull Request:
1. **Tiêu đề và Mô tả rõ ràng (PR Description):** Nêu rõ mục đích thay đổi, lý do kỹ thuật, danh sách các đầu mục đã hoàn thành và ảnh chụp kiểm thử/minh chứng.
2. **Kích hoạt CI Tự động (Automated Checks):** Khi PR được mở, các kịch bản GitHub Actions / GitLab CI tự động kích hoạt:
   - Kiểm tra định dạng mã nguồn (Linting).
   - Chạy toàn bộ các bài Unit Tests và Integration Tests.
   - Quét lỗ hổng bảo mật và phân tích độ phủ mã (*Code Coverage*).
3. **Bình duyệt mã nguồn (Code Review):** Các thành viên cấp cao (*Reviewers/Maintainers*) đọc từng dòng diff và đưa ra nhận xét:
   - `Comment`: Đóng góp ý kiến thảo luận.
   - `Request changes`: Yêu cầu sửa đổi logic trước khi được chấp thuận.
   - `Approve`: Đồng ý hợp nhất.
4. **Hợp nhất (Merge):** Sau khi đạt đủ số lượng Approve và vượt qua toàn bộ CI, người quản trị chọn 1 trong 3 phương thức merge:
   - **Create a merge commit:** Giữ nguyên toàn bộ lịch sử commit chi tiết và tạo merge commit nối 2 nhánh.
   - **Squash and merge:** Nén toàn bộ hàng chục commit nhỏ lẻ của nhánh tính năng thành một commit duy nhất trên nhánh chính (giúp lịch sử nhánh `main` sạch đẹp).
   - **Rebase and merge:** Tua lại các commit của tính năng nối tiếp vào đỉnh nhánh chính, tạo lịch sử hoàn toàn tuyến tính.

---

## 16. Giải quyết Conflict khi làm việc nhóm (Team Conflict Resolution)

### 16.1. Bối cảnh phát sinh xung đột trong nhóm thực tế

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                 BỐI CẢNH PHÁT SINH CONFLICT KHI LÀM VIỆC NHÓM               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Remote main:      ───[C1]───────[C2]────────────[C3 (Member A đã merge)]─► │
│                         \                         ▲                         │
│                          \                        │ (Merge PR thành công)   │
│  Member A (featureA):     └──[A1]───────[A2]──────┘                         │
│                                                                             │
│  Member B (featureB):     └──[B1]───────[B2] ───► Cố gắng Merge PR vào main │
│                                                   ❌ XUNG ĐỘT (CONFLICT)    │
│                                                   vì cùng sửa dòng code     │
│                                                   mà C3 đã sửa đổi!         │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

Khi Thành viên A merge PR trước, nhánh `main` trên máy chủ đã thay đổi sang mốc commit `C3`. Nhánh của Thành viên B vẫn dựa trên mốc cũ `C1`. Nếu Thành viên B có sửa đổi trùng vào các tệp/dòng mã mà Thành viên A đã chạm tới, GitHub sẽ khóa nút merge và thông báo: **"Can't automatically merge. Don't worry, you can still create the pull request."**

---

### 16.2. Kỹ thuật giải quyết xung đột cục bộ chuẩn kỹ thuật

Để giải quyết, lập trình viên không được sửa trực tiếp trên giao diện web (dễ gây lỗi thiếu sót), mà phải **đồng bộ mã nguồn mới từ remote về nhánh cục bộ của mình, giải quyết xung đột trên IDE, kiểm thử lại và đẩy ngược lên PR**.

Có hai kỹ thuật chính để thực hiện:

#### Cách 1: Đồng bộ bằng Merge (Truyền thống, an toàn, không viết lại lịch sử)
```bash
# 1. Chuyển sang nhánh tính năng đang bị xung đột
git switch feature/student-api

# 2. Tải toàn bộ mã nguồn mới nhất từ remote
git fetch origin

# 3. Hợp nhất nhánh main mới nhất của remote vào nhánh tính năng của bạn
git merge origin/main

# 4. Khi xuất hiện thông báo CONFLICT, mở IDE sửa tệp, xóa các chỉ thị <<<<<<< ======= >>>>>>>
# 5. Lưu tệp và đánh dấu đã xử lý
git add path/to/conflict-file.py

# 6. Tạo commit giải quyết xung đột
git commit -m "merge: resolve conflicts with origin/main"

# 7. Đẩy mã nguồn đã xử lý lên nhánh PR
git push origin feature/student-api
```
*Ngay sau khi push, GitHub sẽ tự động kiểm tra lại và mở lại nút Merge màu xanh an toàn.*

---

#### Cách 2: Đồng bộ bằng Rebase (Khuyến nghị cho các dự án chuyên nghiệp)
Kỹ thuật này bốc toàn bộ nhánh tính năng của bạn đặt lên trên đỉnh commit mới nhất của `main`, giữ cho cây lịch sử hoàn toàn tuyến tính và không sinh ra các merge commit trung gian thừa thãi:

```bash
# 1. Chuyển sang nhánh tính năng
git switch feature/student-api

# 2. Tải dữ liệu mới
git fetch origin

# 3. Tái cơ sở nhánh tính năng trên đỉnh origin/main
git rebase origin/main

# 4. Git sẽ tạm dừng tại từng commit gây xung đột.
#    Mở IDE giải quyết xung đột của commit đó, sau đó gõ:
git add path/to/conflict-file.py
git rebase --continue
# (Lặp lại cho đến khi rebase hoàn tất)

# 5. Do lịch sử commit cục bộ đã được viết lại, cần đẩy lên bằng cờ an toàn:
git push --force-with-lease origin feature/student-api
```

---

### 16.3. Bảng so sánh phương pháp xử lý Conflict: Merge vs Rebase

| Tiêu chí | Sử dụng `git merge origin/main` | Sử dụng `git rebase origin/main` |
| :--- | :--- | :--- |
| **Bản chất** | Tạo thêm một commit hợp nhất mới nối 2 nhánh. | Viết lại các commit tính năng đặt lên đỉnh của `main`. |
| **Lịch sử commit** | Phân nhánh nhiều nhánh đan xen, sinh ra commit rác. | Tuyến tính, thẳng tắp, cực kỳ dễ đọc và dễ tra cứu `git log`. |
| **Thao tác Push** | Đẩy bình thường (`git push`). | Bắt buộc phải dùng `git push --force-with-lease`. |
| **Mức độ phức tạp** | Đơn giản, giải quyết toàn bộ xung đột trong 1 lần commit. | Phải giải quyết xung đột tuần tự qua từng commit nếu có nhiều commit đụng độ. |
| **Trường hợp áp dụng** | Thành viên mới làm quen với Git, hoặc nhánh tính năng quá dài. | Quy chuẩn bắt buộc tại các công ty công nghệ lớn và dự án mã nguồn mở chuyên nghiệp. |

---

# PHẦN 6: CÔNG CỤ & KỸ NĂNG NÂNG CAO

---

## 17. Gắn nhãn phiên bản và Semantic Versioning (Tag and Versioning)

### 17.1. Khái niệm và Phân loại Tag trong Git
Trong khi một **Nhánh (Branch)** là một con trỏ di động (*moving pointer*) tự động tịnh tiến về phía trước mỗi khi có commit mới, thì một **Thẻ đánh dấu (Tag)** là một con trỏ cố định vĩnh viễn (*static pointer*). Tag được sử dụng để đánh dấu các mốc lịch sử quan trọng trong vòng đời phần mềm, điển hình nhất là các mốc phát hành phiên bản (*Release milestones* như `v1.0.0`, `v2.1.0`).

Git cung cấp hai loại Tag với cơ chế lưu trữ kỹ thuật hoàn toàn khác nhau:

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                 HAI LOẠI TAG TRONG KIẾN TRÚC DỮ LIỆU CỦA GIT                │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│ 1. LIGHTWEIGHT TAG (Thẻ rút gọn):                                           │
│    .git/refs/tags/v1.0.0 ──────────────► [Commit Object: f0be77ab]          │
│    (Chỉ là một con trỏ lưu trữ trực tiếp SHA-1 của commit, không có metadata)│
│                                                                             │
│ 2. ANNOTATED TAG (Thẻ có chú giải - Khuyến nghị cho Release):               │
│    .git/refs/tags/v1.0.0 ──────────────► ┌───────────────────────────────┐  │
│                                          │      TAG OBJECT (zlib)        │  │
│                                          │ Tagger: Nguyen Vinh Tung      │  │
│                                          │ Date:   2026-10-01 10:00      │  │
│                                          │ Message: Release Version 1.0  │  │
│                                          │ GPG Sig: [Chữ ký số mật mã]   │  │
│                                          └──────────────┬────────────────┘  │
│                                                         │ trỏ tới           │
│                                                         ▼                   │
│                                          [Commit Object: f0be77ab]          │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### Bảng so sánh Lightweight Tag vs Annotated Tag:

| Tiêu chí | Lightweight Tag | Annotated Tag (Khuyến nghị) |
| :--- | :--- | :--- |
| **Bản chất lưu trữ** | Tệp con trỏ thuần túy trong `.git/refs/tags/` | Một đối tượng Git hoàn chỉnh nằm trong `.git/objects/` |
| **Thông tin lưu trữ** | Chỉ chứa duy nhất mã băm SHA-1 của commit | Tên tác giả, email, dấu thời gian, thông điệp tag, chữ ký số GPG |
| **Cú pháp tạo** | `git tag v1.0.0` | `git tag -a v1.0.0 -m "Release version 1.0.0"` |
| **Tính toàn vẹn** | Thấp, không lưu vết người gắn tag | Tuyệt đối cao, có mã kiểm tra checksum và chữ ký xác thực |
| **Trường hợp áp dụng** | Đánh dấu mốc tạm thời cá nhân trên máy cục bộ | Đánh dấu phiên bản phát hành chính thức cho môi trường Production |

---

### 17.2. Quản lý và Chia sẻ Tag với Remote

Theo mặc định của Git, lệnh `git push` thông thường sẽ **không tự động đẩy các Tag lên máy chủ từ xa**. Tag phải được đẩy một cách tường minh:

* **Liệt kê danh sách tag:**
  ```bash
  git tag
  # Lọc theo mẫu phiên bản:
  git tag -l "v1.2.*"
  ```
* **Xem thông tin chi tiết của một tag:**
  ```bash
  git show v1.0.0
  ```
* **Đẩy một tag cụ thể lên remote:**
  ```bash
  git push origin v1.0.0
  ```
* **Đẩy toàn bộ các tag cục bộ chưa có trên remote:**
  ```bash
  git push origin --tags
  ```
* **Xóa bỏ tag:**
  ```bash
  # Xóa tag ở kho chứa cục bộ:
  git tag -d v1.0.0
  # Xóa tag tương ứng trên máy chủ GitHub:
  git push origin --delete v1.0.0
  ```

---

### 17.3. Lệnh `git describe` và Ứng dụng trong CI/CD

Lệnh `git describe` tìm kiếm mốc Annotated Tag gần nhất có thể tiếp cận được từ commit hiện tại và tạo ra một chuỗi định danh phiên bản có thể đọc được bởi con người:

```bash
git describe
```
*Đầu ra mẫu tiêu biểu:*
```text
v1.0.0-4-g948d9f6
```
- `v1.0.0`: Tên của Tag gần nhất trên nhánh lịch sử.
- `4`: Số lượng commit đã được tạo thêm kể từ mốc tag đó.
- `g948d9f6`: Viết tắt của "git" kèm 7 ký tự đầu mã băm SHA của commit hiện tại.

> [!TIP]
> Trong các đường ống tự động hóa triển khai (**CI/CD Pipelines**), lệnh `git describe` là kỹ thuật chuẩn để tự động sinh mã số bản dựng (*Build Number*) hoặc gắn thẻ (*tag*) cho các Docker Image mà không cần chỉnh sửa thủ công.

---

### 17.4. Chuẩn định danh phiên bản ngữ nghĩa (Semantic Versioning - SemVer)

Trong công nghiệp phần mềm, việc đặt tên tag phiên bản bắt buộc tuân theo quy chuẩn **Semantic Versioning (SemVer 2.0.0)** với cấu trúc:

$$\text{v}\mathbf{MAJOR}.\mathbf{MINOR}.\mathbf{PATCH}$$

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                       QUY TẮC PHÂN CẤP SEMANTIC VERSIONING                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│         v 2 . 4 . 1                                                         │
│           │   │   │                                                         │
│           │   │   └───── PATCH : Tăng khi sửa lỗi (Bug fix),                │
│           │   │                  hoàn toàn tương thích ngược                │
│           │   │                                                             │
│           │   └───────── MINOR : Tăng khi bổ sung tính năng mới,            │
│           │                      nhưng vẫn bảo đảm tương thích ngược        │
│           │                                                                 │
│           └───────────── MAJOR : Tăng khi có thay đổi phá vỡ tương thích    │
│                                  ngược (Breaking Changes / API redesign)    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

* **Hậu tố tiền phát hành (*Pre-release labels*):** Được nối phía sau dấu gạch nối để định danh các bản thử nghiệm nội bộ:
  - `v1.0.0-alpha.1`: Bản thử nghiệm ban đầu dành cho nội bộ kiểm thử.
  - `v1.0.0-beta.2`: Bản thử nghiệm mở rộng cho người dùng trải nghiệm.
  - `v1.0.0-rc.1`: Bản ứng viên phát hành (*Release Candidate*), sẵn sàng lên Production nếu không có lỗi phát sinh.

---

## 18. Lưu tạm thay đổi chưa commit (`git stash`)

### 18.1. Bối cảnh kỹ thuật và Vùng lưu trữ Stash

Trong thực tế phát triển phần mềm, lập trình viên thường xuyên gặp tình huống: Đang viết dở một tính năng (mã nguồn chưa hoàn thiện, các bài kiểm tra chưa vượt qua nên **chưa thể commit**), nhưng đột ngột có sự cố khẩn cấp yêu cầu phải chuyển ngay sang nhánh khác để sửa lỗi.

Nếu chuyển nhánh lúc này, Git sẽ chặn lại do nguy cơ ghi đè mã nguồn chưa lưu. Lệnh **`git stash`** giải quyết triệt để vấn đề này bằng cách:
1. Đóng gói toàn bộ các thay đổi chưa commit (cả trong Working Directory và Staging Area).
2. Lưu trữ chúng vào một cấu trúc ngăn xếp (*Stack*) nội bộ tại `.git/refs/stash`.
3. Đưa không gian làm việc trở về trạng thái sạch sẽ (*clean working tree*) trùng khớp hoàn toàn với commit `HEAD`.

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                         CƠ CHẾ NGĂN XẾP CỦA GIT STASH                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Working Tree (Đang sửa dở) ────► [ git stash push ]                        │
│                                            │                                │
│                                            ▼                                │
│                           ┌─────────────────────────────────┐               │
│                           │      NGĂN XẾP STASH (LIFO)      │               │
│                           ├─────────────────────────────────┤               │
│                           │ stash@{0}: WIP on cloud-storage │ ◄── [Đỉnh]    │
│                           │ stash@{1}: WIP on auth-service  │               │
│                           │ stash@{2}: Fix css responsive   │               │
│                           └────────────────┬────────────────┘               │
│                                            │                                │
│  Working Tree (Đã phục hồi) ◄─── [ git stash pop / apply ]                  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

### 18.2. Hệ thống các câu lệnh thao tác Stash chuyên sâu

* **Lưu tạm trạng thái kèm thông điệp ghi chú:**
  ```bash
  git stash push -m "WIP: dang viet do ham xac thuc token JWT"
  ```
* **Lưu tạm bao gồm cả các tệp mới tạo chưa được theo dõi (*Untracked files*):**
  ```bash
  git stash -u
  # hoặc: git stash --include-untracked
  ```
  *(Lưu ý: Mặc định `git stash` chỉ lưu các tệp đã Tracked; cờ `-u` bắt buộc phải dùng nếu bạn vừa tạo thêm các file mới).*
* **Xem danh sách toàn bộ các bản lưu trong ngăn xếp:**
  ```bash
  git stash list
  ```
* **Xem trước nội dung sai khác của bản lưu mà không cần áp dụng:**
  ```bash
  git stash show -p stash@{0}
  ```
* **Phục hồi thay đổi từ ngăn xếp:**
  - **`git stash apply stash@{0}`:** Áp dụng lại các thay đổi vào Working Directory nhưng **vẫn giữ lại bản lưu trong ngăn xếp stash** (an toàn, có thể tái sử dụng nhiều lần).
  - **`git stash pop`:** Áp dụng bản lưu trên đỉnh (`stash@{0}`) và **đồng thời xóa nó ra khỏi ngăn xếp** (thao tác chuẩn khi tiếp tục công việc).
* **Xóa bỏ bản lưu:**
  - Xóa một bản lưu cụ thể: `git stash drop stash@{0}`
  - Xóa sạch toàn bộ ngăn xếp: `git stash clear`
* **Tạo nhánh mới từ bản stash:**
  ```bash
  git stash branch feature/resumed-work stash@{0}
  ```
  Lệnh này tạo một nhánh mới từ commit lúc bạn thực hiện stash, checkout vào nhánh đó và tự động pop dữ liệu ra. Cực kỳ hữu ích khi mã nguồn lưu tạm bị xung đột với các commit mới của nhánh hiện tại.

---

## 19. Tái cơ sở và gộp commit (`git rebase` và `squash`)

### 19.1. Khái niệm và Bản chất của `git rebase`

Lệnh `git rebase` là một trong những tính năng mạnh mẽ nhất của Git, cho phép lập trình viên **di chuyển hoặc kết hợp một chuỗi các commit tới một commit cơ sở mới (*new base commit*)**.

Khác với `git merge` (tạo ra một commit mới để nối hai nhánh), `git rebase` hoạt động bằng cách:
1. Tạm thời bóc tách các commit độc lập của nhánh hiện tại ra thành các tệp vá tạm thời (*patches* trong thư mục `.git/rebase-apply/`).
2. Đặt lại con trỏ nhánh hiện tại trỏ tới commit đầu mút của nhánh mục tiêu (`main`).
3. Lần lượt áp dụng tuần tự từng commit vá tạm thời lên đỉnh của nhánh mục tiêu với các **mã băm commit SHA hoàn toàn mới**.

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                 BẢN CHẤT HÌNH HỌC CỦA THAO TÁC GIT REBASE                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│ 1. BAN ĐẦU: Nhánh feature rẽ nhánh từ commit C2 của main                    │
│                                                                             │
│    main:       ───[C1]────►[C2]────►[C3]────►[C4]                           │
│                              \                                              │
│    feature:                   └───►[F1]────►[F2]                            │
│                                                                             │
│ 2. KHI THỰC HIỆN TRÊN FEATURE: git rebase main                              │
│                                                                             │
│    main:       ───[C1]────►[C2]────►[C3]────►[C4]                           │
│                                                \                            │
│    feature:                                     └───►[F1']───►[F2']         │
│                                                                             │
│    (F1', F2' mang nội dung của F1, F2 nhưng có commit SHA và Parent mới)   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

### 19.2. Tái cơ sở tương tác (Interactive Rebase) và Kỹ thuật Squash

Lệnh **`git rebase -i`** (Interactive Mode) mở ra một giao diện soạn thảo cho phép lập trình viên toàn quyền biên tập lại lịch sử commit của chính mình trước khi chia sẻ cho cộng đồng.

#### Cú pháp kích hoạt:
```bash
# Tái cơ sở lại 4 commit gần nhất:
git rebase -i HEAD~4
```

Git sẽ mở trình soạn thảo văn bản với danh sách các commit từ cũ nhất đến mới nhất kèm bảng chỉ lệnh:

```text
pick e033b12 feat: add initial user schema
pick 948d9f6 fix: fix syntax error in schema
pick 16e1bdd wip: temporary test commit
pick f0be77a feat: add validation rules for user schema

# Commands:
# p, pick <commit> = giữ nguyên commit này
# r, reword <commit> = giữ commit nhưng cho phép sửa lại commit message
# e, edit <commit> = dừng lại để sửa đổi nội dung commit
# s, squash <commit> = gộp commit này vào commit ngay phía trước nó
# f, fixup <commit> = tương tự squash nhưng vứt bỏ commit message của nó
# d, drop <commit> = xóa bỏ hoàn toàn commit này khỏi lịch sử
```

#### Kỹ thuật làm sạch lịch sử (Squash / Fixup Workflow):
Trong quá trình lập trình thực tế, việc tạo ra các commit vụn vặt như *"fix typo"*, *"debug"*, *"test again"* là điều khó tránh khỏi. Trước khi tạo Pull Request, lập trình viên chuyên nghiệp dùng quy tắc sau để gộp lịch sử thành một commit hoàn thiện duy nhất:

```text
pick e033b12 feat(user): implement complete user registration schema
f 948d9f6 fix: fix syntax error in schema
f 16e1bdd wip: temporary test commit
f f0be77a feat: add validation rules for user schema
```
*(Kết quả: Cả 4 commit trên sẽ được nén chặt thành đúng 1 commit duy nhất `e033b12` với thông điệp sạch sẽ, loại bỏ toàn bộ rác lịch sử).*

---

### 19.3. Nguyên tắc vàng của Rebase (The Golden Rule of Rebasing)

> [!CAUTION]
> **QUY TẮC BẤT DI BẤT DỊCH:** Tuyệt đối không bao giờ được phép Rebase những commit **đã được đẩy lên các nhánh công khai dùng chung** (`main`, `develop`, `release`).

**Nguyên nhân kỹ thuật:** Lệnh Rebase phá hủy các commit cũ và tái tạo các commit mới với mã SHA-1 khác hoàn toàn. Nếu bạn rebase một nhánh mà các đồng nghiệp khác đã clone và đang tiếp tục phát triển trên đó, cây lịch sử của họ sẽ bị phân nhánh dị biệt. Khi họ pull về, Git sẽ buộc phải hợp nhất hai lịch sử song song, tạo ra một mớ hỗn độn commit trùng lặp cực kỳ khó khắc phục.

---

## 20. Tùy biến viết tắt và định dạng nhật ký (Git Alias & Log Formatting)

### 20.1. Tối ưu hóa hiệu năng làm việc với `git alias`
Lập trình viên chuyên nghiệp không gõ toàn bộ câu lệnh Git dài mỗi ngày. Cơ chế **Git Alias** cho phép thiết lập các từ viết tắt trực tiếp trong cấu hình `.gitconfig`:

#### Bộ Alias khuyến nghị cho môi trường kỹ sư:
```bash
# 1. Các lệnh thao tác cơ bản thường dùng
git config --global alias.st "status -s"
git config --global alias.co "checkout"
git config --global alias.sw "switch"
git config --global alias.br "branch"
git config --global alias.cm "commit -m"
git config --global alias.amend "commit --amend --no-edit"

# 2. Hủy bỏ nhanh thay đổi
git config --global alias.unstage "restore --staged"
git config --global alias.discard "restore"

# 3. Vẽ cây lịch sử phân nhánh tuyệt đẹp
git config --global alias.tree "log --graph --oneline --decorate --all"
```

---

### 20.2. Tùy biến định dạng chuyên sâu với `git log --pretty=format`

Git hỗ trợ tùy biến định dạng in lịch sử theo các biến thay thế (*placeholders*) và màu sắc mã ANSI:

```bash
git log --graph --pretty=format:'%C(yellow)%h%Creset -%C(red)%d%Creset %s %C(green)(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
```

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                    BẢNG KÝ TỰ ĐỊNH DẠNG LOG PHỔ BIẾN                        │
├─────────────┬───────────────────────────────────────────────────────────────┤
│ Ký tự       │ Ý nghĩa hiển thị                                              │
├─────────────┼───────────────────────────────────────────────────────────────┤
│ %h          │ Mã băm commit rút gọn (Short SHA-1)                           │
│ %H          │ Mã băm commit đầy đủ (40 ký tự)                               │
│ %s          │ Tiêu đề của commit (Commit subject)                           │
│ %an / %ae   │ Tên tác giả (Author name) / Email tác giả                     │
│ %ad         │ Ngày tác giả commit (Author date)                             │
│ %ar         │ Thời gian tương đối so với hiện tại (ví dụ: "2 days ago")     │
│ %d          │ Các con trỏ tham chiếu liên kết (nhánh, tag, HEAD)            │
│ %C(color)   │ Đổi màu văn bản (red, green, blue, yellow, bold, reset)       │
└─────────────┴───────────────────────────────────────────────────────────────┘
```

---

## 21. Nhật ký tham chiếu và Khôi phục commit bị mất (`git reflog`)

### 21.1. Bản chất kỹ thuật của `git reflog` (Reference Log)
Trong khi `git log` chỉ duyệt theo đồ thị các commit còn liên kết với nhánh hiện tại, thì **`git reflog`** là một cuốn **nhật ký cứu sinh tối cao** ghi nhận mọi chuyển động của con trỏ `HEAD` trên máy tính cục bộ trong vòng **90 ngày gần nhất**.

Mỗi khi bạn thực hiện bất kỳ thao tác nào: `commit`, `checkout`, `switch`, `merge`, `rebase`, `reset`, Git đều ghi nhận một dòng nhật ký vào `.git/logs/HEAD`.

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                       TRÍCH XUẤT ĐẦU RA CỦA LỆNH GIT REFLOG                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│ f0be77a HEAD@{0}: commit: feat: complete section 5 documentation            │
│ 16e1bdd HEAD@{1}: checkout: moving from feature/week1 to main               │
│ c87f054 HEAD@{2}: reset: moving to HEAD~1 (thao tác lỡ tay reset nhầm)      │
│ 948d9f6 HEAD@{3}: commit: feat: important payment module logic             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

### 21.2. Kịch bản khôi phục sự cố kinh điển với `git reflog`

#### Kịch bản 1: Lỡ tay chạy `git reset --hard` làm mất sạch commit quan trọng
Giả sử bạn vô tình gõ `git reset --hard HEAD~2` và nhận ra mình vừa xóa mất hai commit chưa được đẩy lên remote:
1. **Bước 1: Tra cứu mã SHA của commit đã bị mất:**
   ```bash
   git reflog
   ```
   Tìm dòng ghi nhận trạng thái ngay trước khi chạy lệnh reset (ví dụ: `HEAD@{1}` có mã SHA là `948d9f6`).
2. **Bước 2: Phục hồi lại trạng thái commit:**
   ```bash
   git reset --hard HEAD@{1}
   # hoặc khôi phục trực tiếp qua SHA:
   git reset --hard 948d9f6
   ```
   *Toàn bộ mã nguồn và lịch sử của commit bị xóa sẽ lập tức quay trở lại Working Directory nguyên vẹn 100%.*

---

#### Kịch bản 2: Xóa nhầm một nhánh chưa kịp merge bằng `git branch -D`
Giả sử bạn lỡ tay cưỡng chế xóa nhánh `feature/ai-model`:
1. **Bước 1: Tìm commit cuối cùng của nhánh vừa bị xóa:**
   ```bash
   git reflog
   ```
   Tìm dòng có nội dung tương tự: `checkout: moving from feature/ai-model to main`. Commit đứng ngay trước thao tác chuyển nhánh đó chính là đỉnh của nhánh đã bị xóa (ví dụ `c87f054`).
2. **Bước 2: Tái sinh nhánh từ commit SHA đó:**
   ```bash
   git switch -c feature/ai-model c87f054
   ```
   *Nhánh `feature/ai-model` được tái sinh hoàn chỉnh cùng đầy đủ tất cả các commit.*

> **Triết lý an toàn của Git:** Trong Git, một khi dữ liệu đã được ghi nhận qua một lệnh `git commit`, dữ liệu đó **gần như không bao giờ có thể bị mất**, trừ khi bạn chủ động xóa thư mục `.git` hoặc để quá hạn dọn rác tự động của `git gc` (mặc định 30 ngày cho các commit mồ côi và 90 ngày cho reflog).

---

# PHẦN 7: THỰC HÀNH DỰ ÁN THỰC TẾ

---

## 22. Các tình huống giả lập thực tế (Practical Simulation Scenarios)

Để bao quát và vận dụng thực tiễn toàn bộ khối kiến thức từ **Phần 1 đến Phần 6**, phần này phân tích và giải quyết các **tình huống giả định kinh điển** bám sát trực tiếp các yêu cầu của đề tài:
1. **Tình huống 1:** Xử lý xung đột khi hợp nhất nhánh (*Merge Conflict Resolution*).
2. **Tình huống 2:** Hoàn tác mã nguồn lỗi trên môi trường chia sẻ (*Revert Code vs Reset*).
3. **Tình huống 3:** Rollback phiên bản khi hệ thống Production gặp sự cố nghiêm trọng (*Production Rollback Strategy*).
4. **Tình huống 4:** Quy trình Đóng gói & Phát hành phiên bản (*Release Management & Semantic Versioning*).
5. **Tình huống 5:** Đồng bộ hóa dữ liệu từ xa: **Khi nào thì cần thực hiện việc Fetch, khi nào cần Pull?**
6. **Tình huống 6:** Các tình huống cứu hộ và tối ưu bổ trợ (*Git Stash, Interactive Rebase & Disaster Recovery với Git Reflog*).

---

### Tình huống 1: Xử lý xung đột khi hợp nhất nhánh (Merge Conflict)

#### 1. Bối cảnh kỹ thuật giả định
Trong dự án phát triển hệ thống Gateway, hai kỹ sư phần mềm cùng được phân công nâng cấp module cấu hình xác thực (`config/auth.yaml`):
* **Kỹ sư A** làm việc trên nhánh `feature/auth-jwt`, thực hiện tích hợp cơ chế xác thực JWT Bearer Token.
* **Kỹ sư B** làm việc trên nhánh `feature/oauth2-google`, thực hiện tích hợp đăng nhập qua Google OAuth2.

Cả hai kỹ sư đều rẽ nhánh từ commit gốc `c01a23b` trên nhánh `main`. Do cùng chỉnh sửa trực tiếp vào cùng một khối cấu hình `auth_service:` trong tệp `config/auth.yaml`, xung đột mã nguồn tất yếu sẽ phát sinh khi hợp nhất.

#### 2. Các bước tái hiện xung đột (Step-by-Step Reproduction)

```bash
# 1. Trạng thái ban đầu trên nhánh main
mkdir -p config
cat << 'EOF' > config/auth.yaml
auth_service:
  mode: basic
  timeout: 30
EOF
git add config/auth.yaml
git commit -m "feat(config): initialize base authentication configuration"

# 2. Kỹ sư A phát triển nhánh feature/auth-jwt
git switch -c feature/auth-jwt
cat << 'EOF' > config/auth.yaml
auth_service:
  mode: jwt-bearer
  token_expiry: 3600
  issuer: "https://auth.company.internal"
EOF
git commit -am "feat(auth): integrate JWT bearer token authentication"

# 3. Kỹ sư B phát triển nhánh feature/oauth2-google từ main
git switch main
git switch -c feature/oauth2-google
cat << 'EOF' > config/auth.yaml
auth_service:
  mode: oauth2-provider
  provider: google-cloud
  client_id: "gateway-prod-01.apps.googleusercontent.com"
EOF
git commit -am "feat(auth): integrate Google Cloud OAuth2 authentication"

# 4. Kỹ sư A hoàn thành trước và hợp nhất vào nhánh main
git switch main
git merge feature/auth-jwt
# Kết quả: Fast-forward hoặc Merge commit thành công 100%

# 5. Kỹ sư B cập nhật nhánh main vào nhánh của mình để kiểm tra trước khi mở Pull Request
git switch feature/oauth2-google
git merge main
```

Ngay lập tức, Git phát hiện cùng một vùng dữ liệu bị thay đổi trái ngược nhau và dừng tiến trình hợp nhất:
```text
Auto-merging config/auth.yaml
CONFLICT (content): Merge conflict in config/auth.yaml
Automatic merge failed; fix conflicts and then commit the result.
```

#### 3. Giải phẫu dấu vết xung đột (Conflict Markers Analysis)
Mở tệp `config/auth.yaml`, Git tự động chèn các ký hiệu phân tách trực quan:

```yaml
auth_service:
<<<<<<< HEAD
  mode: oauth2-provider
  provider: google-cloud
  client_id: "gateway-prod-01.apps.googleusercontent.com"
=======
  mode: jwt-bearer
  token_expiry: 3600
  issuer: "https://auth.company.internal"
>>>>>>> main
```

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                   GIẢI PHÃU CẤU TRÚC CONFLICT MARKERS                       │
├─────────────────────────────────────────────────────────────────────────────┤
│  <<<<<<< HEAD                    ◄── Điểm bắt đầu mã nguồn nhánh hiện tại   │
│    mode: oauth2-provider              (Nhánh feature/oauth2-google)         │
│    provider: google-cloud                                                   │
│    client_id: "gateway-prod-01..."                                          │
│  =======                         ◄── Đường ranh giới ngăn cách trung lập    │
│    mode: jwt-bearer              ◄── Mã nguồn đến từ nhánh được hợp nhất    │
│    token_expiry: 3600                 (Nhánh main của Kỹ sư A)              │
│    issuer: "https://auth..."                                                │
│  >>>>>>> main                    ◄── Điểm kết thúc khối xung đột            │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### 4. Sơ đồ xử lý trực quan (Box Drawing)

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                 SƠ ĐỒ PHÂN NHÁNH VÀ ĐIỂM GIAO THOA CONFLICT                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│                  ┌── [Commit A1: Sửa JWT] ──────► [Merged vào main] ─┐      │
│                 ╱                                                    ▼      │
│  [Commit Gốc] ─┤                                               (CONFLICT!)  │
│                 ╲                                                    ▲      │
│                  └── [Commit B1: Sửa OAuth2] ────► [git merge main] ─┘      │
│                                                                             │
│  ─────────────────────────────────────────────────────────────────────────  │
│  QUY TRÌNH XỬ LÝ 4 BƯỚC:                                                    │
│  [1. git status] ──► [2. Sửa code & xóa Marker] ──► [3. git add] ──► [4. git commit]
└─────────────────────────────────────────────────────────────────────────────┘
```

#### 5. Quy trình 4 bước chuẩn giải quyết Conflict chuyên nghiệp
1. **Bước 1: Khảo sát trạng thái tệp xung đột:**
   ```bash
   git status
   ```
   *Kết quả hiển thị tệp `config/auth.yaml` nằm trong mục `Unmerged paths: both modified`.*

2. **Bước 2: Phân tích mã nguồn và giải quyết triệt để:**
   Kỹ sư không được tùy tiện chọn một bên và xóa bên kia mà cần kết hợp cấu hình thành hệ thống hỗ trợ đa phương thức xác thực (*Hybrid Authentication*). Chỉnh sửa nội dung file và xóa sạch toàn bộ các ký tự marker:
   ```yaml
   auth_service:
     mode: hybrid
     providers:
       jwt:
         token_expiry: 3600
         issuer: "https://auth.company.internal"
       oauth2:
         provider: google-cloud
         client_id: "gateway-prod-01.apps.googleusercontent.com"
   ```

3. **Bước 3: Đánh dấu tệp đã giải quyết xung đột:**
   ```bash
   git add config/auth.yaml
   ```
   *Lệnh này thông báo cho chỉ mục (Staging Index) rằng xung đột tại tệp đã được xử lý xong.*

4. **Bước 4: Hoàn tất hợp nhất bằng commit chuyên biệt:**
   ```bash
   git commit -m "merge: resolve conflict in config/auth.yaml by supporting hybrid auth"
   ```
   *Nhánh `feature/oauth2-google` hiện đã chứa đầy đủ mã nguồn mới nhất từ `main`, sẵn sàng để mở Pull Request an toàn.*

---

### Tình huống 2: Hoàn tác mã nguồn lỗi trên môi trường chia sẻ (Revert Code)

#### 1. Bối cảnh kỹ thuật giả định
Một tính năng tính toán chiết khấu tự động cho đơn hàng thanh toán đám mây (`commit a4f8e12`) đã được kiểm thử sơ bộ và hợp nhất vào nhánh chia sẻ `develop`/`main`. Mã nguồn đã được đẩy lên GitHub và các kỹ sư khác trong nhóm đã kéo (`git pull`) về máy cục bộ.

Sau 2 giờ chạy thử nghiệm, đội QA phát hiện một trường hợp ngoại lệ (Edge Case): khi đơn vị tiền tệ là JPY (đồng Yên không có phần thập phân), thuật toán làm tròn gây tràn số và trừ sai tiền của khách hàng. Yêu cầu nghiệp vụ: **Hủy bỏ ngay lập tức tính năng này khỏi nhánh chính**.

#### 2. Vấn đề cốt lõi: Tại sao NGHIÊM CẤM dùng `git reset` trên nhánh công khai?

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                    SO SÁNH CƠ CHẾ: GIT RESET VS GIT REVERT                  │
├─────────────────────────────────────────────────────────────────────────────┤
│  [TRƯỜNG HỢP 1: DÙNG GIT RESET --HARD]                                      │
│                                                                             │
│  Remote Repo:  ───► C1 ───► C2 ───► C3 (Lỗi)                                │
│  Dev chạy reset lùi về C2 và git push --force:                              │
│  Remote Repo:  ───► C1 ───► C2                                              │
│  Đồng nghiệp khác đang giữ C3 trên máy cục bộ, khi git pull sẽ:             │
│  1. Tự động sinh Merge Commit kéo C3 (Lỗi) ngược trở lại Remote, HOẶC       │
│  2. Gặp lỗi lệch lịch sử phân kỳ nghiêm trọng (Divergent branches).         │
├─────────────────────────────────────────────────────────────────────────────┤
│  [TRƯỜNG HỢP 2: DÙNG GIT REVERT]                                            │
│                                                                             │
│  Repo:  ───► C1 ───► C2 ───► C3 (Lỗi) ───► C4 (Revert C3 - Mã sạch)         │
│                                                                             │
│  * Lịch sử luôn tiến về phía trước (Forward-only history).                  │
│  * Tất cả các thành viên chỉ cần chạy `git pull` bình thường.               │
│  * Lưu vết kiểm toán (Audit Trail) minh bạch về nguyên nhân hủy bỏ mã.      │
└─────────────────────────────────────────────────────────────────────────────┘
```

> **Nguyên tắc vàng của Git (The Golden Rule of Git):** Không bao giờ viết lại lịch sử (Reset, Rebase) trên các nhánh công khai đã được chia sẻ với các thành viên khác. Luôn sử dụng `git revert` để hoàn tác mã nguồn trên các nhánh dùng chung (`main`, `develop`, `release/*`).

#### 3. Thao tác xử lý chi tiết

* **Hoàn tác một commit đơn lẻ:**
  ```bash
  # Kích hoạt revert commit gây lỗi a4f8e12
  git revert a4f8e12
  ```
  *Git sẽ tự động mở trình soạn thảo commit message mặc định: `Revert "feat: apply auto discount logic"`. Kỹ sư bổ sung thêm nguyên nhân hoàn tác để phục vụ truy vết:*
  ```text
  Revert "feat: apply auto discount logic"
  
  This reverts commit a4f8e12b7c09d8e1f5a43b2c1.
  Reason: Fixed critical bug in JPY currency rounding causing overflow (INC-1042).
  ```

* **Hoàn tác một chuỗi nhiều commit liên tiếp mà không sinh nhiều commit lẻ:**
  ```bash
  # Cờ -n (--no-commit) đưa toàn bộ mã nguồn nghịch đảo vào Staging Area
  git revert -n HEAD~3..HEAD
  git commit -m "revert: rollback experimental payment features pending security audit"
  ```

#### 4. Kỹ thuật chuyên sâu: Hoàn tác một Merge Commit (`git revert -m`)
Khi hoàn tác một commit hợp nhất (Merge Commit), Git sẽ báo lỗi:
```text
fatal: commit 3c8e9f1 is a merge but no -m option was given.
```
Nguyên nhân: Một Merge Commit có từ 2 commit cha trở lên (Parent 1: nhánh đích, Parent 2: nhánh tính năng). Git không thể tự đoán biết cần giữ lại lịch sử của nhánh cha nào làm mốc cơ sở.

* **Cú pháp giải quyết:**
  ```bash
  # Chỉ định -m 1 để lấy Parent 1 (nhánh chính main) làm đường cơ sở:
  git revert -m 1 3c8e9f1
  ```

> **Cảnh báo quan trọng khi Revert Merge Commit:** Nếu sau này lỗi đã được sửa xong trên nhánh tính năng và bạn muốn merge lại nhánh đó vào `main`, Git sẽ **từ chối đưa lại các commit cũ** (vì Git ghi nhận chúng đã từng được merge ở quá khứ). Để đưa lại tính năng, quy trình bắt buộc là: **Revert lại chính commit revert đó!**

---

### Tình huống 3: Rollback phiên bản khi hệ thống Production gặp sự cố nghiêm trọng

#### 1. Bối cảnh kỹ thuật giả định
Vào lúc 02:00 AM, phiên bản phần mềm gắn thẻ `v2.4.0` vừa được triển khai tự động lên cụm máy chủ sản xuất (Production Kubernetes Cluster). Ngay sau khi lượng truy cập tăng nhẹ, hệ thống giám sát Prometheus/Grafana phát tín hiệu cảnh báo khẩn cấp:
* Mức tiêu thụ bộ nhớ RAM của dịch vụ API Gateway tăng vọt 98%, kích hoạt vòng lặp khởi động lại (OOMKilled Crash Loop).
* Tỷ lệ lỗi HTTP 500 trả về cho người dùng vượt ngưỡng 35%.

Đội ngũ phản ứng sự cố SRE/DevOps ra chỉ thị: **Thực hiện Rollback hệ thống về phiên bản ổn định gần nhất (`v2.3.9`) trong thời hạn dưới 5 phút**.

#### 2. Phân biệt hai cấp độ Rollback trong kỹ nghệ phần mềm

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                 PHÂN BIỆT HAI CẤP ĐỘ ROLLBACK HỆ THỐNG                      │
├─────────────────────────────────────────────────────────────────────────────┤
│  [CẤP ĐỘ 1: DEPLOYMENT ROLLBACK - HẠ TẦNG & ĐIỀU PHỐI]                      │
│  - Phạm vi: Tầng Container Orchestration (Kubernetes, AWS ECS, Docker).     │
│  - Thao tác: kubectl rollout undo deployment/api-gateway                    │
│    (Chuyển hướng traffic sang Image Pods của tag ổn định v2.3.9).           │
│  - Thời gian: 30 - 60 giây. Cứu sống hệ thống ngay lập tức.                 │
├─────────────────────────────────────────────────────────────────────────────┤
│  [CẤP ĐỘ 2: CODEBASE ROLLBACK - QUẢN TRỊ MÃ NGUỒN GIT]                      │
│  - Phạm vi: Kho lưu trữ mã nguồn Git (Git Repository).                      │
│  - Thao tác: Đồng bộ trạng thái nhánh production khớp với v2.3.9 để         │
│    pipeline CI/CD không vô tình ghi đè lại mã lỗi ở các đợt trigger sau.    │
│  - Nguyên lý: Tuyệt đối không xóa tag hay hạ số phiên bản lùi!              │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### 3. Quy trình Rollback mã nguồn an toàn chuẩn Enterprise (Forward-Fix Rollback)

1. **Bước 1: Tra cứu định danh phiên bản ổn định:**
   ```bash
   git tag -l -n1 "v2.*"
   # Kết quả:
   # v2.3.9   Release v2.3.9: Stable Core Gateway (Production Verified)
   # v2.4.0   Release v2.4.0: High concurrency engine update
   ```

2. **Bước 2: Tạo nhánh nóng khẩn cấp (Hotfix Rollback Branch):**
   ```bash
   git switch main
   git switch -c hotfix/rollback-to-v2.3.9
   ```

3. **Bước 3: Phục hồi toàn bộ cây mã nguồn về trạng thái của tag `v2.3.9`:**
   Thay vì lùi con trỏ hay gõ nhiều lệnh revert phức tạp, kỹ sư sử dụng kỹ thuật trích xuất toàn bộ snapshot của tag ổn định đè vào thư mục làm việc hiện tại:
   ```bash
   # Phục hồi toàn bộ tập tin từ thẻ v2.3.9 vào working tree
   git checkout v2.3.9 -- .
   
   # Kiểm tra trạng thái thay đổi
   git status
   
   # Ghi nhận commit rollback chính thức
   git commit -m "rollback: revert production codebase to stable state of v2.3.9 (INC-8921)"
   ```

4. **Bước 4: Đóng gói bản vá khẩn cấp tuân thủ Semantic Versioning:**
   Theo chuẩn SemVer, hệ thống không bao giờ được phép lùi số phiên bản (ví dụ không được đổi `v2.4.0` thành `v2.3.9` trên nhánh chính). Ta phát hành một bản vá mới **`v2.4.1`** chứa mã nguồn đã rollback:
   ```bash
   # Hợp nhất nhánh hotfix vào main
   git switch main
   git merge hotfix/rollback-to-v2.3.9
   
   # Đánh thẻ phiên bản vá lỗi khẩn cấp
   git tag -a v2.4.1 -m "Release v2.4.1: Emergency rollback to v2.3.9 codebase to resolve OOM crash"
   
   # Đẩy mã nguồn và thẻ phiên bản lên máy chủ GitHub
   git push origin main
   git push origin v2.4.1
   ```

5. **Bước 5: Kiểm tra danh mục an toàn khi Rollback (Safety Checklist):**
   > **Danh mục kiểm tra an toàn Rollback:**
   > * **Database Migrations:** Kiểm tra xem các migration mới chạy trong bản lỗi có xóa cột dữ liệu hay không. Phải chạy các script `down` migration tương thích ngược.
   > * **Cache & Session:** Xóa cache Redis/Memcached liên quan đến các cấu trúc dữ liệu mới để tránh lỗi deserialization.
   > * **Third-party Webhooks:** Tạm dừng các webhook tích hợp chưa tương thích với phiên bản cũ.

---

### Tình huống 4: Quy trình Đóng gói & Phát hành phiên bản (Tạo Release & Semantic Versioning)

#### 1. Bối cảnh kỹ thuật giả định
Đội ngũ kỹ sư kết thúc Sprint 12 với hai tính năng lớn: Tích hợp cổng thanh toán quốc tế Stripe và Nâng cấp thuật toán nén dữ liệu API Gateway. Toàn bộ mã nguồn đã hoàn tất Code Review, vượt qua 100% các bài kiểm thử tự động (Unit Test, Integration Test) trên nhánh `develop` và được hợp nhất vào nhánh `main`. Nhóm tiến hành quy trình **Đóng gói & Phát hành phiên bản chính thức v1.2.0**.

#### 2. Chuẩn mực định danh phiên bản ngữ nghĩa (Semantic Versioning 2.0.0)

Mọi bản phát hành phần mềm chuyên nghiệp đều phải tuân thủ nghiêm ngặt quy tắc ba chữ số:
$$\text{Phiên bản} = \mathbf{MAJOR}.\mathbf{MINOR}.\mathbf{PATCH}$$

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                    QUY CHUẨN SEMANTIC VERSIONING (SEMVER)                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│       v 1 . 2 . 0                                                           │
│         │   │   │                                                           │
│         │   │   └─── PATCH: Tăng khi vá lỗi tương thích ngược (Bug fixes)   │
│         │   │                                                               │
│         │   └─────── MINOR: Tăng khi thêm tính năng mới tương thích ngược   │
│         │                                                                   │
│         └─────────── MAJOR: Tăng khi có thay đổi PHÁ VỠ TƯƠNG THÍCH         │
│                             (Breaking Changes, thay đổi cấu trúc API)       │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│  VÍ DỤ TIÊU BIỂU:                                                           │
│  - v1.2.0 ──► v1.2.1: Sửa lỗi timeout kết nối cổng Stripe.                  │
│  - v1.2.1 ──► v1.3.0: Bổ sung phương thức thanh toán Apple Pay.             │
│  - v1.3.0 ──► v2.0.0: Xóa bỏ hoàn toàn chuẩn REST cũ, chuyển sang gRPC.     │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### 3. Các bước triển khai đóng gói thực tế

1. **Bước 1: Kiểm tra tính toàn vẹn và đồng bộ nhánh `main`:**
   ```bash
   git switch main
   git pull origin main
   git status
   # Đảm bảo Working Directory hoàn toàn sạch sẽ (Clean Tree)
   ```

2. **Bước 2: Tạo thẻ phiên bản có chú thích (Annotated Tag):**
   > **Quy chuẩn bắt buộc:** Trong quy trình Release, tuyệt đối không dùng Lightweight Tag (chỉ là con trỏ thuần túy). Luôn dùng **Annotated Tag (`-a`)** để lưu giữ đầy đủ thông tin: Tác giả đóng gói, Ngày giờ phát hành, và Thông điệp ghi chú chi tiết.
   ```bash
   git tag -a v1.2.0 -m "Release version 1.2.0

Features included:
- Feat: Add Stripe International Payment integration (#142)
- Feat: Enable Gzip/Brotli response payload compression (#158)
- Performance: Optimize database connection pool pooling (#163)
Tested on staging cluster: PASSED (2026-10-01)"
   ```

3. **Bước 3: Kiểm tra siêu dữ liệu của Tag:**
   ```bash
   git show v1.2.0
   ```
   *Kết quả hiển thị: Tên tác giả gắn thẻ, địa chỉ email, dấu thời gian, thông điệp release, và mã SHA của commit tương ứng.*

4. **Bước 4: Tra cứu khoảng cách phiên bản bằng `git describe`:**
   ```bash
   git describe --tags
   # Trả về: v1.2.0
   ```
   *Khi có các commit phát triển tiếp theo sau tag, `git describe` sẽ tự động hiển thị dạng `v1.2.0-4-g8c3a1b` (tức là sau tag v1.2.0 đã có 4 commit mới và HEAD hiện tại đang ở commit `8c3a1b`), cực kỳ hữu ích cho hệ thống tự động sinh số bản dựng (Build Number) trong CI/CD.*

5. **Bước 5: Đẩy Tag lên máy chủ GitHub/GitLab:**
   ```bash
   # Đẩy chính xác tag v1.2.0 lên remote
   git push origin v1.2.0
   
   # Hoặc đẩy toàn bộ các tag cục bộ chưa có trên máy chủ:
   git push origin --tags
   ```

6. **Bước 6: Tự động hóa tạo GitHub Release:**
   Sau khi tag được đẩy lên máy chủ GitHub, kỹ sư sử dụng GitHub CLI (`gh release create`) hoặc giao diện Web để xuất bản Release chính thức kèm theo Release Notes chuẩn:
   ```bash
   gh release create v1.2.0 --title "v1.2.0 - Cloud Gateway Core Release" --notes-file RELEASE_NOTES.md
   ```

---

### Tình huống 5: Đồng bộ hóa dữ liệu từ xa: Khi nào cần thực hiện Fetch, khi nào cần Pull?

#### 1. Bối cảnh kỹ thuật & So sánh bản chất kiến trúc ngầm

Nhiều lập trình viên có thói quen gõ `git pull` theo quán tính mỗi khi bắt đầu làm việc. Tuy nhiên, trong môi trường phát triển doanh nghiệp với nhiều nhánh song song, việc lạm dụng `git pull` có thể dẫn đến việc tự động sinh ra các Merge Commit rác ngoài ý muốn, làm đứt gãy lịch sử hoặc gây xung đột code khi chưa kịp kiểm tra.

Để hiểu khi nào nên dùng lệnh nào, cần phân tích kiến trúc **3 tầng lưu trữ** của Git:

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                    KIẾN TRÚC ĐỒNG BỘ DỮ LIỆU CỦA GIT                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  [MÁY CHỦ REMOTE] ─────────────── (GitHub / GitLab)                         │
│         │                                                                   │
│         │  1. git fetch origin (Tải commit & refs mới về)                   │
│         ▼                                                                   │
│  [KHO CỤC BỘ: REMOTE-TRACKING BRANCHES] ── (origin/main, origin/feature)    │
│         │                                                                   │
│         │  2. git merge origin/main (Hợp nhất vào nhánh đang mở)            │
│         ▼                                                                   │
│  [KHO CỤC BỘ: LOCAL BRANCH] ────────────── (main, feature)                  │
│         │                                                                   │
│         │  3. Cập nhật mã nguồn ra không gian làm việc                      │
│         ▼                                                                   │
│  [WORKING DIRECTORY] ───────────────────── (Tệp mã nguồn trên ổ đĩa)        │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│  BẢN CHẤT CÔNG THỨC:                                                        │
│  * git fetch = Chỉ thực hiện BƯỚC 1 (100% An toàn, chỉ đọc, không đổi code) │
│  * git pull  = Tự động thực hiện BƯỚC 1 + BƯỚC 2 + BƯỚC 3                   │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### 2. Bảng phân tích ngữ cảnh thực tế: Khi nào dùng `fetch`, khi nào dùng `pull`?

| Tiêu chí so sánh | `git fetch` | `git pull` |
| :--- | :--- | :--- |
| **Bản chất hành động** | Tải siêu dữ liệu và commit mới về kho lưu trữ, cập nhật con trỏ `origin/*`. | Tải dữ liệu về và ngay lập tức hợp nhất (`merge`) vào nhánh cục bộ hiện tại. |
| **Tác động tới Working Tree** | **Hoàn toàn KHÔNG**. Thư mục làm việc và mã nguồn đang viết không bị suy chuyển. | **CÓ**. Mã nguồn trên ổ đĩa bị thay đổi hoặc hợp nhất tức thì. |
| **Mức độ an toàn** | **Tuyệt đối an toàn** (Safe Read-Only). Không bao giờ sinh xung đột. | **Có rủi ro**. Có thể sinh xung đột (conflict) hoặc sinh merge commit rác. |
| **Khi nào NÊN DÙNG?** | - Đầu ngày làm việc: xem đồng đội đã làm những gì.<br>- Muốn xem trước `git diff` trước khi quyết định nhận code.<br>- Đang có code dở dang chưa commit.<br>- Khi muốn checkout sang một nhánh mới mà đồng đội vừa tạo trên remote. | - Khi đang làm việc độc lập trên nhánh cá nhân (`feature/*`).<br>- Chắc chắn không có xung đột xảy ra.<br>- Cần cập nhật nhánh nhanh mà không cần thẩm định trước. |
| **Hệ thống tự động hóa (CI/CD)** | Bắt buộc dùng trong các kịch bản kiểm toán mã nguồn (Auditing) và CI Runner. | Dùng trong script deployment đơn giản của môi trường thử nghiệm. |

#### 3. Quy trình đồng bộ chuẩn mực của Kỹ sư phần mềm chuyên nghiệp (Pro Workflow)

Thay vì chạy `git pull` một cách thụ động, quy trình chuẩn mực được khuyến nghị tại các công ty công nghệ lớn:

```bash
# Bước 1: Tải toàn bộ cập nhật mới nhất từ Remote máy chủ
git fetch origin

# Bước 2: Kiểm tra xem nhánh remote (origin/main) có bao nhiêu commit mới mà máy mình chưa có
git log HEAD..origin/main --oneline

# Bước 3: Kiểm tra xem máy mình có commit nào chưa đẩy lên hay không
git log origin/main..HEAD --oneline

# Bước 4: Xem trước những dòng mã thay đổi cụ thể để đánh giá rủi ro
git diff HEAD origin/main

# Bước 5: Tiến hành tích hợp mã nguồn
# Lựa chọn A (Hợp nhất tiêu chuẩn):
git merge origin/main

# Lựa chọn B (Chuẩn mực chuyên nghiệp - Giữ đồ thị thẳng tắp không sinh merge commit thừa):
git pull --rebase origin main
```

---

### Tình huống 6: Các tình huống cứu hộ và tối ưu bổ trợ

Để bao quát toàn diện các kỹ năng nâng cao đã đề cập từ **Phần 1 đến Phần 6**, mục này giải quyết 3 tình huống kỹ thuật thường gặp nhất trong thực tế:

#### Tình huống 6.1: Cắt ngang công việc đột xuất với `git stash`
* **Bối cảnh:** Kỹ sư đang chỉnh sửa 8 tệp tính năng phức tạp tại nhánh `feature/search-engine`. Mã nguồn đang viết dở dang, biên dịch bị lỗi (syntax error), chưa đủ điều kiện để tạo một commit hợp lệ. Đột ngột Trưởng nhóm thông báo có sự cố bảo mật cần vào nhánh `main` sửa gấp.
* **Cách xử lý chuẩn mực:**
  ```bash
  # 1. Cất giữ toàn bộ thay đổi (bao gồm cả tệp mới untracked) vào Stack lưu tạm
  git stash push -u -m "WIP: search indexing query parsing"
  
  # 2. Kiểm tra working tree: Hoàn toàn sạch sẽ 100%!
  git status
  
  # 3. Chuyển sang main sửa lỗi hotfix và commit/push bình thường
  git switch main
  # ... xử lý hotfix ...
  
  # 4. Sau khi hoàn thành, quay trở lại nhánh tính năng và lấy lại không gian làm việc
  git switch feature/search-engine
  git stash pop
  ```

#### Tình huống 6.2: Làm sạch commit vụn vặt bằng Interactive Rebase trước khi mở Pull Request
* **Bối cảnh:** Trong quá trình code cục bộ, kỹ sư liên tục commit các mẩu vụn: `fix typo`, `wip`, `chay thu lan 2`, `test debug`. Nếu đẩy nguyên lịch sử này lên GitHub để mở PR sẽ gây rối loạn cây commit của dự án và gây khó khăn cho người Review.
* **Cách xử lý chuẩn mực:**
  ```bash
  # Mở giao diện Rebase tương tác cho 4 commit gần nhất
  git rebase -i HEAD~4
  ```
  *Trong trình soạn thảo, đổi hành động của các commit vụn từ `pick` sang `squash` (hoặc `fixup`):*
  ```text
  pick a1b2c3d feat(search): introduce elasticsearch query builder
  squash e4f5g6h fix typo in query builder
  squash i7j8k9l debug elastic connection timeout
  fixup m1n2o3p remove console debug logs
  ```
  *Kết quả: Toàn bộ 4 commit được gộp thành 1 commit duy nhất mang thông điệp chuẩn hóa theo Conventional Commits: `feat(search): implement Elasticsearch query builder with timeout handling`.*

#### Tình huống 6.3: Cứu nạn dữ liệu sau thảm họa thao tác bằng `git reflog`
* **Bối cảnh:** Một kỹ sư muốn xóa bỏ thay đổi thử nghiệm gần nhất nhưng lại gõ nhầm lệnh: `git reset --hard HEAD~3`. Ba commit quan trọng của 2 ngày làm việc biến mất hoàn toàn khỏi `git log`, nhánh bị kéo lùi về quá khứ.
* **Cách xử lý chuẩn mực:**
  ```bash
  # 1. Kích hoạt cuốn nhật ký tham chiếu ghi nhận mọi dịch chuyển của HEAD
  git reflog
  # Trả về:
  # 9a8b7c6 HEAD@{0}: reset: moving to HEAD~3
  # 1f2e3d4 HEAD@{1}: commit: feat(auth): complete RBAC authorization module
  # 5b6a7c8 HEAD@{2}: commit: feat(auth): add role management middleware
  
  # 2. Xác định commit đỉnh trước khi bị reset chính là HEAD@{1} (SHA: 1f2e3d4)
  
  # 3. Phục hồi nguyên trạng 100% dữ liệu ngay lập tức:
  git reset --hard HEAD@{1}
  # Hoặc tái sinh thành một nhánh cứu nạn an toàn mới:
  git switch -c recovery/rbac-module 1f2e3d4
  ```

---

## 23. Bảng tổng kết và Ma trận ra quyết định kỹ thuật (Engineering Decision Matrix)

Để hệ thống hóa và tra cứu nhanh các quyết định kỹ thuật khi vận hành Git trong thực tế, bảng ma trận dưới đây phân loại chi tiết từng kịch bản sự cố, giải pháp lệnh tối ưu, mức độ rủi ro và khuyến nghị thực thi:

| Kịch bản sự cố / Nhu cầu kỹ thuật | Lệnh Git tối ưu | Mức độ rủi ro | Khuyến nghị thực thi (Best Practice) |
| :--- | :--- | :---: | :--- |
| **Xung đột hợp nhất mã nguồn** | `git status`<br>`git add <file>`<br>`git commit` | Thấp | Phải trao đổi với tác giả viết code xung đột; loại bỏ sạch conflict markers; test chạy thử trước khi commit. |
| **Hoàn tác commit lỗi trên nhánh chung** (`main`, `develop`) | `git revert <commit_hash>` | Rất thấp (An toàn) | Tuyệt đối không dùng `reset`; giữ nguyên lịch sử kiểm toán minh bạch; viết rõ lý do hủy code trong message. |
| **Hoàn tác commit lỗi trên nhánh cá nhân** (chưa push) | `git reset --soft HEAD~1` (giữ code)<br>`git reset --hard HEAD~1` (xóa code) | Trung bình | Chỉ thực hiện khi chắc chắn nhánh chưa được chia sẻ cho bất kỳ ai khác. |
| **Sự cố khẩn cấp trên Production** | `git checkout <tag> -- .`<br>`git commit`<br>`git tag -a vX.Y.Z` | Trung bình | Áp dụng chiến lược "Forward-fix rollback"; phát hành phiên bản vá mới thay vì hạ phiên bản lùi. |
| **Đóng gói phiên bản phần mềm** | `git tag -a vX.Y.Z -m "..."`<br>`git push origin vX.Y.Z` | Rất thấp | Luôn dùng Annotated Tag; tuân thủ quy tắc Semantic Versioning (SemVer); xuất bản kèm Release Notes. |
| **Bắt đầu ngày làm việc / Khảo sát code** | `git fetch origin`<br>`git log HEAD..origin/main`<br>`git diff HEAD origin/main` | Tuyệt đối an toàn (0%) | Luôn fetch trước khi pull; kiểm tra độ lệch mã nguồn để chủ động phòng ngừa xung đột bất ngờ. |
| **Đồng bộ mã nguồn nhánh cá nhân** | `git pull --rebase origin main` | Thấp | Giúp đồ thị commit tuyến tính, không sinh merge commit rác; giải quyết rebase conflict nếu có. |
| **Cần chuyển việc đột xuất khi code dở** | `git stash push -u -m "..."`<br>`git stash pop` | Rất thấp | Đặt thông điệp rõ ràng cho stash; dùng cờ `-u` để lưu cả tệp untracked; không tích trữ quá nhiều stash. |
| **Làm sạch commit trước khi tạo PR** | `git rebase -i HEAD~N` (Squash/Fixup) | Trung bình | Chỉ rebase trên nhánh tính năng cá nhân; gộp các commit vụn thành commit chuẩn Conventional Commits. |
| **Lỡ tay reset hoặc xóa nhầm commit/branch** | `git reflog`<br>`git switch -c rescue <hash>` | Rất thấp | Giữ bình tĩnh; không chạy `git gc`; dùng reflog tìm SHA mồ côi và tạo nhánh phục hồi ngay lập tức. |
