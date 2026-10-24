# BÁO CÁO: TÌM HIỂU VÀ THỰC HÀNH GIT

---

## PHẦN 1: GIỚI THIỆU TỔNG QUAN VỀ GIT

### 1. Git là gì?

**Git** là hệ thống quản lý phiên bản phân tán (Distributed Version Control System - DVCS). Nó ghi lại mọi thay đổi của mã nguồn theo thời gian, để có thể xem lại, so sánh, khôi phục hoặc làm việc song song trên nhiều nhánh.

**Lịch sử và lý do ra đời**
- Năm 2005, **Linus Torvalds** (cha đẻ Linux) viết ra Git trong vài tuần.
- Trước đó, cộng đồng Linux kernel dùng **BitKeeper** (phần mềm thương mại, miễn phí cho dự án mở). Khi thỏa thuận miễn phí bị thu hồi, cộng đồng cần một công cụ thay thế.
- Yêu cầu thiết kế của Linus:
  - **Nhanh**: kernel có hàng chục nghìn file và hàng nghìn người đóng góp.
  - **Phân tán**: mỗi người có bản sao đầy đủ của repo, làm việc offline được.
  - **Toàn vẹn dữ liệu**: mọi object đều được định danh bằng hash nên không thể sửa lịch sử mà không bị phát hiện.
  - **Hỗ trợ branch/merge mạnh**: tạo nhánh rẻ, merge nhanh.
  - **Đơn giản về mặt thiết kế**: bản chất là một content-addressable filesystem.

**Cách Git lưu dữ liệu**: Git lưu **snapshot** (ảnh chụp toàn bộ dự án tại mỗi commit), không lưu danh sách delta như các VCS đời cũ. File không đổi thì chỉ trỏ lại bản cũ nên không tốn thêm dung lượng.

**So sánh Git với các VCS khác**

| Tiêu chí | Git | SVN (Subversion) | Mercurial |
|---|---|---|---|
| Mô hình | Phân tán | Tập trung | Phân tán |
| Bản sao lịch sử | Mỗi máy có toàn bộ lịch sử | Chỉ server giữ lịch sử đầy đủ | Mỗi máy có toàn bộ lịch sử |
| Làm việc offline | Commit, xem log, tạo branch đều offline | Cần kết nối server để commit | Như Git |
| Branch | Rất nhẹ, tạo tức thì | Branch là bản copy thư mục, nặng hơn | Nhẹ, nhưng khái niệm khác Git |
| Tốc độ | Rất nhanh | Chậm hơn với repo lớn | Nhanh |
| Độ phổ biến | Chuẩn công nghiệp hiện nay | Giảm dần, còn ở hệ thống cũ | Ít phổ biến hơn |
| Độ khó học | Trung bình đến cao (nhiều lệnh) | Dễ hơn | Dễ hơn Git |

**Kết luận**: Git thắng thế nhờ hiệu năng, branching mạnh và hệ sinh thái (GitHub, GitLab, CI/CD) rất lớn.

### 2. Khác biệt giữa Git và GitHub/GitLab/Bitbucket

| | Git | GitHub / GitLab / Bitbucket |
|---|---|---|
| Bản chất | Công cụ (phần mềm) chạy trên máy | Dịch vụ web lưu trữ Git repository |
| Cài đặt | Cài trên máy local | Truy cập qua web, tạo tài khoản |
| Chức năng chính | Quản lý phiên bản, branch, merge | Lưu trữ remote, cộng tác, quản lý dự án |
| Tính năng thêm | Không có | Pull Request/Merge Request, Issues, CI/CD, Wiki, phân quyền, code review |

Ví dụ dễ hiểu: **Git giống như phần mềm soạn thảo Word, còn GitHub giống Google Drive**, nơi lưu và chia sẻ các file đó cho cả nhóm.

- **GitHub**: lớn nhất, mạnh về cộng đồng mã nguồn mở (Microsoft sở hữu).
- **GitLab**: tích hợp sẵn CI/CD mạnh, có thể tự host (self-hosted).
- **Bitbucket**: tích hợp tốt với Jira/Trello (Atlassian).

### 3. Cài đặt Git và cấu hình ban đầu

**Cài đặt**
```bash
# Windows: tải Git for Windows tại git-scm.com
# macOS
brew install git
# Ubuntu/Debian
sudo apt update && sudo apt install git
# Fedora/RHEL
sudo dnf install git
```

**Kiểm tra version**
```bash
git --version
```

**Cấu hình danh tính** (bắt buộc, vì thông tin này được gắn vào mỗi commit)
```bash
git config --global user.name "Nguyen Van A"
git config --global user.email "a@example.com"
git config --global init.defaultBranch main   # đặt tên nhánh mặc định
git config --global core.editor "code --wait" # tùy chọn: dùng VS Code
git config --list                              # xem toàn bộ cấu hình
```

