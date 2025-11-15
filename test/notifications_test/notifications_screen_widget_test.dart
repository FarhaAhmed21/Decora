import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// A fake version of the NotificationsScreen that takes notifications as a parameter
class TestNotificationsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> notifications;
  final bool isLoading;

  const TestNotificationsScreen({
    super.key,
    required this.notifications,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : notifications.isEmpty
                ? const Center(child: Text("No notifications yet."))
                : ListView(
                    children: notifications
                        .map(
                          (n) => ListTile(
                            title: Text(n['title'] ?? ''),
                            subtitle: Text(n['body'] ?? ''),
                          ),
                        )
                        .toList(),
                  ),
      ),
    );
  }
}

void main() {
  testWidgets('shows loading indicator', (tester) async {
    await tester.pumpWidget(const TestNotificationsScreen(
      notifications: [],
      isLoading: true,
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows "No notifications yet." when empty', (tester) async {
    await tester.pumpWidget(const TestNotificationsScreen(
      notifications: [],
      isLoading: false,
    ));

    expect(find.text("No notifications yet."), findsOneWidget);
  });

  testWidgets('shows notifications', (tester) async {
    await tester.pumpWidget(const TestNotificationsScreen(
      notifications: [
        {"title": "Test Title", "body": "Test Body"},
      ],
      isLoading: false,
    ));

    expect(find.text("Test Title"), findsOneWidget);
    expect(find.text("Test Body"), findsOneWidget);
  });
}
