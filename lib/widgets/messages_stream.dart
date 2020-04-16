import 'package:flutter/material.dart';
import 'package:flash_chat/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessagesStream extends StatelessWidget {
  MessagesStream({@required this.loggedInUser});
  final FirebaseUser loggedInUser;
  final _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageWidgets = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];

          final currentUser = loggedInUser.email;

          final messageWidget = MessageBubble(
            text: messageText,
            sender: messageSender,
            isMe: currentUser == messageSender,
          );
          messageWidgets.add(messageWidget);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}
