import 'package:effort_craft/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarFb2 extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final Function() onTap;

  AppBarFb2({Key? key, required this.onTap})
      : preferredSize = const Size.fromHeight(56.0),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF393E46);

    return AppBar(
      title: Center(
        child: Text("Effortcraft",
            style: GoogleFonts.lato(
                textStyle: const TextStyle(
              color: Color(0xff903749),
              fontWeight: FontWeight.bold,
              fontSize: 34,
            ))),
      ),
      backgroundColor: Colors.blueGrey.shade300,
      actions: [
        IconButton(
            icon: const Icon(
              Icons.logout,
              color: accentColor,
            ),
            onPressed: () {
              onTap();
              Get.to(() => const LoginScreen());
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 5),
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 80),
                  shape: StadiumBorder(),
                  backgroundColor: Color(0xFF1EAE98),
                  content: Text(
                    "Logout Successful!",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF393E46),
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )));
            })
      ],
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: accentColor,
        ),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }
}
