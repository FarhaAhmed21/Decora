import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/features/Auth/screens/success_screen.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final controller = TextEditingController();

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.background(),
        appBar: AppBar(
          backgroundColor: AppColors.background(),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
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
            tr.createNewPassword,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.03),
              Text(
                tr.verificationMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryText(),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              Text(tr.newPassword, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 6),
              TextField(
                obscureText: _obscurePassword,
                controller: controller,
                cursorColor: AppColors.primary(),
                decoration: InputDecoration(
                  hintText: tr.newPassword,
                  hintStyle: const TextStyle(fontSize: 14),

                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(
                      color: AppColors.secondaryText(),
                      width: 0.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 16.0,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(
                      color: AppColors.primary(),
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
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 52,
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
                      builder: (_) => const PasswordResetSuccessScreen(),
                    ),
                  ),
                  child: Text(
                    tr.saveNewPassword,
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
    );
  }
}
