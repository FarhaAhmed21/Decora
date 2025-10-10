// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World';

  @override
  String get welcome => 'Welcome to Decora';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get orLoginWith => 'Or login with';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get createAccount => 'Create Account';

  @override
  String get accessCollections =>
      'Access exclusive collections and personalized ideas';

  @override
  String get username => 'Username';

  @override
  String get emailVerification => 'Email Verification';

  @override
  String get verificationMessage =>
      'We’ve sent a verification email to your Registered email address';

  @override
  String get verify => 'Verify';

  @override
  String get didNotGetOtp => 'Didn’t Get OTP?';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get verificationSuccess => 'Verification Successful!';

  @override
  String get verificationSuccessMessage =>
      'Your account has been verified successfully. Welcome to Decora’s curated collections';

  @override
  String get backToLogin => 'Back To Login';

  @override
  String get resetPassword => 'Reset your password';

  @override
  String get enterEmailOrPhone =>
      'Enter your registered email or phone number to reset your password';

  @override
  String get continueButton => 'Continue';

  @override
  String get otpSentMessage =>
      'We’ve sent a verification email to your Registered email address';

  @override
  String get didNotReceiveOtp => 'Didn’t Get OTP?';

  @override
  String get resend => 'Resend OTP';

  @override
  String get createNewPassword => 'Create New Password';

  @override
  String get enterNewPassword => 'Please enter your new password below';

  @override
  String get newPassword => 'New Password';

  @override
  String get saveNewPassword => 'Save New Password';

  @override
  String get passwordResetSuccess => 'Password Reset\nSuccessfully!';

  @override
  String get youCanLoginNow => 'You can now log in with your new password';
}
