# Phần 1: Giới thiệu tổng quan về Git
## 1. Git là gì?
- Git là hệ thống quản lý phiên bản phân tán mã nguồn mở.
- Được Linus Torvalds tạo ra vào năm 2005, ban đầu để quản lý mã nguồn Linux.
- **Các triết lý cốt lõi:**
  1. **Tốc độ cực nhanh** - Thao tác cục bộ, hạn chế tối đa độ trễ mạng.
  2. **Phân tán thực sự** - Mỗi lập trình viên có một bản sao hoàn chỉnh (full mirror) của kho mã nguồn, bao gồm toàn bộ lịch sử commit.
  3. **Hỗ trợ phát triển phi tuyến tính** - Tạo, xóa, hợp nhất hàng nghìn nhánh nhẹ nhàng, tức thì.
  4. **Toàn vẹn dữ liệu (Băm SHA-1)** - Mọi đối tượng trong Git đều được gán nhãn băm mã hóa SHA-1 (hoặc SHA-256), chống giả mạo hoặc hư hỏng dữ liệu mà không bị phát hiện.
  5. **Snapshot** - Git không lưu trữ thay đổi (diff), mà lưu trữ trạng thái (snapshot) của toàn bộ file tại mỗi thời điểm commit. (Lưu toàn bộ file code được sửa đổi, còn các file không đổi sẽ lưu con trỏ dẫn đến bản cũ).

  ![Minh họa](Snapshot_and_CommitID.png)

- **So sánh Git - SVN - Mecurial:**

  |    Tiêu chí | Git | SVN | Mecurial |
  | :-- | :-- | :-- | :-- |
  | **Kiểu mô hình** | Phân tán | Tập trung | Phân tán |
  | **Lưu trữ** | Snapshot | Diff | Diff |
  | **Phân nhánh** | Nhẹ, tức thì | Nặng, tốn thời gian | Nhẹ |
  | **Tốc độ** | Cực nhanh | Chậm | Nhanh|
  | **Độ phổ biến**| Rất cao | Trung bình | Thấp |

<!-- Diff là lưu sự thay đổi (thêm, xóa) các dòng trong file, yêu cầu bản gốc và các diff trước đó để phục hồi. -->

## 2. Phân biệt Git - GitHub/GitLab/Bitbucket

- **Bảng so sánh:**

  | Tiêu chí | Git | GitHub(GitLab, Bitbucket) |
  | :-- | :-- | :-- |
  | **Định nghĩa** | Hệ thống quản lý phiên bản phân tán (phần mềm cài đặt local) | Nền tảng hosting repository online |
  | **Kiểu mô hình** | Phân tán (mỗi máy local là 1 full mirror) | Tập trung (cloud-based) |
  | **Lưu trữ** | Cục bộ (Local) | Trên server của GitHub |
  | **Tính năng** | Quản lý history, branching, merging, commit, tag | Social coding, code review, issue tracking, CI/CD, project management |
  | **Tương thích** | Có thể kết nối với nhiều remote (GitHub, GitLab, Bitbucket, Azure DevOps...) | Chỉ tương thích với các dịch vụ sử dụng giao thức Git |

## 3. Cài đặt Git & Cấu hình ban đầu
- **Cài đặt Git:** (tải từ trang chủ của Git) hoặc sử dụng lệnh
  1. Với Windows: winget install Git.Git -e
  2. Với Ubuntu/Debian: sudo apt update && sudo apt install git
  3. Với MacOS: brew install git
- **Cấu hình ban đầu:**
  - `git config --global user.name "Tên của bạn"` - Cấu hình tên người dùng
  - `git config --global user.email "Email của bạn"` - Cấu hình email người dùng
  - `git config --global core.editor "Tên editor"` - Cấu hình editor mặc định
- **Kiểm tra phiên bản:**
  - `git --version`
  - `git config --list`
