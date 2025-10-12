import 'package:decora/src/features/profile/widgets/profile_body.dart';
import 'package:decora/src/shared/components/custom_floating_action_button.dart';
import 'package:flutter/material.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:decora/src/shared/components/nevbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: const ProfileBody(
        name: "Abdelrahman Taher",
        email: "abdolrahman.taher",
        profileImagepath: "assets/images/ss.jpg",
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 3, // Assuming 'Profile' is the 4th item
        onItemTapped: (index) {
          // Handle navigation logic here
        },
      ),
      floatingActionButton: const Custom_floating_action_button(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
