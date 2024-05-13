import 'package:flutter/material.dart';

class ButtonChoice extends StatelessWidget {
  final Widget icon;
  final String content;
  const ButtonChoice({super.key, required this.content, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
          style: ButtonStyle(
              foregroundColor: const MaterialStatePropertyAll(Colors.white),
              backgroundColor: const MaterialStatePropertyAll(Colors.white),
              surfaceTintColor: const MaterialStatePropertyAll(Colors.white),
              elevation: const MaterialStatePropertyAll(0),
              padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade300, width: 1),
                borderRadius: BorderRadius.circular(10.0),
              ))),
          onPressed: () {},
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
