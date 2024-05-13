import 'package:flutter/material.dart';

class OAuthButtonComponent extends StatelessWidget {
  final String content;
  const OAuthButtonComponent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Image(
        image: AssetImage("assets/$content"),
        width: 20,
      ),
    );
  }
}
