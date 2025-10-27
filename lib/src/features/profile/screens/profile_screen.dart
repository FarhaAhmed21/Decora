import 'package:decora/src/features/Auth/models/user_model.dart';
import 'package:decora/src/features/Auth/services/firestore_service.dart';
import 'package:decora/src/features/profile/widgets/profile_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:decora/src/shared/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(),
      body: FutureBuilder<UserModel>(
        future: FirestoreService().getUserData(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No user data found.'));
          }

          final userModel = snapshot.data!;

          return ProfileBody(user: userModel);
        },
      ),
    );
  }
}
