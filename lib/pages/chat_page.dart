import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_chat_app/components/chat_bubble.dart';
import 'package:mini_chat_app/components/my_text_field.dart';
import 'package:mini_chat_app/services/auth/auth_service.dart';
import 'package:mini_chat_app/services/chats/chat_services.dart';
import 'package:mini_chat_app/models/functions.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final AuthServices _authServices = AuthServices();
  final ScrollController _scrollController = ScrollController();
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
//event listner to focus the node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        // Scroll to show last message above keyboard when keyboard opens
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });

    //wait for the list viw to build and scorll to bottom
    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  // Scroll to the bottom of the chat list
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // Handle sending messages
  void sendMessage() async {
    //if there is somthing inside the texbox
    if (_messageController.text.isNotEmpty) {
      //send msg
      await _chatServices.sendMessage(
          widget.receiverID, _messageController.text);
      //clear the controller
      _messageController.clear();
    }
    scrollDown(); // Scroll down after sending a message
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          toCamelCase(extractNameFromEmail(widget.receiverEmail)),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()), // Messages list
          _buildUserInput(), // Message input field
        ],
      ),
    );
  }

  // Build the list of chat messages without showing a loader
  Widget _buildMessageList() {
    String senderID = _authServices.getCurrentUser()!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: _chatServices.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Show Snackbar for error
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Error loading messages"),
                duration: Duration(seconds: 2),
              ),
            );
          });
          return const SizedBox.shrink(); // Return an empty view on error
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Start Typing..."));
        } else {
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        }
      },
    );
  }

  // Build each individual message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser =
        data['senderID'] == _authServices.getCurrentUser()!.uid;
    return Container(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ChatBubble(
        isCurrentUser: isCurrentUser,
        message: data['message'],
        messageID: doc.id,
        userID: data['senderID'],
      ),
    );
  }

  // Build the user input field and send button
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
              focusNode: myFocusNode,
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
