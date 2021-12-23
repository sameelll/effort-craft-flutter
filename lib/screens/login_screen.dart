import 'dart:async';
import 'package:effort_craft/auth_service.dart';
import 'package:effort_craft/screens/landing_screen.dart';
import 'package:effort_craft/screens/home_screen.dart';
import 'package:effort_craft/screens/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Creating the textfield controller
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    final authService = Provider.of<AuthService>(context);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/login.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Get.to(() => const LandingScreen());
            },
          ),
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 161),
              child: Text(
                'Welcome\nBack',
                style: GoogleFonts.caveat(
                  textStyle: const TextStyle(
                      color: Color(0xFF1EAE98),
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  fillColor: Colors.grey.shade300,
                                  filled: true,
                                  hintText: "Email",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.green, width: 2.8)))),
                          const SizedBox(
                            height: 25,
                          ),
                          TextField(
                            controller: _passwordController,
                            style: const TextStyle(),
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade300,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2.8))),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.to(() => const SignUpScreen());
                                },
                                child: Text(
                                  'Sign Up',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.caveat(
                                    textStyle: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xFFFFD369),
                                        fontSize: 20),
                                  ),
                                ),
                                style: const ButtonStyle(),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Forgat Password?',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.caveat(
                                    textStyle: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xFFFFD369),
                                        fontSize: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign In',
                                style: GoogleFonts.caveat(
                                  textStyle: const TextStyle(
                                      color: Color(0xFF1EAE98),
                                      fontSize: 35,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              CircleAvatar(
                                radius: 27,
                                backgroundColor: const Color(0xFF1EAE98),
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: () async {
                                    authService.signInWithEmailAndPassword(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                    if (authService.user != null) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      await Future.delayed(
                                          const Duration(seconds: 1));
                                      setState(() {
                                        isLoading = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              duration: Duration(seconds: 5),
                                              elevation: 5,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 35,
                                                  horizontal: 110),
                                              shape: StadiumBorder(),
                                              backgroundColor:
                                                  Color(0xFF1EAE98),
                                              content: Text(
                                                "Welcome Back!",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Color(0xFF393E46),
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              )));
                                      Get.to(() => const MainScreen());
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              duration: Duration(seconds: 3),
                                              elevation: 0,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 16, horizontal: 12),
                                              shape: StadiumBorder(),
                                              backgroundColor: Colors.redAccent,
                                              content: Text(
                                                "Please check your email or password!",
                                                style: TextStyle(fontSize: 18),
                                                textAlign: TextAlign.center,
                                              )));
                                    }
                                  },
                                  icon: isLoading
                                      ? const CircularProgressIndicator(
                                          color: Color(0xff903749),
                                        )
                                      : const Icon(
                                          Icons.arrow_forward,
                                        ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
