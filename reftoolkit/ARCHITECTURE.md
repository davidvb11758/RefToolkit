# RefToolkit Architecture Documentation

## Overview

RefToolkit follows **Clean Architecture** principles with clear separation of concerns and dependency inversion.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                      │
│                          (UI)                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────┐         ┌──────────────────┐         │
│  │ WhistleScreen   │         │ SettingsScreen   │         │
│  │                 │         │                  │         │
│  │ - Large Button  │         │ - Volume Slider  │         │
│  │ - Status Text   │         │ - Pitch Slider   │         │
│  │ - Settings Icon │         │ - Output Select  │         │
│  └────────┬────────┘         └────────┬─────────┘         │
│           │                           │                    │
│           └───────────┬───────────────┘                    │
│                       │                                    │
│              ┌────────▼────────┐                           │
│              │ WhistleButton   │                           │
│              │   (Widget)      │                           │
│              └────────┬────────┘                           │
└───────────────────────┼────────────────────────────────────┘
                        │
                        │ Uses Provider
                        │
┌───────────────────────▼────────────────────────────────────┐
│                     DOMAIN LAYER                           │
│                   (Business Logic)                         │
├────────────────────────────────────────────────────────────┤
│                                                            │
│              ┌────────────────────┐                        │
│              │  WhistleService    │                        │
│              │  (ChangeNotifier)  │                        │
│              │                    │                        │
│              │ - onButtonPressed  │                        │
│              │ - onButtonReleased │                        │
│              │ - updateSettings   │                        │
│              │ - testWhistle      │                        │
│              └──────┬──────┬──────┘                        │
└─────────────────────┼──────┼─────────────────────────────┘
                      │      │
        ┌─────────────┘      └──────────────┐
        │                                   │
┌───────▼──────────────────────┐  ┌─────────▼──────────────┐
│      DATA LAYER              │  │   SERVICES LAYER       │
│   (Models & Repos)           │  │  (External Services)   │
├──────────────────────────────┤  ├────────────────────────┤
│                              │  │                        │
│  ┌────────────────────┐      │  │  ┌──────────────────┐ │
│  │ WhistleSettings    │      │  │  │  AudioService    │ │
│  │   (Model)          │      │  │  │                  │ │
│  │                    │      │  │  │ - playWhistle    │ │
│  │ - volume           │      │  │  │ - stopWhistle    │ │
│  │ - frequency        │      │  │  │ - switchOutput   │ │
│  │ - outputMethod     │      │  │  └────────┬─────────┘ │
│  └────────────────────┘      │  │           │           │
│                              │  │           │           │
│  ┌────────────────────┐      │  │  ┌────────▼─────────┐ │
│  │SettingsRepository  │      │  │  │ AudioOutput      │ │
│  │                    │      │  │  │  Interface       │ │
│  │ - getSettings      │      │  │  └────────┬─────────┘ │
│  │ - saveSettings     │      │  │           │           │
│  └────────┬───────────┘      │  │           │           │
└───────────┼──────────────────┘  │  ┌────────▼─────────┐ │
            │                     │  │ Implementations: │ │
            │                     │  │                  │ │
┌───────────▼──────────────────┐  │  │ • Speaker    ✅  │ │
│  SettingsStorageService      │  │  │ • Bluetooth  🔄  │ │
│  (SharedPreferences)         │  │  │ • USB        🔄  │ │
│                              │  │  │ • RF         🔄  │ │
│  - loadSettings              │  │  └──────────────────┘ │
│  - saveSettings              │  │                       │
│  - resetToDefaults           │  └───────────────────────┘
└──────────────────────────────┘
```

## Layer Responsibilities

### 1. Presentation Layer (UI)
**Location**: `lib/presentation/`

**Responsibility**: Display UI and handle user interactions

**Components**:
- **Screens**: Full-page views (WhistleScreen, SettingsScreen)
- **Widgets**: Reusable UI components (WhistleButton)

**Rules**:
- No business logic
- No direct data access
- Uses Provider to observe state
- Displays data from domain layer

### 2. Domain Layer (Business Logic)
**Location**: `lib/domain/services/`

**Responsibility**: Implement business rules and orchestrate data flow

**Components**:
- **WhistleService**: Main business logic coordinator

**Rules**:
- Independent of UI
- Independent of external frameworks
- Contains all business rules
- Manages state using ChangeNotifier

### 3. Data Layer (Models & Repositories)
**Location**: `lib/data/`

**Responsibility**: Define data structures and manage data access

**Components**:
- **Models**: Data structures (WhistleSettings)
- **Repositories**: Abstract data access (SettingsRepository)

**Rules**:
- Pure data structures
- Repository pattern for data access
- No business logic
- Serialization/deserialization

### 4. Services Layer (External Services)
**Location**: `lib/services/`

**Responsibility**: Interface with external systems (audio, storage)

**Components**:
- **Audio**: Audio playback and output management
- **Storage**: Data persistence

**Rules**:
- Abstract interfaces for flexibility
- Platform-specific implementations
- No business logic

## Data Flow

### Button Press Flow
```
User presses button
        ↓
