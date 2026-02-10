import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/services/whistle_service.dart';

/// Large touch-aware whistle button widget
class WhistleButton extends StatelessWidget {
  final double size;
  
  const WhistleButton({
    super.key,
    required this.size,
  });
  
  @override
  Widget build(BuildContext context) {
    return Consumer<WhistleService>(
      builder: (context, whistleService, child) {
        final isPressed = whistleService.isPressed;
        
        return GestureDetector(
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPressed
                  ? AppColors.buttonPressed
                  : Theme.of(context).colorScheme.primary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isPressed ? 0.1 : 0.3),
                  blurRadius: isPressed ? 10 : 20,
                  offset: Offset(0, isPressed ? 2 : 8),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.sports,
                size: size * 0.4,
                color: isPressed
                    ? AppColors.refereeBlack
                    : Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        );
      },
    );
  }
}
