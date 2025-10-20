import 'dart:io';
import 'package:decora/src/features/Auth/models/user_model.dart';
import 'package:decora/src/features/Auth/services/firestore_service.dart';
import 'package:decora/src/features/profile/service/upload_image.dart';

class Savechanges {
  Future<void> savechange(UserModel user, File? photo) async {
    String? url;

    // لو المستخدم اختار صورة جديدة
    if (photo != null) {
      url = await ImageUploader.uploadToImgBB(photo);
      user.photoUrl = url; // ← هنا نحدّث لينك الصورة الجديدة
    }

    // نحفظ البيانات في الـ Firestore
    await FirestoreService().saveUserData(user);
  }
}
