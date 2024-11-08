import 'package:flutter/material.dart';
import 'package:isentry/data/recognized_dummy.dart';
import 'package:intl/intl.dart';
import 'package:isentry/presentation/home/pages/recognized/bottom_sheets/add_data.dart';
import 'package:isentry/presentation/home/pages/recognized/bottom_sheets/detail_data.dart';
import 'package:isentry/presentation/home/pages/recognized/bottom_sheets/edit_data.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RecognizedPage extends StatelessWidget {
  const RecognizedPage({super.key});

  void _showAddDataBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddDataBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff1f4f9),
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 2),
            height: 38,
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xffe4e4e7),
                hintText: 'Search...',
                hintStyle: const TextStyle(color: Color(0xffa1a1aa)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: recoqnize.length,
        itemBuilder: (context, index) {
          final recognized = recoqnize[index];
          final formattedDate =
              DateFormat("d MMMM yyyy").format(recognized.edit);
          return Container(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 7),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recognized.nama,
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
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) =>
                                  EditDataBottomSheet(name: recognized.nama),
                            );
                            break;
                          case 'detail':
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) =>
                                  DetailDataBottomSheet(name: recognized.nama),
                            );
                            break;
                          case 'delete':
                            debugPrint('Delete: ${recognized.nama}');
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem<String>(
                            padding: EdgeInsets.zero,
                            value: 'edit',
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 14, left: 12, top: 6),
                                  child: Row(
                                    children: [
                                      Icon(LucideIcons.pencil, size: 18),
                                      SizedBox(width: 10),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
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
                          PopupMenuItem<String>(
                            padding: EdgeInsets.zero,
                            value: 'delete',
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.black,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      top: 14, left: 12, bottom: 6),
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
                              ],
                            ),
                          ),
                          // const PopupMenuDivider(),
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
}
