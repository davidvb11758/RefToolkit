/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'RefToolkit';
  static const String appVersion = '1.0.0';
  
  // Audio Constants
  static const double minFrequency = 2000.0; // Hz
  static const double maxFrequency = 4000.0; // Hz
  static const double defaultFrequency = 3000.0; // Hz
  
  static const double minVolume = 0.0;
  static const double maxVolume = 1.0;
  static const double defaultVolume = 0.8;
  
  static const double minPressDuration = 0.1; // seconds
  static const double maxPressDuration = 3.0; // seconds
  
  // UI Constants
  static const double phoneButtonSizePercent = 0.70;
  static const double tabletButtonSizePercent = 0.60;
  static const double tabletBreakpoint = 600.0; // width in logical pixels
  
  static const double minTouchTargetSize = 48.0;
  
  // Layout band fractions (top / work / bottom)
  static const double topBandHeightFraction = 0.10;
  static const double workAreaHeightFraction = 0.80;
  static const double bottomBandHeightFraction = 0.10;
  
  // Mode names
  static const String modeWhistle = 'whistle';
  static const String modeTimer = 'timer';
  
  // Timer presets (seconds): 0:30, 1:00, 3:00, 4:00, 10:00
  static const List<int> timerPresetSeconds = [30, 60, 180, 240, 600];
  static const int defaultTimerDurationSeconds = 30;
  
  // Storage Keys
  static const String volumeKey = 'whistle_volume';
  static const String frequencyKey = 'whistle_frequency';
  static const String outputMethodKey = 'output_method';
  
  // Output Methods
  static const String outputSpeaker = 'speaker';
  static const String outputBluetooth = 'bluetooth';
  static const String outputUsb = 'usb';
  static const String outputRf = 'rf';
}
