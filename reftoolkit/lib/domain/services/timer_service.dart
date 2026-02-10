import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/constants/app_constants.dart';

/// Countdown timer service: selected duration, remaining time, start/stop/reset.
class TimerService extends ChangeNotifier {
  int _selectedDurationSeconds = AppConstants.defaultTimerDurationSeconds;
  int _remainingSeconds = AppConstants.defaultTimerDurationSeconds;
  bool _isRunning = false;
  Timer? _ticker;

  int get selectedDurationSeconds => _selectedDurationSeconds;
  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;

  /// Formatted "min:sec" for display (e.g. "1:30").
  String get formattedRemaining {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  /// Set duration (from preset) and optionally reset display.
  void setDuration(int seconds) {
    if (_selectedDurationSeconds == seconds) return;
    _selectedDurationSeconds = seconds;
    _remainingSeconds = seconds;
    _stopTicker();
    _isRunning = false;
    notifyListeners();
  }

  void start() {
    if (_isRunning || _remainingSeconds <= 0) return;
    _isRunning = true;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    notifyListeners();
  }

  void stop() {
    _stopTicker();
    _isRunning = false;
    notifyListeners();
  }

  void reset() {
    _stopTicker();
    _isRunning = false;
    _remainingSeconds = _selectedDurationSeconds;
    notifyListeners();
  }

  void _tick() {
    if (_remainingSeconds <= 0) {
      _stopTicker();
      _isRunning = false;
      notifyListeners();
      return;
    }
    _remainingSeconds--;
    notifyListeners();
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  @override
  void dispose() {
    _stopTicker();
    super.dispose();
  }
}
