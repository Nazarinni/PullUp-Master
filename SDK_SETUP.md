# Connect IQ SDK Setup Guide

## Current Status

✅ **SDK Directory Found:** `C:\Garmin\ConnectIQ-SDK`  
❌ **Build Tools Missing:** `monkeyc.exe` not found

The SDK directory exists, but the actual build tools need to be downloaded.

## Solution: Run SDK Manager

The Connect IQ SDK uses a manager tool to download the actual SDK components. You need to:

### Step 1: Launch SDK Manager

**Option A: From PowerShell**
```powershell
Start-Process "C:\Garmin\ConnectIQ-SDK\sdkmanager.exe"
```

**Option B: From File Explorer**
1. Navigate to `C:\Garmin\ConnectIQ-SDK`
2. Double-click `sdkmanager.exe`

### Step 2: Download SDK Components

1. The SDK Manager window will open
2. Look for available SDK versions (e.g., 4.1.0, 4.2.0, etc.)
3. Select and download the SDK version that matches your project
   - Your project requires SDK 4.1.0 or later (see `manifest.json`)
4. Wait for the download and installation to complete

### Step 3: Verify Installation

After the SDK Manager finishes, verify the tools are installed:

```powershell
# Run the diagnostic script
.\find-sdk.ps1

# Or check manually
Test-Path "C:\Garmin\ConnectIQ-SDK\bin\monkeyc.exe"
```

If `monkeyc.exe` is found, you're ready to build!

## Alternative: Reinstall SDK

If the SDK Manager doesn't work, try reinstalling:

1. **Download the full SDK installer:**
   - Visit: https://developer.garmin.com/connect-iq/sdk/
   - Download the Windows installer

2. **Run the installer:**
   - Choose "Complete" or "Full" installation
   - Install to: `C:\Garmin\ConnectIQ-SDK`
   - Make sure all components are selected

3. **Verify:**
   ```powershell
   Test-Path "C:\Garmin\ConnectIQ-SDK\bin\monkeyc.exe"
   ```

## After SDK is Ready

Once `monkeyc.exe` is found, you can build the project:

```powershell
# Build the app
.\build.ps1

# Build and run in simulator
.\build.ps1 -Run

# Build and deploy to device
.\build.ps1 -Run -Deploy
```

## Need Help?

- Check the [SETUP.md](SETUP.md) for detailed instructions
- Run `.\find-sdk.ps1` to search for SDK in other locations
- Visit: https://developer.garmin.com/connect-iq/developer-guide/