- **Thiết lập SSH key**:
  - `ssh-keygen -t ed25519 -C "Email của bạn"`
  - `eval "$(ssh-agent -s)"`
  - `ssh-add ~/.ssh/id_ed25519`
  - `cat ~/.ssh/id_ed25519.pub` (để copy public key)
  - Đăng nhập [GitHub](https://github.com/) -> Settings -> SSH and GPG keys -> New SSH key -> Add key
  - `ssh -T git@github.com` -> "Hi 'username'! You've successfully authenticated, but GitHub does not provide shell access." (xác nhận đã kết nối thành công)

---

# Phần 2: Làm việc với Repository

## 4. Khởi tạo và Clone Repository
- **Khởi tạo repository:** `git init` (tạo repo rỗng)
  - Khởi tạo repo Git mới từ thư mục local hiện tại
  - Tạo ra thư mục ẩn `\.git` chứa cơ sở dữ liệu và cấu hình rỗng
  - Thường dùng khi bắt đầu dự án mới từ máy cá nhân trước khi đẩy lên máy chủ remote
  - Cú pháp: 
    ```bash
    mkdir new-project
    cd new-project
    git init
    ```

- **Clone repository:** `git clone <URL>`
  - Tạo một bản sao cục bộ từ remote repository
  - Tự động kết nối đến remote source
  - Thường dùng khi tham gia dự án đã có remote repository
  - Cú pháp: 
    ```bash
    git clone https://github.com/username/repo-name.git
    cd repo-name
    ```

- **Cấu trúc thư mục `\.git`:**
  - **`HEAD`**: File văn bản thuần chứa con trỏ chỉ tới nhánh hiện tại đang làm việc (ví dụ: `ref: refs/heads/main`).
  - **`config`**: File cấu hình riêng của repository này (ghi đè cấu hình global nếu có).
  - **`description`**: Mô tả dự án (dùng cho GitWeb).
  - **`hooks/`**: Chứa các script kích hoạt theo sự kiện (ví dụ: `pre-commit`, `post-merge`) để tự động kiểm tra lint, format code, chạy unit test trước khi commit.
  - **`info/exclude`**: Tương tự `.gitignore` nhưng chỉ có tác dụng cục bộ trên máy bạn, không được commit hay chia sẻ.
  - **`index`**: **Staging Area (Khu vực chuẩn bị)** dưới dạng file nhị phân. Lưu cây thư mục và mã băm của các file đã `git add`.
  - **`objects/`**: Trái tim của Git - Cơ sở dữ liệu hướng nội dung (Content-addressable storage). Lưu 4 loại đối tượng chính:
    1. `blob`: Lưu trữ nội dung file dữ liệu.
    2. `tree`: Lưu cấu trúc thư mục (liệt kê tên file và trỏ tới các `blob` hoặc `tree` con).
    3. `commit`: Lưu trữ metadata của commit (tác giả, ngày giờ, thông điệp, trỏ tới `tree` gốc của phiên bản đó và trỏ tới `parent commit`).
    4. `annotated tag`: Lưu trữ thông tin tag phiên bản.
  - **`refs/`**: Chứa các tham chiếu (pointers):
    - `refs/heads/`: Chứa các local branch (mỗi branch là 1 file 41 bytes chứa hash của commit đỉnh).
    - `refs/tags/`: Chứa các con trỏ tag.
    - `refs/remotes/`: Chứa con trỏ theo dõi các remote branch (`origin/main`).

## 5. Trạng thái file trong Git
- **Untracked file:** File mới được tạo nhưng chưa được Git theo dõi
- **Tracked file:** File đã được Git theo dõi
    - **Staging area:** File đã được thêm vào staging area nhưng chưa được commit
    - **Modified file:** File đã được sửa đổi nhưng chưa được thêm vào staging area
    - **Committed/Unmodified:** Dữ liệu file đã được Git lưu lại trong lịch sử và không có thay đổi so với file trong staging area
- **Kiểm tra trạng thái file:**
  - `git status` - Xem trạng thái của file
  - `git status -s` - Xem trạng thái của file dưới dạng ngắn
  - `git status -u` - Xem trạng thái của file dưới dạng chi tiết
- **Xem sự khác biệt giữa các phiên bản:**
  - `git diff` - Xem sự khác biệt giữa working directory và staging area
  - `git diff --cached` - Xem sự khác biệt giữa staging area và repository
  - `git diff <commit1> <commit2>` - Xem sự khác biệt giữa hai commit

## 6. Thêm và Commit thay đổi

- **`git add`:** - Thêm file vào staging area
  - Thêm từng file cụ thể: `git add <file-name1> <file-name2> ...`
  - Thêm tất cả file trong thư mục: `git add .`
  - Thêm tất cả file đã sửa đổi: `git add -u`
  - Thêm tất cả file, kể cả untracked: `git add -A`
  - Thêm từng dòng: `git add -p <file-name>`

- **`git commit`:** - Commit thay đổi vào repository
  - Commit thay đổi trong staging area: `git commit -m "message"`
  - Commit thay đổi cùng với staging area: `git commit -am "message"`
  - Commit thay đổi với message chi tiết: `git commit -v "message"`
  - Sửa lại commit gần nhất : `git add <file-name>` trước rồi `git commit --amend`

- **Cách viết message commit tốt:**
  - Message commit phải ngắn gọn, súc tích, mô tả rõ ràng thay đổi
  - Message commit phải có dấu ""
  - Nên viết commit message bằng tiếng Anh
  - **Conventional Commits**:
    - **Type**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
    - **Scope**: (tùy chọn) `login`, `register`, `api`, `ui`, `core`, `utils`, ...
    - **Description**: mô tả thay đổi
    - Format: 
    ```text
    <type>(<scope>): <description>
    [optional body chứa vấn đề kỹ thuật(lý do, giải pháp, ...)] 
    [optional footer chứa info liên quan(Issue ID, Breaking changes...)]
    ```
    - **Ví dụ:**
    ```text
    feat(auth): add user login and registration

    - Implement user login API endpoint
    - Implement user registration API endpoint
    - Add user authentication middleware
    - Add user validation
    - Add error handling
    ```
    


# Phần 3: Làm việc với lịch sử và phiên bản

## 7. Xem lịch sử commit
- **`git log`:** - Xem lịch sử commit
  - Xem lịch sử commit: `git log`
  - Xem lịch sử commit dạng ngắn: `git log --oneline`
  - Xem lịch sử commit dạng đồ thị: `git log --graph --oneline --decorate`
  - Lọc commit theo tác giả: `git log --author="Author Name"`
  - Lọc commit theo nội dung: `git log --grep="Commit message"`
  - Lọc commit theo khoảng thời gian: `git log --since="2 weeks ago"` (hơn 2 tuần trước), `git log --until="2 weeks ago"` (trước 2 tuần)
  - Lọc commit theo type (sử dụng patch):
    ```bash
    git log --grep="^feat:" --author="<Author Name>"  # Lọc commit có type "feat" và author "Author Name"
    ```

- **CommitID là:** Mã băm SHA-1 của commit, dùng để xác định phiên bản
  - Format: 40 ký tự hex
  - Ví dụ: `commit a1b2c3d4e5f67890123456789012345678901234`
  - Có thể dùng short hash (7-8 ký tự)

## 8. Undo/Revert/Reset thay đổi

- **`git checkout`** - Hoàn tác thay đổi (cách truyền thống)
  - Hủy thay đổi của file trong Working Directory: `git checkout -- <file-name>`
  - Hủy tất cả thay đổi trong Working Directory: `git checkout -- .`
  - Xem lại trạng thái mã nguồn tại commit cũ: `git checkout <commit_id>`

- **`git restore`** - Hoàn tác thay đổi (khuyến nghị từ Git 2.23+)
  - Hủy thay đổi trong Working Directory (chưa `add`): `git restore <file-name>`
  - Hủy tất cả thay đổi trong Working Directory: `git restore .`
  - Đưa file từ Staging Area về lại Working Directory (Unstage): `git restore --staged <file-name>`
  - Khôi phục file về trạng thái của một commit cụ thể: `git restore --source=<commit_id> <file-name>`
  
- **`git reset`** - Hoàn tác commit và di chuyển HEAD (viết lại lịch sử)
  - Bỏ file khỏi Staging Area (Unstage): `git reset HEAD <file-name>`
  - Quay lui commit gần nhất:
    - `--soft`: Giữ nguyên thay đổi trong Staging Area (`git reset --soft HEAD~1`)
    - `--mixed` (mặc định): Đưa thay đổi về Working Directory (`git reset --mixed HEAD~1`)
    - `--hard`: Xóa toàn bộ thay đổi ở cả Staging và Working Directory (`git reset --hard HEAD~1`)

- **`git revert`** - Hoàn tác an toàn bằng cách tạo commit đảo ngược
  - Tạo commit mới đảo ngược thay đổi của một commit cũ: `git revert <commit_id>`
  - Revert mà không tạo commit ngay (để sửa thêm): `git revert -n <commit_id>`

- **Khi nào nên dùng `git revert` thay vì `git reset`?**
  - **Dùng `git reset`**: Khi commit lỗi ở trên máy cá nhân (**Local branch**), chưa từng push lên remote, vì lệnh này viết lại lịch sử commit.
  - **Dùng `git revert`**: Khi commit lỗi **đã push lên remote** (nhánh chung như `main`, `develop`), vì revert tạo commit mới bảo toàn lịch sử tuyến tính và không gây xung đột cho các thành viên khác.

## 9. `.gitignore` - Tập tin "tránh xa" của Git

- **`.gitignore` là gì?**
  - Là một tập tin plain text, chứa danh sách các pattern (mẫu), chỉ thị cho Git biết những file/thư mục nào **không cần theo dõi** (untracked) và **không được commit** vào repository.

- **Cấu trúc cú pháp và ví dụ**
  - **Cú pháp:** Mỗi dòng chứa một pattern (mẫu). Dấu `#` dùng để comment (ghi chú).
  - **Ký tự đại diện:**
    - `*`: Khớp với 0 hoặc nhiều ký tự (ngoại trừ `/`)
    - `?`: Khớp với 1 ký tự (ngoại trừ `/`)
    - `[abc]`: Khớp với ký tự trong ngoặc
    - `**`: Khớp với 0 hoặc nhiều thư mục (khi đi cùng với dấu `/` hoặc ở đầu dòng)
  - **Prefixes (tiền tố):**
    - `/`: Chỉ áp dụng ở thư mục gốc của repository
    - `!`: Phủ định (override), cho phép theo dõi file/thư mục đã bị ignore trước đó
  - **Đường dẫn tuyệt đối vs tương đối:**
    - Đường dẫn không bắt đầu bằng `/`: Relative path (so với vị trí của file .gitignore)
    - Đường dẫn bắt đầu bằng `/`: Absolute path (so với gốc của repository)

- **Các ví dụ .gitignore thực tế**
  ```text
  # Ignore files
  *.log
  *.tmp
  *.swp
  *.swo
  *.DS_Store
  
  # Ignore directories
  node_modules/
  build/
  dist/
  
  # Ignore specific files
  .env
  config.local.js
  
  # Ignore files with specific pattern
  *.bak
  *.old
  ```

# Phần 4: Branching và Merging

## 10. Branch là gì và tại sao cần branch

- **Branch là gì?**
  - Branch là một con trỏ tới một commit cụ thể, đại diện cho một dòng lịch sử phát triển của dự án.
  - Git lưu trữ tất cả các branch trong thư mục `.git/refs/heads/`.

- **Tại sao cần branch?**
  - Để phát triển tính năng mới mà không ảnh hưởng đến main codebase.
  - Để thử nghiệm các ý tưởng mới mà không làm hỏng code đang hoạt động.
  - Để làm việc nhóm hiệu quả, mỗi người một branch.
  - Để sửa lỗi hotfix mà không ảnh hưởng đến quá trình phát triển tính năng mới.

## 11. Tạo và chuyển nhánh

- **Tạo branch:**
  - Tạo branch mới: `git branch <branch-name>`
  - Tạo branch và chuyển sang branch đó: `git checkout -b <branch-name>` hoặc `git switch -c <branch-name>`
  - Tạo branch mới từ một commit cụ thể: `git branch <branch-name> <commit_id>`

- **Chuyển nhánh:**
  - Chuyển sang branch khác: `git checkout <branch-name>` hoặc `git switch <branch-name>`
  - Xem danh sách branch: `git branch`
  - Xem danh sách branch và trạng thái: `git branch -vv`

- **Xóa branch:**
  - Xóa branch cục bộ: `git branch -d <branch-name>`
  - Xóa branch cục bộ cưỡng chế: `git branch -D <branch-name>`
  - Xóa branch remote: `git push origin --delete <branch-name>`

## 12. Merge branch và xử lý xung đột (Conflict)

- **Merge là gì?**
  - Merge là quá trình kết hợp các thay đổi từ một branch này sang branch khác.
  - Có 2 loại merge: Fast-forward merge và 3-way merge.

- **Fast-forward merge**
  - Xảy ra khi branch đích chưa có commit mới nào kể từ khi branch nguồn được tạo ra.
  - Git chỉ đơn giản di chuyển con trỏ branch đích đến commit mới nhất của branch nguồn.

- **3-way merge**
  - Xảy ra khi branch đích đã có commit mới kể từ khi branch nguồn được tạo ra.
  - Git tìm ra điểm chung gần nhất (common ancestor) của 2 branch, sau đó kết hợp thay đổi từ cả 2 branch.

- **Xử lý merge conflict**
  - Xảy ra khi cả 2 branch đều có thay đổi ở cùng một dòng của cùng một file.
  - Git sẽ đánh dấu vùng xung đột trong file với các ký tự `<<<<<<<`, `=======`, `>>>>>>>`.
  - **Để giải quyết conflict:**
    1. Mở file bị conflict và tìm các vùng xung đột.
    2. Chỉnh sửa file để giữ lại phần code mong muốn (có thể giữ cả 2 hoặc chọn 1).
    3. Xóa các ký tự đánh dấu `<<<<<<<`, `=======`, `>>>>>>>`.
    4. `git add <file-name>` để đánh dấu đã giải quyết.
    5. `git commit` để hoàn tất merge.

## 13. Các chiến lược branching phổ biến

### 1. Git Flow
- **Branch chính:**
  - `master`: production code (chỉ deploy từ branch này)
  - `develop`: integration branch (code mới nhất)
- **Branch hỗ trợ:**
  - `feature/*`: branch cho feature mới
  - `release/*`: branch chuẩn bị release
  - `hotfix/*`: branch sửa lỗi production khẩn cấp
- **Flow:**
  - Feature branch từ `develop` -> merge về `develop`
  - Release branch từ `develop` -> merge về `master` và `develop`
  - Hotfix branch từ `master` -> merge về `master` và `develop`

### 2. GitHub Flow
- Chỉ có 2 branch: `main` và feature branches
- Feature branch từ `main` -> merge về `main` thông qua Pull Request
- Thích hợp cho các dự án CI/CD (Continuous Integration/Continuous Delivery)

### 3. GitLab Flow
- Có thể có nhiều environment branches (production, staging, etc.)
- Feature branch từ `master` -> merge về environment branch tương ứng
- Có thể sử dụng release branches

# Phần 5: Remote Repository

## 14. Thêm remote và đẩy code

- **Remote repository là gì?**
  - Là một repository được lưu trữ trên server (ví dụ: GitHub, GitLab, Bitbucket).
  - Là nơi để lưu trữ code và chia sẻ với các thành viên khác trong team.

- **Thêm remote repository:**
  - `git remote add origin <remote_url>`

- **Đẩy code lên remote repository:**
  - `git push origin <branch-name>`

## 15. Làm việc nhóm: fork, clone, pull request

- **Fork là gì?**
  - Fork là quá trình tạo một bản sao của repository về tài khoản của mình.
- **Clone là gì?**
  - Clone là quá trình tải repository từ remote về máy cá nhân.
  - `git clone <remote_url>`
- **Pull Request (PR) là gì?**
  - Pull Request là một yêu cầu gửi thay đổi từ một branch này sang branch khác.
  - Thông qua PR, các thành viên khác có thể review code và đưa ra góp ý trước khi merge.
- **Mô hình cộng tác GitHub cơ bản**
  - **Shared repository** (Dự án chung)
  - **Forking** (Phân nhánh)
  - **Pull Requests** (Yêu cầu hợp nhất)
## 16. Giải quyết xung đột khi làm việc nhóm

- **Quy trình giải quyết xung đột**
  - `git switch` sang branch cần merge
  - `git pull` hoặc `git fetch` để tải thay đổi từ remote
  - `git merge <branch-name>` để merge thay đổi
  - Giải quyết conflict
  - `git add <file-name>` để đánh dấu đã giải quyết.
  - `git commit` để hoàn tất merge.
  - `git push` để đẩy code lên remote repository.

# Phần 6: Công cụ và Kỹ năng nâng cao
 
## 17. Tag và Versioning

- **Tag là gì?**
  - Tag là một con trỏ tới một commit cụ thể, đại diện cho một phiên bản của dự án.
- **Cách tạo tag:**
  - `git tag <tag-name>`: Tạo tag nhẹ (lightweight tag)
  - `git tag -a <tag-name> -m "<tag-message>"`: Tạo tag có chú thích (annotated tag)
- **Cách xem tag:**
  - `git tag`: Xem danh sách tất cả các tag
  - `git show <tag-name>`: Xem thông tin chi tiết về tag
- **Cách đẩy tag lên remote:**
  - `git push origin <tag-name>`: Đẩy một tag cụ thể
  - `git push origin --tags`: Đẩy tất cả các tag

## 18. Stash

- **Stash là gì?**
  - Stash là một nơi để lưu tạm thay đổi chưa commit.
  - Mục đích chính của stash là để chuyển đổi ngữ cảnh làm việc mà không cần phải commit code đang dở.
- **Lưu thay đổi vào stash:**
  - `git stash`: Lưu tất cả thay đổi chưa commit
  - `git stash save "<stash-message>"`: Lưu thay đổi với message
- **Xem danh sách stash:**
  - `git stash list`: Xem danh sách tất cả các stash
- **Khôi phục thay đổi từ stash:**
  - `git stash pop`: Khôi phục thay đổi và xóa stash
  - `git stash apply`: Khôi phục thay đổi nhưng giữ lại stash
- **Xóa stash:**
  - `git stash drop`: Xóa stash gần nhất
  - `git stash clear`: Xóa tất cả các stash

## 19. Rebase và Squash

- **Rebase là gì?**
  - Rebase là quá trình di chuyển các commit của một branch sang một base branch khác.
  - Rebase giúp làm phẳng lịch sử commit và loại bỏ các merge commit không cần thiết.
  - Cách dùng
    ```bash
    # Giả sử bạn đang ở branch feature/new-feature
    # Và muốn rebase nó lên branch develop
    git switch feature/new-feature
    git rebase develop
    ```
  
- **Squash là gì?**
  - Squash là quá trình gộp nhiều commit thành một commit duy nhất.
  - Mục đích chính của squash là để làm sạch lịch sử commit và gộp các thay đổi liên quan vào một commit.
  - Cách dùng
    ```bash
    # Giả sử bạn đang ở branch feature/new-feature
    # Và muốn squash các commit thành một commit duy nhất
    git switch feature/new-feature
    git rebase -i HEAD~5
    ```

## 20. Git Alias và Log Formatting

- **Git Alias là gì?**
  - Git Alias là bí danh cho các lệnh Git, giúp tiết kiệm thời gian khi gõ lệnh.
- **Cách tạo alias:**
  - `git config --global alias.<alias-name> "<git-command>"`
  - Ví dụ:
    ```bash
    git config --global alias.co "checkout"
    git config --global alias.st "status"
    git config --global alias.cm "commit -m"
    git config --global alias.p "push origin"
    git config --global alias.pl "pull origin"
    ```
- **Log Formatting là gì?**
  - Log Formatting là cách định dạng đầu ra của lệnh `git log`.

## 21. Git Reflog và khôi phục commit bị mất

- **Git Reflog là gì?**
  - Git Reflog là viết tắt của "reference logs", là một cơ chế ghi lại tất cả các di chuyển của HEAD và các tham chiếu khác trong repository.
  - Reflog chỉ lưu trữ cục bộ trên máy của bạn và sẽ bị mất khi bạn xóa repository.
- **Cách xem reflog:**
  - `git reflog`: Xem danh sách tất cả các reflog
- **Cách khôi phục commit bị mất:**
  - `git reset --hard <commit_hash>`: Khôi phục commit và xóa tất cả thay đổi sau commit đó
  - `git reset --soft <commit_hash>`: Khôi phục commit nhưng giữ lại thay đổi

# Phần 7: Thực hành dự án thực tế 

## 22. Giả lập dự án thực tế
  [Mô phỏng giả lập](Simulation.md)

  [Video](https://ptiteduvn-my.sharepoint.com/:v:/g/personal/taind_b24cn510_stu_ptit_edu_vn/IQDVCE0cb5XjRYENKx8L-9AnAQQZqn-w2cOIIpM3rhwsZE0?nav=eyJyZWZlcnJhbEluZm8iOnsicmVmZXJyYWxBcHAiOiJPbmVEcml2ZUZvckJ1c2luZXNzIiwicmVmZXJyYWxBcHBQbGF0Zm9ybSI6IldlYiIsInJlZmVycmFsTW9kZSI6InZpZXciLCJyZWZlcnJhbFZpZXciOiJNeUZpbGVzTGlua0NvcHkifX0&e=YSYZnV)
