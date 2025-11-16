# PullUp Master - Setup and Running Guide

## ✅ Setup Status

**Project files are ready!** All required files have been created and configured.

1. **App Icon** ✅ **COMPLETE**
   - ✅ Created: `resources\icons\icon.png` (48x48 PNG)
   - This file is referenced in `manifest.json` and is ready for building

## ⚠️ IMPORTANT: Install Connect IQ SDK First

**Before you can build this project, you MUST install the Garmin Connect IQ SDK.**

The SDK is **not installed** on your system. You need to:

1. **Download the SDK:**
   - Visit: https://developer.garmin.com/connect-iq/sdk/
   - Click "Download" for Windows
   - Save the installer file

2. **Install the SDK:**
   - Run the downloaded installer
   - Install to the default location: `C:\Garmin\ConnectIQ-SDK`
   - Complete the installation wizard

3. **Verify Installation:**
   - After installation, check that this file exists:
     `C:\Garmin\ConnectIQ-SDK\bin\monkeyc.exe`
   - If it exists, you're ready to build!

4. **Then build your project:**
   ```bash
   C:\Garmin\ConnectIQ-SDK\bin\monkeyc.exe -f monkey.jungle -o bin\pullup-master.prg
   ```

**See Prerequisites section below for detailed installation instructions.**

## Prerequisites

### 1. Install Garmin Connect IQ SDK ⚠️ REQUIRED

**You must install this before you can build the project!**

1. **Download the SDK**
   - Visit: https://developer.garmin.com/connect-iq/sdk/
   - Click "Download" button
   - Select "Windows" version
   - Save the installer file (e.g., `ConnectIQ-SDK-win-4.x.x.exe`)

2. **Run the Installer**
   - Double-click the downloaded installer file
   - Follow the installation wizard
   - **Recommended:** Install to default location: `C:\Garmin\ConnectIQ-SDK`
   - Complete the installation

3. **Verify Installation**
   - After installation, verify these files exist:
     - `C:\Garmin\ConnectIQ-SDK\bin\monkeyc.exe` ✅
     - `C:\Garmin\ConnectIQ-SDK\bin\monkeydo.exe` ✅
   - If these files don't exist, the installation failed - try reinstalling

4. **Add SDK to PATH** (Optional but recommended)
   - This allows you to use `monkeyc` and `monkeydo` commands directly
   - See "If SDK is not in PATH" section below for instructions
   - **Note:** You can still build without adding to PATH by using the full path

### 2. Install Java JDK

- Garmin Connect IQ requires Java JDK 8 or later
- Download from: https://www.oracle.com/java/technologies/downloads/
- Verify installation:
  ```bash
  java -version
  ```

### 3. Install Development IDE

**Visual Studio Code (Recommended - Officially Supported)**

Garmin now officially supports and recommends Visual Studio Code for Connect IQ development.

1. **Download Visual Studio Code**
   - Visit: https://code.visualstudio.com/
   - Download and install VS Code for Windows

2. **Install Monkey C Extension**
   - Open VS Code
   - Click the Extensions icon in the left sidebar (or press `Ctrl+Shift+X`)
   - Search for "Monkey C"
   - Install the official "Monkey C" extension by Garmin
   - Restart VS Code after installation

3. **Configure SDK Path in VS Code**
   
   This tells the Monkey C extension where to find your Connect IQ SDK installation.
   
   **Method 1: Via Settings UI (Easiest)**
   - In VS Code, press `Ctrl+,` to open Settings
   - In the search bar at the top, type "Monkey C" or "SDK"
   - Look for "Monkey C: SDK Path" or "Connect IQ SDK Path" setting
   - Click "Edit in settings.json" or enter the path directly in the text field
   - Set the path to your SDK directory (e.g., `C:\Garmin\ConnectIQ-SDK`)
   - The setting will be saved automatically
   
   **Method 2: Via settings.json (Manual)**
   - In VS Code, press `Ctrl+Shift+P` to open Command Palette
   - Type "Preferences: Open User Settings (JSON)" and select it
   - This opens your VS Code settings.json file
   - Add this line to the JSON object (replace with your actual SDK path):
     ```json
     "monkeyC.sdkPath": "C:\\Garmin\\ConnectIQ-SDK"
     ```
     **Important:** Use double backslashes `\\` for Windows paths
   - Save the file (`Ctrl+S`)
   
   **Method 3: Via Command Palette (If Available)**
   - In VS Code, press `Ctrl+Shift+P` to open Command Palette
   - Type "Monkey C" to see all available Monkey C commands
   - If "Monkey C: Configure SDK Path" appears in the list, select it
   - If it doesn't appear, use Method 1 or 2 above
   
   **Note:** If you can't find the setting, you can skip this step if your SDK `bin` directory is already in your system PATH. The extension will use the SDK from PATH.

