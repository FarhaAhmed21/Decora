import 'package:decora/src/features/Auth/screens/login_screen.dart';
import 'package:decora/src/features/chat/screens/chat_screen.dart';
import 'package:decora/src/features/home/main_screen.dart';
import 'package:decora/src/features/myOrders/screens/my_orders_screen.dart';
import 'package:decora/src/features/profile/screens/edit_profile.dart';
import 'package:decora/src/features/profile/widgets/custom_settings_tile.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileBody extends StatefulWidget {
  final String name;
  final String email;
  final String profileImagepath;

  const ProfileBody({
    super.key,
    required this.name,
    required this.email,
    required this.profileImagepath,
  });

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    final List<String> settingsItems = [
      'Edit Profile',
      'Change Password',
      'Transaction History',
      'Help & Support',
      'Logout',
    ];

    final List<Widget> navigations = [
      EditProfileUI(profileImagePath: widget.profileImagepath),
      EditProfileUI(profileImagePath: widget.profileImagepath),
      const MyOrdesScreen(),
      const ChatScreen(),
      const LoginScreen(),
    ];

    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top + 5),
        CustomAppBar(
          title: 'Profile',
          onBackPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MainLayout()),
            );
            MainLayout.currentIndex = 0;
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 30),
                CircleAvatar(
                  radius: 73,
                  backgroundColor: AppColors.primary(),
                  child: const CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage("assets/images/ss.jpg"),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  widget.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: AppColors.textColor(),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.email,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.textColor(),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: List.generate(settingsItems.length, (index) {
                      return CustomSettingsTile(
                        title: settingsItems[index],
                        iconPath: 'assets/icons/arrow-left-01.png',
                        onTap: () {
                          if (settingsItems[index] == 'Logout') {
                            MainLayout.currentIndex = 0;
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => navigations[index],
                              ),
                            );
                          }
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
    );
  }
}
