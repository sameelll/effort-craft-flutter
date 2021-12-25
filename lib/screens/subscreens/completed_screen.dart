import 'package:effort_craft/components/completed_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CompletedScreen extends StatefulWidget {
  final User? user;

  const CompletedScreen({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  _CompletedScreenState createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  User? user;

  Future<void> getUserData() async {
    var userData = FirebaseAuth.instance.currentUser;
    setState(() {
      user = userData;
    });
  }

  Future<void> checkTask(title, task) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference completed =
        users.doc(user?.uid).collection('completed');

    return completed.add({"task": task, "title": title});
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference completed =
        users.doc(user?.uid).collection('completed');
    final Stream<QuerySnapshot> completedStream = completed.snapshots();

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
                'Your Effort',
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
          height: Get.height * 7.8 / 12,
          color: const Color(0xFF393E46),
          child: StreamBuilder<QuerySnapshot>(
            stream: completedStream,
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

              if (data.size > 0) {
                return ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    return CompletedCard(
                      title: '${data.docs[index]['title']}',
                      body: '${data.docs[index]['task']}',
                      delete: () {
                        data.docs[index].reference.delete();
                      },
                    );
                  },
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 250,
                    height: 250,
                    child: Image(
                      image: AssetImage("assets/skeleton.png"),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        color: const Color(0xFF393E46),
                        width: 300,
                        height: 74,
                        child: Text(
                            "You haven't completed a task yet.\nPlease make effort!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.caveat(
                              textStyle: TextStyle(
                                color: const Color(0xFFFFD369).withOpacity(0.9),
                                fontSize: 20,
                              ),
                            )),
                      )
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