**Ba cấp độ cấu hình** (cấp sau ghi đè cấp trước):
1. `--system`: toàn máy (`/etc/gitconfig`)
2. `--global`: theo user (`~/.gitconfig`)
3. `--local`: theo repo (`.git/config`)

**Thiết lập SSH key** (để push/pull không cần nhập mật khẩu)
```bash
# 1. Tạo key
ssh-keygen -t ed25519 -C "a@example.com"
# Nhấn Enter để dùng đường dẫn mặc định, có thể đặt passphrase

# 2. Khởi động ssh-agent và thêm key
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# 3. Copy public key
cat ~/.ssh/id_ed25519.pub
# Dán vào GitHub: Settings → SSH and GPG keys → New SSH key

# 4. Kiểm tra kết nối
ssh -T git@github.com
```
Lưu ý: chỉ chia sẻ file `.pub`. **Không bao giờ** chia sẻ private key (`id_ed25519`).

---

## PHẦN 2: LÀM VIỆC VỚI REPOSITORY

### 4. Khởi tạo và clone repository

**`git init`**: tạo repo mới từ thư mục hiện có.
```bash
mkdir my-project && cd my-project
git init
```

**`git clone`**: sao chép repo có sẵn từ remote, kèm toàn bộ lịch sử.
```bash
git clone https://github.com/user/repo.git
git clone git@github.com:user/repo.git my-folder   # SSH, đổi tên thư mục
git clone --depth 1 <url>                          # shallow clone, chỉ lấy commit mới nhất
```

| | `git init` | `git clone` |
|---|---|---|
| Dùng khi | Bắt đầu dự án mới | Lấy dự án đã tồn tại |
| Kết quả | Repo rỗng, chưa có remote | Repo đầy đủ, tự thêm remote `origin` |

**Cấu trúc thư mục `.git`**: đây là "bộ não" của repo. Xóa nó thì thư mục chỉ còn là folder thường.

| Thành phần | Ý nghĩa |
|---|---|
| `HEAD` | Con trỏ tới branch/commit hiện tại |
| `config` | Cấu hình riêng của repo |
| `objects/` | Kho lưu mọi dữ liệu (blob, tree, commit, tag) |
| `refs/` | Lưu con trỏ tới branch (`heads/`), tag (`tags/`), remote (`remotes/`) |
| `index` | Staging area (vùng chuẩn bị commit) |
| `hooks/` | Script tự chạy theo sự kiện (pre-commit, pre-push, ...) |
| `logs/` | Lịch sử di chuyển của HEAD/branch (nguồn của reflog) |

**4 loại object trong Git**:
- **blob**: nội dung một file
- **tree**: cấu trúc thư mục, trỏ tới blob và tree con
- **commit**: snapshot, gồm tree gốc, commit cha, tác giả, thời gian, message
- **tag**: đánh dấu có chú thích (annotated tag)

### 5. Trạng thái file trong Git

Một file trải qua các trạng thái sau:

```
Untracked ──git add──▶ Staged ──git commit──▶ Committed
                                                  │
                                              (sửa file)
                                                  ▼
                       Staged ◀──git add── Modified
```

| Trạng thái | Ý nghĩa |
|---|---|
| **Untracked** | File mới, Git chưa theo dõi |
| **Modified** | File đã được theo dõi và đã bị sửa, chưa add |
| **Staged** | File đã `git add`, sẵn sàng đưa vào commit kế tiếp |
| **Committed** | Thay đổi đã lưu an toàn trong lịch sử |

Tương ứng với **3 vùng**: *Working Directory* → *Staging Area (Index)* → *Repository (.git)*.

**Lệnh kiểm tra**
```bash
git status                # xem trạng thái tổng quát
git status -s             # dạng rút gọn
git diff                  # khác biệt: working dir vs staging
git diff --staged         # khác biệt: staging vs commit gần nhất (cũng viết --cached)
git diff main..feature    # so sánh hai branch
```

Ký hiệu của `git status -s`: `??` untracked, ` M` modified chưa stage, `M ` đã stage, `A ` file mới đã stage.

### 6. Thêm và commit thay đổi

```bash
git add file.txt          # thêm một file
git add src/              # thêm cả thư mục
git add .                 # thêm tất cả thay đổi trong thư mục hiện tại
git add -p                # chọn từng đoạn (hunk) để stage, rất hữu ích
git commit -m "Thông điệp commit"
git commit -am "msg"      # add + commit cho file đã tracked (không gồm file mới)
git commit --amend        # sửa commit gần nhất (message hoặc thêm file quên)
```

