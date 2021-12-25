import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:effort_craft/auth/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTaskScreen extends StatefulWidget {
  final UserAttributes? user;

  const AddTaskScreen({Key? key, this.user}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
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

  Future addTask(title, task) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference todos = users.doc(user?.uid).collection('todos');

    if (task != null && task != "" && title != null && title != "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 5),
          elevation: 5,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical: 35, horizontal: 12),
          shape: StadiumBorder(),
          backgroundColor: Color(0xFF1EAE98),
          content: Text(
            "The task succesfully added to your list!",
            style: TextStyle(
                fontSize: 18,
                color: Color(0xFF393E46),
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )));

      return todos.add(
        {"task": task, "title": title},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 3),
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical: 16, horizontal: 72),
          shape: StadiumBorder(),
          backgroundColor: Colors.redAccent,
          content: Text(
            "Fields cannot be empty!",
            style: TextStyle(
                fontSize: 18,
                color: Color(0xFF393E46),
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return getUserData();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = TextEditingController();
    TextEditingController _taskController = TextEditingController();

    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 35, right: 35),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(bottom: 22),
                        color: const Color(0xFF393E46),
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 56,
                        child: Text(
                          'Add a task',
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                color: Color(0xFF1EAE98), fontSize: 34),
                          ),
                        ),
                      )
                    ],
                  ),
                  TextField(
                      controller: _titleController,
                      cursorColor: const Color(0xff903749),
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          fillColor: const Color(0xFFFFD369).withOpacity(0.85),
                          filled: true,
                          hintText: "Title",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xff903749), width: 2.8)))),
                  const SizedBox(
                    height: 25,
                  ),
                  TextField(
                    controller: _taskController,
                    cursorColor: const Color(0xff903749),
                    maxLines: 5,
                    style: const TextStyle(),
                    decoration: InputDecoration(
                        fillColor: const Color(0xFFFFD369).withOpacity(0.85),
                        filled: true,
                        hintText: "Task",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color(0xff903749), width: 2.8))),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 27,
                        backgroundColor: const Color(0xFF1EAE98),
                        child: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            addTask(
                                _titleController.text, _taskController.text);
                          },
                          icon: const Icon(
                            Icons.add,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
