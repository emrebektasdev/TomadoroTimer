// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:tomadoro/main.dart';
import 'package:tomadoro/core/services/sound_service.dart';

void main() {
  testWidgets('Tomadoro app smoke test', (WidgetTester tester) async {
    // Create sound service for test
    final soundService = SoundService();

    // Build our app and trigger a frame.
    await tester.pumpWidget(TomadoroApp(soundService: soundService));

    // Verify that the app loads
    expect(find.text('Tomadoro'), findsOneWidget);
  });
}
