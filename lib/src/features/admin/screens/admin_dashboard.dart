import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decora/src/features/chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  final String adminId;

  const AdminDashboard({super.key, required this.adminId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: adminId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return const Center(child: Text("No chats yet."));
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final participants = List<String>.from(chat['participants']);
              final userId = participants.firstWhere((id) => id != adminId);

              final userName = "User $userId";
              final userImage = 'assets/images/default_user.png';
              return StreamBuilder<QuerySnapshot>(
                stream: chat.reference
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .limit(1)
                    .snapshots(),
                builder: (context, msgSnapshot) {
                  String lastMessage = "No messages yet";
                  bool isRead = true;
                  DateTime lastMessageTime = DateTime.now();

                  if (msgSnapshot.hasData &&
                      msgSnapshot.data!.docs.isNotEmpty) {
                    final msgDoc = msgSnapshot.data!.docs.first;
                    lastMessage = msgDoc['text'];
                    lastMessageTime = (msgDoc['timestamp'] as Timestamp)
                        .toDate();
                  }

                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ChatScreen(userId: userId, adminId: adminId),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(userImage),
                      radius: 25,
                    ),
                    title: Text(
                      userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${lastMessageTime.hour.toString().padLeft(2, '0')}:${lastMessageTime.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(fontSize: 12),
                        ),
                        if (!isRead)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
