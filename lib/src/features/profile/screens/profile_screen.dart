import 'package:decora/src/features/profile/widgets/profile_body.dart';
import 'package:flutter/material.dart';
import 'package:decora/src/shared/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: ProfileBody(
        name: "Abdelrahman Taher",
        email: "abdolrahman.taher",
        profileImagepath: "assets/images/ss.jpg",
      ),
    );
  }
}
