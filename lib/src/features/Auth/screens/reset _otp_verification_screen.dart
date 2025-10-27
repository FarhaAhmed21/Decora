import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/features/Auth/screens/reset_password_screen.dart';
import 'package:decora/src/features/Auth/services/sendOTPEmail.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OtpResetScreen extends StatefulWidget {
  final String otp;
  final String email;

  /// usePurpose can be "reset" or "change"
  final String usePurpose;

  const OtpResetScreen({
    super.key,
    required this.otp,
    required this.email,
    this.usePurpose = "reset",
  });

  @override
  State<OtpResetScreen> createState() => _OtpResetScreenState();
}

class _OtpResetScreenState extends State<OtpResetScreen> {
  late String currentOtp;

  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    currentOtp = widget.otp;
  }

  @override
  void dispose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  bool _verifyOtp() {
    String enteredOtp = controllers.map((c) => c.text).join();
    return enteredOtp == currentOtp;
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
  }

  void _resendOtp() async {
    final newOtp = DateTime.now().millisecondsSinceEpoch % 10000;
    currentOtp = newOtp.toString().padLeft(4, '0');

    await sendOtpEmail(widget.email, currentOtp);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.otpSent)),
    );

    for (var c in controllers) {
      c.clear();
    }
    FocusScope.of(context).requestFocus(focusNodes[0]);
  }

  void _handleOtpVerification() {
    final tr = AppLocalizations.of(context)!;

    if (_verifyOtp()) {
      Widget targetScreen;

      if (widget.usePurpose == "change") {
        targetScreen = NewPasswordScreen();
      } else {
        targetScreen = NewPasswordScreen();
      }

      Navigator.push(context, MaterialPageRoute(builder: (_) => targetScreen));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(tr.otpIncorrect)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.background(),
        appBar: AppBar(
          backgroundColor: AppColors.background(),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.innerCardColor(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.pop(context),
                child: Center(
                  child: Icon(
                    isArabic
                        ? FontAwesomeIcons.chevronRight
                        : FontAwesomeIcons.chevronLeft,
                    size: 16,
                    color: AppColors.mainText(),
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            widget.usePurpose == "change"
                ? "Change Your Password"
                : tr.resetPassword,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryText(),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04,
                vertical: size.height * 0.04,
              ),
              child: Column(
                children: [
                  Text(
                    tr.verificationMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondaryText(),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: size.width * 0.14,
                        height: size.width * 0.14,
                        child: TextField(
                          cursorColor: AppColors.primary(),
                          textDirection: TextDirection.ltr,
                          focusNode: focusNodes[index],
                          controller: controllers[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.mainText(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (v) => _onChanged(v, index),
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: focusNodes[index].hasFocus
                                ? AppColors.background()
                                : AppColors.innerCardColor(),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.primary(),
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: size.height * 0.04),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _handleOtpVerification,
                      child: Text(
                        tr.verify,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Text.rich(
                    TextSpan(
                      text: tr.didNotGetOtp,
                      style: TextStyle(color: AppColors.secondaryText()),
                      children: [
                        TextSpan(
                          text: " ${tr.resendOtp}",
                          style: TextStyle(
                            color: AppColors.primary(),
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _resendOtp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
