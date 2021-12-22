import 'package:flutter/material.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

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
                    height: 4,
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
