import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/features/Auth/screens/reset_password_screen.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OtpResetScreen extends StatefulWidget {
  const OtpResetScreen({super.key});

  @override
  State<OtpResetScreen> createState() => _OtpResetScreenState();
}

class _OtpResetScreenState extends State<OtpResetScreen> {
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

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

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
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
                color: const Color(0xFFF6F6F6),
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
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            tr.resetPassword,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                tr.verificationMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryText(),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: size.width * 0.14,
                      height: size.width * 0.14,
                      child: TextField(
                        cursorColor: AppColors.primary(),
                        focusNode: focusNodes[index],
                        controller: controllers[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => _onChanged(v, index),
                        decoration: InputDecoration(
                          counterText: "",
                          filled: true,
                          fillColor: focusNodes[index].hasFocus
                              ? Colors.white
                              : const Color(0xFFF6F6F6),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
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
              ),
              const SizedBox(height: 40),
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
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NewPasswordScreen(),
                    ),
                  ),
                  child: Text(
                    tr.verify,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
