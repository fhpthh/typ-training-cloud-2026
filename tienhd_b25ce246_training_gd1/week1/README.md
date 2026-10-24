# Báo cáo Tuần 1 — Tìm hiểu về Git


## Phần 1: Giới thiệu tổng quan về Git

### 1.1 Git là gì?

**Git** là một hệ thống quản lý phiên bản phân tán (Distributed Version Control System — DVCS), dùng để theo dõi lịch sử thay đổi của mã nguồn và cho phép nhiều người làm việc song song trên cùng một dự án.

- **Lịch sử:** Git được **Linus Torvalds** tạo ra vào **năm 2005** để quản lý mã nguồn nhân Linux, sau khi BitKeeper (công cụ họ dùng trước đó) ngừng cho phép sử dụng miễn phí.
- **Lý do ra đời:** cần một công cụ **nhanh, phân tán, miễn phí, xử lý dự án lớn**, mỗi lập trình viên có toàn bộ lịch sử trong máy nên có thể làm việc offline.

### 1.2 So sánh Git với các VCS khác

| Tiêu chí | Git (phân tán) | SVN (tập trung) | Mercurial (phân tán) |
| --- | --- | --- | --- |
| Mô hình | Phân tán, mỗi máy có repo đầy đủ | Tập trung, phụ thuộc server | Phân tán |
| Làm việc offline | Có (commit, log, branch) | Không (cần server) | Có |
| Tốc độ | Rất nhanh (xử lý cục bộ) | Chậm hơn khi mạng yếu | Nhanh |
| Branching | Rất mạnh, rẻ, khuyến khích dùng | Nặng, tốn kém | Mạnh |
| Phổ biến hiện nay | Cao nhất | Đang giảm | Thấp hơn Git |

### 1.3 Khác biệt giữa Git và GitHub/GitLab/Bitbucket

- **Git** là **công cụ** version control chạy trên máy, không cần Internet.
- **GitHub / GitLab / Bitbucket** là **dịch vụ lưu trữ Git repository trực tuyến**, cung cấp thêm giao diện web, pull request, issue, CI/CD, phân quyền...

> Git là công cụ, còn GitHub là nơi lưu trữ — có thể dùng Git mà không cần GitHub, nhưng không thể dùng GitHub mà không có Git.

### 1.4 Cài đặt & cấu hình ban đầu

```bash
# Kiểm tra phiên bản
git --version

# Cấu hình danh tính (bắt buộc trước khi commit)
git config --global user.name "DUC_TIEN"
git config --global user.email "TienHD.B25CE246@stu.ptit.edu.vn"

# Xem cấu hình đã đặt
git config --global --list

# Tạo SSH key (Ed25519) và kiểm tra kết nối GitHub
ssh-keygen -t ed25519 -C "TienHD.B25CE246@stu.ptit.edu.vn"
ssh -T git@github.com   # Kết quả: "Hi <user>! You've successfully authenticated..."
```
---

## Phần 2: Làm việc với repository

### 2.1 `git init` vs `git clone`

| Lệnh | Mục đích |
| --- | --- |
| `git init` | Khởi tạo một repository **mới, rỗng** ngay tại thư mục hiện tại (tạo thư mục `.git`). |
| `git clone <url>` | **Sao chép** một repository đã có từ xa (kèm toàn bộ lịch sử) về máy. |

### 2.2 Cấu trúc thư mục `.git`

Thư mục `.git/` là "bộ não" của repository, gồm các thành phần chính:

- `HEAD` — trỏ tới nhánh hiện tại đang đứng.
- `config` — cấu hình riêng của repo (remote, branch tracking...).
- `objects/` — nơi lưu toàn bộ dữ liệu (blob, tree, commit) dưới dạng nén.
- `refs/` — chứa con trỏ tới các nhánh (`refs/heads`), tag (`refs/tags`), remote (`refs/remotes`).
- `index` — vùng tạm (staging area).

### 2.3 Trạng thái file trong Git

- **untracked**: file mới, Git chưa quản lý.
- **staged**: đã `git add`, sẵn sàng để commit (nằm trong staging area).
- **committed**: đã được lưu vào lịch sử.
- **modified**: file đã tracked nhưng vừa bị chỉnh sửa, chưa add.

### 2.4 `git status` và `git diff`

Thực hành khởi tạo repo và kiểm tra trạng thái (minh chứng thật):

