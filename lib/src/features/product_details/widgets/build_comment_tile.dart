import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/src/features/Auth/models/user_model.dart';
import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../models/product_model.dart';

Widget BuildCommentTile(Comment comment) {
  return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
    future: FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: comment.userid)
        .get(),
    builder: (context, snapshot) {
      // أثناء التحميل
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      // في حالة الخطأ
      if (snapshot.hasError) {
        return const Text("حدث خطأ أثناء تحميل بيانات المستخدم");
      }

      // في حالة عدم وجود بيانات
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Text("المستخدم غير موجود");
      }

      // جلب بيانات المستخدم
      final userData = snapshot.data!.docs.first.data();
      final user = UserModel.fromMap(userData);

      // واجهة التعليق
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة البروفايل
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  (user.photoUrl != null && user.photoUrl!.isNotEmpty)
                  ? NetworkImage(user.photoUrl!)
                  : const AssetImage('assets/images/default_user.png')
                        as ImageProvider,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppColors.cardColor(context),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الاسم والتاريخ
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            user.name ?? "user un defined",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.mainText(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          comment.date,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.secondaryText(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // نص التعليق
                    Text(
                      comment.text,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.secondaryText(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
