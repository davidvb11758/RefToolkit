import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/services/timer_service.dart';

/// Middle 80% work area for Timer mode: left = preset list, right = timer + Start/Stop + Reset.
class TimerModeContent extends StatelessWidget {
  const TimerModeContent({super.key});

  static String _formatPreset(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final workHeight = constraints.maxHeight;
        final timerFontSize = workHeight * 0.60;

        return Consumer<TimerService>(
          builder: (context, timerService, child) {
            return Row(
              children: [
                // Left 25%: time presets spread vertically (blue text, lighter blue when selected)
                Expanded(
                  flex: 1,
                  child: Column(
                    children: AppConstants.timerPresetSeconds.map((seconds) {
                      final isSelected =
                          timerService.selectedDurationSeconds == seconds;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Material(
                            color: isSelected
                                ? Colors.blue.shade100
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              onTap: () {
                                timerService.setDuration(seconds);
                                timerService.start();
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Center(
                                child: Text(
                                  _formatPreset(seconds),
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Right 75%: timer display + buttons
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          timerService.formattedRemaining,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                fontSize: timerFontSize,
                                fontFeatures: const [FontFeature.tabularFigures()],
                              ),
                        ),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Start (green) / Stop (red) button - twice as wide
                            SizedBox(
                              width: 280,
                              height: 64,
                              child: FilledButton.icon(
                                onPressed: () {
                                  if (timerService.isRunning) {
                                    timerService.stop();
                                  } else {
                                    timerService.start();
                                  }
                                },
                                icon: Icon(
                                  timerService.isRunning ? Icons.stop : Icons.play_arrow,
                                  size: 32,
                                ),
                                label: Text(
                                  timerService.isRunning ? 'Stop' : 'Start',
                                  style: const TextStyle(fontSize: 22),
                                ),
                                style: FilledButton.styleFrom(
                                  backgroundColor: timerService.isRunning ? Colors.red : Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                                ),
                              ),
                            ),
                            // Reset button - blue, right aligned
                            SizedBox(
                              height: 64,
                              child: FilledButton.icon(
                                onPressed: () => timerService.reset(),
                                icon: const Icon(Icons.refresh, size: 28),
                                label: const Text('Reset', style: TextStyle(fontSize: 20)),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
