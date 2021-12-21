import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;

  const ProfileScreen({Key? key, this.user}) : super(key: key);

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

  final TextEditingController _taskController = TextEditingController();

  Future<void> addTask(task) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference todos = users.doc(user?.uid).collection('todos');

    // Call the user's CollectionReference to add a new user
    return todos.add({"task": task});
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
    final Stream<QuerySnapshot> todosStream = todos.snapshots();

    return Scaffold(
        bottomNavigationBar: const BottomNavBarRaisedInsetFb1(),
        body: Container(
            padding: const EdgeInsets.all(16.0),
            height: MediaQuery.of(context).size.height,
            color: const Color(0xFF393E46),
            child: StreamBuilder<QuerySnapshot>(
              stream: todosStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong.');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                }

                final data = snapshot.requireData;

                return ListView.builder(
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      return InfoCard(
                        title: '${data.docs[index]['task']}',
                        onMoreTap: () {},
                      );
                    });
              },
            )));
    // Column(
    //   children: [
    //     // Row(
    //     //   children: [
    //     //     const Text(
    //     //       'Achivements',
    //     //       style: TextStyle(
    //     //           fontSize: 30,
    //     //           color: Color(0xFF1EAE98),
    //     //           fontWeight: FontWeight.w700),
    //     //     ),
    //     //     // Adding flex
    //     //     Expanded(
    //     //       child: Container(),
    //     //     ),
    //     //     const Icon(Icons.info_outline_rounded,
    //     //         size: 22, color: Color(0xFF1EAE98)),
    //     //   ],
    //     // ),
    //     // ElevatedButton(
    //     //     onPressed: () {
    //     //       addTask(_taskController.text);
    //     //     },
    //     //     child: const Text("dana")),
    //     // TextField(
    //     //     controller: _taskController,
    //     //     style: const TextStyle(color: Colors.black),
    //     //     decoration: InputDecoration(
    //     //         fillColor: Colors.grey.shade300,
    //     //         filled: true,
    //     //         hintText: "Enter the task",
    //     //         border: OutlineInputBorder(
    //     //             borderRadius: BorderRadius.circular(10)),
    //     //         focusedBorder: OutlineInputBorder(
    //     //             borderRadius: BorderRadius.circular(10),
    //     //             borderSide: const BorderSide(
    //     //                 color: Colors.green, width: 2.8)))),
    //     Container(
    // child: ,
    //     )
    //   ],
    // ));
  }
}

class BottomNavBarRaisedInsetFb1 extends StatefulWidget {
  const BottomNavBarRaisedInsetFb1({Key? key}) : super(key: key);

  @override
  _BottomNavBarRaisedInsetFb1State createState() =>
      _BottomNavBarRaisedInsetFb1State();
}

class _BottomNavBarRaisedInsetFb1State
    extends State<BottomNavBarRaisedInsetFb1> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = 56;

    const primaryColor = Color(0xFF393E46);
    const secondaryColor = Colors.black54;
    // const accentColor = const Color(0xffffffff);

    const shadowColor = Colors.grey; //color of Navbar shadow
    double elevation = 100; //Elevation of the bottom Navbar

    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(size.width, height),
            painter: BottomNavCurvePainter(
                backgroundColor: Colors.blueGrey.shade300,
                shadowColor: shadowColor,
                elevation: elevation),
          ),
          Center(
            heightFactor: 0.6,
            child: FloatingActionButton(
                backgroundColor: primaryColor,
                child: const Icon(
                  Icons.add,
                  size: 30,
                  color: Color(0xFF1EAE98),
                ),
                elevation: 0.1,
                onPressed: () {}),
          ),
          SizedBox(
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavBarIcon(
                  text: "Home",
                  icon: Icons.home_filled,
                  selected: true,
                  onPressed: () {
                    Get.to(() => const ProfileScreen());
                  },
                  defaultColor: secondaryColor,
                  selectedColor: const Color(0xff903749),
                ),
                NavBarIcon(
                  text: "Search",
                  icon: Icons.search_outlined,
                  selected: false,
                  onPressed: () {},
                  defaultColor: secondaryColor,
                  selectedColor: const Color(0xff903749),
                ),
                const SizedBox(width: 56),
                NavBarIcon(
                    text: "Cart",
                    icon: Icons.emoji_events,
                    selected: false,
                    onPressed: () {},
                    defaultColor: secondaryColor,
                    selectedColor: const Color(0xff903749)),
                NavBarIcon(
                  text: "Calendar",
                  icon: Icons.date_range_outlined,
                  selected: false,
                  onPressed: () {},
                  defaultColor: secondaryColor,
                  selectedColor: const Color(0xff903749),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavCurvePainter extends CustomPainter {
  BottomNavCurvePainter(
      {this.backgroundColor = Colors.white,
      this.insetRadius = 38,
      this.shadowColor = Colors.grey,
      this.elevation = 100});

  Color backgroundColor;
  Color shadowColor;
  double elevation;
  double insetRadius;
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    Path path = Path();

    double insetCurveBeginnningX = size.width / 2 - insetRadius;
    double insetCurveEndX = size.width / 2 + insetRadius;

    path.lineTo(insetCurveBeginnningX, 0);
    path.arcToPoint(Offset(insetCurveEndX, 0),
        radius: const Radius.circular(41), clockwise: true);

    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height + 56);
    path.lineTo(
        0,
        size.height +
            56); //+56 here extends the navbar below app bar to include extra space on some screens (iphone 11)
    canvas.drawShadow(path, shadowColor, elevation, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class NavBarIcon extends StatelessWidget {
  const NavBarIcon(
      {Key? key,
      required this.text,
      required this.icon,
      required this.selected,
      required this.onPressed,
      this.selectedColor = const Color(0xffFF8527),
      this.defaultColor = Colors.black54})
      : super(key: key);
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;
  final Color defaultColor;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(
            icon,
            size: 25,
            color: selected ? selectedColor : defaultColor,
          ),
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String body;
  final Function() onMoreTap;

  const InfoCard(
      {required this.title,
      this.body =
          """Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia, molestiae quas vel sint commodi repudi conseqr!""",
      required this.onMoreTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(25.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              offset: const Offset(0, 10),
              blurRadius: 0,
              spreadRadius: 0,
            )
          ],
          color: Colors.blueGrey.shade200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: Color(0xFF393E46),
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Container(),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: const Color(0xFF393E46)),
                child: GestureDetector(
                    onTap: onMoreTap,
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: Color(0xFF1EAE98),
                      ),
                    )),
              ),
              const SizedBox(width: 4),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: const Color(0xFF393E46)),
                child: GestureDetector(
                    onTap: onMoreTap,
                    child: const Center(
                      child: Icon(
                        Icons.delete,
                        color: Color(0xffE05D5D),
                      ),
                    )),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: TextStyle(
                color: const Color(0xFF393E46).withOpacity(.85), fontSize: 15),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