```text
$ git init -b main
Initialized empty Git repository in /tmp/opencode/git-lab/.git/
On branch main
No commits yet
nothing to commit (create/copy files and use "git add" to track)

$ printf '# Demo Git\nNoi dung ban dau\n' > hello.txt
$ git status --short
?? hello.txt          # untracked

$ git add hello.txt
$ git status --short
A  hello.txt          # staged
```

Khi sửa file đã commit, `git diff` hiển thị thay đổi chưa staged:

```text
$ git status --short
 M hello.txt

$ git diff
diff --git a/hello.txt b/hello.txt
index 427c57b..fa9e6cf 100644
--- a/hello.txt
+++ b/hello.txt
@@ -1,2 +1,3 @@
 # Demo Git
 Noi dung ban dau
+Noi dung sua lan 1
```

### 2.5 `git add`, `git commit` và cách viết commit message tốt

```bash
git add <file>          # stage 1 file
git add .               # stage toàn bộ thay đổi
git commit -m "message" # commit
git commit -am "message" # add các file đã tracked + commit
```

**Quy tắc viết commit message tốt (Conventional Commits):**

- Dòng đầu ngắn gọn (≤ 50 ký tự), ở thể mệnh lệnh: `feat:`, `fix:`, `docs:`, `refactor:`, `chore:`...
- Không viết "update", "fix bug" chung chung.
- Ví dụ tốt: `feat: them chuc nang dang nhap`, `fix: sua loi null khi lay user`.
- Ví dụ xấu: `update`, `abc`, `sua lan 2`.

### 2.6 Cơ chế bên trong Git: Blob – Tree – Commit

Git lưu dữ liệu như một **content-addressable filesystem**: mỗi object được định danh bằng **hash SHA-1 của chính nội dung** (đổi nội dung → hash đổi). Git không lưu file theo tên, mà lưu 3 loại object rời rạc rồi nối lại:

| Object | Chứa gì |
| --- | --- |
| **Blob** | Nội dung (bytes) của 1 file — **không** chứa tên file, thời gian hay quyền |
| **Tree** | Danh sách entry `mode + type + hash + tên`; trỏ tới blob (file) hoặc tree con (thư mục) |
| **Commit** | Metadata (author, committer, thời gian, message) + trỏ tới **1 tree gốc** + **(các) commit cha** |

```text
Commit            # snapshot tại 1 thời điểm
  │
  ▼
Tree              # tree gốc = toàn bộ dự án lúc commit
 /  |  \
Blob Blob Tree    # file (blob) và thư mục con (tree)
          │
          ▼
         Blob
```

Commit chỉ giữ **1 con trỏ tree gốc**; từ đó Git đi xuống đệ quy để dựng lại **toàn bộ cây thư mục** → Git lưu **snapshot** chứ không lưu diff. Nhờ cùng nội dung cho cùng hash, các blob/tree không đổi được **tái sử dụng**, nên dung lượng chỉ tăng ở phần thực sự thay đổi.

---

## Phần 3: Làm việc với lịch sử và phiên bản

### 3.1 Xem lịch sử commit

```bash
git log                     # đầy đủ
git log --oneline            # gọn 1 dòng/commit
git log --oneline --graph --all  # dạng đồ thị các nhánh
git log --stat               # kèm thống kê file thay đổi
git show <commit_id>         # chi tiết 1 commit
git blame <file>             # ai sửa từng dòng, commit nào
```

Ví dụ:

```text
$ git log --oneline
b66df44 feat: them file hello.txt
```

### 3.2 Commit ID (SHA-1 hash)

Mỗi commit được định danh bằng một **mã băm SHA-1 dài 40 ký tự** (ví dụ `b66df44...`), được tính từ nội dung commit, thông tin tác giả, thời gian và commit cha. Nhờ đó đảm bảo tính toàn vẹn và bất biến của lịch sử.

### 3.3 Undo / Revert / Reset thay đổi

| Lệnh | Tác dụng | Vùng ảnh hưởng |
| --- | --- | --- |
| `git restore <file>` | Bỏ thay đổi ở working directory | Working dir |
| `git restore --staged <file>` | Bỏ file khỏi staging | Staging |
| `git reset --soft HEAD~1` | Bỏ commit, giữ thay đổi ở staging | History (giữ nội dung) |
| `git reset --mixed HEAD~1` | Bỏ commit, đưa thay đổi về working (mặc định) | History |
| `git reset --hard HEAD~1` | Bỏ commit **và xóa** thay đổi | History + file |
| `git revert <commit>` | Tạo commit mới **đảo ngược** commit cũ | An toàn cho lịch sử đã push |


