import 'package:flutter/material.dart';

class BottomAppBarExample extends StatefulWidget {
  @override
  _BottomAppBarExampleState createState() => _BottomAppBarExampleState();
}

class _BottomAppBarExampleState extends State<BottomAppBarExample> {
  int _selectedIndex = 0; // Untuk menyimpan indeks yang dipilih

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Selected: ${_selectedIndex + 1}',
          style: const TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: _selectedIndex == 0 ? 'Dashboard' : '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            label: _selectedIndex == 1 ? 'Recognized' : '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: _selectedIndex == 2 ? '' : '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_off_outlined),
            label: _selectedIndex == 3 ? 'Unrecognized' : '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library_outlined),
            label: _selectedIndex == 4 ? 'Gallery' : '',
          ),
        ],
        currentIndex: _selectedIndex, // Indeks item yang dipilih
        selectedItemColor: Colors.black, // Warna item yang dipilih
        unselectedItemColor: Colors.grey, // Warna item yang tidak dipilih
        onTap: _onItemTapped, // Callback ketika item dipilih

        // Modifikasi untuk menaikkan ikon yang dipilih
        selectedIconTheme: const IconThemeData(
          size: 30, // ukuran ikon yang dipilih lebih besar
        ),
        unselectedIconTheme: const IconThemeData(
          size: 24, // ukuran ikon yang tidak dipilih
        ),
        showUnselectedLabels:
            false, // Menyembunyikan label untuk ikon yang tidak dipilih
        type: BottomNavigationBarType
            .fixed, // memastikan label tetap ditampilkan untuk ikon yang terpilih
        selectedLabelStyle: const TextStyle(
          fontSize: 8,
          letterSpacing: 1,
          height: 2.0,
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BottomAppBarExample(),
  ));
}
