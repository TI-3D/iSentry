import 'package:flutter/material.dart';
import 'package:isentry/common/helper/navigation/app_navigation.dart';
import 'package:isentry/presentation/auth/pages/login.dart';
import 'package:isentry/presentation/home/pages/profile/qr_code.dart';
import 'package:isentry/presentation/widgets/appBar/appbar.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AccountSettingsPage extends StatelessWidget {
  final int userId;
  const AccountSettingsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Account Settings',
        onLeadingPressed: () {
          Navigator.pop(context);
        },
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
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey,
                      child: Text('I'),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hello!',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                              color: Colors.grey),
                        ),
                        Text(
                          'userId',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(LucideIcons.qrCode, size: 26),
                  onPressed: () {
                    AppNavigator.push(context, QrCodePage(userId: userId));
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Menu Items
            ListTile(
              dense: true,
              leading: const Icon(LucideIcons.userCircle2),
              title: const Text(
                'Edit Account',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              subtitle: const Text(
                'Update your personal information.',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1),
              ),
              onTap: () {
                // Logic for Edit Account
              },
            ),
            const Divider(),
            ListTile(
              dense: true,
              leading: const Icon(LucideIcons.history),
              title: const Text(
                'Log Activity',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              subtitle: const Text(
                'View your activity history.',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1),
              ),
              onTap: () {
                // Logic for Log Activity
              },
            ),
            const Divider(),
            // // ListTile(
            // //   leading: const Icon(LucideIcons.settings),
            // //   title: const Text('Setting',
            // //     style: TextStyle(
            // //       fontWeight: FontWeight.w500,
            // //       fontSize: 15,
            // //     ),
            // //   ),
            // //   subtitle: const Text('Customize your app experience.',
            // //     style: TextStyle(
            // //       fontSize: 13,
            // //       color: Colors.grey,
            // //       fontWeight: FontWeight.w500,
            // //       letterSpacing: 1
            // //     ),
            // //   ),
            // //   onTap: () {
            // //     // Logic for Settings
            // //   },
            // // ),
            // const Divider(),
            ListTile(
              dense: true,
              leading: const Icon(LucideIcons.settings),
              title: const Text(
                'Setting',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              subtitle: const Text(
                'Customize your app experience.',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1),
              ),
              onTap: () {
                // Logic for Settings
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(LucideIcons.heartHandshake),
              title: const Text(
                'About Us',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              subtitle: const Text(
                'Learn app and development team.',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1),
              ),
              onTap: () {
                // Logic for About Us
              },
            ),
            const Divider(),

            // Logout
            ListTile(
              dense: true,
              leading: const Icon(LucideIcons.logOut, color: Colors.red),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              subtitle: const Text(
                'Log out of your account.',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1),
              ),
              onTap: () {
                AppNavigator.pushAndRemove(context, const LoginPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
