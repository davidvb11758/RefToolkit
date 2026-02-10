import 'package:flutter/foundation.dart';
import '../../data/models/whistle_settings.dart';
import '../../data/repositories/settings_repository.dart';
import '../../services/audio/audio_service.dart';

/// Business logic service for whistle functionality
class WhistleService extends ChangeNotifier {
  final AudioService _audioService;
  final SettingsRepository _settingsRepository;

  WhistleSettings _settings = WhistleSettings.defaults();
  bool _isPressed = false;
  bool _isInitialized = false;

  WhistleService(this._audioService, this._settingsRepository);

  WhistleSettings get settings => _settings;
  bool get isPressed => _isPressed;
  bool get isInitialized => _isInitialized;
  bool get isPlaying => _audioService.isPlaying;

  /// Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Load settings
    _settings = await _settingsRepository.getSettings();

    // Initialize audio service with current output method
    await _audioService.initialize(_settings.outputMethod);

    _isInitialized = true;
    notifyListeners();
  }

  /// Handle button press (start whistle) — sound plays only while pressed.
  void onButtonPressed() {
    if (!_isInitialized) {
      initialize();
      return;
    }

    if (_isPressed) return; // Already pressed

    _isPressed = true;
    notifyListeners();

    _audioService.playWhistle(_settings.frequency, _settings.volume);
  }

  /// Handle button release (stop whistle immediately).
  void onButtonReleased() {
    if (!_isPressed) return; // Not pressed

    _isPressed = false;
    notifyListeners();

    _audioService.stopWhistle();
  }
  
  /// Update settings
  Future<void> updateSettings(WhistleSettings newSettings) async {
    final oldOutputMethod = _settings.outputMethod;
    _settings = newSettings;
    
    // If output method changed, switch the audio output
    if (oldOutputMethod != newSettings.outputMethod) {
      await _audioService.switchOutput(newSettings.outputMethod);
    }
    
    // Save settings
    await _settingsRepository.saveSettings(newSettings);
    
    notifyListeners();
  }
  
  /// Update volume
  Future<void> updateVolume(double volume) async {
    await updateSettings(_settings.copyWith(volume: volume));
  }
  
  /// Update frequency
  Future<void> updateFrequency(double frequency) async {
    await updateSettings(_settings.copyWith(frequency: frequency));
  }
  
  /// Update output method
  Future<void> updateOutputMethod(String outputMethod) async {
    await updateSettings(_settings.copyWith(outputMethod: outputMethod));
  }
  
  /// Reset settings to defaults
  Future<void> resetToDefaults() async {
    await _settingsRepository.resetToDefaults();
    _settings = WhistleSettings.defaults();
    await _audioService.switchOutput(_settings.outputMethod);
    notifyListeners();
  }
  
  /// Test the whistle (for settings preview)
  Future<void> testWhistle() async {
    await _audioService.playWhistle(_settings.frequency, _settings.volume);
    
    // Auto-stop after 0.5 seconds for testing
    await Future.delayed(const Duration(milliseconds: 500));
    await _audioService.stopWhistle();
  }
  
  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
