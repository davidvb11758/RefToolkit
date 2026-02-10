import '../../services/storage/settings_storage_service.dart';
import '../models/whistle_settings.dart';

/// Repository for managing whistle settings
class SettingsRepository {
  final SettingsStorageService _storageService;
  
  SettingsRepository(this._storageService);
  
  /// Get current settings
  Future<WhistleSettings> getSettings() async {
    try {
      return await _storageService.loadSettings();
    } catch (e) {
      // If loading fails, return defaults
      return WhistleSettings.defaults();
    }
  }
  
  /// Save settings
  Future<void> saveSettings(WhistleSettings settings) async {
    await _storageService.saveSettings(settings);
  }
  
  /// Reset to default settings
  Future<void> resetToDefaults() async {
    await _storageService.resetToDefaults();
  }
}
