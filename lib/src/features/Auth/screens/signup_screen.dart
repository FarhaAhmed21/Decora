import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/features/Auth/screens/otp_verification_screen.dart';
import 'package:decora/src/features/Auth/widgets/customField.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final tr = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.background(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: size.height * 0.04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: size.height * 0.002),

                Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.pop(context),
                      child: Center(
                        child: Icon(
                          Directionality.of(context) == TextDirection.rtl
                              ? FontAwesomeIcons.chevronRight
                              : FontAwesomeIcons.chevronLeft,
                          color: Colors.black87,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),

                Image.asset('assets/icons/Frame1.png'),
                SizedBox(height: size.height * 0.01),

                Text(
                  tr.createAccount,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  tr.accessCollections,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.secondaryText(),
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: size.height * 0.04),

                customField(tr.username),
                const SizedBox(height: 15),
                customField(tr.email),
                const SizedBox(height: 15),
                customPasswordField(tr.password),
                SizedBox(height: size.height * 0.04),

                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        // إنشاء المستخدم
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                              email: "doniawanees@gmail.com",
                              password: "Ommy1973@@",
                            );

                        // الحصول على UID الخاص بالمستخدم الجديد
                        String uid = userCredential.user!.uid;

                        // تخزين بيانات المستخدم في Firestore بنفس UID
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(uid)
                            .set({
                              'name': "Donia",
                              'email': "doniawanees@gmail.com",
                              'uid': uid,
                              'phone_num': '',
                              'location': '',
                              'photo_link': '',
                            });

                        // الانتقال لصفحة التحقق
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const OtpVerificationScreen(),
                          ),
                        );
                      } catch (e) {
                        print('Error creating user: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    },

                    child: Text(
                      tr.createAccount,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
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

  Widget customPasswordField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 6),
        TextField(
          cursorColor: AppColors.primary(),
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(color: AppColors.primary(), width: 1.5),
            ),
            hintText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
          ),
        ),
      ],
    );
  }
}
