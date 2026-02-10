import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/whistle_settings.dart';

/// Service for persisting settings using SharedPreferences
class SettingsStorageService {
  SharedPreferences? _prefs;
  
  /// Initialize the storage service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  /// Load settings from storage
  Future<WhistleSettings> loadSettings() async {
    if (_prefs == null) {
      await initialize();
    }
    
    final volume = _prefs!.getDouble(AppConstants.volumeKey) ?? AppConstants.defaultVolume;
    final frequency = _prefs!.getDouble(AppConstants.frequencyKey) ?? AppConstants.defaultFrequency;
    final outputMethod = _prefs!.getString(AppConstants.outputMethodKey) ?? AppConstants.outputSpeaker;
    
    return WhistleSettings(
      volume: volume,
      frequency: frequency,
      outputMethod: outputMethod,
    );
  }
  
  /// Save settings to storage
  Future<void> saveSettings(WhistleSettings settings) async {
    if (_prefs == null) {
      await initialize();
    }
    
    await Future.wait([
      _prefs!.setDouble(AppConstants.volumeKey, settings.volume),
      _prefs!.setDouble(AppConstants.frequencyKey, settings.frequency),
      _prefs!.setString(AppConstants.outputMethodKey, settings.outputMethod),
    ]);
  }
  
  /// Reset settings to defaults
  Future<void> resetToDefaults() async {
    final defaults = WhistleSettings.defaults();
    await saveSettings(defaults);
  }
  
  /// Clear all stored settings
  Future<void> clearAll() async {
    if (_prefs == null) {
      await initialize();
    }
    
    await Future.wait([
      _prefs!.remove(AppConstants.volumeKey),
      _prefs!.remove(AppConstants.frequencyKey),
      _prefs!.remove(AppConstants.outputMethodKey),
    ]);
  }
}
