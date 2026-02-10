import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/themes/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'data/repositories/settings_repository.dart';
import 'services/storage/settings_storage_service.dart';
import 'services/audio/audio_service.dart';
import 'domain/services/whistle_service.dart';
import 'domain/services/timer_service.dart';
import 'presentation/screens/main_screen.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations (allow all)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  // Initialize services
  final storageService = SettingsStorageService();
  await storageService.initialize();
  
  final settingsRepository = SettingsRepository(storageService);
  final audioService = AudioService();
  final whistleService = WhistleService(audioService, settingsRepository);
  final timerService = TimerService();
  
  // Initialize whistle service
  await whistleService.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: whistleService),
        ChangeNotifierProvider.value(value: timerService),
      ],
      child: const RefToolkitApp(),
    ),
  );
}

class RefToolkitApp extends StatelessWidget {
  const RefToolkitApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}
