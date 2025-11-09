import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/features/Auth/screens/forgot_password_screen.dart';
import 'package:decora/src/features/Auth/screens/signup_screen.dart';
import 'package:decora/src/features/Auth/services/auth_service.dart';
import 'package:decora/src/features/Auth/widgets/error_dialog.dart';
import 'package:decora/src/features/admin/screens/adminpanel.dart';
import 'package:decora/src/features/home/main_screen.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  String? _emailError;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadRememberedEmail();
    _checkIfLoggedIn();
  }

  Future<void> _loadRememberedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email');
    if (savedEmail != null && savedEmail.isNotEmpty) {
      setState(() {
        _emailController.text = savedEmail;
        rememberMe = true;
      });
    }
  }

  Future<void> _saveEmailIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('saved_email', _emailController.text);
    } else {
      await prefs.remove('saved_email');
    }
  }

  Future<void> _checkIfLoggedIn() async {
    final user = authService.currentUser;
    if (user != null) {
      if (user.uid == "aEc97NihV5aCa8Zaw0w2YlzvICv2") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminPanel()),
        );
      } else {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainLayout()),
          );
        }
      }
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      await _saveEmailIfNeeded();

      try {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        final user = await authService.signInWithEmail(email, password);

        if (user != null && user.uid == "aEc97NihV5aCa8Zaw0w2YlzvICv2") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminPanel()),
          );
        } else if (user != null) {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (userDoc.exists && mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainLayout()),
            );
          } else {
            await showErrorDialog(
              context,
              AppLocalizations.of(context)!.userNotFound,
            );
          }
        } else {
          await showErrorDialog(
            context,
            AppLocalizations.of(context)!.wrongCredentials,
          );
        }
      } catch (e) {
        await showErrorDialog(
          context,
          AppLocalizations.of(context)!.wrongCredentials,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.background(context),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.06,
            vertical: size.height * 0.06,
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: size.height * 0.05),
                Image.asset('assets/icons/Frame1.png'),
                SizedBox(height: size.height * 0.015),
                Center(
                  child: Text(
                    loc.login,
                    style: TextStyle(
                      fontSize: size.width * 0.06,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryText(context),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.008),
                Center(
                  child: Text(
                    loc.accessCollections,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.width * 0.032,
                      color: AppColors.secondaryText(context),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Text(
                  loc.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.mainText(context),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: AppColors.mainText(context)),
                  onChanged: (value) {
                    setState(() {
                      if (EmailValidator.validate(value.trim())) {
                        _emailError = null;
                      }
                    });
                  },
                  cursorColor: AppColors.primary(context),
                  textDirection: TextDirection.ltr,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    hintText: loc.email,
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
                      return loc.enterEmail;
                    } else if (!EmailValidator.validate(value)) {
                      return loc.invalidEmail;
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  loc.password,
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: TextStyle(color: AppColors.mainText(context)),
                  cursorColor: AppColors.primary(context),
                  decoration: InputDecoration(
                    hintText: loc.password,
                    errorText: _emailError,
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: AppColors.lightSecondaryText,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
                      borderSide: BorderSide(
                        color: AppColors.secondaryText(context),
                        width: 0.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 16.0,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12.0),
                      ),
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
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return loc.enterPassword;
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (bool? newValue) {
                            setState(() {
                              rememberMe = newValue ?? false;
                            });
                          },
                          activeColor: AppColors.primary(context),
                        ),
                        Text(
                          loc.rememberMe,
                          style: TextStyle(
                            fontSize: size.width * 0.035,
                            color: AppColors.secondaryText(context),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgetPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        loc.forgotPassword,
                        style: TextStyle(
                          color: AppColors.primary(context),
                          fontWeight: FontWeight.w600,
                          fontSize: size.width * 0.035,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.025),
                SizedBox(
                  height: 55.0,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary(context),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      loc.login,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.04,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.primary(context))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        loc.orLoginWith,
                        style: TextStyle(
                          color: AppColors.secondaryText(context),
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.primary(context))),
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                      ),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.google,
                          size: 30,
                          color: AppColors.primary(context),
                        ),
                        onPressed: () async {
                          final user = await authService.signInWithGoogle();
                          if (user != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MainLayout(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                      ),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.facebookF,
                          size: 30,
                          color: AppColors.primary(context),
                        ),
                        onPressed: () async {
                          final user = await authService.signInWithFacebook(
                            context,
                          );
                          if (user != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MainLayout(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      loc.dontHaveAccount,
                      style: TextStyle(color: AppColors.secondaryText(context)),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        loc.createAccount,
                        style: TextStyle(
                          color: AppColors.primary(context),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
