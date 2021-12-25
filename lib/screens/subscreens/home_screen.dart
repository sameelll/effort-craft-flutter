import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../components/info_card.dart';

class HomeScreen extends StatefulWidget {
  final User? user;

  const HomeScreen({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;

  Future<void> getUserData() async {
    var userData = FirebaseAuth.instance.currentUser;
    setState(() {
      user = userData;
    });
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> checkTask(title, task) {
    CollectionReference completed =
        users.doc(user?.uid).collection('completed');

    CollectionReference totalTasks =
        users.doc(user?.uid).collection('totalTasks');

    totalTasks.add({"total": title});

    return completed.add({
      "task": task,
      "title": title,
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
    CollectionReference todos = users.doc(user?.uid).collection('todos');
    CollectionReference completed =
        users.doc(user?.uid).collection('completed');
    final Stream<QuerySnapshot> todosStream = todos.snapshots();
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
              child: Text('Tasks',
                  style: GoogleFonts.caveat(
                    textStyle:
                        const TextStyle(color: Color(0xFF1EAE98), fontSize: 38),
                  )),
            )
          ],
        ),
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          height: 320,
          color: const Color(0xFF393E46),
          child: StreamBuilder<QuerySnapshot>(
            stream: todosStream,
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
                    return InfoCard(
                      title: '${data.docs[index]['title']}',
                      body: '${data.docs[index]['task']}',
                      check: () {
                        checkTask('${data.docs[index]['title']}',
                            '${data.docs[index]['task']}');
                        data.docs[index].reference.delete();
                      },
                      delete: () {
                        data.docs[index].reference.delete();
                      },
                    );
                  },
                );
              }
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    width: 200,
                    height: 200,
                    child: Image(
                      image: AssetImage("assets/creeper.png"),
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
                            'Your shulker seems empty.\nPlease add some tasks!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.caveat(
                              textStyle: TextStyle(
                                color: const Color(0xFFFFD369).withOpacity(0.9),
                                fontSize: 30,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 12.475, left: 16, right: 6),
              height: 230.9,
              width: MediaQuery.of(context).size.width / 2,
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
                      height: 230.9,
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
                        itemCount: 9,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 15,
                                crossAxisSpacing: 15,
                                crossAxisCount: 3),
                        itemBuilder: (BuildContext context, int index) {
                          for (var i = 1; i <= data.size; i++) {
                            if (data.size <= 5) {
                              if (index < data.size + 3 &&
                                      index != 7 &&
                                      i + index >= 4 ||
                                  (data.size == 5 && index == 8)) {
                                return Container(
                                  color: Colors.white.withOpacity(0.1),
                                  child: const Image(
                                    image:
                                        AssetImage("assets/items/diamond.png"),
                                  ),
                                );
                              } else {
                                return Container(
                                  color: Colors.white.withOpacity(0.1),
                                  child: Container(),
                                );
                              }
                            } else if (data.size > 5 && data.size <= 13) {
                              if (index <= data.size - 5 && index != 1) {
                                return Container(
                                  color: Colors.white.withOpacity(0.1),
                                  child: const Image(
                                    image:
                                        AssetImage("assets/items/diamond.png"),
                                  ),
                                );
                              } else {
                                return Container(
                                  color: Colors.white.withOpacity(0.1),
                                  child: Container(),
                                );
                              }
                            } else if (data.size > 13 && data.size <= 20) {
                              if (index < data.size - 13 &&
                                      index != 7 &&
                                      index != 4 ||
                                  (data.size == 18 && index == 5) ||
                                  (data.size == 19 && index == 6) ||
                                  (data.size == 20 && index == 8)) {
                                return Container(
                                  color: Colors.white.withOpacity(0.1),
                                  child: const Image(
                                    image:
                                        AssetImage("assets/items/diamond.png"),
                                  ),
                                );
                              } else {
                                return Container(
                                  color: Colors.white.withOpacity(0.1),
                                  child: Container(),
                                );
                              }
                            } else if (data.size > 20 && data.size <= 24) {
                              if (index < data.size - 16 &&
                                      i + index >= 4 &&
                                      (index != 7 && index != 4) ||
                                  (data.size == 24 && index == 8)) {
                                return Container(
                                  color: Colors.white.withOpacity(0.1),
                                  child: const Image(
                                    image:
                                        AssetImage("assets/items/diamond.png"),
                                  ),
                                );
                              } else {
                                return Container(
                                  color: Colors.white.withOpacity(0.1),
                                  child: Container(),
                                );
                              }
                            } else if (data.size > 24 && data.size <= 40) {
                              if ((index < (data.size - 24)) &&
                                      i + index >= 2 &&
                                      index != 2 &&
                                      index != 3 &&
                                      index != 5 &&
                                      index != 6 &&
                                      index != 7 &&
                                      index != 8 ||
                                  (data.size == 25 && index == 1) ||
                                  (data.size >= 27 && index == 4) ||
                                  (data.size == 26 && index == 4)) {
                                return Container(
                                  color: Colors.white.withOpacity(0.1),
                                  child: const Image(
                                    image:
                                        AssetImage("assets/items/diamond.png"),
                                  ),
                                );
                              } else {
                                return Container(
                                  color: Colors.white.withOpacity(0.1),
                                  child: Container(),
                                );
                              }
                            }
                            if ((data.size == 40) &&
                                index < data.size - 36 &&
                                index == 7) {
                              return Container(
                                color: Colors.white.withOpacity(0.1),
                                child: const Image(
                                  image: AssetImage("assets/items/stick.png"),
                                ),
                              );
                            }
                          }
                          return Container(
                            color: Colors.white.withOpacity(0.1),
                            child: Container(),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 29, left: 9, right: 10),
              color: const Color(0xFF393E46),
              height: 230.9,
              child: const Icon(
                Icons.arrow_right_alt,
                size: 45,
                color: Color(0xFF1EAE98),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 47.475, left: 16, right: 16),
              color: const Color(0xFF393E46),
              height: 230.9,
              width: 132.362,
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
                      height: 230.9,
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
                        itemCount: 1,
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
                                  image: AssetImage("assets/items/helmet.png"),
                                ));
                          } else if (data.size == 5) {
                            return Container(
                              padding: const EdgeInsets.all(8.0),
                              color: Colors.yellow.withOpacity(0.5),
                              child: const Image(
                                alignment: Alignment.center,
                                image: AssetImage("assets/items/helmet.png"),
                              ),
                            );
                          } else if (data.size > 5 && data.size < 13) {
                            return Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.white.withOpacity(0.1),
                                child: const Image(
                                  alignment: Alignment.center,
                                  image:
                                      AssetImage("assets/items/chestplate.png"),
                                ));
                          } else if (data.size == 13) {
                            return Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.yellow.withOpacity(0.5),
                                child: const Image(
                                  alignment: Alignment.center,
                                  image:
                                      AssetImage("assets/items/chestplate.png"),
                                ));
                          } else if (data.size > 13 && data.size < 20) {
                            return Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.white.withOpacity(0.1),
                                child: const Image(
                                  alignment: Alignment.center,
                                  image:
                                      AssetImage("assets/items/leggings.png"),
                                ));
                          } else if (data.size == 20) {
                            return Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.yellow.withOpacity(0.5),
                                child: const Image(
                                  alignment: Alignment.center,
                                  image:
                                      AssetImage("assets/items/leggings.png"),
                                ));
                          } else if (data.size > 20 && data.size < 24) {
                            return Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.white.withOpacity(0.1),
                                child: const Image(
                                  alignment: Alignment.center,
                                  image: AssetImage("assets/items/boots.png"),
                                ));
                          } else if (data.size == 24) {
                            return Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.yellow.withOpacity(0.5),
                                child: const Image(
                                  alignment: Alignment.center,
                                  image: AssetImage("assets/items/boots.png"),
                                ));
                          } else if (data.size > 24 && data.size < 40) {
                            return Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.white.withOpacity(0.1),
                                child: const Image(
                                  alignment: Alignment.center,
                                  image: AssetImage("assets/items/sword.png"),
                                ));
                          } else if (data.size == 40) {
                            return Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.yellow.withOpacity(0.5),
                                child: const Image(
                                  alignment: Alignment.center,
                                  image: AssetImage("assets/items/sword.png"),
                                ));
                          } else if (data.size > 40 && data.size < 50) {
                            return Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.white.withOpacity(0.1),
                                child: const Image(
                                  alignment: Alignment.center,
                                  image: AssetImage("assets/items/torch.png"),
                                ));
                          } else if (data.size == 50) {
                            return Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.yellow.withOpacity(0.5),
                                child: const Image(
                                  alignment: Alignment.center,
                                  image: AssetImage("assets/items/torch.png"),
                                ));
                          }

                          return Container();
                        },
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
