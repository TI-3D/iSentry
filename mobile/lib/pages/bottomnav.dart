import 'package:flutter/material.dart';
import 'package:pbl_op/pages/dashboard_screen.dart';
import 'package:pbl_op/pages/recognized_screen.dart';
import 'package:go_router/go_router.dart';

class BottomAppBarExample extends StatefulWidget {
  const BottomAppBarExample({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomAppBarExampleState createState() => _BottomAppBarExampleState();
}

class _BottomAppBarExampleState extends State<BottomAppBarExample> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    MyTest(),
    Center(child: Text('Camera')),
    Center(child: Text('Unrecognized Screen')),
    Center(child: Text('Gallery Screen')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (index == 2) {
        GoRouter.of(context).go('/camera');
      } else {
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xfff1f4f9),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            label: _selectedIndex == 0 ? 'Dashboard' : '',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.group_outlined),
            label: _selectedIndex == 1 ? 'Recognized' : '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.black),
              child: const Icon(
                Icons.camera,
                color: Color(0xfff1f4f9),
              ),
            ),
            label: _selectedIndex == 2 ? '' : '',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_off_outlined),
            label: _selectedIndex == 3 ? 'Unrecognized' : '',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.photo_library_outlined),
            label: _selectedIndex == 4 ? 'Gallery' : '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        elevation: 0,
        selectedIconTheme: const IconThemeData(
          size: 30,
        ),
        unselectedIconTheme: const IconThemeData(
          size: 24,
        ),
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontSize: 8,
          letterSpacing: 1,
          height: 2.0,
        ),
      ),
    );
  }
}
