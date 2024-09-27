import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_shelf/screens/Chat_Files/personal_chat_screen.dart';
import 'package:edu_shelf/services/shared_pref.dart'; // For accessing SharedPreferenceHelper
import 'package:edu_shelf/widgets/support_widget.dart';
import 'package:flutter/material.dart';
import 'chat_tile.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId(); // Loading userId from shared preferences
  }

  // Load current user ID from shared preferences
  Future<void> _loadCurrentUserId() async {
    String? userId = await SharedPreferenceHelper().getUserId();
    setState(() {
      currentUserId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      // Show loading indicator while waiting for userId
      return Scaffold(
        appBar: AppBar(title: Text("My Chats")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("My Chats", style: AppWidget.boldTextFieldStyle(),),
      backgroundColor: Colors.blueGrey[100],),
      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: currentUserId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final chats = snapshot.data!.docs;

          if (chats.isEmpty) {
            return Center(
              child: Text(
                'No chats available',
                style: AppWidget.boldTextFieldStyle(),
              ),
            );
          }

          return ListView.builder(

            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index].data() as Map<String, dynamic>;
              final chatId = chats[index].id;
              final lastMessage = chat['lastMessage'] ?? 'No messages yet';
              final unreadCount = chat['unreadCount'] ?? 0;
              final participants = chat['participants'] as List<dynamic>;

              // Determine the other participant's name and ID
              final otherUserId = participants.firstWhere((id) => id != currentUserId);

              // Fetch other user data
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return Container(); // Placeholder while loading user data
                  }

                  final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                  final otherUserName = userData['Name'] ?? 'User';
                  final otherUserImage = userData['Image'] ?? '';

                  return ChatTile(
                    name: otherUserName,
                    lastmessage: lastMessage,
                    unreadCount: unreadCount,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailScreen(
                            ownerId: otherUserId,
                              otherUserName: otherUserName,
                            // Optionally, pass otherUserName and otherUserImage if needed
                          ),
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
}
