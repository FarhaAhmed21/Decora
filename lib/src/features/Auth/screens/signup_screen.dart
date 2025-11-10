import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/features/Auth/screens/otp_verification_screen.dart';
import 'package:decora/src/features/Auth/services/sendOTPEmail.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String generateOtp() {
    final random = DateTime.now().millisecondsSinceEpoch % 10000;
    return random.toString().padLeft(4, '0');
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final otp = generateOtp();
      await sendOtpEmail(_emailController.text.trim(), otp);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            otp: otp,
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            name: _nameController.text.trim(),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Signup failed: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final tr = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.background(context),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: size.height * 0.04,
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: AppColors.innerCardColor(context),
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
                            color: AppColors.mainText(context),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Image.asset('assets/icons/Frame1.png'),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    tr.createAccount,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryText(context),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    tr.accessCollections,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondaryText(context),
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),

                  Text(
                    tr.username,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.mainText(context),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  TextFormField(
                    controller: _nameController,

                    textDirection: TextDirection.ltr,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(color: AppColors.mainText(context)),
                    cursorColor: AppColors.primary(context),
                    decoration: InputDecoration(
                      hintText: tr.username,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryText(context),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primary(context),
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? tr.enterUsername
                        : null,
                  ),
                  SizedBox(height: size.height * 0.02),

                  Text(
                    tr.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.mainText(context),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  TextFormField(
                    controller: _emailController,
                    textDirection: TextDirection.ltr,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: TextStyle(color: AppColors.mainText(context)),
                    cursorColor: AppColors.primary(context),
                    decoration: InputDecoration(
                      hintText: tr.email,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryText(context),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primary(context),
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return tr.enterEmail;
                      if (!EmailValidator.validate(value)) {
                        return tr.invalidEmail;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: size.height * 0.02),

                  Text(
                    tr.password,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.mainText(context),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,

                    textDirection: TextDirection.ltr,
                    style: TextStyle(color: AppColors.mainText(context)),
                    cursorColor: AppColors.primary(context),
                    decoration: InputDecoration(
                      hintText: tr.password,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryText(context),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primary(context),
                          width: 1.5,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.secondaryText(context),
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr.enterPassword;
                      }
                      if (value.length < 6) return tr.passwordTooShort;
                      return null;
                    },
                  ),
                  SizedBox(height: size.height * 0.04),

                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              tr.createAccount,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
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
