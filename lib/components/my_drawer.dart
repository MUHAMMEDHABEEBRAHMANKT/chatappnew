import 'package:flutter/material.dart';
import 'package:mini_chat_app/services/auth/auth_service.dart';
import 'package:mini_chat_app/pages/settings_page.dart';

// ignore: must_be_immutable
class MyDrawer extends StatelessWidget {
  void Function()? onTap;
  MyDrawer({super.key});
  void logout() {
    final auth = AuthServices();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      width: 250,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(children: [
          //   logo
          DrawerHeader(
              child: Center(
            child: Icon(
              Icons.message,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
          )),
          //home list hear
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: ListTile(
              title: const Text("H O M E"),
              leading: const Icon(Icons.home),
              onTap: () {
                //go back to home
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: ListTile(
              title: const Text("S E T T I N G S"),
              leading: const Icon(Icons.settings),
              onTap: () {
                //go back to home
                Navigator.pop(context);
                //navigate to settings page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ));
              },
            ),
          )
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: ListTile(
            title: const Text("L O G O U T"),
            leading: const Icon(Icons.logout),
            onTap: logout,
          ),
        ),
      ]),
    );
  }
}
