import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_chat_app/components/chat_bubble.dart';
import 'package:mini_chat_app/components/my_text_field.dart';
import 'package:mini_chat_app/services/auth/auth_service.dart';
import 'package:mini_chat_app/services/chats/chat_services.dart';
import 'package:mini_chat_app/models/user_details.dart'; // Import UserDetails model

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
  String toCamelCase(String text) {
    return text
        .toLowerCase()
        .split(' ')
        .map((str) =>
            str.isNotEmpty ? str[0].toUpperCase() + str.substring(1) : '')
        .join(' ');
  }

  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final AuthServices _authServices = AuthServices();
  final ScrollController _scrollController = ScrollController();
  FocusNode myFocusNode = FocusNode();
  String receiverName = ''; // Variable to store receiver's name

  @override
  void initState() {
    super.initState();
    _fetchReceiverName();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollDown();
        });
      }
    });

    // Ensure scrolling down after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollDown();
    });

    // Fetch receiver's name from Firestore
    _fetchReceiverName();
  }

  // String receiverName1 = '';
  final double _fontSize = 17.0; // Define your font size here

  Future<void> _fetchReceiverName() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.receiverID)
          .get();
      if (userDoc.exists) {
        UserDetails userDetails = UserDetails.fromFirestore(
          userDoc.data() as Map<String, dynamic>,
          widget.receiverID,
        );
        setState(() {
          receiverName =
              toCamelCase(userDetails.name); // Update receiver's name
        });
      }
    } catch (e) {
      // Handle error if necessary
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
        ),
      );
    }
  }

  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(
          widget.receiverID, _messageController.text);
      _messageController.clear();
      scrollDown(); // Scroll down after sending a message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          receiverName,
          style: TextStyle(fontSize: _fontSize), // Apply the font size here
        ),
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
      stream: _chatServices.getMessages(widget.receiverID, senderID),
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
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser =
        data['senderID'] == _authServices.getCurrentUser()!.uid;
    return Container(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ChatBubble(
        isCurrentUser: isCurrentUser,
        messsage: data['message'],
        messageID: doc.id,
        userID: data['senderID'],
      ),
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
