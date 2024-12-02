import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool obscureText; 
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText; 

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText; 
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      style: const TextStyle(color: Colors.black, fontSize: 15.0),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        suffixIcon: widget.obscureText 
        ? IconButton(
            icon: Icon(
              _obscureText ? LucideIcons.eyeOff : LucideIcons.eye,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText; 
              });
            },
          )
        : null, 
      ),
    );
  }
}
