import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:keeptrack_flutter/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Show fab button', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      final Finder button = find.byType(FloatingActionButton);
      expect(button, findsOneWidget);
    });
  });
}
