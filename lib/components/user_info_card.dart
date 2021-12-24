import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardFb12 extends StatelessWidget {
  final String text;
  final String image;
  final Function() onPressed;
  final Color color;

  const CardFb12(
      {required this.text,
      required this.image,
      required this.onPressed,
      required this.color,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: Get.width * 0.8,
        height: Get.height * 0.8,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: color,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF393E46),
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                )),
          ],
        ),
      ),
    );
  }
}
