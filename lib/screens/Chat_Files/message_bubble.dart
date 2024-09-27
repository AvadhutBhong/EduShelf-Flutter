import 'package:flutter/material.dart';
class MessageBubble extends StatelessWidget {
  final String message;
  final bool isSender;

  const MessageBubble({super.key,
  required this.message,
  required this.isSender
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          message,
          style: TextStyle(color: isSender? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
