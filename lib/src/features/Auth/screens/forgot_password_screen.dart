import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/src/features/Auth/screens/reset%20_otp_verification_screen.dart';
import 'package:decora/src/features/Auth/services/sendOTPEmail.dart';
import 'package:decora/src/features/Auth/widgets/emailnotfound_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  String? emailError;
  final _firestore = FirebaseFirestore.instance;

  String _generateOtp() {
    final random = DateTime.now().millisecondsSinceEpoch % 10000;
    return random.toString().padLeft(4, '0');
  }

  Future<bool> _checkIfEmailExists(String email) async {
    final users = await _firestore
        .collection('users')
        .where('email', isEqualTo: email.trim())
        .get();
    return users.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.background(context),
        appBar: AppBar(
          backgroundColor: AppColors.background(context),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
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
                    size: 16,
                    color: AppColors.secondaryText(context),
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            tr.resetPassword,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryText(context),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.04,
              ),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        tr.enterEmailreset,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.secondaryText(context),
                          fontSize: 17,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.025),
                    Text(
                      tr.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.mainText(context),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    TextFormField(
                      controller: emailController,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(color: AppColors.mainText(context)),
                      onChanged: (value) {
                        setState(() {
                          if (EmailValidator.validate(value.trim())) {
                            emailError = null;
                          }
                        });
                      },
                      cursorColor: AppColors.primary(context),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                          borderSide: BorderSide(
                            color: AppColors.primary(context),
                            width: 1.5,
                          ),
                        ),
                        hintText: tr.email,
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: AppColors.lightSecondaryText,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 14,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return tr.enterEmail;
                        } else if (!EmailValidator.validate(value)) {
                          return tr.invalidEmail;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: size.height * 0.04),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final email = emailController.text.trim();
                            final exists = await _checkIfEmailExists(email);

                            if (exists) {
                              final otp = _generateOtp();
                              await sendOtpEmail(email, otp);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      OtpResetScreen(otp: otp, email: email),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    EmailNotFoundDialog(email: email),
                              );
                            }
                          }
                        },
                        child: Text(
                          tr.continueButton,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
