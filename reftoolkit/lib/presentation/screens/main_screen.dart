import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../widgets/whistle_mode_content.dart';
import '../widgets/timer_mode_content.dart';
import 'settings_screen.dart';

/// Main screen: top 10% mode selector, middle 80% work area, bottom 10% scoreboard.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _mode = AppConstants.modeWhistle;

  @override
  Widget build(BuildContext context) {
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final topHeight = height * AppConstants.topBandHeightFraction;
          final workHeight = height * AppConstants.workAreaHeightFraction;
          final bottomHeight = height * AppConstants.bottomBandHeightFraction;
          return Column(
            children: [
              // Top 10%: mode selector
              SizedBox(
                height: topHeight,
                child: Center(
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment<String>(
                        value: AppConstants.modeWhistle,
                        label: Text('Whistle'),
                        icon: Icon(Icons.sports),
                      ),
                      ButtonSegment<String>(
                        value: AppConstants.modeTimer,
                        label: Text('Timer'),
                        icon: Icon(Icons.timer),
                      ),
                    ],
                    selected: {_mode},
                    onSelectionChanged: (Set<String> selected) {
                      setState(() {
                        _mode = selected.first;
                      });
                    },
                  ),
                ),
              ),
              // Middle 80%: work area for current mode
              SizedBox(
                height: workHeight,
                width: double.infinity,
                child: _mode == AppConstants.modeWhistle
                    ? const WhistleModeContent()
                    : const TimerModeContent(),
              ),
              // Bottom 10%: scoreboard placeholder
              Container(
                height: bottomHeight,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                child: Text(
                  'Scoreboard',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
