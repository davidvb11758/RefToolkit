import 'package:audioplayers/audioplayers.dart';
import 'audio_output_interface.dart';

/// Speaker output implementation using device speaker (audioplayers).
class SpeakerOutput implements AudioOutputInterface {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  String get name => 'Speaker';

  @override
  bool get isPlaying => _isPlaying;

  @override
  Future<void> initialize() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  @override
  Future<void> playWhistle(double frequency, double volume) async {
    try {
      _isPlaying = true;
      _audioPlayer.stop();

      await _audioPlayer.setVolume(volume);

      final baseFrequency = 3000.0;
      final playbackRate = (frequency / baseFrequency).clamp(0.5, 2.0);
      await _audioPlayer.setPlaybackRate(playbackRate);

      await _audioPlayer.play(AssetSource('sounds/whistle.mp3'));
    } catch (e) {
      _isPlaying = false;
    }
  }

  @override
  Future<void> stopWhistle() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      _isPlaying = false;
    }
  }

  @override
  Future<void> dispose() async {
    await _audioPlayer.stop();
    await _audioPlayer.dispose();
    _isPlaying = false;
  }
}
