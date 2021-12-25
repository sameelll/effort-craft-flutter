import 'package:effort_craft/auth/auth_service.dart';
import 'package:effort_craft/screens/subscreens/achivements_screen.dart';
import 'package:effort_craft/screens/subscreens/add_task_screen.dart';
import 'package:effort_craft/components/app_bar.dart';
import 'package:effort_craft/screens/subscreens/completed_screen.dart';
import 'package:effort_craft/screens/subscreens/home_screen.dart';
import 'package:effort_craft/screens/subscreens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _bottomNavIndex = 0;
  Widget _currentScreen = const HomeScreen();
  var _iconType = Icons.add;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
        backgroundColor: const Color(0xFF393E46),
        appBar: AppBarFb2(
          onTap: () async {
            await authService.signOut();
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFFFFD369).withOpacity(0.85),
          child: Icon(
            _iconType,
            size: 34,
            color: const Color(0xFF393E46),
          ),
          onPressed: () {
            setState(() {
              _currentScreen = const AddTaskScreen();
              _iconType = Icons.view_in_ar;
            });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: const [
            Icons.home_filled,
            Icons.check,
            Icons.emoji_events,
            Icons.person
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
            _currentScreen = (index == 0)
                ? const HomeScreen()
                : (index == 1)
                    ? const CompletedScreen()
                    : (index == 2)
                        ? const AchivementsScreen()
                        : (index == 3)
                            ? const ProfileScreen()
                            : const AddTaskScreen();
            _iconType = Icons.add;
          }),
          //other params
        ),
        body: _currentScreen);
  }
}
