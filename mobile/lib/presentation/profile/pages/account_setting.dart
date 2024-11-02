import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AccountSettingPage extends StatelessWidget {
  const AccountSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Menjadikan judul di AppBar berada di tengah
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      child: Text(
                          'PEH'), // Placeholder for profile picture initials
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello!',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          'Pak Enggal',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(LucideIcons.qrCode),
                  onPressed: () {
                    // Logic for QR code
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),

            // Menu Items
            ListTile(
              leading: const Icon(LucideIcons.userCircle2),
              title: const Text('Edit Account'),
              subtitle: const Text('Profile, change password'),
              onTap: () {
                // Logic for Edit Account
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(LucideIcons.history),
              title: const Text('Log Activity'),
              subtitle: const Text('Profile, change password'),
              onTap: () {
                // Logic for Log Activity
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(LucideIcons.settings),
              title: const Text('Setting'),
              subtitle: const Text('Profile, change password'),
              onTap: () {
                // Logic for Settings
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(LucideIcons.heartHandshake),
              title: const Text('About Us'),
              subtitle: const Text('Profile, change password'),
              onTap: () {
                // Logic for About Us
              },
            ),
            const Divider(),

            // Logout
            ListTile(
              leading: const Icon(LucideIcons.logOut, color: Colors.red),
              title: const Text(
                'Log Out',
                style: TextStyle(color: Colors.red),
              ),
              subtitle: const Text('Profile, change password'),
              onTap: () {
                // Logic for Log Out
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
