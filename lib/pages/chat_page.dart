import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_chat_app/components/chat_bubble.dart';
import 'package:mini_chat_app/components/my_text_field.dart';
import 'package:mini_chat_app/services/auth/auth_service.dart';
import 'package:mini_chat_app/services/chats/chat_services.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String reciverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.reciverID,
  });

  // Text editing controller
  final TextEditingController _messageController = TextEditingController();

  // Chat services
  final ChatServices _chatServices = ChatServices();
  final AuthServices _authServices = AuthServices();

  // Send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(reciverID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authServices.getCurrentUser()!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: _chatServices.getMessages(reciverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading messages"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text("Loading...", style: TextStyle(fontSize: 17)),
              ],
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Start Typing..."));
        }
        return ListView(
          // reverse: true, // To show the latest messages at the bottom
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // Determine if the message is from the current user
    bool isCurrentUser =
        data['senderID'] == _authServices.getCurrentUser()!.uid;
    var msgAlignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: msgAlignment,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child:
          ChatBubble(isCurrentUser: isCurrentUser, messsage: data['message']),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              hinttext: 'Type something...',
              obscuretxt: false,
              controller: _messageController,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Color(0xFF1DCD63), shape: BoxShape.circle),
            margin: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.send_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
