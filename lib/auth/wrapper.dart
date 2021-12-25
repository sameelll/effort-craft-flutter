import 'package:effort_craft/auth/auth_service.dart';
import 'package:effort_craft/screens/login_screen.dart';
import 'package:effort_craft/screens/main_screen.dart';
import 'package:effort_craft/auth/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<UserAttributes?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<UserAttributes?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final UserAttributes? user = snapshot.data;
          return user == null ? const LoginScreen() : const MainScreen();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
