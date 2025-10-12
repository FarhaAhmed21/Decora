import 'package:flutter/material.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:decora/src/shared/theme/app_colors.dart';

class EditProfileUI extends StatelessWidget {
  final String profileImagePath;

  const EditProfileUI({super.key, required this.profileImagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top + 5),
          const CustomAppBar(title: "Edit Profile"),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // ---------------- Profile Image ----------------
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary,
                        radius: 73,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage(profileImagePath),
                        ),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        margin: const EdgeInsets.only(bottom: 3, right: 6),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: IconButton(
                          icon: Image.asset(
                            'assets/icons/edit-02.png',
                            height: 24,
                            width: 24,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                          iconSize: 20,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _buildField("Name", "Name"),
                  _buildField("Email", "Email"),
                  _buildField("Phone Number", "Phone Number"),
                  _buildField("Location", "Description.."),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        width: 30,
                        height: 30,
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () {},
                          iconSize: 15,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Add another Location",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  // ---------------- Save Button ----------------
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: AppColors.mainText,
              fontSize: 16,
              fontFamily: 'Montserratt',
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            maxLines: label == "Location" ? 3 : 1,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: AppColors.secondaryText,
                fontSize: 14,
                fontFamily: 'Montserratt',
              ),
              filled: true,
              fillColor: const Color(0xFFF6F6F6),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
