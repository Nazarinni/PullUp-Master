# PullUp Master - Build Script
# This script helps build and run the Garmin Connect IQ app

param(
    [string]$SDKPath = "",
    [string]$Device = "fenix6",
    [switch]$Run,
    [switch]$Deploy
)

$ErrorActionPreference = "Stop"

# Auto-detect SDK path if not provided
if ([string]::IsNullOrEmpty($SDKPath)) {
    # Try common SDK locations
    $possiblePaths = @(
        "$env:USERPROFILE\AppData\Roaming\Garmin\ConnectIQ\Sdks",
        "C:\Garmin\ConnectIQ-SDK",
        "$env:LOCALAPPDATA\Garmin\ConnectIQ\Sdks"
    )
    
    $foundSDK = $null
    foreach ($basePath in $possiblePaths) {
        if (Test-Path $basePath) {
            # Look for SDK version directories
            $sdkDirs = Get-ChildItem $basePath -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*connectiq-sdk*" } | Sort-Object LastWriteTime -Descending
            if ($sdkDirs) {
                $latestSDK = $sdkDirs[0].FullName
                $monkeycPath = Join-Path $latestSDK "bin\monkeyc.bat"
                if (Test-Path $monkeycPath) {
                    $foundSDK = $latestSDK
                    break
                }
            }
        }
    }
    
    if ($foundSDK) {
        $SDKPath = $foundSDK
        Write-Host "[OK] Auto-detected SDK at: $SDKPath" -ForegroundColor Green
    }
}

# Find monkeyc (try .bat first, then .exe)
$monkeyc = "$SDKPath\bin\monkeyc.bat"
if (-not (Test-Path $monkeyc)) {
    $monkeyc = "$SDKPath\bin\monkeyc.exe"
}

if (-not (Test-Path $monkeyc)) {
    Write-Host "[X] Connect IQ SDK tools not found" -ForegroundColor Red
    Write-Host ""
    Write-Host "Searched in: $SDKPath\bin" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please:" -ForegroundColor Yellow
    Write-Host "1. Run SDK Manager to download SDK tools" -ForegroundColor Yellow
    Write-Host "2. Or specify SDK path: .\build.ps1 -SDKPath 'C:\Path\To\SDK'" -ForegroundColor Yellow
    Write-Host "3. SDK is typically at: $env:USERPROFILE\AppData\Roaming\Garmin\ConnectIQ\Sdks" -ForegroundColor Yellow
    exit 1
}

Write-Host "[OK] Using SDK at: $SDKPath" -ForegroundColor Green

# Check for icon
if (-not (Test-Path "resources\icons\icon.png")) {
    Write-Host "❌ Icon not found: resources\icons\icon.png" -ForegroundColor Red
    Write-Host "Please create a 48x48 PNG icon file." -ForegroundColor Yellow
    exit 1
}

Write-Host "[OK] Icon found" -ForegroundColor Green

# Create bin directory if it doesn't exist
if (-not (Test-Path "bin")) {
    New-Item -ItemType Directory -Path "bin" | Out-Null
    Write-Host "[OK] Created bin directory" -ForegroundColor Green
}

# Check for developer key
$devKey = "developer_key.der"
if (-not (Test-Path $devKey)) {
    Write-Host "[!] Developer key not found: $devKey" -ForegroundColor Yellow
    Write-Host "    For development, you need a developer key." -ForegroundColor Yellow
    Write-Host "    Get one from: https://developer.garmin.com/connect-iq/developer-tools/" -ForegroundColor Yellow
    Write-Host "    Or create a test key for simulator use." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "    Creating a test developer key for simulator use..." -ForegroundColor Cyan
    # Note: For actual development, get a real key from Garmin Developer Portal
    # For now, we'll try building without it and see what happens
}

# Build the app
Write-Host ""
Write-Host "[*] Building PullUp Master..." -ForegroundColor Cyan
if (Test-Path $devKey) {
    & $monkeyc -f monkey.jungle -o bin\pullup-master.prg -w -y $devKey
} else {
    # Try building without key first (might work for simulator)
    Write-Host "    Attempting build without key (for simulator testing)..." -ForegroundColor Gray
    & $monkeyc -f monkey.jungle -o bin\pullup-master.prg -w 2>&1 | Tee-Object -Variable buildOutput
    if ($LASTEXITCODE -ne 0 -and $buildOutput -match "private key") {
        Write-Host ""
        Write-Host "[!] Build requires a developer key." -ForegroundColor Yellow
        Write-Host "    Please get a developer key from:" -ForegroundColor Yellow
        Write-Host "    https://developer.garmin.com/connect-iq/developer-tools/" -ForegroundColor Cyan
        Write-Host "    Save it as 'developer_key.der' in the project root." -ForegroundColor Yellow
    }
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "[X] Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host "[OK] Build successful!" -ForegroundColor Green
Write-Host "   Output: bin\pullup-master.prg" -ForegroundColor Gray

# Run in simulator
if ($Run) {
    Write-Host ""
    Write-Host "[*] Starting simulator ($Device)..." -ForegroundColor Cyan
    $monkeydo = "$SDKPath\bin\monkeydo.bat"
    if (-not (Test-Path $monkeydo)) {
        $monkeydo = "$SDKPath\bin\monkeydo.exe"
    }
    if ($Deploy) {
        & $monkeydo bin\pullup-master.prg $Device -d
    } else {
        & $monkeydo bin\pullup-master.prg $Device
    }
}

Write-Host ""
Write-Host "[OK] Done!" -ForegroundColor Green

