import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_shelf/services/shared_pref.dart';
import 'package:edu_shelf/widgets/support_widget.dart';
import 'package:flutter/material.dart';
import '../../utils/chat_functions.dart';
import 'message_bubble.dart';

class ChatDetailScreen extends StatefulWidget {
  final String ownerId;
  String? otherUserName;
  ChatDetailScreen({Key? key, required this.ownerId, this.otherUserName}) : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final ChatFunctions _chatFunctions = ChatFunctions();
  final TextEditingController _controller = TextEditingController();
  String? _chatId;
  String? currentUserId;
  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() async {
    currentUserId = await SharedPreferenceHelper().getUserId(); // Retrieve from auth
    _chatId = await _chatFunctions.getChatId(currentUserId!, widget.ownerId);
    setState(() {});
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty && _chatId != null) {
      _chatFunctions.sendMessages(_chatId!, currentUserId!, _controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUserName ?? 'Unknown owner' , style: AppWidget.boldTextFieldStyle(),),
        centerTitle: false,
        backgroundColor: Colors.blueGrey[100],
      ),
      body: Column(
        children: [
          Expanded(

            child: _chatId == null
                ? Center(child: CircularProgressIndicator())
                : StreamBuilder<List<Map<String, dynamic>>>(
              stream: _chatFunctions.getMessages(_chatId!),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error loading messages"));
                }
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return MessageBubble(
                      message: message['message'],
                      isSender: message['senderId'] == currentUserId,
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
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