### 3.4 Khi nào dùng `revert` thay vì `reset`?

- Dùng **`revert`** khi commit **đã push** lên remote và người khác có thể đã kéo về → tạo commit đảo ngược để không phá lịch sử chung.
- Dùng **`reset`** khi commit **chỉ ở máy local**, chưa chia sẻ → có thể xóa/viết lại lịch sử cho gọn.
- Quy tắc an toàn: **không bao giờ `reset --hard` trên nhánh đã chia sẻ**.

### 3.5 Làm việc với `.gitignore`

`.gitignore` liệt kê các file/thư mục Git **bỏ qua**, không theo dõi.

**Cú pháp phổ biến:**

```gitignore
node_modules/     # bỏ qua cả thư mục
build/            # bỏ qua thư mục build
*.log             # mọi file .log
.env              # file biến môi trường (bảo mật)
!important.log    # ngoại lệ: vẫn theo dõi file này
```

## Phần 4: Nhánh (Branching) & hợp nhất (Merging)

### 4.1 Branch là gì và tại sao cần branch?

**Branch (nhánh)** là một dòng phát triển độc lập, cho phép tách ra để phát triển tính năng/sửa lỗi mà không ảnh hưởng nhánh chính. Branch trong Git rất nhẹ vì chỉ là con trỏ tới một commit.

### 4.2 Tạo và chuyển nhánh

```bash
git branch                 # liệt kê nhánh
git branch <ten>           # tạo nhánh mới
git switch <ten>           # chuyển nhánh (cách mới)
git switch -c <ten>        # tạo + chuyển nhánh
git checkout <ten>         # cách cũ, tương đương switch
git branch -d <ten>        # xóa nhánh (đã merge)
```

### 4.3 Merge branch và xử lý conflict

**Merge nhanh (fast-forward)** — nhánh main chưa có commit mới:

```text
$ git switch main
$ git merge feature/login
Updating 13ae36c..1cc2b6b
Fast-forward
 login.txt | 1 +
```

**Merge conflict** — xảy ra khi hai nhánh sửa **cùng một dòng** của cùng file. Em chủ động tạo tình huống này: sửa `hello.txt` ở cả `feature/conflict` và `main`:

```text
$ git merge feature/conflict
Auto-merging hello.txt
CONFLICT (content): Merge conflict in hello.txt
Automatic merge failed; fix conflicts and then commit the result.
```

Nội dung file bị conflict:

```text
# Demo Git
Noi dung ban dau
<<<<<<< HEAD
Nhanh main
=======
Nhanh conflict
>>>>>>> feature/conflict
```

**Cách xử lý:**

1. Mở file, chọn/ghép nội dung đúng, **xóa các dấu** `<<<<<<<`, `=======`, `>>>>>>>`.
2. `git add <file>` để đánh dấu đã giải quyết.
3. `git commit` để hoàn tất merge.

```bash
# Sau khi sửa file
git add hello.txt
git commit -m "merge: giai quyet conflict hello.txt"
```

```text
$ git log --oneline --graph
*   edd8092 merge: giai quyet conflict hello.txt
|\
| * 8a02e4d feat: sua theo nhanh conflict
* | d8fdf77 feat: sua theo main
|/
* 1cc2b6b feat: trang login
* 13ae36c chore: them .gitignore
* b66df44 feat: them file hello.txt
```

### 4.4 Chiến lược branching phổ biến

- **Git Flow:** `main` (production) ← `develop` ← `feature/*`; `release/*` để chuẩn bị phát hành; `hotfix/*` để sửa gấp. Phù hợp dự án có chu kỳ release rõ ràng.
- **GitHub Flow:** đơn giản hơn — chỉ `main` + `feature/*`, mỗi tính năng tạo nhánh, mở pull request rồi merge vào `main`. Phù hợp triển khai liên tục (CI/CD).

---

## Phần 5: Remote repository (GitHub/GitLab)

### 5.1 Thêm remote và đẩy code

```bash
git remote add origin <url>   # gắn repo từ xa
git remote -v                 # xem danh sách remote
git fetch origin              # tải thay đổi về nhưng KHÔNG gộp
git pull origin main          # fetch + merge vào nhánh hiện tại
git push origin main          # đẩy commit lên remote
git push -u origin <branch>   # đẩy và gắn tracking
```

**Phân biệt `fetch` và `pull`:** `fetch` chỉ tải về và cập nhật `origin/*` để xem trước; `pull` = `fetch` + `merge` (tự động gộp vào nhánh hiện tại). Muốn an toàn, xem `fetch` + `git diff` trước rồi mới `merge`/`pull`.

