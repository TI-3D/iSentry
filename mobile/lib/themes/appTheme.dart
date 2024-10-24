import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  // Warna dasar aplikasi
  scaffoldBackgroundColor: const Color(0xFAFAFAFA), // Background aplikasi

  // Font
  fontFamily: 'SFPro', // Pastikan SFPro sudah ditambahkan di pubspec.yaml
  
  // Skema warna
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
      .copyWith(background: const Color(0xFAFAFAFA)),

  // Pengaturan teks
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700, // Bobot teks bold
      color: Color(0xFF1A1A1A),  // Warna teks gelap
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400, // Bobot teks normal
      color: Color(0xFF1A1A1A),  // Warna teks gelap
    ),
  ),
);
