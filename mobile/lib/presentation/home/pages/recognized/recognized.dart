import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_bloc.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_event.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_state.dart';
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
    context.read<DetectionBloc>().add(DetectionDetail());
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
    return BlocConsumer<DetectionBloc, DetectionState>(
      listener: (context, state) {
        if (state is DetectionDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User deleted successfully')),
          );
        } else if (state is DetectionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.errorMessage}')),
          );
        }
      },
      builder: (context, state) {
        return BlocBuilder<DetectionBloc, DetectionState>(
          builder: (context, state) {
            if (state is DetectionLoading) {
              return const CircularProgressIndicator();
            } else if (state is DetectionFailure) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            } else if (state is DetailDetectionLoaded) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xfff1f4f9),
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(0),
                    child: Container(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, bottom: 2),
                      height: 38,
                      child: TextField(
                          decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xffe4e4e7),
                        hintText: 'Search...',
                        hintStyle: const TextStyle(color: Color(0xffa1a1aa)),
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
                  itemCount: state.recognizedDetails.length,
                  itemBuilder: (context, index) {
                    final details = state.recognizedDetails[index];
                    final formattedDate =
                        DateFormat("d MMMM yyyy").format(details.timestamp);
                    return Container(
                      padding:
                          const EdgeInsets.only(left: 30, right: 30, top: 7),
                      color: const Color(0xfff1f4f9),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    (LucideIcons.userCircle2),
                                    size: 35,
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${details.identityName}',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
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
                                icon: const Icon(LucideIcons.moreVertical),
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
                                                name: '${details.identityName}',
                                              ));
                                    case 'edit':
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (_) => EditData(
                                            name: '${details.identityName}'),
                                      );
                                      break;
                                    case 'detail':
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (_) => Details(
                                          name: '${details.identityName}',
                                          lastActivity: '-',
                                        ),
                                      );
                                      break;
                                    case 'delete':
                                      context.read<DetectionBloc>().add(
                                          DeleteDetection(id: '${details.id}'));
                                      break;
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    const PopupMenuItem<String>(
                                      value: 'add',
                                      child: Row(
                                        children: [
                                          Icon(LucideIcons.userPlus, size: 18),
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
                                          Icon(LucideIcons.pencil, size: 18),
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
                                          Icon(LucideIcons.info, size: 18),
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
                                            style: TextStyle(color: Colors.red),
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
                  },
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => _showAddDataBottomSheet(context),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(LucideIcons.plus, color: Colors.white),
                ),
              );
            }
            return const Center(child: Text("No data found"));
          },
        );
      },
    );
  }
}
