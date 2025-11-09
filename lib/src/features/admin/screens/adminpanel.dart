import 'package:decora/src/features/Auth/screens/login_screen.dart';
import 'package:decora/src/features/admin/screens/add_product_screen.dart';
import 'package:decora/src/features/admin/screens/admin_dashboard.dart';
import 'package:decora/src/features/admin/screens/allprodects_screen.dart';
import 'package:decora/src/features/profile/widgets/custom_settings_tile.dart';
import 'package:decora/src/shared/components/appbar.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  bool _isLoading = false;

  void _logout(BuildContext context) async {
    setState(() => _isLoading = true);
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: "AdminPanel",
              onBackPressed: () => _logout(context),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CustomSettingsTile(
                      title: "Add Product",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const AddProductScreen();
                            },
                          ),
                        );
                      },
                    ),
                    CustomSettingsTile(
                      title: "Edit Or Delete Product",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const AllProductsScreen();
                            },
                          ),
                        );
                      },
                    ),
                    CustomSettingsTile(
                      title: "User Chats",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminDashboard(
                              adminId: "aEc97NihV5aCa8Zaw0w2YlzvICv2",
                            ),
                          ),
                        );
                      },
                    ),

                    CustomSettingsTile(
                      title: "LogOut",
                      onTap: () => _logout(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
