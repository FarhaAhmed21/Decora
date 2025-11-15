import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/src/features/Auth/services/auth_service.dart';
import 'package:decora/src/features/notifications/services/notification.dart';
import 'package:intl/intl.dart';

class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final userId = AuthService().currentUser?.uid;

  /// Add a new notification
  static Future<void> addNotification(String title, String body) async {
    final formattedTime = DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(DateTime.now());
    final newNotification = {
      'title': title,
      'body': body,
      'time': formattedTime,
      'isRead': false,
    };

    final query = await _firestore
        .collection('notifications')
        .where('id', isEqualTo: userId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      await _firestore.collection('notifications').add({
        'id': userId,
        'notifications': [newNotification],
      });
    } else {
      // Update the existing user's notifications array
      final docRef = query.docs.first.reference;
      await docRef.update({
        'notifications': FieldValue.arrayUnion([newNotification]),
      });
    }
    NotificationMessage.showNotification(title: title, message: body);
  }

  // Get all notifications for a user
  Future<List<Map<String, dynamic>>> getUserNotifications() async {
    final query = await _firestore
        .collection('notifications')
        .where('id', isEqualTo: userId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      print("User not found in Firestore");
      return [];
    }

    final data = query.docs.first.data();
    if (data['notifications'] == null) {
      print("No notifications found for this user");
      return [];
    }

    final notifications = List<Map<String, dynamic>>.from(
      data['notifications'],
    );
    for (int i = 0; i < notifications.length; i++) {
      notifications[i]['count'] = i;
    }

    return notifications;
  }

  // Get the number of unread notifications for a user
  Future<int> getUnreadNotificationsCount() async {
    final query = await _firestore
        .collection('notifications')
        .where('id', isEqualTo: userId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      print("User not found in Firestore");
      return 0;
    }

    final data = query.docs.first.data();
    if (data['notifications'] == null) {
      print("No notifications found for this user");
      return 0;
    }

    final List notifications = List.from(data['notifications']);
    final unreadCount = notifications.where((n) => n['isRead'] == false).length;
    return unreadCount;
  }

  /// Mark all notifications as read for a user
  Future<void> markAllNotificationsAsRead() async {
    final query = await _firestore
        .collection('notifications')
        .where('id', isEqualTo: userId)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      print("User not found in Firestore");
      return;
    }

    final docRef = query.docs.first.reference;
    final data = query.docs.first.data();

    if (data['notifications'] == null) {
      print("No notifications found for this user");
      return;
    }

    List notifications = List.from(data['notifications']);
    for (var n in notifications) {
      n['isRead'] = true;
    }

    await docRef.update({'notifications': notifications});
    print("All notifications marked as read for user $userId");
  }
}
