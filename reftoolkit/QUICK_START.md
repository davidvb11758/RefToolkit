# Quick Start Guide - RefToolkit

## For Windows Users (Current Setup)

Since Flutter might not be in your PATH yet, follow these steps:

### 1. Add Flutter to PATH

After installing Flutter, you need to add it to your system PATH:

1. **Find your Flutter installation directory** (e.g., `C:\flutter` or `C:\src\flutter`)
2. **Open System Environment Variables**:
   - Press `Win + X` and select "System"
   - Click "Advanced system settings"
   - Click "Environment Variables"
3. **Edit PATH**:
   - Under "User variables", find "Path" and click "Edit"
   - Click "New" and add: `C:\flutter\bin` (or your Flutter path)
   - Click "OK" on all windows
4. **Restart your terminal/IDE**

### 2. Verify Flutter Installation

Open a new PowerShell window and run:
```powershell
flutter --version
flutter doctor
```

### 3. Install Dependencies

```powershell
cd C:\9-personal\david\programs\reftoolkit1\reftoolkit
flutter pub get
```

### 4. Add Whistle Sound

**CRITICAL**: The app needs a whistle sound file to work:

1. Download a free whistle sound (MP3 format) from:
   - https://freesound.org/search/?q=whistle
   - https://zapsplat.com (search for "referee whistle")
   - https://soundbible.com

2. Rename it to `whistle.mp3`

3. Place it in: `C:\9-personal\david\programs\reftoolkit1\reftoolkit\assets\sounds\whistle.mp3`

### 5. Run the App

#### On Windows Desktop (Touch Screen Ready):
```powershell
flutter run -d windows
```

#### On Android Emulator:
```powershell
flutter run -d android
```

#### On Chrome (for quick testing):
```powershell
flutter run -d chrome
```

### 6. Build for Production

#### Windows Executable:
```powershell
flutter build windows --release
```

The app will be in: `build\windows\runner\Release\reftoolkit.exe`

You can distribute the entire `Release` folder.

## Testing the App

1. **Launch the app** - You should see a large black circular button
2. **Press and hold** - Whistle sound should play
3. **Release** - Sound stops
4. **Tap Settings (⚙️)** - Adjust volume and tone
5. **Test button** - Preview the whistle sound

## Troubleshooting

### "flutter: command not found"
- Flutter is not in your PATH
- Restart your terminal after adding to PATH
- Verify with: `$env:PATH -split ';' | Select-String flutter`

### No Sound Playing
1. Check that `whistle.mp3` exists in `assets/sounds/`
2. Run `flutter clean` then `flutter pub get`
3. Rebuild the app

### Build Errors
```powershell
flutter clean
flutter pub get
flutter doctor
```

Fix any issues shown by `flutter doctor`.

### Touch Not Working on Windows
- Ensure you have a touch-capable display
- Test touch in Windows Settings
- Verify touch drivers are up to date

## Next Steps

- Customize settings in `lib/core/constants/app_constants.dart`
- Add your own branding/colors in `lib/core/constants/app_colors.dart`
- Test on Android/iOS by connecting a device or using emulators
- Build release versions for distribution

## File Structure Quick Reference

```
reftoolkit/
├── lib/                          # All Dart code
│   ├── main.dart                 # App entry point
│   ├── core/                     # Constants, themes
│   ├── data/                     # Models, repositories
│   ├── domain/                   # Business logic
│   ├── presentation/             # UI (screens, widgets)
│   └── services/                 # Audio, storage
├── assets/
│   └── sounds/
│       └── whistle.mp3          # ⚠️ YOU NEED TO ADD THIS
├── android/                      # Android config
├── ios/                          # iOS config
├── windows/                      # Windows config
├── macos/                        # macOS config
└── test/                         # Unit tests
```

## Support

- Flutter Documentation: https://docs.flutter.dev
- Flutter Community: https://flutter.dev/community
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter
