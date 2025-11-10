import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/features/Auth/models/user_model.dart';
import 'package:decora/src/features/Auth/screens/verification_success_screen.dart';
import 'package:decora/src/features/Auth/services/auth_service.dart';
import 'package:decora/src/features/Auth/services/firestore_service.dart';
import 'package:decora/src/features/Auth/services/sendOTPEmail.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String otp;
  final String email;
  final String password;
  final String name;

  const OtpVerificationScreen({
    super.key,
    required this.otp,
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  bool _isResending = false;
  late String _currentOtp;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();

    _currentOtp = widget.otp;
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

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
  }

  String get _enteredOtp => controllers.map((c) => c.text.trim()).join();

  Future<void> _verifyOtp() async {
    final tr = AppLocalizations.of(context)!;

    if (_enteredOtp == _currentOtp) {
      final user = await _authService.signUpWithEmail(
        widget.email,
        widget.password,
        widget.name,
      );
      if (user != null) {
        final userModel = UserModel(
          id: user.uid,
          name: widget.name,
          email: widget.email,
          photoUrl:
              "https://cvhrma.org/wp-content/uploads/2015/07/default-profile-photo.jpg",
        );

        await FirestoreService().saveUserData(userModel);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VerificationSuccessScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(tr.otpIncorrect)));
    }
  }

  String _generateOtp() {
    final random = DateTime.now().millisecondsSinceEpoch % 10000;
    return random.toString().padLeft(4, '0');
  }

  Future<void> _resendOtp() async {
    setState(() => _isResending = true);

    final newOtp = _generateOtp();

    await sendOtpEmail(widget.email, newOtp);

    setState(() {
      _isResending = false;
      _currentOtp = newOtp;
      for (var c in controllers) {
        c.clear();
      }
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('OTP sent again')));
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
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            tr.emailVerification,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryText(),
            ),
          ),
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
                    color: AppColors.mainText(),
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.04,
              vertical: size.height * 0.04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  tr.verificationMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.secondaryText(),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: size.width * 0.14,
                      height: size.width * 0.14,
                      child: TextField(
                        textDirection: TextDirection.ltr,
                        cursorColor: AppColors.primary(),
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
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _verifyOtp,
                    child: Text(
                      tr.verify,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Center(
                  child: GestureDetector(
                    onTap: _isResending ? null : _resendOtp,
                    child: Text.rich(
                      TextSpan(
                        text: tr.didNotGetOtp,
                        style: TextStyle(color: AppColors.secondaryText()),
                        children: [
                          TextSpan(
                            text: " ${tr.resendOtp}",
                            style: TextStyle(
                              color: _isResending
                                  ? Colors.grey
                                  : AppColors.primary(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