**Cách viết commit message tốt**
- Dòng đầu (subject) **≤ 50 ký tự**, dùng thể mệnh lệnh: "Add login validation", không viết "Added" hay "Adding".
- Cách một dòng trống, sau đó phần body giải thích **tại sao** thay đổi, không chỉ **cái gì**.
- Mỗi commit chỉ nên làm **một việc** (atomic commit).
- Có thể dùng chuẩn **Conventional Commits**:
  ```
  feat: thêm chức năng đăng nhập bằng Google
  fix: sửa lỗi crash khi giỏ hàng rỗng
  docs: cập nhật README
  refactor: tách hàm tính thuế
  chore: nâng cấp dependency
  ```

Ví dụ tốt và xấu:
```
❌ fix bug
❌ update
✅ fix: handle null user in profile page
✅ feat(auth): add JWT refresh token support
```

---

## PHẦN 3: LÀM VIỆC VỚI LỊCH SỬ VÀ PHIÊN BẢN

### 7. Xem lịch sử commit

```bash
git log                           # đầy đủ
git log --oneline                 # mỗi commit một dòng
git log --graph --oneline --all   # vẽ cây nhánh
git log -n 5                      # 5 commit gần nhất
git log --author="Nguyen"         # lọc theo tác giả
git log --since="2 weeks ago"     # lọc theo thời gian
git log -- path/to/file           # lịch sử của một file
git log -S"tenHam"                # tìm commit làm thêm/xóa chuỗi này

git show <commit>                 # chi tiết một commit (message + diff)
git show HEAD~2                   # commit trước HEAD hai bước

git blame file.txt                # ai sửa từng dòng, ở commit nào
git blame -L 10,20 file.txt       # chỉ các dòng 10 đến 20
```

**Commit ID (SHA-1 hash)**
- Ví dụ: `a1b2c3d4e5f6...` (40 ký tự hex). Thường chỉ cần dùng 7 ký tự đầu (`a1b2c3d`) miễn là không trùng.
- Hash được tính từ **nội dung commit**: tree, commit cha, tác giả, thời gian, message. Vì vậy:
  - Mỗi commit có ID duy nhất.
  - Chỉ cần sửa một ký tự nào đó thì hash đổi, nên Git phát hiện được dữ liệu bị hỏng hay bị sửa.
  - Commit con chứa hash của commit cha, tạo thành chuỗi liên kết (tương tự blockchain về ý tưởng).
- Lưu ý: SHA-1 không còn được coi là an toàn tuyệt đối về mặt mật mã học. Git đã có hỗ trợ SHA-256 ở dạng thử nghiệm, nhưng phần lớn repo hiện vẫn dùng SHA-1.

**Cách tham chiếu commit**: `HEAD`, `HEAD~1` (cha), `HEAD^`, `HEAD~3`, tên branch, tên tag.

### 8. Undo / Revert / Reset thay đổi

Đây là phần dễ nhầm nhất. Phân loại theo **tình huống**:

**a) Hủy thay đổi chưa add (ở working directory)**
```bash
git restore file.txt              # cách mới (Git ≥ 2.23)
git checkout -- file.txt          # cách cũ
```
⚠️ Thay đổi bị mất vĩnh viễn, không khôi phục được.

**b) Bỏ file khỏi staging (đã add nhưng chưa commit)**
```bash
git restore --staged file.txt     # cách mới
git reset HEAD file.txt           # cách cũ
```

**c) Sửa commit gần nhất**
```bash
git commit --amend
```

**d) `git reset`: di chuyển HEAD (và branch) về commit cũ**

| Chế độ | Commit | Staging | Working dir |
|---|---|---|---|
| `--soft` | Lùi | Giữ nguyên | Giữ nguyên |
| `--mixed` (mặc định) | Lùi | Xóa | Giữ nguyên |
| `--hard` | Lùi | Xóa | **Xóa (mất thay đổi)** |

```bash
git reset --soft HEAD~1    # bỏ commit, giữ lại thay đổi ở trạng thái staged
git reset HEAD~1           # bỏ commit, thay đổi về lại modified
git reset --hard HEAD~1    # bỏ commit và xóa luôn thay đổi
```

**e) `git revert`: tạo commit MỚI để đảo ngược commit cũ**
```bash
git revert <commit>
git revert HEAD
git revert -m 1 <merge-commit>    # revert một merge commit
```

**Khi nào dùng revert thay vì reset?**

| | `reset` | `revert` |
|---|---|---|
| Cơ chế | Viết lại lịch sử (xóa commit) | Thêm commit đảo ngược, lịch sử giữ nguyên |
| An toàn trên branch đã push/dùng chung | ❌ Nguy hiểm | ✅ An toàn |
| Dùng khi | Commit còn ở local, chưa push | Commit đã push lên remote hoặc đồng nghiệp đã pull |

**Nguyên tắc vàng**: *Đã push và chia sẻ thì dùng `revert`; còn ở local thì có thể dùng `reset`.* Nếu `reset` rồi push thì phải `push --force`, làm hỏng lịch sử của người khác.

