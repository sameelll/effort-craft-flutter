import 'package:effort_craft/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
        print("No user found");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    // Creating the textfield controller
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Image.asset('assets/dragon-logo.png'),
          ),
          const SizedBox(
            height: 10,
          ),
          Text('Effortcraft',
              style: TextStyle(
                  color: Colors.red[600],
                  fontSize: 38.0,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 34,
          ),
          TextField(
            controller: _emailController,
            cursorColor: Colors.black,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintText: 'user email',
                prefixIcon: Icon(
                  Icons.mail,
                  color: Colors.black,
                )),
          ),
          const SizedBox(
            height: 26,
          ),
          TextField(
            controller: _passwordController,
            cursorColor: Colors.black,
            obscureText: true,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
                hintText: 'user password',
                prefixIcon: Icon(
                  Icons.vpn_key_rounded,
                  color: Colors.black,
                )),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "Don't remember your password?",
            style: TextStyle(
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(
            height: 66,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.0),
                color: Colors.red[600]),
            child: MaterialButton(
              onPressed: () async {
                User? user = await loginUsingEmailPassword(
                    email: _emailController.text,
                    password: _passwordController.text,
                    context: context);
                if (user != null) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
                }
              },
              child: const Text('Login'),
            ),
          )
        ],
      ),
    );
  }
}
