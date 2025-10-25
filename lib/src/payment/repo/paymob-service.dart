import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaymobService {
  static final String _baseUrl = dotenv.env['PAYMOB_BASE_URL']!;
  static final String _apiKey = dotenv.env['PAYMOB_API_KEY']!;
  static final String _integrationId = dotenv.env['INTEGRATION_ID']!;
  static final String _iframeId = dotenv.env['IFRAME_ID']!;

  /// 1️⃣ احصل على Auth Token
  static Future<String> getAuthToken() async {
    final response = await http.post(
      Uri.parse("$_baseUrl/auth/tokens"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"api_key": _apiKey}),
    );

    final data = jsonDecode(response.body);
    return data["token"];
  }

  /// 2️⃣ أنشئ طلب (Order)
  static Future<int> createOrder({
    required String authToken,
    required int amountCents,
  }) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/ecommerce/orders"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode({
        "auth_token": authToken,
        "delivery_needed": false,
        "amount_cents": amountCents.toString(),
        "currency": "EGP",
        "items": [],
      }),
    );

    final data = jsonDecode(response.body);
    return data["id"]; // order_id
  }

  /// 3️⃣ احصل على Payment Key
  static Future<String> getPaymentKey({
    required String authToken,
    required int orderId,
    required int amountCents,
  }) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/acceptance/payment_keys"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "auth_token": authToken,
        "amount_cents": amountCents.toString(),
        "expiration": 3600,
        "order_id": orderId,
        "billing_data": {
          "apartment": "NA",
          "email": "customer@example.com",
          "floor": "NA",
          "first_name": "Customer",
          "street": "NA",
          "building": "NA",
          "phone_number": "+201000000000",
          "shipping_method": "NA",
          "postal_code": "NA",
          "city": "Cairo",
          "country": "EG",
          "last_name": "Test",
          "state": "NA",
        },
        "currency": "EGP",
        "integration_id": int.parse(_integrationId),
        "lock_order_when_paid": "false",
      }),
    );

    final data = jsonDecode(response.body);
    return data["token"];
  }

  /// 4️⃣ ارجع رابط الدفع الجاهز
  static String getPaymentUrl(String paymentKey) {
    return "https://accept.paymob.com/api/acceptance/iframes/$_iframeId?payment_token=$paymentKey";
  }
}
