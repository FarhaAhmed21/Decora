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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("حدث خطأ في تحميل المحادثات"));
          }

          final chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return const Center(child: Text("No chats yet."));
          }

          final Set<String> userIds = {};
          for (final chat in chats) {
            final participants = List<String>.from(chat['participants']);
            final other = participants.firstWhere(
              (id) => id != adminId,
              orElse: () => '',
            );
            if (other.isNotEmpty) userIds.add(other);
          }

          return FutureBuilder<Map<String, DocumentSnapshot>>(
            future: _fetchUsers(userIds),
            builder: (context, usersSnapshot) {
              if (usersSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (usersSnapshot.hasError) {
                return Center(child: Text("Error: ${usersSnapshot.error}"));
              }

              final Map<String, DocumentSnapshot> usersMap =
                  usersSnapshot.data ?? {};

              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final participants = List<String>.from(chat['participants']);
                  final userId = participants.firstWhere(
                    (id) => id != adminId,
                    orElse: () => '',
                  );

                  final userDoc = usersMap[userId];
                  final userName =
                      (userDoc != null &&
                          userDoc.exists &&
                          userDoc.data() != null)
                      ? (userDoc['name'] ?? "Unknown User")
                      : "Unknown User";
                  final userImage =
                      (userDoc != null &&
                          userDoc.exists &&
                          userDoc.data() != null)
                      ? (userDoc['photoUrl'] ??
                            'assets/images/default_user.png')
                      : 'assets/images/default_user.png';

                  return StreamBuilder<QuerySnapshot>(
                    stream: chat.reference
                        .collection('messages')
                        .orderBy('timestamp', descending: true)
                        .limit(1)
                        .snapshots(),
                    builder: (context, msgSnapshot) {
                      String lastMessage = "No messages yet";
                      DateTime lastMessageTime = DateTime.now();

                      if (msgSnapshot.hasData &&
                          msgSnapshot.data!.docs.isNotEmpty) {
                        final msgDoc = msgSnapshot.data!.docs.first;
                        lastMessage = msgDoc['text'] ?? lastMessage;
                        final ts = msgDoc['timestamp'];
                        if (ts is Timestamp) lastMessageTime = ts.toDate();
                      }

                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                userId: userId,
                                adminId: adminId,
                                currentUserId: adminId,
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage:
                              userImage.toString().startsWith("http")
                              ? NetworkImage(userImage)
                              : AssetImage(userImage) as ImageProvider,
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
                        ),
                        trailing: Text(
                          "${lastMessageTime.hour.toString().padLeft(2, '0')}:${lastMessageTime.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<Map<String, DocumentSnapshot>> _fetchUsers(Set<String> userIds) async {
    final Map<String, DocumentSnapshot> result = {};

    final futures = userIds.map(
      (id) => FirebaseFirestore.instance.collection('users').doc(id).get(),
    );
    final docs = await Future.wait(futures);

    for (var doc in docs) {
      if (doc.exists) {
        result[doc.id] = doc;
      }
    }

    return result;
  }
}