**Về `git checkout`**: lệnh này "làm quá nhiều việc" (chuyển branch, khôi phục file, về commit cũ) nên từ Git 2.23 được tách thành `git switch` (đổi branch) và `git restore` (khôi phục file).

### 9. Làm việc với `.gitignore`

**Ý nghĩa**: file khai báo những file/thư mục Git **không theo dõi**: file build, thư viện tải về, file cấu hình bí mật, file rác của hệ điều hành/IDE.

**Cú pháp**
```gitignore
# Đây là comment
*.log                # mọi file đuôi .log
node_modules/        # cả thư mục
build/
dist/
.env                 # file chứa bí mật (API key, password)
!important.log       # dấu ! = ngoại lệ, KHÔNG ignore file này
/config.local        # chỉ ignore ở thư mục gốc, không ignore ở thư mục con
doc/**/*.pdf         # ** khớp mọi cấp thư mục con
.DS_Store            # file rác macOS
Thumbs.db            # file rác Windows
.idea/               # IDE JetBrains
.vscode/
__pycache__/
*.pyc
```

**Ví dụ thực tế cho dự án Node.js**
```gitignore
node_modules/
dist/
.env
.env.local
npm-debug.log*
coverage/
.DS_Store
```

**Lưu ý quan trọng**
- `.gitignore` **chỉ có tác dụng với file chưa được tracked**. Nếu file đã commit trước đó, phải gỡ ra khỏi index:
  ```bash
  git rm --cached file.txt
  git rm -r --cached node_modules/
  git commit -m "Stop tracking node_modules"
  ```
- Nếu lỡ commit file bí mật (key, password), chỉ xóa file là chưa đủ vì nó vẫn nằm trong lịch sử. Cần đổi (rotate) key ngay và dọn lịch sử bằng công cụ như `git filter-repo`.
- Có thể tham khảo mẫu có sẵn tại **gitignore.io** hoặc repo `github/gitignore`.
- Kiểm tra vì sao một file bị ignore: `git check-ignore -v file.txt`.

---

## PHẦN 4: NHÁNH (BRANCHING) VÀ HỢP NHẤT (MERGING)

### 10. Branch là gì và tại sao cần branch?

**Branch** thực chất chỉ là **một con trỏ nhẹ (41 byte) trỏ tới một commit**. Vì vậy tạo branch gần như tức thì và gần như không tốn dung lượng. `HEAD` trỏ tới branch hiện tại.

```
A ← B ← C        ← main
          ↖
           D ← E ← feature
```

**Lợi ích**
- **Cô lập công việc**: phát triển tính năng mới mà không ảnh hưởng code ổn định ở `main`.
- **Làm song song**: nhiều người, nhiều tính năng cùng lúc.
- **Thử nghiệm an toàn**: không ổn thì xóa branch.
- **Code review**: gom thay đổi vào branch rồi tạo Pull Request.

### 11. Tạo và chuyển nhánh

```bash
git branch                      # liệt kê branch local
git branch -a                   # gồm cả branch remote
git branch -vv                  # kèm commit cuối và upstream
git branch feature/login        # tạo branch (chưa chuyển sang)
git checkout feature/login      # chuyển branch (cách cũ)
git switch feature/login        # chuyển branch (cách mới, rõ nghĩa hơn)

git checkout -b feature/login   # tạo và chuyển (cũ)
git switch -c feature/login     # tạo và chuyển (mới)

git branch -m old new           # đổi tên
git branch -d feature/login     # xóa (chỉ khi đã merge)
git branch -D feature/login     # xóa cưỡng bức
git push origin --delete feature/login   # xóa branch trên remote
```

Lưu ý: trước khi chuyển branch nên commit hoặc stash thay đổi đang làm dở.

### 12. Merge branch

```bash
git switch main
git merge feature/login
```

**Hai kiểu merge**

1. **Fast-forward**: khi `main` chưa có commit mới nào kể từ lúc tách nhánh, Git chỉ việc dời con trỏ `main` lên phía trước, không tạo commit mới, lịch sử thẳng hàng.
   ```
   A ← B ← C(main)        →   A ← B ← C ← D ← E (main, feature)
              ↖ D ← E (feature)
   ```
2. **3-way merge**: khi cả hai nhánh đều có commit mới, Git tạo một **merge commit** có hai commit cha.
   ```
   A ← B ← C ← F (main, merge commit)
        ↖     ↗
         D ← E (feature)
   ```
   Có thể ép luôn tạo merge commit bằng `git merge --no-ff feature`.

**Xử lý xung đột (conflict)**

Conflict xảy ra khi hai nhánh sửa **cùng vùng của cùng một file**. Git dừng merge và đánh dấu trong file:
```
<<<<<<< HEAD
code của nhánh hiện tại (main)
=======
code của nhánh được merge (feature)
>>>>>>> feature/login
```