**Eclipse (Legacy - Not Recommended)**

⚠️ **Note:** Eclipse support is deprecated. The `plugins` folder is no longer included in newer SDK installations. The update site may not work. Consider using VS Code instead.

If you must use Eclipse:
- Download Eclipse IDE for Java Developers from https://www.eclipse.org/downloads/
- Use Eclipse 2020-06 or earlier for better compatibility
- Attempt to install plugin via: `Help` → `Install New Software...` → Add repository: `https://developer.garmin.com/downloads/connect-iq/eclipse/`
- If this fails, the plugin is no longer available and you should use VS Code

## Setup Project

### Using Visual Studio Code (Recommended)

1. **Open Project**
   - Open VS Code
   - Go to: `File` → `Open Folder...`
   - Browse to your project directory: `C:\PullUp-Master`
   - Click `Select Folder`

2. **Configure SDK Path** (if not already done)
   - **Via Settings:** Press `Ctrl+,` → Search "Monkey C SDK" → Set path to `C:\Garmin\ConnectIQ-SDK`
   - **Or via settings.json:** Press `Ctrl+Shift+P` → "Preferences: Open User Settings (JSON)" → Add:
     ```json
     "monkeyC.sdkPath": "C:\\Garmin\\ConnectIQ-SDK"
     ```
     (Replace with your actual SDK path)

3. **Create App Icon** (Required - See Missing Items section above)
   - Create `resources\icons\icon.png` (48x48 PNG)

4. **Verify Project Structure**
   - ✅ `manifest.json` in root
   - ✅ `monkey.jungle` in root
   - ✅ `source` folder with all `.mc` files
   - ✅ `resources` folder exists
   - ✅ `resources\icons\icon.png` exists

### Using Command Line Only

1. **Navigate to Project Directory**
   ```bash
   cd C:\PullUp-Master
   ```

2. **Create App Icon** (Required)
   - Create `resources\icons\icon.png` (48x48 PNG)

## Building the App

### Using Visual Studio Code

1. **Build Project**
   - **Option A: Command Line (Recommended - Most Reliable)**
     - **Open Terminal:** Press `` Ctrl+` `` (Ctrl + backtick) to open integrated terminal
       - Or go to: `Terminal` → `New Terminal` from the menu
       - Or use: `View` → `Terminal`
     - **Run Build Command:** Use one of these:
       
       **If SDK is in PATH:**
       ```bash
       monkeyc -f monkey.jungle -o bin\pullup-master.prg
       ```
       
       **If you get "monkeyc is not recognized" error, use full path:**
       ```bash
       C:\Garmin\ConnectIQ-SDK\bin\monkeyc.exe -f monkey.jungle -o bin\pullup-master.prg
       ```
       (Note: Use `.exe` extension on Windows. Adjust the path if your SDK is installed elsewhere)
       
       **If the SDK is not installed:**
       - Download and install from: https://developer.garmin.com/connect-iq/sdk/
       - Then use the full path command above
     - Press `Enter` to execute
     - The terminal will show build progress and any errors
   - **Option B: Extension Command (May have bugs)**
     - Press `Ctrl+Shift+P` → Type "Monkey C: Build" and select it
     - If you get "t.split is not a function" error, use Option A instead

2. **Check for Errors**
   - Errors appear in the Problems panel (View → Problems)
   - Or check terminal output if using command line
   - Fix any compilation errors

### Using Command Line

```bash
# If SDK is in PATH
monkeyc -f monkey.jungle -o bin\pullup-master.prg

