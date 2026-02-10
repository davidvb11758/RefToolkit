import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../domain/services/whistle_service.dart';

/// Middle 80% work area for Whistle mode: thick red border, semi-transparent red interior.
/// Press = sound on, release = sound off (full area is touch target).
class WhistleModeContent extends StatelessWidget {
  const WhistleModeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WhistleService>(
      builder: (context, whistleService, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) {
            HapticFeedback.mediumImpact();
            whistleService.onButtonPressed();
          },
          onTapUp: (_) {
            whistleService.onButtonReleased();
          },
          onTapCancel: () {
            whistleService.onButtonReleased();
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
                width: 8,
              ),
              color: Colors.red.withOpacity(0.25),
            ),
            child: Center(
              child: Text(
                whistleService.isPressed ? 'WHISTLE ACTIVE' : 'Press to Whistle',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.red.shade900,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}
