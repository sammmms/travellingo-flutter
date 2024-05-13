import 'package:flutter/cupertino.dart';
import 'package:flutter_localization/flutter_localization.dart';

class LabelHeading extends StatelessWidget {
  final Icon icon;
  final String content;
  const LabelHeading({super.key, required this.icon, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(
          width: 10,
        ),
        Text(
          content.getString(context),
          style: const TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
