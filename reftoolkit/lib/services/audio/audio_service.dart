import 'dart:async';
import '../../core/constants/app_constants.dart';
import 'audio_output_interface.dart';
import 'speaker_output.dart';
import 'bluetooth_output.dart';
import 'usb_output.dart';
import 'rf_output.dart';

/// Main audio service that manages different output methods
class AudioService {
  AudioOutputInterface? _currentOutput;
  final Map<String, AudioOutputInterface> _outputs = {};
  Timer? _maxDurationTimer;
  
  AudioService() {
    _initializeOutputs();
  }
  
  void _initializeOutputs() {
    _outputs[AppConstants.outputSpeaker] = SpeakerOutput();
    _outputs[AppConstants.outputBluetooth] = BluetoothOutput();
    _outputs[AppConstants.outputUsb] = UsbOutput();
    _outputs[AppConstants.outputRf] = RfOutput();
  }
  
  /// Initialize the audio service with specified output method
  Future<void> initialize(String outputMethod) async {
    _currentOutput = _outputs[outputMethod];
    if (_currentOutput != null) {
      await _currentOutput!.initialize();
    }
  }
  
  /// Switch to a different output method
  Future<void> switchOutput(String outputMethod) async {
    if (_currentOutput != null) {
      await _currentOutput!.stopWhistle();
    }
    
    _currentOutput = _outputs[outputMethod];
    if (_currentOutput != null) {
      await _currentOutput!.initialize();
    }
  }
  
  /// Play the whistle sound
  Future<void> playWhistle(double frequency, double volume) async {
    if (_currentOutput == null) {
      await initialize(AppConstants.outputSpeaker);
    }
    
    // Clamp values to valid ranges
    final clampedFrequency = frequency.clamp(
      AppConstants.minFrequency,
      AppConstants.maxFrequency,
    );
    final clampedVolume = volume.clamp(
      AppConstants.minVolume,
      AppConstants.maxVolume,
    );
    
    await _currentOutput!.playWhistle(clampedFrequency, clampedVolume);
    
    // Set maximum duration timer (3 seconds)
    _maxDurationTimer?.cancel();
    _maxDurationTimer = Timer(
      Duration(milliseconds: (AppConstants.maxPressDuration * 1000).round()),
      () => stopWhistle(),
    );
  }
  
  /// Stop the whistle sound
  Future<void> stopWhistle() async {
    _maxDurationTimer?.cancel();
    if (_currentOutput != null) {
      await _currentOutput!.stopWhistle();
    }
  }
  
  /// Check if whistle is currently playing
  bool get isPlaying => _currentOutput?.isPlaying ?? false;
  
  /// Get current output method name
  String get currentOutputName => _currentOutput?.name ?? 'None';
  
  /// Get list of available output methods
  List<String> get availableOutputs => _outputs.keys.toList();
  
  /// Dispose of resources
  Future<void> dispose() async {
    _maxDurationTimer?.cancel();
    for (final output in _outputs.values) {
      await output.dispose();
    }
    _outputs.clear();
    _currentOutput = null;
  }
}
