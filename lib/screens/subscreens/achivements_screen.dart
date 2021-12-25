import 'package:effort_craft/components/carousel.dart';
import 'package:effort_craft/components/total_efforts_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AchivementsScreen extends StatefulWidget {
  final User? user;

  const AchivementsScreen({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  _AchivementsScreenState createState() => _AchivementsScreenState();
}

class _AchivementsScreenState extends State<AchivementsScreen> {
  User? user;

  Future<void> getUserData() async {
    var userData = FirebaseAuth.instance.currentUser;
    setState(() {
      user = userData;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference totalTasks =
        users.doc(user?.uid).collection('totalTasks');
    final Stream<QuerySnapshot> totalTasksStream = totalTasks.snapshots();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.only(left: 16),
              color: const Color(0xFF393E46),
              width: MediaQuery.of(context).size.width,
              height: 56,
              child: Text(
                'Achivements',
                style: GoogleFonts.lato(
                  textStyle:
                      const TextStyle(color: Color(0xFF1EAE98), fontSize: 30),
                ),
              ),
            )
          ],
        ),
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
          height: Get.height * 4.8 / 12,
          color: const Color(0xFF393E46),
          child: StreamBuilder<QuerySnapshot>(
            stream: totalTasksStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong.');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  height: 320,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xFF393E46),
                  child: LoadingAnimationWidget.halfTringleDot(
                      color: const Color(0xFFFFD369), size: 90),
                );
              }

              // ignore: unused_local_variable
              final data = snapshot.requireData;

              return const CustomCarouselFB2();
            },
          ),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              height: Get.height * 2.8 / 12,
              width: Get.width / 2,
              color: const Color(0xFF393E46),
              child: StreamBuilder<QuerySnapshot>(
                stream: totalTasksStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong.');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      height: 320,
                      width: MediaQuery.of(context).size.width,
                      color: const Color(0xFF393E46),
                      child: LoadingAnimationWidget.halfTringleDot(
                          color: const Color(0xFFFFD369), size: 90),
                    );
                  }

                  final data = snapshot.requireData;

                  late double dataPercent;
                  late String level;

                  if (data.size <= 5) {
                    dataPercent = data.size / 5;
                    level = 1.toString();
                  } else if (data.size > 5 && data.size <= 13) {
                    dataPercent = (data.size - 5) / 8;
                    level = 2.toString();
                  } else if (data.size > 13 && data.size <= 20) {
                    level = 3.toString();
                    dataPercent = (data.size - 13) / 7;
                  } else if (data.size > 20 && data.size <= 24) {
                    level = 4.toString();
                    dataPercent = (data.size - 20) / 4;
                  } else if (data.size > 24 && data.size <= 40) {
                    level = 5.toString();
                    dataPercent = (data.size - 24) / 16;
                  } else {
                    level = "Full";
                    dataPercent = 1;
                  }

                  return CircularPercentIndicator(
                    radius: 120.0,
                    lineWidth: 13.0,
                    animation: true,
                    percent: dataPercent,
                    center: Text(
                      "${(double.parse((dataPercent * 100).toStringAsFixed(2)))}%",
                      style: const TextStyle(
                          color: Color(0xFF1EAE98),
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    footer: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Level ${level.toString()}',
                        style: const TextStyle(
                            color: Color(0xFF1EAE98),
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: const Color(0xffF05454),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              height: Get.height * 2.8 / 12,
              width: Get.width / 2,
              color: const Color(0xFF393E46),
              child: StreamBuilder<QuerySnapshot>(
                stream: totalTasksStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong.');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      height: 320,
                      width: MediaQuery.of(context).size.width,
                      color: const Color(0xFF393E46),
                      child: LoadingAnimationWidget.halfTringleDot(
                          color: const Color(0xFFFFD369), size: 90),
                    );
                  }

                  final data = snapshot.requireData;

                  return Center(
                      child: CardFb14(
                    image: "assets/steve.png",
                    text: "Total Efforts",
                    subtitle: data.size.toString(),
                    onPressed: () {},
                  ));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
