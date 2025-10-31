import 'package:decora/src/features/Auth/services/auth_service.dart';
import 'package:decora/src/features/home/main_screen.dart';
import 'package:decora/src/features/notifications/services/notifications_services.dart';
import 'package:decora/src/features/notifications/widgets/notifications_container.dart';
import 'package:decora/src/features/notifications/widgets/notifications_text.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final userId = AuthService().currentUser?.uid;
    if (userId == null) {
      debugPrint("⚠️ No user logged in!");
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    debugPrint("ℹ️ Loading notifications for user: $userId");
    try {
      final notis = await _notificationService.getUserNotifications(userId);

      notis.sort(
        (a, b) => b['time'].toString().compareTo(a['time'].toString()),
      );

      if (mounted) {
        setState(() {
          _notifications = notis;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("❌ Error loading notifications: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _formatTime(String fullTime) {
    try {
      final parsed = DateFormat('yyyy-MM-dd HH:mm:ss').parse(fullTime);
      return DateFormat('h:mm a').format(parsed);
    } catch (_) {
      return fullTime;
    }
  }

  String _formatSectionDate(String fullTime) {
    try {
      final now = DateTime.now();
      final parsed = DateFormat('yyyy-MM-dd HH:mm:ss').parse(fullTime);

      final nowDate = DateTime(now.year, now.month, now.day);
      final parsedDate = DateTime(parsed.year, parsed.month, parsed.day);

      final diffDays = nowDate.difference(parsedDate).inDays;

      if (diffDays < 0) return "Unknown";
      if (diffDays == 0) return "Today";
      if (diffDays == 1) return "Yesterday";
      if (diffDays < 7) return "Last Week";
      if (diffDays < 30) return "Last Month";
      return "Older";
    } catch (_) {
      return "Unknown";
    }
  }

  List<Widget> _buildGroupedNotifications() {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final noti in _notifications) {
      final section = _formatSectionDate(noti['time']);
      grouped.putIfAbsent(section, () => []).add(noti);
    }

    const order = [
      "Today",
      "Yesterday",
      "Last Week",
      "Last Month",
      "Older",
      "Unknown",
    ];

    final List<Widget> widgets = [];

    for (final section in order) {
      final notis = grouped[section];
      if (notis == null || notis.isEmpty) continue;

      widgets.add(NotificationsText(text: section));
      widgets.add(const SizedBox(height: 8));

      for (final noti in notis) {
        widgets.add(
          NoificationsContainer(
            title: noti['title'] ?? '',
            message: noti['body'] ?? '',
            time: _formatTime(noti['time']) ?? '',
            icon: noti['isRead'] == false ? 0 : 1,
          ),
        );
        widgets.add(const SizedBox(height: 8));
      }

      widgets.add(const SizedBox(height: 16));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final userId = AuthService().currentUser?.uid;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        onBackPressed: () async {
          if (userId != null) {
            await _notificationService.markAllNotificationsAsRead(userId);
          }
          MainLayout.currentIndex = 1;
          Navigator.pop(context);
        },
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
          ? Center(
              child: Text(
                "No notifications yet.",
                style: TextStyle(
                  color: AppColors.mainText(),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(children: _buildGroupedNotifications()),
            ),
    );
  }
}
