import 'dart:async';

import 'package:effort_craft/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

void main() {
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

// Create the main layout(UI)

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          return const LoginScreen();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ));
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int activeIndex = 0;

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        activeIndex++;

        if (activeIndex == 4) {
          activeIndex = 0;
        }
      });
    });
    super.initState();
  }

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
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("No user found")));
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    // Creating the textfield controller
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            height: 350,
            child: Stack(children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedOpacity(
                  opacity: activeIndex == 0 ? 1 : 0,
                  duration: const Duration(
                    seconds: 1,
                  ),
                  curve: Curves.linear,
                  child: Image.network(
                    'https://freepngimg.com/thumb/minecraft/5-2-minecraft-enderman-png.png',
                    height: 400,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedOpacity(
                  opacity: activeIndex == 1 ? 1 : 0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.linear,
                  child: Image.network(
                    'https://pngimg.com/uploads/minecraft/minecraft_PNG94.png',
                    height: 400,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedOpacity(
                  opacity: activeIndex == 2 ? 1 : 0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.linear,
                  child: Image.network(
                    'https://pngimg.com/uploads/minecraft/minecraft_PNG47.png',
                    height: 400,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedOpacity(
                  opacity: activeIndex == 3 ? 1 : 0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.linear,
                  child: Image.network(
                    'https://pngimg.com/uploads/minecraft/minecraft_PNG71.png',
                    height: 400,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedOpacity(
                  opacity: activeIndex == 3 ? 1 : 0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.linear,
                  child: Image.network(
                    'https://pngimg.com/uploads/minecraft/minecraft_PNG48.png',
                    height: 400,
                  ),
                ),
              )
            ]),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _emailController,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0.0),
              labelText: 'Email',
              hintText: 'Username or e-mail',
              labelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
              prefixIcon: const Icon(
                Iconsax.user,
                color: Colors.black,
                size: 18,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                borderRadius: BorderRadius.circular(10.0),
              ),
              floatingLabelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          const SizedBox(
            height: 26,
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(0.0),
              labelText: 'Password',
              hintText: 'Password',
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
              labelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: const Icon(
                Iconsax.key,
                color: Colors.black,
                size: 18,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
                borderRadius: BorderRadius.circular(10.0),
              ),
              floatingLabelStyle: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
            onPressed: () async {
              User? user = await loginUsingEmailPassword(
                  email: _emailController.text,
                  password: _passwordController.text,
                  context: context);
              if (user != null) {
                Get.to(() => const ProfileScreen());
              }
            },
            height: 45,
            color: Colors.black,
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account?',
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Register',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
        ],
      ),
    )));
  }
}