### 5.2 Làm việc nhóm: fork, clone, pull request

Quy trình chuẩn:

1. **Fork** repo gốc về tài khoản cá nhân.
2. **Clone** bản fork về máy: `git clone <fork-url>`.
3. Tạo nhánh cho tính năng: `git switch -c week1-git`.
4. Thêm/sửa file, `git add`, `git commit`.
5. `git push -u origin week1-git`.
6. Mở **Pull Request** từ nhánh trên fork về repo gốc để review/merge.

### 5.3 Giải quyết conflict khi làm việc nhóm

- Tình huống conflict khi `git pull`/`git merge` từ remote cũng xử lý giống mục 4.3.
- Cách giảm conflict: thường xuyên `pull`/`fetch`, chia nhỏ commit, mỗi người làm branch riêng, thống nhất quy ước format code.
- Nếu conflict phức tạp, có thể dùng `git merge --abort` để hủy và làm lại.

---

## Phần 6: Công cụ & kỹ năng nâng cao

### 6.1 Tag và Versioning

- **Tag là gì?**
  - Tag là một con trỏ trỏ tới commit cụ thể, đại diện cho một phiên bản (release) của dự án.
- **Cách tạo tag:**
  - `git tag <tag-name>`: Tạo tag nhẹ (lightweight tag).
  - `git tag -a <tag-name> -m "<message>"`: Tạo tag có chú thích (annotated tag) — khuyến nghị.
- **Cách xem tag:**
  - `git tag`: Xem danh sách tất cả các tag.
  - `git show <tag-name>`: Xem thông tin chi tiết về tag.
  - `git describe --tags`: Mô tả vị trí commit so với tag gần nhất.
- **Cách đẩy tag lên remote:**
  - `git push origin <tag-name>`: Đẩy một tag cụ thể.
  - `git push origin --tags`: Đẩy tất cả các tag.


### 6.2 Stash

- **Stash là gì?**
  - Stash là nơi để lưu tạm các thay đổi chưa commit.
  - Mục đích chính: chuyển sang làm việc khác mà không cần phải commit code đang làm dở.
- **Lưu thay đổi vào stash:**
  - `git stash`: Lưu tất cả thay đổi chưa commit.
  - `git stash save "<stash-message>"`: Lưu thay đổi kèm message.
- **Xem danh sách stash:**
  - `git stash list`: Xem danh sách tất cả các stash.
- **Khôi phục thay đổi từ stash:**
  - `git stash pop`: Khôi phục thay đổi và xóa stash.
  - `git stash apply`: Khôi phục thay đổi nhưng giữ lại stash.
- **Xóa stash:**
  - `git stash drop`: Xóa stash gần nhất.
  - `git stash clear`: Xóa tất cả các stash.

### 6.3 Rebase và Squash

- **Rebase là gì?**
  - Rebase là quá trình chuyển các commit của một branch sang một base branch khác.
  - Rebase giúp làm phẳng lịch sử commit và loại bỏ các merge commit không cần thiết.
  - **Cách dùng:**
    ```bash
    # Đang ở branch feature/new-feature, rebase lên branch develop
    git switch feature/new-feature
    git rebase develop
    ```
- **Squash là gì?**
  - Squash là quá trình gộp nhiều commit thành một commit duy nhất.
  - Mục đích chính: làm sạch lịch sử commit và gộp các thay đổi liên quan vào một commit.
  - **Cách dùng:**
    ```bash
    # Gộp 5 commit gần nhất trên branch feature/new-feature
    git switch feature/new-feature
    git rebase -i HEAD~5
    ```
- **Không rebase nhánh đã chia sẻ** với người khác (vì rebase viết lại hash commit).

### 6.4 Git Alias và Log Formatting

- **Git Alias là gì?**
  - Git Alias là bí danh cho các lệnh Git, giúp tiết kiệm thời gian gõ lệnh.
- **Cách tạo alias:**
  - Cú pháp: `git config --global alias.<alias-name> "<git-command>"`
  - Ví dụ:
    ```bash
    git config --global alias.co "checkout"
    git config --global alias.st "status"
    git config --global alias.cm "commit -m"
    git config --global alias.p "push origin"
    git config --global alias.pl "pull origin"
    git config --global alias.lg "log --oneline --graph --decorate"
    ```
