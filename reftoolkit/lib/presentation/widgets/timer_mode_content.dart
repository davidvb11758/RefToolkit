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
    return Consumer<TimerService>(
      builder: (context, timerService, child) {
        return Row(
          children: [
            // Left half: time presets
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                children: AppConstants.timerPresetSeconds.map((seconds) {
                  final isSelected =
                      timerService.selectedDurationSeconds == seconds;
                  return ListTile(
                    title: Text(
                      _formatPreset(seconds),
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.5),
                    onTap: () => timerService.setDuration(seconds),
                  );
                }).toList(),
              ),
            ),
            // Right half: timer display + buttons
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      timerService.formattedRemaining,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontFeatures: [const FontFeature.tabularFigures()],
                          ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton.icon(
                          onPressed: () {
                            if (timerService.isRunning) {
                              timerService.stop();
                            } else {
                              timerService.start();
                            }
                          },
                          icon: Icon(
                            timerService.isRunning ? Icons.stop : Icons.play_arrow,
                          ),
                          label: Text(timerService.isRunning ? 'Stop' : 'Start'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () => timerService.reset(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Reset'),
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
  }
}
