import 'package:flutter/material.dart';

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
