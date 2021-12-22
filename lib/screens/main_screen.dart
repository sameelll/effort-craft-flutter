import 'package:effort_craft/screens/subscreens/add_task_screen.dart';
import 'package:effort_craft/components/app_bar.dart';
import 'package:effort_craft/screens/subscreens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _bottomNavIndex = 0;
  Widget _currentScreen = const ProfileScreen();

  Future signOut() async {
    try {
      return await FirebaseAuth.instance.signOut();
    } catch (e) {
      e.toString();
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF393E46),
        appBar: AppBarFb2(
          onTap: signOut,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFFFD369).withOpacity(0.85),
          child: const Icon(
            Icons.add,
            size: 34,
            color: Color(0xFF393E46),
          ),
          onPressed: () {
            setState(() {
              _currentScreen = const AddTaskScreen();
            });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: const [
            Icons.home_filled,
            Icons.search,
            Icons.check,
            Icons.emoji_events
          ],
          activeColor: const Color(0xff903749),
          inactiveColor: Colors.black54,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          backgroundColor: Colors.blueGrey.shade300,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          activeIndex: _bottomNavIndex,
          onTap: (index) => setState(() {
            _bottomNavIndex = index;
            _currentScreen =
                (index == 0) ? const ProfileScreen() : const AddTaskScreen();
          }),
          //other params
        ),
        body: _currentScreen);
  }
}
