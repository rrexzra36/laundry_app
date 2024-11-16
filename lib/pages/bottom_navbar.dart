// bottom_navbar.dart
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../pages/dashboard.dart';
import '../pages/setting.dart';
import '../utils/constants.dart';
import 'laporan.dart';
import 'pesanan.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _activeIndex = 0;

  // List of pages for navigation
  final List<Widget> _pages = [
    Dashboard(),
    Pesanan(),
    Laporan(),
    Setting(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_activeIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Constants.scaffoldBackgroundColor,
        buttonBackgroundColor: Constants.primaryColor,
        items: [
          Icon(
            Icons.home,
            size: 30.0,
            color: _activeIndex == 0 ? Colors.white : const Color(0xFFC8C9CB),
          ),
          Icon(
            Icons.list_alt,
            size: 30.0,
            color: _activeIndex == 1 ? Colors.white : const Color(0xFFC8C9CB),
          ),
          Icon(
            Icons.bar_chart,
            size: 30.0,
            color: _activeIndex == 2 ? Colors.white : const Color(0xFFC8C9CB),
          ),
          Icon(
            Icons.settings,
            size: 30.0,
            color: _activeIndex == 3 ? Colors.white : const Color(0xFFC8C9CB),
          ),
        ],
        onTap: (index) {
          setState(() {
            _activeIndex = index;
          });
        },
      ),
    );
  }
}
