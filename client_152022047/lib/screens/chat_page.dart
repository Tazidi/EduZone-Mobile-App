import 'package:client_152022047/styles.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatelessWidget {
  final String chatId;
  final String identifier; // Bisa username atau client identifier
  final String otherUser;

  final TextEditingController messageController = TextEditingController();

  ChatPage({
    required this.chatId,
    required this.identifier,
    required this.otherUser,
  });

  void sendMessage(String message) {
    if (message.isEmpty) return;

    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'sender': identifier,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    FirebaseFirestore.instance.collection('chats').doc(chatId).set({
      'last_message': message,
      'last_timestamp': FieldValue.serverTimestamp(),
      'participants': FieldValue.arrayUnion([identifier, otherUser]),
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat with $otherUser',
          style: TextStyle(color: AppColors.softBeige),
        ),
        backgroundColor: AppColors.royalBlue,
        iconTheme: IconThemeData(color: AppColors.softBeige),
      ),
      body: Container(
        color: AppColors.skyBlue, // SkyBlue as background color
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(chatId)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var messages = snapshot.data!.docs;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var message = messages[index];
                      bool isSender = message['sender'] == identifier;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 8.0,
                        ),
                        child: Align(
                          alignment: isSender
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSender
                                  ? AppColors.royalBlue // RoyalBlue for sender
                                  : AppColors.powderBlue, // PowderBlue for receiver
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: isSender
                                    ? Radius.circular(10)
                                    : Radius.zero,
                                bottomRight: isSender
                                    ? Radius.zero
                                    : Radius.circular(10),
                              ),
                            ),
                            child: Text(
                              message['message'],
                              style: TextStyle(
                                color: Colors.white, // Text color for contrast
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.send, color: AppColors.royalBlue),
                    onPressed: () {
                      sendMessage(messageController.text.trim());
                      messageController.clear();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
