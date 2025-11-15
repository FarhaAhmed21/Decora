import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:decora/src/features/notifications/services/notification.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dexterous.com/flutter/local_notifications'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'initialize') return true;
        if (methodCall.method == 'show') return null;
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dexterous.com/flutter/local_notifications'),
      null,
    );
  });

  test('NotificationMessage can call initialize', () async {
    await NotificationMessage.initialize();
  });

  test('NotificationMessage can call showNotification', () async {
    await NotificationMessage.showNotification(
      title: 'Test Title',
      message: 'Test Message',
      id: 1,
    );
  });
}