WhistleButton (onTapDown)
        ↓
WhistleService.onButtonPressed()
        ↓
AudioService.playWhistle(frequency, volume)
        ↓
SpeakerOutput.playWhistle()
        ↓
Device plays sound
```

### Settings Update Flow
```
User adjusts slider
        ↓
SettingsScreen (onChanged)
        ↓
WhistleService.updateVolume()
        ↓
WhistleService.updateSettings()
        ↓
SettingsRepository.saveSettings()
        ↓
SettingsStorageService.saveSettings()
        ↓
SharedPreferences persists data
```

### App Initialization Flow
```
main()
        ↓
Initialize SettingsStorageService
        ↓
Create SettingsRepository
        ↓
Create AudioService
        ↓
Create WhistleService
        ↓
Load settings from storage
        ↓
Initialize audio with output method
        ↓
Provide WhistleService to widget tree
        ↓
Build UI
```

## Design Patterns

### 1. Repository Pattern
**Used in**: Data access

```dart
SettingsRepository
    ↓
SettingsStorageService
    ↓
SharedPreferences
```

**Benefits**:
- Abstraction of data source
- Easy to swap storage implementations
- Testable

### 2. Strategy Pattern
**Used in**: Audio output

```dart
AudioOutputInterface (Strategy)
    ├── SpeakerOutput
    ├── BluetoothOutput
    ├── UsbOutput
    └── RfOutput
```

**Benefits**:
- Runtime output switching
- Easy to add new output methods
- Follows Open/Closed Principle

### 3. Provider Pattern
**Used in**: State management

```dart
WhistleService extends ChangeNotifier
    ↓
Provider.value(whistleService)
    ↓
Consumer<WhistleService>
```

**Benefits**:
- Reactive UI updates
- Clean separation of state and UI
- Efficient rebuilds

### 4. Singleton Pattern
**Used in**: Services

```dart
AudioService (single instance)
SettingsStorageService (single instance)
```

**Benefits**:
- Shared state across app
- Resource management
- Consistent behavior

## Key Principles

### 1. Dependency Inversion
- High-level modules don't depend on low-level modules
- Both depend on abstractions (interfaces)
- Example: `AudioService` depends on `AudioOutputInterface`, not concrete implementations

### 2. Single Responsibility
- Each class has one reason to change
- Example: `WhistleButton` only handles UI, `WhistleService` only handles logic

### 3. Open/Closed Principle
- Open for extension, closed for modification
- Example: Add new output method by implementing interface, no changes to existing code

### 4. Interface Segregation
- Clients shouldn't depend on interfaces they don't use
- Example: `AudioOutputInterface` only has methods needed by all outputs

## Extension Points

### Adding a New Output Method

1. **Create implementation**:
```dart
class NewOutput implements AudioOutputInterface {
  // Implement all methods
}
```

2. **Register in AudioService**:
```dart
_outputs['new_output'] = NewOutput();
```

3. **Add to UI**:
```dart
RadioListTile<String>(
  title: Text('New Output'),
  value: 'new_output',
  // ...
)
```

### Adding a New Setting

1. **Update model**:
```dart
class WhistleSettings {
  final String newSetting;
  // ...
}
```

2. **Update storage**:
```dart
const String newSettingKey = 'new_setting';
```

3. **Add to UI**:
```dart
// Add control in SettingsScreen
```

## Testing Strategy

### Unit Tests
- Test individual classes in isolation
- Mock dependencies
- Example: Test `WhistleService` with mocked `AudioService`

### Widget Tests
- Test UI components
- Verify user interactions
- Example: Test button press updates state

### Integration Tests
- Test complete flows
- Verify end-to-end functionality
- Example: Test settings persistence

## Performance Considerations

### Audio Latency
- Direct audio output (no buffering)
- Minimal processing between touch and sound
- Target: <50ms latency

### UI Performance
- Efficient Provider usage (Consumer widgets)
- Minimal rebuilds
- 60fps animations

### Memory Management
- Dispose audio resources properly
- Clean up listeners
- Efficient asset loading

## Platform-Specific Notes

### Android
- Minimum SDK 21
- Audio permissions handled automatically

### iOS
- iOS 12.0+ required
- Info.plist configured for audio

### Windows
- Touch screen support via native Flutter
- No additional configuration needed

### macOS
- Universal binary (Intel + Apple Silicon)
- Audio permissions automatic

## Future Architecture Enhancements

1. **Offline-First Architecture**
   - Add local database (SQLite/Hive)
   - Cache settings locally

2. **Event-Driven Architecture**
   - Add event bus for decoupled communication
   - Better for complex state management

3. **Plugin Architecture**
   - Allow third-party output plugins
   - Dynamic loading of features

4. **Reactive Extensions**
   - Consider RxDart for complex streams
   - Better async handling
