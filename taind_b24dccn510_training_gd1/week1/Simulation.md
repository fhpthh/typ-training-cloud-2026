# Phần 7: Thực hành dự án thực tế

Tài liệu này mô phỏng các tình huống Git thường gặp trong quá trình làm việc nhóm. Các lệnh được thực hiện trong thư mục `lab_simulation_ps`.

## 0. Thiết lập môi trường mô phỏng

```powershell
mkdir lab_simulation_ps
cd lab_simulation_ps
git init -b main
git config user.name "Skyboy12"
git config user.email "skyboy123123.dot@gmail.com"
```

## 1. Tạo và xử lý merge conflict

### Mục tiêu

Tạo hai thay đổi khác nhau trên cùng một file ở hai nhánh, hợp nhất chúng và giải quyết conflict thủ công.

### Thực hiện

Tạo phiên bản ban đầu của `app.py`, sau đó commit:

```powershell
Set-Content app.py
```

Nội dung `app.py`:

```python
def calculate_tax(income):
	# Base implementation
	tax_rate = 0.1
	return income * tax_rate

print("App Initialized")
```

```powershell
git add app.py
git commit -m "feat: initial tax calculation system"
```

Tạo nhánh tính thuế cho người có thu nhập cao:

```powershell
git switch -c feature/high-income
Set-Content app.py
```

Nội dung mới của `app.py` trên nhánh `feature/high-income`:

```python
def calculate_tax(income):
	# Tier 2 tax calculation for high income
	tax_rate = 0.35
	return income * tax_rate

print("App Initialized - High Income Mode")
```

```powershell
git commit -am "feat: update tax rate for high income earners to 35%"
```

Trên `main`, tạo một thay đổi khác cũng trên `app.py`:

```powershell
git switch main
Set-Content app.py
```

Nội dung mới của `app.py` trên nhánh `main`:

```python
def calculate_tax(income):
	# Standard revised tax calculation
	tax_rate = 0.15
	return income * tax_rate

print("App Initialized - Standard Revision")
```

```powershell
git commit -am "feat: update standard tax rate to 15%"
git merge feature/high-income
```

Git báo:

```text
CONFLICT (content): Merge conflict in app.py
Automatic merge failed; fix conflicts and then commit the result.
```

Kiểm tra file để thấy các conflict marker:

```powershell
Get-Content app.py
```

Output của `Get-Content app.py`:

```python
def calculate_tax(income):
<<<<<<< HEAD
	# Standard revised tax calculation
	tax_rate = 0.15
	return income * tax_rate

print("App Initialized - Standard Revision")
=======
	# Tier 2 tax calculation for high income
	tax_rate = 0.35
	return income * tax_rate

print("App Initialized - High Income Mode")
>>>>>>> feature/high-income
```

Mở `app.py`, chọn hoặc kết hợp phần code phù hợp, rồi hoàn tất merge:

```powershell
Set-Content app.py
```

Nội dung sau khi giải quyết conflict:

```python
def calculate_tax(income):
	# Combined logic: tiered progressive tax calculation
	if income > 10000:
		tax_rate = 0.35
	else:
		tax_rate = 0.15
	return income * tax_rate

print("App Initialized - Progressive Tax System")
```

```powershell
git add app.py
git commit -m "fix(merge): resolve tax calculation conflict between main and high-income"
```

Sau khi commit, conflict đã được giải quyết và lịch sử có merge commit.

## 2. Revert một commit lỗi

### Mục tiêu

Hoàn tác một commit đã đưa code lỗi vào nhánh chung mà không xóa lịch sử Git.

### Thực hiện

Tạo một file mô phỏng tính năng lỗi:

```powershell
Add-Content bug_feature.py
```

Delta của `bug_feature.py`:

```diff
+CRITICAL_BUG: System Crashed on Null Pointer!
```

Commit tính năng lỗi:

```powershell
git add bug_feature.py
git commit -m "feat(payment): integrate experimental gateway (HAS CRITICAL BUG)"
git log -1 --oneline
```

Hoàn tác commit gần nhất bằng một commit mới:

```powershell
git revert HEAD --no-edit
git log -2 --oneline
```

`git revert` tạo một commit mới đảo ngược thay đổi của commit lỗi. Đây là lựa chọn an toàn khi commit đã được đẩy lên remote hoặc đang nằm trên nhánh dùng chung.

## 3. Rollback và khôi phục commit bằng reflog

### Mục tiêu

