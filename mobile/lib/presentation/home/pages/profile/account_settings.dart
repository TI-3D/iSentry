import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isentry/common/helper/navigation/app_navigation.dart';
import 'package:isentry/presentation/auth/bloc/login_bloc.dart';
import 'package:isentry/presentation/auth/bloc/login_event.dart';
import 'package:isentry/presentation/auth/bloc/login_state.dart';
import 'package:isentry/presentation/auth/pages/login.dart';
import 'package:isentry/presentation/home/bloc/user/user_bloc.dart';
import 'package:isentry/presentation/home/bloc/user/user_event.dart';
import 'package:isentry/presentation/home/bloc/user/user_state.dart';
import 'package:isentry/presentation/home/pages/profile/qr_code.dart';
import 'package:isentry/presentation/widgets/appBar/appbar.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AccountSettingsPage extends StatefulWidget {
  final String userId;
  const AccountSettingsPage({super.key, required this.userId});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  @override
  void initState() {
    context.read<UserBloc>().add(GetUserById(id: widget.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          Fluttertoast.showToast(
            msg: "Logout Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          AppNavigator.push(context, const LoginPage());
        } else if (state is LoginFailure) {
          Fluttertoast.showToast(
            msg: state.errorMessage,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserFailure) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else if (state is UserLoaded) {
            final role = state.user.role.toString();
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
                                  state.user.name,
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
                        if (role == 'Role.OWNER')
                          IconButton(
                            icon: const Icon(LucideIcons.qrCode, size: 26),
                            onPressed: () {
                              AppNavigator.push(
                                  context, QrCodePage(userId: widget.userId));
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
                      enabled: false,
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
                      enabled: false,
                      onTap: () {
                      // Logic for Log Activity
                      },
                    ),
                    const Divider(),
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
                      enabled: false,
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
                      enabled: false,
                      onTap: () {
                      // Logic for About Us
                      },
                    ),
                    const Divider(),

                    // Logout
                    ListTile(
                      dense: true,
                      leading:
                          const Icon(LucideIcons.logOut, color: Colors.red),
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
                        context
                            .read<LoginBloc>()
                            .add(LogoutRequested(id: widget.userId));
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text("No Data Found"));
        },
      ),
    );
  }
}
