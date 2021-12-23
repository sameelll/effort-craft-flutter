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
                          style: GoogleFonts.caveat(
                            textStyle: TextStyle(
                                color:
                                    const Color(0xFFFFD369).withOpacity(0.85),
                                fontSize: 63,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    SizedBox(
                      child: Text(
                        'Reflect Your Effort!',
                        style: GoogleFonts.caveat(
                          textStyle: TextStyle(
                              color: const Color(0xFF7CD1B8).withOpacity(0.9),
                              fontSize: 21,
                              fontWeight: FontWeight.bold),
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
                height: 350,
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
                        color: const Color(0xFFFFD369),
                        child: Text("Start",
                            style: GoogleFonts.caveat(
                              textStyle: const TextStyle(
                                  color: Color(0xFF105652),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30.0),
                            )),
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
