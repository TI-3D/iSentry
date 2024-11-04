import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  // ignore: non_constant_identifier_names
  final Color Backcolor;
  // ignore: non_constant_identifier_names
  final Color TextColor;
  final BorderSide? border;

  const CustomElevatedButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    // ignore: non_constant_identifier_names
    required this.Backcolor,
    // ignore: non_constant_identifier_names
    required this.TextColor,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: Backcolor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: border ?? BorderSide.none,
        ),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 15,
          color: TextColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
