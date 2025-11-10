import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/core/l10n/app_localizations_ar.dart';
import 'package:decora/src/features/Auth/models/user_model.dart';
import 'package:decora/src/features/Auth/screens/login_screen.dart';
import 'package:decora/src/features/Auth/screens/reset%20_otp_verification_screen.dart';
import 'package:decora/src/features/Auth/services/sendOTPEmail.dart';
import 'package:decora/src/features/chat/screens/chat_screen.dart';
import 'package:decora/src/features/home/main_screen.dart';
import 'package:decora/src/features/myOrders/screens/my_orders_screen.dart';
import 'package:decora/src/features/profile/screens/edit_profile.dart';
import 'package:decora/src/features/profile/widgets/custom_settings_tile.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final String default_url =
    'https://cvhrma.org/wp-content/uploads/2015/07/default-profile-photo.jpg';

// ignore: must_be_immutable
class ProfileBody extends StatefulWidget {
  UserModel user;

  ProfileBody({super.key, required this.user});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  bool _isLoading = false;

  void _logout(BuildContext context) async {
    setState(() => _isLoading = true);
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    MainLayout.currentIndex = 0;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
    setState(() => _isLoading = false);
  }

  String generateOtp() {
    final random = DateTime.now().millisecondsSinceEpoch % 10000;
    return random.toString().padLeft(4, '0');
  }

  @override
  Widget build(BuildContext context) {
    final List<String> settingsItems = [
      AppLocalizations.of(context)!.edit_profile,
      AppLocalizations.of(context)!.change_password,
      AppLocalizations.of(context)!.transaction_history,
      AppLocalizations.of(context)!.help_support,
      AppLocalizations.of(context)!.logout,
    ];

    final List<Widget> navigations = [
      EditProfileUI(user: widget.user),
      const MyOrdesScreen(),
      ChatScreen(
        userId: widget.user.id,
        adminId: "aEc97NihV5aCa8Zaw0w2YlzvICv2",
      ),
      const LoginScreen(),
    ];

    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 5),
            CustomAppBar(
              title: AppLocalizations.of(context)!.profile,
              onBackPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MainLayout()),
                );
                setState(() {
                  MainLayout.currentIndex = 0;
                });
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    CircleAvatar(
                      key: UniqueKey(),
                      radius: 73,
                      backgroundColor: AppColors.primary(context),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage:
                            widget.user.photoUrl != null &&
                                widget.user.photoUrl!.isNotEmpty
                            ? NetworkImage(widget.user.photoUrl!)
                            : NetworkImage(default_url) as ImageProvider,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      widget.user.name ?? 'No Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: AppColors.textColor(context),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.user.email ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.textColor(context),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: List.generate(settingsItems.length, (index) {
                          final title = settingsItems[index];
                          return CustomSettingsTile(
                            title: title,
                            iconPath: 'assets/icons/arrow-left-01.png',
                            onTap: () async {
                              setState(() => _isLoading = true);

                              if (title ==
                                  AppLocalizations.of(context)!.logout) {
                                _logout(context);
                              } else if (title ==
                                      AppLocalizations.of(
                                        context,
                                      )!.edit_profile ||
                                  title == 'تعديل الملف الشخصي') {
                                final updatedUser =
                                    await Navigator.push<UserModel?>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            EditProfileUI(user: widget.user),
                                      ),
                                    );

                                if (updatedUser != null && mounted) {
                                  setState(() => widget.user = updatedUser);
                                  if (updatedUser.photoUrl != null &&
                                      updatedUser.photoUrl!.isNotEmpty) {
                                    precacheImage(
                                      NetworkImage(updatedUser.photoUrl!),
                                      context,
                                    );
                                  }
                                }
                              } else if (title ==
                                  AppLocalizations.of(
                                    context,
                                  )!.change_password) {
                                final otp = generateOtp();
                                await sendOtpEmail(widget.user.email!, otp);
                                if (!mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => OtpResetScreen(
                                      otp: otp,
                                      email: widget.user.email!,
                                      usePurpose: "change",
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => navigations[index - 1],
                                  ),
                                );
                              }

                              await Future.delayed(
                                const Duration(milliseconds: 500),
                              );
                              if (mounted) setState(() => _isLoading = false);
                            },
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ✅ Loading Overlay
        if (_isLoading)
          AnimatedOpacity(
            opacity: _isLoading ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
