import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String messsage;
  final bool isCurrentUser;

  const ChatBubble(
      {super.key, required this.isCurrentUser, required this.messsage});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color:
              isCurrentUser ? const Color(0xFF1DCD63) : const Color(0xFF0C3C8A),
          borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
      child: Text(
        messsage,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
