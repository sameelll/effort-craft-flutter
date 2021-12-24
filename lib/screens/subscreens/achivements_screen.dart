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
                style: GoogleFonts.caveat(
                  textStyle:
                      const TextStyle(color: Color(0xFF1EAE98), fontSize: 34),
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
                  late int level;

                  if (data.size <= 5) {
                    dataPercent = data.size / 5;
                    level = 1;
                  } else if (data.size > 5 && data.size <= 13) {
                    dataPercent = (data.size - 5) / 8;
                    level = 2;
                  } else if (data.size > 13 && data.size <= 20) {
                    level = 3;
                    dataPercent = (data.size - 13) / 7;
                  } else if (data.size > 20 && data.size <= 24) {
                    level = 4;
                    dataPercent = (data.size - 20) / 4;
                  } else if (data.size > 24 && data.size <= 40) {
                    level = 5;
                    dataPercent = (data.size - 24) / 16;
                  }

                  return CircularPercentIndicator(
                    radius: 120.0,
                    lineWidth: 13.0,
                    animation: true,
                    percent: dataPercent,
                    center: Text(
                      "${dataPercent * 100}%",
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
                    child: Text(data.size.toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CustomCarouselFB2 extends StatefulWidget {
  const CustomCarouselFB2({Key? key}) : super(key: key);

  @override
  _CustomCarouselFB2State createState() => _CustomCarouselFB2State();
}

class _CustomCarouselFB2State extends State<CustomCarouselFB2> {
  List<Widget> cards = [
    CardFb1(
        text: "Diamond Helmet",
        image: "assets/items/helmet.png",
        subtitle: "5 Effort",
        onPressed: () {}),
    CardFb1(
        text: "Diamond Chestplate",
        image: "assets/items/chestplate.png",
        subtitle: "13 Effort",
        onPressed: () {}),
    CardFb1(
        text: "Diamond Leggings",
        image: "assets/items/leggings.png",
        subtitle: "20 Effort",
        onPressed: () {}),
    CardFb1(
        text: "Diamond Boots",
        image: "assets/items/boots.png",
        subtitle: "24 Effort",
        onPressed: () {}),
    CardFb1(
        text: "Diamond Sword",
        image: "assets/items/sword.png",
        subtitle: "40 Effort",
        onPressed: () {})
  ];

  final double carouselItemMargin = 16;

  late PageController _pageController;
  // ignore: unused_field
  int _position = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: .7);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: _pageController,
        itemCount: cards.length,
        onPageChanged: (int position) {
          setState(() {
            _position = position;
          });
        },
        itemBuilder: (BuildContext context, int position) {
          return imageSlider(position);
        });
  }

  Widget imageSlider(int position) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, widget) {
        return Container(
          margin: EdgeInsets.all(carouselItemMargin),
          child: Center(child: widget),
        );
      },
      child: Container(
        child: cards[position],
      ),
    );
  }
}

class CardFb1 extends StatelessWidget {
  final String text;
  final String image;
  final String subtitle;
  final Function() onPressed;

  const CardFb1(
      {required this.text,
      required this.image,
      required this.subtitle,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 250,
        height: 230,
        padding: const EdgeInsets.all(25.4),
        decoration: BoxDecoration(
          color: const Color(0xFFFFD369).withOpacity(0.9),
          borderRadius: BorderRadius.circular(12.5),
          boxShadow: [
            BoxShadow(
                offset: const Offset(10, 20),
                blurRadius: 10,
                spreadRadius: 0,
                color: Colors.grey.withOpacity(.05)),
          ],
        ),
        child: Column(
          children: [
            Image(image: AssetImage(image), height: 90, fit: BoxFit.cover),
            const Spacer(),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                )),
            const SizedBox(
              height: 5,
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xff903749),
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
