import '../../core/constants/app_constants.dart';

/// Model representing whistle configuration settings
class WhistleSettings {
  final double volume;
  final double frequency;
  final String outputMethod;
  
  const WhistleSettings({
    required this.volume,
    required this.frequency,
    required this.outputMethod,
  });
  
  /// Create settings with default values
  factory WhistleSettings.defaults() {
    return const WhistleSettings(
      volume: AppConstants.defaultVolume,
      frequency: AppConstants.defaultFrequency,
      outputMethod: AppConstants.outputSpeaker,
    );
  }
  
  /// Create settings from JSON
  factory WhistleSettings.fromJson(Map<String, dynamic> json) {
    return WhistleSettings(
      volume: (json['volume'] as num?)?.toDouble() ?? AppConstants.defaultVolume,
      frequency: (json['frequency'] as num?)?.toDouble() ?? AppConstants.defaultFrequency,
      outputMethod: json['outputMethod'] as String? ?? AppConstants.outputSpeaker,
    );
  }
  
  /// Convert settings to JSON
  Map<String, dynamic> toJson() {
    return {
      'volume': volume,
      'frequency': frequency,
      'outputMethod': outputMethod,
    };
  }
  
  /// Create a copy with modified fields
  WhistleSettings copyWith({
    double? volume,
    double? frequency,
    String? outputMethod,
  }) {
    return WhistleSettings(
      volume: volume ?? this.volume,
      frequency: frequency ?? this.frequency,
      outputMethod: outputMethod ?? this.outputMethod,
    );
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WhistleSettings &&
        other.volume == volume &&
        other.frequency == frequency &&
        other.outputMethod == outputMethod;
  }
  
  @override
  int get hashCode => Object.hash(volume, frequency, outputMethod);
}
