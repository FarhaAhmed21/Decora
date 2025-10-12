import 'package:decora/src/features/profile/widgets/custom_settings_tile.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileBody extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final List<String> settingsItems = [
      'Edit Profile',
      'Change Password',
      'Transaction History',
      'Payment Methods',
      'Help & Support',
      'Logout',
    ];
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top + 5),
        const CustomAppBar(title: 'Profile'),
        Expanded(
          child: SingleChildScrollView(
            //why
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 30),
                CircleAvatar(
                  radius: 73,
                  backgroundColor: AppColors.primary,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage(profileImagepath),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  email,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.textColor,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: settingsItems.map((title) {
                        return CustomSettingsTile(
                          title: title,
                          iconPath: 'assets/icons/arrow-left-01.png',
                          onTap: () {
                            print('$title tapped!');
                          },
                        );
                      }).toList(),
                    ),
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
