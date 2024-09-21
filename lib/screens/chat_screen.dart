import 'package:edu_shelf/screens/personal_chat_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/support_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Dummy chat data with unread message count
  final List<Map<String, dynamic>> _chats = [
    {'name': 'John Doe', 'message': 'Hello! How are you?', 'unreadCount': 2},
    {'name': 'Jane Smith', 'message': 'Can we schedule a meeting?', 'unreadCount': 1},
    {'name': 'Alice Johnson', 'message': 'Thanks for your help!', 'unreadCount': 0},
    {'name': 'Michael Brown', 'message': 'Let’s catch up soon.', 'unreadCount': 5},
    {'name': 'Chris Evans', 'message': 'Received your documents.', 'unreadCount': 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Chats",
          style: AppWidget.boldTextFieldStyle(),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: TextField(
              // onChanged: onQueryChanged,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(

            child: ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (context, index) {
                return ListTile(

                  leading: CircleAvatar(
                    child: Text(_chats[index]['name']![0]),
                  ),
                  title: Text(_chats[index]['name']),
                  subtitle: Text(_chats[index]['message']),
                  trailing: _chats[index]['unreadCount'] > 0
                      ? Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Text(
                      _chats[index]['unreadCount'].toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                      : null,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> ChatDetailScreen()));
                    // Add functionality when a chat is tapped
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
