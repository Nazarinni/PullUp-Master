# 🚀 Quick Start Guide

## Prerequisites Check

Before starting, make sure you have:

- ✅ **Java JDK 8+** (You have: Java 25.0.1 ✅)
- ⚠️ **Garmin Connect IQ SDK** (Not installed - see below)
- ✅ **App Icon** (Found at `resources/icons/icon.png` ✅)

## Step 1: Install Connect IQ SDK

**The SDK is required to build and run this app.**

1. **Download the SDK:**
   - Visit: https://developer.garmin.com/connect-iq/sdk/
   - Click "Download" for Windows
   - Save the installer file

2. **Install the SDK:**
   - Run the downloaded installer
   - Install to default location: `C:\Garmin\ConnectIQ-SDK`
   - Complete the installation wizard

3. **Verify Installation:**
   - Check that this file exists: `C:\Garmin\ConnectIQ-SDK\bin\monkeyc.exe`
   - If it exists, you're ready to build!

## Step 2: Build the App

Once the SDK is installed, you can build using:

### Option A: Using the Build Script (Easiest)

```powershell
# Build only
.\build.ps1

# Build and run in simulator
.\build.ps1 -Run

# Build and deploy to connected device
.\build.ps1 -Run -Deploy

# Use a different device
.\build.ps1 -Run -Device fenix7
```

### Option B: Manual Commands

```powershell
# Build
C:\Garmin\ConnectIQ-SDK\bin\monkeyc.exe -f monkey.jungle -o bin\pullup-master.prg

# Run in simulator
C:\Garmin\ConnectIQ-SDK\bin\monkeydo.exe bin\pullup-master.prg fenix6

# Deploy to device
C:\Garmin\ConnectIQ-SDK\bin\monkeydo.exe bin\pullup-master.prg fenix6 -d
```

## Step 3: Run in Simulator

After building, you can run the app in the Garmin Connect IQ Simulator:

```powershell
.\build.ps1 -Run
```

**Available Devices:**
- `fenix6`, `fenix6Pro`, `fenix6S`, `fenix6X`
- `fenix7`, `fenix7S`, `fenix7X`
- `venu2`, `venu2S`, `venu3`, `venu3S`
- `forerunner945`, `forerunner955`, `forerunner965`
- `vivoactive4`, `vivoactive4S`, `vivoactive5`

**Simulator Controls:**
- Mouse: Click buttons
- Keyboard: `Up/Down Arrow` (Navigate), `Enter` (Select), `Esc` (Back)

## Step 4: Deploy to Physical Device (Optional)

1. Connect your Garmin watch via USB
2. Enable Developer Mode on the watch
3. Run:
   ```powershell
   .\build.ps1 -Run -Deploy
   ```

## Troubleshooting

### "SDK not found" Error
- Make sure the SDK is installed at `C:\Garmin\ConnectIQ-SDK`
- Or specify a custom path: `.\build.ps1 -SDKPath "C:\Your\SDK\Path"`

### "monkeyc is not recognized"
- Use the full path: `C:\Garmin\ConnectIQ-SDK\bin\monkeyc.exe`
- Or add the SDK to your PATH environment variable

### Build Errors
- Check that all files are in place (see SETUP.md)
- Verify the icon exists: `resources\icons\icon.png`
- Check for syntax errors in source files

## Next Steps

Once the app is running:
1. Test all features (workout tracking, history, settings)
2. Test on multiple device models
3. Fix any bugs you find
4. Prepare for Garmin Connect IQ Store submission

## Need Help?

- See [SETUP.md](SETUP.md) for detailed setup instructions
- See [README.md](README.md) for project overview
- See [DEVELOPMENT.md](DEVELOPMENT.md) for development guide

