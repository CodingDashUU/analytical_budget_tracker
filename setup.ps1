# 1. Download Flutter (Stable channel)
Write-Host "[INFO] Checking if Flutter exists..."
if (-not (Test-Path "flutter")) {
    Write-Host "[INFO] You are currently missing Flutter, cloning the Flutter dependency..." -ForegroundColor Yellow
    git clone https://github.com/flutter/flutter.git -b stable --depth 1
} else {
    Write-Host "[INFO] Flutter directory already exists." -ForegroundColor Green
}

# 2. Add Flutter to the PATH for this session only
# $PSScriptRoot is the directory where this script is located
$flutterPath = Join-Path $PSScriptRoot "flutter\bin"
$env:Path += ";$flutterPath"

# 3. Pre-cache and check version
Write-Host "[INFO] Running Flutter Doctor..." -ForegroundColor Cyan
flutter doctor

Write-Host "[INFO] Fetching Dependancies..." -ForegroundColor Cyan
flutter pub get

Write-Host "`n[SUCCESS] Flutter setup successfully complete." -ForegroundColor Green
$response = Read-Host -Prompt "`Do you want to run the Budget Tracker app now? [Y/N]"

if ($response.ToUpper() -eq "Y") {
    Write-Host "Running Application..."
    flutter run
}