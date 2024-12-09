import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isentry/presentation/home/bloc/identity/identity_bloc.dart';
import 'package:isentry/presentation/home/bloc/identity/identity_event.dart';
import 'package:isentry/presentation/home/bloc/identity/identity_state.dart';
import 'package:isentry/presentation/home/bloc/user/user_bloc.dart';
import 'package:isentry/presentation/home/bloc/user/user_event.dart';
import 'package:isentry/presentation/home/bloc/user/user_state.dart';
import 'package:isentry/presentation/home/pages/recognized/bottom_sheets/add_account.dart';
import 'package:isentry/presentation/home/pages/recognized/bottom_sheets/add_data.dart';
import 'package:isentry/presentation/home/pages/recognized/bottom_sheets/detail_data.dart';
import 'package:isentry/presentation/home/pages/recognized/bottom_sheets/edit_data.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RecognizedPage extends StatefulWidget {
  final String userId;
  const RecognizedPage({super.key, required this.userId});

  @override
  State<RecognizedPage> createState() => _RecognizedPageState();
}

class _RecognizedPageState extends State<RecognizedPage> {
  @override
  void initState() {
    super.initState();
    context.read<IdentityBloc>().add(GetAllIdentity());
    context.read<UserBloc>().add(GetAllUser());
  }

  void _showAddDataBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IdentityBloc, IdentityState>(
      listener: (context, state) {
        if (state is IdentityDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Identity deleted successfully')),
          );
        } else if (state is IdentityFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.errorMessage}')),
          );
        }
      },
      builder: (context, state) {
        return BlocBuilder<IdentityBloc, IdentityState>(
          builder: (context, identityState) {
            if (identityState is IdentityLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (identityState is IdentityFailure) {
              return Center(
                  child: Text('Error: ${identityState.errorMessage}'));
            } else if (identityState is AllIdentityLoaded) {
              return BlocBuilder<UserBloc, UserState>(
                builder: (context, userState) {
                  if (userState is UserLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (userState is UserFailure) {
                    return Center(
                        child: Text('Error: ${userState.errorMessage}'));
                  } else if (userState is AllUserLoaded) {
                    final userIds =
                        userState.users.map((user) => user.identityId).toSet();
                    return Scaffold(
                      appBar: AppBar(
                        backgroundColor: const Color(0xfff1f4f9),
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(0),
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, bottom: 2),
                            height: 38,
                            child: TextField(
                                decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xffe4e4e7),
                              hintText: 'Search...',
                              hintStyle:
                                  const TextStyle(color: Color(0xffa1a1aa)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color(0xffa1a1aa),
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color(0xffa1a1aa),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              prefixIcon: const Icon(
                                LucideIcons.search,
                                color: Color(0xffa1a1aa),
                                size: 18,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                            )),
                          ),
                        ),
                      ),
                      body: ListView.builder(
                        itemCount: identityState.identities.length + 1,
                        itemBuilder: (context, index) {
                          if (index < identityState.identities.length) {
                            final identities = identityState.identities[index];
                            final hasAccount = userIds.contains(identities.id);
                            final formattedDate = DateFormat("d MMMM yyyy")
                                .format(identities.updatedAt);
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, top: 7),
                              color: const Color(0xfff1f4f9),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            (LucideIcons.userCircle2),
                                            size: 35,
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    identities.name,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  if (hasAccount)
                                                    const Icon(
                                                      Icons.check_box,
                                                      size: 14,
                                                    ),
                                                ],
                                              ),
                                              Text(
                                                "Last Modified $formattedDate",
                                                style: const TextStyle(
                                                  color: Color(0xffa1a1aa),
                                                  letterSpacing: 1.5,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      PopupMenuButton<String>(
                                        color: const Color(0xfff1f4f9),
                                        elevation: 8,
                                        shadowColor: Colors.black,
                                        icon: const Icon(
                                            LucideIcons.moreVertical),
                                        constraints: const BoxConstraints(
                                          minWidth:
                                              150, // Menyesuaikan lebar popup menu
                                          maxWidth:
                                              180, // Mengatur batas maksimum lebar
                                        ),
                                        onSelected: (value) {
                                          switch (value) {
                                            case 'add':
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (_) => AddAccount(
                                                  userId: widget.userId,
                                                  name: identities.name,
                                                  identityId: identities.id,
                                                ),
                                              ).then((_) {
                                                Future.delayed(
                                                    const Duration(seconds: 1),
                                                    () {
                                                  // ignore: use_build_context_synchronously
                                                  context
                                                      .read<UserBloc>()
                                                      .add(GetAllUser());
                                                });
                                              });
                                              break;
                                            case 'edit':
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (_) => EditData(
                                                    name: identities.name),
                                              );
                                              break;
                                            case 'detail':
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (_) => Details(
                                                  name: identities.name,
                                                  id: identities.id,
                                                ),
                                              );
                                              break;
                                            case 'delete':
                                              context.read<IdentityBloc>().add(
                                                  DeleteIdentity(
                                                      id: '${identities.id}'));
                                              break;
                                          }
                                        },
                                        itemBuilder: (BuildContext context) {
                                          return [
                                            if (!hasAccount)
                                              const PopupMenuItem<String>(
                                                value: 'add',
                                                child: Row(
                                                  children: [
                                                    Icon(LucideIcons.userPlus,
                                                        size: 18),
                                                    SizedBox(width: 10),
                                                    Text('Add Account'),
                                                  ],
                                                ),
                                              ),
                                            const PopupMenuDivider(height: 1),
                                            const PopupMenuItem<String>(
                                              value: 'edit',
                                              child: Row(
                                                children: [
                                                  Icon(LucideIcons.pencil,
                                                      size: 18),
                                                  SizedBox(width: 10),
                                                  Text('Edit'),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuDivider(height: 1),
                                            const PopupMenuItem<String>(
                                              value: 'detail',
                                              child: Row(
                                                children: [
                                                  Icon(LucideIcons.info,
                                                      size: 18),
                                                  SizedBox(width: 10),
                                                  Text('Detail'),
                                                ],
                                              ),
                                            ),
                                            const PopupMenuDivider(height: 1),
                                            const PopupMenuItem<String>(
                                              value: 'delete',
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    LucideIcons.trash2,
                                                    size: 18,
                                                    color: Colors.red,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ];
                                        },
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox(height: 100);
                          }
                        },
                      ),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () => _showAddDataBottomSheet(context),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child:
                            const Icon(LucideIcons.plus, color: Colors.white),
                      ),
                    );
                  }
                  return const Center(child: Text("No data found"));
                },
              );
            }
            return const Center(child: Text("No data found"));
          },
        );
      },
    );
  }
}