# If SDK is not in PATH
C:\Garmin\ConnectIQ-SDK\bin\monkeyc -f monkey.jungle -o bin\pullup-master.prg
```

## Running the App

### Option 1: Connect IQ Simulator (Recommended)

**Using VS Code:**
- Press `Ctrl+Shift+P` → Type "Monkey C: Run" → Select device

**Using Command Line:**
```bash
monkeydo bin\pullup-master.prg fenix6
```

**Available Device Simulators:**
- `fenix6`, `fenix6Pro`, `fenix6S`, `fenix6X`
- `fenix7`, `fenix7S`, `fenix7X`
- `venu2`, `venu2S`, `venu3`, `venu3S`
- `forerunner945`, `forerunner955`, `forerunner965`
- `vivoactive4`, `vivoactive4S`, `vivoactive5`
- See `manifest.json` for full list

**Simulator Controls:**
- Mouse: Click buttons
- Keyboard: `Up/Down Arrow` (Navigate), `Enter` (Select), `Esc` (Back)

### Option 2: Deploy to Physical Device

1. **Connect Your Garmin Watch**
   - Connect watch to computer via USB
   - Ensure Garmin Express is installed and running

2. **Enable Developer Mode**
   - On watch: Settings → System → Developer Mode (enable)
   - Or use Garmin Express to enable

3. **Deploy**
   - **VS Code:** Press `Ctrl+Shift+P` → Type "Monkey C: Deploy" → Select device
   - **Command Line:**
     ```bash
     monkeydo bin\pullup-master.prg fenix6 -d
     ```
     (The `-d` flag deploys to connected device)

## Quick Start Commands

### In VS Code Terminal

1. **Open Terminal in VS Code:**
   - Press `` Ctrl+` `` (Ctrl + backtick key)
   - Or: `Terminal` → `New Terminal` from menu
   - Or: `View` → `Terminal`

2. **Build the app:**
   
   **If SDK is in PATH:**
   ```bash
   monkeyc -f monkey.jungle -o bin\pullup-master.prg
   ```
   
   **If you get "monkeyc is not recognized" error, use full path:**
   ```bash
   C:\Garmin\ConnectIQ-SDK\bin\monkeyc -f monkey.jungle -o bin\pullup-master.prg
   ```

3. **Run in simulator:**
   
   **If SDK is in PATH:**
   ```bash
   monkeydo bin\pullup-master.prg fenix6
   ```
   
   **If you get "monkeydo is not recognized" error, use full path:**
   ```bash
   C:\Garmin\ConnectIQ-SDK\bin\monkeydo bin\pullup-master.prg fenix6
   ```

4. **Deploy to connected device:**
   ```bash
   monkeydo bin\pullup-master.prg fenix6 -d
   ```

### Windows PowerShell (Outside VS Code)

```powershell
# Navigate to project
cd C:\PullUp-Master

# Build the app
monkeyc -f monkey.jungle -o bin\pullup-master.prg

# Run in simulator
monkeydo bin\pullup-master.prg fenix6

# Deploy to connected device
monkeydo bin\pullup-master.prg fenix6 -d
```

### If SDK is not in PATH

```powershell
# Set SDK path for current session
$env:Path += ";C:\Garmin\ConnectIQ-SDK\bin"

# Or use full path
C:\Garmin\ConnectIQ-SDK\bin\monkeyc -f monkey.jungle -o bin\pullup-master.prg
C:\Garmin\ConnectIQ-SDK\bin\monkeydo bin\pullup-master.prg fenix6
```

## Troubleshooting

### Build Errors

1. **"Cannot find manifest.json"**
   - Ensure you're in the project root directory
   - Check that `manifest.json` exists

2. **"Icon not found"** ⚠️ **Most Common Issue**
   - Create `resources\icons\icon.png` (48x48 PNG)
   - This is required for the build to succeed

3. **"Unable to find manifest.xml" in VS Code**
   - This is a false error - Connect IQ projects use `manifest.json`, not `manifest.xml`
   - **Solution:** Reload VS Code window: `Ctrl+Shift+P` → "Developer: Reload Window"
   - Ensure you opened the project folder (not a parent folder): `File` → `Open Folder...` → Select `C:\PullUp-Master`
   - The extension should detect `manifest.json` automatically after reload
   - If error persists, the extension may need an update - check Extensions panel

