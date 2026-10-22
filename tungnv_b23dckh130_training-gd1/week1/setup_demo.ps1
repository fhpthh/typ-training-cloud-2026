param(
    [switch]$Fresh
)

# ==============================================================================
# SCRIPT KHỞI TẠO MÔI TRƯỜNG THỰC HÀNH / DEMO THUYẾT TRÌNH (GIT TỪ PHẦN 1 ĐẾN 7)
# Tác giả: Mentor & Nguyen Vinh Tung
# ==============================================================================

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DemoBase = Join-Path $ScriptDir "demo-git"
$RemoteDir = Join-Path $DemoBase "remote-server.git"
$WorkspaceDir = Join-Path $DemoBase "cloud-gateway"
$TempSeedDir = Join-Path $DemoBase "temp-seed"

function Safe-SetContent {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Path,
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string]$Value
    )
    process {
        for ($i = 0; $i -lt 10; $i++) {
            try {
                Set-Content -Path $Path -Value $Value -Encoding UTF8 -ErrorAction Stop
                return
            } catch {
                Start-Sleep -Milliseconds 200
            }
        }
        Set-Content -Path $Path -Value $Value -Encoding UTF8
    }
}

Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ">>> DANG DUNG MOI TRUONG DEMO TAI: $DemoBase" -ForegroundColor Yellow
if ($Fresh) {
    Write-Host ">>> Che do: FRESH (Khoi tao trang tu Phan 1 den Phan 5)" -ForegroundColor Green
} else {
    Write-Host ">>> Che do: ADVANCED (San sang cho Phan 6 & Phan 7)" -ForegroundColor Magenta
}
Write-Host "=================================================================" -ForegroundColor Cyan

# 1. Don dep sach se du lieu cu (xu ly thong minh neu thu muc dang bi khoa boi Terminal)
if (Test-Path $DemoBase) {
    Write-Host "[1/6] Don dep du lieu cu..." -ForegroundColor Gray
    
    # Xoa remote-server va temp-seed
    if (Test-Path $RemoteDir) {
        Remove-Item -Recurse -Force $RemoteDir -ErrorAction SilentlyContinue
    }
    if (Test-Path $TempSeedDir) {
        Remove-Item -Recurse -Force $TempSeedDir -ErrorAction SilentlyContinue
    }
    
    # Xoa toan bo ruot ben trong cloud-gateway ke ca file an .git
    if (Test-Path $WorkspaceDir) {
        Get-ChildItem -Path $WorkspaceDir -Force -Recurse | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }
} else {
    New-Item -ItemType Directory -Path $DemoBase | Out-Null
}

# 2. Tao Bare Remote Repository (Gia lap GitHub / GitLab Server cua cong ty)
Write-Host "[2/6] Khoi tao Remote Bare Repository voi nhanh goc main..." -ForegroundColor Gray
git init --bare -b main "$RemoteDir" | Out-Null
git -C "$RemoteDir" symbolic-ref HEAD refs/heads/main

if ($Fresh) {
    if (-not (Test-Path $WorkspaceDir)) {
        New-Item -ItemType Directory -Path $WorkspaceDir | Out-Null
    }
    Write-Host "=================================================================" -ForegroundColor Green
    Write-Host ">>> KHOI TAO MOI TRUONG TRANG (-Fresh) THANH CONG!" -ForegroundColor Green
    Write-Host ">>> Bare Remote san sang tai: week1\demo-git\remote-server.git" -ForegroundColor Cyan
    Write-Host ">>> San sang thuc hanh tu Phan 1 den Phan 5 tai: week1\demo-git\cloud-gateway" -ForegroundColor Yellow
    Write-Host ">>> Xem kich ban huong dan: week1\KICH_BAN_DEMO_CHI_TIET.md" -ForegroundColor Magenta
    Write-Host "=================================================================" -ForegroundColor Green
    return
}

# 3. Su dung repo tam de khoi tao ma nguon ban dau len Remote
Write-Host "[3/6] Khoi tao commit ban dau tren server..." -ForegroundColor Gray
git init -b main "$TempSeedDir" | Out-Null
Set-Location "$TempSeedDir"
git config user.name "Nguyen Vinh Tung"
git config user.email "tungnv@ptit.edu.vn"

# File 1: server.py
@"
# Cloud Gateway Service v1.0
# Core routing and microservices gateway

def handle_request(path, method):
    print(f"Routing {method} request to {path}")
    return {"status": 200, "message": "Success"}

if __name__ == "__main__":
    print("Cloud Gateway is running on port 8080...")
