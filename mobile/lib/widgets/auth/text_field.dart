import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller; // Menambahkan controller
  final TextInputType keyboardType; // Menambahkan opsi untuk tipe keyboard

  const CustomTextField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    this.suffixIcon,
    this.controller, // Menambahkan parameter controller
    this.keyboardType = TextInputType.text, // Default tipe keyboard
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller, // Menyambungkan controller
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType, // Menyambungkan tipe keyboard
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(),
        suffixIcon: widget.suffixIcon, // Menambahkan suffixIcon
      ),
    );
  }
}