4. **"monkeyc is not recognized" or "CommandNotFoundException"**
   - **Cause:** The Connect IQ SDK is not installed or not in PATH
   - **Solution 1: Install the SDK** (if not installed)
     - Download from: https://developer.garmin.com/connect-iq/sdk/
     - Install to default location: `C:\Garmin\ConnectIQ-SDK`
   - **Solution 2: Find your SDK installation**
     - Check common locations:
       - `C:\Garmin\ConnectIQ-SDK\bin`
       - `C:\Program Files\Garmin\ConnectIQ-SDK\bin`
       - `%USERPROFILE%\Garmin\ConnectIQ-SDK\bin`
     - Or search your computer for `monkeyc.exe`
   - **Solution 3: Use full path** (once you find SDK location)
     ```bash
     C:\Garmin\ConnectIQ-SDK\bin\monkeyc.exe -f monkey.jungle -o bin\pullup-master.prg
     ```
     (Note: Use `.exe` extension on Windows)
   - **Solution 4: Add SDK to PATH** (permanent fix)
     - See "If SDK is not in PATH" section below

5. **"t.split is not a function" or "Build Current Project" error in VS Code**
   - This is a bug in the Monkey C extension, not your project
   - **Workaround:** Use command line to build instead:
     ```bash
     monkeyc -f monkey.jungle -o bin\pullup-master.prg
     ```
   - **Try fixing the extension:**
     - Update the Monkey C extension: Extensions panel → Find "Monkey C" → Update if available
     - Or reinstall: Uninstall → Restart VS Code → Reinstall
     - Check extension settings: `Ctrl+,` → Search "Monkey C" → Verify SDK path is correct
   - **Note:** Command line build works reliably and is often faster than the extension

6. **"Java not found"**
   - Install Java JDK 8 or later
   - Add Java to your PATH
   - Verify: `java -version`

7. **Compilation Errors**
   - Check `source` folder for all `.mc` files
   - Verify no syntax errors in Monkey C code
   - Check VS Code Problems panel or command line output

### Simulator Issues

1. **Simulator won't start**
   - Ensure Java is installed and in PATH
   - Try a different device model
   - Check SDK installation

2. **App crashes in simulator**
   - Check for runtime errors in console
   - Verify all required permissions in manifest
   - Test with minimal code first

### Device Deployment Issues

1. **Device not detected**
   - Ensure USB connection is stable
   - Install Garmin Express
   - Enable Developer Mode on watch

2. **Deployment fails**
   - Check device compatibility in manifest
   - Ensure watch has enough storage
   - Try restarting Garmin Express

## Development Workflow

1. **Make Changes**
   - Edit `.mc` files in `source` folder
   - Edit resources in `resources` folder

2. **Build**
   - **VS Code:** `Ctrl+Shift+P` → "Monkey C: Build"
   - **Command line:** `monkeyc -f monkey.jungle -o bin\pullup-master.prg`

3. **Test**
   - **VS Code:** `Ctrl+Shift+P` → "Monkey C: Run" → Select device
   - **Command line:** `monkeydo bin\pullup-master.prg fenix6`

4. **Debug**
   - Check console output
   - Use `System.println()` for debugging
   - Check VS Code Problems panel

## Useful Commands Reference

```bash
# Build
monkeyc -f monkey.jungle -o bin\pullup-master.prg

# Run simulator
monkeydo bin\pullup-master.prg fenix6

# Deploy to device
monkeydo bin\pullup-master.prg fenix6 -d

# List available devices
monkeydo -l

# Get help
monkeyc -h
monkeydo -h
```

## Testing Checklist

Once running, test these features:

- [ ] App launches successfully
- [ ] Main menu displays correctly
- [ ] Can navigate between menu items
- [ ] Can start a workout
- [ ] Can log reps and sets
- [ ] Rest timer works
- [ ] Can complete workout
- [ ] History view shows data
- [ ] Settings can be changed
- [ ] User profile imports (if available)
- [ ] Pro features work (after subscription)

## Next Steps

After successfully running the app:

1. Test all features
2. Fix any bugs
3. Create proper app icon (if using placeholder)
4. Test on multiple device models
5. Prepare for store submission

## Resources

- [Garmin Connect IQ Developer Guide](https://developer.garmin.com/connect-iq/developer-guide/)
- [Monkey C Language Reference](https://developer.garmin.com/connect-iq/monkey-c/)
- [Connect IQ SDK Download](https://developer.garmin.com/connect-iq/sdk/)
