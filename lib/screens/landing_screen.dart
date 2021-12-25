import 'package:effort_craft/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
                      child: Text('Effortcraft',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color:
                                    const Color(0xFFFFD369).withOpacity(0.85),
                                fontSize: 45,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    SizedBox(
                      child: Text(
                        'Reflect Your Effort!',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              color: const Color(0xFF7CD1B8).withOpacity(0.9),
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 450,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color(0xFF16222A).withOpacity(0.9).withRed(30),
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        alignment: Alignment.center,
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.only(
                                right: 27, left: 27, top: 5, bottom: 5)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        )),
                    onPressed: () {
                      Get.to(() => const LoginScreen());
                    },
                    child: Text(
                      "Start",
                      style: TextStyle(
                          color: const Color(0xFFFFD369).withOpacity(0.90),
                          fontWeight: FontWeight.bold,
                          fontSize: 26),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 3,
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
