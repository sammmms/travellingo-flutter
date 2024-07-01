import 'package:flutter/material.dart';

class OAuthButtonComponent extends StatelessWidget {
  final String content;
  const OAuthButtonComponent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surfaceTint,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      child: Image(
        image: AssetImage("assets/images/$content"),
        width: 20,
      ),
    );
  }
}
