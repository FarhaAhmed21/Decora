import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendOtpEmail(String recipientEmail, String otp) async {
  const String username = 'habibabasel747@gmail.com';
  const String password = 'mpjb cwht pnbt kvgv';

  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = const Address(username, 'Decora Support')
    ..recipients.add(recipientEmail)
    ..subject = 'OTP Verification'
    ..text = 'Your OTP code is: $otp';

  try {
    final sendReport = await send(message, smtpServer);
    print('Email sent: $sendReport');
  } on MailerException catch (e) {
    print('Email not sent. Error: $e');
  }
}
