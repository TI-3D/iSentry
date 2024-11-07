import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final Widget content;
  final Widget actionButton;

  const CustomBottomSheet({
    super.key,
    required this.title,
    required this.content,
    required this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xfff1f4f9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          content,
          const SizedBox(height: 20),
          actionButton,
        ],
      ),
    );
  }
}
