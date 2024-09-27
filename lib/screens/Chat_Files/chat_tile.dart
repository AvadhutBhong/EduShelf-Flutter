import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String lastmessage;
  final int unreadCount;
  final VoidCallback onTap;

  const ChatTile({super.key,
  required this.name,
  required this.lastmessage,
  required this.unreadCount,
  required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(name[0]),
      ),
       title:  Text(name),
      subtitle: Text(lastmessage),
      trailing: unreadCount > 0 ?
      CircleAvatar(
        radius: 12,
        backgroundColor: Colors.red,
        child: Text(
          unreadCount.toString(),
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ): null,
      onTap: onTap,
    );
  }
}
