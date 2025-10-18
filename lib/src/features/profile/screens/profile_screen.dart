import 'package:decora/src/features/profile/models/usermodel.dart';
import 'package:decora/src/features/profile/services/user_firebase.dart';
import 'package:decora/src/features/profile/widgets/profile_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:decora/src/shared/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  final User userCredential = FirebaseAuth.instance.currentUser!;

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(),
      body: FutureBuilder<UserModel?>(
        future: UserFirebase().getUser(userCredential.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final user = snapshot.data;

          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return ProfileBody(
            name: user.name,
            email: user.email,
            profileImagepath: user.photoLink,
          );
        },
      ),
    );
  }
}
