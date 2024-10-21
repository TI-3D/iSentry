import 'package:flutter/material.dart';

class MySort extends StatelessWidget {
  final List<String> texts;
  final int selectedIndex;

  const MySort({
    Key? key,
    required this.texts,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: const Color.fromARGB(255, 241, 244, 249),
          padding: const EdgeInsets.only(left: 35, right: 35, top: 14),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFe7e8eb),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(texts.length, (index) {
                return Container(
                  height: 25,
                  width: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: index == selectedIndex
                        ? Colors.black
                        : const Color(0xFFe7e8eb),
                  ),
                  child: Center(
                    child: Text(
                      texts[index],
                      style: TextStyle(
                        color: index == selectedIndex
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: const Color.fromARGB(255, 241, 244, 249),
          ),
        ),
      ],
    );
  }
}