**Các bước xử lý**
1. `git status`: xem file nào đang `both modified`.
2. Mở file, chọn giữ bản nào, hoặc kết hợp cả hai, rồi **xóa các dòng đánh dấu** `<<<<<<<`, `=======`, `>>>>>>>`.
3. `git add file.txt`: báo đã giải quyết.
4. `git commit`: hoàn tất merge (hoặc `git merge --continue`).
5. Muốn hủy giữa chừng: `git merge --abort`.

Ngoài ra có thể dùng công cụ trực quan: VS Code (CodeLens "Accept Current/Incoming/Both"), `git mergetool`.

### 13. Chiến lược branching phổ biến

**a) Git Flow** (Vincent Driessen, 2010): phù hợp dự án có chu kỳ release rõ ràng.

| Branch | Vai trò |
|---|---|
| `main` (hoặc `master`) | Code production, mỗi commit là một bản phát hành |
| `develop` | Nhánh tích hợp tính năng, chuẩn bị cho release |
| `feature/*` | Phát triển tính năng mới, tách từ `develop` rồi merge lại `develop` |
| `release/*` | Chuẩn bị phát hành, chỉ sửa lỗi nhỏ, rồi merge vào `main` và `develop` |
| `hotfix/*` | Sửa lỗi khẩn cấp ở production, tách từ `main` rồi merge vào cả `main` và `develop` |

- Ưu điểm: có quy trình chặt chẽ, quản lý nhiều phiên bản song song.
- Nhược điểm: phức tạp, nhiều nhánh, không hợp với continuous deployment.

**b) GitHub Flow**: đơn giản, hợp với web app và deploy liên tục.
1. `main` luôn ở trạng thái có thể deploy.
2. Tạo branch mô tả rõ từ `main` (ví dụ `add-search-bar`).
3. Commit và push thường xuyên.
4. Mở **Pull Request**, review, chạy CI.
5. Merge vào `main` rồi deploy ngay.

**c) Trunk-Based Development**: mọi người commit vào `main` (trunk) thường xuyên, branch sống rất ngắn (vài giờ đến 1-2 ngày), kết hợp feature flag. Phổ biến ở các công ty có CI/CD mạnh.

| | Git Flow | GitHub Flow | Trunk-Based |
|---|---|---|---|
| Độ phức tạp | Cao | Thấp | Thấp |
| Tần suất release | Định kỳ | Liên tục | Liên tục |
| Phù hợp | Sản phẩm có version (phần mềm đóng gói, mobile) | Web/SaaS, nhóm vừa và nhỏ | Nhóm lớn, CI/CD trưởng thành |

---

## PHẦN 5: REMOTE REPOSITORY (GITHUB/GITLAB)

### 14. Thêm remote và đẩy code

**Remote** là phiên bản của repo được lưu trên server. Tên mặc định là `origin`.

```bash
git remote -v                                    # xem danh sách remote
git remote add origin git@github.com:user/repo.git
git remote set-url origin <url-mới>              # đổi URL
git remote remove origin

git push -u origin main    # đẩy lần đầu, -u thiết lập upstream để sau chỉ cần "git push"
git push                   # đẩy các commit mới
git push origin feature/login

git fetch origin           # tải dữ liệu mới về, KHÔNG sửa working dir
git pull                   # = fetch + merge
git pull --rebase          # = fetch + rebase (lịch sử gọn hơn)
```

**Phân biệt `fetch` và `pull`**

| | `git fetch` | `git pull` |
|---|---|---|
| Hành động | Chỉ tải commit mới về (cập nhật `origin/main`) | Tải về **và** gộp vào branch hiện tại |
| Rủi ro | Không thay đổi code đang làm | Có thể gây conflict ngay |
| Dùng khi | Muốn xem trước người khác đã đổi gì | Muốn cập nhật nhanh |

Thói quen tốt: `git fetch` trước, xem bằng `git log HEAD..origin/main` hoặc `git diff origin/main`, rồi mới merge/rebase.

**Push bị từ chối** (`rejected - non-fast-forward`) nghĩa là remote có commit mà local chưa có. Cần `pull` trước rồi push lại. Chỉ dùng `--force` khi hiểu rõ hậu quả, và ưu tiên `--force-with-lease` an toàn hơn.

### 15. Làm việc nhóm: fork, clone, pull request

**Mô hình cộng tác phổ biến trên GitHub**

*Mô hình Fork & Pull Request* (dùng cho mã nguồn mở, khi không có quyền ghi vào repo gốc):
1. **Fork**: tạo bản sao repo gốc về tài khoản của mình trên GitHub.
2. **Clone** bản fork về máy:
   ```bash
   git clone git@github.com:ban/repo.git
   ```
3. Thêm repo gốc làm remote `upstream` để đồng bộ:
   ```bash
   git remote add upstream git@github.com:goc/repo.git
   ```
4. Tạo branch riêng, code, commit:
   ```bash
   git switch -c fix/typo-readme
   ```
