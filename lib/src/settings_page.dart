// File: settings_page.dart

import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('Notification Preferences'),
            subtitle: const Text('Manage your notification settings'),
            trailing: const Icon(Icons.notifications),
            onTap: () {
              // Navigate to notification settings
            },
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: const Text('Select your preferred language'),
            trailing: const Icon(Icons.language),
            onTap: () {
              // Navigate to language settings
            },
          ),
          ListTile(
            title: const Text('Privacy'),
            subtitle: const Text('Adjust your privacy settings'),
            trailing: const Icon(Icons.privacy_tip),
            onTap: () {
              // Navigate to privacy settings
            },
          ),
          // Add more settings options as needed
        ],
      ),
    );
  }
}
