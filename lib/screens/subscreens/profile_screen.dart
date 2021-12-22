import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../components/info_card.dart';

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

  Future<void> getUserData() async {
    var userData = FirebaseAuth.instance.currentUser;
    setState(() {
      user = userData;
    });
  }

  Future<void> addTask(title, task) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference todos = users.doc(user?.uid).collection('todos');

    return todos.add({"task": task, "title": title});
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
              padding: const EdgeInsets.only(left: 16, bottom: 7),
              color: const Color(0xFF393E46),
              width: MediaQuery.of(context).size.width,
              height: 56,
              child: const Text(
                'Tasks',
                style: TextStyle(color: Color(0xFF1EAE98), fontSize: 27),
              ),
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
                  });
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
                          for (var i = 0; i < data.size; i++) {
                            if (i + index <= data.size + 3 &&
                                i + index >= 3 &&
                                index != 7) {
                              return Container(
                                  color: Colors.white.withOpacity(0.1),
                                  child: const Image(
                                    image:
                                        AssetImage("assets/items/diamond.png"),
                                  ));
                            } else {
                              return Container(
                                  color: Colors.white.withOpacity(0.1),
                                  child: Container());
                            }
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
