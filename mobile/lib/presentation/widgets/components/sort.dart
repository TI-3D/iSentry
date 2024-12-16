import 'package:flutter/material.dart';

class MySort extends StatefulWidget {
  final List<String> texts;
  final double leftPadding;
  final double rightPadding;
  final Function(int) onItemSelected;

  const MySort({
    super.key,
    required this.texts,
    required this.leftPadding,
    required this.rightPadding,
    required this.onItemSelected,
  });

  @override
  State<MySort> createState() => _MySortState();
}

class _MySortState extends State<MySort> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 241, 244, 249),
      padding: EdgeInsets.only(
        left: widget.leftPadding,
        right: widget.rightPadding,
        top: 14,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFe7e8eb),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(widget.texts.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                widget.onItemSelected(index);
              },
              child: Container(
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
                    widget.texts[index],
                    style: TextStyle(
                      color:
                          index == selectedIndex ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
