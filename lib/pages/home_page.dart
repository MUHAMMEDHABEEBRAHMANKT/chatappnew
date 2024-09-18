// home_page.dart
import 'package:flutter/material.dart';
import 'package:mini_chat_app/components/user_tile.dart';
import 'package:mini_chat_app/pages/chat_page.dart';
import 'package:mini_chat_app/services/auth/auth_service.dart';
import 'package:mini_chat_app/components/my_drawer.dart';
import 'package:mini_chat_app/services/chats/chat_services.dart';
import 'package:mini_chat_app/services/chats/user_details.dart'; // Import UserDetails

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final AuthServices _authServices = AuthServices();
  final ChatServices _chatServices = ChatServices();

  Widget _buildUserList() {
    return StreamBuilder<List<UserDetails>>(
      stream: _chatServices.getUsersStreamExcludingBlocked(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                    height:
                        10), // Adds some spacing between the indicator and text
                Text(
                  "Loading",
                  style: TextStyle(fontSize: 17),
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Text("No Data Available Right Now!!");
        }

        List<UserDetails> users = snapshot.data!;
        return ListView(
          children: users
              .where(
                  (user) => user.email != _authServices.getCurrentUser()?.email)
              .map<Widget>((user) => _buildUserListItem(user, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(UserDetails user, BuildContext context) {
    final currentUser = _authServices.getCurrentUser();
    // ignore: unrelated_type_equality_checks
    if (user.email != currentUser) {
      return UserTile(
        text: user
            .email, //hear i need the users name when they entered registering
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: user.email,
                reciverID: user.uid,
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 85),
          child: Text(
            "Home",
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      drawer: MyDrawer(),
      body: _buildUserList(),
    );
  }
}
