import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mini_chat_app/pages/blocked_users_page.dart';
import 'package:mini_chat_app/themes/theme_provider.dart'; // Fixed import typo
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          // Dark mode toggle
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(25),
            padding: const EdgeInsets.all(26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Dark Mode"),
                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme();
                  },
                ),
              ],
            ),
          ),
          // Blocked users section
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(25),
            padding: const EdgeInsets.all(26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Blocked Users"),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlockedUsersPage(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.arrow_forward_rounded,
                    color: Theme.of(context)
                        .colorScheme
                        .primary, // Adjusted for better visibility
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
