import 'package:flutter/material.dart';
import 'package:mini_chat_app/components/user_tile.dart';
import 'package:mini_chat_app/models/user_details.dart';
import 'package:mini_chat_app/pages/chat_page.dart';
import 'package:mini_chat_app/services/auth/auth_service.dart';
import 'package:mini_chat_app/components/my_drawer.dart';
import 'package:mini_chat_app/services/chats/chat_services.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final AuthServices _authServices = AuthServices();
  final ChatServices _chatServices = ChatServices();

  Widget _buildUserList() {
    return StreamBuilder<List<UserDetails>>(
      stream: _chatServices.getUsersStreamExcludingBlocked(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Show Snackbar for error
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Error"),
                duration: Duration(seconds: 2),
              ),
            );
          });
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
                  "Loading...",
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
    // Ensure you are comparing email correctly
    // ignore: unrelated_type_equality_checks
    if (user.email != currentUser) {
      return UserTile(
        text: user.email,
        fontSize: 16, // Specify your desired font size here
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: user.email, // Ensure correct parameter
                reciverID: user.uid, // Ensure correct parameter
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
        title: Center(
          child: Text(
            "U S E R S",
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 20,
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
