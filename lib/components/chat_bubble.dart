import 'package:flutter/material.dart';
import 'package:mini_chat_app/services/chats/chat_services.dart';
import 'package:mini_chat_app/pages/home_page.dart'; // Ensure you import HomePage

class ChatBubble extends StatelessWidget {
  final String message; // Fixed typo from 'messsage' to 'message'
  final bool isCurrentUser;
  final String messageID;
  final String userID;

  const ChatBubble({
    super.key,
    required this.isCurrentUser,
    required this.message,
    required this.messageID,
    required this.userID,
  });

  // Show options in a modal bottom sheet
  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              // Report user
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Report'),
                onTap: () {
                  Navigator.pop(context);
                  _reportMessage(context, messageID, userID);
                },
              ),
              // Block user
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Block User'),
                onTap: () {
                  Navigator.pop(context);
                  _blockUser(context, userID);
                },
              ),
              // Close
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Report the message
  Future<void> _reportMessage(
      BuildContext context, String messageID, String userID) async {
    final chatServices = ChatServices(); // Create an instance
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Report Message"),
        content: const Text("Are you sure you want to report this message?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          // Report button
          TextButton(
            onPressed: () async {
              await chatServices.reportUser(messageID, userID);
              if (!context.mounted) return; // Check if context is still valid
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Message Reported!!"),
              ));
            },
            child: const Text("Report"),
          ),
        ],
      ),
    );
  }

  // Block the user
  Future<void> _blockUser(BuildContext context, String userID) async {
    final chatServices = ChatServices(); // Create an instance
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Block User"),
        content: const Text("Are you sure you want to block this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          // Block button
          TextButton(
            onPressed: () async {
              await chatServices.blockUser(userID);
              if (!context.mounted) return; // Check if context is still valid
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("User Blocked!!"),
              ));

              // Refresh the Home Page after blocking
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: const Text("Block"),
          ),
        ],
      ),
    );
  }

  // Show options on long press
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          // Show options for the message
          _showOptions(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color:
              isCurrentUser ? const Color(0xFF1DCD63) : const Color(0xFF262A32),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
        child: Text(
          message, // Fixed typo from 'messsage' to 'message'
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
