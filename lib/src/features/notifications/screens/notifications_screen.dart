import 'package:decora/src/features/notifications/widgets/notifications_container.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(72),
        child: CustomAppBar(title: 'Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Today",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            for (int i = 0; i < 4; i++)
              NoificationsContainer(
                title: "Accepted",
                message: "Your booking has been accepted.",
                time: "3:45 AM",
              ),
            const SizedBox(height: 8),
            const Text(
              "Yesterday",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            for (int i = 0; i < 4; i++)
              NoificationsContainer(
                title: "Accepted",
                message: "Your booking has been accepted.",
                time: "3:45 AM",
                icon: 1,
              ),
          ],
        ),
      ),
    );
  }
}
