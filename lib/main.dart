import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:effort_craft/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Initialize forestore
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('users').snapshots();
  // Initialize firebase app
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: _initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const ProfileScreen();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/landing_dark.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5, color: Colors.red.withOpacity(0.0))
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: Text(
                        'Effortcraft',
                        style: TextStyle(
                            color: Colors.cyan[400],
                            fontSize: 45,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    SizedBox(
                      child: Text(
                        'Reflect Your Effort!',
                        style: TextStyle(
                          color: Colors.red[100],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.07,
              ),
              Container(
                height: 380,
              ),
              Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                      height: 50,
                      width: 112,
                      decoration: BoxDecoration(
                        color: const Color(0xffebebeb).withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30)),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          Get.to(() => const LoginScreen());
                        },
                        height: 50,
                        color: Colors.grey[100]?.withOpacity(0.9),
                        child: const Text(
                          "Start",
                          style: TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 23.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 2),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30)),
                        ),
                      ),
                    )
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Login Function
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {}
    }
    return user;
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Creating the textfield controller
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

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
              Get.to(() => const HomeScreen());
            },
          ),
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 172),
              child: Text(
                'Welcome\nBack',
                style: TextStyle(color: Colors.cyan[200], fontSize: 30),
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
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.cyan[200],
                                      fontSize: 16),
                                ),
                                style: const ButtonStyle(),
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.cyan[200],
                                      fontSize: 16,
                                    ),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 268,
                              ),
                              CircleAvatar(
                                radius: 27,
                                backgroundColor:
                                    Colors.green[700]?.withOpacity(0.9),
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: () async {
                                    User? user = await loginUsingEmailPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        context: context);
                                    if (user != null) {
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
                                              elevation: 0,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 16,
                                                  horizontal: 110),
                                              shape: StadiumBorder(),
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                "Welcome Back!",
                                                style: TextStyle(fontSize: 18),
                                                textAlign: TextAlign.center,
                                              )));
                                      Get.to(() => const ProfileScreen());
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
                                          color: Colors.white,
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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  static Future<User?> signUpUsingEmailPassword(
      {required String email,
      required String name,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {}
    }
    return user;
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _nameController = TextEditingController();

    CollectionReference users = FirebaseFirestore.instance.collection('users');

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
              Get.to(() => const HomeScreen());
            },
          ),
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 30),
              child: Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.cyan[200], fontSize: 33),
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
                                style: TextStyle(
                                    color: Colors.cyan[200],
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 27,
                                backgroundColor: Colors.yellow[400],
                                child: IconButton(
                                    color: Colors.black,
                                    onPressed: () async {
                                      User? user =
                                          await signUpUsingEmailPassword(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                              context: context,
                                              name: _nameController.text);

                                      if (user != null) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await Future.delayed(
                                            const Duration(seconds: 3));
                                        setState(() {
                                          isLoading = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                duration: Duration(seconds: 4),
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
                                        await users.add({
                                          'email': _emailController.text,
                                          'name': _nameController.text,
                                        });
                                        Get.to(() => const LoginScreen());
                                      } else if (_passwordController
                                              .text.length <
                                          6) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                duration: Duration(seconds: 4),
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
                                                duration: Duration(seconds: 4),
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
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.cyan[200],
                                      fontSize: 18),
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
