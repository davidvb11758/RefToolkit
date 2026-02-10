import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/services/whistle_service.dart';

/// Settings screen for configuring volume, tone, and output method
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<WhistleService>(
        builder: (context, whistleService, child) {
          final settings = whistleService.settings;
          
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Volume Section
              const Text(
                'Volume',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.volume_down),
                  Expanded(
                    child: Slider(
                      value: settings.volume,
                      min: AppConstants.minVolume,
                      max: AppConstants.maxVolume,
                      divisions: 100,
                      label: '${(settings.volume * 100).round()}%',
                      onChanged: (value) {
                        whistleService.updateVolume(value);
                      },
                    ),
                  ),
                  const Icon(Icons.volume_up),
                ],
              ),
              Text(
                'Current: ${(settings.volume * 100).round()}%',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Frequency/Tone Section
              const Text(
                'Tone (Pitch)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Low'),
                  Expanded(
                    child: Slider(
                      value: settings.frequency,
                      min: AppConstants.minFrequency,
                      max: AppConstants.maxFrequency,
                      divisions: 20,
                      label: '${settings.frequency.round()} Hz',
                      onChanged: (value) {
                        whistleService.updateFrequency(value);
                      },
                    ),
                  ),
                  const Text('High'),
                ],
              ),
              Text(
                'Current: ${settings.frequency.round()} Hz',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Output Method Section
              const Text(
                'Output Method',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Device Speaker'),
                      subtitle: const Text('Use built-in speaker'),
                      value: AppConstants.outputSpeaker,
                      groupValue: settings.outputMethod,
                      onChanged: (value) {
                        if (value != null) {
                          whistleService.updateOutputMethod(value);
                        }
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Bluetooth'),
                      subtitle: const Text('Connect to Bluetooth device (Coming Soon)'),
                      value: AppConstants.outputBluetooth,
                      groupValue: settings.outputMethod,
                      onChanged: null, // Disabled for now
                    ),
                    RadioListTile<String>(
                      title: const Text('USB'),
                      subtitle: const Text('Connect to USB device (Coming Soon)'),
                      value: AppConstants.outputUsb,
                      groupValue: settings.outputMethod,
                      onChanged: null, // Disabled for now
                    ),
                    RadioListTile<String>(
                      title: const Text('RF (Radio Frequency)'),
                      subtitle: const Text('Wireless transmitter (Coming Soon)'),
                      value: AppConstants.outputRf,
                      groupValue: settings.outputMethod,
                      onChanged: null, // Disabled for now
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Test Button
              ElevatedButton.icon(
                onPressed: () {
                  whistleService.testWhistle();
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Test Whistle'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Reset to Defaults Button
              OutlinedButton.icon(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Reset to Defaults'),
                      content: const Text(
                        'Are you sure you want to reset all settings to default values?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  );
                  
                  if (confirmed == true) {
                    await whistleService.resetToDefaults();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Settings reset to defaults'),
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.restore),
                label: const Text('Reset to Defaults'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Info Section
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Tips',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('• Press and hold the whistle button to activate'),
                      const Text('• Release to stop the whistle'),
                      const Text('• Maximum press duration: 3 seconds'),
                      const Text('• You can press repeatedly for quick bursts'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
