import 'package:flutter/material.dart';
import 'package:isentry/common/helper/navigation/app_navigation.dart';
import 'package:isentry/presentation/home/pages/camera/camera.dart';
import 'package:isentry/presentation/home/pages/dashboard.dart';
import 'package:isentry/presentation/home/pages/recognized/recognized.dart';
import 'package:isentry/presentation/home/pages/unrecognized/unrecognized.dart';
import 'package:lucide_icons/lucide_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomAppBarState createState() => _BottomAppBarState();
}

class _BottomAppBarState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DashboardPage(),
    RecognizedPage(),
    Center(child: Text('Camera')),
    UnrecognizedPage(),
    // Center(child: Text('Unrecognized Screen')),
    Center(child: Text('Gallery Screen')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (index == 2) {
        AppNavigator.push(context, const CameraPage());
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
            icon: const Icon(LucideIcons.layoutDashboard),
            label: _selectedIndex == 0 ? 'Dashboard' : '',
          ),
          BottomNavigationBarItem(
            icon: const Icon(LucideIcons.users),
            label: _selectedIndex == 1 ? 'Recognized' : '',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.black),
              child: const Icon(
                LucideIcons.view,
                color: Color(0xfff1f4f9),
              ),
            ),
            label: _selectedIndex == 2 ? '' : '',
          ),
          BottomNavigationBarItem(
            icon: const Icon(LucideIcons.bot),
            label: _selectedIndex == 3 ? 'Unrecognized' : '',
          ),
          BottomNavigationBarItem(
            icon: const Icon(LucideIcons.image),
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
          fontSize: 10,
          letterSpacing: 1,
          height: 2.0,
        ),
      ),
    );
  }
}
