import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_152022047/styles.dart'; // Import AppColors
import 'chat_page.dart';

class AdminChatListPage extends StatelessWidget {
  final String adminUsername;

  AdminChatListPage({required this.adminUsername});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(color: AppColors.softBeige),
        ),
        backgroundColor: AppColors.royalBlue,
        iconTheme: IconThemeData(color: AppColors.softBeige),
      ),
      body: Container(
        color: AppColors.skyBlue,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('chats').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var chats = snapshot.data!.docs;
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                var chat = chats[index];
                var participants = List<String>.from(chat['participants']);
                String clientIdentifier =
                    participants.firstWhere((p) => p != adminUsername);

                return Card(
                  color: AppColors.powderBlue,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.royalBlue,
                      child: Icon(
                        Icons.person,
                        color: AppColors.softBeige,
                      ),
                    ),
                    title: Text(
                      clientIdentifier,
                      style: TextStyle(
                        color: AppColors.royalBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      chat['last_message'] ?? 'No messages yet',
                      style: TextStyle(color: AppColors.royalBlue),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.royalBlue,
                      size: 16,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            chatId: chat.id,
                            identifier: adminUsername,
                            otherUser: clientIdentifier,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
