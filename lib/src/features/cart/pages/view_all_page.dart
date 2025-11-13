import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/core/l10n/app_localizations.dart';
import 'package:decora/src/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ViewAllPage extends StatelessWidget {
  final List<String> usersId;
  const ViewAllPage({super.key, required this.usersId});

  Future<List<Map<String, dynamic>>> _fetchUsersDetails() async {
    final firestore = FirebaseFirestore.instance;
    List<Map<String, dynamic>> users = [];

    for (final id in usersId) {
      try {
        final doc = await firestore.collection('users').doc(id).get();
        if (doc.exists && doc.data() != null) {
          users.add({
            'id': id,
            'name': doc.data()!['name'] ?? 'Unknown User',
            'email': doc.data()!['email'] ?? 'No email',
            'photoUrl':
                doc.data()!['photoUrl'] ??
                'https://i.pravatar.cc/150?u=$id', // fallback image
          });
        } else {
          users.add({
            'id': id,
            'name': 'Unknown User',
            'email': 'N/A',
            'photoUrl': 'https://i.pravatar.cc/150?u=$id',
          });
        }
      } catch (e) {
        print('⚠️ Error loading user $id: $e');
      }
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        backgroundColor: AppColors.background(context),
        title: Text(
          AppLocalizations.of(context)!.shared_cart_users,
          style: TextStyle(
            color: AppColors.textColor(context),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 8),
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.cardColor(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textColor(context),
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchUsersDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final users = snapshot.data ?? [];

          if (users.isEmpty) {
            return const Center(child: Text('No user details found.'));
          }
          return ListView.builder(

            itemCount: users.length,
            itemBuilder: (_, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                child: ListTile(
                    leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['photoUrl']),
                  ),
                  title: Text(user['name']),
                  subtitle: Text(user['email']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
