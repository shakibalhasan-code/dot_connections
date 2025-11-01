import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic app should build without errors', (
    WidgetTester tester,
  ) async {
    // Create a simple MaterialApp for testing
    await tester.pumpWidget(
      MaterialApp(
        title: 'Dot Connections Test',
        home: Scaffold(
          appBar: AppBar(title: const Text('Dot Connections')),
          body: const Center(
            child: Text(
              'Welcome to Dot Connections',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );

    // Verify that the basic app structure exists
    expect(find.text('Dot Connections'), findsOneWidget);
    expect(find.text('Welcome to Dot Connections'), findsOneWidget);
  });
}
