import 'package:effort_craft/main.dart';
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

  Future signOut() async {
    try {
      return await FirebaseAuth.instance.signOut();
    } catch (e) {
      e.toString();
      return null;
    }
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
        appBar: AppBarFb2(
          onTap: signOut,
        ),
        bottomNavigationBar: const BottomNavBarRaisedInsetFb1(),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.only(left: 9, bottom: 2),
                  color: const Color(0xFF393E46),
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  child: Text(
                    'Tasks',
                    style: TextStyle(
                        color: Colors.cyan[400]?.withOpacity(0.9),
                        fontSize: 35),
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              height: 330,
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
                          title: '${data.docs[index]['title']}',
                          body: '${data.docs[index]['task']}',
                          check: () {},
                          delete: () {},
                        );
                      });
                },
              ),
            ),
          ],
        ));
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
  final Function() check;
  final Function() delete;

  const InfoCard(
      {required this.title,
      required this.body,
      required this.check,
      required this.delete,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 150,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(18.0),
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
                    fontSize: 20,
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
                    onTap: check,
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
                    onTap: delete,
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
                color: const Color(0xFF393E46).withOpacity(.85), fontSize: 20),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

class AppBarFb2 extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final Function() onTap;

  AppBarFb2({Key? key, required this.onTap})
      : preferredSize = const Size.fromHeight(56.0),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF393E46);

    return AppBar(
      title: const Text("Effortcraft",
          style: TextStyle(
            color: Color(0xff903749),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          )),
      backgroundColor: Colors.blueGrey.shade300,
      actions: [
        IconButton(
            icon: const Icon(
              Icons.logout,
              color: accentColor,
            ),
            onPressed: () {
              onTap();
              Get.to(() => const LoginScreen());
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 5),
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.symmetric(vertical: 16, horizontal: 80),
                  shape: StadiumBorder(),
                  backgroundColor: Color(0xFF1EAE98),
                  content: Text(
                    "Logout Successful!",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF393E46),
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )));
            })
      ],
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: accentColor,
        ),
        onPressed: () {
          Get.back();
        },
      ),
    );
  }
}
