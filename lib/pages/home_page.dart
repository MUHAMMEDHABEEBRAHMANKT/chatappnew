// import 'package:flutter/material.dart';
// import 'package:mini_chat_app/components/user_tile.dart';
// import 'package:mini_chat_app/pages/chat_page.dart';
// import 'package:mini_chat_app/services/auth/auth_service.dart';
// import 'package:mini_chat_app/components/my_drawer.dart';
// import 'package:mini_chat_app/services/chats/chat_services.dart';

// class HomePage extends StatelessWidget {
//   HomePage({super.key});

//   final AuthServices _authServices = AuthServices();
//   final ChatServices _chatServices = ChatServices();

//   Widget _buildUserList() {
//     return StreamBuilder(
//       stream: _chatServices.getUserStream(),
//       builder: (context, snapshot) {
//         //check any error
//         if (snapshot.hasError) {
//           return const Text("Error");
//         }

//         //loading
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//               child: Text(
//             "Loading...",
//             style: TextStyle(
//               fontSize: 20,
//             ),
//           ));
//         }
//         //return the list view
//         return ListView(
//           children: snapshot.data!
//               .map<Widget>((userData) => _buildUserListItem(userData, context))
//               .toList(),
//         );
//       },
//     );
//   }

//   Widget _buildUserListItem(
//       Map<String, dynamic> userData, BuildContext context) {
//     //display all the user except current user
//     if (userData["email"] != _authServices.getCurrentUser()!.email) {
//       return UserTile(
//         text: userData["email"],
//         onTap: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ChatPage(
//                   receiverEmail: userData['email'],
//                 ),
//               ));
//         },
//       );
//     } else {
//       return Container();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Padding(
//           padding: const EdgeInsets.only(left: 85),
//           child: Text(
//             "Home",
//             style: TextStyle(
//                 color: (Theme.of(context).colorScheme.inversePrimary),
//                 fontSize: 30,
//                 fontWeight: FontWeight.w500),
//           ),
//         ),
//       ),
//       drawer: MyDrawer(),
//       body: _buildUserList(),
//     );
//   }
// }

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
      stream: _chatServices.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Text("Loading...", style: TextStyle(fontSize: 20)));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Text("No data available");
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
    return UserTile(
      text: user.email,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverEmail: user.email,
            ),
          ),
        );
      },
    );
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
