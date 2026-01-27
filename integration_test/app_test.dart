import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bibliospace/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full Flow: Login -> Home', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final emailField = find.byType(TextFormField).at(0); 
    final passField = find.byType(TextFormField).at(1);
    final loginButton = find.byType(ElevatedButton);

    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passField, 'password123');
    await tester.pumpAndSettle();

    await tester.tap(loginButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Welcome Back!'), findsNothing);
  });
}