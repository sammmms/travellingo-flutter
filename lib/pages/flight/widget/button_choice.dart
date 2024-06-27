import 'package:flutter/material.dart';

class ButtonChoice extends StatelessWidget {
  final Widget icon;
  final String content;
  final Function()? onPressed;
  const ButtonChoice(
      {super.key, required this.content, required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
          style: ButtonStyle(
              foregroundColor: const WidgetStatePropertyAll(Colors.white),
              backgroundColor: const WidgetStatePropertyAll(Colors.white),
              surfaceTintColor: const WidgetStatePropertyAll(Colors.white),
              elevation: const WidgetStatePropertyAll(0),
              padding: const WidgetStatePropertyAll(EdgeInsets.all(0)),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10.0),
              ))),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                icon,
                Text(
                  content,
                  style: const TextStyle(color: Color.fromRGBO(20, 21, 17, 1)),
                ),
              ],
            ),
          )),
    );
  }
}