5. Push lên fork của mình:
   ```bash
   git push -u origin fix/typo-readme
   ```
6. Trên GitHub, tạo **Pull Request (PR)** từ branch của mình sang `main` của repo gốc.
7. Maintainer review, bình luận, yêu cầu sửa; push thêm commit lên cùng branch thì PR tự cập nhật.
8. Được chấp thuận thì merge (Merge commit, Squash and merge hoặc Rebase and merge).

*Đồng bộ fork với repo gốc*:
```bash
git fetch upstream
git switch main
git merge upstream/main     # hoặc git rebase upstream/main
git push origin main
```

*Mô hình Shared Repository* (dùng trong công ty, mọi người có quyền ghi): không cần fork, chỉ clone, tạo branch, push branch rồi mở PR.

**Thực hành tốt khi làm việc nhóm**
- Branch bảo vệ (`main`): bắt buộc PR và ít nhất 1 người review, CI phải pass.
- PR nhỏ, mô tả rõ mục đích, liên kết với issue (`Closes #12`).
- Review code mang tính xây dựng.
- Pull/rebase thường xuyên để tránh lệch xa `main`.

### 16. Giải quyết conflict khi làm việc nhóm

**Kịch bản thực hành**: A và B cùng sửa một dòng trong `app.py` trên hai branch khác nhau.

```bash
# Người A: sửa dòng 10 rồi push
git switch -c feature-a
# ... sửa file ...
git commit -am "Change greeting to Hello"
git push -u origin feature-a
# Merge PR của A vào main trước

# Người B: cùng sửa dòng 10 theo cách khác
git switch -c feature-b
git commit -am "Change greeting to Hi"
git push -u origin feature-b
# PR của B báo conflict
```

**Cách B xử lý** (nên làm ở local):
```bash
git switch feature-b
git fetch origin
git merge origin/main        # hoặc: git rebase origin/main
# Git báo: CONFLICT (content): Merge conflict in app.py
git status                   # xem file xung đột
# Mở app.py, sửa, xóa các dấu <<<<<<< ======= >>>>>>>
git add app.py
git commit                   # (nếu rebase: git rebase --continue)
git push                     # PR tự hết conflict
```

**Cách giảm conflict**
- Chia nhỏ task, tránh nhiều người cùng sửa một file lớn.
- Pull/rebase từ `main` thường xuyên.
- Thống nhất code style và formatter để tránh conflict do định dạng.
- Giao tiếp: nói rõ ai đang sửa phần nào.

---

## PHẦN 6: CÔNG CỤ VÀ KỸ NĂNG NÂNG CAO

### 17. Tag và versioning

**Tag** là nhãn cố định gắn vào một commit, thường dùng đánh dấu phiên bản phát hành (khác branch ở chỗ không di chuyển).

```bash
git tag                          # liệt kê tag
git tag v1.0.0                   # lightweight tag (chỉ là con trỏ)
git tag -a v1.0.0 -m "Release 1.0.0"   # annotated tag (có tác giả, ngày, message) - NÊN DÙNG
git tag -a v0.9.0 <commit-id>    # gắn tag vào commit cũ
git show v1.0.0                  # xem chi tiết

git push origin v1.0.0           # đẩy một tag (push thường KHÔNG đẩy tag)
git push origin --tags           # đẩy tất cả tag
git tag -d v1.0.0                # xóa tag local
git push origin --delete v1.0.0  # xóa tag trên remote
git checkout v1.0.0              # xem code ở phiên bản đó (detached HEAD)

git describe                     # mô tả commit hiện tại dựa trên tag gần nhất
git describe --tags
# Ví dụ kết quả: v1.2.0-5-g3a1b2c4
# nghĩa là: cách tag v1.2.0 là 5 commit, commit hiện tại có hash bắt đầu bằng 3a1b2c4
```

**Semantic Versioning (SemVer)**: `MAJOR.MINOR.PATCH`, ví dụ `2.4.1`
- **MAJOR**: thay đổi không tương thích ngược.
- **MINOR**: thêm tính năng, vẫn tương thích.
- **PATCH**: sửa lỗi.

### 18. Stash

**Tình huống**: đang code dở nhưng cần chuyển sang branch khác để sửa gấp, mà chưa muốn commit.

```bash
git stash                         # cất thay đổi (tracked) vào ngăn xếp
git stash push -m "wip: login form"
git stash -u                      # gồm cả file untracked
git stash list                    # xem danh sách stash
git stash show -p stash@{0}       # xem nội dung

git stash pop                     # lấy stash gần nhất ra và xóa khỏi danh sách
git stash apply stash@{1}         # áp dụng nhưng giữ lại stash
git stash drop stash@{0}          # xóa một stash
git stash clear                   # xóa hết
git stash branch new-branch       # tạo branch mới từ stash
```

Lưu ý: stash hoạt động theo kiểu ngăn xếp (LIFO); nên đặt message để dễ nhớ; stash chỉ nằm ở local, không được push.

