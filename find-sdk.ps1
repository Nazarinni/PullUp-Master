# Find Connect IQ SDK - Diagnostic Script
# This script helps locate the Connect IQ SDK installation

Write-Host "Searching for Connect IQ SDK..." -ForegroundColor Cyan
Write-Host ""

$found = $false
$locations = @(
    "C:\Garmin\ConnectIQ-SDK\bin\monkeyc.exe",
    "C:\Program Files\Garmin\ConnectIQ-SDK\bin\monkeyc.exe",
    "$env:USERPROFILE\Garmin\ConnectIQ-SDK\bin\monkeyc.exe",
    "$env:LOCALAPPDATA\Garmin\ConnectIQ-SDK\bin\monkeyc.exe"
)

Write-Host "Checking common locations..." -ForegroundColor Yellow
foreach ($location in $locations) {
    if (Test-Path $location) {
        Write-Host "[OK] Found at: $location" -ForegroundColor Green
        $found = $true
        $sdkPath = Split-Path (Split-Path $location)
        Write-Host "   SDK Path: $sdkPath" -ForegroundColor Gray
        break
    } else {
        Write-Host "[X] Not found: $location" -ForegroundColor DarkGray
    }
}

if (-not $found) {
    Write-Host ""
    Write-Host "SDK tools not found in common locations." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Searching entire system (this may take a while)..." -ForegroundColor Yellow
    
    $searchPaths = @(
        "C:\Garmin",
        "C:\Program Files\Garmin",
        "$env:USERPROFILE\Garmin",
        "$env:LOCALAPPDATA\Garmin"
    )
    
    foreach ($searchPath in $searchPaths) {
        if (Test-Path $searchPath) {
            Write-Host "Searching: $searchPath" -ForegroundColor Gray
            $result = Get-ChildItem $searchPath -Recurse -Filter "monkeyc.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($result) {
                Write-Host "[OK] Found at: $($result.FullName)" -ForegroundColor Green
                $found = $true
                $sdkPath = Split-Path (Split-Path $result.FullName)
                Write-Host "   SDK Path: $sdkPath" -ForegroundColor Gray
                break
            }
        }
    }
}

Write-Host ""
if ($found) {
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "SDK Found! You can now build the project." -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "To build, use:" -ForegroundColor Cyan
    Write-Host "  .\build.ps1 -SDKPath `"$sdkPath`"" -ForegroundColor White
    Write-Host ""
    Write-Host "Or update build.ps1 to use this path by default." -ForegroundColor Gray
} else {
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "SDK Tools Not Found" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "The Connect IQ SDK directory exists, but the tools (monkeyc.exe) are missing." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Possible solutions:" -ForegroundColor Cyan
    Write-Host "1. Run the SDK Manager to download the tools:" -ForegroundColor White
    Write-Host "   Start-Process `"C:\Garmin\ConnectIQ-SDK\sdkmanager.exe`"" -ForegroundColor Gray
    Write-Host ""
    Write-Host "2. Reinstall the Connect IQ SDK:" -ForegroundColor White
    Write-Host "   - Download from: https://developer.garmin.com/connect-iq/sdk/" -ForegroundColor Gray
    Write-Host "   - Run the installer again" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. Check if SDK is installed in a different location" -ForegroundColor White
    Write-Host "   - Look for 'monkeyc.exe' on your system" -ForegroundColor Gray
    Write-Host "   - Common locations: Program Files, AppData, or custom install path" -ForegroundColor Gray
}

