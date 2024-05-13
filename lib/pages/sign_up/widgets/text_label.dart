import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class TextLabel extends StatelessWidget {
  final String content;
  const TextLabel({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content.getString(context),
      style: const TextStyle(
        fontSize: 10,
        letterSpacing: 1.1,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1B1446),
      ),
      textScaler: const TextScaler.linear(1.1),
    );
  }
}
