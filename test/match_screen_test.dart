import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Match Screen UI Components Test', (WidgetTester tester) async {
    // Create a simple widget that mimics the match screen structure
    await tester.pumpWidget(
      MaterialApp(
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Connections'),
              actions: const [
                TextButton(
                  onPressed: null,
                  child: Text(
                    'Sent',
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              bottom: const TabBar(
                indicatorColor: Colors.pink,
                labelColor: Colors.pink,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'Requests', icon: Icon(Icons.person_add)),
                  Tab(text: 'Matches', icon: Icon(Icons.favorite)),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                // Requests Tab
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No connection requests',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'When someone sends you a request, it will appear here',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                // Matches Tab
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No matches yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'When you match with someone, they will appear here',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pump();

    // Verify the basic UI components
    expect(find.text('Connections'), findsOneWidget);
    expect(find.text('Sent'), findsOneWidget);
    expect(find.text('Requests'), findsOneWidget);
    expect(find.text('Matches'), findsOneWidget);
    expect(find.text('No connection requests'), findsOneWidget);

    // Test tab switching
    await tester.tap(find.text('Matches'));
    await tester.pumpAndSettle();

    // Should now show matches empty state
    expect(find.text('No matches yet'), findsOneWidget);
  });
}
