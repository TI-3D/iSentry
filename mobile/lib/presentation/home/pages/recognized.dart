import 'package:flutter/material.dart';
import 'package:isentry/data/recognized_dummy.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

class RecognizedPage extends StatelessWidget {
  const RecognizedPage({super.key});

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
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      icon: const Icon(LucideIcons.moreVertical),
                      onSelected: (value) {
                        // Logika untuk setiap aksi
                        switch (value) {
                          case 'edit':
                            debugPrint('Edit: ${recognized.nama}');
                            break;
                          case 'detail':
                            debugPrint('Detail: ${recognized.nama}');
                            break;
                          case 'delete':
                            debugPrint('Delete: ${recognized.nama}');
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
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
                          const PopupMenuDivider(),
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
                          const PopupMenuDivider(),
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
        onPressed: () {
          debugPrint('Tombol tambah ditekan');
        },
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(LucideIcons.plus, color: Colors.white),
      ),
    );
  }
}
