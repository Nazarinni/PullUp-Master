# Generate Developer Key Script
# This script generates a developer key for Connect IQ development

$sdkPath = "C:\Users\NazarTymchyna\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.4.0-2025-12-03-5122605dc\bin"
$keyPath = Join-Path $PSScriptRoot "developer_key.der"

Write-Host "Generating developer key..." -ForegroundColor Cyan
Write-Host "SDK Path: $sdkPath" -ForegroundColor Gray
Write-Host "Key will be saved to: $keyPath" -ForegroundColor Gray
Write-Host ""

if (-not (Test-Path $sdkPath)) {
    Write-Host "[X] SDK not found at: $sdkPath" -ForegroundColor Red
    exit 1
}

$connectiq = Join-Path $sdkPath "connectiq.bat"
if (-not (Test-Path $connectiq)) {
    Write-Host "[X] connectiq.bat not found" -ForegroundColor Red
    exit 1
}

# Try to generate the key
Write-Host "Running: $connectiq genkey $keyPath" -ForegroundColor Yellow
Write-Host ""

# Try different methods
try {
    # Method 1: Direct execution
    & $connectiq genkey $keyPath
    if ($LASTEXITCODE -eq 0 -and (Test-Path $keyPath)) {
        Write-Host "[OK] Developer key generated successfully!" -ForegroundColor Green
        Write-Host "   Location: $keyPath" -ForegroundColor Gray
        exit 0
    }
} catch {
    Write-Host "Method 1 failed, trying alternative..." -ForegroundColor Yellow
}

# Method 2: Using cmd
try {
    $cmd = "`"$connectiq`" genkey `"$keyPath`""
    cmd /c $cmd
    if ($LASTEXITCODE -eq 0 -and (Test-Path $keyPath)) {
        Write-Host "[OK] Developer key generated successfully!" -ForegroundColor Green
        Write-Host "   Location: $keyPath" -ForegroundColor Gray
        exit 0
    }
} catch {
    Write-Host "Method 2 failed." -ForegroundColor Yellow
}

# If we get here, manual instructions
Write-Host ""
Write-Host "[!] Automatic generation failed. Please run manually:" -ForegroundColor Yellow
Write-Host ""
Write-Host "   cd C:\PullUp-Master" -ForegroundColor Cyan
Write-Host "   `"$connectiq`" genkey developer_key.der" -ForegroundColor Cyan
Write-Host ""
Write-Host "Or in Command Prompt (cmd):" -ForegroundColor Yellow
Write-Host "   cd C:\PullUp-Master" -ForegroundColor Cyan
Write-Host "   `"$connectiq`" genkey developer_key.der" -ForegroundColor Cyan
Write-Host ""