### 19. Rebase và squash

**Rebase** "ghép lại" các commit của branch hiện tại lên một điểm nền mới, giúp lịch sử **thẳng hàng**.

```
Trước:    A ← B ← C (main)
               ↖ D ← E (feature)

Sau git switch feature; git rebase main:
          A ← B ← C (main)
                   ↖ D' ← E' (feature)   # D', E' là commit MỚI (hash khác)
```
```bash
git switch feature
git rebase main
# Có conflict: sửa file → git add → git rebase --continue
git rebase --abort         # hủy
```

**Merge vs Rebase**

| | Merge | Rebase |
|---|---|---|
| Lịch sử | Giữ nguyên, có merge commit | Thẳng hàng, gọn |
| Bản chất | Không viết lại commit | Tạo commit mới, viết lại lịch sử |
| An toàn | An toàn | Rủi ro nếu rebase branch đã chia sẻ |

**Quy tắc vàng: không rebase các commit đã push và người khác đang dùng chung.**

**Interactive rebase và squash**: gộp, sửa, sắp xếp lại các commit.
```bash
git rebase -i HEAD~4       # chỉnh 4 commit gần nhất
```
Trong editor sẽ hiện danh sách:
```
pick a1b2c3 Add login form
pick d4e5f6 Fix typo
pick 7g8h9i Fix another typo
pick j0k1l2 Add validation
```
Các lệnh thường dùng: `pick` (giữ), `reword` (sửa message), `squash` (gộp vào commit trước, giữ message), `fixup` (gộp và bỏ message), `drop` (xóa), `edit` (dừng lại để sửa). Ví dụ đổi `Fix typo` thành `fixup` để gộp vào commit "Add login form".

Tiện ích: `git commit --fixup <commit>` rồi `git rebase -i --autosquash`.

Dùng khi: dọn dẹp các commit "wip", "fix typo" trước khi mở PR. Trên GitHub cũng có nút **Squash and merge** làm việc tương tự.

### 20. Git alias và log formatting

**Alias** giúp rút gọn lệnh dài:
```bash
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.sw switch
git config --global alias.cm "commit -m"
git config --global alias.unstage "restore --staged"
git config --global alias.last "log -1 HEAD"
git config --global alias.lg "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"
```
Sau đó dùng: `git st`, `git co main`, `git lg`.

**Định dạng log với `--pretty=format`**
```bash
git log --pretty=format:"%h %an %ar %s"
```
| Mã | Ý nghĩa |
|---|---|
| `%h` | Hash rút gọn |
| `%H` | Hash đầy đủ |
| `%an` | Tên tác giả |
| `%ar` | Thời gian tương đối (2 days ago) |
| `%ad` | Ngày tuyệt đối |
| `%s` | Subject của commit |
| `%d` | Tên branch/tag |

Alias cũng có thể sửa trực tiếp trong `~/.gitconfig` ở mục `[alias]`.

### 21. Git reflog và khôi phục commit bị mất

**Reflog** là nhật ký cục bộ ghi lại **mọi lần HEAD di chuyển** (commit, checkout, reset, rebase, merge...). Đây là "lưới an toàn" khi lỡ tay.

```bash
git reflog
# Ví dụ:
# 3a1b2c4 HEAD@{0}: reset: moving to HEAD~2
# 9f8e7d6 HEAD@{1}: commit: Add payment feature
# 5c4b3a2 HEAD@{2}: commit: Add cart
```

**Kịch bản: lỡ `git reset --hard` làm mất commit**
```bash
git reset --hard HEAD~2          # lỡ tay, mất 2 commit
git reflog                       # tìm hash của commit trước khi reset (9f8e7d6)
git reset --hard 9f8e7d6         # quay lại đúng trạng thái đó
# hoặc an toàn hơn, tạo branch tại commit đó:
git branch recovered 9f8e7d6
```

**Khôi phục branch đã xóa nhầm**
```bash
git reflog
git switch -c feature/login <hash>
```

**Lưu ý**
- Reflog chỉ tồn tại **ở local**, không được push.
- Entry mặc định được giữ khoảng 90 ngày (với entry còn tham chiếu được) rồi bị dọn bởi garbage collection.
- Chỉ cứu được những gì **đã từng commit**. Thay đổi chưa commit mà bị `reset --hard` thì thường không lấy lại được.

---

## PHẦN 7: THỰC HÀNH DỰ ÁN THỰC TẾ

### 22. Các tình huống giả lập

**Tình huống 1: Merge conflict**
```bash
mkdir demo && cd demo && git init
echo "Hello" > greeting.txt
git add . && git commit -m "Initial commit"

git switch -c feature-a
echo "Hello World" > greeting.txt
git commit -am "Update greeting A"

git switch main
echo "Hello Git" > greeting.txt
git commit -am "Update greeting main"

git merge feature-a            # → CONFLICT
cat greeting.txt               # thấy các dấu <<<<<<<
# Sửa file thành: Hello Git World
git add greeting.txt
git commit -m "Merge feature-a, resolve conflict"
```

