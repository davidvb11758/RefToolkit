import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:reftoolkit/main.dart';
import 'package:reftoolkit/domain/services/whistle_service.dart';
import 'package:reftoolkit/data/repositories/settings_repository.dart';
import 'package:reftoolkit/services/storage/settings_storage_service.dart';
import 'package:reftoolkit/services/audio/audio_service.dart';

void main() {
  testWidgets('RefToolkit app smoke test', (WidgetTester tester) async {
    // Initialize services for testing
    final storageService = SettingsStorageService();
    await storageService.initialize();
    
    final settingsRepository = SettingsRepository(storageService);
    final audioService = AudioService();
    final whistleService = WhistleService(audioService, settingsRepository);
    
    await whistleService.initialize();
    
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: whistleService),
        ],
        child: const RefToolkitApp(),
      ),
    );
    
    // Verify that the app title is displayed
    expect(find.text('RefToolkit'), findsOneWidget);
    
    // Verify that the press instruction is displayed
    expect(find.text('Press to Whistle'), findsOneWidget);
    
    // Verify that settings button exists
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
  
  testWidgets('Settings screen navigation test', (WidgetTester tester) async {
    final storageService = SettingsStorageService();
    await storageService.initialize();
    
    final settingsRepository = SettingsRepository(storageService);
    final audioService = AudioService();
    final whistleService = WhistleService(audioService, settingsRepository);
    
    await whistleService.initialize();
    
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: whistleService),
        ],
        child: const RefToolkitApp(),
      ),
    );
    
    // Tap the settings button
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    
    // Verify that we navigated to the settings screen
    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Volume'), findsOneWidget);
    expect(find.text('Tone (Pitch)'), findsOneWidget);
  });
}
