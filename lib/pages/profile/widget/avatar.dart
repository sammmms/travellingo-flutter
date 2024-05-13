import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class BorderedAvatar extends StatelessWidget {
  final String? content;
  const BorderedAvatar({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(90),
        child: Badge(
            alignment: Alignment.bottomRight,
            smallSize: 34,
            backgroundColor: Colors.yellow,
            label: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            largeSize: 30,
            child: DottedBorder(
              strokeWidth: 3,
              color: const Color(0xFFF6F8FB),
              dashPattern: const [9, 7],
              borderType: BorderType.Circle,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFFF6F8FB),
                  child: content != ""
                      ? Image.memory(base64Decode(content!))
                      : null,
                ),
              ),
            )),
      ),
    );
  }
}
