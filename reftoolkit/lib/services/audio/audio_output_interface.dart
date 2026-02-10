/// Abstract interface for audio output methods
/// This allows for future expansion to Bluetooth, USB, RF, etc.
abstract class AudioOutputInterface {
  /// Initialize the audio output
  Future<void> initialize();
  
  /// Play whistle sound at specified frequency and volume
  /// 
  /// [frequency] - Frequency in Hz (typically 2000-4000 Hz)
  /// [volume] - Volume level (0.0 to 1.0)
  Future<void> playWhistle(double frequency, double volume);
  
  /// Stop the whistle sound
  Future<void> stopWhistle();
  
  /// Dispose of resources
  Future<void> dispose();
  
  /// Check if whistle is currently playing
  bool get isPlaying;
  
  /// Get the name of this output method
  String get name;
}