"@ | Safe-SetContent "server.py"

# File 2: config.yaml
@"
app:
  name: cloud-gateway
  port: 8080
  env: production
"@ | Safe-SetContent "config.yaml"

# File 3: README.md
@"
# Cloud Gateway Service
Hệ thống API Gateway lõi phục vụ điều phối tải và xác thực microservices.
"@ | Safe-SetContent "README.md"

git add .
git commit -m "feat: initial core gateway architecture" | Out-Null
git remote add origin "$RemoteDir"
git push -u origin main | Out-Null

# 4. Gia lap Dong nghiep (Teammate) push 1 commit len main cua server
Write-Host "[4/6] Gia lap Dong nghiep cap nhat code va push len Remote..." -ForegroundColor Gray
@"
app:
  name: cloud-gateway
  port: 8080
  env: production
  timeout: 30
  routing_mode: dynamic
"@ | Safe-SetContent "config.yaml"
git commit -am "feat(config): teammate update routing and timeout" | Out-Null
git push origin main | Out-Null

# Xoa thu muc seed tam
Set-Location $ScriptDir
Remove-Item -Recurse -Force $TempSeedDir -ErrorAction SilentlyContinue

# 5. Clone ve may cuc bo (Workspace cua Tung) va thiet lap nhanh feature
Write-Host "[5/6] Thiet lap workspace lam viec tai 'cloud-gateway'..." -ForegroundColor Gray
git clone "$RemoteDir" "$WorkspaceDir" | Out-Null
Set-Location "$WorkspaceDir"
git config user.name "Nguyen Vinh Tung"
git config user.email "tungnv@ptit.edu.vn"

# Re nhanh feature tu commit ban dau cua main
$InitialCommit = (git rev-list --max-parents=0 origin/main)
git checkout -b feature/rate-limiter $InitialCommit | Out-Null

# Commit 1
@"
class TokenBucketLimiter:
    def __init__(self, capacity, refill_rate):
        self.capacity = capacity
        self.refill_rate = refill_rate
"@ | Safe-SetContent "limiter.py"
git add limiter.py
git commit -m "feat(limiter): initialize token bucket structure" | Out-Null

# Commit 2
@"
class TokenBucketLimiter:
    def __init__(self, capacity, refill_rate):
        self.capacity = capacity
        self.refill_rate = refill_rate
        self.redis_pool = "redis://cluster.prod:6379"
"@ | Safe-SetContent "limiter.py"
git commit -am "feat(limiter): add redis connection pool" | Out-Null

# Commit 3 (Rac de squash)
@"
# Fix typo
# self.redis_pool = redis
"@ | Add-Content "limiter.py" -Encoding UTF8
git commit -am "fix: typo in variable name" | Out-Null

# Commit 4 (Rac de squash)
@"
# Temporary debug log
print('Limiter initialized')
"@ | Add-Content "limiter.py" -Encoding UTF8
git commit -am "wip: test debug prints" | Out-Null

# Commit 5: Chinh sua config.yaml gay Conflict ve sau
@"
app:
  name: cloud-gateway
  port: 8080
  env: production
  timeout: 60
  rate_limit_enabled: true
"@ | Safe-SetContent "config.yaml"
git commit -am "feat(config): enable rate limiting config" | Out-Null

# 6. Tao trang thai dang code do dang cho Hoi 1 (Stash)
Write-Host "[6/6] Thiet lap trang thai code do dang cho tinh huong Git Stash..." -ForegroundColor Gray
New-Item -ItemType Directory -Path "config" -Force | Out-Null
@"
REDIS_CLUSTER_SECRET=super_secret_jwt_key_2026
REDIS_MAX_CONNECTIONS=500
"@ | Safe-SetContent "config\redis_secret.env"

@"
# WIP: Dang viet do thuat toan sliding window... (bi loi syntax, chua the commit!)
def sliding_window_incomplete_code(
"@ | Add-Content "limiter.py" -Encoding UTF8

Set-Location $ScriptDir

Write-Host "=================================================================" -ForegroundColor Green
Write-Host ">>> KHOI TAO MOI TRUONG DEMO HOAN TAT 100%!" -ForegroundColor Green
Write-Host ">>> Thu muc thuc hanh: week1\demo-git\cloud-gateway" -ForegroundColor Cyan
Write-Host ">>> Xem file huong dan: week1\KICH_BAN_DEMO_CHI_TIET.md" -ForegroundColor Yellow
Write-Host "=================================================================" -ForegroundColor Green
