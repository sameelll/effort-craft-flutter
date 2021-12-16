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
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoginScreen());
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
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
          // const Text(
          //   'Login to Your App',
          //   style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 32.0,
          //       fontWeight: FontWeight.bold),
          // ),
          const SizedBox(
            height: 34,
          ),
          const TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                hintText: 'user email',
                prefixIcon: Icon(
                  Icons.mail,
                  color: Colors.black,
                )),
          ),
          const SizedBox(
            height: 26,
          ),
          const TextField(
            obscureText: true,
            decoration: InputDecoration(
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
              onPressed: () {},
              child: const Text('Login'),
            ),
          )
        ],
      ),
    );
  }
}
