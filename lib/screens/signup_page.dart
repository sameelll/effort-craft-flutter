import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:effort_craft/auth/auth_service.dart';
import 'package:effort_craft/screens/landing_screen.dart';
import 'package:effort_craft/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _nameController = TextEditingController();

    final authService = Provider.of<AuthService>(context);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/signUp.jpg'), fit: BoxFit.cover),
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
              padding: const EdgeInsets.only(left: 35, top: 34),
              child: Text(
                'Create\nAccount',
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
                    top: MediaQuery.of(context).size.height * 0.28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade300,
                                filled: true,
                                hintText: "Full Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2.8))),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade300,
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                        color: Colors.green, width: 2.8))),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.black),
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
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sign Up',
                                style: GoogleFonts.caveat(
                                  textStyle: const TextStyle(
                                      color: Color(0xFFFFD369),
                                      fontSize: 35,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              CircleAvatar(
                                radius: 27,
                                backgroundColor: const Color(0xFFFFD369),
                                child: IconButton(
                                    color: Colors.black,
                                    onPressed: () async {
                                      await authService
                                          .createUserWithEmailAndPassword(
                                        _emailController.text,
                                        _passwordController.text,
                                      )
                                          .then((value) {
                                        if (value != null) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(value.uid)
                                              .set({
                                            "email": value.email,
                                            "name": _nameController.text,
                                          });
                                          setState(() {
                                            isLoading = true;
                                          });
                                          Future.delayed(
                                              const Duration(seconds: 3));
                                          setState(() {
                                            isLoading = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  duration:
                                                      Duration(seconds: 4),
                                                  elevation: 0,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 16,
                                                      horizontal: 12),
                                                  shape: StadiumBorder(),
                                                  backgroundColor: Colors.green,
                                                  content: Text(
                                                    "Registration Successful! Please login!",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                    textAlign: TextAlign.center,
                                                  )));
                                          Get.to(() => const LoginScreen());
                                        } else if (_passwordController
                                                .text.length <
                                            6) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  duration:
                                                      Duration(seconds: 4),
                                                  elevation: 0,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 16,
                                                      horizontal: 12),
                                                  shape: StadiumBorder(),
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  content: Text(
                                                    "Your password needs to be at least 6 characters long!",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                    textAlign: TextAlign.center,
                                                  )));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  duration:
                                                      Duration(seconds: 4),
                                                  elevation: 0,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 16,
                                                      horizontal: 12),
                                                  shape: StadiumBorder(),
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  content: Text(
                                                    "This email is already in use. Please use another one.",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                    textAlign: TextAlign.center,
                                                  )));
                                        }
                                      });
                                    },
                                    icon: isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.black,
                                          )
                                        : const Icon(
                                            Icons.arrow_forward,
                                          )),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.to(() => const LoginScreen());
                                },
                                child: Text(
                                  'Sign In',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.caveat(
                                    textStyle: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Color(0xFF1EAE98),
                                        fontSize: 24),
                                  ),
                                ),
                                style: const ButtonStyle(),
                              ),
                            ],
                          )
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
