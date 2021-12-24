import 'package:flutter/material.dart';

class CardFb14 extends StatelessWidget {
  final String text;
  final String image;
  final String subtitle;
  final Function() onPressed;

  const CardFb14(
      {required this.text,
      required this.image,
      required this.subtitle,
      required this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 150,
        height: 150,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.green.shade200,
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
          children: [
            Image(image: AssetImage(image), height: 59, fit: BoxFit.cover),
            const SizedBox(
              height: 10,
            ),
            Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF393E46),
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                )),
            const SizedBox(
              height: 3,
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xff903749),
                  fontWeight: FontWeight.w900,
                  fontSize: 20),
            ),
            const SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    );
  }
}
