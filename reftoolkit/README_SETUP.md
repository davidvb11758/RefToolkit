# RefToolkit - Referee Whistle App

A cross-platform Flutter app that simulates a referee whistle with touch-activated sound, configurable volume and pitch.

## Platform Support

- ✅ Android (Phone & Tablet)
- ✅ iOS (iPhone & iPad)
- ✅ Windows (Desktop with touch screen support)
- ✅ macOS (Intel & Apple Silicon)

## Features

- **Touch-Aware**: Large button responds to touch input
- **Responsive**: Adapts to different screen sizes and orientations
- **Configurable**: Adjust volume and tone/pitch
- **Object-Oriented**: Clean architecture with separated UI, logic, and output layers
- **Extensible**: Output interface ready for future Bluetooth, USB, and RF support

## Setup Instructions

### Prerequisites

1. **Install Flutter**: https://docs.flutter.dev/get-started/install
2. **Add Flutter to PATH**: Make sure you can run `flutter` command in terminal
3. **Install Platform-Specific Tools**:
   - Android: Android Studio & Android SDK
   - iOS: Xcode (macOS only)
   - Windows: Visual Studio 2022 with Desktop C++ workload
   - macOS: Xcode

### Initial Setup

1. **Navigate to the project directory**:
   ```bash
   cd reftoolkit
   ```

2. **Get Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Add a whistle sound file** (IMPORTANT):
   - Place a whistle sound file named `whistle.mp3` in `assets/sounds/`
   - See `assets/sounds/README.txt` for details
   - You can download free whistle sounds from:
     - https://freesound.org
     - https://zapsplat.com
     - https://soundbible.com

4. **Verify Flutter setup**:
   ```bash
   flutter doctor
   ```
   Fix any issues reported by flutter doctor.

### Running the App

#### On Android
```bash
flutter run -d android
```

#### On iOS (macOS only)
```bash
flutter run -d ios
```

#### On Windows
```bash
flutter run -d windows
```

#### On macOS
```bash
flutter run -d macos
```

#### On Chrome (for testing)
```bash
flutter run -d chrome
```

### Building for Production

#### Android APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

#### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

#### iOS (macOS only)
```bash
flutter build ios --release
```
Then open in Xcode to create archive for App Store

#### Windows
```bash
flutter build windows --release
```
Output: `build/windows/runner/Release/`

#### macOS
```bash
flutter build macos --release
```
Output: `build/macos/Build/Products/Release/`

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── core/
│   ├── constants/                     # App constants, colors
│   └── themes/                        # Light/dark themes
├── data/
│   ├── models/                        # Data models (WhistleSettings)
│   └── repositories/                  # Settings repository
├── domain/
│   └── services/                      # Business logic (WhistleService)
├── presentation/
│   ├── screens/                       # Whistle & Settings screens
│   └── widgets/                       # Reusable widgets
└── services/
    ├── audio/                         # Audio output interface & implementations
    └── storage/                       # Settings persistence
```

## Architecture

### Clean Architecture

The app follows clean architecture principles:

1. **Presentation Layer**: UI components (screens, widgets)
2. **Domain Layer**: Business logic (services)
3. **Data Layer**: Models and repositories
4. **Services Layer**: External services (audio, storage)

### Audio Output Interface

The app uses an abstract `AudioOutputInterface` that allows for multiple output methods:

- **Speaker** (Implemented): Device speaker with pitch/volume control
- **Bluetooth** (Placeholder): Ready for Bluetooth audio output
- **USB** (Placeholder): Ready for USB audio devices
- **RF** (Placeholder): Ready for radio frequency transmission

To add a new output method:
1. Create a class implementing `AudioOutputInterface`
2. Add to `AudioService` output registry
3. Add to settings UI

## Usage

1. **Launch the app**: You'll see a large circular button
2. **Press and hold**: The whistle sound plays
3. **Release**: The sound stops
4. **Settings**: Tap the gear icon to configure:
   - Volume (0-100%)
   - Tone/Pitch (2000-4000 Hz)
   - Output method (currently only Speaker)
   - Test button to preview sound
   - Reset to defaults

## Configuration

### Default Settings

- **Volume**: 80%
- **Frequency**: 3000 Hz
- **Output**: Speaker
- **Max Duration**: 3 seconds per press

### Customization

Edit `lib/core/constants/app_constants.dart` to change:
- Frequency range
- Volume range
- Button size percentages
- Maximum press duration

## Troubleshooting

### No Sound?
1. Check that `whistle.mp3` exists in `assets/sounds/`
2. Verify volume is not at 0%
3. Check device volume/mute settings
4. Run `flutter clean && flutter pub get`

### Build Errors?
1. Run `flutter clean`
2. Run `flutter pub get`
3. Check `flutter doctor` for platform issues
4. Verify all dependencies are compatible

### Touch Not Working on Windows?
1. Ensure Windows touch drivers are installed
2. Test touch in other apps to verify hardware
3. Try running as administrator

## Future Enhancements

- [ ] Multiple whistle sounds to choose from
- [ ] Bluetooth audio output
- [ ] USB audio output
- [ ] RF transmission support
- [ ] Custom sound upload
- [ ] Whistle pattern presets
- [ ] Visual equalizer
- [ ] Shake to whistle

## License

This project is created for personal/commercial use.

## Support

For issues or questions, please refer to the Flutter documentation:
- https://docs.flutter.dev
- https://flutter.dev/community
