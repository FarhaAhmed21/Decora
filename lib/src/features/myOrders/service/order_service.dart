import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/features/Auth/services/auth_service.dart';
import 'package:decora/src/features/notifications/services/notifications_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final String? _currentUid = AuthService().currentUser?.uid;

  // =========================================================================
  // 1. GET USER ORDERS
  // =========================================================================
  static Future<List<Map<String, dynamic>>> getUserOrders() async {
    if (_currentUid == null) return [];

    final snap = await _firestore
        .collection('orders')
        .where('id', isEqualTo: _currentUid)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return [];

    final orderList = snap.docs.first['orderList'] as List<dynamic>? ?? [];
    return orderList.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  // =========================================================================
  // 2. ADD ORDER FROM CART — FIXED FOREVER
  // =========================================================================
  static Future<void> addOrderFromCart({
    required String amount,
    required bool isShared,
    required BuildContext context,
  }) async {
    if (_currentUid == null) throw Exception("No user logged in");

    final today = DateFormat('dd MMM, yyyy').format(DateTime.now());

    final cartQuery = _firestore
        .collection('carts')
        .where('isShared', isEqualTo: isShared)
        .where('userIds', arrayContains: _currentUid)
        .limit(1);

    final cartSnap = await cartQuery.get();
    if (cartSnap.docs.isEmpty) throw Exception("Cart not found");

    final cartDoc = cartSnap.docs.first;
    final cartRef = cartDoc.reference;
    final cartData = cartDoc.data() as Map<String, dynamic>;

    final productsMap =
        (cartData['products'] as Map?)?.cast<String, dynamic>() ?? {};
    final productsId = productsMap.keys.toList();
    final targetUids = List<String>.from(cartData['userIds'] as List);

    await _firestore.runTransaction((transaction) async {
      String? lastOrderId;

      for (final uid in targetUids) {
        final orderQuery = _firestore
            .collection('orders')
            .where('id', isEqualTo: uid)
            .limit(1);
        final orderSnap = await orderQuery.get();

        final orderRef = orderSnap.docs.isEmpty
            ? _firestore.collection('orders').doc()
            : orderSnap.docs.first.reference;

        int maxNum = 0;
        if (!orderSnap.docs.isEmpty) {
          final list =
              orderSnap.docs.first['orderList'] as List<dynamic>? ?? [];
          for (var o in list) {
            final id = o['id'] as String?;
            if (id?.startsWith('DO') == true) {
              final n = int.tryParse(id!.substring(2));
              if (n != null && n > maxNum) maxNum = n;
            }
          }
        }

        final newOrderId = 'DO${maxNum + 1}';
        lastOrderId = newOrderId;

        final newOrder = {
          'amount': amount,
          'date': today,
          'id': newOrderId,
          'productsId': productsId,
        };

        if (orderSnap.docs.isEmpty) {
          transaction.set(orderRef, {
            'id': uid,
            'orderList': [newOrder],
          });
        } else {
          transaction.update(orderRef, {
            'orderList': FieldValue.arrayUnion([newOrder]),
          });
        }
      }

      if (lastOrderId != null) {
        await NotificationService.addNotification(
          AppLocalizations.of(context)!.order_placed_successfully +
              " #$lastOrderId",
          AppLocalizations.of(context)!.order_received_message,
        );
      }

      transaction.delete(cartRef);
    });
  }

  // =========================================================================
  // 3. GET SPECIFIC ORDER BY ID FOR CURRENT USER
  // =========================================================================
  static Future<Map<String, dynamic>?> getOrderById(String orderId) async {
    if (_currentUid == null) return null;

    final snap = await _firestore
        .collection('orders')
        .where('id', isEqualTo: _currentUid)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return null;

    final orderList = snap.docs.first['orderList'] as List<dynamic>? ?? [];

    final order = orderList.firstWhere(
      (o) => (o['id'] as String?) == orderId,
      orElse: () => null,
    );

    return order != null ? Map<String, dynamic>.from(order as Map) : null;
  }
}
