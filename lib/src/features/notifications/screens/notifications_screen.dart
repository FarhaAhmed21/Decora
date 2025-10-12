import 'package:decora/src/features/notifications/widgets/notifications_container.dart';
import 'package:decora/src/features/notifications/widgets/notifications_text.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> notificationTimes = [
      "Today",
      "Yesterday",
      "Last Week",
      "Last Month",
      "Last Year",
      "Older",
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: 'Notifications'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          itemCount: notificationTimes.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NotificationsText(text: notificationTimes[index]),

                // TEMP: showing 2 notifications for each section
                for (int i = 0; i < 2; i++)
                  NoificationsContainer(
                    title: "Accepted",
                    message: "Your booking has been accepted.",
                    time: "3:45 AM",
                    icon: i % 2,
                  ),

                const SizedBox(height: 8),
              ],
            );
          },
        ),
      ),
    );
  }
}