- **Log Formatting là gì?**
  - Log Formatting là cách định dạng đầu ra của lệnh `git log` (ví dụ `--oneline`, `--graph`, `--pretty=format:"..."`).


### 6.5 Git Reflog và khôi phục commit bị mất

- **Reflog là gì?**
  - Reflog là viết tắt của "reference logs", là cơ chế ghi lại tất cả các di chuyển của HEAD và các tham chiếu khác trong repository.
  - Reflog chỉ lưu trữ cục bộ trên máy và sẽ bị mất khi xóa repository.
- **Cách xem reflog:**
  - `git reflog`: Xem danh sách tất cả các reflog.
- **Cách khôi phục commit bị mất:**
  - `git reset --hard <commit_hash>`: Khôi phục commit và xóa tất cả thay đổi sau commit đó.
  - `git reset --soft <commit_hash>`: Khôi phục commit nhưng giữ lại thay đổi.

---

## Phần 7: Thực hành dự án thực tế

Phần này mô phỏng lại toàn bộ tình huống làm việc nhóm trên một **repo demo** đặt tại `~/Desktop/TYP_CLOUD_TRAINING/git-lab`, với một **remote giả** `git-lab-remote.git` (bare repo) thay cho GitHub. Toàn bộ lệnh và output dưới đây được chạy thật trên máy và dán nguyên văn.

### 7.0. Chuẩn bị repo demo và remote


```bash
git config --global init.defaultBranch main

cd ~/Desktop/TYP_CLOUD_TRAINING
git init --bare git-lab-remote.git                 # remote giả

mkdir git-lab && cd git-lab
git init
git remote add origin ../git-lab-remote.git

printf 'Dong 1\nDong 2\nDong 3\n' > hello.txt
git add hello.txt
git commit -m "feat: khoi tao hello.txt"
git push -u origin main
```

**File/thư mục sau bước này:**

```text
TYP_CLOUD_TRAINING/
├── git-lab-remote.git/     # remote giả (bare)
└── git-lab/                # repo làm việc
    ├── .git/               
    └── hello.txt         
```

---

### Tình huống 1: Merge conflict khi 2 người sửa cùng file

- **Kịch bản:** một nhánh và `main` cùng sửa dòng số 2 của `hello.txt` → xảy ra xung đột.
- **Mục đích:** biết cách nhận diện và xử lý conflict.

**Lệnh đã gõ — tạo conflict:**

```bash
git switch -c feature/change
printf 'Dong 1\nDong 2 SUA BOI FEATURE\nDong 3\n' > hello.txt
git commit -am "feat: sua dong 2 theo feature"

git switch main
printf 'Dong 1\nDong 2 SUA BOI MAIN\nDong 3\n' > hello.txt
git commit -am "feat: sua dong 2 theo main"

git merge feature/change          # -> CONFLICT
```

**Kết quả:**

```text
hello.txt
Dong 1
<<<<<<< HEAD
Dong 2 SUA BOI MAIN
=======
Dong 2 SUA BOI FEATURE
>>>>>>> feature/change
Dong 3
```

**Giải quyết conflict:**
  - Xóa marker và fix, sau đó: 
```bash
git add hello.txt
git commit -m "merge: giai quyet conflict hello.txt"
```

---

### Tình huống 2: Revert một commit đã push bị lỗi

- **Kịch bản:** lỡ push một commit chứa code lỗi lên remote → cần gỡ bỏ nhưng không phá lịch sử chung.
- **Mục đích:** dùng `git revert` thay vì `reset` cho commit đã chia sẻ.

**Lệnh đã gõ:**

```bash
printf 'DONG CODE LOI\n' >> hello.txt
git commit -am "feat: them tinh nang loi"
git push                          

git revert --no-edit HEAD         
git log --oneline -3
git push
```

**Kết quả:**

```text
$ git commit -am "feat: them tinh nang loi"
[main 38432d2] feat: them tinh nang loi
 1 file changed, 1 insertion(+)

$ git push
To ../git-lab-remote.git
   75628a9..38432d2  main -> main

$ git revert --no-edit HEAD
[main 958c1ac] Revert "feat: them tinh nang loi"
 Date: Tue Oct 6 23:59:57 2026 +0700
 1 file changed, 1 deletion(-)

$ git log --oneline -3
958c1ac Revert "feat: them tinh nang loi"
38432d2 feat: them tinh nang loi
23ffc71 merge: giai quyet conflict hello.txt

$ git push
To ../git-lab-remote.git
   38432d2..958c1ac  main -> main
```

