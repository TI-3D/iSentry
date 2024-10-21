import 'package:flutter/material.dart';
import 'package:pbl_op/data/recognized_dummy.dart';
import 'package:intl/intl.dart';

class MyTest extends StatelessWidget {
  const MyTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff1f4f9),
        elevation: 0,
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
                  Icons.search,
                  color: Color(0xffa1a1aa),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 1,
        childAspectRatio: 6.7,
        children: recoqnize.map((recognized) {
          final formattedDate =
              DateFormat("d MMMM yyyy").format(recognized.edit);
          return Container(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 5),
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
                          Icons.circle,
                          size: 40,
                          color: Color(0xffebebeb),
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
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Icon(Icons.more_vert_outlined),
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
        }).toList(),
      ),
    );
  }
}
