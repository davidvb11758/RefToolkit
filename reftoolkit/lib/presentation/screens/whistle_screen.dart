import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/services/whistle_service.dart';
import '../widgets/whistle_button.dart';
import 'settings_screen.dart';

/// Main screen with the large whistle button
class WhistleScreen extends StatelessWidget {
  const WhistleScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > AppConstants.tabletBreakpoint;
    
    // Calculate button size based on device type
    final buttonSizePercent = isTablet
        ? AppConstants.tabletButtonSizePercent
        : AppConstants.phoneButtonSizePercent;
    
    final buttonSize = screenSize.width * buttonSizePercent;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<WhistleService>(
                  builder: (context, whistleService, child) {
                    return Column(
                      children: [
                        WhistleButton(size: buttonSize),
                        const SizedBox(height: 32),
                        Text(
                          whistleService.isPressed
                              ? 'WHISTLE ACTIVE'
                              : 'Press to Whistle',
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: whistleService.isPressed
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Volume: ${(whistleService.settings.volume * 100).round()}%',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'Tone: ${whistleService.settings.frequency.round()} Hz',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
