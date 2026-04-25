# 1. Check if 'flutter' is already available in the system
Write-Host "[INFO] Searching for Flutter in System PATH..." -ForegroundColor Cyan
$existingFlutter = Get-Command flutter -ErrorAction SilentlyContinue

if ($existingFlutter) {
    Write-Host "[INFO] Flutter found globally at: $($existingFlutter.Source)" -ForegroundColor Green
    $flutterExecutable = "flutter"
} else {
    Write-Host "[INFO] Flutter not found in System PATH." -ForegroundColor Yellow

    # 2. Check if it exists locally in the script folder
    $localFlutterDir = Join-Path $PSScriptRoot "flutter"
    $localFlutterBin = Join-Path $localFlutterDir "bin"

    if (-not (Test-Path $localFlutterDir)) {
        Write-Host "[INFO] Installing Flutter locally..." -ForegroundColor Yellow
        git clone https://github.com/flutter/flutter.git -b stable --depth 1 --single-branch $localFlutterDir

        if ($LASTEXITCODE -ne 0) {
            Write-Host "[ERROR] Git clone failed." -ForegroundColor Red
            exit
        }
    }

    # 3. Set local environment variable for this session
    Write-Host "[INFO] Using local Flutter environment." -ForegroundColor Magenta
    if ($env:Path -notlike "*$localFlutterBin*") {
        $env:Path = "$localFlutterBin;$env:Path"
    }
    $flutterExecutable = "flutter"
}

# 4. Proceed with Project Tasks
Write-Host "[INFO] Initializing..." -ForegroundColor Cyan
& $flutterExecutable precache

if (Test-Path "pubspec.yaml") {
    & $flutterExecutable pub get
}

Write-Host "`n[SUCCESS] Environment Ready." -ForegroundColor Green

$response = Read-Host -Prompt "Run Budget Tracker? (Y/N)"
if ($response -eq "Y") {
    & $flutterExecutable run -d windows
}