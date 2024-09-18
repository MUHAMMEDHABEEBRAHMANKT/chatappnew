// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mini_chat_app/components/user_tile.dart';
import 'package:mini_chat_app/services/auth/auth_service.dart';
import 'package:mini_chat_app/services/chats/chat_services.dart';
import 'package:mini_chat_app/pages/home_page.dart'; // Ensure you import HomePage

class BlockedUsersPage extends StatelessWidget {
  BlockedUsersPage({super.key});
  final ChatServices _chatServices = ChatServices();
  final AuthServices _authServices = AuthServices();

  // Show confirm unblock user dialog
  void _showUnblockBox(BuildContext context, String userID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Unblock User"),
        content: const Text("Are you sure you want to unblock this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await _chatServices
                  .unblockUser(userID); // Await the unblock operation
              Navigator.pop(context); // Close the dialog

              // Show SnackBar after unblocking
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("User Unblocked"),
              ));

              // Optional: Refresh the blocked users list
              // You could also just pop the dialog and let the stream handle it
              // Or navigate back to HomePage if needed
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
            child: const Text("Unblock"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userID = _authServices.getCurrentUser()!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Blocked Users"),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _chatServices.getBlockedUsersStream(userID),
        builder: (context, snapshot) {
          // Error handling
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error loading blocked users"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final blockedUsers = snapshot.data ?? [];
          // No blocked users?
          if (blockedUsers.isEmpty) {
            return const Center(
              child: Text("No Blocked Users"),
            );
          }

          return ListView.builder(
            itemCount: blockedUsers.length,
            itemBuilder: (context, index) {
              final user = blockedUsers[index];
              return UserTile(
                text: user["email"],
                onTap: () => _showUnblockBox(context, user["uid"]),
              );
            },
          );
        },
      ),
    );
  }
}
