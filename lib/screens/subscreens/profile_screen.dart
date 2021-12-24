import 'package:effort_craft/components/user_info_card.dart';
import 'package:effort_craft/components/user_profile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;

  const ProfileScreen({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;

  late String name;

  Future<void> getUserData() async {
    var userData = FirebaseAuth.instance.currentUser;

    setState(() {
      user = userData;
    });
  }

  getUserInfo() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((ds) {
      name = ds.get("name");
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

    CollectionReference todos = users.doc(user?.uid).collection('todos');
    CollectionReference completed =
        users.doc(user?.uid).collection('completed');

    final Stream<QuerySnapshot> todosStream = todos.snapshots();
    final Stream<QuerySnapshot> completedStream = completed.snapshots();
    final Stream<QuerySnapshot> totalTasksStream = totalTasks.snapshots();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: Get.height * 0.05,
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: const Color(0xFF393E46),
                  height: 250,
                  width: 50,
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
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          color: const Color(0xFF393E46),
                          child: LoadingAnimationWidget.halfTringleDot(
                              color: const Color(0xFFFFD369), size: 90),
                        );
                      }
                      final data = snapshot.requireData;

                      return SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: GridView.builder(
                            itemCount: 4,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 15,
                                    crossAxisSpacing: 15,
                                    crossAxisCount: 1),
                            itemBuilder: (BuildContext context, int index) {
                              if (data.size < 5) {
                                return Container(
                                    padding: const EdgeInsets.all(8.0),
                                    color: Colors.white.withOpacity(0.1),
                                    child: const Image(
                                      alignment: Alignment.center,
                                      image:
                                          AssetImage("assets/items/helmet.png"),
                                    ));
                              } else if (data.size == 5) {
                                return Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: Colors.yellow.withOpacity(0.5),
                                  child: const Image(
                                    alignment: Alignment.center,
                                    image:
                                        AssetImage("assets/items/helmet.png"),
                                  ),
                                );
                              } else if (data.size > 5 && data.size < 13) {
                                return Container(
                                    padding: const EdgeInsets.all(8.0),
                                    color: Colors.white.withOpacity(0.1),
                                    child: const Image(
                                      alignment: Alignment.center,
                                      image: AssetImage(
                                          "assets/items/chestplate.png"),
                                    ));
                              } else if (data.size == 13) {
                                return Container(
                                    padding: const EdgeInsets.all(8.0),
                                    color: Colors.yellow.withOpacity(0.5),
                                    child: const Image(
                                      alignment: Alignment.center,
                                      image: AssetImage(
                                          "assets/items/chestplate.png"),
                                    ));
                              }

                              return Container();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                  height: Get.height * 3.9 / 12,
                  width: Get.width * 0.47,
                  color: const Color(0xFF393E46),
                  child: FutureBuilder(
                    future: getUserInfo(),
                    builder: (context, snapshot) {
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

                      return Center(
                          child: CardFb11(
                        image: "assets/steve.png",
                        text: name,
                        onPressed: () {},
                      ));
                    },
                  ),
                ),
                Container(
                  color: const Color(0xFF393E46),
                  height: 250,
                  width: 50,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: completedStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong.');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 16),
                          height: 20,
                          width: MediaQuery.of(context).size.width,
                          color: const Color(0xFF393E46),
                          child: LoadingAnimationWidget.halfTringleDot(
                              color: const Color(0xFFFFD369), size: 20),
                        );
                      }
                      return SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: GridView.builder(
                            itemCount: 2,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 137.5,
                                    crossAxisSpacing: 15,
                                    crossAxisCount: 1),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: Colors.white.withOpacity(0.1),
                                  child: const Image(
                                    alignment: Alignment.center,
                                    image:
                                        AssetImage("assets/items/helmet.png"),
                                  ));
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              height: Get.height * 1.3 / 12,
              width: Get.width,
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
                      child: CardFb12(
                    image: "assets/steve.png",
                    text: "Total Effort: ${data.size.toString()}",
                    onPressed: () {},
                    color: const Color(0xFFFFD369),
                  ));
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              height: Get.height * 1.3 / 12,
              width: Get.width,
              color: const Color(0xFF393E46),
              child: StreamBuilder<QuerySnapshot>(
                stream: todosStream,
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
                      child: CardFb12(
                    image: "assets/steve.png",
                    text: "Active Todos: ${data.size.toString()}",
                    onPressed: () {},
                    color: const Color(0xffFFAFAF).withOpacity(0.8),
                  ));
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              height: Get.height * 1.3 / 12,
              width: Get.width,
              color: const Color(0xFF393E46),
              child: StreamBuilder<QuerySnapshot>(
                stream: completedStream,
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
                      child: CardFb12(
                    image: "assets/steve.png",
                    text: "Completed: ${data.size.toString()}",
                    onPressed: () {},
                    color: Colors.blueGrey.shade300,
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