**Tình huống 2: Revert code (đã push lên main)**
Một commit gây lỗi production, cần gỡ nhanh mà không phá lịch sử.
```bash
git log --oneline              # tìm commit lỗi, ví dụ b7c8d9e
git revert b7c8d9e             # tạo commit đảo ngược
git push origin main
```

**Tình huống 3: Rollback phiên bản**
- *Cách an toàn (nhánh dùng chung)*: dùng `git revert` cho từng commit, hoặc `git revert <cũ>..<mới>` cho cả dãy.
- *Cách trên local/nhánh riêng*:
  ```bash
  git reset --hard v1.0.0      # đưa branch về đúng tag v1.0.0
  git push --force-with-lease  # chỉ khi chắc chắn không ai dùng chung
  ```
- *Chỉ cần xem/chạy lại bản cũ*, không đổi lịch sử:
  ```bash
  git switch --detach v1.0.0
  ```

**Tình huống 4: Hotfix khẩn cấp (theo Git Flow)**
```bash
git switch main && git pull
git switch -c hotfix/1.0.1
# sửa lỗi
git commit -am "fix: prevent null pointer on checkout"
git switch main && git merge --no-ff hotfix/1.0.1
git tag -a v1.0.1 -m "Hotfix 1.0.1"
git switch develop && git merge --no-ff hotfix/1.0.1
git push origin main develop --tags
git branch -d hotfix/1.0.1
```

**Tình huống 5: Tạo release**
```bash
git switch develop && git pull
git switch -c release/1.1.0
# nâng version, cập nhật CHANGELOG, sửa lỗi nhỏ
git switch main && git merge --no-ff release/1.1.0
git tag -a v1.1.0 -m "Release 1.1.0"
git switch develop && git merge --no-ff release/1.1.0
git push origin main develop --tags
```
Trên GitHub có thể tạo **Release** từ tag, kèm release notes và file đính kèm.

**Tình huống 6: Khi nào dùng `fetch`, `pull`, `push`, `rebase`?**

| Tình huống | Lệnh nên dùng |
|---|---|
| Sáng đi làm, muốn cập nhật code mới nhất của nhóm, nhánh local sạch | `git pull` (hoặc `git pull --rebase`) |
| Muốn xem đồng nghiệp đã làm gì **trước khi** quyết định merge | `git fetch` rồi `git log HEAD..origin/main` |
| Đang làm dở, chưa commit, cần cập nhật | `git stash` → `git pull` → `git stash pop` |
| Push bị từ chối vì remote có commit mới | `git pull --rebase` rồi `git push` |
| Branch feature bị lệch xa `main`, muốn lịch sử gọn | `git fetch` rồi `git rebase origin/main` |
| Hoàn thành tính năng, đẩy lên để tạo PR | `git push -u origin feature/x` |
| Đồng bộ fork với repo gốc | `git fetch upstream` rồi `git merge upstream/main` |
| Muốn cập nhật danh sách branch/tag remote, xóa tham chiếu cũ | `git fetch --prune` |

**Quy trình làm việc hằng ngày (tham khảo)**
1. `git switch main && git pull`: cập nhật.
2. `git switch -c feature/ten-tinh-nang`: tạo branch.
3. Code, `git add -p`, `git commit` theo từng bước nhỏ.
4. `git fetch` và `git rebase origin/main` (hoặc merge) để đồng bộ.
5. `git push -u origin feature/ten-tinh-nang`.
6. Mở PR, review, sửa theo góp ý, merge.
7. Xóa branch đã xong; `git switch main && git pull`.

---

## TỔNG KẾT: BẢNG LỆNH NHANH

| Mục đích | Lệnh |
|---|---|
| Khởi tạo / clone | `git init`, `git clone` |
| Xem trạng thái / khác biệt | `git status`, `git diff` |
| Lưu thay đổi | `git add`, `git commit` |
| Xem lịch sử | `git log`, `git show`, `git blame` |
| Hoàn tác | `git restore`, `git reset`, `git revert` |
| Nhánh | `git branch`, `git switch`, `git merge`, `git rebase` |
| Remote | `git remote`, `git fetch`, `git pull`, `git push` |
| Tạm cất | `git stash` |
| Đánh dấu phiên bản | `git tag`, `git describe` |
| Cứu hộ | `git reflog` |

**Ba điều cần nhớ nhất**
1. Commit nhỏ, có ý nghĩa; message rõ ràng.
2. Không viết lại lịch sử đã chia sẻ (không `reset`/`rebase`/`force push` trên nhánh chung).
3. Khi lỡ tay, đừng hoảng: `git reflog` thường cứu được.
