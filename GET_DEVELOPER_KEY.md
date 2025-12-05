# Getting a Developer Key

The Connect IQ SDK 8.4.0 requires a developer key to build applications, even for simulator testing.

## Option 1: Get Key from Garmin Developer Portal (Recommended)

1. **Sign up/Login:**
   - Visit: https://developer.garmin.com/connect-iq/developer-tools/
   - Sign in with your Garmin account (or create one)

2. **Generate Developer Key:**
   - Navigate to "Developer Keys" section
   - Click "Generate New Key"
   - Download the key file (usually `developer_key.der`)

3. **Place in Project:**
   - Save the key file as `developer_key.der` in the project root (`C:\PullUp-Master\`)
   - The build script will automatically use it

## Option 2: Generate Developer Key Using SDK (Easiest)

You can generate a developer key directly using the Connect IQ SDK tools:

**Windows (PowerShell):**
```powershell
cd C:\PullUp-Master
C:\Users\NazarTymchyna\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.4.0-2025-12-03-5122605dc\bin\connectiq.bat genkey developer_key.der
```

**Or using Command Prompt (cmd):**
```cmd
cd C:\PullUp-Master
C:\Users\NazarTymchyna\AppData\Roaming\Garmin\ConnectIQ\Sdks\connectiq-sdk-win-8.4.0-2025-12-03-5122605dc\bin\connectiq.bat genkey developer_key.der
```

**Note:** If you get "Access is denied", try:
- Running PowerShell/Command Prompt as Administrator
- Or use the full path in quotes
- Or navigate to the bin directory first, then run: `connectiq.bat genkey C:\PullUp-Master\developer_key.der`

This will create a `developer_key.der` file in your project root that you can use for development builds.

## After Getting the Key

Once you have `developer_key.der` in the project root, you can build:

```powershell
.\build.ps1
```

The build script will automatically detect and use the key.

## Note

- **Keep your developer key secure** - don't commit it to version control
- Add `developer_key.der` to `.gitignore` if using git
- The key is required for all builds in SDK 8.4.0+