**Kết quả:** dòng `DONG CODE LOI` đã bị gỡ; lịch sử vẫn giữ cả commit lỗi lẫn commit revert.

---

### Tình huống 3: Rollback về phiên bản cũ

- **Kịch bản:** có commit mới bị lỗi, cần quay về phiên bản ổn định trước đó (tình huống local).
- **Mục đích:** dùng `git reset --hard` để quay lui.

**Lệnh đã gõ:**

```bash
printf 'tinh nang A\n' > a.txt && git add a.txt && git commit -m "feat: tinh nang A"
printf 'tinh nang B loi\n' > b.txt && git add b.txt && git commit -m "feat: tinh nang B"

git reset --hard HEAD~1

```

**Kết quả:** commit `feat: tinh nang B` bị loại bỏ, file `b.txt` biến mất.

---

### Tình huống 4: Tạo release bằng tag

- **Kịch bản:** đánh dấu phiên bản phát hành 1.0.0 cho dự án.
- **Mục đích:** dùng annotated tag để tạo mốc release.

**Lệnh đã gõ:**

```bash
git tag -a v1.0.0 -m "Release phien ban 1.0.0"
git tag
git show v1.0.0 --stat
git push origin v1.0.0
git describe --tags
```

**Kết quả:**

```text
$ git tag
v1.0.0

$ git show v1.0.0 --stat
tag v1.0.0
Tagger: DUC_TIEN <TienHD.B25CE246@stu.ptit.edu.vn>
Date:   Wed Oct 7 00:00:03 2026 +0700

Release phien ban 1.0.0

commit bf9907013168baf9d4a7b950731e5c6c6ef8bfa6
Author: DUC_TIEN <TienHD.B25CE246@stu.ptit.edu.vn>
Date:   Tue Oct 6 23:59:57 2026 +0700

    feat: tinh nang A

 a.txt | 1 +
 1 file changed, 1 insertion(+)

$ git push origin v1.0.0
To ../git-lab-remote.git
 * [new tag]         v1.0.0 -> v1.0.0

$ git describe --tags
v1.0.0
```

**Kết quả:** có tag v1.0.0 ở cả local lẫn remote.

---

### Tình huống 5: Khi nào dùng fetch vs pull?

- **Kịch bản:** một "dev khác" clone repo, thêm nội dung, push lên remote. 
- **Mục đích:** hiểu rõ khác biệt giữa fetch và pull.

**Lệnh đã gõ — "dev khác" đóng góp:**

```bash
cd ~/Desktop/TYP_CLOUD_TRAINING
git clone git-lab-remote.git git-lab-other
cd git-lab-other

printf 'dong gop tu dev khac\n' >> hello.txt
git add hello.txt
git commit -m "feat: dong gop tu dev khac"
git push origin main
```

**Kết quả:**

```text
$ git branch -vv
* main 958c1ac [origin/main] Revert "feat: them tinh nang loi"

$ git commit -m "feat: dong gop tu dev khac"
[main 2d88c00] feat: dong gop tu dev khac
 1 file changed, 1 insertion(+)

$ git push origin main
To /home/tien/Desktop/TYP_CLOUD_TRAINING/git-lab-remote.git
   958c1ac..2d88c00  main -> main
```

**Lệnh đã gõ — so sánh fetch vs pull ở repo chính:**

```bash
cd ~/Desktop/TYP_CLOUD_TRAINING/git-lab
git fetch
git log --oneline main..origin/main 

git pull
git log --oneline -3
```

**Kết quả:**

```text
$ git fetch
From ../git-lab-remote
   958c1ac..2d88c00  main       -> origin/main

$ git log --oneline main..origin/main
2d88c00 feat: dong gop tu dev khac

hello.txt:
Dong 1
Dong 2 SUA BOI MAIN + FEATURE
Dong 3
                          # <- fetch KHONG lam thay doi file

$ git pull
Merge made by the 'ort' strategy.
 hello.txt | 1 +
 1 file changed, 1 insertion(+)

$ git log --oneline -3
82669e6 Merge branch 'main' of ../git-lab-remote
2d88c00 feat: dong gop tu dev khac
bf99070 feat: tinh nang A

hello.txt:
Dong 1
Dong 2 SUA BOI MAIN + FEATURE
Dong 3
dong gop tu dev khac      # <- pull DA gop thay doi
```

**Kết quả:** `fetch` chỉ tải về và cập nhật `origin/main` (working tree không đổi); `pull` = `fetch` + `merge`.

---
