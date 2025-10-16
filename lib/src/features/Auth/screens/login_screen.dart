import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/features/Auth/screens/forgot_password_screen.dart';
import 'package:decora/src/features/Auth/screens/signup_screen.dart';
import 'package:decora/src/features/Auth/widgets/customField.dart';
import 'package:decora/src/features/home/main_screen.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.06,
          vertical: size.height * 0.06,
        ),
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
                  color: Colors.black87,
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
                  color: AppColors.secondaryText(),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),

            customField(loc.email),

            SizedBox(height: size.height * 0.02),

            Text(loc.password, style: TextStyle(fontSize: size.width * 0.04)),
            const SizedBox(height: 6),
            customPasswordField(loc),

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
                      activeColor: AppColors.primary(),
                    ),
                    Text(
                      loc.rememberMe,
                      style: TextStyle(fontSize: size.width * 0.035),
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
                      color: AppColors.primary(),
                      fontWeight: FontWeight.w600,
                      fontSize: size.width * 0.035,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.03),

            SizedBox(
              height: 55.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MainLayout()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary(),
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
                Expanded(child: Divider(color: AppColors.primary())),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    loc.orLoginWith,
                    style: TextStyle(color: AppColors.secondaryText()),
                  ),
                ),
                Expanded(child: Divider(color: AppColors.primary())),
              ],
            ),
            SizedBox(height: size.height * 0.03),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: Icon(
                    FontAwesomeIcons.google,
                    size: 30,
                    color: AppColors.primary(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: Icon(
                    FontAwesomeIcons.apple,
                    size: 35,
                    color: AppColors.primary(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  child: Icon(
                    FontAwesomeIcons.facebookF,
                    size: 30,
                    color: AppColors.primary(),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.05),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  loc.dontHaveAccount,
                  style: const TextStyle(color: Colors.black54),
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
                      color: AppColors.primary(),
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
    );
  }

  Widget customPasswordField(AppLocalizations loc) {
    return TextField(
      obscureText: _obscurePassword,
      cursorColor: AppColors.primary(),
      decoration: InputDecoration(
        hintText: loc.password,
        hintStyle: const TextStyle(fontSize: 14),

        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: AppColors.secondaryText(), width: 0.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 16.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          borderSide: BorderSide(color: AppColors.primary(), width: 1.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }
}
