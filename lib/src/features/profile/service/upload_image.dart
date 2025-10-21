import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImageUploader {
  static const String _apiKey =
      'faf1059ad01f9e1db7908d3f9ed56cdc'; // 🔑 حط مفتاحك هنا

  /// ترفع الصورة لـ ImgBB وترجع لينك الصورة الجاهز
  static Future<String?> uploadToImgBB(File imageFile) async {
    try {
      final uri = Uri.parse('https://api.imgbb.com/1/upload?key=$_apiKey');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = json.decode(resBody);
        final imageUrl = data['data']['url'] as String;
        return imageUrl;
      } else {
        print('❌ فشل رفع الصورة: ${response.statusCode}');
        print(resBody);
        return null;
      }
    } catch (e) {
      print('⚠️ خطأ أثناء رفع الصورة: $e');
      return null;
    }
  }
}
