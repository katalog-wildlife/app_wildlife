import 'package:app_wildlife/view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_wildlife/view/home_page.dart';
import 'package:app_wildlife/view/screen/dashboard.dart';

class DynamicBottomNavBar extends StatefulWidget {
  const DynamicBottomNavBar({super.key});

  @override
  State<DynamicBottomNavBar> createState() => _DynamicBottomNavBarState();
}

class _DynamicBottomNavBarState extends State<DynamicBottomNavBar> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomePage(),
    const LoginScreen(),
    const MyDasboard(),
    // const MyImage()
    // const MyShared(),
  ];
  void onTabTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle), label: 'User'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.last_page_rounded), label: 'Shared Preferences'),
        ],
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}