Mô phỏng việc xóa nhầm các commit bằng `reset --hard`, sau đó khôi phục chúng nhờ `git reflog`.

### Thực hiện

Tạo và commit hai tính năng:

```powershell
Set-Content feature_a.txt
```

Nội dung `feature_a.txt`:

```text
Feature A: Analytics
```

```powershell
git add feature_a.txt
git commit -m "feat: implement data analytics"

Set-Content feature_b.txt
```

Nội dung `feature_b.txt`:

```text
Feature B: Webhook
```

```powershell
git add feature_b.txt
git commit -m "feat: implement webhook dispatcher"
```

Lưu lại commit hiện tại trước khi rollback:

```powershell
git rev-parse HEAD
```

Mô phỏng thao tác reset nhầm:

```powershell
git reset --hard HEAD~2
git log -2 --oneline
```

Hai commit vừa tạo không còn xuất hiện trong log hiện tại. Tìm lại vị trí cũ của `HEAD`:

```powershell
git reflog -n 3
```

Khôi phục bằng commit hash lấy từ reflog:

```powershell
git reset --hard <commit-hash-can-khoi-phuc>
git log -2 --oneline
```

`git reflog` lưu lại các vị trí mà `HEAD` từng trỏ tới trên máy cục bộ, nhờ đó có thể cứu các commit bị mất do reset hoặc checkout nhầm.

## 4. Tạo tag và release versioning

### Mục tiêu

Đánh dấu các phiên bản ổn định bằng annotated tag và kiểm tra phiên bản gần nhất.

### Thực hiện

Tạo release đầu tiên:

```powershell
git tag -a v1.0.0 -m "Release v1.0.0: Core taxation logic, stable release"
```

Tạo một bản vá nhỏ, sau đó kiểm tra khoảng cách với tag:

```powershell
Add-Content app.py
```

Delta của `app.py`:

```diff
+# Minor improvement
```

```powershell
git commit -am "fix(core): apply performance patch to tax engine"
git describe --tags
```

Kết quả có dạng:

```text
v1.0.0-1-g<commit-hash>
```

Đánh dấu bản phát hành bản vá và xem danh sách tag:

```powershell
git tag -a v1.0.1 -m "Release v1.0.1: Performance patch"
git tag -n
```

`v1.0.0` là bản phát hành chính đầu tiên, còn `v1.0.1` biểu thị bản vá tương thích với phiên bản trước.

## 5. Phân biệt fetch và pull

### Mục tiêu

Hiểu cách lấy thay đổi từ remote mà chưa tác động vào working tree, sau đó chủ động tích hợp thay đổi.

### Tạo remote mô phỏng và clone của đồng nghiệp

```powershell
git init --bare --initial-branch=main remote_origin.git
git remote add origin remote_origin.git
git push -u origin main --tags
git clone -b main remote_origin.git colleague_workspace
cd colleague_workspace
git config user.name "Colleague Alice"
git config user.email "alice@company.com"
Set-Content updates.txt
```

Nội dung `updates.txt`:

```text
New update from colleague
```

```powershell
git add updates.txt
git commit -m "feat(colleague): add daily activity logging"
git push origin main
cd ..
```

### Dùng `git fetch`

```powershell
git fetch origin
git log HEAD..origin/main --oneline
```

`git fetch` tải commit và cập nhật remote-tracking branch như `origin/main`, nhưng không tự thay đổi branch hiện tại hoặc working tree.

### Tích hợp bằng merge

```powershell
git merge origin/main --no-edit
```

Trong mô phỏng này, thay đổi được tích hợp bằng fast-forward.

### So sánh với `git pull`

```powershell
git pull origin main
```

`git pull` thực hiện `git fetch` rồi tự động tích hợp thay đổi bằng merge hoặc rebase tùy cấu hình. Dùng `fetch` trước giúp kiểm tra commit mới và quyết định cách tích hợp an toàn hơn.

## Tổng kết

- Dùng `git merge` để hợp nhất nhánh và xử lý conflict khi cần.
- Dùng `git revert` để đảo ngược commit đã chia sẻ mà vẫn giữ lịch sử.
- Dùng `git reflog` để tìm lại commit sau khi reset hoặc di chuyển `HEAD` nhầm.
- Dùng annotated tag để đánh dấu các release như `v1.0.0` và `v1.0.1`.
- Dùng `git fetch` để xem thay đổi từ remote trước khi quyết định merge hoặc rebase; dùng `git pull` khi muốn fetch và tích hợp ngay.
