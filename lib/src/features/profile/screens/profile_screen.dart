import 'package:flutter/material.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:decora/src/shared/components/nevbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      body:  const ProfileBody(name: "Abdelrahman Taher",email: "abdolrahman.taher",profileImagepath: "assets/images/ss.png",),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 3, // Assuming 'Profile' is the 4th item
        onItemTapped: (index) {
          // Handle navigation logic here
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primaryGreen,
        shape: const CircleBorder(),
        child: Image.asset('assets/icons/VTO.png', height: 24, width: 24, color: Colors.white), // أيقونة الكرسي
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
class ProfileBody extends StatelessWidget {
  final String name;
  final String email;
  final String profileImagepath;
  
  const ProfileBody({super.key, required this.name, required this.email, required this.profileImagepath});
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
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage(profileImagepath),
          ),
          const SizedBox(height: 15),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: AppColors.textColor)
          ),
          const SizedBox(height: 5),
          Text(
            email,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: AppColors.textColor)
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0), 
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
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class CustomSettingsTile extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;
  
  static final BorderRadius tileBorderRadius = BorderRadius.circular(8);

  const CustomSettingsTile({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0), 
      
      child: ClipRRect(
        borderRadius: tileBorderRadius,
        child: InkWell(
          onTap: onTap,
          splashColor: const Color.fromARGB(255, 220, 220, 220), 
          borderRadius: tileBorderRadius, 
          
          child: Container(
            height: 45, 
            width: double.infinity, 
            decoration: const BoxDecoration(
              color: Color.fromRGBO(246, 246, 246, 1),
            ),
            
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400, 
                      fontSize: 16, 
                      color: Colors.black
                    ),
                  ),

                  Image.asset(iconPath, height: 20, width: 20), 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}