import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({Key? key}) : super(key: key);

  @override
  _ChatDetailScreenState createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  List<Map<String, dynamic>> messages = [];
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _showScrollToBottomButton = false; // Track visibility of the floating button

  // Static data for demonstration
  final String ownerName = "Owner Name";
  final String ownerImageUrl = "images/avatar.png"; // Make sure this path is correct
  final List<Map<String, dynamic>> staticMessages = [
    {"text": "Hello, how can I help you?", "isSender": false},
    {"text": "I need some information about your product.", "isSender": true},
    {"text": "Sure, what do you need to know?", "isSender": false},{"text": "Hello, how can I help you?", "isSender": false},
    {"text": "I need some information about your product.", "isSender": true},
    {"text": "Sure, what do you need to know?", "isSender": false},{"text": "Hello, how can I help you?", "isSender": false},
    {"text": "I need some information about your product.", "isSender": true},
    {"text": "Sure, what do you need to know?", "isSender": false},{"text": "Hello, how can I help you?", "isSender": false},
    {"text": "I need some information about your product.", "isSender": true},
    {"text": "Sure, what do you need to know?", "isSender": false},{"text": "Hello, how can I help you?", "isSender": false},
    {"text": "I need some information about your product.", "isSender": true},
    {"text": "Sure, what do you need to know?", "isSender": false},{"text": "Hello, how can I help you?", "isSender": false},
    {"text": "I need some information about your product.", "isSender": true},
    {"text": "Sure, what do you need to know?", "isSender": false},{"text": "Hello, how can I help you?", "isSender": false},
    {"text": "I need some information about your product.", "isSender": true},
    {"text": "Sure, what do you need to know?", "isSender": false},{"text": "Hello, how can I help you?", "isSender": false},
    {"text": "I need some information about your product.", "isSender": true},
    {"text": "Sure, what do you need to know?", "isSender": false},{"text": "Hello, how can I help you?", "isSender": false},
    {"text": "I need some information about your product.", "isSender": true},
    {"text": "Sure, what do you need to know?", "isSender": false},
    // Add more messages here
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with static messages
    messages = staticMessages;

    // Scroll to the bottom on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Listen to scroll events
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        // When at the bottom of the list, hide the floating button
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          setState(() {
            _showScrollToBottomButton = false;
          });
        }
      } else {
        // Show the floating button when scrolling up
        setState(() {
          _showScrollToBottomButton = true;
        });
      }
    });
  }

  void _sendMessage() {
    final messageText = _controller.text.trim();
    if (messageText.isNotEmpty) {
      setState(() {
        messages.add({"text": messageText, "isSender": true});
        _controller.clear();
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(ownerImageUrl),
            ),
            SizedBox(width: 8.0),
            Text(
              ownerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blueGrey[200],
        elevation: 3,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isSender = message["isSender"];
                      return Align(
                        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7, // Limit message box width
                          ),
                          margin: EdgeInsets.symmetric(vertical: 6.0),
                          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: isSender ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            message["text"],
                            style: TextStyle(
                              color: isSender ? Colors.white : Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
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
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.blue),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.0), // Added padding from the bottom
              ],
            ),
            // Floating button to scroll to bottom
            if (_showScrollToBottomButton)
              Positioned(
                right: 16,
                bottom: 80, // Adjust this value based on the height of the input area
                child: FloatingActionButton(
                  mini: true,
                  onPressed: _scrollToBottom,
                  child: Icon(Icons.arrow_downward),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
